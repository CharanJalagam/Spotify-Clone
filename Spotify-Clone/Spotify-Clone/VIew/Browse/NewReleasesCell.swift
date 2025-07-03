import UIKit
import SDWebImage

class NewReleasesCell: UICollectionViewCell {
    static let identifier = "NewReleasesCell"
    
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
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLbl: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numberOfTracksLbl: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCover)
        contentView.addSubview(albumNameLbl)
        contentView.addSubview(artistNameLbl)
        contentView.addSubview(numberOfTracksLbl)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            albumCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            albumCover.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            albumCover.widthAnchor.constraint(equalToConstant: contentView.height),
            albumCover.heightAnchor.constraint(equalToConstant: contentView.height),
            
            albumNameLbl.leadingAnchor.constraint(equalTo: albumCover.trailingAnchor, constant: 10),
            albumNameLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            albumNameLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            artistNameLbl.leadingAnchor.constraint(equalTo: albumCover.trailingAnchor, constant: 10),
            artistNameLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            artistNameLbl.topAnchor.constraint(equalTo: albumNameLbl.bottomAnchor, constant: 5),
            
            numberOfTracksLbl.leadingAnchor.constraint(equalTo: albumCover.trailingAnchor, constant: 10),
            numberOfTracksLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            numberOfTracksLbl.topAnchor.constraint(equalTo: artistNameLbl.bottomAnchor, constant: 5),
            numberOfTracksLbl.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLbl.text = nil
        artistNameLbl.text = nil
        numberOfTracksLbl.text = nil
        albumCover.image = nil
    }
    
    func config(viewModel: NewReleasescellViewModel) {
        albumNameLbl.text = viewModel.name
        artistNameLbl.text = viewModel.artistName
        numberOfTracksLbl.text = "Tracks: \(viewModel.numberOfTracks)"
        albumCover.sd_setImage(with: viewModel.artworkUrl, placeholderImage: UIImage(systemName: "photo"))
    }
}
