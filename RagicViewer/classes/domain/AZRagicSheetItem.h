//
// Created by azuritul on 2014/9/29.
// Copyright (c) 2014 Azuritul. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AZRagicSheetItem : NSObject

@property (nonatomic, copy) NSString * key;  // == url segment
@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSInteger seq;
@property (nonatomic, retain) NSArray * children;
@property (nonatomic, copy) NSString *itemUrl;

+ (AZRagicSheetItem *)sheetItemFromDictionary:(NSDictionary *)dict forKey:(NSString *)key andAccount:(NSString *)account;
@end