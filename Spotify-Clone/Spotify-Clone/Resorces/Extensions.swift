//
//  Extensions.swift
//  Spotify-Clone
//
//  Created by apple on 19/01/25.
//

import Foundation
import UIKit

extension UIView{
    
    var width: CGFloat {
        frame.width
    }
    
    var height: CGFloat {
        frame.height
    }
    var left: CGFloat {
        frame.origin.x
    }
    var right: CGFloat {
        left+width
    }
    var top : CGFloat {
        frame.origin.y
    }
    var bottom: CGFloat {
        top + height
    }
    
    
}
extension DateFormatter{
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
}

extension String{
    static func formattedDate(_ dateString: String) -> String? {
        guard let date = DateFormatter.dateFormatter.date(from: dateString) else {
            return nil
        }
        return DateFormatter.displayDateFormatter.string(from: date)
    }
}
