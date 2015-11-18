//
//  AZUSimpleDropdownMenu.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/23.
//  Copyright (c) 2014年 Labcule. All rights reserved.
//

import UIKit

/**
  View class for the dropdown menu. Currently using UIButton as selectable objects in the menu.
 */
class AZUSimpleDropdownMenu : UIView {
    
    private let seperator:DropdownSeperatorStyle = .None
    
    /// The dark overlay behind the menu
    private let overlay:CALayer = CALayer()
    
    /// Array of titles for the menu
    var titles = [String]()
    
    /// Collection of buttons in the dropdown menu
    var itemsArray = [UIButton]()
    
    /// View constraint for the dropdown menu
    private var dropdownConstraint:NSLayoutConstraint?
    
    /// Height for each button
    private let ITEM_HEIGHT:CGFloat = 60.0
    
    /// Property to figure out if initial layout has been configured
    private var isSetUpFinished : Bool
    
    // MARK: - Initializer
    init(frame: CGRect, titles:[String]) {
        self.isSetUpFinished = false
        self.titles = titles
        super.init(frame:frame)
        self.backgroundColor = UIColor.clearColor()
        self.alpha = 0.95;
        self.translatesAutoresizingMaskIntoConstraints = false
        for title in titles {
            let button = createButton(title)
            self.itemsArray.append(button)
        }
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func layoutSubviews() {
        setupOverlay()

        if self.isSetUpFinished == false {
            for button in self.itemsArray {
                button.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(button)
            }
            setupInitialLayout()
            setupButtonLayout()
        }
        
    }
    
    private func setupOverlay(){
        let frame = UIScreen.mainScreen().applicationFrame
        self.overlay.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height * 2)
        self.overlay.backgroundColor = UIColor.blackColor().CGColor
        self.overlay.opacity = 0.0
        self.layer.addSublayer(self.overlay)
    }
    
    private func setupInitialLayout(){
        
        let selfBindings = ["rootview": self]
        let viewHeight = CGFloat(self.titles.count * 60)
        
        // Initialize an array to store the constraints
        var constraintsArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|[rootview]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views:selfBindings)
        
        self.dropdownConstraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: self.superview, attribute: .Top, multiplier: 1, constant: 64)
        let height = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: viewHeight)
        
        constraintsArray.append(self.dropdownConstraint!)
        constraintsArray.append(height)
        
        self.superview?.addConstraints(constraintsArray)
        
    }
    
    private func setupButtonLayout(){
        
        for (idx, button) in itemsArray.enumerate() {
            
            let buttonHeight = NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: ITEM_HEIGHT)
            let pinLeft = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0)
            
            self.addConstraint(itemWidthConstraint(button, targetView: self))
            self.addConstraint(buttonHeight)
            self.addConstraint(pinLeft)
            if idx == 0 {
                self.addConstraint(vAlignmentConstraint(button, targetView:nil, buttonIndex:idx))
            } else {
                self.addConstraint(vAlignmentConstraint(button, targetView:itemsArray[idx-1], buttonIndex:idx))
            }
        }
        self.isSetUpFinished = true
        
    }
    
    //MARK: - Constraint creation methods
    private func itemWidthConstraint(sourceView:UIView, targetView:UIView) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: sourceView, attribute: .Width, relatedBy: .Equal, toItem: targetView, attribute: .Width, multiplier: 1, constant: 0)
    }
    
    private func vAlignmentConstraint(sourceView:UIView, targetView:UIView?, buttonIndex:Int) -> NSLayoutConstraint {
        //Pin first button to top of superview
        if buttonIndex == 0 {
            return NSLayoutConstraint(item: sourceView, attribute: .Top, relatedBy: .Equal, toItem: self,
                attribute: .Top, multiplier:1, constant: 0)
        } else { //Pin other buttons to the bottom of the previous button
            return NSLayoutConstraint(item: sourceView, attribute: .Top, relatedBy: .Equal, toItem: targetView!, attribute: .Bottom, multiplier:1, constant: 0)
        }
    }
    
    //MARK: - Utility methods
    private func createButton(title:String) -> UIButton {
        let button = UIButton(type: .Custom)
        button.setTitle(title, forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel!.font = UIFont.boldSystemFontOfSize(16.0)
        button.titleLabel!.textAlignment = .Center
        button.setTitleColor(AZRagicSwiftUtils.colorFromHexString("#636363"), forState: .Normal)
        button.backgroundColor = UIColor.whiteColor()
        button.userInteractionEnabled = true
        return button
    }
    
    func attachMethodFor(target: AnyObject, forItemIndex index: Int, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        let button = self.itemsArray[index]
        button.addTarget(target, action: action, forControlEvents: controlEvents)
    }
    
    func showFromView(view:UIView){
        view.addSubview(self)
        
        let transition:CATransition = CATransition()
        transition.duration = 0.2;
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromBottom
        transition.delegate = self
        transition.setValue("show", forKey: "showAction")
        self.layer.addAnimation(transition,forKey: kCATransitionFromBottom)
    }
    
    func hideView() {
        self.dropdownConstraint?.constant = -1200
        self.overlay.opacity = 0.0
        
        self.superview?.setNeedsUpdateConstraints()
        
        let transition:CATransition = CATransition()
        transition.duration = 0.2;
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        transition.delegate = self
        transition.setValue("hide", forKey: "showAction")
        self.layer.addAnimation(transition, forKey: kCATransitionFromTop)

    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        switch anim.valueForKey("showAction") as! String {
            case "show":
                //fade in the background view
                UIView.animateWithDuration(0.08, animations: {
                    self.overlay.opacity = 0.95
                })
            case "hide":
                self.removeFromSuperview()
            default:
                break
        }
    }
    
}

enum DropdownSeperatorStyle {
    case Singleline, None
}




