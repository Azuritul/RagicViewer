//
//  EntryListViewController.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/17.
//

import UIKit

@objc
class EntryListViewController: UIViewController {
    
    var tableView:UITableView?
    var dataArray:Array<AnyObject> = []
    var url:String
    let cellKey = "keyForCell"

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
        tableView.backgroundColor = AZRagicSwiftUtils.colorFromHexString(hexString: "#F0F0F2")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self,forCellReuseIdentifier: cellKey)
        let button:UIButton = UIButton(type: .custom)
        button.frame = CGRect(x: 0,y: 0,width: 320, height: 44)
        button.backgroundColor = AZRagicSwiftUtils.colorFromHexString(hexString: "#D70700")
        button.setTitle("Load more...", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(EntryListViewController.loadMore), for: .touchUpInside)
        tableView.tableFooterView = button

        let bindings = ["tableView":tableView]
        self.tableView = tableView

        self.view.addSubview(tableView)
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: bindings))
        
        self.loadData(offset: 0, count: 20)
        SVProgressHUD.show(with: .gradient)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Utility methods
    func loadData(offset:Int, count:Int) {
        let client = RagicClient.sharedInstance
        client.delegate = self;
        client.loadEntries(entryUrl: self.url, offset:offset, count:count)
    }

    @objc func loadMore() {
        SVProgressHUD.show(with: .gradient)
        self.loadData(offset: self.dataArray.count + 1, count: 20)
    }
    
    func detailTextFromResultDict(dict:[String:AnyObject]) -> String? {
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
        DispatchQueue.main.async {
            self.tableView?.reloadData()
            self.tableView?.flashScrollIndicators()
            SVProgressHUD.dismiss()
        }
    }

}

//MARK: - UITableViewDataSource
extension EntryListViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.dataArray.isEmpty {
            let messageLabel = UILabel(frame: CGRect(x:0, y:0, width:self.view.bounds.size.width, height:self.view.bounds.size.height))
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        if let cell = tableView.dequeueReusableCell(withIdentifier: cellKey) {
            
            let item = self.dataArray[indexPath.row] as! [String:AnyObject]
            
            //Testing result shows that _index_title_ might be missing in some earlier apps,
            //so here ragic_id would be used for the situation if _index_title_ is missing.
            let title: String? = item["_index_title_"] as AnyObject? as? String
            let placeholder: Int = item["_ragicId"] as AnyObject? as! Int
            
            let label = cell.textLabel
            let detailLabel = cell.detailTextLabel
            cell.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = UIView()
            
            label?.font = UIFont(name: "HelveticaNeue", size: 16.0)
            label?.textColor = AZRagicSwiftUtils.colorFromHexString(hexString: "#636363")
            label?.highlightedTextColor = UIColor.lightGray
            label?.text = title ?? "\(placeholder)"
            
            detailLabel?.font = UIFont(name: "HelveticaNeue", size: 10)
            detailLabel?.textColor = UIColor.lightGray
            detailLabel?.numberOfLines = 2
            detailLabel?.lineBreakMode = .byWordWrapping;
            detailLabel?.text = self.detailTextFromResultDict(dict: item)
            return cell
        }
        
        return UITableViewCell()

    }

}


//MARK: - UITableViewDelegate
extension EntryListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView?.deselectRow(at: indexPath as IndexPath, animated: true)
            let item = self.dataArray[indexPath.row] as! [String:AnyObject]
            if let nodeId = item["_ragicId"] as AnyObject? as! Int! {
                let detailViewURL = "\(self.url)/\(nodeId).xhtml"
                let webViewController = LeafViewController(url: detailViewURL)
                self.navigationController?.pushViewController(webViewController, animated: true)
            }
    }
}


// MARK: - ClientDelegate
extension EntryListViewController: ClientDelegate {

    func loadFinishedWithResult(result: Dictionary<String, AnyObject>?) {
        if let result = result {
            let sortedKeys  = result.keys.sorted();
            for key in sortedKeys {
                self.dataArray.append(result[key]!)
            }
            self.navigationController?.hidesBarsOnSwipe = result.count > 10
            self.reloadData()
            if(self.dataArray.count < 20) {
                self.tableView?.tableFooterView?.isHidden = true
            } else {
                self.tableView?.tableFooterView?.isHidden = false
            }
        } else {
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
        }
    }

    func loginFinishedWithStatusCode(code:String, result:Dictionary<String, AnyObject>?) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
}
