//
//  CheckLoginViewController.swift
//  animelist-checker
//
//  Created by Darin Minamoto on 12/30/14.
//  Copyright (c) 2014 com.d_m. All rights reserved.
//

import UIKit

class CheckLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            var animeListViewController = animeNavViewController.viewControllers[0] as AnimeListTableViewController
            animeListViewController.username = username!
            
            tabViewController.selectedIndex = 0
            self.navigationController?.pushViewController(tabViewController, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
