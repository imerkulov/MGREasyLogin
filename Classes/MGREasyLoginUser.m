//
//  MGREasyLoginUser.m
//  MGREasyLogin
//
//  Created by ilya.imlove@gmail.com on 08.08.15.
//  Copyright (c) 2015 magora-systems.com. All rights reserved.
//

#import "MGREasyLoginUser.h"

#import <TwitterKit/TwitterKit.h>

@interface MGREasyLoginUser ()

@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *userID;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *lastName;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSURL *photoURL;

@end

@implementation MGREasyLoginUser

- (instancetype)initWithFacebookResult:(NSDictionary*)result token:(NSString*)tokenString {
    self = [super init];
    if (self) {
        self.token = tokenString;
        self.userID = result[@"id"];
        self.userName = result[@"name"];
        self.firstName = result[@"first_name"];
        self.lastName = result[@"last_name"];
        self.email = result[@"email"];
        NSDictionary *pict = result[@"picture"];
        if (pict != nil) {
            NSDictionary *data = pict[@"data"];
            if (data[@"url"] != nil) {
                self.photoURL = [NSURL URLWithString:data[@"url"]];
            }
        }
    }
    return self;
}

- (instancetype)initWithTwitterUser:(TWTRUser*)user session:(TWTRSession*)session {
    self = [super init];
    if (self) {
        self.token = session.authToken;
        self.userID = user.userID;
        self.userName = user.screenName;
        self.firstName = nil;
        self.lastName = nil;
        self.photoURL = [NSURL URLWithString:user.profileImageLargeURL];
    }
    return self;
}

@end