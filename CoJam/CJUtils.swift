//
//  CJUtils.swift
//  CoJam
//
//  Created by Stephen Greco on 7/26/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

func getArtistStringForArtistList(artists : [SPTPartialArtist]) -> String {
    return ", ".join(artists.map {return $0.name!})
}

func getURLSFromStrings(strings: [String]) -> [NSURL] {
    return strings.map {return NSURL(string: $0)!}
}
