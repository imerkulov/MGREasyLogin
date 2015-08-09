//
//  MGREasyLoginTwitterAccountsStore.h
//  MGREasyLogin
//
//  Created by ilya.imlove@gmail.com on 08.08.15.
//  Copyright (c) 2015 magora-systems.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACAccount;

typedef void(^MGREasyLoginLoadSystemTwitterAccountsHandler)(BOOL granted, NSArray *accounts);
typedef void(^MGREasyLoginSelectSystemTwitterAccountsHandler)(ACAccount *account);

@interface MGREasyLoginTwitterAccountsStore : NSObject

- (void)loadSystemTwitterAccountsWithResult:(MGREasyLoginLoadSystemTwitterAccountsHandler)result;
- (void)showSelectionAccountViewWithResult:(MGREasyLoginSelectSystemTwitterAccountsHandler)result;

@end