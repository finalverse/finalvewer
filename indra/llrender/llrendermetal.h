#ifndef LL_LLRENDERMETAL_H
#define LL_LLRENDERMETAL_H

#include "llrender.h"

#if LL_METAL
class LLRenderMetal : public LLRender
{
public:
    bool init(bool needs_vertex_buffer) override;
    void shutdown() override;
};
#endif

#endif
