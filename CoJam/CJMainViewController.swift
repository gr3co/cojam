//
//  CJMainViewController.swift
//  CoJam
//
//  Created by Stephen Greco on 4/23/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

import UIKit

class CJMainViewController: UIViewController, CJSpotifyManagerDelegate,
UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl : UIRefreshControl!
    let helper = CJSpotifyManager.sharedManager
    
    var myRooms : [CJRoom]?
    var myRoomsQuery : PFQuery!
    var nearbyRooms : [CJRoom]?
    var nearbyRoomsQuery : PFQuery!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myRoomsQuery = CJRoom.queryWithPredicate(NSPredicate(format: "isActive == true"))
        nearbyRoomsQuery = myRoomsQuery // Temporary
        
        helper.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        helper.attemptToReauthenticate { (success: Bool, error: NSError?) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if error != nil {
                println("Auth error: \(error)")
            }
            if success {
                self.refresh()
            } else {
                self.showSpotifyAuthController()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        // Refresh when opened
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh",
            name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    func refresh() {
        self.refreshControl.beginRefreshing()
        myRoomsQuery.findObjectsInBackgroundWithBlock { (objects : [AnyObject]?, _) in
            self.myRooms = objects as? [CJRoom]
            self.nearbyRoomsQuery.findObjectsInBackgroundWithBlock { (objects : [AnyObject]?, _) in
                self.nearbyRooms = objects as? [CJRoom]
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                    if self.refreshControl.refreshing {
                        self.refreshControl.endRefreshing()
                    }
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
    
    // MARK: - UITableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return myRooms?.count ?? 0
        case 1: return nearbyRooms?.count ?? 0
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Your rooms"
        case 1: return "Nearby rooms"
        default: return ""
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.roomListCellIdentifier,
            forIndexPath: indexPath) as! CJRoomListTableCell
        
        switch indexPath.section {
        case 0:
            cell.room = myRooms?[indexPath.row]
        case 1:
            cell.room = nearbyRooms?[indexPath.row]
        default:
            break
        }
        
        cell.updateView()
        return cell
    }

    // MARK: - CJSpotifyManagerDelegate
    
    func failedToLogin() {
        // Do nothing for now
    }
    
    func openRoomView(room: CJRoom?) {
        // Do nothing for now
    }
    
    
}

class CJRoomListTableCell : UITableViewCell {
    
    @IBOutlet weak var albumCover: AsyncImageView!
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var nowPlaying: UILabel!
    var room : CJRoom?
    
    func updateView() {
        roomName.text = room?.displayName ?? "Untitled"
        albumCover.imageURL = NSURL(string: "https://upload.wikimedia.org/wikipedia/en/3/35/The_Eminem_Show.jpg")
    }
    
}
