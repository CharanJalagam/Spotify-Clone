//
//  SearchResultResponse.swift
//  Spotify-Clone
//
//  Created by apple on 09/03/25.
//

import Foundation

struct SearchResultResponse : Codable{
    let albums : SearchAlbumsResponse
    let artists : SearchArtistsResponse
    let playlists : SearchPlaylistsResponse
    let tracks : SearchTracksResponse
}

struct SearchAlbumsResponse:Codable{
    let items : [Album?]
}
struct SearchArtistsResponse:Codable{
    let items : [Artist?]
}
struct SearchPlaylistsResponse:Codable{
    let items : [UserPlaylist?]
}
struct SearchTracksResponse:Codable{
    let items : [AudioTrack?]
}
