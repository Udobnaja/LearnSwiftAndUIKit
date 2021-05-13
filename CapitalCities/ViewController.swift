//
//  ViewController.swift
//  CapitalCities
//
//  Created by Anna Udobnaja on 12.05.2021.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

  private lazy var mapView = makeMapView()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    view.addSubview(mapView)

    mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

    let london = Capital(
      title: "Tel Aviv-Yafo",
      coordinate: CLLocationCoordinate2D(latitude: 32.0853, longitude: 34.7818),
      info: "I'm here now",
      url: "https://en.wikipedia.org/wiki/Tel_Aviv"
    )
    let oslo = Capital(
      title: "Oslo",
      coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75),
      info: "Founded over the thousand years ago",
      url: "https://en.wikipedia.org/wiki/Oslo"
    )
    let paris = Capital(
      title: "Paris",
      coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508),
      info: "Often called the City of Light",
      url: "https://en.wikipedia.org/wiki/Paris"
    )
    let rome = Capital(
      title: "Rome",
      coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5),
      info: "Has a whole country inside it",
      url: "https://en.wikipedia.org/wiki/Rome"
    )
    let washington = Capital(
      title: "Wachington",
      coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667),
      info: "Named after George himself",
      url: "https://en.wikipedia.org/wiki/Washington,_D.C."
    )

//    for capital in [london, oslo, paris, rome, washington] {
//      mapView.addAnnotation(capital)
//    }
    mapView.addAnnotations([london, oslo, paris, rome, washington])

    mapView.delegate = self

    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editMapTypeTapped))
  }

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is Capital else {
      return nil
    }

    let identifier = "Capital"

    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

//    annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//    annotationView?.canShowCallout = true
//    annotationView?.pinTintColor = UIColor.systemGreen
//
//    let btn = UIButton(type: .detailDisclosure)
//
//    annotationView?.rightCalloutAccessoryView = btn

//    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

    if annotationView == nil {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      annotationView?.canShowCallout = true
      annotationView?.pinTintColor = UIColor.systemGreen

      let btn = UIButton(type: .detailDisclosure)

      annotationView?.rightCalloutAccessoryView = btn
    } else {
      annotationView?.annotation = annotation
    }

    return annotationView
  }

  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    guard let capital = view.annotation as? Capital else {
      return
    }

    let vc = CapitalViewController()

    vc.url = capital.url

    navigationController?.pushViewController(vc, animated: false)
//    let placeName = capital.title
//    let placeInfo = capital.info
//
//    let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//
//    ac.addAction(UIAlertAction(title: "OK", style: .default))
//
//    present(ac, animated: true)
  }

  private func makeMapView() -> MKMapView {
    let result = MKMapView.newAutoLayout()

    return result
  }

  @objc private func editMapTypeTapped(_ sender: UIBarButtonItem) {
    let ac = UIAlertController(title: "Change Map Type", message: nil, preferredStyle: .alert)

    for type in ["standard", "satellite", "hybrid", "satelliteFlyover", "hybridFlyover", "mutedStandard"] {
      ac.addAction(UIAlertAction(title: type, style: .default, handler: setMapTipe))
    }

    ac.addAction(UIAlertAction(title: "OK", style: .default))

    present(ac, animated: true)
  }

  private func setMapTipe(action: UIAlertAction) {
    guard let title = action.title else {
      return
    }

    let mapType: MKMapType!

    switch title {
    case "standard":
      mapType = .standard
    case "satellite":
      mapType = .satellite
    case "hybrid":
      mapType = .hybrid
    case "satelliteFlyover":
      mapType = .satelliteFlyover
    case "hybridFlyover":
      mapType = .hybridFlyover
    case "mutedStandard":
      mapType = .mutedStandard
    default:
      mapType = .standard
    }

    mapView.mapType = mapType
  }


}

