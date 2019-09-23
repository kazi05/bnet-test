//
//  AddEntryViewController.swift
//  iPartnerTest
//
//  Created by Kazim Gajiev on 23/09/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import UIKit

class AddEntryViewController: UIViewController, UITextViewDelegate {
  
  @IBOutlet weak var textView: UITextView!
  
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textView.text = "Введите текст"
    textView.textColor = UIColor.lightGray
    textView.delegate = self
  }
  
  //MARK: - UITextViewDelegate
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
      textView.text = ""
      textView.textColor = UIColor.black
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "Введите текст"
      textView.textColor = UIColor.lightGray
    }
  }
  
  //MARK: - IBActions
  @IBAction func actionDissmis(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func actionAddEntry(_ sender: Any) {
    if Reachabelity.isConnectedToNetwork() {
      let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
      activityIndicator.style = .gray
      let barButton = UIBarButtonItem(customView: activityIndicator)
      self.navigationItem.setRightBarButton(barButton, animated: true)
      activityIndicator.startAnimating()
      if textView.text.isEmpty {
        showAlert(title: "Ошибка", message: "Заполните обязательное поле!", completion: {})
      }else {
        EntriesService.shared.addEntry(with: textView.text) { [weak self] (succes) in
          if succes {
            self?.dismiss(animated: true, completion: nil)
          }
        }
      }
    } else {
      showAlert(title: "Ошибка!", message: "Проверьте соединение с интернетом!", completion: {})
    }
  }
  
}
