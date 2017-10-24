//
//  TabFolderViewController.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/15.
//

import UIKit
import AZDropdownMenu
/**
  The topmost view controller. Showing all the sheets under specific user account.
 */
@objc
class TabFolderViewController: UIViewController {
    
    /// The base view that holds all the data
    var tableView:UITableView?
    
    /// Object to store fetched data
    var result:Array<AZRagicSheetItem>?
    
    /// Layout constraint for dropdown menu
    var xAxisLayoutConstraint:NSLayoutConstraint?
    
    /// The view for dropdown menu
    //var menuWindow:AZUSimpleDropdownMenu?
    var menuWindow:AZDropdownMenu?
    let cellKey = "cellKey"

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = false
        self.view.backgroundColor = AZRagicSwiftUtils.colorFromHexString(hexString: "#F0F0F2")
        let moreButton = UIBarButtonItem(image: UIImage(named:"glyphicons_187_more"), style: .done, target: self, action: #selector(TabFolderViewController.moreButtonPressed))

        self.navigationItem.rightBarButtonItem = moreButton
        self.title = "Ragic Viewer";
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor =  AZRagicSwiftUtils.colorFromHexString(hexString: "#D70700")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.isOpaque = false;
        tableView.backgroundColor = AZRagicSwiftUtils.colorFromHexString(hexString: "#F0F0F2")
        tableView.separatorStyle = .singleLine;
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellKey)
        self.tableView = tableView;
        self.view.addSubview(tableView)
        
        let tableViewBindings = ["tableView": tableView]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: tableViewBindings))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: tableViewBindings))
        
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.show()
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.hidesBarsOnSwipe = false;
    }
    
    // MARK: - Utility methods
    func popSwitchAccountController() {
        let accountsViewController = AccountListViewController()
        let navigationController = UINavigationController(rootViewController: accountsViewController)
        let presentation = accountsViewController.popoverPresentationController
        
        accountsViewController.delegate = self
        navigationController.modalPresentationStyle = .popover
        presentation?.permittedArrowDirections = .any
        presentation?.sourceView = self.menuWindow
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc func moreButtonPressed(){
        if (self.menuWindow?.isDescendant(of: self.view) == true ) {
            //self.menuWindow?.hideView()
            self.menuWindow?.hideMenu()

        } else {
            let menu = AZDropdownMenu(titles: ["Switch Account", "Logout"])
            
            menu.cellTapHandler = { [weak self] (indexPath: IndexPath) -> Void in
                if (indexPath.row == 0) {
                    self?.popSwitchAccountController()
                }
                if (indexPath.row == 1) {
                    self?.confirmLogout()
                }
                
            }
            self.menuWindow = menu
            //self.menuWindow?.showFromView(view: self.view)
            self.menuWindow?.showMenuFromView(self.view)
            
        }
    }
    
    func confirmLogout() {
        let alertController = UIAlertController(title:"Logout", message:"Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (alert: UIAlertAction!) in
                AZRagicSwiftUtils.removeUserInfo()
                self.forwardToLoginView()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (alert: UIAlertAction!) in } )
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func forwardToLoginView() {
        let controller = LoginHomeViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.isHidden = true
        self.present(nav, animated: true, completion: nil)
    }
    
    func loadData() {
        let client = RagicClient.sharedInstance
        client.delegate = self
        client.loadTopLevel()
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            if SVProgressHUD.isVisible() {
                SVProgressHUD.dismiss()
            }
            self.tableView?.reloadData()
        }
    }
    
}

// MARK: - UITableViewDelegate
extension TabFolderViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if self.tableView != nil {
            let header = UIView()
            let label = UILabel(frame: CGRect(x:self.tableView!.frame.origin.x,
                                              y:self.tableView!.frame.origin.y,
                                              width:self.tableView!.bounds.size.width,
                                              height: 44))
            label.text = AZRagicSwiftUtils.getUserMainAccount()
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.textColor = UIColor.white
            label.textAlignment = .center
            header.backgroundColor = AZRagicSwiftUtils.colorFromHexString(hexString: "#A12B28")
            header.alpha = 0.9
            header.addSubview(label)
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let item = self.result?[indexPath.row]
        let children = SheetListViewController(array: item!.children!)
        self.navigationController?.pushViewController(children, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TabFolderViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result?.count ?? 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.result?.count == 0 {
            let messageLabel = UILabel(frame: CGRect(x:0, y:0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            messageLabel.text = "There is currently no data."
            messageLabel.textColor = UIColor.black
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.font = UIFont(name: "Palatino-Italic", size: 20)
            messageLabel.sizeToFit()
            self.tableView?.backgroundView = messageLabel
            self.tableView?.separatorStyle = .none
            return 0
        } else {
            self.tableView?.separatorStyle = .singleLine
            self.tableView?.backgroundView = nil
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellKey) {
            
            let sheetItem:AZRagicSheetItem? = self.result?[indexPath.row]
            let label = cell.textLabel
            if sheetItem != nil {
                cell.backgroundColor = UIColor.clear
                cell.selectedBackgroundView = UIView()
                cell.accessoryType = .disclosureIndicator
                label?.font = UIFont(name: "HelveticaNeue", size: 16.0)
                label?.textColor = AZRagicSwiftUtils.colorFromHexString(hexString: "#636363")
                label?.highlightedTextColor = UIColor.lightGray
                
            }
            label?.text = sheetItem?.name
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - AccountListViewControllerDelegate
extension TabFolderViewController : AccountListViewControllerDelegate {
    func didSwitchToAccount() {
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.show()

        SVProgressHUD.show()
        self.menuWindow?.hideMenu()
        self.loadData()
    }
}

// MARK: - ClientDelegate
extension TabFolderViewController : ClientDelegate {
    
    func loadFinishedWithResult(result: Dictionary<String, AnyObject>?) {
        if result != nil {
            var resultArray:Array<AZRagicSheetItem> = [AZRagicSheetItem]()
            let account:String! = AZRagicSwiftUtils.getUserMainAccount()
            for key in result!.keys {
                let extractedItem = result![key]! as! Dictionary<String, AnyObject>
                let item = AZRagicSheetItem.createSheetItem(fromDictionary: extractedItem, forKey: key, andAccount: account)
                resultArray.append(item)
                
            }
            if let result = self.result {
                if result.count > 0 {
                    self.result?.removeAll(keepingCapacity: false)
                }
            } else {
                self.result = [AZRagicSheetItem]()
            }
            self.result! += resultArray
            self.reloadTable()
        }
    }
}
