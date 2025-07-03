//
//  AlbumDetailsResponse.swift
//  Spotify-Clone
//
//  Created by apple on 01/03/25.
//

import Foundation

struct AlbumDetailsResponse: Codable{
    
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let id: String
    let external_urls: [String: String]
    let images: [APIImage]
    let label: String
    let name: String
    let tracks : TrackResponse
}
struct TrackResponse: Codable{
    let items: [AudioTrack]
}
