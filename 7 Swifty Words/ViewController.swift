//
//  ViewController.swift
//  7 Swifty Words
//
//  Created by Anna Udobnaja on 26.04.2021.
//

import UIKit

class ViewController: UIViewController {
  private lazy var cluesLabel = makeBigLabel(text: "CLUES")
  private lazy var answerLabel = makeBigLabel(text: "ANSWERS", textAligment: .right)
  private lazy var currentAnswer = makeCurrentAnswer()
  private lazy var scoreLabel = makeScoreLabel()
  private var letterButtons = [UIButton]()
  private var activatedButtons = [UIButton]()
  private var solutions = [String]()
  private var correctAnswerCount = 0
  private var score = 0 {
    didSet {
      scoreLabel.text = "Score: \(score)"
    }
  }
  private var level = 1

  override func loadView() {
    view = UIView()
    view.backgroundColor = .white

    let submitBtn = makeButton(title: "SUBMIT")
    submitBtn.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)

    let clearBtn = makeButton(title: "CLEAR")
    clearBtn.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)

    let buttonsView = makeButtonsView()

    for childView in [scoreLabel, cluesLabel, answerLabel, currentAnswer, submitBtn, clearBtn, buttonsView] {
      view.addSubview(childView)
    }

    let scoreLabelConstraint = [
      scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
    ]

    let cluesLabelConstraint = [
      cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
      cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
      cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100)
    ]

    let answersLabelConstraint = [
      answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
      answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
      answerLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
      answerLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor)
    ]

    let currentAnswerConstraint = [
      currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
      currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20)
    ]

    let submitConstraint = [
      submitBtn.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
      submitBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
      submitBtn.heightAnchor.constraint(equalToConstant: 44)
    ]

    let clearConstraint = [
      clearBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
      clearBtn.centerYAnchor.constraint(equalTo: submitBtn.centerYAnchor),

      clearBtn.heightAnchor.constraint(equalToConstant: 44)
    ]

    let buttonsViewConstraint = [
      buttonsView.widthAnchor.constraint(equalToConstant: 750),
      buttonsView.heightAnchor.constraint(equalToConstant: 320),
      buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      buttonsView.topAnchor.constraint(equalTo: submitBtn.bottomAnchor, constant: 20),
      buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
    ]

    let constraints = scoreLabelConstraint + cluesLabelConstraint +
      answersLabelConstraint + currentAnswerConstraint +
      submitConstraint + clearConstraint + buttonsViewConstraint

    NSLayoutConstraint.activate(constraints)
  }


  override func viewDidLoad() {
    super.viewDidLoad()

    loadLevel()
  }

  func levelUp(action: UIAlertAction) {
    level += 1

    solutions.removeAll(keepingCapacity: true)

    loadLevel()

    for button in letterButtons {
      button.isHidden = false
    }
  }

  @objc func letterTapped(_ sender: UIButton) {
    guard let buttonTitle = sender.titleLabel?.text else {
      return
    }

    currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
    activatedButtons.append(sender)
    sender.isHidden = true
  }

  @objc func submitTapped(_ sender: UIButton) {
    guard let answerText = currentAnswer.text else {
      return
    }

    if let solutionPosition = solutions.firstIndex(of: answerText) {
      activatedButtons.removeAll()

      var splitAnswers = answerLabel.text?.components(separatedBy: "\n")
      splitAnswers?[solutionPosition] = answerText

      answerLabel.text = splitAnswers?.joined(separator: "\n")
      currentAnswer.text = ""

      score += 1
      correctAnswerCount += 1

      if correctAnswerCount % 7 == 0 {
        let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)

        ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
        present(ac, animated: true)
      }
    } else {
      score -= 1
      let ac = UIAlertController(title: "Wrong answer", message: "Try again", preferredStyle: .alert)

      ac.addAction(UIAlertAction(title: "OK", style: .default))

      present(ac, animated: true)
    }
  }

  @objc func clearTapped(_ sender: UIButton) {
    currentAnswer.text = ""

    for button in activatedButtons {
      button.isHidden = false
    }

    activatedButtons.removeAll()
  }

  private func loadLevel() {
    var clueString = ""
    var solutionString = ""
    var letterBits = [String]()

    if let levelFileUrl = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
      if let levelContents = try? String(contentsOf: levelFileUrl) {
        var lines = levelContents.components(separatedBy: "\n")
        lines.shuffle()

        for (index, line) in lines.enumerated() {
          let parts = line.components(separatedBy: ": ")
          let answer = parts[0]
          let clue = parts[1]

          clueString += "\(index + 1). \(clue)\n"

          let solutionWord = answer.replacingOccurrences(of: "|", with: "")
          solutionString += "\(solutionWord.count) letters\n"
          solutions.append(solutionWord)

          let bits = answer.components(separatedBy: "|")
          letterBits += bits
        }
      }
    }
    cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
    answerLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)

    letterButtons.shuffle()

    if letterButtons.count == letterBits.count {
      for i in 0..<letterButtons.count {
        letterButtons[i].setTitle(letterBits[i], for: .normal)
      }
    }
  }

  private func makeScoreLabel() -> UILabel {
    let label = UILabel.newAutoLayout()

    label.textAlignment = .right
    label.text = "Score: 0"

    return label
  }

  private func makeBigLabel(text: String, textAligment: NSTextAlignment = .left) -> UILabel {
    let label = UILabel.newAutoLayout()

    label.font = UIFont.systemFont(ofSize: 24)
    label.text = text
    label.numberOfLines = 0
    label.textAlignment = textAligment
    label.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)

    return label
  }

  private func makeCurrentAnswer() -> UITextField {
    let textField = UITextField.newAutoLayout()

    textField.placeholder = "Tap letters to guess"
    textField.textAlignment = .center
    textField.font = UIFont.systemFont(ofSize: 44)
    textField.isUserInteractionEnabled = false

    return textField
  }

  private func makeButton(title: String) -> UIButton {
    let button = UIButton.newAutoLayout()
    button.setTitle(title, for: .normal)
    button.setTitleColor(UIColor.systemBlue, for: .normal)

    return button
  }

  private func makeLetterButton(row: Int, column: Int) -> UIButton {
    let width = 150
    let height = 80
    let leterButton = UIButton(type: .system)
    leterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
    leterButton.setTitle("WWW", for: .normal)

    let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
    leterButton.frame = frame
    leterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
    return leterButton
  }

  private func setupLettersButton(parentView: UIView) {
    for row in 0..<4 {
      for column in 0..<5 {
        let letterButton = makeLetterButton(row: row, column: column)
        parentView.addSubview(letterButton)
        letterButtons.append(letterButton)
      }
    }
  }

  private func makeButtonsView() -> UIView {
    let buttonsView = UIView.newAutoLayout()

    buttonsView.layer.borderWidth = 1
    buttonsView.layer.borderColor = UIColor.lightGray.cgColor

    setupLettersButton(parentView: buttonsView)

    return buttonsView
  }

}

