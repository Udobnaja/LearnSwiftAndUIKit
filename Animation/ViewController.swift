//
//  ViewController.swift
//  Animation
//
//  Created by Anna Udobnaja on 11.05.2021.
//

import UIKit

class ViewController: UIViewController {

  private lazy var tapBtn = makeButton()
  private lazy var imageView = makeImageView()
  var currentAnimation = 0

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white
    view.addSubview(tapBtn)

    view.addSubview(imageView)

    tapBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
    tapBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    tapBtn.addTarget(self, action: #selector(tapped), for: .touchUpInside)
  }

  private func makeButton() -> UIButton {
    let button = UIButton.newAutoLayout()

    button.setTitle("Tap", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)

    button.heightAnchor.constraint(equalToConstant: 44).isActive = true

    return button
  }

  private func makeImageView() -> UIImageView {
    let imageView = UIImageView.newAutoLayout()

    imageView.image = UIImage(named: "penguin")

    return imageView
  }

  @objc private func tapped(_ sender: UIButton) {
    sender.isHidden = true

    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {

//    UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
      switch self.currentAnimation {
      case 0:
        self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
      case 1:
        self.imageView.transform = .identity
      case 2:
        self.imageView.transform = CGAffineTransform(translationX: -150, y: -150)
      case 3:
        self.imageView.transform = .identity
      case 4:
        self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
      case 5:
        self.imageView.transform = .identity
      case 6:
        self.imageView.alpha = 0.1
        self.imageView.backgroundColor = .green
      case 7:
        self.imageView.alpha = 1
        self.imageView.backgroundColor = .clear
      default:
        break
      }
    }) {
      finished in
      sender.isHidden = false
    }

    currentAnimation += 1

    if currentAnimation > 7 {
      currentAnimation = 0
    }
  }


}

