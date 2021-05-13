//
//  CapitalViewController.swift
//  CapitalCities
//
//  Created by Anna Udobnaja on 13.05.2021.
//

import UIKit
import WebKit

class CapitalViewController: UIViewController, WKNavigationDelegate {

  private var webView: WKWebView!
  var url = ""

  private var urlToLoad: URL? {
    guard !url.isEmpty else { return nil }
    guard let url = URL(string: url) else { return nil}
    return url
  }

  override func loadView() {
    webView = WKWebView()
    webView.navigationDelegate = self
    view = webView
  }

  override func viewDidLoad() {
      super.viewDidLoad()

    if let url = urlToLoad {
      webView.load(URLRequest(url: url))
    } else {
      let ac = UIAlertController(title: "Error duiring load url", message: nil, preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))

      present(ac, animated: true)
    }
  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
