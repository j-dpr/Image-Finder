//
//  PhotoCellCollectionViewCell.swift
//  Flickr
//
//  Created by Jd on 23/09/22.
//

import UIKit

class PhotoCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageCell: UIImageView!
    
    override func prepareForReuse() {
        imageCell.image = UIImage(named:"")
    }
}
