//
//  CJSpotifyManager.swift
//  CoJam
//
//  Created by Stephen Greco on 7/26/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

import UIKit
import AVFoundation

protocol CJSpotifyManagerDelegate {
    func refresh()
    func openRoomView(room: CJRoom?)
    
    func failedToLogin()
}

class CJSpotifyManager: NSObject, SPTAuthViewDelegate, SPTAudioStreamingPlaybackDelegate {
    
    static let sharedManager = CJSpotifyManager()
    var delegate : CJSpotifyManagerDelegate?
    var player : SPTAudioStreamingController?
    var spotifyUser : SPTUser?
    var currentRoom : CJRoom?
    var session : SPTSession?
    
    // MARK: - Utility
    func handleURL(url: NSURL) -> Bool {
        if url.host == "room" {
            let roomId = url.pathComponents![1] 
            CJRoom.queryWithPredicate(NSPredicate(format: "idNumber == %@",
                roomId))!.findObjectsInBackgroundWithBlock { (objects : [AnyObject]?, _) in
                let room = objects?.first as? CJRoom
                self.delegate?.openRoomView(room)
            }
            return true
        }
        return false
    }
    
    func getTracks(uris: [String], block: ([SPTPartialTrack]?, error: NSError?) -> Void) {
        let tracks = getURLSFromStrings(uris)
        SPTTrack.tracksWithURIs(tracks, session: session!,
            callback: {block($1 as? [SPTPartialTrack], error: $0)})
    }
    
    func performSearch(query: String, block: ([SPTPartialTrack]?, error: NSError?) -> Void) {
        SPTSearch.performSearchWithQuery(query, queryType: .QueryTypeTrack,
            accessToken: self.session!.accessToken, callback: {block($1 as? [SPTPartialTrack], error: $0)})
    }
    
    // MARK: - Playback
    func playTracksFromRoom(room: CJRoom) {
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        if player == nil {
            player = SPTAudioStreamingController(clientId: Tokens.spotifyClientId)
            player?.playbackDelegate = self
        }
        player?.loginWithSession(session!) { _ in
            self.player?.playURIs(getURLSFromStrings(room.queue as! [String]), fromIndex: 0) {
                _ in
                self.currentRoom = room
                let relation = room.relationForKey("members")
                relation.addObject(PFUser.currentUser()!)
                room.saveEventually(nil)
            }
        }
    }
    
    // MARK: - Auth
    func attemptToReauthenticate(block: (Bool, NSError?) -> Void) {
        let user = CJUser.currentUser()
        if let spotifyUsername = user?.spotifyUsername,
            let spotifyAccessToken = user?.spotifyAccessToken,
            let refreshToken = user?.spotifyRefreshToken,
            let expirationDate = user?.spotifyExpirationDate,
            let oldSession = SPTSession(userName: spotifyUsername, accessToken: spotifyAccessToken,
                encryptedRefreshToken: refreshToken, expirationDate: expirationDate) {
                    
                SPTAuth.defaultInstance().renewSession(oldSession) {
                    (error: NSError?, newSession: SPTSession?) in
                    if error != nil {
                        return block(false, error)
                    }
                    self.session = newSession
                    user!.spotifyAccessToken = newSession!.accessToken
                    user!.spotifyRefreshToken = newSession!.encryptedRefreshToken
                    user!.spotifyExpirationDate = newSession!.expirationDate
                    user!.saveInBackgroundWithBlock(block)
                }
                    
        } else {
            return block(false, nil)
        }
    }
    
    // MARK: - SPTAuthViewDelegate
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
        self.session = session
        SPTUser.requestCurrentUserWithAccessToken(session.accessToken) { (_, object: AnyObject?) in
            
            if let spotifyUser = object as? SPTUser {
                self.spotifyUser = spotifyUser
                let user = CJUser.currentUser()!
                user.spotifyEmailAddress = spotifyUser.emailAddress
                user.spotifyAccessToken = session.accessToken
                user.spotifyExpirationDate = session.expirationDate
                user.spotifyRefreshToken = session.encryptedRefreshToken
                user.spotifyUsername = spotifyUser.canonicalUserName
                user.spotifyDisplayName = spotifyUser.displayName
                user.saveInBackgroundWithBlock() { (success: Bool, _) in
                    if success {
                        self.delegate?.refresh()
                    }
                }
            }
            
        }
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        print("Failed to login: \(error)")
        delegate?.failedToLogin()
    }
    
    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
        delegate?.failedToLogin()
    }
   
}
