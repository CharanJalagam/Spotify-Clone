//
//  FeaturedCell.swift
//  Spotify-Clone
//
//  Created by apple on 19/02/25.
//

import UIKit

class FeaturedCell: UICollectionViewCell {
    static let identifier = "FeaturedCell"
    
    private let albumCover: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let albumNameLbl: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLbl: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCover)
        contentView.addSubview(albumNameLbl)
        contentView.addSubview(artistNameLbl)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            albumCover.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            albumCover.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            albumCover.widthAnchor.constraint(equalToConstant: contentView.height - 20),
            albumCover.heightAnchor.constraint(equalToConstant: contentView.height - 40),
            
            albumNameLbl.topAnchor.constraint(equalTo: albumCover.bottomAnchor , constant: 2),
            albumNameLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            albumNameLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            artistNameLbl.topAnchor.constraint(equalTo: albumNameLbl.bottomAnchor, constant: 2),
            artistNameLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            artistNameLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            artistNameLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLbl.text = nil
        artistNameLbl.text = nil
        albumCover.image = nil
    }
    
    func config(viewModel: FeaturedPlaylistViewModel) {
        albumNameLbl.text = viewModel.name
        artistNameLbl.text = viewModel.createrName
        albumCover.sd_setImage(with: viewModel.artworkUrl, placeholderImage: UIImage(systemName: "photo"))
    }
}

