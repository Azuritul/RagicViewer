//
//  AZRagicSwiftUtils.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/8.
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
        return UserDefaults.standard.object(forKey: Constants.KEY_ACCOUNT) as? String
    }
    
    /**
      Retrieving user's api key from iOS's user defaults.
    
      :return: Optional of a String that representing api key.
     */
    class func getUserAPIKey() -> String? {
        return UserDefaults.standard.object(forKey: Constants.KEY_APIKEY) as? String
    }
    
    /**
      Checking whether there is account stored in iOS's user defaults currently.
    
      :return: Boolean value indicating whether account is exist or not.
     */
    class func isMainAccountExist() -> Bool {
        guard let _ = AZRagicSwiftUtils.getUserMainAccount() else {
            return false
        }
        return true
    }
    
    /**
      Removing user's api key and account name from iOS's user defaults.
     */
    class func removeUserInfo() {
        let standardStore = UserDefaults.standard
        standardStore.removeObject(forKey: Constants.KEY_ACCOUNT)
        standardStore.removeObject(forKey: Constants.KEY_APIKEY)
        standardStore.synchronize()
    }
    
    /**
      Converting color code string (ex. #FF00FF) into instance of UIColor.
    
      :return: UIColor instance that represents the color code.
     */
    class func colorFromHexString(hexString:String) -> UIColor {
        
        var rgbValue:UInt32 = 0
        let scanner : Scanner = Scanner(string: hexString)
        if hexString.contains("#") {
            scanner.scanLocation = 1
        } else {
            scanner.scanLocation = 0
        }
        
        scanner.scanHexInt32(&rgbValue)
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
        let path:Array = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory:String = path.first! as String
        let fullPath = NSURL(string:documentsDirectory)?.appendingPathComponent("ragic_accounts.plist")
        
        return fullPath!.path;
    }
    
    
    class func switchAccount(newAccount:String) {
        UserDefaults.standard.set(newAccount, forKey: Constants.KEY_ACCOUNT)
        UserDefaults.standard.synchronize()
    }
    
   
}
