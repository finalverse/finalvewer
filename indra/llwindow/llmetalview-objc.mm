#import "llmetalview-objc.h"

@implementation LLMetalView
- (id)initWithFrame:(NSRect)frame
              device:(id<MTLDevice>)device
        commandQueue:(id<MTLCommandQueue>)queue
{
    self = [super initWithFrame:frame device:device];
    if (self)
    {
        self.preferredFramesPerSecond = 60;
        self.framebufferOnly = YES;
        self.paused = NO;
        self.enableSetNeedsDisplay = NO;
        self.commandQueue = queue;
    }
    return self;
}
@end
