//
//  AppDelegate.swift
//  CoJam
//
//  Created by Stephen Greco on 7/26/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
    var window : UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [NSObject : AnyObject]?) -> Bool {
            
            // Setup Parse schemas
            CJUser.load()
            CJRoom.load()
            
            // Setup Parse application
            Parse.setApplicationId(Tokens.parseAppId, clientKey: Tokens.parseClientKey)
            CJUser.enableAutomaticUser()
            
            // Setup Spotify authorization
            let auth = SPTAuth.defaultInstance()
            auth.clientID = Tokens.spotifyClientId
            auth.redirectURL = NSURL(string: URLs.spotifyCallbackURL)
            auth.requestedScopes = ["user-read-email", "streaming", "user-follow-read"]
            auth.tokenRefreshURL = NSURL(string: URLs.spotifyRefreshURL)
            auth.tokenSwapURL = NSURL(string: URLs.spotifySwapURL)
            auth.sessionUserDefaultsKey = kSpotifySessionDefaultsKey
            
            return true
        
    }
    
    func application(application: UIApplication, openURL url: NSURL,
        sourceApplication: String?, annotation: AnyObject) -> Bool {
        
            // Ask Spotify Auth if this is an auth callback
            if SPTAuth.defaultInstance().canHandleURL(url) {
                SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(url) {
                    (error: NSError?, _) -> Void in
                    
                    if error != nil {
                        print("Auth error: \(error)")
                    }
                    
                }
                return true
            }
            
            // Otherwise, check if it's a custom CoJam url
            return CJSpotifyManager.sharedManager.handleURL(url)
            
    }
    
}
