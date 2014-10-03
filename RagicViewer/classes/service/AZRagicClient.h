//
//  AZRagicClient.h
//  RagicRestClient
//
//  Created by azuritul on 2014/9/9.
//  Copyright (c) 2014年 Azuritul. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RagicClientDelegate<NSObject>
@optional
-(void) loginFinishedWithStatusCode:(NSString*) code andResult:(NSDictionary*)result;
-(void) loadFinishedWithResult:(NSDictionary *) result;
@end


@interface AZRagicClient : NSObject

//Basic Auth
- (void) loginWithAPIKey:(NSString *) key;

//Password Auth
- (void)loginWithUsername:(NSString *)string password:(NSString *)pass;
- (void)loadTopLevel:(NSString *)apikey;
- (void)loadSheet:(NSString *)sheetUrl;

+ (NSURLRequest *)webviewRequestWithUrl:(NSString *)url;

@property (assign) id<RagicClientDelegate> delegate;

@end
