//
//  LibraryToggleView.swift
//  Spotify-Clone
//
//  Created by apple on 15/03/25.
//

import UIKit

protocol toggleViewDelegate: AnyObject{
    func didTapPlaylist(_ toggleView : LibraryToggleView)
    func didTapAlbum(_ toggleView : LibraryToggleView)
}


class LibraryToggleView: UIView {
    
    enum State {
        case playlist
        case album
    }
    
    weak var delegate: toggleViewDelegate?
    
    var state : State = .playlist
    
    private let playlistButton: UIButton = {
        let button = UIButton()
        button.setTitle("Playlists", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    private let albumButton: UIButton = {
        let button = UIButton()
        button.setTitle("Albums", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(playlistButton)
        addSubview(albumButton)
        addSubview(indicatorView)
        playlistButton.addTarget(self, action: #selector(playlistTapped), for: .touchUpInside)
        albumButton.addTarget(self, action: #selector(albumTapped), for: .touchUpInside)
        
        
    }
    
    @objc func playlistTapped(){
        state = .playlist
        UIView.animate(withDuration: 0.2) {
            self.indicatorViewAnimation()
        }
        delegate?.didTapPlaylist(self)
    }
    @objc func albumTapped(){
        state = .album
        UIView.animate(withDuration: 0.2) {
            self.indicatorViewAnimation()
        }
        delegate?.didTapAlbum(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playlistButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        albumButton.frame = CGRect(x: playlistButton.right, y: 0, width: 100, height: 40)
        indicatorViewAnimation()
    }
    func indicatorViewAnimation(){
        switch state {
        case .playlist:
            self.indicatorView.frame = CGRect(x: 0, y: self.playlistButton.bottom, width: 100, height: 3)
        case .album:
            self.indicatorView.frame = CGRect(x: 100, y: self.playlistButton.bottom, width: 100, height: 3)
        }
        
    }
    
    func update(to state: State){
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.indicatorViewAnimation()
        }
    }
}
