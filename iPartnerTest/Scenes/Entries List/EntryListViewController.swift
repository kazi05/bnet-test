//
//  NotesListViewController.swift
//  iPartnerTest
//
//  Created by Kazim Gajiev on 23/09/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import UIKit

class EntryListViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var entries: [Entry] = []
  
  
  //MARK: - Lifecycle
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
      showAlert(title: "Ошибка", message: "Проверьте подключение к инернету!", and: "Обновить данные") {
        self.fetchEntries()
      }
    }
  }
  
  //MARK: - Objc functions
  @objc private func refreshing() {
    fetchEntries()
  }
  
  //MARK: - Service methods
  private func fetchEntries() {
    EntriesService.shared.fetchEntries { [weak self] (entries, error) in
      if let error = error {
        self?.showAlert(title: error, message: "", completion: {})
      }
      
      if let entries = entries {
        self?.entries = entries
        DispatchQueue.main.async {
          self?.tableView.refreshControl?.endRefreshing()
          self?.tableView.reloadData()
        }
      }
    }
  }
  
}

//MARK: - UITableViewDelegate
extension EntryListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if self.entries.count == 0 {
      let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
      emptyLabel.text = "Нет записей"
      emptyLabel.textAlignment = NSTextAlignment.center
      self.tableView.backgroundView = emptyLabel
      self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
      return 0
    } else {
      tableView.backgroundView = nil
      return entries.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewCell.name, for: indexPath) as! EntryTableViewCell
    let entry = entries[indexPath.row]
    cell.set(entry: entry)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let entry = entries[indexPath.row]
    let sb = UIStoryboard(name: "Main", bundle: nil)
    let entryDetailVC = sb.instantiateViewController(withIdentifier: "EntryDetail") as! EntryDetailViewController
    entryDetailVC.entry = entry
    navigationController?.pushViewController(entryDetailVC, animated: true)
  }
  
}
