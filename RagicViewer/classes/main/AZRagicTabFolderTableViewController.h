//
//  AZRagicTabFolderTableViewController.h
//  RagicRestClient
//
//  Created by azuritul on 2014/9/9.
//  Copyright (c) 2014年 Azuritul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AZRagicClient.h"

@interface AZRagicTabFolderTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, RagicClientDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray * result;
@property (nonatomic, retain) UIView *dropdownMenu;
@property (nonatomic, retain) NSLayoutConstraint *xAxisLayoutConstraint;
@end
