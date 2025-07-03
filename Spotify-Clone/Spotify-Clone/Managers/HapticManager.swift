//
//  HapticManager.swift
//  Spotify-Clone
//
//  Created by apple on 18/01/25.
//

import Foundation
import CoreHaptics
import UIKit

public class HapticManager {
    
    static let shared = HapticManager()
    
    private init() {}
    
    public func vibrateForSelection() {
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
    public func vibrate(for type : UINotificationFeedbackGenerator.FeedbackType){
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
}
