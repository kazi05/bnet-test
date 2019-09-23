//
//  EntryDetailViewController.swift
//  iPartnerTest
//
//  Created by Kazim Gajiev on 23/09/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController, NibLoadable {
  
  @IBOutlet weak var bodyLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  var entry: Entry?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let entry = entry else { return }
    bodyLabel.text = entry.body
    let da = Int(entry.da) ?? 0
    dateLabel.text = "Дата создания: \(convertTimeStampToDateString(date: da))"
  }
  
  private func convertTimeStampToDateString(date: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(date))
    let dateformatter = DateFormatter()
    dateformatter.locale = Locale.current
    dateformatter.dateFormat = "dd MMM, HH:mm"
    return dateformatter.string(from: date)
  }
  
}
