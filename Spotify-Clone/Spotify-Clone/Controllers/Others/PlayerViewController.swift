//
//  PlayerViewController.swift
//  Spotify-Clone
//
//  Created by apple on 18/01/25.
//

import UIKit
import SDWebImage

protocol PlayerViewControllerDelegate : AnyObject {
    func didTapPlayPause()
    func didTapSkipForward()
    func didTapSkipBackward()
    func sliderValueChanged(_ value : Float)
}

class PlayerViewController: UIViewController {
    
    weak var dataSource : PlaybackDataSource?
    weak var delegate : PlayerViewControllerDelegate?

    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemBlue
        return imageView
    }()
    
    let contentView  = PlayerControllView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(contentView)
        contentView.delegate = self
        configureButtons()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        
        contentView.frame = CGRect(x: 10, y: imageView.bottom + 10  , width: view.width - 20, height: view.height - imageView.height - view.safeAreaInsets.bottom - 15 - view.safeAreaInsets.top)
    }
    
    func updateUI(){
        configure()
    }
    
    func configureButtons(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleAction))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleDismiss))
    }
    @objc func handleDismiss(){
        self.dismiss(animated: true)
    }
    
    @objc func handleAction(){

    }
    
    func configure(){
        imageView.sd_setImage(with: dataSource?.imageURL, completed: nil)
        contentView.configure(with: PlayerControllViewModel(songName: dataSource?.songName ?? "", artistName: dataSource?.subtitle ?? ""))
    }
    
}
extension PlayerViewController : PlayerControllerDelegate{
    func sliderValueChnaged(_ playerController: PlayerControllView, slidedidSlide: Float) {
        print("Volume ------ \(slidedidSlide)")
        delegate?.sliderValueChanged(slidedidSlide)
    }
    
    func playPauseTapped(_ playerController: PlayerControllView) {
        print("play")
        delegate?.didTapPlayPause()
    }
    
    func nextSongTapped(_ playerController: PlayerControllView) {
        print("next")
        delegate?.didTapSkipForward()
    }
    
    func previousSongTapped(_ playerController: PlayerControllView) {
        print("back")
        delegate?.didTapSkipBackward()
    }
    
    
}
