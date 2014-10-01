//
//  AZRagicClient.h
//  RagicRestClient
//
//  Created by azuritul on 2014/9/9.
//  Copyright (c) 2014年 Azuritul. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RagicClientDelegate
@optional
-(void) loginFinishedWithStatusCode:(NSString*) code andResult:(NSDictionary*)result;
-(void) loadFinishedWithResult:(NSDictionary *) result;
@end


@interface AZRagicClient : NSObject

//Basic Auth
- (NSDictionary *) loginWithAPIKey:(NSString *) key;

//Password Auth
- (NSDictionary *) loginWithUsername:(NSString *)string password:(NSString *)pass;
- (NSDictionary *)loadTopLevel:(NSString *)apikey;
- (NSDictionary *)loadSheet:(NSString *)sheetUrl;

+ (NSURLRequest *)webviewRequestWithUrl:(NSString *)url;

@property (assign) id<RagicClientDelegate> delegate;

@end
