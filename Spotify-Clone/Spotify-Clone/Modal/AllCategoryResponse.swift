//
//  AllCategoryResponse.swift
//  Spotify-Clone
//
//  Created by apple on 08/03/25.
//

import Foundation

struct AllCategoryResponse : Codable{
    let  categories : Item3
    
}
struct Item3: Codable {
    let items : [Category]
}

struct Category: Codable {
    let id: String
    let icons: [APIImage]
    let name : String
    
}
