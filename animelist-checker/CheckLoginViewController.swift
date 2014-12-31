//
//  CheckLoginViewController.swift
//  animelist-checker
//
//  Created by Darin Minamoto on 12/30/14.
//  Copyright (c) 2014 com.d_m. All rights reserved.
//

import UIKit

class CheckLoginViewController: UIViewController {
    
    func checkLogin() {
        var data = AuthenticationToken.getAuthToken()
        if data == nil {
            // go to login view
            var loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Login") as LoginViewController
            self.navigationController?.pushViewController(loginViewController, animated: false)
        } else {
            // extract username and go to anime list view
            var username = AuthenticationToken.getUsername()
            
            var tabViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBar") as UITabBarController
            var animeNavViewController = tabViewController.viewControllers?[0] as UINavigationController
            var accountNavViewController = tabViewController.viewControllers?[1] as UINavigationController
            
            var animeListViewController = animeNavViewController.viewControllers[0] as AnimeListTableViewController
            var accountViewController = accountNavViewController.viewControllers[0] as FeedTableViewController
            
            accountViewController.mainNavController = self.navigationController
            animeListViewController.mainNavController = self.navigationController
            animeListViewController.username = username!
            
            tabViewController.selectedIndex = 0
            self.navigationController?.pushViewController(tabViewController, animated: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.checkLogin()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.checkLogin()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
