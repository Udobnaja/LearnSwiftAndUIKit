//
//  PersonCollectionViewCell.swift
//  Names to Faces
//
//  Created by Anna Udobnaja on 27.04.2021.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {
  lazy var imageView = makeImageView()
  private lazy var labelView = makeLabelView()

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .white
    layer.cornerRadius = 7

    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("Init(coder:) has not been implemented")
  }

  private func makeImageView() -> UIImageView {
    let imageView = UIImageView()

    imageView.layer.borderWidth = 2
    imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
    imageView.layer.cornerRadius = 3
    imageView.frame = CGRect(x: 10, y: 10, width: 120, height: 120)
    imageView.isUserInteractionEnabled = true

    return imageView
  }

  private func makeLabelView() -> UILabel {
    let labelView = UILabel()
    labelView.frame = CGRect(x: 10, y: 134, width: 120, height: 40)
    labelView.font = UIFont(name: "MarkerFelt-Thin", size: 16)
    labelView.textAlignment = .center
    labelView.numberOfLines = 2

    return labelView
  }

  private func setupViews() {
    for childView in [imageView, labelView] {
      contentView.addSubview(childView)
    }
  }

  func updateProps(name: String, image: UIImage) {
    labelView.text = name
    imageView.image = image
  }

  

//  lazy var width: NSLayoutConstraint = {
//      let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
//      width.isActive = true
//      return width
//  }()
//
//  override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
//      width.constant = bounds.size.width
//      return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
//  }
}
