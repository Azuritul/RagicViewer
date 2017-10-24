//
//  AZUSimpleDropdownMenu.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/23.
//

import UIKit

/**
  View class for the dropdown menu. Currently using UIButton as selectable objects in the menu.
 */
@objc
class AZUSimpleDropdownMenu : UIView, UIGestureRecognizerDelegate {
    
    private let seperator:DropdownSeperatorStyle = .None
    
    /// The dark overlay behind the menu
    private let overlay:UIView = UIView()

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
        self.backgroundColor = UIColor.clear
        self.alpha = 0.95;
        self.translatesAutoresizingMaskIntoConstraints = false
        for title in titles {
            let button = createButton(title: title)
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

        for (_, button) in itemsArray.enumerated() {
            self.bringSubview(toFront: button)
        }

    }
    
    private func setupOverlay(){
        let frame = UIScreen.main.applicationFrame
        self.overlay.frame = CGRect(x:frame.origin.x, y:frame.origin.y, width: frame.size.width, height: frame.size.height * 2)
        self.overlay.backgroundColor = UIColor.black
        self.overlay.alpha = 0
        self.overlay.isUserInteractionEnabled = true

        self.addSubview(self.overlay)
    }

    func close(gestureRecognizer: UITapGestureRecognizer? = nil){
        print("overlay 2 tapped")
    }
    
    private func setupInitialLayout(){
        
        let selfBindings = ["rootview": self]
        let viewHeight = CGFloat(self.titles.count * 60)
        
        // Initialize an array to store the constraints
        var constraintsArray = NSLayoutConstraint.constraints(withVisualFormat: "H:|[rootview]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views:selfBindings)
        
        self.dropdownConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.superview, attribute: .top, multiplier: 1, constant: 64)
        let height = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: viewHeight)
        
        constraintsArray.append(self.dropdownConstraint!)
        constraintsArray.append(height)
        
        self.superview?.addConstraints(constraintsArray)
        
    }
    
    private func setupButtonLayout(){
        
        for (idx, button) in itemsArray.enumerated() {
            
            let buttonHeight = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: ITEM_HEIGHT)
            let pinLeft = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
            
            self.addConstraint(itemWidthConstraint(sourceView: button, targetView: self))
            self.addConstraint(buttonHeight)
            self.addConstraint(pinLeft)
            if idx == 0 {
                self.addConstraint(vAlignmentConstraint(sourceView: button, targetView:nil, buttonIndex:idx))
            } else {
                self.addConstraint(vAlignmentConstraint(sourceView: button, targetView:itemsArray[idx-1], buttonIndex:idx))
            }
        }
        self.isSetUpFinished = true
        
    }
    
    //MARK: - Constraint creation methods
    private func itemWidthConstraint(sourceView:UIView, targetView:UIView) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: sourceView, attribute: .width, relatedBy: .equal, toItem: targetView, attribute: .width, multiplier: 1, constant: 0)
    }
    
    private func vAlignmentConstraint(sourceView:UIView, targetView:UIView?, buttonIndex:Int) -> NSLayoutConstraint {
        //Pin first button to top of superview
        if buttonIndex == 0 {
            return NSLayoutConstraint(item: sourceView, attribute: .top, relatedBy: .equal, toItem: self,
                attribute: .top, multiplier:1, constant: 0)
        } else { //Pin other buttons to the bottom of the previous button
            return NSLayoutConstraint(item: sourceView, attribute: .top, relatedBy: .equal, toItem: targetView!, attribute: .bottom, multiplier:1, constant: 0)
        }
    }
    
    //MARK: - Utility methods
    private func createButton(title:String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 16.0)
        button.titleLabel!.textAlignment = .center
        button.setTitleColor(AZRagicSwiftUtils.colorFromHexString(hexString: "#636363"), for: .normal)
        button.backgroundColor = UIColor.white
        button.isUserInteractionEnabled = true
        return button
    }
    
    func attachMethodFor(target: AnyObject, forItemIndex index: Int, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        let button = self.itemsArray[index]
        button.addTarget(target, action: action, for: controlEvents)
    }
    
    func showFromView(view:UIView){
        view.addSubview(self)
        
        let transition:CATransition = CATransition()
        transition.duration = 0.2;
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromBottom
        //transition.delegate = self
        transition.setValue("show", forKey: "showAction")
        self.layer.add(transition,forKey: kCATransitionFromBottom)
//        self.userInteractionEnabled = true;
//        let tap:UIGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("close:"))
//        tap.delegate = self
//        self.addGestureRecognizer(tap)
    }
    
    func hideView() {
        self.dropdownConstraint?.constant = -1200
        self.overlay.alpha = 0.0
        
        self.superview?.setNeedsUpdateConstraints()
        
        let transition:CATransition = CATransition()
        transition.duration = 0.2;
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        //transition.delegate = self
        transition.setValue("hide", forKey: "showAction")
        self.layer.add(transition, forKey: kCATransitionFromTop)

    }
    
     func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        switch anim.value(forKey: "showAction") as! String {
            case "show":
                //fade in the background view
                UIView.animate(withDuration: 0.08, animations: {
                    self.overlay.alpha = 0.9
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




