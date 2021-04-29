//
//  ViewController.swift
//  testuikit
//
//  Created by Anna Udobnaja on 19.04.2021.
//

import UIKit

class ViewController: UITableViewController {
  private var pictures = [String]()

  override func loadView() {
    super.loadView()

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Storm Viewer"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

    performSelector(inBackground: #selector(loadPictures), with: nil)
  }

  @objc func loadPictures() {
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let items = try! fm.contentsOfDirectory(atPath: path)

    for item in items {
        if item.hasPrefix("nssl") {
          pictures.append(item)
        }
    }

    pictures.sort()

    tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pictures.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let viewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

    viewCell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator

    viewCell.textLabel?.font = viewCell.textLabel?.font.withSize(25)

    viewCell.textLabel?.text = pictures[indexPath.row]

    return viewCell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = DetailViewController()
    vc.selectedImage = pictures[indexPath.row]
    vc.title = "Picture \(indexPath.row + 1) of \(pictures.count)"

    navigationController?.pushViewController(vc, animated: false)
  }

  @objc func shareTapped(sender : UIButton) {
    let link = NSURL(string: "https://www.instagram.com/udobnyj/") as Any
    let vc = UIActivityViewController(activityItems: ["I nave no app in App", link], applicationActivities: nil)

    //Apps to exclude sharing to
    vc.excludedActivityTypes = [
      UIActivity.ActivityType.airDrop,
      UIActivity.ActivityType.print,
      UIActivity.ActivityType.saveToCameraRoll,
      UIActivity.ActivityType.addToReadingList
    ]

    vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem

    present(vc, animated: true)
  }
}

