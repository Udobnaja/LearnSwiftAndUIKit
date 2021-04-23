//
//  ViewController.swift
//  Guess the Flag
//
//  Created by Anna Udobnaja on 22.04.2021.
//

import UIKit

class ViewController: UIViewController {

  private lazy var button1 = makeButton(tag: 0)
  private lazy var button2 = makeButton(tag: 1)
  private lazy var button3 = makeButton(tag: 2)

  var countries = [String]()
  var score = 0
  var correctAnswer = 0
  var tryCount = 0

  var currentTitle: String {
    return "\(countries[correctAnswer].uppercased()), Your score \(score)"
  }

  override func loadView() {
    super.loadView()
    view = UIView()
    view.backgroundColor = .white

    view.addSubview(button1)
    alignButton(button1, topAnchor: view.safeAreaLayoutGuide.topAnchor)

    view.addSubview(button2)
    alignButton(button2, topAnchor: button1.bottomAnchor)

    view.addSubview(button3)
    alignButton(button3, topAnchor: button2.bottomAnchor)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show my score", style: .plain, target: self, action: #selector(scoreTapped))
    countries += ["estonia", "russia", "uk", "us", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "spain"]

    askQuestion();
  }

  private func askQuestion() {
    guard tryCount < 10 else {
      let ac = UIAlertController(title: "The END, Final score \(score)", message: nil, preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "Ok", style: .default))

      present(ac, animated: true)

      button1.removeTarget(nil, action: nil, for: .allEvents)
      button2.removeTarget(nil, action: nil, for: .allEvents)
      button3.removeTarget(nil, action: nil, for: .allEvents)

      return
    }

    countries.shuffle()

    correctAnswer = Int.random(in: 0...2)

    button1.setImage(UIImage(named: countries[0]), for: .normal)
    button2.setImage(UIImage(named: countries[1]), for: .normal)
    button3.setImage(UIImage(named: countries[2]), for: .normal)

    title = currentTitle
  }

  private func continueAsking(action: UIAlertAction) {
    askQuestion()
  }

  @objc func scoreTapped(sender : UIButton) {
    let ac = UIAlertController(title: "Your score", message: String(score), preferredStyle: .alert)

    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

    present(ac, animated: true)
  }


  @objc func buttonTapped(sender : UIButton) {
    var title:String
    var message:String

    tryCount += 1

    if sender.tag == correctAnswer {
      title = "Correct"
      score += 1
      message = "Your score is \(score)"
    } else {
      title = "Wrong"
      message = "That’s the flag of \(countries[sender.tag].uppercased())"
      score -= 1
    }

    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)

    ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: continueAsking))

    present(ac, animated: true)
  }

  private func makeButton(tag t: Int) -> UIButton {
    let button = UIButton.newAutoLayout()
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.lightGray.cgColor
    button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
    button.tag = t
    //button.imageView?.contentMode = .scaleToFill .scaleAspectFit
    //button.setTitleColor(UIColor.black, for: .normal)

    return button;
  }

  private func alignButton(_ button: UIButton, topAnchor anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>) {
    button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    button.topAnchor.constraint(equalTo: anchor, constant: 40).isActive = true
    button.widthAnchor.constraint(equalToConstant: 200).isActive = true
    button.heightAnchor.constraint(equalToConstant: 100).isActive = true
  }


}

