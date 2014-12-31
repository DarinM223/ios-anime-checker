//
//  LoginViewController.swift
//  animelist-checker
//
//  Created by Darin Minamoto on 12/29/14.
//  Copyright (c) 2014 com.d_m. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLoginClicked(sender: AnyObject) {
        AuthenticationToken.setAuthToken(usernameField.text, password: passwordField.text) { result in
            if let auth_token:String = result {
                var tabViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBar") as UITabBarController
                var animeNavViewController = tabViewController.viewControllers?[0] as UINavigationController
                var accountNavViewController = tabViewController.viewControllers?[1] as UINavigationController
                var animeListViewController = animeNavViewController.viewControllers[0] as AnimeListTableViewController
                var accountViewController = accountNavViewController.viewControllers[0] as FeedTableViewController
                
                accountViewController.mainNavController = self.navigationController
                animeListViewController.mainNavController = self.navigationController
                animeListViewController.username = self.usernameField.text
                tabViewController.selectedIndex = 0
                self.navigationController?.pushViewController(tabViewController, animated: true)
            } else {
                var alertView = UIAlertView(title: "Warning", message: "You must enter a correct username or password", delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
