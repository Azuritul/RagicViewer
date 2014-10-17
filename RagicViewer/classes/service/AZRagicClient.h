//
//  AZRagicClient.h
//  RagicViewer
//
//  Created by azuritul on 2014/9/9.
//  Copyright (c) 2014年 Azuritul. All rights reserved.
//

#import <Foundation/Foundation.h>

__deprecated
@protocol RagicClientDelegate<NSObject>

@optional
-(void) loginFinishedWithStatusCode:(NSString*) code andResult:(NSDictionary*)result;
-(void) loadFinishedWithResult:(NSDictionary *) result;
@end

__deprecated
@interface AZRagicClient : NSObject

//Basic Auth
- (void) loginWithAPIKey:(NSString *) key;

//Password Auth
- (void)loginWithUsername:(NSString *)string password:(NSString *)pass;

//Loading Data
- (void)loadTopLevel:(NSString *)apikey;
- (void)loadTopLevelContentByAPIKey:(NSString *)apikey andAccount:(NSString *)account;
- (void)loadSheet:(NSString *)sheetUrl;

//Accessing webview
+ (NSURLRequest *)webviewRequestWithUrl:(NSString *)url;

@property (assign) id<RagicClientDelegate> delegate;

@end
