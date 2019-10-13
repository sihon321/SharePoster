//
//  ShareViewController.swift
//  TestShareExtension
//
//  Created by sihon321 on 09/10/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SharePoster
import MobileCoreServices

class ShareViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!
  
  var sharePoster: SharePoster? = nil
  
  var images = [URL]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.dataSource = self
    collectionView.delegate = self
    
    collectionView.register(UINib(nibName: "ShareCollectionViewCell", bundle: nil),
                            forCellWithReuseIdentifier: "ShareCollectionViewCell")
    
    sharePoster = SharePoster(extensionContext?.inputItems.first)
    guard let sharePoster = sharePoster else { return }
    
    sharePoster.loadData {
      defer {
        DispatchQueue.main.async {
          self.collectionView.reloadData()
        }
      }
      
      self.images = sharePoster.contents
    }
  }
  
  @IBAction func didTappedCancel(_ sender: Any) {
    extensionContext?.completeRequest(returningItems: sharePoster?.inputItem,
                                      completionHandler: nil)
  }
  
}

extension ShareViewController: UICollectionViewDelegate {
  
}

extension ShareViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShareCollectionViewCell", for: indexPath) as? ShareCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    cell.updateContents(images[indexPath.row])
    
    return cell
  }
  
}

extension ShareViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 250.0, height: 250.0)
  }
}
