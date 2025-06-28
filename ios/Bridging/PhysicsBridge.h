#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhysicsBridge : NSObject
+ (void)initializePhysics;
+ (void)stepSimulation:(float)timeStep;
+ (void)shutdownPhysics;
@end

NS_ASSUME_NONNULL_END
