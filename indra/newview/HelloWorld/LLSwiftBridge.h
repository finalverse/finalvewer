//
//  LLSwiftBridge.h
//  Finalviewer HelloWorld Bridge
//
//  Bridge header to expose Finalviewer C++ functionality to Swift
//

#ifndef LLSwiftBridge_h
#define LLSwiftBridge_h

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif

// Message System Bridge Functions
NS_ASSUME_NONNULL_BEGIN

// Initialize the Finalviewer message system
BOOL LLBridge_InitializeMessageSystem(void);

// Send a simple message to the backend server
BOOL LLBridge_SendMessage(NSString* messageName, NSDictionary* parameters);

// Get the last received message as a dictionary
NSDictionary* _Nullable LLBridge_GetLastReceivedMessage(void);

// Connect to OpenSim/MutSea server
BOOL LLBridge_ConnectToServer(NSString* serverURL, NSString* username, NSString* password);

// Disconnect from server
void LLBridge_Disconnect(void);

// Check connection status
BOOL LLBridge_IsConnected(void);

// Get agent information
NSDictionary* _Nullable LLBridge_GetAgentInfo(void);

// Common utility functions
NSString* LLBridge_GetViewerVersion(void);
NSString* LLBridge_GetGridName(void);

NS_ASSUME_NONNULL_END

#ifdef __cplusplus
}
#endif

#endif /* LLSwiftBridge_h */