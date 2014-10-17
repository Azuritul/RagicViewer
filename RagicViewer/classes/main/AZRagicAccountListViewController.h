//
// Created by azuritul on 2014/10/7.
// Copyright (c) 2014 Labcule. All rights reserved.
//

#import <Foundation/Foundation.h>

__deprecated
@protocol AZRagicAccountListViewControllerDelegate<NSObject>
@optional
-(void) didSwitchToAccount;
@end

__deprecated
@interface AZRagicAccountListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,assign) id<AZRagicAccountListViewControllerDelegate> delegate;

@end