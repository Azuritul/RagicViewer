//
//  BaseViewController.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/27.
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

        return 1
    }

}
