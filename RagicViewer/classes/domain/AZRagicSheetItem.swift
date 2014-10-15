//
//  AZRagicSheetItem.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/9.
//  Copyright (c) 2014年 Labcule. All rights reserved.
//

import Foundation

let BASE_URL = "https://api.ragic.com"

class AZRagicSheetItem {

    var key:String?
    var name:String?
    var seq:Int?
    var children:[AZRagicSheetItem]?
    var itemUrl:String?
    var description : String {
        if key != nil {
            return "key : { \(key) }"
        }
        return "nothing"
    }
    
    class func createSheetItem(fromDictionary dict:[String:Any], forKey key:String, andAccount account:String) -> AZRagicSheetItem {

        var item = AZRagicSheetItem()
        item.key = key
        item.name = dict["name"] as? String
        item.seq = dict["seq"] as? Int
        let childDict = dict["children"] as [String:Any]
        
        var childArray = [AZRagicSheetItem]()
        
        for (childKey, childValue) in childDict {
            var childItem = AZRagicSheetItem()
            childItem.key = childKey
            childItem.name = childDict["name"] as? String
            childItem.seq = childDict["seq"] as? Int
            childItem.itemUrl = "\(BASE_URL)/\(account)\(key)/\(childKey)"
            childArray.append(childItem)
        }
        
        item.children = childArray
        return item
        
    }
    
}