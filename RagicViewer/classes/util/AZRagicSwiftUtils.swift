//
//  AZRagicSwiftUtils.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/8.
//  Copyright (c) 2014年 Labcule. All rights reserved.
//

import UIKit

@objc
class AZRagicSwiftUtils:NSObject {
    
    var k = "variable"
    let g:String = "constant"
    
    //Ways to declare array
    var arr1:[String] = [String]()
    var arr2:Array<String> = Array<String>()
    
    //Ways to declare dictionary
    var dict1:Dictionary<String,Int> = Dictionary<String,Int>()
    var dict2 = ["key":"title", "value":"The lean startup"]
    
    func helloWorld() -> String {
        return "Hello world"
    }
    
    
    func getUserMainAccount() -> String {
        return ""
    }
    
    func removeUserInfo() {
        
    }
    
    func colorFromHexString(hexString:String) -> UIColor {
        return UIColor .whiteColor()
    }
    
    func accountsFilePath() -> String {
        return ""
    }
    
    func switchAccount(newAccount:String) {
        
    }
    
   
}



