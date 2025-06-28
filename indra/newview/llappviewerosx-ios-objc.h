#ifndef LL_LLAPPVIEWERIOS_OBJC_H
#define LL_LLAPPVIEWERIOS_OBJC_H

#ifdef __cplusplus
extern "C" {
#endif

void ios_construct_viewer(void);
bool ios_init_viewer(void);
bool ios_pump_frame(void);
void ios_handle_url(const char* url_utf8);
void ios_quit(void);
void ios_cleanup_viewer(void);

#ifdef __cplusplus
}
#endif

#endif // LL_LLAPPVIEWERIOS_OBJC_H
