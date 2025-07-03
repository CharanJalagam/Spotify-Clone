//
//  SearchResultDefaultTableViewCell.swift
//  Spotify-Clone
//
//  Created by apple on 09/03/25.
//

import UIKit
import SDWebImage

struct SearchResultSubTitleTableViewCellViewModel {
    let title: String
    let subTitle: String
    let imageURL: URL?
}

class SearchResultSubTitleTableViewCell: UITableViewCell {
    
    static let identifier = "SearchResultSubTitleTableViewCell"
    
    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    let subLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
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
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.addSubview(subLabel)
        applyConstraints()
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
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            subLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            subLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
            subLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            subLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -padding)
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
    
    func configure(with viewModel: SearchResultSubTitleTableViewCellViewModel){
        label.text = viewModel.title
        subLabel.text = viewModel.subTitle
        iconImageView.sd_setImage(with: viewModel.imageURL, completed : nil)
    }
    
}
