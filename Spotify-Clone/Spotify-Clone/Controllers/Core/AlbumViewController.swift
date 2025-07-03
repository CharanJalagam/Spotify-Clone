//
//  AlbumViewController.swift
//  Spotify-Clone
//
//  Created by apple on 01/03/25.
//

import UIKit

class AlbumViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, HeaderViewDelegate {
    

    let album : Album
    var collectionView: UICollectionView!
    var viewModels : [UserTopItemsViewModel] = []
    var tracks : [AudioTrack] = []
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = album.name
        
        
        ApiCallers.shared.getAlbumDetails(for: album) { [weak self] res in
            switch res {
            case .success(let s):
                self?.tracks = s.tracks.items
                self?.viewModels = s.tracks.items.compactMap({
                    UserTopItemsViewModel(name: $0.name, artworkUrl: URL(string: $0.album?.images.first?.url ?? ""), artistName: $0.artists.first?.name ?? "-")
                })
            case .failure(let e):
                break
            }
            DispatchQueue.main.async{
                self?.collectionView.reloadData()
            }
        }
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
        collectionView.register(UserTopItemsCell.self, forCellWithReuseIdentifier: UserTopItemsCell.identifier)
        collectionView.register(PlaylistHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
    }
    
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return self.createSection3()
            default:
                return self.createSection3()
            }
        }
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
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
        return section
    }
    
    func playAllTapped(_ header: PlaylistHeaderCollectionReusableView) {
        
        let trackViewAlbum : [AudioTrack] = tracks.compactMap({
            var track = $0
            track.album = self.album
            return track
        })
        PlaybackPresenter.shared.startPlaying(from: self, tracks: trackViewAlbum )
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier, for: indexPath) as? PlaylistHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else{
            return UICollectionReusableView()
        }
        header.configure(with : PlaylistHeaderViewModel(playlistName: album.name, ownerName: album.artists.first?.name ?? "", description: "Release Date: \(String.formattedDate(album.release_date) ?? "")" , artworkUrl: URL(string: album.images.first?.url ?? "")))
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserTopItemsCell.identifier, for: indexPath) as? UserTopItemsCell else {
            return UICollectionViewCell()
        }
        cell.isFromAlbum = true
        cell.config(viewModel: viewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticManager.shared.vibrateForSelection()
        let trackViewAlbum : [AudioTrack] = tracks.compactMap({
            var track = $0
            track.album = self.album
            return track
        })
        PlaybackPresenter.shared.startPlaying(from: self, track: trackViewAlbum[indexPath.row])
        
    }

    

}
