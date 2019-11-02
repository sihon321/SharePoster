//
//  SharePoster.swift
//  Pods
//
//  Created by sihon321 on 09/10/2019.
//

import Foundation
import MobileCoreServices

protocol Postable: class {
  
  var inputItem: [Any]? { get set }
  
  var extensionItem: NSExtensionItem? { get set }
  
  var providers: [NSItemProvider] { get set }
  
  var contentsItem: ContentsItem { get set }
}

public class SharePoster: Postable {
  
  public typealias URLCompletion = (_ url: URL, _ title: String) -> Void
  
  public var inputItem: [Any]? = nil
  
  var extensionItem: NSExtensionItem? = nil
  
  public var providers: [NSItemProvider] = []
  
  public var contentsItem = ContentsItem()
  
  public init(_ inputItem: [Any]?) {
    
    self.inputItem = inputItem
    self.extensionItem = inputItem?.first as? NSExtensionItem
    
    if let attachments = extensionItem?.attachments {
      providers = attachments
    }
  }
  
  public func loadData(uType: CFString? = nil, completion: @escaping () -> Void) {
    let group = DispatchGroup()
    
    for provider in self.providers {
      for type in provider.registeredTypeIdentifiers {
        let kUTType = uType == nil ? (type as CFString) : uType
        
        print("UTType: \(kUTType.debugDescription)")
        switch kUTType {
        case kUTTypeURL:
          group.enter()
          self.loadAttachmentedURL(provider, type) { (url, title) in
            self.contentsItem.append(.urls, data: (url, title))
            group.leave()
          }
        case kUTTypePlainText:
          group.enter()
          self.loadAttachmentedText(provider, type) { text in
            self.contentsItem.append(.documents, data: text)
            group.leave()
          }
        case kUTTypeJPEG, kUTTypeJPEG2000, kUTTypePICT,
             kUTTypeGIF, kUTTypeTIFF, kUTTypeGIF, kUTTypePNG, kUTTypeBMP,

             kUTTypeVideo, kUTTypeQuickTimeMovie, kUTTypeMPEG,
             kUTTypeMPEG2Video, kUTTypeAVIMovie, kUTTypeMPEG4,
             kUTTypeAudio, kUTTypeMPEG4Audio, kUTTypeMP3,
             
             kUTTypeGNUZipArchive, kUTTypeZipArchive,
             kUTTypePDF, kUTTypeSpreadsheet, kUTTypePresentation:
          group.enter()
          self.loadAttachmentedContent(provider, type) { url in
            self.contentsItem.append(.contents, data: url)
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
                                  completion: @escaping URLCompletion) {
    guard let provider = provider == nil ? providers.first : provider,
      let typeId = type == nil ? provider.registeredTypeIdentifiers.first : type else {
        return
    }
    
    provider.loadItem(forTypeIdentifier: typeId) { (item, error) in
      guard error == nil,
        let url = item as? URL else {
          return
      }
      
      let pattern = "<title>.*?</title>"
      if let content = try? String(contentsOf: url, encoding: .utf8),
        let titleRange = content.range(of: pattern, options:.regularExpression) {
        let titleHtml = content[titleRange]
        let startIndex = titleHtml.index(titleHtml.startIndex, offsetBy: 7)
        let endIndex = titleHtml.index(titleHtml.endIndex, offsetBy: -9)
        let title = String(titleHtml[startIndex...endIndex])
        
        completion(url, title)
      }
    }
  }
}
