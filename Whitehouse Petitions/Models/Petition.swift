//
//  Petition.swift
//  Whitehouse Petitions
//
//  Created by Anna Udobnaja on 26.04.2021.
//

import Foundation

struct Petition: Codable {
  var title: String
  var body: String
  var signatureCount: Int
}
