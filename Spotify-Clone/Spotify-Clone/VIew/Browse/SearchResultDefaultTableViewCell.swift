//
//  SearchResultDefaultTableViewCell.swift
//  Spotify-Clone
//
//  Created by apple on 09/03/25.
//

import UIKit
import SDWebImage

struct SearchResultDefaultTableViewCellViewModel {
    let title: String
    let imageURL: URL?
}

class SearchResultDefaultTableViewCell: UITableViewCell {
    
    static let identifier = "SearchResultDefaultTableViewCell"
    
    let label: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        label.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        applyConstraints()
        iconImageView.layer.cornerRadius = 30
        iconImageView.layer.masksToBounds = true
        accessoryType = .disclosureIndicator
    }
    private func applyConstraints() {
        let padding: CGFloat = 10
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 60),
            iconImageView.heightAnchor.constraint(equalToConstant: 60),
            
            label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80) // Ensures minimum height
        ])
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with viewModel: SearchResultDefaultTableViewCellViewModel){
        label.text = viewModel.title
        iconImageView.sd_setImage(with: viewModel.imageURL, completed : nil)
    }
    
}
