#include "llappviewerosx-ios-objc.h"
#include "llappviewermacosx-for-objc.h"

void ios_construct_viewer(void)
{
    constructViewer();
}

bool ios_init_viewer(void)
{
    return initViewer();
}

bool ios_pump_frame(void)
{
    return pumpMainLoop();
}

void ios_handle_url(const char* url_utf8)
{
    handleUrl(url_utf8);
}

void ios_quit(void)
{
    handleQuit();
}

void ios_cleanup_viewer(void)
{
    cleanupViewer();
}
