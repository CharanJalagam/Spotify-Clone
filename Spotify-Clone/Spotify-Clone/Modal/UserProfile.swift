//
//  UserProfile.swift
//  Spotify-Clone
//
//  Created by apple on 18/01/25.
//

import Foundation

struct UserProfile : Codable{
    
    let country: String
    let display_name: String
    let explicit_content: [String : Bool]
    let external_urls: [String : String]
    let id: String
    let email : String?
    let product: String
    let images: [APIImage]
    
    
}


