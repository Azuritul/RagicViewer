//
//  AccountListViewController.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/17.
//  Copyright (c) 2014年 Labcule. All rights reserved.
//

import UIKit

@objc
class AccountListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dataArray:NSArray?
    var tableView:UITableView?
    var accountChanged:Bool
    var delegate:AnyObject?
    
    //MARK: - Initializer
    override init() {
        self.accountChanged = false
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dismissButton = UIBarButtonItem(image: UIImage(named: "glyphicons_207_remove_2.png"), style: .Done, target: self, action: "dismissPressed")
        self.navigationItem.rightBarButtonItem = dismissButton;
        self.title = "Switch Account";
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = AZRagicSwiftUtils.colorFromHexString("#D70700")
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
        
        let temp = UITableView()
        temp.setTranslatesAutoresizingMaskIntoConstraints(false)
        temp.delegate = self
        temp.dataSource = self
        
        self.view.addSubview(temp)
        self.tableView = temp;
        let bindings = ["tableView": temp]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: .allZeros, metrics: nil, views: bindings))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options: .allZeros, metrics: nil, views: bindings))
        
        self.loadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    //MARK: - Utility methods
    func dismissPressed(){
        self.dismissViewControllerAnimated(true, completion:{() in
            println(self.accountChanged)
            if(self.accountChanged) {
                self.delegate?.didSwitchToAccount?()
            }
        })
    }
    
    func loadData(){
        var array = NSArray(contentsOfFile:AZRagicSwiftUtils.accountsFilePath())
        self.dataArray = array
        self.tableView?.reloadData()
    }
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellKey = "keyForCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellKey) as? UITableViewCell
        
        if(cell == nil) {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellKey)
        }
        
        let dict = self.dataArray![indexPath.row] as AnyObject? as? [String:AnyObject]
        let name = dict!["account"] as AnyObject? as String
        
        cell?.backgroundColor = UIColor.clearColor()
        cell?.textLabel.font = UIFont(name: "HelveticaNeue", size: 18)
        cell?.textLabel.textColor = AZRagicSwiftUtils.colorFromHexString("#636363")
        cell?.textLabel.highlightedTextColor = UIColor.lightGrayColor()
        cell?.selectedBackgroundView = UIView()
        cell?.textLabel.text = name
        if name == AZRagicSwiftUtils.getUserMainAccount() {
            cell?.accessoryType = .Checkmark
        } else {
            cell?.accessoryType = .None
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var lastAccount = AZRagicSwiftUtils.getUserMainAccount()
        let dict = self.dataArray![indexPath.row] as AnyObject? as? [String:AnyObject]
        let selectedAccount = dict!["account"] as AnyObject? as String
        
        self.accountChanged = !(lastAccount == selectedAccount)
        
        AZRagicSwiftUtils.switchAccount(selectedAccount)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.reloadData()
    }

}

@objc
protocol AccountListViewControllerDelegate {
    func didSwitchToAccount()
}

