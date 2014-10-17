//
//  LoginHomeViewController.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/14.
//  Copyright (c) 2014年 Labcule. All rights reserved.
//

import UIKit

@objc
class LoginHomeViewController: UIViewController {
    
    var tableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var imageView:UIImageView = UIImageView(image:UIImage(named:"titleImage.JPG"))
        let blurEffect:UIBlurEffect = UIBlurEffect(style:.ExtraLight)
        let blurView:UIVisualEffectView = UIVisualEffectView(effect:blurEffect)
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        blurView.setTranslatesAutoresizingMaskIntoConstraints(false)

        //Configure title label
        var titleLabel:UILabel = UILabel()
        titleLabel.text = "Ragic Viewer"
        titleLabel.font = UIFont.boldSystemFontOfSize(34)
        titleLabel.textColor = AZRagicSwiftUtils.colorFromHexString("#D70700")
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)

        //Configure subtitle
        var subtitle:UILabel = UILabel()
        subtitle.text = "An Unofficial Viewer for Ragic Cloud DB"
        subtitle.font = UIFont.boldSystemFontOfSize(13)
        subtitle.textColor = AZRagicSwiftUtils.colorFromHexString("#B0B0B0")
        subtitle.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        //Configure login button
        var button:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.setTitle("Login", forState:.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(self, action:"loginOption", forControlEvents:UIControlEvents.TouchUpInside)
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        button.backgroundColor = AZRagicSwiftUtils.colorFromHexString("#D70700")
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        button.alpha = 0.9
        
        self.view.addSubview(imageView)
        self.view.addSubview(blurView)
        self.view.addSubview(button)
        self.view.addSubview(titleLabel)
        self.view.addSubview(subtitle)
        self.view.backgroundColor = UIColor.whiteColor()
        
        //Setup constraints
        var bindings = ["imageView":imageView, "blurView":blurView,
                        "titleLabel":titleLabel, "subtitle":subtitle, "button":button]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]|", options: .allZeros, metrics: nil, views: bindings))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[blurView]|", options: .allZeros, metrics: nil, views: bindings))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[blurView]|", options: .allZeros, metrics: nil, views: bindings))

        //View constraints for title label
        self.view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: -80))
        
        //View constraints for subtitle
        self.view.addConstraint(NSLayoutConstraint(item: subtitle, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleLabel]-6-[subtitle]", options: .allZeros, metrics: nil, views: bindings))
        
        //View constraints for login button
        self.view.addConstraint(NSLayoutConstraint(item: button, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-40-[button]-40-|", options: .allZeros, metrics: nil, views: bindings))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[button(==52)]-20-|", options: .allZeros, metrics: nil, views: bindings))
    }
    
    func loginOption() {
        let tabs:BasicAuthLoginViewController = BasicAuthLoginViewController()
        let nav:UINavigationController = UINavigationController(rootViewController: tabs)
        nav.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
