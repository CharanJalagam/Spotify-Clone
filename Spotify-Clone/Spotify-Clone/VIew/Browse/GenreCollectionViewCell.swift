//
//  GenreCollectionViewCell.swift
//  Spotify-Clone
//
//  Created by apple on 08/03/25.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "GenreCollectionViewCell"
    
    private lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        return imageView
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 10, y: contentView.height/2 , width: contentView.width - 20, height: contentView.height/2)
        imageView.frame = CGRect(x: contentView.width/2, y: 0 , width: contentView.width/2, height: contentView.height/2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    func configure(with genre: String){
        label.text = genre
        contentView.backgroundColor = getRandomSystemColor()
        imageView.image = UIImage(systemName: getRandomMusicSFImage(), withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
    }
    
    func getRandomSystemColor() -> UIColor {
        let systemColors: [UIColor] = [
            .systemRed, .systemBlue, .systemGreen, .systemOrange,
                .systemYellow, .systemPink, .systemPurple, .systemTeal,
                .systemIndigo, .systemBrown, .systemGray
        ]
        return systemColors.randomElement() ?? .systemGray
    }
    func getRandomMusicSFImage() -> String {
        let musicSymbols = [
            "music.note",
            "music.note.list",
            "guitars",
            "pianokeys",
            "music.quarternote.3",
            "music.mic",
            "headphones",
            "radio",
            "speaker.wave.2",
            "earbuds"
        ]
        return musicSymbols.randomElement() ?? "music.note"
    }
}
