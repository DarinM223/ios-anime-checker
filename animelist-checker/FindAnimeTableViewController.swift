//
//  FindAnimeTableViewController.swift
//  animelist-checker
//
//  Created by Darin Minamoto on 12/28/14.
//  Copyright (c) 2014 com.d_m. All rights reserved.
//

import UIKit

class FindAnimeTableViewController: UITableViewController, UISearchBarDelegate {
    var list: [Anime] = []

    override func viewDidLoad() {
        super.viewDidLoad()
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
        return self.list.count
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.tableView.reloadData()
        return true
    }
    
    func filterSearchText(searchText: String, callback: (Bool) -> Void) {
        if searchText != "" {
            HummingbirdAPI.searchAnime(searchText) { result in
                if result == nil {
                    callback(false)
                    self.tableView.reloadData() 
                } else {
                    let arr: [AnyObject] = result as! [AnyObject]
                    self.list.removeAll(keepCapacity: true)
                    
                    for item:AnyObject in arr {
                        if let dict:NSDictionary = item as? NSDictionary {
                            self.list.append(Anime(dict: dict))
                        }
                    }
                    callback(true)
                }
            }
        } else {
            callback(false)
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.filterSearchText(searchBar.text) { result in
            if result == true {
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterSearchText(searchBar.text) { result in
            if result == true {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! AnimeListCell
        
        
        // Configure the cell...
        var animeItem = list[indexPath.row]
        
        cell.TitleLabel.text = animeItem.title
        cell.IncrementAnimeButton.hidden = true
        cell.NumAnimeLabel.text = ""

        return cell
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
        
        if segue.identifier == "showAnimeDetail" {
            var destViewController = segue.destinationViewController as! AnimeDetailViewController
            var indexPath = self.tableView.indexPathForSelectedRow()
            var animeItem = list[indexPath!.row]
            destViewController.anime = animeItem
        }
    }

}
