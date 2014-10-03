//
// Created by azuritul on 2014/9/30.
// Copyright (c) 2014 Labcule. All rights reserved.
//

#import "AZRagicWebViewController.h"


@interface AZRagicWebViewController () <UIWebViewDelegate>
@end

@implementation AZRagicWebViewController


@synthesize webView = _webView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIWebView *webView = [[UIWebView alloc] init];
    [webView setTranslatesAutoresizingMaskIntoConstraints:NO];

    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.ragic.com/intl/zh-TW/resetPwd"]]];
    webView.delegate = self;
    self.webView = webView;
    [self.view addSubview:self.webView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[webView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(webView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-44-[webView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(webView)]];

}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.view setNeedsDisplay];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"start loading");
}



- (void)dealloc {
    [_webView release];
    [super dealloc];
}
@end