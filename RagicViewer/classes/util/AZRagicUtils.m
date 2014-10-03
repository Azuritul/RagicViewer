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
@end