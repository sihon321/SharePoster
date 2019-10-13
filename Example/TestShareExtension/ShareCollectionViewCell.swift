//
//  ShareCollectionViewCell.swift
//  TestShareExtension
//
//  Created by sihon321 on 13/10/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class ShareCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
  }
  
  func updateContents(_ url: URL) {
    if let image = try? Data(contentsOf: url) {
      imageView.image = UIImage(data: image)
    }
  }
  
}
