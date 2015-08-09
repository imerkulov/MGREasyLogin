//
//  MGREasyLoginManager.h
//  MGREasyLogin
//
//  Created by ilya.imlove@gmail.com on 08.08.15.
//  Copyright (c) 2015 magora-systems.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MGREasyLoginUser.h"
#import "MGREasyLoginButton.h"

typedef NS_ENUM(NSUInteger, MGREasyLoginNetworkType) {
    MGREasyLoginNetworkTypeFacebook = 0,
    MGREasyLoginNetworkTypeTwitter
};

typedef NS_ENUM(NSUInteger, MGREasyLoginCacheType) {
    MGREasyLoginCacheTypeServer = 0,
    MGREasyLoginCacheTypeLocal
};

typedef void (^MGRSocialNetworkLogoutSuccess)();
typedef void (^MGRSocialNetworkLogoutFailed)(NSError *error);

typedef void (^MGRSocialNetworkLoginSuccess)(MGREasyLoginUser *user, MGREasyLoginCacheType cacheType);
typedef void (^MGRSocialNetworkLoginFailed)(NSError *error);

@interface MGREasyLoginManager : NSObject

+ (instancetype)sharedManager;

- (void)setPermissions:(NSArray *)permissions forNetworkWithType:(MGREasyLoginNetworkType)type;

- (void)userWithNetworkType:(MGREasyLoginNetworkType)type
                    success:(MGRSocialNetworkLoginSuccess)success
                     failed:(MGRSocialNetworkLogoutFailed)failed;

- (void)logoutAllWithSuccess:(MGRSocialNetworkLogoutSuccess)success
                      failed:(MGRSocialNetworkLogoutFailed)failed;

- (void)logoutUserWithNetworkType:(MGREasyLoginNetworkType)type
                          success:(MGRSocialNetworkLogoutSuccess)success
                           failed:(MGRSocialNetworkLogoutFailed)failed;

/* FACEBOOK SDK */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

+ (void)activateApp;

@end