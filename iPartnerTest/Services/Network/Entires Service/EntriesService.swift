//
//  EntriesService.swift
//  iPartnerTest
//
//  Created by Kazim Gajiev on 23/09/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import Foundation

class EntriesService: BasicService {
  
  //MARK: - Single ton
  static let shared = EntriesService()
  private override init() {}
  
  //MARK: - Private properties
  private let userDefaults = UserDefaults.standard
  private var completion: (([Entry]?, String?) -> Void)?
  
  //MARK: - Service methods
  
  /**
   Fetching data from API
   
   - returns:
    Array of Entry model
  */
  func fetchEntries(completion: @escaping ([Entry]?, String?) -> Void) {
    if userDefaults.string(forKey: "session") == nil {
      //Для первого запуска приложения
      NotificationCenter.default.addObserver(self, selector: #selector(sessionStarted), name: NSNotification.Name("session_started"), object: nil)
    } else {
      callFetchingRequest()
    }
    self.completion = { (entries, error) in
      completion(entries, error)
    }
  }
  
  /**
   Adding entry to user session
   
   - returns:
    Succes of adding
  */
  func addEntry(with body: String, completion: @escaping (Bool) -> Void) {
    if let session = userDefaults.string(forKey: "session") {
      let params = [
        "session": session,
        "body": body
      ]
      request(path: APIPath.AddEntry, with: params) { (json, error) in
        if error != nil {
          completion(false)
        }
        
        if let json = json {
          let status = json["status"].intValue
          completion(status == 1)
        }
      }
    }
  }
  
  // NotificationCenter observe method
  @objc private func sessionStarted() {
    callFetchingRequest()
  }
  
  private func callFetchingRequest() {
    guard let session = userDefaults.string(forKey: "session") else { return }
    let params = ["session": session]
    request(path: APIPath.GetEntries, with: params) { (json, error) in
      if let error = error {
        self.completion?(nil, error)
      }
      
      if let json = json {
        var entries = [Entry]()
        guard let results = json["data"].array?.first?.array else {
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
