//
//  SheetListViewController.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/17.
//  Copyright (c) 2014年 Labcule. All rights reserved.
//

import UIKit

@objc
class SheetListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView:UITableView?
    var dataArray:[AZRagicSheetItem]
        
    init(array:[AZRagicSheetItem]){
        self.dataArray = array
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Ragic Viewer"
        let tableView = UITableView()
        tableView.backgroundColor = AZRagicSwiftUtils.colorFromHexString("#F0F0F2")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView = tableView
        self.view.addSubview(tableView)
        
        let bindings = ["tableView": tableView]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.hidesBarsOnSwipe = false
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.dataArray.count == 0 {
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellKey = "keyForCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellKey) as? UITableViewCell
        
        if(cell == nil) {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellKey)
        }
        
        let item = self.dataArray[indexPath.row]
        
        cell?.backgroundColor = UIColor.clearColor()
        let label = cell?.textLabel
        label?.font = UIFont(name: "HelveticaNeue", size: 16)
        label?.textColor = AZRagicSwiftUtils.colorFromHexString("#636363")
        label?.highlightedTextColor = UIColor.lightGrayColor()
        cell?.selectedBackgroundView = UIView()
        label?.text = item.name
        return cell!;
    }
    
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let item = self.dataArray[indexPath.row]
        let listingViewController = EntryListViewController(url: item.itemUrl!)
        self.navigationController?.pushViewController(listingViewController, animated: true)
    }

}
