import UIKit

protocol HeaderViewDelegate : AnyObject{
    func playAllTapped(_ header : PlaylistHeaderCollectionReusableView)
}

class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    weak var delegate : HeaderViewDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Shadow settings
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.4
        imageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        imageView.layer.shadowRadius = 6
        imageView.layer.masksToBounds = false
        
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playAllButton : UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        button.backgroundColor = UIColor(named: "green")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(descLabel)
        addSubview(ownerLabel)
        addSubview(playAllButton)
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
        bringSubviewToFront(playAllButton)
        applyConstraints()
    }
    
    @objc func didTapPlayAll() {
        HapticManager.shared.vibrateForSelection()
        delegate?.playAllTapped(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playAllButton.frame = CGRect(x: width-90, y: height-65, width: 60, height: 60)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            // Image View
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: height/1.5),
            imageView.heightAnchor.constraint(equalToConstant: height/1.5),
            
            // Name Label
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Description Label
            descLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            descLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Owner Label
            ownerLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 8),
            ownerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            ownerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            ownerLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10),
            
        ])
    }
    
    // Configure method to update UI with data
    func configure(with playlist: PlaylistHeaderViewModel) {
        nameLabel.text = playlist.playlistName
        descLabel.text = playlist.description
        ownerLabel.text = "By \(playlist.ownerName)"
        imageView.sd_setImage(with: playlist.artworkUrl, placeholderImage: UIImage(systemName: "photo"))
    }
}
