//
// Created by azuritul on 2014/9/29.
// Copyright (c) 2014 Azuritul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

__deprecated
@interface AZRagicSheetListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

-(AZRagicSheetListViewController *) initWithArray:(NSArray *) array;

@property (nonatomic, retain) UITableView * tableView;
@property (nonatomic, retain) NSArray * dataArray;
@property (nonatomic, retain) NSMutableDictionary *dataDict;

@end