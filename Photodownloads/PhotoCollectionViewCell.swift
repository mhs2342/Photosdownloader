//
//  PhotoCollectionViewCell.swift
//  Photodownloads
//
//  Created by Anthony Guella on 7/22/19.
//  Copyright © 2019 Matt Sanford. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func setImage(_ image: UIImage) {
        self.imageView.image = image
    }
    
    override func prepareForReuse() {
        self.imageView.image = nil
    }
}
