#import "PhysicsBridge.h"
#import "../../indra/newview/llphysicsios-objc.h"

@implementation PhysicsBridge

+ (void)initializePhysics {
    ios_physics_initialize();
}

+ (void)stepSimulation:(float)timeStep {
    ios_physics_step(timeStep);
}

+ (void)shutdownPhysics {
    ios_physics_shutdown();
}

@end
