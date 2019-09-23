//
//  EntriesService.swift
//  iPartnerTest
//
//  Created by Kazim Gajiev on 23/09/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import Foundation

class EntriesService: BasicService {
  
  static let shared = EntriesService()
  private override init() {}
  private let userDefaults = UserDefaults.standard
  private var completion: (([Entry]?, String?) -> Void)?
  
  func fetchEntries(completion: @escaping ([Entry]?, String?) -> Void) {
    if userDefaults.string(forKey: "session") == nil {
      NotificationCenter.default.addObserver(self, selector: #selector(sessionStarted), name: NSNotification.Name("session_started"), object: nil)
    } else {
      callRequest()
      self.completion = { (entries, error) in
        completion(entries, error)
      }
    }
  }
  
  @objc private func sessionStarted() {
    callRequest()
  }
  
  private func callRequest() {
    guard let session = userDefaults.string(forKey: "session") else { return }
    let params = ["session": session]
    request(path: APIPath.GetEntries, with: params) { (json, error) in
      if let error = error {
        self.completion?(nil, error)
      }
      
      if let json = json {
        var entries = [Entry]()
        guard let results = json["data"].array else {
          self.completion?(nil, nil)
          return
        }
        
        for item in results {
          do {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let data = try item.rawData()
            let photo = try jsonDecoder.decode(Entry.self, from: data)
            entries.append(photo)
          } catch {
            print(error.localizedDescription)
          }
        }
        self.completion?(entries, nil)
      }
    }
  }
}
