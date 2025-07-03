//
//  PlayerControllView.swift
//  Spotify-Clone
//
//  Created by apple on 11/03/25.
//

import Foundation
import UIKit

protocol PlayerControllerDelegate : AnyObject {
    func playPauseTapped(_ playerController: PlayerControllView)
    func nextSongTapped(_ playerController: PlayerControllView)
    func previousSongTapped(_ playerController: PlayerControllView)
    func sliderValueChnaged(_ playerController: PlayerControllView, slidedidSlide : Float)
}

struct PlayerControllViewModel{
    let songName : String
    let artistName : String
}


class PlayerControllView: UIView {
    
    var isPlaying : Bool = false
    
    weak var delegate : PlayerControllerDelegate?
    
    private let volumeSlider : UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Song Name"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let subNameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Arist Name "
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let backButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .label
        button.setImage(UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular)), for: .normal)
        return button
    }()
    private let nextButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .label
        button.setImage(UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular)), for: .normal)
        return button
    }()
    private let playButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .label
        button.setImage(UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular)), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        playButton.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        volumeSlider.addTarget(self, action: #selector(sliderDidSlide), for: .valueChanged)
        
        addSubview(volumeSlider)
        addSubview(backButton)
        addSubview(nextButton)
        addSubview(playButton)
        addSubview(nameLabel)
        addSubview(subNameLabel)
        
        clipsToBounds = true
    }
    @objc func sliderDidSlide(){
        delegate?.sliderValueChnaged(self, slidedidSlide: volumeSlider.value)
    }
    
    @objc func playPauseTapped(){
        HapticManager.shared.vibrateForSelection()
        self.isPlaying = !isPlaying
        delegate?.playPauseTapped(self)
        let play = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        let pause = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        playButton.setImage(isPlaying ? play : pause, for: .normal)
    }
    @objc func nextTapped(){
        HapticManager.shared.vibrateForSelection()
        delegate?.nextSongTapped(self)
    }
    @objc func backTapped(){
        HapticManager.shared.vibrateForSelection()
        delegate?.previousSongTapped(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        subNameLabel.frame = CGRect(x: 0  , y: nameLabel.bottom+10, width: width - 20 , height: 50)
        
        volumeSlider.frame = CGRect(x: 10, y: subNameLabel.bottom + 20, width: width - 20, height: 44)
        let buttonsWidth : CGFloat = 60
        
        playButton.frame = CGRect(x: (width - buttonsWidth)/2, y: volumeSlider.bottom + 30, width: buttonsWidth, height: buttonsWidth)
        nextButton.frame = CGRect(x: playButton.right + 60, y: playButton.top, width: buttonsWidth, height: buttonsWidth)
        backButton.frame = CGRect(x: playButton.left - 60 - buttonsWidth, y: playButton.top, width: buttonsWidth, height: buttonsWidth)
    }
    
    func configure(with viewModel: PlayerControllViewModel){
        nameLabel.text = viewModel.songName
        subNameLabel.text = viewModel.artistName
    }
    
}
