//
//  AZUSimpleDropdownMenu.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/23.
//  Copyright (c) 2014年 Labcule. All rights reserved.
//

import UIKit


class AZUSimpleDropdownMenu: UIView {

    let rootView:UIScrollView = UIScrollView(frame: CGRectZero)
    let overlayView:UIView = UIView(frame: CGRectZero)
    
    let seperator:DropdownSeperatorStyle = .None
    let items = [AZDropdownMenuItem]()
    var itemsArray = [UIButton]()
    var dropdownConstraint:NSLayoutConstraint?
    
    init(frame: CGRect, items:[AZDropdownMenuItem]) {
        super.init(frame:frame)
        self.items = items
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        //Adding
        //let item :AZDropdownMenuItem = AZDropdownMenuItem("dropdown")
        //item text, text color, alignment, bgcolor normal, bgcolor pressed

        //check itemsArray count
        
        //adding constraints

        
    }
    
    func addMenuItem(item:UIButton) {
        self.itemsArray.append(item)
        item.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.rootView.addSubview(item)
    }
    
    

}


enum DropdownSeperatorStyle {
    case Singleline, None
}



