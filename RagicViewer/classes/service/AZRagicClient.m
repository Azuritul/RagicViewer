//
//  AZRagicClient.m
//
//  Created by azuritul on 2014/9/9.
//  Copyright (c) 2014年 Azuritul. All rights reserved.
//

#import "AZRagicClient.h"

@implementation AZRagicClient
@synthesize delegate = _delegate;

- (NSDictionary *) loginWithAPIKey:(NSString *) key {
    NSString *url = @"https://api.ragic.com/";
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
    [request setValue:[NSString stringWithFormat:@"Basic %@", key] forHTTPHeaderField:@"Authorization"];
    [NSURLConnection sendAsynchronousRequest:request
                              queue:[[[NSOperationQueue alloc] init] autorelease]
                  completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                      if ([data length] > 0 && error == nil) {
                          NSString *responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
                          if ([self.delegate respondsToSelector:@selector(loginFinishedWithStatusCode:andResult:)]) {
                          }
                      }
                      else if ([data length] == 0 && error == nil) {
                          NSLog(@"Nothing was downloaded.");
                      }
                      else if (error != nil) {
                          NSLog(@"Error = %@", error);
                      }
                  }];
    return nil;
}

- (NSDictionary *) loginWithUsername:(NSString *)name password:(NSString *)password {
    NSString * url = @"https://api.ragic.com/AUTH";
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
    NSString *loginStr = [NSString stringWithFormat:@"u=%@&p=%@&login_type=sessionId&json=1&apikey", name, password];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[loginStr dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[[NSOperationQueue alloc] init] autorelease]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ([data length] > 0 && error == nil) {
                                   NSError *resultError;

                                   NSString *responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
                                   NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&resultError];
                                   if(resultDic.count > 0) {
                                       if ([self.delegate respondsToSelector:@selector(loginFinishedWithStatusCode:andResult:)]) {
                                           //Should save apikey to keychain if success
                                           [[NSUserDefaults standardUserDefaults] setObject:resultDic[@"apikey"] forKey:@"ragic_apikey"];
                                           [[NSUserDefaults standardUserDefaults] setObject:resultDic[@"accounts"][@"account"] forKey:@"ragic_account"];
                                           [[NSUserDefaults standardUserDefaults] synchronize];
                                           [self.delegate loginFinishedWithStatusCode:@"success" andResult:resultDic];
                                       }
                                   } else {
                                       //Something is wrong
                                       if ([self.delegate respondsToSelector:@selector(loginFinishedWithStatusCode:andResult:)]) {
                                           [self.delegate loginFinishedWithStatusCode:@"fail" andResult:resultDic];
                                       }
                                   }

                               } else if (error != nil) {
                                   if ([self.delegate respondsToSelector:@selector(loginFinishedWithStatusCode:andResult:)]) {
                                       [self.delegate loginFinishedWithStatusCode:@"fail" andResult:@{}];
                                   }
                               }
                           }];
    return nil;
}

// showing all accounts
- (NSDictionary *) loadTopLevel:(NSString *) apikey {
    NSString *url = @"https://api.ragic.com/";
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
    NSString *keyParam = [NSString stringWithFormat:@"Basic %@", apikey];
    [request setValue:keyParam forHTTPHeaderField:@"Authorization"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[[NSOperationQueue alloc] init] autorelease]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ([data length] > 0 && error == nil) {
                                   NSError *resultError;
                                   NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&resultError];
                                   if ([self.delegate respondsToSelector:@selector(loadFinishedWithResult:)]) {
                                       if([[resultDic allKeys] count] > 0) {
                                           NSString * accountKey = [resultDic allKeys][0];
                                           [self.delegate loadFinishedWithResult:resultDic[accountKey][@"children"]];
                                       }
                                   }
                               }
                               else if ([data length] == 0 && error == nil) {
                                   NSLog(@"Nothing was downloaded.");
                               }
                               else if (error != nil) {
                                   NSLog(@"Error = %@", error);
                               }
                           }];
    return nil;
}


- (void)loadSheet:(NSString *)sheetUrl {
    NSString *apikey = [[NSUserDefaults standardUserDefaults] objectForKey:@"ragic_apikey"];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:sheetUrl]] autorelease];
    NSString *keyParam = [NSString stringWithFormat:@"Basic %@", apikey];
    [request setValue:keyParam forHTTPHeaderField:@"Authorization"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[[NSOperationQueue alloc] init] autorelease]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ([data length] > 0 && error == nil) {
                                   NSError *resultError;
                                   NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&resultError];
                                   if ([self.delegate respondsToSelector:@selector(loadFinishedWithResult:)]) {
                                       [self.delegate loadFinishedWithResult:resultDic];
                                   }
                               }
                               else if ([data length] == 0 && error == nil) {
                                   NSLog(@"Nothing was downloaded.");
                               }
                               else if (error != nil) {
                                   NSLog(@"Error = %@", error);
                               }
                           }];
}

+(NSURLRequest *)webviewRequestWithUrl:(NSString *) url {
    NSString * webViewURL = [url stringByReplacingOccurrencesOfString:@"api." withString:@"www."];
    NSString *apikey = [[NSUserDefaults standardUserDefaults] objectForKey:@"ragic_apikey"];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:webViewURL]] autorelease];
    NSString *keyParam = [NSString stringWithFormat:@"Basic %@", apikey];
    [request setValue:keyParam forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    return [request copy];
}

@end
