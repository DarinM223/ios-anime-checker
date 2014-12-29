//
//  AddAnimeViewController.swift
//  animelist-checker
//
//  Created by Darin Minamoto on 12/28/14.
//  Copyright (c) 2014 com.d_m. All rights reserved.
//

import UIKit

class AddAnimeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    @IBAction func onDoneButton(sender: AnyObject) {
        // TODO: save new anime
        self.navigationController?.popToRootViewControllerAnimated(true)
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
