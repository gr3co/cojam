//
//  CJMainViewController.swift
//  CoJam
//
//  Created by Stephen Greco on 4/23/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

import UIKit

class CJMainViewControllerSwift: UIViewController, CJSpotifyHelperDelegate,
UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var rooms : [CJRoom]?
    var roomsQuery : PFQuery!
    var refreshControl : UIRefreshControl!
    let helper = CJSpotifyHelper.defaultHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        roomsQuery = CJRoom.query()
        //roomsQuery.whereKey("members", equalTo: PFUser.currentUser()!)
        //roomsQuery.whereKey("isActive", equalTo: true)
        
        helper.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        helper.attemptToReauthenticateWithBlock { (success: Bool, error: NSError?) -> Void in
            if error != nil {
                println("Auth error: \(error)")
            }
            if success {
                println("Logged in as \(CJUser.currentUser()!.spotifyUsername)")
                self.refresh()
            } else {
                self.showSpotifyAuthController()
            }
        }
    }
    
    func refresh() {
        roomsQuery.findObjectsInBackgroundWithBlock { (objects : [AnyObject]?, error: NSError?) in
            if error != nil {
                println("Refresh error: \(error)")
            }
            self.rooms = objects as? [CJRoom]
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                
                // If there are any loading indicators, hide them
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                if self.refreshControl.refreshing {
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    func showSpotifyAuthController() {
        let authvc = SPTAuthViewController.authenticationViewController()
        authvc.delegate = helper
        authvc.modalPresentationStyle = .Custom
        authvc.modalTransitionStyle = .CrossDissolve
        self.modalPresentationStyle = .CurrentContext
        self.definesPresentationContext = true
        self.navigationController!.presentViewController(authvc,
            animated: true, completion: nil)
    }
    
    // MARK - UITableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms?.count ?? 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Your rooms"
        default: return ""
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.roomListCellIdentifier,
            forIndexPath: indexPath) as! CJRoomListTableCell
        cell.room = rooms?[indexPath.row]
        cell.updateView()
        return cell
    }

}

class CJRoomListTableCell : UITableViewCell {
    
    @IBOutlet weak var albumCover: AsyncImageView!
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var nowPlaying: UILabel!
    var room : CJRoom!
    
    func updateView() {
        roomName.text = room.displayName
        albumCover.imageURL = NSURL(string: "https://upload.wikimedia.org/wikipedia/en/3/35/The_Eminem_Show.jpg")
    }
    
}
