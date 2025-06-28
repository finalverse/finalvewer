/** 
 * @file 
 * @brief 
 *
 * $LicenseInfo:firstyear=2025&license=fsviewerlgpl$
 * Finalviewer Viewer Source Code
 * Copyright (C) 2025, The Finalviewer Project, Inc.
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation;
 * version 2.1 of the License only.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 * 
 * The Finalviewer Project, Inc., 1831 Oakwood Drive, Fairmont, Minnesota 56031-3225 USA
 * http://www.finalviewer.org
 * $/LicenseInfo$
 */


#import "ViewerBridge.h"

@implementation ViewerBridge

+ (void)constructViewer {
    ios_construct_viewer();
}

+ (BOOL)initViewer {
    return ios_init_viewer();
}

+ (BOOL)pumpFrame {
    return ios_pump_frame();
}

+ (void)handleURL:(NSString *)url {
    ios_handle_url([url UTF8String]);
}

+ (void)quit {
    ios_quit();
}

+ (void)cleanupViewer {
    ios_cleanup_viewer();
}

@end

