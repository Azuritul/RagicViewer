//
//  EntryListViewController.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/17.
//  Copyright (c) 2014年 Labcule. All rights reserved.
//

import UIKit

@objc
class EntryListViewController: UIViewController {
    
    var tableView:UITableView?
    var dataArray:Array<AnyObject> = []
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

        let button:UIButton = UIButton.buttonWithType(.Custom) as UIButton
        button.frame = CGRectMake(0,0,320,44)
        button.backgroundColor = AZRagicSwiftUtils.colorFromHexString("#D70700")
        button.setTitle("Load more...", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(self, action: "loadMore", forControlEvents: .TouchUpInside)
        tableView.tableFooterView = button

        let bindings = ["tableView":tableView]
        self.tableView = tableView
        self.view.addSubview(tableView)
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: .allZeros, metrics: nil, views: bindings))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options: .allZeros, metrics: nil, views: bindings))
        
        self.loadData(0, count: 20)
        SVProgressHUD.showWithMaskType(.Gradient)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Utility methods
    func loadData(offset:Int, count:Int) {
        let client = RagicClient()
        client.delegate = self;
        client.loadEntries(self.url, offset:offset, count:count)
    }

    func loadMore() {
        SVProgressHUD.showWithMaskType(.Gradient)
        self.loadData(self.dataArray.count + 1, count: 20)
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
            self.tableView?.flashScrollIndicators()
            SVProgressHUD.dismiss()
        })
    }

}

//MARK: - UITableViewDataSource
extension EntryListViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.dataArray.isEmpty {
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
        return self.dataArray.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellKey = "keyForCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellKey) as? UITableViewCell

        if (cell == nil) {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellKey)
        }

        let item = self.dataArray[indexPath.row] as [String:AnyObject]

        //Testing result shows that _index_title_ might be missing in some earlier apps,
        //so here ragic_id would be used for the situation if _index_title_ is missing.
        var title: String? = item["_index_title_"] as AnyObject? as? String
        var placeholder: Int = item["_ragicId"] as AnyObject? as Int

        let label = cell?.textLabel
        let detailLabel = cell?.detailTextLabel
        cell?.backgroundColor = UIColor.clearColor()
        cell?.selectedBackgroundView = UIView()

        label?.font = UIFont(name: "HelveticaNeue", size: 16.0)
        label?.textColor = AZRagicSwiftUtils.colorFromHexString("#636363")
        label?.highlightedTextColor = UIColor.lightGrayColor()
        label?.text = title ?? "\(placeholder)"

        detailLabel?.font = UIFont(name: "HelveticaNeue", size: 10)
        detailLabel?.textColor = UIColor.lightGrayColor()
        detailLabel?.numberOfLines = 2
        detailLabel?.lineBreakMode = .ByWordWrapping;
        detailLabel?.text = self.detailTextFromResultDict(item)
        return cell!;
    }
}


//MARK: - UITableViewDelegate
extension EntryListViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
            let item = self.dataArray[indexPath.row] as [String:AnyObject]
            if let nodeId = item["_ragicId"] as AnyObject? as Int! {
                let detailViewURL = "\(self.url)/\(nodeId).xhtml"
                let webViewController = LeafViewController(url: detailViewURL)
                self.navigationController?.pushViewController(webViewController, animated: true)
            }
    }
}


// MARK: - ClientDelegate
extension EntryListViewController: ClientDelegate {

    func loadFinishedWithResult(result: Dictionary<String, AnyObject>?) {
        if result != nil {
            for(key, value) in result! {
                self.dataArray.append(value)
            }
            self.navigationController?.hidesBarsOnSwipe = result?.count > 10
            self.reloadData()
            if(self.dataArray.count < 20) {
                self.tableView?.tableFooterView?.hidden = true
            } else {
                self.tableView?.tableFooterView?.hidden = false
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                SVProgressHUD.dismiss()
            })
        }
    }

    func loginFinishedWithStatusCode(code:String, result:Dictionary<String, AnyObject>?) {
        dispatch_async(dispatch_get_main_queue(), {
            SVProgressHUD.dismiss()
        })
    }
}