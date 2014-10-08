//
//  AZRagicLeafViewController.m
//  RagicViewer
//
//  Created by azuritul on 2014/9/30.
//  Copyright (c) 2014年 Azuritul. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "AZRagicLeafViewController.h"
#import "AZRagicClient.h"

@implementation AZRagicLeafViewController

@synthesize webView = _webView;
@synthesize url = _url;

- (id)initWithUrl:(NSString *) url {
    self = [super init];
    if(self) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RagicViewer";
    UIWebView *webView = [[UIWebView alloc] init];
    [webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.webView = webView;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(webView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[webView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(webView)]];
    [self.webView loadRequest:[AZRagicClient webviewRequestWithUrl:self.url]];
    [self.webView setScalesPageToFit:YES];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [webView release];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD dismiss];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_webView release];
    [_url release];
    [super dealloc];
}

@end
