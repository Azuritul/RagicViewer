//
//  AZRagicSwiftUtils.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/8.
//  Copyright (c) 2014年 Labcule. All rights reserved.
//

import UIKit
import Foundation

/**
  All utility methods
 */
@objc
class AZRagicSwiftUtils : NSObject {
    
    /**
        Retrieving user's account from iOS's user defaults.
    
        :return: Optional of a String that representing user account.
     */
    class func getUserMainAccount() -> String? {
        return NSUserDefaults.standardUserDefaults().objectForKey(Constants.KEY_ACCOUNT) as? String
    }
    
    /**
      Retrieving user's api key from iOS's user defaults.
    
      :return: Optional of a String that representing api key.
     */
    class func getUserAPIKey() -> String? {
        return NSUserDefaults.standardUserDefaults().objectForKey(Constants.KEY_APIKEY) as? String
    }
    
    /**
      Checking whether there is account stored in iOS's user defaults currently.
    
      :return: Boolean value indicating whether account is exist or not.
     */
    class func isMainAccountExist() -> Bool {
        if let account = AZRagicSwiftUtils.getUserMainAccount() {
            return true
        }
        return false
    }
    
    /**
      Removing user's api key and account name from iOS's user defaults.
     */
    class func removeUserInfo() {
        let standardStore = NSUserDefaults.standardUserDefaults()
        standardStore.removeObjectForKey(Constants.KEY_ACCOUNT)
        standardStore.removeObjectForKey(Constants.KEY_APIKEY)
        standardStore.synchronize()
    }
    
    /**
      Converting color code string (ex. #FF00FF) into instance of UIColor.
    
      :return: UIColor instance that represents the color code.
     */
    class func colorFromHexString(hexString:String) -> UIColor {
        
        var rgbValue:UInt32 = 0
        let scanner : NSScanner = NSScanner(string: hexString)
        if hexString.rangeOfString("#") != nil {
            scanner.scanLocation = 1
        } else {
            scanner.scanLocation = 0
        }
        
        scanner.scanHexInt(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    /**
      Retrieving the file path for storing user's accounts.
    
      :return: String that represents the account file path.
     */
    class func accountsFilePath() -> String {
        var path:Array = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var documentsDirectory:String = path.first as String
        var fullPath = documentsDirectory.stringByAppendingPathComponent("ragic_accounts.plist")
        return fullPath;
    }
    
    
    class func switchAccount(newAccount:String) {
        NSUserDefaults.standardUserDefaults().setObject(newAccount, forKey: Constants.KEY_ACCOUNT)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
   
}