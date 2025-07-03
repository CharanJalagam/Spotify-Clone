//
//  SettingsModals.swift
//  Spotify-Clone
//
//  Created by apple on 23/01/25.
//

import Foundation

struct Section{
    let title: String
    let options: [Option]
    
}

struct Option{
    let title: String
    let handler : () -> Void
}
