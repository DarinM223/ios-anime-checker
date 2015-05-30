//
//  AnimeViewController.swift
//  animelist-checker
//
//  Created by Darin Minamoto on 12/28/14.
//  Copyright (c) 2014 com.d_m. All rights reserved.
//

import UIKit

class LibraryItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
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
    
    // new anime parameters
    var episodes_watched: Int?
    var status: String?
    
    func reload() {
        if libraryItem!.anime.episode_count != nil {
            self.episodeLabel.text = String(self.episodes_watched!) + "/" + String(libraryItem!.anime.episode_count!)
        } else {
            self.episodeLabel.text = String(self.episodes_watched!) + "/_"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        episodeLabel.text = episodeText
        self.watchingPicker.dataSource = self;
        self.watchingPicker.delegate = self;
        
        var watchingIndex = 0
        
        self.navigationItem.title = libraryItem!.anime.title
        
        self.episodeStepper.minimumValue = 0
        if libraryItem!.anime.episode_count == nil {
            self.episodeStepper.maximumValue = Double(10000)
        } else {
            self.episodeStepper.maximumValue = Double(libraryItem!.anime.episode_count!)
        }
        self.episodeStepper.value = Double(libraryItem!.episodes_watched)
        
        switch libraryItem!.status {
            case "currently-watching": watchingIndex = 0
            case "plan-to-watch": watchingIndex = 1
            case "completed": watchingIndex = 2
            case "on-hold": watchingIndex = 3
            case "dropped": watchingIndex = 4
            default: watchingIndex = 0
        }
        
        self.episodes_watched = libraryItem!.episodes_watched
        self.status = libraryItem!.status
        self.watchingPicker.selectRow(watchingIndex, inComponent: 0, animated: false)
        
        self.reload()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onSaveClicked(sender: AnyObject) {
        var size:Int = self.navigationController?.viewControllers.count as Int!
        var animeListController = self.navigationController?.viewControllers[size-2] as! AnimeListTableViewController
        animeListController.refreshAnimeList()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func stepperValueChanged(sender: AnyObject) {
        self.episodes_watched = Int(self.episodeStepper.value)
        self.reload()
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showAnimeDetail" {
            var destViewController = segue.destinationViewController as! AnimeDetailViewController
            destViewController.anime = self.libraryItem?.anime
        }
    }

}
