//
//  TitleHeaderCollectionReusableView.swift
//  Spotify-Clone
//
//  Created by apple on 05/03/25.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "TitleHeaderCollectionReusableView"

    let label : UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .light)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 10, y: 0, width: width, height: height)
    }
        
    func configure(with title : String){
        label.text = title
    }
}
