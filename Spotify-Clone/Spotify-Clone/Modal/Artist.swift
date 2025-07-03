//
//  Artist.swift
//  Spotify-Clone
//
//  Created by apple on 18/01/25.
//

import Foundation


struct Artist: Codable {
    let id : String
    let name : String
    let type : String
    let images : [APIImage]?
    let external_urls : [String: String]
}
