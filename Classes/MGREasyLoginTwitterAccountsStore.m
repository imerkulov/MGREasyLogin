//
//  MGREasyLoginTwitterAccountsStore.m
//  MGREasyLogin
//
//  Created by ilya.imlove@gmail.com on 08.08.15.
//  Copyright (c) 2015 magora-systems.com. All rights reserved.
//

#import "MGREasyLoginTwitterAccountsStore.h"

#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface MGREasyLoginTwitterAccountsStore () <UIActionSheetDelegate>

@property (copy, nonatomic) NSArray *systemAccounts;
@property (copy, nonatomic) MGREasyLoginSelectSystemTwitterAccountsHandler actionSheetHandler;

@end

@implementation MGREasyLoginTwitterAccountsStore

- (void)loadSystemTwitterAccountsWithResult:(MGREasyLoginLoadSystemTwitterAccountsHandler)result {
    
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *type = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    __weak typeof(self) wSelf = self;
    [store requestAccessToAccountsWithType:type
                                   options:nil
                                completion:^(BOOL granted, NSError *error) {
                                                
                                                if (granted) {
                                                    wSelf.systemAccounts = [store accountsWithAccountType:type];
                                                    result(YES,wSelf.systemAccounts);
                                                } else {
                                                    result(NO,nil);
                                                }
                                            }];
}

- (void)showSelectionAccountViewWithResult:(MGREasyLoginSelectSystemTwitterAccountsHandler)result {
    
    self.actionSheetHandler = result;
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    for (ACAccount *account in self.systemAccounts) {
        [sheet addButtonWithTitle:[NSString stringWithFormat:@"@%@",account.username]];
    }
    [sheet addButtonWithTitle: @"Cancel"];
    [sheet setCancelButtonIndex:[self.systemAccounts count]];
    [sheet setDelegate:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        [sheet showInView: [[[UIApplication sharedApplication] delegate] window]];
    });
}

#pragma mark - Action Sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        if (self.actionSheetHandler != nil) {
            self.actionSheetHandler(nil);
        }
    } else {
        if (self.actionSheetHandler != nil) {
            ACAccount *account = self.systemAccounts[buttonIndex];
            self.actionSheetHandler(account);
        }
    }
}

@end