//
//  ViewController.m
//  MGREasyLogin
//
//  Created by ilya.imlove@gmail.com on 08.08.15.
//  Copyright (c) 2015 magora-systems.com. All rights reserved.
//

#import "ViewController.h"

#import "MGREasyLogin.h"

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNotifications];
    
//    [self signInFacebook];
//    [self signInTwitter];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
    [[MGREasyLoginManager sharedManager] setPermissions:@[@"email", @"public_profile"] forNetworkWithType:MGREasyLoginNetworkTypeFacebook];
}

- (void)configureNotifications {
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(facebookLoginStart:)
                                                 name:MGREasyLoginFacebookLoginStartNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(facebookLoginSuccess:)
                                                 name:MGREasyLoginFacebookLoginSuccessNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(facebookLoginError:)
                                                 name:MGREasyLoginFacebookLoginErrorNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(twitterLoginStart:)
                                                 name:MGREasyLoginTwitterLoginStartNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(twitterLoginSuccess:)
                                                 name:MGREasyLoginTwitterLoginSuccessNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(twitterLoginError:)
                                                 name:MGREasyLoginTwitterLoginErrorNotification
                                               object:nil];
}

#pragma mark - Facebook

- (void)facebookLoginStart:(NSNotification*)notification {
    NSLog(@"%s", __func__);
}

- (void)facebookLoginSuccess:(NSNotification*)notification {
    MGREasyLoginUser *user = [notification object];
    [self showAlertForUser:user];
    NSLog(@"%s: %@", __func__,user);
}

- (void)facebookLoginError:(NSNotification*)notification {
    NSError *error = [notification object];
    [self showAlertForError:error];
    NSLog(@"%s: %@", __func__,error);
}

#pragma mark - Twitter

- (void)twitterLoginStart:(NSNotification*)notification {
    NSLog(@"%s", __func__);
}
- (void)twitterLoginSuccess:(NSNotification*)notification {
    MGREasyLoginUser *user = [notification object];
    [self showAlertForUser:user];
    NSLog(@"%s: %@", __func__,user);
}

- (void)twitterLoginError:(NSNotification*)notification {
    NSError *error = [notification object];
    [self showAlertForError:error];
    NSLog(@"%s: %@", __func__,error);
}

#pragma mark -

- (void)signInFacebook {
    [[MGREasyLoginManager sharedManager] userWithNetworkType:MGREasyLoginNetworkTypeFacebook success:^(MGREasyLoginUser *user, MGREasyLoginCacheType cacheType) {
        NSLog(@"user: %@", user);
    } failed:^(NSError *error) {
        NSLog(@"error: %@", error.description);
    }];
}

- (void)signInTwitter {
    [[MGREasyLoginManager sharedManager] userWithNetworkType:MGREasyLoginNetworkTypeTwitter success:^(MGREasyLoginUser *user, MGREasyLoginCacheType cacheType) {
        NSLog(@"user: %@", user);
    } failed:^(NSError *error) {
        NSLog(@"error: %@", error.description);
    }];
}

- (void)showAlertForUser:(MGREasyLoginUser*)user {
    NSString *message = [NSString stringWithFormat:@"userID: %@ \nuserName: %@ \ntoken: %@",user.userID, user.userName, user.token];
    [[[UIAlertView alloc] initWithTitle:@"The user" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];;
}

- (void)showAlertForError:(NSError*)error {
    [[[UIAlertView alloc] initWithTitle:@"Error:" message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];;
}

#pragma mark - IBAction

- (IBAction)logout:(id)sender {
    [[MGREasyLoginManager sharedManager] logoutAllWithSuccess:^{
        NSLog(@"logout succes");
    } failed:^(NSError *error) {
        NSLog(@"logout failed");
    }];
}

@end
