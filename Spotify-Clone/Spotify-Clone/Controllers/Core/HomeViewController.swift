//
//  HomeViewController.swift
//  Spotify-Clone
//
//  Created by apple on 18/01/25.
//

import UIKit

enum BrowseSectionType {
    case newRelease(viewModels: [NewReleasescellViewModel])
    case featuredPlaylist(viewModels: [FeaturedPlaylistViewModel])
    case userTopItems(viewModels: [UserTopItemsViewModel])
    
    var title: String {
        switch self {
        case .newRelease:
            return "New Release"
        case .featuredPlaylist:
            return "Featured Playlist"
        case .userTopItems:
            return "Your Top Items"
        }
    }
}

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var collectionView: UICollectionView!
    var sections: [BrowseSectionType] = []
    var albums: [Album] = []
    var playlists: [UserPlaylist] = []
    var userTopItems : [AudioTrack] = []
    
    let supplemetaryViews =  [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
        
        fetchData()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        // Register cells
        collectionView.register(NewReleasesCell.self, forCellWithReuseIdentifier: NewReleasesCell.identifier)
        collectionView.register(FeaturedCell.self, forCellWithReuseIdentifier: FeaturedCell.identifier)
        collectionView.register(UserTopItemsCell.self, forCellWithReuseIdentifier: UserTopItemsCell.identifier)
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return self.createSection1()
            case 1:
                return self.createSection2()
            case 2:
                return self.createSection3()
            default:
                return self.createSection1()
            }
        }
    }
    
    func createSection1() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0 / 3.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(390))
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item, item, item])
        let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                         heightDimension: .absolute(390))
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitems: [verticalGroup])
        
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = supplemetaryViews
        return section
    }
    
    func createSection2() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0 / 2.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(350))
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item, item])
        let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                                         heightDimension: .absolute(350))
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitems: [verticalGroup])
        
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = supplemetaryViews
        return section
    }
    
    func createSection3() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(80))
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.boundarySupplementaryItems = supplemetaryViews
        return section
    }
    
    func fetchData() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        dispatchGroup.enter()
        dispatchGroup.enter()
        
        var newReleasesResponse: NewReleasesResponse?
        var featuredPlaylistsResponse: UserPlaylistResponse?
        var userTopItemResponse: UserTopItemsResponse?
        
        ApiCallers.shared.getNewReleases { result in
            defer { dispatchGroup.leave() }
            if case .success(let response) = result {
                newReleasesResponse = response
            }
        }
        
        ApiCallers.shared.getFeaturedPlaylists { result in
            defer { dispatchGroup.leave() }
            if case .success(let response) = result {
                featuredPlaylistsResponse = response
            }
        }
        
        ApiCallers.shared.getUserTopItems { result in
            defer { dispatchGroup.leave() }
            if case .success(let response) = result {
                userTopItemResponse = response
                
            }
        }
        
        dispatchGroup.notify(queue: .main) {
//            guard let newAlbums = newReleasesResponse?.albums.items,
//                  let playlists = featuredPlaylistsResponse?.items,let userTopItem = userTopItemResponse?.items else { return }
            self.configureDataModels(newAlbums: newReleasesResponse?.albums.items ?? [], playlists: featuredPlaylistsResponse?.items ?? [], userTopItems : userTopItemResponse?.items ?? [])
        }
    }
    
    
    
    func configureDataModels(newAlbums: [Album], playlists: [UserPlaylist], userTopItems : [AudioTrack]) {
        
        self.albums = newAlbums
        self.playlists = playlists
        self.userTopItems = userTopItems
        sections.append(.newRelease(viewModels: newAlbums.compactMap { album in
            return NewReleasescellViewModel(name: album.name,
                                            artworkUrl: URL(string: album.images.first?.url ?? ""),
                                            numberOfTracks: album.total_tracks,
                                            artistName: album.artists.first?.name ?? "")
        }))
        
        sections.append(.featuredPlaylist(viewModels: playlists.compactMap { playlist in
            return FeaturedPlaylistViewModel(name: playlist.name, artworkUrl: URL(string: playlist.images?.first?.url ?? ""), createrName: playlist.owner.display_name)
        }))
        
        sections.append(.userTopItems(viewModels: userTopItems.compactMap { topItem in
            return UserTopItemsViewModel(name: topItem.name, artworkUrl: URL(string: topItem.album?.images.first?.url ?? ""), artistName: topItem.album?.artists.first?.name ?? "")
        }))
        
        collectionView.reloadData()
    }
    
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case .newRelease(let viewModels):
            return viewModels.count
        case .featuredPlaylist(let viewModels):
            return viewModels.count
        case .userTopItems(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier, for: indexPath) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        header.configure(with: sections[indexPath.section].title)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .newRelease(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasesCell.identifier, for: indexPath) as? NewReleasesCell else {
                return UICollectionViewCell()
            }
            cell.config(viewModel: viewModels[indexPath.row])
            
            return cell
        case .featuredPlaylist(let viewModels) :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedCell.identifier, for: indexPath) as? FeaturedCell else {
                return UICollectionViewCell()
            }
            cell.config(viewModel: viewModels[indexPath.row])
            
            return cell
        case .userTopItems(let viewModels) :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserTopItemsCell.identifier, for: indexPath) as? UserTopItemsCell else {
            return UICollectionViewCell()
        }
        cell.config(viewModel: viewModels[indexPath.row])
        return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        HapticManager.shared.vibrateForSelection()
        switch section {
        case .featuredPlaylist:
            let playlist = playlists[indexPath.row]
            let vc = PlaylistViewController(playlist: playlist)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .userTopItems:
            let track = userTopItems[indexPath.row]
            PlaybackPresenter.shared.startPlaying(from: self, track: track)
        case .newRelease:
            let album = albums[indexPath.row]
            let vc = AlbumViewController(album: album)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
       
    }
}
