//
//  Ext+UIViewController.swift
//  iPartnerTest
//
//  Created by Kazim Gajiev on 23/09/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import UIKit

extension UIViewController {
  
  public func showAlert(title: String, message: String, completion: @escaping () -> Void) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
      completion()
    }
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
}
