//
//  LeafViewController.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/14.
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
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[webView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[webView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
        self.webView?.load(RagicClient.webviewRequestWithUrl(url: self.url!) as URLRequest)
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.show()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }

}
