//
//  AccountListViewController.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/17.
//

import UIKit

@objc
class AccountListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dataArray:NSArray?
    var tableView:UITableView?
    var accountChanged:Bool
    var delegate:AnyObject?
    
    //MARK: - Initializer
     init() {
        self.accountChanged = false
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismissButton = UIBarButtonItem(image: UIImage(named: "glyphicons_207_remove_2.png"), style: .done, target: self, action: #selector(AccountListViewController.dismissPressed))
        self.navigationItem.rightBarButtonItem = dismissButton;
        self.title = "Switch Account";
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = AZRagicSwiftUtils.colorFromHexString(hexString: "#D70700")
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white];
        
        let temp = UITableView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.delegate = self
        temp.dataSource = self
        
        self.view.addSubview(temp)
        self.tableView = temp;
        let bindings = ["tableView": temp]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
        
        self.loadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    //MARK: - Utility methods
    @objc func dismissPressed(){
        self.dismiss(animated: true, completion:{() in
            if(self.accountChanged) {
                self.delegate?.didSwitchToAccount?()
            }
        })
    }
    
    func loadData(){
        let array = NSArray(contentsOfFile:AZRagicSwiftUtils.accountsFilePath())
        self.dataArray = array
        self.tableView?.reloadData()
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellKey = "keyForCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellKey)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellKey)
        }
        
        let dict = self.dataArray![indexPath.row] as AnyObject? as? [String:AnyObject]
        let name = dict!["account"] as AnyObject? as! String
        
        let label = cell?.textLabel
        cell?.backgroundColor = UIColor.clear
        label?.font = UIFont(name: "HelveticaNeue", size: 18)
        label?.textColor = AZRagicSwiftUtils.colorFromHexString(hexString: "#636363")
        label?.highlightedTextColor = UIColor.lightGray
        cell?.selectedBackgroundView = UIView()
        label?.text = name
        cell?.accessoryType = (AZRagicSwiftUtils.getUserMainAccount() == name) ? .checkmark : .none
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lastAccount = AZRagicSwiftUtils.getUserMainAccount()
        let dict = self.dataArray![indexPath.row] as AnyObject? as? [String:AnyObject]
        let selectedAccount = dict!["account"] as AnyObject? as! String
        
        self.accountChanged = !(lastAccount == selectedAccount)
        
        AZRagicSwiftUtils.switchAccount(newAccount: selectedAccount)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        tableView.reloadData()
    }

}

@objc
protocol AccountListViewControllerDelegate {
    func didSwitchToAccount()
}

