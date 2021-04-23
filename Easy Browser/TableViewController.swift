//
//  TableViewController.swift
//  Easy Browser
//
//  Created by Anna Udobnaja on 23.04.2021.
//

import UIKit

class TableViewController: UITableViewController {

  private let websites = ["developer.apple.com", "hackingwithswift.com"]

  override func viewDidLoad() {
      super.viewDidLoad()
    
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return websites.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let viewCell = UITableViewCell()

    viewCell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator

    viewCell.textLabel?.text = websites[indexPath.row]

    return viewCell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = ViewController()

    vc.websites = websites
    vc.selectedWebsite = websites[indexPath.row]

    navigationController?.pushViewController(vc, animated: false)
  }


}
