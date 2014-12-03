//
//  BaseViewController.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/27.
//  Copyright (c) 2014年 Labcule. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController{

    
    var tableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        if self.dataArray.count == 0 {
//            let messageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
//            messageLabel.text = "There is currently no data."
//            messageLabel.textColor = UIColor.blackColor()
//            messageLabel.numberOfLines = 0
//            messageLabel.textAlignment = .Center
//            messageLabel.font = UIFont(name: "Palatino-Italic", size: 20)
//            messageLabel.sizeToFit()
//            self.tableView?.backgroundView = messageLabel
//            self.tableView?.separatorStyle = .None
//            return 0
//        } else {
//            self.tableView?.separatorStyle = .SingleLine
//            self.tableView?.backgroundView = nil
//        }
        return 1
    }

}
