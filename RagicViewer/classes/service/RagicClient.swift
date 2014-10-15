//
//  RagicClient.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/15.
//  Copyright (c) 2014年 Labcule. All rights reserved.
//

import UIKit

class RagicClient: NSObject {

    var delegate:ClientDelegate?
    
    func login(username:String, password:String) {
        let url = "https://api.ragic.com/AUTH";
        let request = NSMutableURLRequest(URL:NSURL(string:url))
        var loginStr = "u=\(username)&p=\(password)&login_type=sessionId&json=1&apikey"
        request.HTTPMethod = "POST"
        request.HTTPBody = loginStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        request.HTTPShouldHandleCookies = false
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {(data : NSData!, response : NSURLResponse!, error : NSError!) in
            var resultError:NSError?
            let jsonOptional:AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error:&resultError)
            
            // Might need to document the returning json because the structure is pretty complicated
            if let json = jsonOptional as?Dictionary<String, AnyObject> {
                if let key = json["apikey"] as AnyObject? as? String {
                    NSUserDefaults.standardUserDefaults().setObject(key, forKey:"ragic_apikey")
                }
                if let accounts = json["accounts"] as AnyObject? as? Dictionary<String,AnyObject> {
                    if let account = accounts["account"] as AnyObject? as? String {
                        NSUserDefaults.standardUserDefaults().setObject(account, forKey:"ragic_account")
                    }
                }
                NSUserDefaults.standardUserDefaults().synchronize()
                self.delegate?.loginFinishedWithStatusCode("success", result:json)
            } else {
                //something is wrong
                self.delegate?.loginFinishedWithStatusCode("fail", result: nil)
            }
            
        })
        dataTask.resume()
        
    }
    
    func loadTopLevel(apikey:String) {
        let request = self.buildRequest("https://api.ragic.com")
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {(data : NSData!, response : NSURLResponse!, error : NSError!) in
            var resultError:NSError?
            let jsonOptional:AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error:&resultError)
            
            // Might need to document the returning json because the structure is pretty complicated
            if let json = jsonOptional as? Dictionary<String, AnyObject> {
                let currentUserAccount = AZRagicSwiftUtils.getUserMainAccount()!
                if let mainAccount = json[currentUserAccount] as AnyObject? as? Dictionary<String, AnyObject> {
                    if let children = mainAccount["children"] as AnyObject? as? Dictionary<String, AnyObject> {
                        self.delegate?.loadFinishedWithResult(children)
                    }
                }
                
            } else {
                //something is wrong
                self.delegate?.loginFinishedWithStatusCode("fail", result: nil)
            }
            
        })
        
        dataTask.resume()
    }
    
    
    func loadSheet(sheetUrl:String) {
        
        let request = self.buildRequest(sheetUrl)
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {(data : NSData!, response : NSURLResponse!, error : NSError!) in
            var resultError:NSError?
            let jsonOptional:AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error:&resultError)
            
            // Might need to document the returning json because the structure is pretty complicated
            if let resultDic = jsonOptional as? Dictionary<String, AnyObject> {
                self.delegate?.loadFinishedWithResult(resultDic)
            } else {
                self.delegate?.loginFinishedWithStatusCode("fail", result: nil)
            }
            
        })
        
        dataTask.resume()
    }
    
    class func webviewRequestWithUrl(url:String) -> NSURLRequest {
        let webViewURL = url.stringByReplacingOccurrencesOfString(url, withString: "www", options: .LiteralSearch, range: nil)
        let apikey = NSUserDefaults.standardUserDefaults().objectForKey("ragic_apikey") as String
        let request = NSMutableURLRequest(URL: NSURL(string: webViewURL))
        let keyParam = "Basic \(apikey)"
        request.setValue(keyParam, forHTTPHeaderField: "Authorization")
        request.HTTPShouldHandleCookies = false
        request.HTTPMethod = "GET"
        return request.copy() as NSURLRequest
    }
    
    // MARK: Utility methods
    func buildRequest(url:String) -> NSURLRequest {
        let apikey = NSUserDefaults.standardUserDefaults().objectForKey("ragic_apikey") as String
        let request = NSMutableURLRequest(URL: NSURL(string: url))
        let keyParam = "Basic \(apikey)"
        request.setValue(keyParam, forHTTPHeaderField: "Authorization")
        request.HTTPShouldHandleCookies = false
        request.HTTPMethod = "POST"
        return request
    }
    
    
}

protocol ClientDelegate {
    func loginFinishedWithStatusCode(code:String, result:Dictionary<String, AnyObject>?)
    func loadFinishedWithResult(result:Dictionary<String, AnyObject>?)
}




