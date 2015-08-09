//
//  MGREasyLoginButton.h
//  MGREasyLogin
//
//  Created by ilya.imlove@gmail.com on 08.08.15.
//  Copyright (c) 2015 magora-systems.com. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const MGREasyLoginFacebookLoginStartNotification;
extern NSString *const MGREasyLoginFacebookLoginSuccessNotification;
extern NSString *const MGREasyLoginFacebookLoginErrorNotification;

extern NSString *const MGREasyLoginTwitterLoginStartNotification;
extern NSString *const MGREasyLoginTwitterLoginSuccessNotification;
extern NSString *const MGREasyLoginTwitterLoginErrorNotification;

@interface MGREasyLoginBaseButton : UIButton

@end

@interface MGREasyLoginFacebookButton : MGREasyLoginBaseButton

@end

@interface MGREasyLoginTwitterButton : MGREasyLoginBaseButton

@end