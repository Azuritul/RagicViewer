//
//  LeafViewController.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/14.
//  Copyright (c) 2014年 Labcule. All rights reserved.
//

import UIKit

class LeafViewController: UIViewController, UIWebViewDelegate {
    
    var webView:UIWebView?
    var url:String?
    
    init(url:String) {
        self.url = url
        super.init(nibName: nil, bundle: nil);
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "RagicViewer";
        let webView = UIWebView()
        webView.delegate = self
        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.webView = webView
        self.view.addSubview(webView)
        let bindings = ["webView":webView]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options: .allZeros, metrics: nil, views: bindings))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[webView]|", options: .allZeros, metrics: nil, views: bindings))
        self.webView?.loadRequest(RagicClient.webviewRequestWithUrl(self.url!))
        self.webView?.scalesPageToFit = true
        SVProgressHUD.showWithMaskType(.Gradient)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        dispatch_async(dispatch_get_main_queue(), {SVProgressHUD.dismiss()})
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        dispatch_async(dispatch_get_main_queue()){
            SVProgressHUD.dismiss()
        }
    }

}
