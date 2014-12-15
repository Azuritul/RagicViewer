//
//  RagicClient.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/15.
//  Copyright (c) 2014年 Labcule. All rights reserved.
//

import UIKit
import Foundation

// TODO: Document the server url pattern

/**
  Class interacting with Ragic server.

 */
@objc
class RagicClient: NSObject {

    var delegate:ClientDelegate?
    
    // MARK: Service methods
    
    /**
      Login with username and password.  
      If succeed, user's apikey and account lists will be saved for later use.
      
      :param: username
      :param: password
     */
    func login(username:String, password:String) {
        let url = "https://api.ragic.com/AUTH";
        let request = NSMutableURLRequest(URL:NSURL(string:url)!)
        var loginStr = "u=\(username)&p=\(password)&login_type=sessionId&json=1&apikey"
        request.HTTPMethod = "POST"
        request.HTTPBody = loginStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        request.HTTPShouldHandleCookies = false
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            var resultError:NSError?
            let jsonOptional:AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error:&resultError)
            
            // Might need to document the returning json because the structure is pretty complicated
            if let json = jsonOptional as?Dictionary<String, AnyObject> {
                if let key = json["apikey"] as AnyObject? as? String {
                    // API key returned by server is saved because it will be used afterwards for building HTTP request
                    NSUserDefaults.standardUserDefaults().setObject(key, forKey:Constants.KEY_APIKEY)
                }
                if let accounts = json["accounts"] as AnyObject? as? Dictionary<String,AnyObject> {
                    if let account = accounts["account"] as AnyObject? as? String {
                        NSUserDefaults.standardUserDefaults().setObject(account, forKey:Constants.KEY_ACCOUNT)
                    }
                }
                
                NSUserDefaults.standardUserDefaults().synchronize()
                if let allAccount = json["allAccounts"] as? NSArray {
                    allAccount.writeToFile(AZRagicSwiftUtils.accountsFilePath(), atomically:true)
                }
                
                self.delegate?.loginFinishedWithStatusCode?("success", result:json)
            } else {
                self.delegate?.loginFinishedWithStatusCode?("fail", result: nil)
            }
            
        })
        dataTask.resume()
        
    }
    
    /**
      Loading top level contents for user using existing main account in user defaults.
    
     */
    func loadTopLevel() {
        var request = self.buildRequest("https://api.ragic.com")
        var dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            var resultError:NSError?
            let jsonResponse:AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error:&resultError)

            if let jsonResponse = jsonResponse as? Dictionary<String, AnyObject> {
                if let currentUserAccount:String = AZRagicSwiftUtils.getUserMainAccount() {
                    if let mainAccount = jsonResponse[currentUserAccount] as AnyObject? as? Dictionary<String, AnyObject> {
                        //println(mainAccount)
                        if let children = mainAccount["children"] as AnyObject? as? Dictionary<String, NSDictionary> {
                            //println(children)
                            
                            self.delegate?.loadFinishedWithResult?(children)
                        }

                    } else {
                        self.delegate?.loadFinishedWithResult?(nil)
                    }
                } else {
                    self.delegate?.loadFinishedWithResult?(nil)
                }
                
            } else {
                //something is wrong
                self.delegate?.loadFinishedWithResult?(nil)
            }
            
        })
        
        dataTask.resume()
    }
    
    
    func loadSheet(sheetUrl:String) {
        
        let request = self.buildRequest(sheetUrl)
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            var resultError:NSError?
            let jsonOptional:AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error:&resultError)
            
            // Might need to document the returning json because the structure is pretty complicated
            if let resultDic = jsonOptional as? Dictionary<String, AnyObject> {
                self.delegate?.loadFinishedWithResult?(resultDic)
            } else {
                self.delegate?.loginFinishedWithStatusCode?("fail", result: nil)
            }
            
        })
        
        dataTask.resume()
    }
    
    
    
    // MARK: Utility methods
    
    /**
      Building request from the argument. This method calls www.ragic.com instead of api.ragic.com since we are requesting web pages.
    
      :param: The URL of the requested resource
      :return: An NSURLRequest instance representing the URL
     */
    class func webviewRequestWithUrl(url:String) -> NSURLRequest {
        let webViewURL = url.stringByReplacingOccurrencesOfString("api", withString: "www")
        let apikey = NSUserDefaults.standardUserDefaults().objectForKey("ragic_apikey") as String
        let request = NSMutableURLRequest(URL: NSURL(string: webViewURL)!)
        let keyParam = "Basic \(apikey)"
        request.setValue(keyParam, forHTTPHeaderField: "Authorization")
        request.HTTPShouldHandleCookies = false
        request.HTTPMethod = "GET"
        return request.copy() as NSURLRequest
    }
    
    /**
      Building request from the argument. Common URL parameters required by Ragic server is appended in the method.
        
      :param: The URL of the requested resource
      :return: An NSMutableURLRequest instance representing the url
     */
    private func buildRequest(url:String) -> NSMutableURLRequest {
        let apikey = AZRagicSwiftUtils.getUserAPIKey()!
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let keyParam = "Basic \(apikey)"
        request.setValue(keyParam, forHTTPHeaderField: "Authorization")
        request.HTTPShouldHandleCookies = false
        return request
    }
    
    
}

@objc
protocol ClientDelegate {

    optional func loginFinishedWithStatusCode(code:String, result:Dictionary<String, AnyObject>?)
    optional func loadFinishedWithResult(result:Dictionary<String, AnyObject>?)
}




