//
//  CJRoomViewController.swift
//  CoJam
//
//  Created by Stephen Greco on 7/27/15.
//  Copyright © 2015 Stephen Greco. All rights reserved.
//

import UIKit

protocol CJRoomViewDelegate {
    func updateNowPlaying(track: SPTPartialTrack)
}

class CJRoomViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var room : CJRoom!
    var queue : [SPTPartialTrack]?
    var delegate : CJRoomViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self.childViewControllers[0] as! CJRoomViewDelegate
        titleLabel.text = room?.displayName ?? "Untitled"
        refresh()
    }

    func updateNowPlaying() {
        if let track = queue?[0] {
            delegate.updateNowPlaying(track)
        }
    }
    
    func refresh() {
        room.fetchInBackgroundWithBlock() { _ in
            CJSpotifyManager.sharedManager.getTracks(self.room.queue as! [String]) {
                (results : [SPTPartialTrack]?, _) in
                self.queue = results
                self.tableView.reloadData()
                self.updateNowPlaying()
            }
        }
    }

}
