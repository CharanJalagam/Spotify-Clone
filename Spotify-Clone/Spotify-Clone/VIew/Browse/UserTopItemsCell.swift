import UIKit

class UserTopItemsCell: UICollectionViewCell {
    static let identifier = "UserTopItemsCell"
    
    var isFromAlbum = false
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(albumImageView)
        contentView.addSubview(songNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.backgroundColor = .secondarySystemBackground
//        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            albumImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            albumImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            albumImageView.widthAnchor.constraint(equalToConstant: isFromAlbum ? 0 : 60),
            albumImageView.heightAnchor.constraint(equalToConstant: 60),
            
            songNameLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 10),
            songNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            songNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            artistNameLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 10),
            artistNameLabel.topAnchor.constraint(equalTo: songNameLabel.bottomAnchor, constant: 5),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    func config(viewModel: UserTopItemsViewModel) {
        setupConstraints()
        songNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        albumImageView.sd_setImage(with: viewModel.artworkUrl, placeholderImage: UIImage(systemName: "photo"))  
    }
}
