//
//  AnimeListTableViewController.swift
//  animelist-checker
//
//  Created by Darin Minamoto on 12/23/14.
//  Copyright (c) 2014 com.d_m. All rights reserved.
//

import UIKit


class AnimeListTableViewController: UITableViewController {
    
    var username: String = ""
    var fixture_data: NSArray? = nil
    var window:UIWindow?
    var activityView: UIView?
    var mainNavController: UINavigationController?
    
    func refreshAnimeList() {
        window?.addSubview(activityView!)
        self.activityView?.subviews[0].startAnimating()
        HummingbirdAPI.getLibrary(self.username){result in
            self.fixture_data = result
            self.tableView.reloadData()
            self.activityView?.subviews[0].stopAnimating()
            self.activityView?.removeFromSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            self.refreshAnimeList()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    @IBAction func onRefreshClicked(sender: AnyObject) {
        self.refreshAnimeList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if fixture_data == nil {
            return 0
        } else {
            return fixture_data!.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as AnimeListCell

        // Configure the cell...
        var item = fixture_data?[indexPath.row] as NSDictionary
        var anime = item["anime"] as NSDictionary
        var title = anime["title"] as NSString
        var numEpisodesWatched = item["episodes_watched"] as Int
        
        cell.TitleLabel.text = title
        if let totalEpisodes = anime["episode_count"] as? Int {
            var totalEpisodesText = String(totalEpisodes)
            cell.NumAnimeLabel.text = String(numEpisodesWatched) + "/" + totalEpisodesText
            if numEpisodesWatched < totalEpisodes {
                cell.IncrementAnimeButton.hidden = false
            } else {
                cell.IncrementAnimeButton.hidden = true
            }
        } else {
            cell.NumAnimeLabel.text = String(numEpisodesWatched) + "/_"
        }
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showAnime" {
            var indexPath = self.tableView.indexPathForSelectedRow() as NSIndexPath!
            var destViewController = segue.destinationViewController as AnimeViewController
            
            var item = fixture_data?[indexPath.row] as NSDictionary
            var anime = item["anime"] as NSDictionary
            var title = anime["title"] as NSString
            destViewController.navigationItem.title = title
        }
    }
}
