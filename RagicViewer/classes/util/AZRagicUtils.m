//
// Created by azuritul on 2014/10/2.
// Copyright (c) 2014 Labcule. All rights reserved.
//

#import "AZRagicUtils.h"

@implementation AZRagicUtils

+ (NSString *) getUserMainAccount {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"ragic_account"];
}

+ (void)removeUserInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ragic_account"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ragic_apikey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
@end