//
//  BasicService.swift
//  iPartnerTest
//
//  Created by Kazim Gajiev on 23/09/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BasicService {
  
  fileprivate struct APIConstants {
    static let host = "https://bnet.i-partner.ru/testAPI/"
    
    static let headers: HTTPHeaders = [
      "token": "gEyUJKD-Ln-TrAGKEj"
    ]
  }
  
  
  func request(path: APIPath, with params: Parameters, completion: @escaping (_ json: JSON?, _ error: String?) -> Void) {
    let fullUrlString = String(format: "%@/", APIConstants.host)
    
    var allParams = ["a": path.rawValue]
    params.forEach { allParams[$0.key] = $0.value as? String }
    
    Alamofire
      .request(fullUrlString, method: .post, parameters: allParams, encoding: URLEncoding.default, headers: APIConstants.headers)
      .responseJSON { (response) in
        switch response.result {
        case .failure(let error): completion(nil, error.localizedDescription)
        case .success(let value):
          let json = JSON(value)
          completion(json, nil)
        }
    }
  }
}

enum APIPath: String {
  case NewSession = "new_session"
  case GetEntries = "get_entries"
  case AddEntry = "add_entry"
}

