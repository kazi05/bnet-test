//
//  NotesListViewController.swift
//  iPartnerTest
//
//  Created by Kazim Gajiev on 23/09/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import UIKit

class NotesListViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    EntriesService.shared.fetchEntries { (entries, error) in
      print("Entries: \(entries)")
    }
  }
  
}
