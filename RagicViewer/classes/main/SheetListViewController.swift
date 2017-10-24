//
//  SheetListViewController.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/17.
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
        tableView.backgroundColor = AZRagicSwiftUtils.colorFromHexString(hexString: "#F0F0F2")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView = tableView
        self.view.addSubview(tableView)
        
        let bindings = ["tableView": tableView]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: bindings))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.hidesBarsOnSwipe = false
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.dataArray.count == 0 {
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
        let cellKey = "keyForCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellKey)
        
        if(cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellKey)
        }
        
        let item = self.dataArray[indexPath.row]
        
        cell?.backgroundColor = UIColor.clear
        let label = cell?.textLabel
        label?.font = UIFont(name: "HelveticaNeue", size: 16)
        label?.textColor = AZRagicSwiftUtils.colorFromHexString(hexString: "#636363")
        label?.highlightedTextColor = UIColor.lightGray
        cell?.selectedBackgroundView = UIView()
        label?.text = item.name
        return cell!;
    }
    
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let item = self.dataArray[indexPath.row]
        let listingViewController = EntryListViewController(url: item.itemUrl!)
        self.navigationController?.pushViewController(listingViewController, animated: true)
    }

}
