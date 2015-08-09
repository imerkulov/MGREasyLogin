//
//  MGREasyLoginUser.h
//  MGREasyLogin
//
//  Created by ilya.imlove@gmail.com on 08.08.15.
//  Copyright (c) 2015 magora-systems.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TWTRUser, TWTRSession;

@interface MGREasyLoginUser : NSObject

@property (copy, nonatomic, readonly) NSString *token;
@property (copy, nonatomic, readonly) NSString *userID;
@property (copy, nonatomic, readonly) NSString *userName;
@property (copy, nonatomic, readonly) NSString *firstName;
@property (copy, nonatomic, readonly) NSString *lastName;
@property (copy, nonatomic, readonly) NSString *email;
@property (copy, nonatomic, readonly) NSURL *photoURL;


- (instancetype)initWithFacebookResult:(NSDictionary*)result token:(NSString*)tokenString;
- (instancetype)initWithTwitterUser:(TWTRUser*)user session:(TWTRSession*)session;

@end