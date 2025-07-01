//
//  LLSwiftBridge.mm
//  Finalviewer HelloWorld Bridge
//
//  Implementation of the bridge between Swift and Finalviewer C++ code
//

#import "LLSwiftBridge.h"

// Include necessary Finalviewer headers
#include "llcommon.h"
#include "message.h"
#include "llviewernetwork.h"
#include "llversioninfo.h"
#include "llagent.h"
#include "llviewercontrol.h"
#include "llstartup.h"
#include "llappviewer.h"

// Message handler for capturing incoming messages
static NSDictionary* sLastReceivedMessage = nil;
static BOOL sIsInitialized = NO;

// Helper to setup directories and start the messaging system
static bool initMessagingSubsystem()
{
    static bool sInited = false;
    if (sInited)
    {
        return true;
    }

    LLCommon::initClass();

#if ADDRESS_SIZE == 64
    gDirUtilp->initAppDirs(APP_NAME + "_x64");
#else
    gDirUtilp->initAppDirs(APP_NAME);
#endif

    std::string template_path = gDirUtilp->getExpandedFilename(
        LL_PATH_APP_SETTINGS, "message_template.msg");

    const F32 heartbeat = 5.f;
    const F32 timeout = 100.f;
    const LLUseCircuitCodeResponder* responder = NULL;
    bool failure_is_fatal = true;

    if(!start_messaging_system(template_path,
                               0,
                               LLVersionInfo::instance().getMajor(),
                               LLVersionInfo::instance().getMinor(),
                               LLVersionInfo::instance().getPatch(),
                               false,
                               std::string(),
                               responder,
                               failure_is_fatal,
                               heartbeat,
                               timeout))
    {
        return false;
    }

    sInited = true;
    return true;
}

// Custom message handler class
class LLSwiftMessageHandler : public LLHTTPNode
{
public:
    virtual void post(LLHTTPNode::ResponsePtr response,
                     const LLSD& context,
                     const LLSD& input) const
    {
        // Convert LLSD to NSDictionary
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        
        // Extract message data
        for (LLSD::map_const_iterator it = input.beginMap(); 
             it != input.endMap(); ++it)
        {
            NSString* key = [NSString stringWithUTF8String:it->first.c_str()];
            
            // Convert LLSD value to appropriate NSObject
            if (it->second.isString())
            {
                dict[key] = [NSString stringWithUTF8String:it->second.asString().c_str()];
            }
            else if (it->second.isInteger())
            {
                dict[key] = @(it->second.asInteger());
            }
            else if (it->second.isReal())
            {
                dict[key] = @(it->second.asReal());
            }
            else if (it->second.isBoolean())
            {
                dict[key] = @(it->second.asBoolean());
            }
        }
        
        // Store the last received message
        sLastReceivedMessage = [dict copy];
        
        // Send response
        response->result(LLSD());
    }
};

// Initialize the message system
BOOL LLBridge_InitializeMessageSystem(void)
{
    @autoreleasepool {
        if (sIsInitialized) {
            return YES;
        }
        
        try {
            if (!initMessagingSubsystem()) {
                NSLog(@"Failed to initialize messaging subsystem");
                return NO;
            }

            sIsInitialized = YES;
            return YES;
        }
        catch (const std::exception& e) {
            NSLog(@"Failed to initialize message system: %s", e.what());
            return NO;
        }
    }
}

