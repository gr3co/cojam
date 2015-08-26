//
//  CJConstants.swift
//  CoJam
//
//  Created by Stephen Greco on 7/26/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

let kSpotifySessionDefaultsKey = "spotifySession"
let kSpotifyUsernameKey = "spotifyUsername"
let kSpotifyAccessTokenKey = "spotifyAccessToken"
let kSpotifyRefreshTokenKey = "spotifyRefreshToken"
let kSpotifyExpirationDateKey = "spotifyExpirationDate"

struct URLs {
    
    static let spotifySwapURL = "https://cojam.parseapp.com/swap"
    static let spotifyRefreshURL = "https://cojam.parseapp.com/refresh"
    static let spotifyCallbackURL = "cojam://spotify/callback"
    
}

struct Tokens {
    
    static let parseAppId = "waRB2NWEkLHS0y1OezpmRZFhI8vSbnGm0uznT9tC"
    static let parseClientKey = "Neyfbq0ibmZqnKxkYtUXRyPuAB8CqM30dkFAJfUb"
    static let spotifyClientId = "100501836e2e494c97c10613da0587d2"
    
}

struct CellIdentifiers {
    
    static let roomListCellIdentifier = "CJRoomListTableCell"
    static let songViewCellIdentifier = "CJSongTableViewCell"
    
}

struct Notifications {
    
    static let hideKeyboardNotification = "hideKeyboard"
    
}
