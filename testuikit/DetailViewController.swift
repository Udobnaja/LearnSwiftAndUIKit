//
//  DetailViewController.swift
//  testuikit
//
//  Created by Anna Udobnaja on 19.04.2021.
//

import UIKit

class DetailViewController: UIViewController {
  var selectedImage:String?
  let imageView = UIImageView()

  override func loadView() {
    super.loadView()

    imageView.contentMode = .scaleToFill
    imageView.frame = self.view.frame

    self.view.addSubview(imageView)
  }

  override func viewDidLoad() {
      super.viewDidLoad()

      navigationItem.largeTitleDisplayMode = .never
      // Selectors are effectively the names of methods on an object or struct,
      // and they are used to execute some code at runtime. They were common in Objective-C
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

      if let realImage = selectedImage {
        imageView.image = UIImage(named: realImage)
      }

        // Do any additional setup after loading the view.
    }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.hidesBarsOnTap = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.hidesBarsOnTap = false
  }

  // By default Swift generates code that is only available to other Swift code,
  // but if you need to interact with the Objective-C runtime use @objc
  @objc func shareTapped(sender : UIButton) {
    guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
      let ac = UIAlertController(title: "No image found", message: nil, preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "Ok", style: .default))

      present(ac, animated: true)

      return
    }
    // plist NSPhotoLibraryAddUsageDescription - Privacy - Photo Library Additions ...
    let vc = UIActivityViewController(activityItems: [image, selectedImage as Any], applicationActivities: [])

    vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    
    // Presents a view controller modally
    present(vc, animated: true)
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
