//
//  TabFolderViewController.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/15.
//  Copyright (c) 2014年 Labcule. All rights reserved.
//

import UIKit

@objc
class TabFolderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ClientDelegate, AccountListViewControllerDelegate {

    var tableView:UITableView?
    var result:Array<AZRagicSheetItem>?
    var xAxisLayoutConstraint:NSLayoutConstraint?
    var menuWindow:AZUSimpleDropdownMenu?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = false
        self.view.backgroundColor = AZRagicSwiftUtils.colorFromHexString("#F0F0F2")
        var moreButton = UIBarButtonItem(image: UIImage(named:"glyphicons_187_more"), style: .Done, target: self, action: "moreButtonPressed")

        self.navigationItem.rightBarButtonItem = moreButton
        self.title = "Ragic Viewer";
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor =  AZRagicSwiftUtils.colorFromHexString("#D70700")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let tableView = UITableView()
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = false;
        tableView.backgroundColor = AZRagicSwiftUtils.colorFromHexString("#F0F0F2")
        tableView.separatorStyle = .SingleLine;
        self.tableView = tableView;
        self.view.addSubview(tableView)
        
        let tableViewBindings = ["tableView": tableView]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: .allZeros, metrics: nil, views: tableViewBindings))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options: .allZeros, metrics: nil, views: tableViewBindings))
        
        SVProgressHUD.showWithMaskType(.Gradient)
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.hidesBarsOnSwipe = false;
    }
    
    // MARK: - Utility methods
    func popSwitchAccountController() {
        let accountsViewController = AccountListViewController()
        let navigationController = UINavigationController(rootViewController: accountsViewController)
        let presentation = accountsViewController.popoverPresentationController
        
        accountsViewController.delegate = self
        navigationController.modalPresentationStyle = .Popover
        presentation?.permittedArrowDirections = .Any
        presentation?.sourceView = self.menuWindow
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func moreButtonPressed(){
        if (self.menuWindow?.isDescendantOfView(self.view) == true ) {
            self.menuWindow?.hideView()
            
        } else {
            let menu = AZUSimpleDropdownMenu(frame: self.view.frame, titles: ["Switch Account", "Logout"])
            
            menu.attachMethodTo(self, forItemIndex: 0, action: "popSwitchAccountController", forControlEvents: .TouchUpInside)
            menu.attachMethodTo(self, forItemIndex: 1, action: "confirmLogout", forControlEvents: .TouchUpInside)
            
            self.menuWindow = menu
            self.menuWindow?.showFromView(self.view)
            
        }
    }
    
    func confirmLogout() {
        let alertController = UIAlertController(title:"Logout", message:"Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
            (alert: UIAlertAction!) in
                AZRagicSwiftUtils.removeUserInfo()
                self.forwardToLoginView()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (alert: UIAlertAction!) in } )
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func forwardToLoginView() {
        let controller = LoginHomeViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.hidden = true
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func loadData() {
        let client = RagicClient()
        client.delegate = self
        client.loadTopLevel()
    }
    
    func reloadTable() {
        dispatch_async(dispatch_get_main_queue(), { self.reload() } )
    }
    
    func reload() {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        self.tableView?.reloadData()
    }
    
    // MARK: - ClientDelegate
    func loadFinishedWithResult(result: Dictionary<String, AnyObject>?) {
        if result != nil {
            var resultArray:Array<AZRagicSheetItem> = [AZRagicSheetItem]()
            let account:String! = AZRagicSwiftUtils.getUserMainAccount()
            for key in result!.keys {
                let extractedItem = result![key]! as Dictionary<String, AnyObject>
                var item = AZRagicSheetItem.createSheetItem(fromDictionary: extractedItem, forKey: key, andAccount: account)
                resultArray.append(item)
                
            }
            if self.result?.count > 0 {
                self.result?.removeAll(keepCapacity: false)
            }
            if self.result == nil {
                self.result = [AZRagicSheetItem]()
            }
            self.result! += resultArray
            self.reloadTable()
        }
        
    }

    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellKey = "cellKey"
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellKey) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellKey)
        }
        
        let sheetItem:AZRagicSheetItem? = self.result?[indexPath.row]
        let label = cell?.textLabel
        if sheetItem != nil {
            cell?.backgroundColor = UIColor.clearColor()
            cell?.selectedBackgroundView = UIView()
            cell?.accessoryType = .DisclosureIndicator
            label?.font = UIFont(name: "HelveticaNeue", size: 16.0)
            label?.textColor = AZRagicSwiftUtils.colorFromHexString("#636363")
            label?.highlightedTextColor = UIColor.lightGrayColor()
            
        }
        label?.text = sheetItem?.name
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result?.count ?? 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.result?.count == 0 {
            let messageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            messageLabel.text = "There is currently no data."
            messageLabel.textColor = UIColor.blackColor()
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .Center
            messageLabel.font = UIFont(name: "Palatino-Italic", size: 20)
            messageLabel.sizeToFit()
            self.tableView?.backgroundView = messageLabel
            self.tableView?.separatorStyle = .None
            return 0
        } else {
            self.tableView?.separatorStyle = .SingleLine
            self.tableView?.backgroundView = nil
        }
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if self.tableView != nil {
            let header = UIView()
            let label = UILabel(frame: CGRectMake(self.tableView!.frame.origin.x,
                                                  self.tableView!.frame.origin.y,
                                                  self.tableView!.bounds.size.width, 44))
            label.text = AZRagicSwiftUtils.getUserMainAccount()
            label.font = UIFont.boldSystemFontOfSize(14)
            label.textColor = UIColor.whiteColor()
            label.textAlignment = .Center
            header.backgroundColor = AZRagicSwiftUtils.colorFromHexString("#A12B28")
            header.alpha = 0.9
            header.addSubview(label)
            return header
        }
        return nil
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let item = self.result?[indexPath.row]
        let children = SheetListViewController(array: item!.children!)
        self.navigationController?.pushViewController(children, animated: true)
    }
    
    // MARK: - AccountList Delegate
    func didSwitchToAccount() {
        SVProgressHUD.showWithMaskType(.Gradient)
        self.menuWindow?.hideView()
        self.loadData()
    }

}
