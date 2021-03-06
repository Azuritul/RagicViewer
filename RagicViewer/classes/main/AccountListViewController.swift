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
        
        let dismissButton = UIBarButtonItem(image: UIImage(named: "glyphicons_207_remove_2.png"), style: .Done, target: self, action: #selector(AccountListViewController.dismissPressed))
        self.navigationItem.rightBarButtonItem = dismissButton;
        self.title = "Switch Account";
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = AZRagicSwiftUtils.colorFromHexString("#D70700")
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
        
        let temp = UITableView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.delegate = self
        temp.dataSource = self
        
        self.view.addSubview(temp)
        self.tableView = temp;
        let bindings = ["tableView": temp]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
        
        self.loadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    //MARK: - Utility methods
    func dismissPressed(){
        self.dismissViewControllerAnimated(true, completion:{() in
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellKey = "keyForCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellKey)
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellKey)
        }
        
        let dict = self.dataArray![indexPath.row] as AnyObject? as? [String:AnyObject]
        let name = dict!["account"] as AnyObject? as! String
        
        let label = cell?.textLabel
        cell?.backgroundColor = UIColor.clearColor()
        label?.font = UIFont(name: "HelveticaNeue", size: 18)
        label?.textColor = AZRagicSwiftUtils.colorFromHexString("#636363")
        label?.highlightedTextColor = UIColor.lightGrayColor()
        cell?.selectedBackgroundView = UIView()
        label?.text = name
        cell?.accessoryType = (AZRagicSwiftUtils.getUserMainAccount() == name) ? .Checkmark : .None
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let lastAccount = AZRagicSwiftUtils.getUserMainAccount()
        let dict = self.dataArray![indexPath.row] as AnyObject? as? [String:AnyObject]
        let selectedAccount = dict!["account"] as AnyObject? as! String
        
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

