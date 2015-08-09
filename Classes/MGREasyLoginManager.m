//
//  MGREasyLoginManager.h
//  MGREasyLogin
//
//  Created by ilya.imlove@gmail.com on 08.08.15.
//  Copyright (c) 2015 magora-systems.com. All rights reserved.
//

#import "MGREasyLoginManager.h"
#import "MGREasyLoginUser.h"
#import "MGREasyLoginTwitterAccountsStore.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <TwitterKit/TwitterKit.h>
#import <Fabric/Fabric.h>

#define BLOCK_SAFE_RUN(block, ...) block ? block(__VA_ARGS__) : nil

@interface MGREasyLoginManager ()

@property (strong, nonatomic) NSMutableDictionary *permissions;
@property (strong, nonatomic) MGREasyLoginTwitterAccountsStore *twitterSystemAccountsStore;

@end

static MGREasyLoginManager * kEasyLoginManager = nil;

@implementation MGREasyLoginManager

#pragma mark - LifeCycle

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kEasyLoginManager = [[[self class] allocWithZone:NULL] init];
        [kEasyLoginManager configureFacebook];
        [kEasyLoginManager configureTwitter];
    });
    
    return kEasyLoginManager;
}

+ (instancetype)alloc {
    return [self sharedManager];
}

- (instancetype)init {
    if (kEasyLoginManager != nil) {
        return kEasyLoginManager;
    }
    return [super init];
}

#pragma mark - lazy

- (MGREasyLoginTwitterAccountsStore *)twitterSystemAccountsStore {
    if (_twitterSystemAccountsStore == nil) {
        _twitterSystemAccountsStore = [[MGREasyLoginTwitterAccountsStore alloc] init];
    }
    return _twitterSystemAccountsStore;
}

- (NSMutableDictionary *)permissions {
    if (_permissions == nil) {
        _permissions = [NSMutableDictionary new];
    }
    return _permissions;
}

#pragma mark - Private methods

- (void) configureFacebook {
    [self setPermissions:@[@"email", @"public_profile"] forNetworkWithType:MGREasyLoginNetworkTypeFacebook];
}

- (void) configureTwitter {
    [Fabric with:@[TwitterKit]];
}

- (NSArray*)permissionsForNetworkWithType:(MGREasyLoginNetworkType)type {
    return [self.permissions objectForKey:@(type)];
}

#pragma mark - Facebook

- (void)loadUserProfileFromFacebookWithTokenString:(NSString*)tokenString success:(MGRSocialNetworkLoginSuccess)success failed:(MGRSocialNetworkLogoutFailed)failed {
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"name, first_name, last_name, picture, email"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (error == nil && result != nil) {
            MGREasyLoginUser *user = [[MGREasyLoginUser alloc] initWithFacebookResult:result token:tokenString];
            BLOCK_SAFE_RUN(success,user,MGREasyLoginCacheTypeServer);
        } else {
            BLOCK_SAFE_RUN(failed,error);
        }
    }];
}

- (void)userFromFacebookWithSuccess:(MGRSocialNetworkLoginSuccess)success failed:(MGRSocialNetworkLogoutFailed)failed {
    FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
    if (token == nil) {
        NSArray *permissions = [self permissionsForNetworkWithType:MGREasyLoginNetworkTypeFacebook];
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:permissions handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error != nil) {
                BLOCK_SAFE_RUN(failed,error);
            } else if (result.isCancelled) {
                BLOCK_SAFE_RUN(failed,[NSError errorWithDomain:@"result is cancelled" code:0 userInfo:nil]);
            } else if (result.token == nil) {
                BLOCK_SAFE_RUN(failed,[NSError errorWithDomain:@"token is nil" code:0 userInfo:nil]);
            } else {
                [self loadUserProfileFromFacebookWithTokenString:result.token.tokenString success:success failed:failed];
            }
        }];
    } else if ([[token expirationDate] compare:[NSDate date]] == NSOrderedAscending){
        [FBSDKAccessToken refreshCurrentAccessToken:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (error == nil) {
                [self loadUserProfileFromFacebookWithTokenString:token.tokenString success:success failed:failed];
            } else {
                BLOCK_SAFE_RUN(failed,error);
            }
        }];
    } else {
        [self loadUserProfileFromFacebookWithTokenString:token.tokenString success:success failed:failed];
    }
}

