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
    
    var animelist: Animelist?
    
    var currently_watching: [LibraryItem]? = nil
    
    var window:UIWindow?
    var activityView: UIView?
    var mainNavController: UINavigationController?
    
    func refreshAnimeList() {
        window?.addSubview(activityView!)
        self.activityView?.subviews[0].startAnimating()
        self.animelist?.getList {error in
            if error == nil {
                self.currently_watching = self.animelist?.getCurrentlyWatching()
            }
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
            window.addSubview(activityView!)
            self.activityView?.subviews[0].startAnimating()
            animelist = Animelist(username: self.username) { error in
                if error == nil {
                    self.currently_watching = self.animelist?.getCurrentlyWatching()
                }
                self.tableView.reloadData()
                self.activityView?.subviews[0].stopAnimating()
                self.activityView?.removeFromSuperview()
            }
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
        if currently_watching == nil {
            return 0
        } else {
            return currently_watching!.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as AnimeListCell

        // Configure the cell...
        
        var libraryItem:LibraryItem = currently_watching![indexPath.row]
        
        cell.TitleLabel.text = libraryItem.anime.title
        
        if libraryItem.anime.episode_count != nil {
            cell.NumAnimeLabel.text = String(libraryItem.episodes_watched) + "/" + String(libraryItem.anime.episode_count!)
            if libraryItem.episodes_watched < libraryItem.anime.episode_count {
                cell.IncrementAnimeButton.hidden = false
            } else {
                cell.IncrementAnimeButton.hidden = true
            }
        } else {
            cell.IncrementAnimeButton.hidden = false
            cell.NumAnimeLabel.text = String(libraryItem.episodes_watched) + "/_"
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var watchingIndex: Int
        var destViewController = storyboard?.instantiateViewControllerWithIdentifier("AnimeDetail") as AnimeViewController
        var libraryItem:LibraryItem = currently_watching![indexPath.row]

        switch libraryItem.status {
            case "currently-watching": watchingIndex = 0
            case "plan-to-watch": watchingIndex = 1
            case "completed": watchingIndex = 2
            case "on-hold": watchingIndex = 3
            case "dropped": watchingIndex = 4
            default: watchingIndex = 1
        }
        
        if libraryItem.anime.episode_count != nil {
            destViewController.episodeText = String(libraryItem.episodes_watched) + "/" + String(libraryItem.anime.episode_count!)
        } else {
            destViewController.episodeText = String(libraryItem.episodes_watched) + "/_"
        }
        destViewController.navigationItem.title = libraryItem.anime.title
        destViewController.selectedRow = watchingIndex
        self.navigationController?.pushViewController(destViewController, animated: true)
    }
    
    // MARK: - Navigation
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
}
