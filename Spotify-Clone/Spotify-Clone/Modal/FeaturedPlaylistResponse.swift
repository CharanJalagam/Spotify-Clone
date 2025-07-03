//
//  FeaturedPlaylistResponse.swift
//  Spotify-Clone
//
//  Created by apple on 08/02/25.
//

import Foundation

struct FeaturedPlaylistResponse: Codable{
    let playlists : PlaylistsResponse
}
struct PlaylistsResponse: Codable{
    let items : [Playlist]
}
struct Playlist: Codable{
    let description : String
    let external_urls : [String : String]
    let owner : User
    let images : [APIImage]
    let name : String
    let id : String
}
struct User: Codable{
    let display_name : String
    let external_urls : [String : String]
    let id : String
}