// Send a message to the backend server
BOOL LLBridge_SendMessage(NSString* messageName, NSDictionary* parameters)
{
    @autoreleasepool {
        if (!sIsInitialized || !gMessageSystem) {
            return NO;
        }
        
        try {
            // Start new message
            gMessageSystem->newMessage([messageName UTF8String]);
            
            // Add parameters
            for (NSString* key in parameters) {
                id value = parameters[key];
                
                if ([value isKindOfClass:[NSString class]]) {
                    gMessageSystem->addString([key UTF8String], 
                                            [(NSString*)value UTF8String]);
                }
                else if ([value isKindOfClass:[NSNumber class]]) {
                    NSNumber* num = (NSNumber*)value;
                    if (strcmp([num objCType], @encode(float)) == 0 ||
                        strcmp([num objCType], @encode(double)) == 0) {
                        gMessageSystem->addF32([key UTF8String], [num floatValue]);
                    }
                    else if (strcmp([num objCType], @encode(BOOL)) == 0) {
                        gMessageSystem->addBOOL([key UTF8String], [num boolValue]);
                    }
                    else {
                        gMessageSystem->addS32([key UTF8String], [num intValue]);
                    }
                }
            }
            
            // Send the message
            gMessageSystem->sendReliable(gAgent.getRegionHost());
            
            return YES;
        }
        catch (const std::exception& e) {
            NSLog(@"Failed to send message: %s", e.what());
            return NO;
        }
    }
}

// Get the last received message
NSDictionary* _Nullable LLBridge_GetLastReceivedMessage(void)
{
    return sLastReceivedMessage;
}

// Connect to OpenSim/MutSea server
BOOL LLBridge_ConnectToServer(NSString* serverURL, NSString* username, NSString* password)
{
    @autoreleasepool {
        if (!sIsInitialized) {
            if (!LLBridge_InitializeMessageSystem()) {
                return NO;
            }
        }
        
        try {
            // Set login credentials
            gSavedSettings.setString("FirstName", 
                                   [[username componentsSeparatedByString:@" "][0] UTF8String]);
            gSavedSettings.setString("LastName", 
                                   [[username componentsSeparatedByString:@" "][1] UTF8String]);
            
            // Note: In production, handle password more securely
            // This is a simplified example
            
            // Set grid
            LLGridManager::getInstance()->setGridChoice([serverURL UTF8String]);
            
            // Start login process
            LLStartUp::setStartupState(STATE_LOGIN_SHOW);
            
            return YES;
        }
        catch (const std::exception& e) {
            NSLog(@"Failed to connect to server: %s", e.what());
            return NO;
        }
    }
}

// Disconnect from server
void LLBridge_Disconnect(void)
{
    @autoreleasepool {
        if (gMessageSystem) {
            gMessageSystem->logoutRequest();
        }
    }
}

// Check connection status
BOOL LLBridge_IsConnected(void)
{
    return gMessageSystem && gMessageSystem->isConnected();
}

// Get agent information
NSDictionary* _Nullable LLBridge_GetAgentInfo(void)
{
    @autoreleasepool {
        if (!gAgent.isInitialized()) {
            return nil;
        }
        
        NSMutableDictionary* agentInfo = [NSMutableDictionary dictionary];
        
        // Get agent UUID
        agentInfo[@"agentID"] = [NSString stringWithUTF8String:gAgent.getID().asString().c_str()];
        
        // Get agent name
        std::string fullname = gAgent.getFullname();
        agentInfo[@"fullName"] = [NSString stringWithUTF8String:fullname.c_str()];
        
        // Get region info if available
        LLViewerRegion* region = gAgent.getRegion();
        if (region) {
            agentInfo[@"regionName"] = [NSString stringWithUTF8String:region->getName().c_str()];
            
            LLVector3 pos = gAgent.getPositionAgent();
            agentInfo[@"position"] = @{
                @"x": @(pos.mV[0]),
                @"y": @(pos.mV[1]),
                @"z": @(pos.mV[2])
            };
        }
        
        return [agentInfo copy];
    }
}

// Get viewer version
NSString* LLBridge_GetViewerVersion(void)
{
    @autoreleasepool {
        std::string version = LLVersionInfo::getInstance()->getVersion();
        return [NSString stringWithUTF8String:version.c_str()];
    }
}

// Get grid name
NSString* LLBridge_GetGridName(void)
{
    @autoreleasepool {
        std::string grid = LLGridManager::getInstance()->getGridLabel();
        return [NSString stringWithUTF8String:grid.c_str()];
    }
}
