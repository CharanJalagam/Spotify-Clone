//
//  PlaybackPresenter.swift
//  Spotify-Clone
//
//  Created by apple on 11/03/25.
//

import Foundation
import UIKit
import AVFoundation

protocol PlaybackDataSource: AnyObject {
    var songName: String { get }
    var subtitle: String { get }
    var imageURL: URL? { get }
}



final class PlaybackPresenter {
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    
    var vcPlayer = PlayerViewController()
    var index = 0
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        } else if !tracks.isEmpty {
            guard index >= 0, index < tracks.count else { return nil }
            return tracks[index]
        }
        return nil
    }
    
    static let shared = PlaybackPresenter()
    var player = AVPlayer()
    var playerQueue = AVQueuePlayer()
    
    func startPlaying(from vc: UIViewController, track: AudioTrack) {
        let path = Bundle.main.path(forResource: "my_song", ofType: "mp3")
        let url = URL(fileURLWithPath: path ?? "")
        setupAudioSession()
        player = AVPlayer(url: url)
        player.volume = 0.5
        self.track = track
        self.tracks = []
        index = 0
        
        let playerVC = PlayerViewController()
        playerVC.title = track.name
        playerVC.dataSource = self
        playerVC.delegate = self
        
        vc.present(UINavigationController(rootViewController: playerVC), animated: true) { [weak self] in
            self?.player.play()
        }
        vcPlayer = playerVC
    }
    
    func startPlaying(from vc: UIViewController, tracks: [AudioTrack]) {
        self.track = nil
        self.tracks = tracks
        index = 0
        setupAudioSession()
        
        let playerVC = PlayerViewController()
        playerVC.dataSource = self
        playerVC.delegate = self
        
        let path = Bundle.main.path(forResource: "my_song", ofType: "mp3")
        let url = URL(fileURLWithPath: path ?? "")
        
        let items = tracks.map { _ in AVPlayerItem(url: url) }
        playerQueue = AVQueuePlayer(items: items)
        
        vc.present(UINavigationController(rootViewController: playerVC), animated: true) { [weak self] in
            self?.playerQueue.play()
        }
        vcPlayer = playerVC
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }
}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    
    func sliderValueChanged(_ value: Float) {
        player.volume = value
        playerQueue.volume = value
    }
    
    func didTapPlayPause() {
        if player.timeControlStatus == .playing {
            player.pause()
        } else {
            player.play()
        }
        
        if playerQueue.timeControlStatus == .playing {
            playerQueue.pause()
        } else {
            playerQueue.play()
        }
    }
    
    func didTapSkipForward() {
        guard !tracks.isEmpty else {
            print("No playlist available.")
            return
        }
        
        if index < tracks.count - 1 {
            index += 1
            playerQueue.advanceToNextItem()
        } else {
            index = 0
            playerQueue.seek(to: .zero)
        }
        
        vcPlayer.updateUI()
    }
    
    func didTapSkipBackward() {
        guard !tracks.isEmpty else {
            print("No playlist available.")
            return
        }
        
        if playerQueue.currentTime().seconds > 3.0 {
            playerQueue.seek(to: .zero)
        } else if index > 0 {
            index -= 1
            let previousItem = AVPlayerItem(url: URL(fileURLWithPath: Bundle.main.path(forResource: "my_song", ofType: "mp3") ?? ""))
            playerQueue.insert(previousItem, after: nil)
            playerQueue.advanceToNextItem()
        }
        
        vcPlayer.updateUI()
    }
}

extension PlaybackPresenter: PlaybackDataSource {
    
    var songName: String {
        return currentTrack?.name ?? ""
    }
    
    var subtitle: String {
        return currentTrack?.artists.first?.name ?? ""
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
}
