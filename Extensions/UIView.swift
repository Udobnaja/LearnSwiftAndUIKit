//
//  UIView.swift
//  testuikit
//
//  Created by Anna Udobnaja on 26.04.2021.
//

import UIKit

extension UIView {
  public static func newAutoLayout() -> Self {
    let view = self.init()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }
}
