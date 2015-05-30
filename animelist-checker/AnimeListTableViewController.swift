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
    
    var library: [[LibraryItem]] = []
    
    var currently_watching: [LibraryItem]? = nil
    var plan_to_watch: [LibraryItem]? = nil
    var completed: [LibraryItem]? = nil
    
    var window:UIWindow?
    var activityView: UIView?
    var mainNavController: UINavigationController?
    
    func refreshAnimeList() {
        window?.addSubview(activityView!)
        self.activityView?.subviews[0].startAnimating()
        self.animelist?.getList {error in
            self.library.removeAll(keepCapacity: true)
            if error == nil {
                for var i = 0; i < 5; i++ {
                    self.library.append(self.getLibraryType(i)!)
                }
            }
            self.tableView.reloadData()
            self.activityView?.subviews[0].stopAnimating()
            self.activityView?.removeFromSuperview()
        }
    }
    
    func getLibraryType(index: Int) -> [LibraryItem]? {
        switch index {
            case 0: return self.animelist?.getCurrentlyWatching()
            case 1: return self.animelist?.getPlanToWatch()
            case 2: return self.animelist?.getOnHold()
            case 3: return self.animelist?.getCompleted()
            case 4: return self.animelist?.getDropped()
            default: return nil
        }
    }
    
    func getLibraryTitle(index: Int) -> String {
        switch index {
            case 0: return "Currently Watching"
            case 1: return "Plan to Watch"
            case 2: return "On Hold"
            case 3: return "Completed"
            case 4: return "Dropped"
            default: return ""
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
                self.library.removeAll(keepCapacity: true)
                if error == nil {
                    for var i = 0; i < 5; i++ {
                        self.library.append(self.getLibraryType(i)!)
                    }
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
        return library.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return library[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! AnimeListCell

        // Configure the cell...
        
        var libraryItem:LibraryItem = library[indexPath.section][indexPath.row]
        
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
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.getLibraryTitle(section)
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
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var watchingIndex: Int
//        var destViewController = storyboard?.instantiateViewControllerWithIdentifier("LibraryItemDetail") as LibraryItemViewController
//        var libraryItem:LibraryItem = library[indexPath.section][indexPath.row]
//        
//        destViewController.libraryItem = libraryItem
//
//        self.navigationController?.pushViewController(destViewController, animated: true)
//    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showLibraryItem" {
            var indexPath = self.tableView.indexPathForSelectedRow()
            var libraryItem:LibraryItem = library[indexPath!.section][indexPath!.row]
            var destViewController = segue.destinationViewController as! LibraryItemViewController
            destViewController.libraryItem = libraryItem
        }
    }
}
