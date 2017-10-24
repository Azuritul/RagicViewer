//
//  BasicAuthLoginViewController.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/14.
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

        let customBarItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(BasicAuthLoginViewController.back))
        let loginBarItem = UIBarButtonItem(title: "Login", style: .done, target: self, action: #selector(BasicAuthLoginViewController.loginButtonPressed))
        
        self.navigationItem.leftBarButtonItem = customBarItem
        self.navigationItem.rightBarButtonItem = loginBarItem
        self.navigationItem.title = "RagicViewer"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationController?.navigationBar.barTintColor = AZRagicSwiftUtils.colorFromHexString(hexString: "#D70700")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white];
        
        self.view.backgroundColor = UIColor.white;
        let tempTableView = UITableView(frame: CGRect.zero, style:.grouped)
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.backgroundColor = UIColor.white
        tempTableView.separatorStyle = .singleLine
        tempTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellKey)
        tempTableView.rowHeight = 44
        self.tableView = tempTableView
        self.view.addSubview(tempTableView)
        
        let bindings = ["tempTableView":tempTableView]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tempTableView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-6-[tempTableView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[tempTableView]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Services methods
    
    /**
      Called when back button is pressed. Would cancel login operation.
     */
    @objc func back(){
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
      Called if user info is input correctly. Asking the service class to login.
     */
    func login() {
        let client:RagicClient = RagicClient.sharedInstance
        client.delegate = self;
        client.login(username: self.accountField!.text!, password: self.passwordField!.text!)
    }
    
    /**
      Validate the account and password provided by the user.
    
      :return: Boolean value indicating whether the validation is passed or not.
     */
    func isFormValid() -> Bool {

        let account:String? = self.accountField?.text
        let password:String? = self.passwordField?.text
        
        if let account = account, let _ = password {
            if (account.contains("@") == true) {
                return true
            }
        }
        return false
    }
    
    /**
      Called when login button is pressed.
     */
    @objc func loginButtonPressed(){
        SVProgressHUD.show(withStatus: "Loading", maskType: .gradient)
        if self.isFormValid() {
            self.login()
            self.passwordField?.resignFirstResponder()
        } else {
            SVProgressHUD.showError(withStatus: "Username or password is wrong")
        }
    }
    
    func dispatchToMainView() {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        let controller:TabFolderViewController = TabFolderViewController()
        let nav:UINavigationController = UINavigationController(rootViewController: controller)
        self.present(nav, animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDataSource
extension BasicAuthLoginViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellKey)!

        cell.selectionStyle = .none
        switch (indexPath.row) {
        case 0:
            let field:UITextField = UITextField()
            field.translatesAutoresizingMaskIntoConstraints = false
            field.placeholder = "email address"
            field.autocapitalizationType = .none
            field.keyboardType = .emailAddress
            self.accountField = field;
            cell.contentView.addSubview(self.accountField!)
            let bindings = ["field":field]
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[field]-12-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[field(>=40)]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
        case 1:
            let field = UITextField()
            field.translatesAutoresizingMaskIntoConstraints = false
            field.placeholder = "password"
            field.isSecureTextEntry = true
            self.passwordField = field
            cell.contentView.addSubview(self.passwordField!)
            let bindings = ["field":field]
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[field]-12-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[field(>=40)]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
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

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {  }
    
}

// MARK: - ClientDelegate
extension BasicAuthLoginViewController : ClientDelegate {
    
    func loginFinishedWithStatusCode(code: String, result: Dictionary<String, AnyObject>?) {
        if code == "success" {
            DispatchQueue.main.async {
                self.dispatchToMainView()
            }
        } else {
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "Login failed")
            }
        }
    }
}
