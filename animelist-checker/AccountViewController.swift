//
//  AccountViewController.swift
//  animelist-checker
//
//  Created by Darin Minamoto on 1/1/15.
//  Copyright (c) 2015 com.d_m. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    var mainNavController:UINavigationController?
    var username:String = ""
    
    var window:UIWindow?
    var activityView: UIView?
    
    func refreshAccount() {
        window?.addSubview(activityView!)
        self.activityView?.subviews[0].startAnimating()
        HummingbirdAPI.getAccountInfo(self.username){result in
            // TODO: do something with the result
            self.activityView?.subviews[0].stopAnimating()
            self.activityView?.removeFromSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var delegate = UIApplication.sharedApplication().delegate
        window = delegate?.window as UIWindow!!
        
        if let window = window as UIWindow! {
            activityView = UIView(frame: CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height))
            activityView?.backgroundColor = UIColor.blackColor()
            activityView?.alpha = 0.5
            
            var spinner = UIActivityIndicatorView(frame: CGRectMake(window.bounds.width/2-12, window.bounds.height/2-12, 24, 24))
            spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
            spinner.color = UIColor.grayColor()
            spinner.autoresizingMask = (UIViewAutoresizing.FlexibleLeftMargin |
                UIViewAutoresizing.FlexibleRightMargin |
                UIViewAutoresizing.FlexibleTopMargin |
                UIViewAutoresizing.FlexibleBottomMargin)
            
            activityView?.addSubview(spinner)
            self.refreshAccount()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onSignOutClicked(sender: AnyObject) {
        var result = AuthenticationToken.removeAuthToken()
        if result == true {
            self.mainNavController?.popToRootViewControllerAnimated(true)
        } else {
            
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
