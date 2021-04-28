//
//  Person.swift
//  Names to Faces
//
//  Created by Anna Udobnaja on 28.04.2021.
//

import UIKit

class Person: NSObject {
  var name: String
  var image: String

  init(name: String, image: String) {
    self.name = name
    self.image = image
  }
}
