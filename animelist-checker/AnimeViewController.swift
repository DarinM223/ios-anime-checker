//
//  AnimeViewController.swift
//  animelist-checker
//
//  Created by Darin Minamoto on 12/28/14.
//  Copyright (c) 2014 com.d_m. All rights reserved.
//

import UIKit

class AnimeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var episodeStepper: UIStepper!
    @IBOutlet weak var watchingPicker: UIPickerView!
    
    var libraryItem: LibraryItem?
    
    var episodeText: String?
    
    var _pickerData = [
        "Currently Watching",
        "Plan to Watch",
        "Completed",
        "On Hold",
        "Dropped",
        "Remove from Library"
    ]
    
    var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        episodeLabel.text = episodeText
        self.watchingPicker.dataSource = self;
        self.watchingPicker.delegate = self;
        
        var watchingIndex = 0
        
        switch libraryItem!.status {
            case "currently-watching": watchingIndex = 0
            case "plan-to-watch": watchingIndex = 1
            case "completed": watchingIndex = 2
            case "on-hold": watchingIndex = 3
            case "dropped": watchingIndex = 4
            default: watchingIndex = 0
        }
        
        if libraryItem!.anime.episode_count != nil {
            self.episodeLabel.text = String(libraryItem!.episodes_watched) + "/" + String(libraryItem!.anime.episode_count!)
        } else {
            self.episodeLabel.text = String(libraryItem!.episodes_watched) + "/_"
        }
        self.navigationItem.title = libraryItem!.anime.title
        
        self.watchingPicker.selectRow(watchingIndex, inComponent: 0, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onSaveClicked(sender: AnyObject) {
        var size:Int = self.navigationController?.viewControllers.count as Int!
        var animeListController = self.navigationController?.viewControllers[size-2] as AnimeListTableViewController
        animeListController.refreshAnimeList()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // # of columns
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // # of rows
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return _pickerData.count
    }
    
    // text for row
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return _pickerData[row]
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
