//
//  AZRagicLeafViewController.h
//  RagicViewer
//
//  Created by azuritul on 2014/9/30.
//  Copyright (c) 2014年 Azuritul. All rights reserved.
//

#import <UIKit/UIKit.h>

__deprecated
@interface AZRagicLeafViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, retain) UIWebView* webView;
@property (nonatomic, copy) NSString * url;

- (id)initWithUrl:(NSString *)url;
@end
