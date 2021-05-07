//
//  Person.swift
//  Names to Faces
//
//  Created by Anna Udobnaja on 28.04.2021.
//

import UIKit

class Person: NSObject, Codable {
  var name: String
  var image: String

  init(name: String, image: String) {
    self.name = name
    self.image = image
  }
}

//class Person: NSObject, NSCoding {
//  var name: String
//  var image: String
//
//  init(name: String, image: String) {
//    self.name = name
//    self.image = image
//  }
//
//  // from disk
//  required init?(coder decoder: NSCoder) {
//    name = decoder.decodeObject(forKey: "name") as? String ?? ""
//    image = decoder.decodeObject(forKey: "image") as? String ?? ""
//  }
//
//  // to disk
//  func encode(with coder: NSCoder) {
//    coder.encode(name, forKey: "name")
//    coder.encode(image, forKey: "image")
//  }
//}
