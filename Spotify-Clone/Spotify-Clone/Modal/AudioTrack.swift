//
//  AudioTrack.swift
//  Spotify-Clone
//
//  Created by apple on 18/01/25.
//

import Foundation

struct AudioTrack: Codable{
    var album : Album?
    let artists:[Artist]
    let available_markets:[String]
    let disc_number:Int
    let duration_ms:Int
    let explicit:Bool
    let images : [APIImage]?
    let external_urls:[String: String]
    let id:String
    let name:String
    let preview_url : String?
}
