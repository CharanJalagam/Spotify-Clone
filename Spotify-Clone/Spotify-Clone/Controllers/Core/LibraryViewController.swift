//
//  LibraryViewController.swift
//  Spotify-Clone
//
//  Created by apple on 18/01/25.
//

import UIKit

class LibraryViewController: UIViewController {
    
    let playlistVC = LibraryPlaylistsViewController()
    let albumVC = LibraryAlbumsViewController()
    let toggleView = LibraryToggleView()
    
    let scrollView : UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        view.addSubview(toggleView)
        toggleView.delegate = self
        view.backgroundColor = .systemBackground
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.width*2, height: scrollView.height)
        addChildren()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 43, width: view.width, height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 43)
        toggleView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: 200, height: 43)
    }
    
    func addChildren(){
        addChild(playlistVC)
        scrollView.addSubview(playlistVC.view)
        playlistVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        playlistVC.didMove(toParent: self)
        addChild(albumVC)
        scrollView.addSubview(albumVC.view)
        albumVC.view.frame = CGRect(x: view.width , y: 0, width: scrollView.width, height: scrollView.height)
        albumVC.didMove(toParent: self)
    }

}
extension LibraryViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x >= (view.width - 100){
            toggleView.update(to: .album)
        }else{
            toggleView.update(to: .playlist)
        }
        
    }
}
extension LibraryViewController : toggleViewDelegate {
    func didTapPlaylist(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func didTapAlbum(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
    }
    
    
}
