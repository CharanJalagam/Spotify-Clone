//
//  SearchResult.swift
//  Spotify-Clone
//
//  Created by apple on 09/03/25.
//

import Foundation
enum SearchResult{
    case artist(model : Artist)
    case album(model : Album)
    case track(model : AudioTrack)
    case playlist(model : UserPlaylist)
    
}
