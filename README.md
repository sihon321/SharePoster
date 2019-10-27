# SharePoster

[![CI Status](https://img.shields.io/travis/sihon321/SharePoster.svg?style=flat)](https://travis-ci.org/sihon321/SharePoster)
[![Version](https://img.shields.io/cocoapods/v/SharePoster.svg?style=flat)](https://cocoapods.org/pods/SharePoster)
[![License](https://img.shields.io/cocoapods/l/SharePoster.svg?style=flat)](https://cocoapods.org/pods/SharePoster)
[![Platform](https://img.shields.io/cocoapods/p/SharePoster.svg?style=flat)](https://cocoapods.org/pods/SharePoster)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
- Swift 4.2

## Installation

SharePoster is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

- An example implementation of didSelectPost
```Objective-C
- (void)didSelectPost {
    // Perform the post operation.
    // When the operation is complete (probably asynchronously), the Share extension should notify the success or failure, as well as the items that were actually shared.
 
    NSExtensionItem *inputItem = self.extensionContext.inputItems.firstObject;
 
    NSExtensionItem *outputItem = [inputItem copy];
    outputItem.attributedContentText = [[NSAttributedString alloc] initWithString:self.contentText attributes:nil];
    // Complete this implementation by setting the appropriate value on the output item.
 
    NSArray *outputItems = @[outputItem];
 
    [self.extensionContext completeRequestReturningItems:outputItems expirationHandler:nil completion:nil];
// Or call [super didSelectPost] to use the superclass's default completion behavior.
}
```

- SharePoster
```Swift
override func didSelectPost() {
  sharePoster = SharePoster(extensionContext?.inputItems)
  
  sharePoster.loadData {
      defer {
        DispatchQueue.main.async {
          self.collectionView.reloadData()
        }
      }

      self.images = sharePoster.contentsItem.getContents()
  }
}

...

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShareCollectionViewCell", 
                                                        for: indexPath) as? ShareCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    if images.isEmpty == false {
      cell.updateContents(images[indexPath.row])
    }
    
    return cell
  }
  
}
```

ContentsItem.swift
```Swift
public struct ContentsItem {
  
  var contents: [URL]
  
  var documents: [String]
  
  var urls: [(url: URL, title: String)]
  
  ...
  
}
```
## Author

sihon321, sihon321@gmail.com

## License

SharePoster is available under the MIT license. See the LICENSE file for more info.
