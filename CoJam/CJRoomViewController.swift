//
//  CJRoomViewController.swift
//  CoJam
//
//  Created by Stephen Greco on 7/27/15.
//  Copyright © 2015 Stephen Greco. All rights reserved.
//

import UIKit

class CJRoomViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var room : CJRoom!
    var queue : [SPTPartialTrack]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }

    func refresh() {
        room.fetchInBackgroundWithBlock() { _ in
            CJSpotifyManager.sharedManager.getTracks(self.room.queue as! [String]) {
                (results : [SPTPartialTrack]?, _) in
                self.queue = results
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
        }
    }

}
