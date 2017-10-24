//
//  AppDelegate.swift
//  RagicViewer
//
//  Created by azuritul on 2014/10/18.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
   
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions:     [NSObject : AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let apikey = AZRagicSwiftUtils.getUserAPIKey()
        
        if apikey != nil {
            let rootViewController = TabFolderViewController()
            let navigationController = UINavigationController(rootViewController: rootViewController)
            
            self.window!.rootViewController = navigationController;
        } else {
            let controller = LoginHomeViewController()
            self.window!.rootViewController = controller;
        }
        
        self.window!.makeKeyAndVisible()
        return true
    }
}

