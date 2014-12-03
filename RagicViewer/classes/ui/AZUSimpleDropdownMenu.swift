//
//  AZUSimpleDropdownMenu.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/23.
//  Copyright (c) 2014年 Labcule. All rights reserved.
//

import UIKit

class AZUSimpleDropdownMenu : UIView {

    let seperator:DropdownSeperatorStyle = .None
    let containerView:UIView = UIView()
    let overlay:CALayer = CALayer()
    let titles = [String]()
    let itemsArray = [UIButton]()
    var dropdownConstraint:NSLayoutConstraint?
    
    let ITEM_HEIGHT:CGFloat = 60.0
    
    // MARK: - Initializer
    init(frame: CGRect, titles:[String]) {
        super.init(frame:frame)
        self.titles = titles
        self.backgroundColor = UIColor.clearColor()
        self.alpha = 0.95;
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        for title in titles {
            let button = self.defaultButton(title)
            self.itemsArray.append(button)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    override func layoutSubviews() {
        
        self.overlay.frame = UIScreen.mainScreen().applicationFrame
        self.overlay.backgroundColor = UIColor.blackColor().CGColor
        self.overlay.opacity = 0.8
        self.layer.addSublayer(self.overlay)

        for button in itemsArray {
            self.addSubview(button)
        }
        
        //Constraint for self
        let selfBindings = ["rootview": self]
        let viewHeight = self.titles.count * 60
        self.superview?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[rootview]|", options: .allZeros, metrics: nil, views:selfBindings))
        self.superview?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-64-[rootview(==\(viewHeight))]", options: .allZeros, metrics: nil, views:selfBindings))
        
        //Assign constraint for each item(button)
        for (idx, button) in enumerate(itemsArray) {
            
            let buttonHeight = NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: ITEM_HEIGHT)
            let pinLeft = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0)
            
            self.addConstraint(itemWidthConstraint(button, targetView: self))
            self.addConstraint(buttonHeight)
            self.addConstraint(pinLeft)
            self.addConstraint(vAlignmentConstraint(button, targetView:itemsArray[idx-1], buttonIndex:idx))
        }
        
        //update layout when attached on superview
        self.setNeedsUpdateConstraints()
    }
    
    func showFromView() {
        
    }
    
    //MARK: - Constraint creation methods
    private func itemWidthConstraint(sourceView:UIView, targetView:UIView) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: sourceView, attribute: .Width, relatedBy: .Equal, toItem: targetView, attribute: .Width, multiplier: 1, constant: 0)
    }
    
    private func vAlignmentConstraint(sourceView:UIView, targetView:UIView, buttonIndex:Int) -> NSLayoutConstraint {
        //Pin first button to top of superview
        if buttonIndex == 0 {
            return NSLayoutConstraint(item: sourceView, attribute: .Top, relatedBy: .Equal, toItem: self,
                attribute: .Top, multiplier:1, constant: 0)
        } else { //Pin other buttons to the bottom of the previous button
            return NSLayoutConstraint(item: sourceView, attribute: .Top, relatedBy: .Equal, toItem: targetView, attribute: .Bottom, multiplier:1, constant: 0)
        }
        
    }
    
    //MARK: - Utility methods
    private func defaultButton(title:String) -> UIButton {
        let button = UIButton.buttonWithType(.Custom) as UIButton
        button.setTitle(title, forState: .Normal)
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        button.titleLabel!.font = UIFont.boldSystemFontOfSize(16.0)
        button.titleLabel!.textAlignment = .Center
        button.setTitleColor(AZRagicSwiftUtils.colorFromHexString("#636363"), forState: .Normal)
        button.backgroundColor = UIColor.whiteColor()
        button.userInteractionEnabled = true
        return button
    }
    
    func itemAtIndex(index:Int) -> UIButton {
        return self.itemsArray[index]
    }
    
    private func defaultSeperator(_ hexColor:NSString = "#E0DDDD") -> UIView {
        let seperator = UIView()
        seperator.setTranslatesAutoresizingMaskIntoConstraints(false)
        println("adding colored line \(hexColor)")
        seperator.backgroundColor = AZRagicSwiftUtils.colorFromHexString(hexColor)
        return seperator
    }
    
    func attachMethodTo(target: AnyObject, forItemIndex index: Int, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        let button = self.itemsArray[index]
        button.addTarget(target, action: action, forControlEvents: controlEvents)
    }
    
}


enum DropdownSeperatorStyle {
    case Singleline, None
}



