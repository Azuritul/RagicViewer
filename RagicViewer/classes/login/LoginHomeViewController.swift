//
//  LoginHomeViewController.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/14.
//

import UIKit

/**
  Welcome page of the app.
 */
@objc
class LoginHomeViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let imageView:UIImageView = UIImageView(image:UIImage(named:"titleImage.JPG"))
        let blurEffect:UIBlurEffect = UIBlurEffect(style:.extraLight)
        let blurView:UIVisualEffectView = UIVisualEffectView(effect:blurEffect)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        //Configure title label
        let titleLabel:UILabel = UILabel()
        titleLabel.text = "Ragic Viewer"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 34)
        titleLabel.textColor = AZRagicSwiftUtils.colorFromHexString(hexString: "#D70700")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        //Configure subtitle
        let subtitle:UILabel = UILabel()
        subtitle.text = "An Unofficial Viewer for Ragic Cloud DB"
        subtitle.font = UIFont.boldSystemFont(ofSize: 13)
        subtitle.textColor = AZRagicSwiftUtils.colorFromHexString(hexString: "#B0B0B0")
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        
        //Configure login button
        let button:UIButton = UIButton(type: UIButtonType.system)
        button.setTitle("Login", for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action:#selector(LoginHomeViewController.loginPressed), for:UIControlEvents.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = AZRagicSwiftUtils.colorFromHexString(hexString: "#D70700")
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.alpha = 0.9
        
        self.view.addSubview(imageView)
        self.view.addSubview(blurView)
        self.view.addSubview(button)
        self.view.addSubview(titleLabel)
        self.view.addSubview(subtitle)
        self.view.backgroundColor = UIColor.white
        
        //Setup constraints
        let bindings = ["imageView": imageView,"blurView":blurView,
            "titleLabel":titleLabel, "subtitle":subtitle, "button":button]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[blurView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[blurView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))

        //View constraints for title label
        self.view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: -80))
        
        //View constraints for subtitle
        self.view.addConstraint(NSLayoutConstraint(item: subtitle, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[titleLabel]-6-[subtitle]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        
        //View constraints for login button
        self.view.addConstraint(NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[button]-40-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[button(==52)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
    }
    
    /**
      Called when login button is pressed.
     */
    func loginPressed() {
        let tabs:BasicAuthLoginViewController = BasicAuthLoginViewController()
        let nav:UINavigationController = UINavigationController(rootViewController: tabs)
        nav.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(nav, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
