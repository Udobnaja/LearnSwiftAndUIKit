//
//  ViewController.swift
//  Word Scramble
//
//  Created by Anna Udobnaja on 23.04.2021.
//

import UIKit

class ViewController: UITableViewController {

  var allWords = [String]()
  var usedWords = [String]()

  override func loadView() {
    super.loadView()

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadGame))

    if let wordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
      if let words = try? String(contentsOf: wordsURL) {
        allWords = words.components(separatedBy: "\n")
      }
    }

    if allWords.isEmpty {
      allWords = ["silkworm"]
    }

    startGame()
  }

  private func startGame() {
    title = allWords.randomElement()
    usedWords.removeAll(keepingCapacity: true)

    tableView.reloadData()
  }

  @objc func reloadGame() {
    startGame()
  }


  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return usedWords.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let viewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

    viewCell.textLabel?.text = usedWords[indexPath.row]

    return viewCell
  }

  @objc func promptForAnswer() {
    let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)

    ac.addTextField()

    let submitAction = UIAlertAction(title: "Submit", style: .default) {
      [weak self, weak ac] _ in
      guard let answer = ac?.textFields?[0].text else { return }

      self?.submit(answer)
    }

    ac.addAction(submitAction)

    present(ac, animated: true)
  }

  private func submit(_ answer: String) {
    let lowerAnswer = answer.lowercased()

    if isPossible(word: lowerAnswer) {
      if isOriginal(word: lowerAnswer) {
        if isReal(word: lowerAnswer) {
          usedWords.insert(lowerAnswer, at: 0)

          // we not using reload data to animate
          let indexPath = IndexPath(row: 0, section: 0)
          tableView.insertRows(at: [indexPath], with: .automatic)
        } else {
          showErrorMessage(title: "Word not recognised", message: "You can't just make them up, you know!")
        }
      } else {
        showErrorMessage(title: "Word used already", message: "Be more original!")
      }
    } else {
      guard let title = title?.lowercased() else { return }
      showErrorMessage(title: "Word not possible", message: "You can't spell that word from \(title)")
    }

  }

  private func isPossible(word: String) -> Bool {
    guard var tempWord = title?.lowercased() else {
      return false
    }

    guard tempWord != word else {
      return false
    }

    for letter in word {
      if let position = tempWord.firstIndex(of: letter) {
        tempWord.remove(at: position)
      } else {
        return false
      }
    }

    return true
  }

  private func isOriginal(word: String) -> Bool {
    return !usedWords.contains(word)
  }

  private func isReal(word: String) -> Bool {
    guard word.count > 2 else {
      return false
    }

    let checker = UITextChecker()
    let range = NSRange(location: 0, length: word.utf16.count)

    let misspellRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

    return misspellRange.location == NSNotFound
  }

  private func showErrorMessage(title: String, message: String) {
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
  }
}

