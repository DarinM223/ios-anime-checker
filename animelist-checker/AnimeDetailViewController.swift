//
//  AnimeDetailViewController.swift
//  animelist-checker
//
//  Created by Darin Minamoto on 1/10/15.
//  Copyright (c) 2015 com.d_m. All rights reserved.
//

import UIKit

class AnimeDetailViewController: UIViewController {
    
    var anime: Anime?

    @IBOutlet weak var detailText: UITextView!
    @IBOutlet weak var showTypeLabel: UILabel!
    @IBOutlet weak var numEpisodesLabel: UILabel!
    @IBOutlet weak var episodeLengthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = anime!.title
        self.detailText.text = anime!.synopsis
        if anime!.show_type == nil {
            self.showTypeLabel.text = "No type"
        } else {
            self.showTypeLabel.text = anime?.show_type
        }
        
        if anime!.episode_count == nil {
           self.numEpisodesLabel.text = "No episodes"
        } else {
            self.numEpisodesLabel.text = String(anime!.episode_count!)
        }
        
        if anime!.episode_length == nil {
            self.episodeLengthLabel.text = "No episode length"
        } else {
            self.episodeLengthLabel.text = String(anime!.episode_length!) + (anime!.episode_length == 1 ? " minute" : " minutes")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
