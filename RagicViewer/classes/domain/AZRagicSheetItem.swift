//
//  AZRagicSheetItem.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/9.
//  Copyright (c) 2014年 Labcule. All rights reserved.
//

import Foundation

let BASE_URL = "https://api.ragic.com"

@objc
class AZRagicSheetItem : NSObject {
    
    typealias Entry = Dictionary<String, AnyObject>
    
    var key:String?
    var name:String?
    var seq:Int?
    var children:[AZRagicSheetItem]?
    var itemUrl:String?
    override var description : String {
        if key != nil {
            return "##Item## : { KEY: [\(key)] NAME: [\(name)] SEQ: [\(seq)] URL: [\(itemUrl)] }"
        }
        return "Item is not associated with a key"
    }
    
    class func createSheetItem(fromDictionary dict:Dictionary<String, AnyObject>, forKey key:String, andAccount account:String) -> AZRagicSheetItem {
        typealias Entry = Dictionary<String, AnyObject>
        
        var item = AZRagicSheetItem()
        item.key = key
        item.name = dict["name"] as AnyObject? as? String
        item.seq = dict["seq"] as AnyObject? as? Int

        var childArray = [AZRagicSheetItem]()
        let childDict = dict["children"] as AnyObject? as Entry
        
        for (childKey, childValue) in childDict {
            var childItem = AZRagicSheetItem()
            childItem.key = childKey
            //childValue is also a dictionary
            childItem.name = childValue["name"] as AnyObject? as? String
            childItem.seq = childValue["seq"] as AnyObject? as? Int
            childItem.itemUrl = "\(BASE_URL)/\(account)\(key)/\(childKey)"
            childArray.append(childItem)
        }
        
        item.children = childArray
        return item
    }
    
    class func mappingFieldForDictionaryAndItem(dict:Entry) -> AZRagicSheetItem {
        let item = AZRagicSheetItem()
        
        return item
    }
    
    
}