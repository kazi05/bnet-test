//
//  SessionService.swift
//  iPartnerTest
//
//  Created by Kazim Gajiev on 23/09/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import Foundation

class SessionService: BasicService {
  
  static let shared = SessionService()
  private override init() { }
  private let userDefaults = UserDefaults.standard
  
  public func startSession() {
    if userDefaults.string(forKey: "session") == nil {
      request(path: APIPath.NewSession, with: [:]) { (json, error) in
        if let error = error {
          print(error)
        }
        guard let json = json else { return }
        let session = json["data"]["session"].stringValue
        self.userDefaults.set(session, forKey: "session")
        self.userDefaults.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "session_started"), object: nil)
      }
    }
  }
}
