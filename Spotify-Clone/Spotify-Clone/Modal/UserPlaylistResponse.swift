//
//  UserPlaylistResponse.swift
//  Spotify-Clone
//
//  Created by apple on 08/02/25.
//

import Foundation

struct UserPlaylistResponse: Codable{
    let items : [UserPlaylist]
}

struct UserPlaylist: Codable{
    let description: String
    let external_urls : [String : String]
    let images: [APIImage]?
    let name: String
    let owner : User
    let id: String
}

