//
//  ViewController.swift
//  Auto Layout
//
//  Created by Anna Udobnaja on 26.04.2021.
//

import UIKit

class ViewController: UIViewController {

  private lazy var label1 = makeLabel(text: "THESE", backgroundColor: UIColor.red)
  private lazy var label2 = makeLabel(text: "ARE", backgroundColor: UIColor.cyan)
  private lazy var label3 = makeLabel(text: "SOME", backgroundColor:  UIColor.yellow)
  private lazy var label4 = makeLabel(text: "AWESOME", backgroundColor:  UIColor.green)
  private lazy var label5 = makeLabel(text: "LABELS", backgroundColor:  UIColor.orange)

  private var labelsViews = [UILabel]()

  override func loadView() {
    super.loadView()
    view = UIView()
    view.backgroundColor = .white
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    labelsViews = [label1, label2, label3, label4, label5]

    setupViews()

    // Learn withVisualFormat
//    let viewsDictionary = [
//      "label1": label1,
//      "label2": label2,
//      "label3": label3,
//      "label4": label4,
//      "label5": label5,
//    ]
//
//    for label in viewsDictionary.keys {
//      view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
//    }
//
//    let metrics = ["labelHeight": 88]
//
//    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|", options: [], metrics: metrics, views: viewsDictionary))

    alignViews()
  }

  private func alignLables() {
    var previous: UILabel?
    for label in labelsViews {
      label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
      label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

      if let previous = previous {
        label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
        label.heightAnchor.constraint(equalTo: previous.heightAnchor).isActive = true
      } else {
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        let constraint = label.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1/5, constant: -10)
        constraint.priority = UILayoutPriority(999)
        constraint.isActive = true
      }

      previous = label
    }
  }

  private func alignViews() {
    alignLables()

    view.safeAreaLayoutGuide.bottomAnchor.constraint(greaterThanOrEqualTo: label5.bottomAnchor, constant: 10).isActive = true
  }

  private func setupViews() {
    for label in labelsViews {
      view.addSubview(label)
    }
  }

  private func makeLabel(text: String, backgroundColor: UIColor) -> UILabel {
    let label = UILabel.newAutoLayout()
    label.backgroundColor = backgroundColor
    label.text = text
    label.sizeToFit()

    return label;
  }


}

