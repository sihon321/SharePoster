//
//  SharePoster.swift
//  Pods
//
//  Created by sihon321 on 09/10/2019.
//

import Foundation
import MobileCoreServices

protocol Postable: class {
  
  var inputItem: Any? { get set }
  
  var extensionItem: NSExtensionItem? { get set }
  
  var providers: [NSItemProvider] { get set }
}

public class SharePoster: Postable {
  
  public typealias URLCompletion = (_ url: String, _ selection: String, _ title: String) -> Void
  
  public var inputItem: Any? = nil {
    didSet {
      extensionItem = inputItem as? NSExtensionItem
    }
  }
  
  var extensionItem: NSExtensionItem? = nil
  
  public var providers: [NSItemProvider] = []
  
  public var contents: [URL] = []
  
  public var documents: [String] = []
  
  public var urls: [(url: String, title: String)] = []
  
  public init(_ inputItem: Any?) {
    
    self.inputItem = inputItem
    
    if let attachments = extensionItem?.attachments as? [NSItemProvider] {
      providers = attachments
    }
  }
  
  public func loadData(completion: @escaping () -> Void) {
      let group = DispatchGroup()
      
      for provider in self.providers {
          for type in provider.registeredTypeIdentifiers {
              let kUTType = (type as CFString)
              
              switch kUTType {
              case kUTTypeURL:
                  group.enter()
                  self.loadAttachmentedURL(provider, type) { (url, title) in
                      self.urls.append((url, title))
                      group.leave()
                  }
              case kUTTypePlainText:
                  group.enter()
                  self.loadAttachmentedText(provider, type) { text in
                      self.documents.append(text)
                      group.leave()
                  }
              case kUTTypeImage, kUTTypeJPEG, kUTTypeGIF, kUTTypePNG, kUTTypeBMP,
                   kUTTypeMovie, kUTTypeVideo, kUTTypeAudio, kUTTypeQuickTimeMovie,
                   kUTTypeMPEG, kUTTypeAVIMovie, kUTTypeMP3, kUTTypeMPEG4,
                   kUTTypeGNUZipArchive, kUTTypeZipArchive,
                   kUTTypePDF, kUTTypeSpreadsheet, kUTTypePresentation:
                  group.enter()
                  self.loadAttachmentedContent(provider, type) { url in
                      self.contents.append(url)
                      group.leave()
                  }
              default:
                  break
              }
          }
      }
      
      group.notify(queue: .main) {
          completion()
      }
  }
  
  public func loadAttachmentedContents(completion: @escaping ([URL]) -> Void) {
    var urls: [URL] = []
    let group = DispatchGroup()
    let queue = DispatchQueue(label: "SharePoster")
    
    queue.async(group: group) {
      for provider in self.providers {
        self.loadAttachmentedContent(provider) { url in
          urls.append(url)
        }
      }
    }
    
    group.notify(queue: .main) {
      completion(urls)
    }
  }
  
  public func loadAttachmentedContent(_ provider: NSItemProvider? = nil,
                                      _ type: String? = nil,
                                      completion: @escaping (URL) -> Void) {
    guard let provider = provider == nil ? providers.first : provider,
      let typeId = type == nil ? provider.registeredTypeIdentifiers.first : type else {
        return
    }
    
    provider.loadItem(forTypeIdentifier: typeId,
                      options: nil) { (item, error) in
                        guard error == nil,
                          let url = item as? URL else {
                            return
                        }
                        
                        completion(url)
    }
  }
  
  public func loadAttachmentedText(_ provider: NSItemProvider? = nil,
                                   _ type: String? = nil,
                                   completion: @escaping (String) -> Void) {
    guard let provider = provider == nil ? providers.first : provider,
      let typeId = type == nil ? provider.registeredTypeIdentifiers.first : type else {
        return
    }
    
    provider.loadItem(forTypeIdentifier: typeId,
                      options: nil) { (item, error) in
                        guard error == nil,
                          let text = item as? String else {
                            return
                        }
                        
                        completion(text)
    }
  }
  
  public func loadAttachmentedURL(_ provider: NSItemProvider? = nil,
                                  _ type: String? = nil,
                                  completion: @escaping (String, String) -> Void) {
    guard let provider = provider == nil ? providers.first : provider,
      let typeId = type == nil ? provider.registeredTypeIdentifiers.first : type else {
        return
    }
    
  }

}
