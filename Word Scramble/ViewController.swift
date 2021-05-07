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
    let savedTitle = readCurrentWord()
    title = savedTitle.isEmpty ? allWords.randomElement() : savedTitle
    saveCurrentWord(title: title!)

    let savedWords = readUsedWords()
    if savedWords.isEmpty {
      usedWords.removeAll(keepingCapacity: true)
    } else {
      usedWords = savedWords
    }

    tableView.reloadData()
  }

  @objc func reloadGame() {
    saveCurrentWord(title: "")
    saveUsedWords(words: [String]())
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

          saveUsedWords(words: usedWords)

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

  private func saveCurrentWord(title: String) {
    let jsonEncoder = JSONEncoder()

    if let savedData = try? jsonEncoder.encode(title) {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: "currentWord")
    } else {
      print("Failed to save word.")
    }
  }

  private func saveUsedWords(words: [String]) {
    let jsonEncoder = JSONEncoder()

    if let savedData = try? jsonEncoder.encode(words) {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: "usedWords")
    } else {
      print("Failed to used words.")
    }
  }

  private func readCurrentWord() -> String {
    let defaults = UserDefaults.standard
    var word = ""

    if let savedWord = defaults.object(forKey: "currentWord") as? Data {
      let jsonDecoder = JSONDecoder()

      do {
        word = try jsonDecoder.decode(String.self, from: savedWord)
      } catch {
        print("Failed to load score.")
      }
    }
    return word
  }

  private func readUsedWords() -> [String] {
    let defaults = UserDefaults.standard
    var words = [String]()

    if let savedWords = defaults.object(forKey: "usedWords") as? Data {
      let jsonDecoder = JSONDecoder()

      do {
        words = try jsonDecoder.decode([String].self, from: savedWords)
      } catch {
        print("Failed to load score.")
      }
    }
    return words
  }
}

