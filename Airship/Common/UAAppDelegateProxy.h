/*
 Copyright 2009-2015 Urban Airship Inc. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC ``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL URBAN AIRSHIP INC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>
#import "UAGlobal.h"

/**
 * This class is designed to take the place of the default application delegate and forward messages
 * to both a surrogate delegate and the original delegate. This is useful for intercepting messages
 * sent to the app delegate that do not have corresponding NSNotificationCenter events (such as 
 * application:didReceiveRemoteNotification: and other APNS-related calls).
 *
 * @note Delegates are typically not retained, but in this case we will take responsibility for them
 * as we're essentially a man in the middle and we don't want to lose them.
 */
@interface UAAppDelegateProxy : NSProxy<UIApplicationDelegate>

//NSProxy has no default init method, we have to declare it to satisfy the compiler
- (instancetype)init;

/**
 * The Urban Airship app delegate. 
 */
@property (nonatomic, strong) NSObject<UIApplicationDelegate> *airshipAppDelegate;

/**
 * The original app delegate.
 */
@property (nonatomic, strong) NSObject<UIApplicationDelegate> *originalAppDelegate;

@end
