//
//  ViewController.swift
//  Easy Browser
//
//  Created by Anna Udobnaja on 22.04.2021.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

  private var webView: WKWebView!
  private var progressView: UIProgressView!

  var websites = [String]()
  var selectedWebsite: String!

  override func loadView() {
    webView = WKWebView()
    webView.navigationDelegate = self
    view = webView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))

    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
    let back = UIBarButtonItem(title: "<-", style: .plain, target: webView, action: #selector(webView.goBack))
    let forward = UIBarButtonItem(title: "->", style: .plain, target: webView, action: #selector(webView.goForward))

    progressView = UIProgressView(progressViewStyle: .default)
    progressView.sizeToFit()

    let progressButton = UIBarButtonItem(customView: progressView)

    toolbarItems = [back, spacer, forward, spacer, progressButton, spacer, refresh]

    navigationController?.isToolbarHidden = false

    webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    webView.allowsBackForwardNavigationGestures = true


    // can use guard but here i'm sure
    let url = URL(string: "https://\(selectedWebsite!)")!

    webView.load(URLRequest(url: url))

  }

  @objc func openTapped () {
    let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)

    websites.forEach {
      ac.addAction(UIAlertAction(title: $0, style: .default, handler: openPage))
    }
    ac.addAction(UIAlertAction(title: "cancel", style: .cancel))

    ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem

    present(ac, animated: true)
  }

  func openPage(action: UIAlertAction) {
    guard let actionTitle = action.title else {
      return
    }
    guard let url = URL(string: "https://\(actionTitle)") else {
      return
    }

    webView.load((URLRequest(url: url)))
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    title = webView.title
  }

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if  keyPath == "estimatedProgress" {
        progressView.progress = Float(webView.estimatedProgress)
    }
  }

  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    let url = navigationAction.request.url

    print(url?.host)

    if let host = url?.host {
      for website in websites {
        if host.contains(website) {
          decisionHandler(.allow)
          return
        }
      }
    }

    decisionHandler(.cancel)

    let ac = UIAlertController(title: "Oops.", message: "This site is not allowed", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

    ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem

    present(ac, animated: true)
  }


}

