//
// Created by azuritul on 2014/10/2.
// Copyright (c) 2014 Labcule. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AZRagicUtils : NSObject

+ (NSString *)getUserMainAccount;
+ (void)removeUserInfo;

+ (UIColor *)colorFromHexString:(NSString *)hexString;
@end