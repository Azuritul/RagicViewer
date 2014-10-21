//
//  EntryListViewController.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/17.
//  Copyright (c) 2014年 Labcule. All rights reserved.
//

import UIKit

@objc
class EntryListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, ClientDelegate {
    
    var tableView:UITableView?
    var dataDict:[String:AnyObject]?
    var url:String
    
    init(url:String) {
        self.url = url
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
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableView.delegate = self
        tableView.dataSource = self
        
        let bindings = ["tableView":tableView]
        self.tableView = tableView
        self.view.addSubview(tableView)
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: .allZeros, metrics: nil, views: bindings))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options: .allZeros, metrics: nil, views: bindings))
        
        self.loadData()
        SVProgressHUD.showWithMaskType(.Gradient)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Utility methods
    func loadData() {
        let client = RagicClient()
        client.delegate = self;
        client.loadSheet(self.url)
    }
    
    private func detailTextFromResultDict(dict:[String:AnyObject]) -> String? {
        var text:String = ""
        for (key, value) in dict {
            if key.hasPrefix("_") && key.hasSuffix("_") {
                continue
            }
            if value is String {
                text += "\(value)"
                text += "  "
            }
            
        }
        return text
    }
    
    func reloadData(){
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView?.reloadData()
            SVProgressHUD.dismiss()
        })
    }
    

    //MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.dataDict?.count == 0 {
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
        return self.dataDict?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellKey = "keyForCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellKey) as? UITableViewCell
        
        if(cell == nil) {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellKey)
        }

        if let itemDict = self.dataDict as AnyObject? as? [String:AnyObject] {
            
            let item = itemDict.values.array[indexPath.row] as [String:AnyObject]
            //println(item)
            
            //Testing result shows that _index_title_ might be missing in some earlier apps,
            //so here ragic_id would be used for the situation if _index_title_ is missing.
            var title : String? =  item["_index_title_"] as AnyObject? as? String
            var placeholder : Int = item["_ragicId"] as AnyObject? as Int
            
            cell?.backgroundColor = UIColor.clearColor()
            cell?.textLabel.font = UIFont(name: "HelveticaNeue", size: 16.0)
            cell?.textLabel.textColor = AZRagicSwiftUtils.colorFromHexString("#636363")
            cell?.textLabel.highlightedTextColor = UIColor.lightGrayColor()
            cell?.selectedBackgroundView = UIView()
            cell?.detailTextLabel?.font = UIFont(name: "HelveticaNeue", size: 10)
            cell?.detailTextLabel?.textColor = UIColor.lightGrayColor()
            cell?.detailTextLabel?.numberOfLines = 2
            cell?.detailTextLabel?.lineBreakMode = .ByWordWrapping;
            cell?.textLabel.text = title ?? "\(placeholder)"
            cell?.detailTextLabel?.text = self.detailTextFromResultDict(item)
        }
        
        return cell!;
    }
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
   
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
        if let itemDict = self.dataDict as AnyObject? as? [String:AnyObject] {
            let item = itemDict.values.array[indexPath.row] as [String:AnyObject]
            println(item)
            if let nodeId = item["_ragicId"] as AnyObject? as Int! {
                let detailViewURL = "\(self.url)/\(nodeId).xhtml"
                println(detailViewURL)
                let webViewController = LeafViewController(url: detailViewURL)
                self.navigationController?.pushViewController(webViewController, animated: true)
            }
            
        }
    }
    
    //MARK: ClientDelegate
    func loadFinishedWithResult(result: Dictionary<String, AnyObject>?) {
        if result != nil {
            self.dataDict = result
            self.reloadData()
            self.navigationController?.hidesBarsOnSwipe = result?.count > 10
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                SVProgressHUD.dismiss()
            })
        }
    }
    
}
