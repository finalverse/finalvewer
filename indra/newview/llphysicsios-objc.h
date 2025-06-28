#ifndef LL_LLPHYSICS_IOS_OBJC_H
#define LL_LLPHYSICS_IOS_OBJC_H

#ifdef __cplusplus
extern "C" {
#endif

void ios_physics_initialize(void);
void ios_physics_step(float dt);
void ios_physics_shutdown(void);

#ifdef __cplusplus
}
#endif

#endif // LL_LLPHYSICS_IOS_OBJC_H
