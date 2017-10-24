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
        let request = NSMutableURLRequest(url:URL(string:url)!)
        let loginStr = "u=\(username)&p=\(password)&login_type=sessionId&json=1&apikey"
        request.httpMethod = "POST"
        request.httpBody = loginStr.data(using: String.Encoding.utf8, allowLossyConversion: false)
        request.httpShouldHandleCookies = false
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            do {
                let jsonObject:AnyObject! = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
                
                // Might need to document the returning json because the structure is pretty complicated
                if let json = jsonObject as? [String:AnyObject] {
                    if let key = json["apikey"] as AnyObject? as? String {
                        // API key returned by server is saved because it will be used afterwards for building HTTP request
                        UserDefaults.standard.set(key, forKey:Constants.KEY_APIKEY)
                    }
                    if let accounts = json["accounts"] as AnyObject? as? Dictionary<String,AnyObject> {
                        if let account = accounts["account"] as AnyObject? as? String {
                            UserDefaults.standard.set(account, forKey:Constants.KEY_ACCOUNT)
                        }
                    }
                    
                    UserDefaults.standard.synchronize()
                    if let allAccount = json["allAccounts"] as? NSArray {
                        allAccount.write(toFile: AZRagicSwiftUtils.accountsFilePath(), atomically:true)
                    }
                    
                    self.delegate?.loginFinishedWithStatusCode?(code: "success", result:json)
                } else {
                    self.delegate?.loginFinishedWithStatusCode?(code: "fail", result: nil)
                }
            } catch {
                print("Error occurred.")
            }
            
            
        })
        dataTask.resume()
        
    }
    
    func printStringFromNSData(data:Data) {
        let string = NSString(data: data, encoding:String.Encoding.utf8.rawValue)
        print(string ?? "")
    }
    
    /**
      Loading top level contents for user using existing main account in user defaults.
    
     */
    func loadTopLevel() {
        let request = self.buildRequest(url: "https://api.ragic.com")
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            
            if let data = data {
                do {
                    let jsonObject:AnyObject! = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
                    //let string = NSString(data: data, encoding:NSUTF8StringEncoding)
                    //print(string)
                    if let jsonObject = jsonObject as? Dictionary<String, AnyObject> {

                        //key would be the name for the database, so iterate the keys
                        
                        if let currentUserAccount:String = AZRagicSwiftUtils.getUserMainAccount() {
                            if let mainAccount = jsonObject[currentUserAccount] as AnyObject? as? Dictionary<String, AnyObject> {
                                //print(mainAccount)
                                if let children = mainAccount["children"] as AnyObject? as? Dictionary<String, NSDictionary> {
                                    self.delegate?.loadFinishedWithResult?(result: children)
                                }
                                
                            } else {
                                self.delegate?.loadFinishedWithResult?(result: nil)
                            }
                        } else {
                            self.delegate?.loadFinishedWithResult?(result: nil)
                        }
                        
                    }
                } catch {
                    print("it's totally wrong")
                }
                
            } else {
                //something is wrong
                self.delegate?.loadFinishedWithResult?(result: nil)
            }
        })
        
        dataTask.resume()
    }
    
    
    func loadSheet(sheetUrl:String) {
        
        let request = self.buildRequest(url: sheetUrl)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            if let data = data {
                do {
                    let jsonOptional:AnyObject! = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
                    
                    // Might need to document the returning json because the structure is pretty complicated
                    if let resultDic = jsonOptional as? Dictionary<String, AnyObject> {
                        self.delegate?.loadFinishedWithResult?(result: resultDic)
                    } else {
                        self.delegate?.loginFinishedWithStatusCode?(code: "fail", result: nil)
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
        let request = self.buildRequest(url: entryUrl + "?limit=\(offset),\(count)")

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            if let data = data {
                do {
                    let jsonOptional:AnyObject! = try JSONSerialization.jsonObject(with: data, options: .mutableContainers ) as AnyObject
                    
                    if let resultArray = jsonOptional as? Dictionary<String, AnyObject> {
                        self.delegate?.loadFinishedWithResult?(result: resultArray)
                    } else {
                        self.delegate?.loginFinishedWithStatusCode?(code: "fail", result: nil)
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
        let webViewURL = url.replacingOccurrences(of: "api", with: "www")
        if let apikey = UserDefaults.standard.object(forKey: "ragic_apikey") {
            let request = NSMutableURLRequest(url: NSURL(string: webViewURL)! as URL)
            let keyParam = "Basic \(apikey)"
            request.setValue(keyParam, forHTTPHeaderField: "Authorization")
            request.httpShouldHandleCookies = false
            request.httpMethod = "GET"
            
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
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let keyParam = "Basic \(apikey)"
        request.setValue(keyParam, forHTTPHeaderField: "Authorization")
        request.httpShouldHandleCookies = false
        return request
    }
    
    
}

@objc
protocol ClientDelegate {

    @objc optional func loginFinishedWithStatusCode(code:String, result:Dictionary<String, AnyObject>?)
    @objc optional func loadFinishedWithResult(result:Dictionary<String, AnyObject>?)
}




