//
//  LeafViewController.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/14.
//  Copyright (c) 2014年 Labcule. All rights reserved.
//

import UIKit
import WebKit

/**
  View controller for showing the detail view of a specific data entry.
 */
class LeafViewController: UIViewController, UIWebViewDelegate, WKNavigationDelegate {
    
    private var webView:WKWebView?
    private var url:String?
    
    init(url:String) {
        self.url = url
        super.init(nibName: nil, bundle: nil);
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "RagicViewer"
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.webView = webView
        self.view.addSubview(webView)
        let bindings = ["webView":webView]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[webView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
        self.webView?.loadRequest(RagicClient.webviewRequestWithUrl(self.url!))
        SVProgressHUD.showWithMaskType(.Gradient)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        dispatch_async(dispatch_get_main_queue()){
            SVProgressHUD.dismiss()
        }
    }

    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        dispatch_async(dispatch_get_main_queue(), {SVProgressHUD.dismiss()})
    }

}
