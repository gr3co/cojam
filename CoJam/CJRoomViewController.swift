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

class CJRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
    
    // MARK: - UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = queue?.count {
            return max(0, count - 1)
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Up next" : ""
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.songViewCellIdentifier, forIndexPath: indexPath) as! CJSongTableViewCell
        cell.titleLabel.text = queue![indexPath.row + 1].name
        cell.artistsLabel.text = getArtistStringForArtistList(queue![indexPath.row + 1].artists as! [SPTPartialArtist])
        return cell
    }

}

class CJSongTableViewCell : UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistsLabel: UILabel!
    
}
