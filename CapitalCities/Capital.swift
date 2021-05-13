//
//  Capital.swift
//  CapitalCities
//
//  Created by Anna Udobnaja on 12.05.2021.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
  let title: String?
  let coordinate: CLLocationCoordinate2D
  let info: String
  let url: String

  init(title: String, coordinate: CLLocationCoordinate2D, info: String, url: String) {
    self.title = title
    self.coordinate = coordinate
    self.info = info
    self.url = url
  }
}
