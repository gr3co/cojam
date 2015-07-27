//
//  CJNowPlayingViewController.swift
//  CoJam
//
//  Created by Stephen Greco on 7/27/15.
//  Copyright © 2015 Stephen Greco. All rights reserved.
//

import UIKit

class CJNowPlayingViewController: UIViewController, CJRoomViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumCover: AsyncImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateNowPlaying(track: SPTPartialTrack) {
        let artists = getArtistStringForArtistList(track.artists as! [SPTPartialArtist])
        dispatch_async(dispatch_get_main_queue()) {
            self.titleLabel.text = "\(track.name) - \(artists)"
            self.albumCover.imageURL = track.album.largestCover.imageURL
        }
    }
    
}
