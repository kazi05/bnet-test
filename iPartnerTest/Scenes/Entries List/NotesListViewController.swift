//
//  NotesListViewController.swift
//  iPartnerTest
//
//  Created by Kazim Gajiev on 23/09/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import UIKit

class NotesListViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var entries: [Entry] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(EntryTableViewCell.nib, forCellReuseIdentifier: EntryTableViewCell.name)
    let refreshControll = UIRefreshControl(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    refreshControll.addTarget(self, action: #selector(refreshing), for: .valueChanged)
    tableView.refreshControl = refreshControll
    tableView.refreshControl?.beginRefreshing()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if Reachabelity.isConnectedToNetwork() {
      fetchEntries()
    } else {
      showAlert(title: "Ошибка", message: "Проверьте подключение к инернету!") {
        self.fetchEntries()
      }
    }
  }
  
  @objc private func refreshing() {
    fetchEntries()
  }
  
  private func fetchEntries() {
    EntriesService.shared.fetchEntries { [weak self] (entries, error) in
      if let error = error {
        self?.showAlert(title: error, message: "", completion: {})
      }
      
      if let entries = entries {
        self?.entries = entries
        DispatchQueue.main.async {
          self?.tableView.reloadData()
          self?.tableView.refreshControl?.endRefreshing()
        }
      }
    }
  }
  
}

extension NotesListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return entries.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewCell.name, for: indexPath) as! EntryTableViewCell
    let entry = entries[indexPath.row]
    cell.set(entry: entry)
    return cell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let cell = cell as! EntryTableViewCell
    cell.backGroundView.layer.masksToBounds = true
  }
  
}
