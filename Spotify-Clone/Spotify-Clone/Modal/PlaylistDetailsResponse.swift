//
//  PlaylistDetailsResponse.swift
//  Spotify-Clone
//
//  Created by apple on 01/03/25.
//

import Foundation

//struct PlaylistDetailsResponse: Codable{
//    let description: String
//    let id: String
//    let external_urls: [String: String]
//    let images: [APIImage]
//    let name: String
//    let tracks : PlaylistTrackResponse
//}
//struct PlaylistTrackResponse: Codable{
//    let items : PlaylistItem
//}
//
//struct PlaylistItem: Codable{
//    let track : [AudioTrack]
//}
struct PlaylistDetailsResponse: Codable {
    let description: String
    let id: String
    let images: [APIImage]
    let name: String
    let owner: Owner
    let tracks: Tracks
    
    enum CodingKeys: String, CodingKey {
        case  description
        case id, images, name, owner
        case tracks
    }
}

// MARK: - ExternalUr
// MARK: - Followers

// MARK: - Owner
struct Owner: Codable {
    let  id: String
    let displayName, name: String?
    
    enum CodingKeys: String, CodingKey {
        case  id
        case displayName = "display_name"
        case name
    }
}

// MARK: - Tracks
struct Tracks: Codable {
    let items: [Item2]
}

// MARK: - Item
struct Item2: Codable {
    let track: AudioTrack
    
    enum CodingKeys: String, CodingKey {
        case track
    }
}

// MARK: - Track
struct Track: Codable {
    let album: Album3
    let artists: [Owner]
    let  id: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case album, artists
        
        case  id
        case name
    }
}

// MARK: - Album
struct Album3: Codable {
    let id: String
    let images: [APIImage]
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case  id, images, name
    }
}

