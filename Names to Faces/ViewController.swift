//
//  ViewController.swift
//  Names to Faces
//
//  Created by Anna Udobnaja on 27.04.2021.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  private var people = [Person]()

  override func loadView() {
    collectionView = makeCollectionView()
    alignCollectionView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
  }

//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    print("cell size")
//          return CGSize(width: 140, height: 180)
//  }

  private func makeLayout() -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()

    layout.estimatedItemSize = .zero
    // fix sizes
    layout.itemSize = CGSize(width: 140, height: 180)

    return layout
  }

  private func makeCollectionView() -> UICollectionView {
    let layout = makeLayout()

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .black
    // ????
    collectionView.delegate = self
    collectionView.dataSource = self

    collectionView.collectionViewLayout = layout
    collectionView.register(PersonCollectionViewCell.self, forCellWithReuseIdentifier: "cell")

    return collectionView
  }

  private func alignCollectionView() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
    collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
    collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
    collectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return people.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PersonCollectionViewCell

    let person = people[indexPath.item]
    let path = getDocumentsDirectory().appendingPathComponent(person.image)

    cell.updateProps(name: person.name, image: UIImage(contentsOfFile: path.path)!)
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
    cell.imageView.tag = indexPath.item
    cell.imageView.addGestureRecognizer(tapGestureRecognizer)
  
    return cell
  }

  @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
  {
    let tappedImage = tapGestureRecognizer.view as! UIImageView
    let ac = UIAlertController(title: "Rename or delete person?", message: nil, preferredStyle: .alert)
    let person = people[tappedImage.tag]

    ac.addAction(UIAlertAction(title: "Rename", style: .default) {
      [weak self] _ in
      self?.rename(person: person)
    })

    ac.addAction(UIAlertAction(title: "Delete", style: .destructive) {
      [weak self] _ in
      self?.people.remove(at: tappedImage.tag)
      self?.collectionView.reloadData()
    })

    present(ac, animated: true)
  }

  @objc func addNewPerson() {
    let picker = UIImagePickerController()

    if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
      picker.sourceType = .camera
    }

    picker.allowsEditing = true
    picker.delegate = self

    present(picker, animated: true)
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else {
      return
    }

    let imageName = UUID().uuidString
    let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

    if let jpegData = image.jpegData(compressionQuality: 0.8) {
      try? jpegData.write(to: imagePath)
    }

    let person = Person(name: "UnKnown", image: imageName)
    people.append(person)

    collectionView.reloadData()

    dismiss(animated: true)
  }

  func getDocumentsDirectory() -> URL {
      let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      let documentsDirectory = paths[0]
      return documentsDirectory
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let person = people[indexPath.item]

    rename(person: person)
  }

  private func rename(person: Person){
    let ac = UIAlertController(title: "Rename person?", message: nil, preferredStyle: .alert)

    ac.addTextField()
    ac.addAction(UIAlertAction(title: "OK", style: .default) {
      [weak self, weak ac] _ in
      guard let newName = ac?.textFields?[0].text else { return }
      person.name = newName
      self?.collectionView.reloadData()
    })

    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

    present(ac, animated: true)
  }
}

//extension ViewController: UICollectionViewDataSource {
//
//}
//
//extension ViewController: UICollectionViewDelegateFlowLayout {
//
//}