#pragma mark - Twitter

- (void)userFromTwitterWithSuccess:(MGRSocialNetworkLoginSuccess)success failed:(MGRSocialNetworkLogoutFailed)failed {

    void(^logIn)(MGRSocialNetworkLoginSuccess, MGRSocialNetworkLogoutFailed) = ^void(MGRSocialNetworkLoginSuccess successBlock, MGRSocialNetworkLogoutFailed failedBlock){
        [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
            if (error == nil && session != nil) {
                [[[Twitter sharedInstance] APIClient] loadUserWithID:[session userID] completion:^(TWTRUser *twUser, NSError *error) {
                    MGREasyLoginUser *user = [[MGREasyLoginUser alloc] initWithTwitterUser:twUser session:session];
                    BLOCK_SAFE_RUN(successBlock,user,MGREasyLoginCacheTypeServer);
                }];
            } else {
                BLOCK_SAFE_RUN(failedBlock,error);
            }
        }];
    };
    
    if ([[Twitter sharedInstance] session] == nil) {
        __weak typeof(self) wSelf = self;
        [self.twitterSystemAccountsStore loadSystemTwitterAccountsWithResult:^(BOOL granted, NSArray *accounts) {
            if (granted && accounts.count == 1) {
                [wSelf.twitterSystemAccountsStore showSelectionAccountViewWithResult:^(ACAccount *account) {
                    if (account != nil) {
                        logIn(success,failed);
                    } else {
                        BLOCK_SAFE_RUN(failed,nil);
                    }
                }];
            } else {
                logIn(success,failed);
            }
        }];
    } else {
        logIn(success,failed);
    }
}

#pragma mark - Public methods

- (void)setPermissions:(NSArray *)permissions forNetworkWithType:(MGREasyLoginNetworkType)type {
    [self.permissions setObject:permissions forKey:@(type)];
}

- (void)userWithNetworkType:(MGREasyLoginNetworkType)type
                    success:(MGRSocialNetworkLoginSuccess)success
                     failed:(MGRSocialNetworkLogoutFailed)failed {

    if (type == MGREasyLoginNetworkTypeFacebook) {
        [self userFromFacebookWithSuccess:success failed:failed];
    } else if (type == MGREasyLoginNetworkTypeTwitter) {
        [self userFromTwitterWithSuccess:success failed:failed];
    }
}

- (void)logoutAllWithSuccess:(MGRSocialNetworkLogoutSuccess)success
                      failed:(MGRSocialNetworkLogoutFailed)failed {
    @try {
        [FBSDKAccessToken setCurrentAccessToken: nil];
        [[Twitter sharedInstance] logOut];
        BLOCK_SAFE_RUN(success);
    }
    @catch (NSException *exception) {
        BLOCK_SAFE_RUN(failed,[NSError errorWithDomain:exception.description code:0 userInfo:exception.userInfo]);
    }
}


- (void)logoutUserWithNetworkType:(MGREasyLoginNetworkType)type
                          success:(MGRSocialNetworkLogoutSuccess)success
                           failed:(MGRSocialNetworkLogoutFailed)failed {
    @try {
        if (type == MGREasyLoginNetworkTypeFacebook) {
            [FBSDKAccessToken setCurrentAccessToken: nil];
        } else if (type == MGREasyLoginNetworkTypeTwitter) {
            [[Twitter sharedInstance] logOut];
        }
        BLOCK_SAFE_RUN(success);
    }
    @catch (NSException *exception) {
        BLOCK_SAFE_RUN(failed,[NSError errorWithDomain:exception.description code:0 userInfo:exception.userInfo]);
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];

}

+ (void)activateApp {
    [FBSDKAppEvents activateApp];
}

@end

