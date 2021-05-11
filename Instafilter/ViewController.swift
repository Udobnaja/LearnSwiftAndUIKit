//
//  ViewController.swift
//  Instafilter
//
//  Created by Anna Udobnaja on 07.05.2021.
//
import CoreImage
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  private lazy var mainView = makeMainView()
  private lazy var imageView = makeImageView()
  private lazy var intensityView = makeLabel("Intensity: ")
  private lazy var sliderView = makeSliderView()
  private lazy var radiusLabel = makeLabel("Radius: ")
  private lazy var radiusView = makeSliderView()
  private lazy var changeFilterBtn = makeButton("Change Filter")
  private lazy var saveBtn = makeButton("Save")
  private var currentImage: UIImage!
  private var context: CIContext!
  private var currentFilter: CIFilter!

  override func viewDidLoad() {
    super.viewDidLoad()

    setupLayout()

    mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
    mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
    mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true

    changeFilterBtn.leadingAnchor.constraint(equalTo: mainView.leadingAnchor).isActive = true
    changeFilterBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20).isActive = true

    saveBtn.trailingAnchor.constraint(equalTo: mainView.trailingAnchor).isActive = true
    saveBtn.bottomAnchor.constraint(equalTo: changeFilterBtn.bottomAnchor).isActive = true

    intensityView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    intensityView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor).isActive = true
    intensityView.bottomAnchor.constraint(equalTo: changeFilterBtn.topAnchor, constant: -20).isActive = true


    radiusLabel.heightAnchor.constraint(equalTo: intensityView.heightAnchor).isActive = true
    radiusLabel.leadingAnchor.constraint(equalTo: intensityView.leadingAnchor).isActive = true
    radiusLabel.bottomAnchor.constraint(equalTo: intensityView.topAnchor, constant: -20).isActive = true

    mainView.bottomAnchor.constraint(equalTo: radiusLabel.topAnchor, constant: -20).isActive = true

    sliderView.heightAnchor.constraint(equalTo: intensityView.heightAnchor).isActive = true
    sliderView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor).isActive = true
    sliderView.topAnchor.constraint(equalTo: intensityView.topAnchor).isActive = true
    sliderView.leadingAnchor.constraint(equalTo: intensityView.trailingAnchor, constant: 20).isActive = true

    radiusView.heightAnchor.constraint(equalTo: radiusLabel.heightAnchor).isActive = true
    radiusView.trailingAnchor.constraint(equalTo: sliderView.trailingAnchor).isActive = true
    radiusView.topAnchor.constraint(equalTo: radiusLabel.topAnchor).isActive = true
    radiusView.leadingAnchor.constraint(equalTo: sliderView.leadingAnchor).isActive = true

    imageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10).isActive = true
    imageView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10).isActive = true
    imageView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10).isActive = true
    imageView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -10).isActive = true

    saveBtn.addTarget(self, action: #selector(self.save), for: .touchUpInside)
    changeFilterBtn.addTarget(self, action: #selector(self.changeFilter), for: .touchUpInside)

    sliderView.addTarget(self, action: #selector(self.sliderChanged), for: .touchUpInside)
    radiusView.addTarget(self, action: #selector(self.sliderChanged), for: .touchUpInside)
  }

  private func setupLayout() {
    title = "InstaFilter"

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))

    context = CIContext()
    currentFilter = CIFilter(name: "CISepiaTone")
    view.backgroundColor = .white
    view.addSubview(mainView)
    view.addSubview(intensityView)
    view.addSubview(sliderView)
    view.addSubview(radiusLabel)
    view.addSubview(radiusView)
    changeFilterBtn.setTitle(currentFilter.name, for: .normal)
    view.addSubview(changeFilterBtn)
    view.addSubview(saveBtn)
    mainView.addSubview(imageView)
  }

  private func makeMainView() -> UIView {
    let view = UIView.newAutoLayout()

    view.backgroundColor = .darkGray

    return view
  }

  private func makeImageView() -> UIImageView {
    let imageView = UIImageView.newAutoLayout()

    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.alpha = 0

    return imageView
  }

  private func makeLabel(_ title: String) -> UILabel {
    let labelView = UILabel.newAutoLayout()

    labelView.text = title
    labelView.sizeToFit()

    return labelView
  }

  private func makeSliderView() -> UISlider {
    let slider = UISlider.newAutoLayout()

    return slider
  }

  private func makeButton(_ text: String) -> UIButton {
    let button = UIButton.newAutoLayout()

    button.setTitle(text, for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)

    button.heightAnchor.constraint(equalToConstant: 44).isActive = true

    return button
  }

  @objc private func save(_ sender: UIButton) {
    guard let image = imageView.image else {
      let ac = UIAlertController(title: "No Image has been selected", message: nil, preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
      return
    }
    UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
  }

  @objc private func changeFilter(_ sender: UIButton) {
    let ac = UIAlertController(title: "Choose Filter", message: nil, preferredStyle: .actionSheet)

    for filterName in ["CIBumpDistortion", "CIGaussianBlur", "CIPixellate", "CISepiaTone", "CITwirlDistortion", "CIUnsharpMask", "CIVignette"] {
      ac.addAction(UIAlertAction(title: filterName, style: .default, handler: setFilter))
    }

    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

    if let popoverController = ac.popoverPresentationController {
      popoverController.sourceView = sender
      popoverController.sourceRect = sender.bounds
    }

    present(ac, animated: true)
  }

  private func setFilter(action: UIAlertAction) {
    guard currentImage != nil else {
      return
    }

    guard let actionTitle = action.title else {
      return
    }

    currentFilter = CIFilter(name: actionTitle)
    changeFilterBtn.setTitle(currentFilter.name, for: .normal)
    let beginImage = CIImage(image: currentImage)
    currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

    applyProcessing()
  }

  @objc private func sliderChanged(_ sender: UISlider) {
    applyProcessing()
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else {
      return
    }

    dismiss(animated: true)

    currentImage = image

    let beginImage = CIImage(image: currentImage)
    currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
    applyProcessing()
  }

  @objc private func importPicture() {
    let picker = UIImagePickerController()

    picker.allowsEditing = true
    picker.delegate = self

    present(picker, animated: true)
  }

  private func applyProcessing() {
    let inputkeys = currentFilter.inputKeys

    if inputkeys.contains(kCIInputIntensityKey) {
      currentFilter.setValue(sliderView.value, forKey: kCIInputIntensityKey)
    }

    if inputkeys.contains(kCIInputRadiusKey) {
      currentFilter.setValue(radiusView.value * 200, forKey: kCIInputRadiusKey)
    }

    if inputkeys.contains(kCIInputScaleKey) {
      currentFilter.setValue(sliderView.value * 10, forKey: kCIInputScaleKey)
    }

    if inputkeys.contains(kCIInputCenterKey) {
      currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
    }

    guard let outputImage = currentFilter.outputImage else {
      return
    }

    if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
      let processedImage = UIImage(cgImage: cgImage)
      imageView.image = processedImage
      UIView.animate(withDuration: 3, delay: 0, options: [], animations: {
        self.imageView.alpha = 1
      })
    }
  }

  @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    if let error = error {
      let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)

      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
    } else {
      let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos library", preferredStyle: .alert)

      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
    }
  }


}

