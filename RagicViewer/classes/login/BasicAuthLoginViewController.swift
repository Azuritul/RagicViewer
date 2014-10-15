//
//  BasicAuthLoginViewController.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/14.
//  Copyright (c) 2014年 Labcule. All rights reserved.
//

import UIKit

class BasicAuthLoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RagicClientDelegate {
    
    var tableView:UITableView?
    var accountField:UITextField?
    var passwordField:UITextField?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let customBarItem = UIBarButtonItem(title: "Back", style: .Done, target: self, action: "back")
        let loginBarItem = UIBarButtonItem(title: "Login", style: .Done, target: self, action: "loginButtonPressed")
        
        self.navigationItem.leftBarButtonItem = customBarItem
        self.navigationItem.rightBarButtonItem = loginBarItem
        self.navigationItem.title = "RagicViewer"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.barTintColor = AZRagicSwiftUtils.colorFromHexString("#D70700")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
        
        self.view.backgroundColor = UIColor.whiteColor();
        let tempTableView = UITableView(frame: CGRectZero, style:.Grouped)
        tempTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.backgroundColor = UIColor.whiteColor()
        tempTableView.separatorStyle = .SingleLine
        self.tableView = tempTableView
        self.view.addSubview(tempTableView)
        
        let bindings = ["tempTableView":tempTableView]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tempTableView]|", options: .allZeros, metrics: nil, views: bindings))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-6-[tempTableView]|", options: .allZeros, metrics: nil, views: bindings))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[tempTableView]", options: .allZeros, metrics: nil, views: bindings))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: Services
    func back(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func login() {
        let client:AZRagicClient = AZRagicClient()
        client.delegate = self;
        client.loginWithUsername(self.accountField?.text, password: self.passwordField?.text)
    }
    
    
    /**
     * Validate form field
     */
    func isFormValid() -> Bool {

        let account:String? = self.accountField?.text
        let password:String? = self.passwordField?.text
        
        if account == nil || password == nil {
            return false;
        }
        
        if account!.rangeOfString("@") == nil {
            return false;
        }
        return true;
    }
    
    func loginButtonPressed(){
        SVProgressHUD.showWithStatus("Loading", maskType: .Gradient)
        if self.isFormValid() {
            self.login()
            self.passwordField?.resignFirstResponder()
        } else {
            SVProgressHUD.showErrorWithStatus("Username or password is wrong")
        }
    }
    
    func loginFinishedWithStatusCode(code: String!, andResult result: [NSObject : AnyObject]!) {
        if(code=="success") {
            dispatch_sync(dispatch_get_main_queue()) { self.dispatchToMainView() }
        } else {
            dispatch_sync(dispatch_get_main_queue()) {
                SVProgressHUD.dismiss();
                SVProgressHUD.showErrorWithStatus("Login failed")
                
            }
        }
    }
    
    func dispatchToMainView() {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        let controller:AZRagicTabFolderTableViewController = AZRagicTabFolderTableViewController()
        let nav:UINavigationController = UINavigationController(rootViewController: controller)
        self.presentViewController(nav, animated: true, completion: nil)
    }

    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellKey = "inputCell"
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellKey) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellKey)
        }
        cell?.selectionStyle = .None
        switch (indexPath.row) {
            case 0:
                var field:UITextField = UITextField()
                field.setTranslatesAutoresizingMaskIntoConstraints(false)
                field.placeholder = "email address"
                field.autocapitalizationType = .None
                field.keyboardType = .EmailAddress
                self.accountField = field;
                cell?.contentView.addSubview(self.accountField!)
                let bindings = ["field":field]
                cell?.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-12-[field]-12-|", options: .allZeros, metrics: nil, views: bindings))
                cell?.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[field(>=40)]|", options: .allZeros, metrics: nil, views: bindings))
            case 1:
                var field = UITextField()
                field.setTranslatesAutoresizingMaskIntoConstraints(false)
                field.placeholder = "password"
                field.secureTextEntry = true
                self.passwordField = field
                cell?.contentView.addSubview(self.passwordField!)
                let bindings = ["field":field]
                cell?.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-12-[field]-12-|", options: .allZeros, metrics: nil, views: bindings))
                cell?.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[field(>=40)]|", options: .allZeros, metrics: nil, views: bindings))
            default:
                break;
        }
        
        return cell!
        
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
}
