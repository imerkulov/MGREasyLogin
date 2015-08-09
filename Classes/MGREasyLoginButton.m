//
//  MGREasyLoginButton.m
//  MGREasyLogin
//
//  Created by ilya.imlove@gmail.com on 08.08.15.
//  Copyright (c) 2015 magora-systems.com. All rights reserved.
//

#import "MGREasyLoginButton.h"
#import "MGREasyLoginManager.h"

NSString *const MGREasyLoginFacebookLoginStartNotification = @"MGREasyLoginFacebookLoginStartNotification";
NSString *const MGREasyLoginFacebookLoginSuccessNotification = @"MGREasyLoginFacebookLoginSuccessNotification";
NSString *const MGREasyLoginFacebookLoginErrorNotification = @"MGREasyLoginFacebookLoginErrorNotification";

NSString *const MGREasyLoginTwitterLoginStartNotification = @"MGREasyLoginTwitterLoginStartNotification";
NSString *const MGREasyLoginTwitterLoginSuccessNotification = @"MGREasyLoginTwitterLoginSuccessNotification";
NSString *const MGREasyLoginTwitterLoginErrorNotification = @"MGREasyLoginTwitterLoginErrorNotification";

@interface MGREasyLoginBaseButton ()

@property MGREasyLoginNetworkType socialNetworkType;

- (void)configureButton;
- (void)postLoginStartNotification;
- (void)postLoginSuccessNotificationWithUser:(MGREasyLoginUser*)user cacheType:(MGREasyLoginCacheType)cacheType;
- (void)postLoginErrorNotificationWithError:(NSError*)error;

@end

@implementation MGREasyLoginBaseButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureButton];    
    }
    return self;
}

- (void)awakeFromNib {
    [self configureButton];
    [super awakeFromNib];
}

- (void)configureButton {
    [self addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchUpInside {
    [self postLoginStartNotification];
    [[MGREasyLoginManager sharedManager] userWithNetworkType:self.socialNetworkType success:^(MGREasyLoginUser *user, MGREasyLoginCacheType cacheType) {
        [self postLoginSuccessNotificationWithUser:user cacheType:cacheType];
    } failed:^(NSError *error) {
        [self postLoginErrorNotificationWithError:error];
    }];
}

- (void)postLoginStartNotification {

}

- (void)postLoginSuccessNotificationWithUser:(MGREasyLoginUser*)user cacheType:(MGREasyLoginCacheType)cacheType {

}

- (void)postLoginErrorNotificationWithError:(NSError*)error {

}

@end

@implementation MGREasyLoginFacebookButton

- (void)configureButton {
    self.socialNetworkType = MGREasyLoginNetworkTypeFacebook;
    [super configureButton];
}

- (void)postLoginStartNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:MGREasyLoginFacebookLoginStartNotification object:nil];
}

- (void)postLoginSuccessNotificationWithUser:(MGREasyLoginUser*)user cacheType:(MGREasyLoginCacheType)cacheType {
    [[NSNotificationCenter defaultCenter] postNotificationName:MGREasyLoginFacebookLoginSuccessNotification
                                                        object:user
                                                      userInfo:@{@"cacheType": @(cacheType)}];
}

- (void)postLoginErrorNotificationWithError:(NSError*)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:MGREasyLoginFacebookLoginErrorNotification
                                                        object:error];
}

@end

@implementation MGREasyLoginTwitterButton

- (void)configureButton {
    self.socialNetworkType = MGREasyLoginNetworkTypeTwitter;
    [super configureButton];
}

- (void)postLoginStartNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:MGREasyLoginTwitterLoginStartNotification object:nil];
}

- (void)postLoginSuccessNotificationWithUser:(MGREasyLoginUser*)user cacheType:(MGREasyLoginCacheType)cacheType {
    [[NSNotificationCenter defaultCenter] postNotificationName:MGREasyLoginTwitterLoginSuccessNotification
                                                        object:user
                                                      userInfo:@{@"cacheType": @(cacheType)}];
}

- (void)postLoginErrorNotificationWithError:(NSError*)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:MGREasyLoginTwitterLoginErrorNotification
                                                        object:error];
}

@end
