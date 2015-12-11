//
//  BasicAuthLoginViewController.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/14.
//  Copyright (c) 2014年 Labcule. All rights reserved.
//

import UIKit

/**
  Actual login view controller for the app.
 */
class BasicAuthLoginViewController: UIViewController {
    
    /// The base view that contains the username and password field
    var tableView:UITableView?
    
    var accountField:UITextField?
    
    var passwordField:UITextField?
    
    let cellKey = "inputCell"
    
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
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.backgroundColor = UIColor.whiteColor()
        tempTableView.separatorStyle = .SingleLine
        tempTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellKey)

        self.tableView = tempTableView
        self.view.addSubview(tempTableView)
        
        let bindings = ["tempTableView":tempTableView]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tempTableView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-6-[tempTableView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[tempTableView]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Services methods
    
    /**
      Called when back button is pressed. Would cancel login operation.
     */
    func back(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
      Called if user info is input correctly. Asking the service class to login.
     */
    func login() {
        let client:RagicClient = RagicClient()
        client.delegate = self;
        client.login(self.accountField!.text!, password: self.passwordField!.text!)
    }
    
    /**
      Validate the account and password provided by the user.
    
      :return: Boolean value indicating whether the validation is passed or not.
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
    
    /**
      Called when login button is pressed.
     */
    func loginButtonPressed(){
        SVProgressHUD.showWithStatus("Loading", maskType: .Gradient)
        if self.isFormValid() {
            self.login()
            self.passwordField?.resignFirstResponder()
        } else {
            SVProgressHUD.showErrorWithStatus("Username or password is wrong")
        }
    }
    
    private func dispatchToMainView() {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        let controller:TabFolderViewController = TabFolderViewController()
        let nav:UINavigationController = UINavigationController(rootViewController: controller)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDataSource
extension BasicAuthLoginViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellKey)!

        cell.selectionStyle = .None
        switch (indexPath.row) {
        case 0:
            let field:UITextField = UITextField()
            field.translatesAutoresizingMaskIntoConstraints = false
            field.placeholder = "email address"
            field.autocapitalizationType = .None
            field.keyboardType = .EmailAddress
            self.accountField = field;
            cell.contentView.addSubview(self.accountField!)
            let bindings = ["field":field]
            cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-12-[field]-12-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
            cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[field(>=40)]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
        case 1:
            let field = UITextField()
            field.translatesAutoresizingMaskIntoConstraints = false
            field.placeholder = "password"
            field.secureTextEntry = true
            self.passwordField = field
            cell.contentView.addSubview(self.passwordField!)
            let bindings = ["field":field]
            cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-12-[field]-12-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
            cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[field(>=40)]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
        default:
            break;
        }
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension BasicAuthLoginViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
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

// MARK: - ClientDelegate
extension BasicAuthLoginViewController : ClientDelegate {
    
    func loginFinishedWithStatusCode(code: String, result: Dictionary<String, AnyObject>?) {
        if code == "success" {
            dispatch_async(dispatch_get_main_queue(), { self.dispatchToMainView()})
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                SVProgressHUD.dismiss()
                SVProgressHUD.showErrorWithStatus("Login failed")
            })
        }
    }
}
