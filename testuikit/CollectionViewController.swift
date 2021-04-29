//
//  CollectionViewController.swift
//  testuikit
//
//  Created by Anna Udobnaja on 29.04.2021.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {

    private var pictures = [String]()

    override func loadView() {
      collectionView = makeCollectionView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Storm Viewer"

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(ImageViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        performSelector(inBackground: #selector(loadPictures), with: nil)

        // Do any additional setup after loading the view.
    }

    @objc func loadPictures() {
      let fm = FileManager.default
      let path = Bundle.main.resourcePath!
      let items = try! fm.contentsOfDirectory(atPath: path)

      for item in items {
          if item.hasPrefix("nssl") {
            pictures.append(item)
          }
      }

      pictures.sort()

      collectionView.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: false)
    }

    private func makeLayout() -> UICollectionViewFlowLayout {
      let layout = UICollectionViewFlowLayout()

      layout.estimatedItemSize = .zero
      layout.minimumInteritemSpacing = 1


      let screenSize: CGRect = UIScreen.main.bounds
      let size = screenSize.width / 2 - 2

      layout.itemSize = CGSize(width: size, height: size + 58)

      return layout
    }

    private func makeCollectionView() -> UICollectionView {
      let layout = makeLayout()

      let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
      collectionView.backgroundColor = .white
      // ????
      collectionView.delegate = self
      collectionView.dataSource = self

      collectionView.collectionViewLayout = layout

      return collectionView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
      return pictures.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageViewCell

        cell.updateProps(text: pictures[indexPath.item], image: UIImage(named: pictures[indexPath.row])!)
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      let vc = DetailViewController()
      vc.selectedImage = pictures[indexPath.item]
      vc.title = "Picture \(indexPath.item + 1) of \(pictures.count)"

      navigationController?.pushViewController(vc, animated: false)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    @objc func shareTapped(sender : UIButton) {
      let link = NSURL(string: "https://www.instagram.com/udobnyj/") as Any
      let vc = UIActivityViewController(activityItems: ["I nave no app in App", link], applicationActivities: nil)

      //Apps to exclude sharing to
      vc.excludedActivityTypes = [
        UIActivity.ActivityType.airDrop,
        UIActivity.ActivityType.print,
        UIActivity.ActivityType.saveToCameraRoll,
        UIActivity.ActivityType.addToReadingList
      ]

      vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem

      present(vc, animated: true)
    }

}
