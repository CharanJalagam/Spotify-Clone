//
//  SearchResultViewController.swift
//  Spotify-Clone
//
//  Created by apple on 18/01/25.
//

import UIKit
import SafariServices

protocol SearchResultDelegate : AnyObject{
    func didSelect(_ vc : UIViewController)
}
struct SearchSection{
    let title : String
    let results : [SearchResult]
}

class SearchResultViewController: UIViewController{
    
    private var sections : [SearchSection] = []
    
    var delegate :SearchResultDelegate?
    
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier)
        tableView.register(SearchResultSubTitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubTitleTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with results : [SearchResult]){
        let artists = results.filter({
            switch $0 {
            case .artist:
                return true
            default :
                return false
            }
        })
        let albums = results.filter({
            switch $0 {
            case .album:
                return true
            default :
                return false
            }
        })
        let playlist = results.filter({
            switch $0 {
            case .playlist:
                return true
            default :
                return false
            }
        })
        let tracks = results.filter({
            switch $0 {
            case .track:
                return true
            default :
                return false
            }
        })
        self.sections = [SearchSection(title: "Songs", results: tracks),
                         SearchSection(title: "Artists", results: artists),
                         SearchSection(title: "Playlist", results: playlist),
                         SearchSection(title: "Albums", results: albums)]
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
        
        
    }
}
extension SearchResultViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let result = sections[indexPath.section].results[indexPath.row]
        switch result {
        case .album(let album):
            let acell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubTitleTableViewCell.identifier, for: indexPath) as? SearchResultSubTitleTableViewCell ?? SearchResultSubTitleTableViewCell()
            if let urlString = album.images.first?.url {
                let imageURL = URL(string: urlString) // Convert String? to URL?
                let vm = SearchResultSubTitleTableViewCellViewModel(title: album.name, subTitle: album.artists.first?.name ?? "", imageURL: imageURL)
                acell.configure(with: vm)
            }
            return acell
        case .artist(let artist):
            let acell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifier, for: indexPath) as? SearchResultDefaultTableViewCell ?? SearchResultDefaultTableViewCell()
            if let urlString = artist.images?.first?.url {
                let imageURL = URL(string: urlString) // Convert String? to URL?
                let vm = SearchResultDefaultTableViewCellViewModel(title: artist.name, imageURL: imageURL)
                acell.configure(with: vm)
            }
            return acell
        case .playlist(let playlist):
            let acell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubTitleTableViewCell.identifier, for: indexPath) as? SearchResultSubTitleTableViewCell ?? SearchResultSubTitleTableViewCell()
            if let urlString = playlist.images?.first?.url {
                let imageURL = URL(string: urlString) // Convert String? to URL?
                let vm = SearchResultSubTitleTableViewCellViewModel(title: playlist.name, subTitle : playlist.owner.display_name  , imageURL: imageURL)
                acell.configure(with: vm)
            }
            return acell
        case .track(let track):
            let acell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubTitleTableViewCell.identifier, for: indexPath) as? SearchResultSubTitleTableViewCell ?? SearchResultSubTitleTableViewCell()
            if let urlString = track.album?.images.first?.url {
                let imageURL = URL(string: urlString) // Convert String? to URL?
                let vm = SearchResultSubTitleTableViewCellViewModel(title: track.name,subTitle: track.artists.first?.name ?? "" , imageURL: imageURL)
                acell.configure(with: vm)
            }
            return acell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticManager.shared.vibrateForSelection()
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].results[indexPath.row]
        switch result {
        case .album(let model):
            let vc = AlbumViewController(album: model)
            delegate?.didSelect(vc)
        case .track(let model):
            PlaybackPresenter.shared.startPlaying(from: self, track: model)
        case .artist(let model):
            guard let url = URL(string: model.external_urls["spotify"] ?? "") else { return }
            
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        case .playlist(let model):
            let vc = PlaylistViewController(playlist: model )
            delegate?.didSelect(vc)
        }
    }
}
