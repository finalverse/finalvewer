#include "llphysicsios-objc.h"
#include "btBulletDynamicsCommon.h"

static btDiscreteDynamicsWorld* gWorld = nullptr;
static btBroadphaseInterface* gBroadphase = nullptr;
static btDefaultCollisionConfiguration* gCollisionConfig = nullptr;
static btCollisionDispatcher* gDispatcher = nullptr;
static btSequentialImpulseConstraintSolver* gSolver = nullptr;

void ios_physics_initialize(void)
{
    if (gWorld) return;
    gCollisionConfig = new btDefaultCollisionConfiguration();
    gDispatcher = new btCollisionDispatcher(gCollisionConfig);
    gBroadphase = new btDbvtBroadphase();
    gSolver = new btSequentialImpulseConstraintSolver();
    gWorld = new btDiscreteDynamicsWorld(gDispatcher, gBroadphase, gSolver, gCollisionConfig);
    gWorld->setGravity(btVector3(0.f, -9.81f, 0.f));
}

void ios_physics_step(float dt)
{
    if (gWorld)
    {
        gWorld->stepSimulation(dt);
    }
}

void ios_physics_shutdown(void)
{
    delete gWorld; gWorld = nullptr;
    delete gSolver; gSolver = nullptr;
    delete gBroadphase; gBroadphase = nullptr;
    delete gDispatcher; gDispatcher = nullptr;
    delete gCollisionConfig; gCollisionConfig = nullptr;
}
