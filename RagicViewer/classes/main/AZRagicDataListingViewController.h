//
// Created by azuritul on 2014/10/2.
// Copyright (c) 2014 Labcule. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AZRagicDataListingViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

- (AZRagicDataListingViewController *)initWithURL:(NSString *)url;

@property (nonatomic, copy) NSString * url;
@property (nonatomic, retain) UITableView * tableView;
@property (nonatomic, retain) NSMutableDictionary *dataDict;

@end