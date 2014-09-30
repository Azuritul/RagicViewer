//
// Created by azuritul on 2014/9/30.
// Copyright (c) 2014 Azuritul. All rights reserved.
//

#import "AZRagicSheet.h"

@implementation AZRagicSheet

@synthesize account = _account;
@synthesize itemCollection = _itemCollection;

- (void)dealloc {
    [_account release];
    [_itemCollection release];
    [super dealloc];
}
@end