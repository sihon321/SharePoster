//
//  ExtensionItem.swift
//  Pods
//
//  Created by sihon321 on 2019/10/18.
//

import Foundation

public enum ContentsType {
  case contents, documents, urls, all
}

public struct ContentsItem {
  
  var contents: [URL]
  
  var documents: [String]
  
  var urls: [(url: URL, title: String)]
  
  init() {
    contents = []
    documents = []
    urls = []
  }
  
  public mutating func clear(_ type: ContentsType = .all) {
    switch type {
    case .contents:
      contents.removeAll()
    case .documents:
      documents.removeAll()
    case .urls:
      urls.removeAll()
    case .all:
      contents.removeAll()
      documents.removeAll()
      urls.removeAll()
    }
  }
  
  public mutating func append(_ type: ContentsType, data: Any) {
    switch type {
    case .contents:
      if let content = data as? URL {
        contents.append(content)
      }
    case .documents:
      if let document = data as? String {
        documents.append(document)
      }
    case .urls:
      if let url = data as? (URL, String) {
        urls.append(url)
      }
    default:
      break
    }
  }
  
  public func getContents() -> [URL] {
    return contents
  }
  
  public func getDocuments() -> [String] {
    return documents
  }
  
  public func getURLs() -> [(URL, String)] {
    return urls
  }
}
