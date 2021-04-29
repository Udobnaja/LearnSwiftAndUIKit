//
//  ImageViewCell.swift
//  testuikit
//
//  Created by Anna Udobnaja on 29.04.2021.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
  private lazy var imageView = makeImageView()
  private lazy var labelView = makeLabelView()
  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .white

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
    imageView.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.width)

    return imageView
  }

  private func makeLabelView() -> UILabel {
    let labelView = UILabel()
    labelView.frame = CGRect(x: 0, y: imageView.bounds.height + 10, width: contentView.bounds.width, height: 48)
    labelView.font = UIFont.systemFont(ofSize: 24)
    labelView.textAlignment = .center
    labelView.numberOfLines = 2

    return labelView
  }

  private func setupViews() {
    for childView in [imageView, labelView] {
      contentView.addSubview(childView)
    }
  }

  func updateProps(text: String, image: UIImage) {
    labelView.text = text
    imageView.image = image
  }
}
