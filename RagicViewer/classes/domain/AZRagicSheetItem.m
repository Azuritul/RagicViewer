//
// Created by azuritul on 2014/9/29.
// Copyright (c) 2014 Azuritul. All rights reserved.
//

#import "AZRagicSheetItem.h"


@implementation AZRagicSheetItem
@synthesize key = _key;
@synthesize name = _name;
@synthesize seq = _seq;
@synthesize children = _children;
@synthesize itemUrl = _itemUrl;

const static NSString * BASE_URL = @"https://api.ragic.com";

+ (AZRagicSheetItem *) sheetItemFromDictionary:(NSDictionary *) dict forKey:(NSString *) key andAccount:(NSString *)account{
    AZRagicSheetItem * item = [[AZRagicSheetItem alloc] init];
    if(dict) {
        [item setKey:key];
        [item setName:dict[@"name"]];
        [item setSeq:[dict[@"seq"] integerValue]];
        NSMutableArray *childrenArray = [NSMutableArray array];
        NSDictionary *childDictionary = dict[@"children"];
        for(NSString * childKey in [childDictionary allKeys]) {
            AZRagicSheetItem * childItem = [AZRagicSheetItem sheetItemFromDictionary:childDictionary[childKey] forKey:childKey andAccount:account];
            //So the output account name would be "https://api.ragic.com/{accountName}/{sheetURL}/{sheetIndex}
            [childItem setItemUrl:[NSString stringWithFormat:@"%@/%@%@/%@", BASE_URL, account, key, childKey]];
            [childrenArray addObject:childItem];
        }
        [item setChildren:childrenArray];
    }
    return [item autorelease];
}


- (void)dealloc {
    [_key release];
    [_name release];
    [_children release];
    [_itemUrl release];
    [super dealloc];
}
@end