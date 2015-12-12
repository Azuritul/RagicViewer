//
//  RagicClient.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/15.
//

import UIKit
import Foundation

// TODO: Document the server url pattern

/**
  Class interacting with Ragic server.

 */
@objc
class RagicClient: NSObject {

    private override init() {}
    static let sharedInstance = RagicClient()

    var delegate:ClientDelegate?
    
    // MARK: Service methods
    
    /**
     * Login with username and password.
     * If succeed, user's apikey and account lists will be saved for later use.
      
     * :param: username
     * :param: password
     */
    func login(username:String, password:String) {
        let url = "https://api.ragic.com/AUTH";
        let request = NSMutableURLRequest(URL:NSURL(string:url)!)
        let loginStr = "u=\(username)&p=\(password)&login_type=sessionId&json=1&apikey"
        request.HTTPMethod = "POST"
        request.HTTPBody = loginStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        request.HTTPShouldHandleCookies = false
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            do {
                let jsonObject:AnyObject! = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
                
                // Might need to document the returning json because the structure is pretty complicated
                if let json = jsonObject as? [String:AnyObject] {
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
            } catch {
                print("Error occurred.")
            }
            
            
        })
        dataTask.resume()
        
    }
    
    func printStringFromNSData(data:NSData) {
        let string = NSString(data: data, encoding:NSUTF8StringEncoding)
        print(string)
    }
    
    /**
      Loading top level contents for user using existing main account in user defaults.
    
     */
    func loadTopLevel() {
        let request = self.buildRequest("https://api.ragic.com")
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            if let data = data {
                do {
                    let jsonObject:AnyObject! = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
                    //let string = NSString(data: data, encoding:NSUTF8StringEncoding)
                    //print(string)
                    if let jsonObject = jsonObject as? Dictionary<String, AnyObject> {

                        //key would be the name for the database, so iterate the keys
                        
                        if let currentUserAccount:String = AZRagicSwiftUtils.getUserMainAccount() {
                            if let mainAccount = jsonObject[currentUserAccount] as AnyObject? as? Dictionary<String, AnyObject> {
                                //print(mainAccount)
                                if let children = mainAccount["children"] as AnyObject? as? Dictionary<String, NSDictionary> {
                                    self.delegate?.loadFinishedWithResult?(children)
                                }
                                
                            } else {
                                self.delegate?.loadFinishedWithResult?(nil)
                            }
                        } else {
                            self.delegate?.loadFinishedWithResult?(nil)
                        }
                        
                    }
                } catch {
                    print("it's totally wrong")
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
            if let data = data {
                do {
                    let jsonOptional:AnyObject! = try NSJSONSerialization.JSONObjectWithData(data, options:.MutableContainers)
                    
                    // Might need to document the returning json because the structure is pretty complicated
                    if let resultDic = jsonOptional as? Dictionary<String, AnyObject> {
                        self.delegate?.loadFinishedWithResult?(resultDic)
                    } else {
                        self.delegate?.loginFinishedWithStatusCode?("fail", result: nil)
                    }
                    
                } catch {
                    print("Error occurred.")
                }

            }
        })
        dataTask.resume()
    }

    /**
      Loading data entries.

      :param: entryUrl
      :param: offset  The offset of the data to be fetched
     */
    func loadEntries(entryUrl:String, offset:Int, count:Int) {
        let request = self.buildRequest(entryUrl + "?limit=\(offset),\(count)")

        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            if let data = data {
                do {
                    let jsonOptional:AnyObject! = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0) )
                    
                    if let resultArray = jsonOptional as? Dictionary<String, AnyObject> {
                        self.delegate?.loadFinishedWithResult?(resultArray)
                    } else {
                        self.delegate?.loginFinishedWithStatusCode?("fail", result: nil)
                    }
                } catch {
                    print("Error occurred.")
                }
                
            }
            
        })

        dataTask.resume()
    }

    
    // MARK: Utility methods
    
    /**
      Building request from the argument.
      This method calls www.ragic.com instead of api.ragic.com since we are requesting web pages.
    
      :param: The URL of the requested resource
      :return: An NSURLRequest instance representing the URL
     */
    class func webviewRequestWithUrl(url:String) -> NSURLRequest {
        let webViewURL = url.stringByReplacingOccurrencesOfString("api", withString: "www")
        if let apikey = NSUserDefaults.standardUserDefaults().objectForKey("ragic_apikey") {
            let request = NSMutableURLRequest(URL: NSURL(string: webViewURL)!)
            let keyParam = "Basic \(apikey)"
            request.setValue(keyParam, forHTTPHeaderField: "Authorization")
            request.HTTPShouldHandleCookies = false
            request.HTTPMethod = "GET"
            
            return request.copy() as! NSURLRequest
        }
        return NSURLRequest()
    }
    
    /**
      Building request from the argument.
      Common URL parameters required by Ragic server is appended in the method.
        
      :param: The URL of the requested resource
      :return: An NSMutableURLRequest instance representing the url
     */
    private func buildRequest(url:String) -> NSMutableURLRequest {
        let apikey = AZRagicSwiftUtils.getUserAPIKey()!
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
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




