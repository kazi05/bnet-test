//
//  Reachabelity.swift
//  iPartnerTest
//
//  Created by Kazim Gajiev on 23/09/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import Foundation
import SystemConfiguration

open class Reachabelity {
  
  class func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAdress in
        SCNetworkReachabilityCreateWithAddress(nil, zeroSockAdress)
      }
    }
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
      return false
    }
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    return (isReachable && !needsConnection)
  }
  
}
