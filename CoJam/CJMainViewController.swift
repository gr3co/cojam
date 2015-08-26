//
//  CJMainViewController.swift
//  CoJam
//
//  Created by Stephen Greco on 4/23/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

import UIKit

class CJMainViewController: UIViewController, CJSpotifyManagerDelegate,
    CJNewRoomViewDelegate, UITableViewDelegate, UITableViewDataSource,
    UIGestureRecognizerDelegate {

    @IBOutlet weak var newRoomView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newRoomViewHeightConstraint: NSLayoutConstraint!
    
    var refreshControl : UIRefreshControl!
    var tapRecognizer : UITapGestureRecognizer!
    let helper = CJSpotifyManager.sharedManager
    
    var myRooms : [CJRoom]?
    var myRoomsQuery : PFQuery!
    var nearbyRooms : [CJRoom]?
    var nearbyRoomsQuery : PFQuery!
    
    var showingNewRoomView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myRoomsQuery = CJRoom.queryWithPredicate(NSPredicate(format: "isActive == true"))
        nearbyRoomsQuery = myRoomsQuery // Temporary
        
        helper.delegate = self
        
        // hide the create room panel
        newRoomViewHeightConstraint.constant = 0
        
        let newRoomVC = childViewControllers[0] as! CJNewRoomViewController
        newRoomVC.delegate = self
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: "tapped:")
        tapRecognizer.delegate = self
        self.view.addGestureRecognizer(tapRecognizer)
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        helper.attemptToReauthenticate { (success: Bool, _) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
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
    
    @IBAction func newRoomButtonPressed(sender: AnyObject) {
        self.view.layoutIfNeeded()
        newRoomViewHeightConstraint.constant = 50
        UIView.animateWithDuration(0.2) {
            self.view.layoutIfNeeded()
            self.showingNewRoomView = true
        }
    }
    
    func hideNewRoomView() {
        self.view.layoutIfNeeded()
        NSNotificationCenter.defaultCenter().postNotificationName(
            Notifications.hideKeyboardNotification, object: nil)
        newRoomViewHeightConstraint.constant = 0
        UIView.animateWithDuration(0.2) {
            self.view.layoutIfNeeded()
            self.showingNewRoomView = false
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRoom" {
            let controller = segue.destinationViewController as! CJRoomViewController
            controller.room = (sender as! CJRoomReference).room
        }
        super.prepareForSegue(segue, sender: sender)
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
    
    
    // MARK: - UIGestureRecognizerDelegate
    
    func tapped(sender: AnyObject?) {
        hideNewRoomView()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        let point = touch.locationInView(newRoomView)
        return showingNewRoomView && !CGRectContainsPoint(newRoomView.bounds, point)
    }
    
    // MARK: - CJNewRoomDelegate
    
    func newRoomCreated(room: CJRoom) {
        hideNewRoomView()
        refresh()
    }
    
}

protocol CJRoomReference {
    var room : CJRoom? {get set}
}

class CJRoomListTableCell : UITableViewCell, CJRoomReference {
    
    @IBOutlet weak var albumCover: AsyncImageView!
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var nowPlaying: UILabel!
    var room : CJRoom?
    
    func updateView() {
        roomName.text = room?.displayName ?? "Untitled"
        albumCover.imageURL = NSURL(string: "https://upload.wikimedia.org/wikipedia/en/3/35/The_Eminem_Show.jpg")
    }
    
}
