//
//  AZRagicSheetItem.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/9.
//

import Foundation

let BASE_URL = "https://api.ragic.com"

/**
  The domain class for Ragic sheet.
 */
@objc
class AZRagicSheetItem : NSObject {
    
    typealias Entry = Dictionary<String, AnyObject>
    
    ///  The key representing the sheet
    var key:String?
    
    ///  Human-friendly name of the sheet
    var name:String?

    ///  Sequence of the sheet, provided by server
    var seq:Int?
    
    /// Every sheet item can contain children
    var children:[AZRagicSheetItem]?
    
    /// The actual url representation of the sheet
    var itemUrl:String?
    
    override var description : String {
        var childArr = [String]()
        if children != nil {
            
            for child in children! {
                let childItem = "##Child## : { KEY: [\(child.key)] NAME: [\(child.name))] SEQ: [\(child.seq)] URL: [\(child.itemUrl)] }"
                childArr.append(childItem)
            }
            
        }
        return "##Item## : { KEY: [\(key)] NAME: [\(name)] SEQ: [\(seq)] URL: [\(itemUrl)] Child: [\(childArr)] }"
            
    }
    
    /**
      Create sheet item from Dictionary.
    
      :param: dict The dictionary
      :param: key The key
      :param: account Under which account
      :return: An instance of AZRagicSheetItem created from the dictionary
     */
    class func createSheetItem(fromDictionary dict:Dictionary<String, AnyObject>, forKey key:String, andAccount account:String) -> AZRagicSheetItem {
        typealias Entry = Dictionary<String, AnyObject>
        
        let item = AZRagicSheetItem()
        item.key = key
        item.name = dict["name"] as AnyObject? as? String
        item.seq = dict["seq"] as AnyObject? as? Int

        var childArray = [AZRagicSheetItem]()
        let childDict = dict["children"] as AnyObject? as! Entry
        
        for (childKey, childValue) in childDict {
            let childItem = AZRagicSheetItem()
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
    
}