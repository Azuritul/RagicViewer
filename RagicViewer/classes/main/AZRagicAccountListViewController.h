//
// Created by azuritul on 2014/10/7.
// Copyright (c) 2014 Labcule. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AZRagicAccountListViewControllerDelegate<NSObject>
@optional
-(void) didSwitchToAccount;
@end

@interface AZRagicAccountListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,assign) id<AZRagicAccountListViewControllerDelegate> delegate;

@end