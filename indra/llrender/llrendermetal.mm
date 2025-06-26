#include "llrendermetal.h"

#if LL_METAL
bool LLRenderMetal::init(bool needs_vertex_buffer)
{
    return LLRender::init(needs_vertex_buffer);
}

void LLRenderMetal::shutdown()
{
}
#endif
