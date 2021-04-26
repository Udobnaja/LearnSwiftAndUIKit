//
//  ViewController.swift
//  Whitehouse Petitions
//
//  Created by Anna Udobnaja on 26.04.2021.
//

import UIKit

class ViewController: UITableViewController {
  private var petitions = [Petition]()
  private var filterdPetitions = [Petition]()

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterButtonTapped))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(creditButtonTapped))

    let urlString: String

    if navigationController?.tabBarItem.tag == 0 {
        // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
    } else {
        // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
    }
    
    // fetch here lock the screen, improve it later
    if let url = URL(string: urlString) {
      if let data = try? Data(contentsOf: url) {
        parse(json: data)
        filterdPetitions = petitions
        return
      }
    }

    showError()
  }

  private func parse(json: Data) {
    let decoder = JSONDecoder()

    if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
      petitions = jsonPetitions.results

      tableView.reloadData()
    }
  }

  private func showError() {
    let ac = UIAlertController(
      title: "Loading error",
      message: "There was a problem loading the feed, please check your connection and try again",
      preferredStyle: .alert
    )

    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filterdPetitions.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let viewCell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
    let petition = filterdPetitions[indexPath.row]

    viewCell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator

    viewCell.textLabel?.text = petition.title
    viewCell.detailTextLabel?.text = petition.body

    return viewCell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = DetailViewController()
    vc.detailPetition = filterdPetitions[indexPath.row]

    navigationController?.pushViewController(vc, animated: false)
  }

  @objc func creditButtonTapped(sender : UIButton) {
    let ac = UIAlertController(
      title: "Info",
      message: "There is information from https://api.whitehouse.gov",
      preferredStyle: .alert
    )

    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }

  @objc func filterButtonTapped(sender : UIButton) {
    let ac = UIAlertController(
      title: "Filter Petitions",
      message: "Enter the searching word",
      preferredStyle: .alert
    )

    ac.addTextField()
    let submitAction = UIAlertAction(title: "Submit", style: .default) {
      [weak self, weak ac] _ in
      guard let petition = ac?.textFields?[0].text else { return }

      self?.submit(petition)
    }

    ac.addAction(submitAction)
    
    present(ac, animated: true)
  }

  private func submit(_ petition: String) {
    filterdPetitions = petitions.filter {
      $0.title.localizedCaseInsensitiveContains(petition)
    }

    tableView.reloadData()
  }

}

