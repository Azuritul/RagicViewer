//
//  AZRagicSwiftUtils.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/8.
//  Copyright (c) 2014年 Labcule. All rights reserved.
//

import UIKit
import Foundation

@objc
class AZRagicSwiftUtils {
    
    class func getUserMainAccount() -> String? {
        return NSUserDefaults.standardUserDefaults().stringForKey("ragic_accont")
    }
    
    class func getUserAPIKey() -> String? {
        return NSUserDefaults.standardUserDefaults().stringForKey("ragic_apikey")
    }
    
    class func removeUserInfo() {
        let standardStore = NSUserDefaults.standardUserDefaults()
        standardStore.removeObjectForKey("ragic_account")
        standardStore.removeObjectForKey("ragic_apikey")
        standardStore.synchronize()
    }
    
    
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
    
    class func accountsFilePath() -> String {
        var path:Array = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var documentsDirectory:String = path[0] as String
        return  documentsDirectory + "ragic_accounts.plist";
    }
    
    class func switchAccount(newAccount:String) {
        NSUserDefaults.standardUserDefaults().setObject(newAccount, forKey: "ragic_account")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
   
}