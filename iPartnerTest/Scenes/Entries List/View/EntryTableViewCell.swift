//
//  EntryTableViewCell.swift
//  iPartnerTest
//
//  Created by Kazim Gajiev on 23/09/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell, NibLoadable {
  
  @IBOutlet weak var bodyTextLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var backGroundView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
    backGroundView.layer.cornerRadius = 10
    backGroundView.layer.masksToBounds = false
    backGroundView.layer.shadowOpacity = 0.23
    backGroundView.layer.shadowRadius = 4
    backGroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
    backGroundView.layer.shadowColor = UIColor.black.cgColor
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
  }
  
  func set(entry: Entry) {
    bodyTextLabel.text = entry.body
    let da = Int(entry.da) ?? 0
    let dm = Int(entry.dm) ?? 0
    
    dateLabel.text = dm > da ? "Изменено: \(convertTimeStampToDateString(date: dm))" : convertTimeStampToDateString(date: da)
  }
  
  private func convertTimeStampToDateString(date: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(date))
    let dateformatter = DateFormatter()
    dateformatter.locale = Locale.current
    dateformatter.dateFormat = "dd MMM, HH:mm"
    return dateformatter.string(from: date)
  }
}
