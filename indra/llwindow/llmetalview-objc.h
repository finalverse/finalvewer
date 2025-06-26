#ifndef LLMetalView_H
#define LLMetalView_H

#import <Cocoa/Cocoa.h>
#import <MetalKit/MetalKit.h>

@interface LLMetalView : MTKView

@property(nonatomic, strong) id<MTLCommandQueue> commandQueue;

- (instancetype)initWithFrame:(NSRect)frame
                        device:(id<MTLDevice>)device
                  commandQueue:(id<MTLCommandQueue>)queue;

@end

#endif
