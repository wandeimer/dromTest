//
//  ImageCellCollectionViewCell.swift
//  dromTest
//
//  Created by Artem Yurchenko on 16.02.2022.
//

import UIKit
class ImageCellCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
    var image: UIImage? {
      didSet {
        imageView.image = image
      }
    }
    
    var color: UIColor? {
        didSet {
            imageView.backgroundColor = color
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // set item size from screen width independent of orientation
        let screenSize: CGRect = UIScreen.main.bounds
        let itemSize = screenSize.height > screenSize.width ? screenSize.width - 20 : screenSize.height - 20
        
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: itemSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: itemSize).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
