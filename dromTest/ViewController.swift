//
//  ViewController.swift
//  dromTest
//
//  Created by Artem Yurchenko on 16.02.2022.
//

import UIKit

class ViewController : UIViewController {
    private var myCollectionView:UICollectionView?
    private let refreshControl = UIRefreshControl()
    private var itemColor = UIColor.blue // color items while image is not loaded
    private var linkListObject = LinkList()
    private var linkList : [String] = []
    private var itemSize : Double? // size of image(without edge insets)
    let networker = NetworkManager.networkManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = UIView()
        view.backgroundColor = .white
        linkList = linkListObject.linkList // load list of image link
        
        refreshControl.addTarget(self, action: #selector(refreshListObjc(_:)), for: .valueChanged)
        
        // get item size from screen width independent of orientation
        let screenSize: CGRect = UIScreen.main.bounds
        itemSize = screenSize.height > screenSize.width ? screenSize.width - 20 : screenSize.height - 20
        
        // MARK: init collectionView
        myCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.init())
        addEdgeInsetsToCollectionView()
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
        myCollectionView?.refreshControl = refreshControl
        myCollectionView?.register(ImageCellCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView?.backgroundColor = UIColor.white
        
        
        // MARK: place collectionView
        view.addSubview(myCollectionView!)
        self.myCollectionView!.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myCollectionView!.topAnchor.constraint(equalTo: view.topAnchor),
            myCollectionView!.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            myCollectionView!.leftAnchor.constraint(equalTo: view.leftAnchor),
            myCollectionView!.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
        
        self.view = view
    }
    
    @objc private func refreshListObjc(_ sender: Any) {
        refreshList()
    }
    
    // MARK: refresh list
    private func refreshList(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // add delay
            
            self.linkList = self.linkListObject.linkList
            // refresh Collection View
            self.myCollectionView?.reloadData()
            
            // disable refresh indicator
            self.refreshControl.endRefreshing()
        }
    }
    
    func addEdgeInsetsToCollectionView(){
        // MARK: set item size
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize!, height: itemSize!) // set size of item (include edge insets)

        myCollectionView?.setCollectionViewLayout(layout, animated: true)
    }

    // MARK: get insets to place image to center
    func getSidesInsets(cellWidth: Double, numberOfItems: Double, spaceBetweenCell: Double, collectionView: UICollectionView) -> UIEdgeInsets {
        let totalWidth = cellWidth * numberOfItems
        let totalSpacingWidth = spaceBetweenCell * (numberOfItems - 1)
        let leftInset = (collectionView.frame.width - CGFloat(totalWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
}



extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.linkList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! ImageCellCollectionViewCell
        
        myCell.color = self.itemColor
        
        // setting an identifier for a cell so that only the image that corresponds to it gets into the cell
        let representedIdentifier = self.linkList[indexPath.item]
        myCell.representedIdentifier = representedIdentifier
        
        // MARK: check "data received".
        // if not - return an empty UIImage
        func image(data: Data?) -> UIImage? {
          if let data = data {
            return UIImage(data: data)
          }
          return UIImage()
        }
        
        // MARK: load image data from url and set image to myCell
        if (self.linkList != []){
            let url = URL(string: self.linkList[indexPath.item])!
            networker.download(imageURL: url) { data, error  in
              let img = image(data: data)
              DispatchQueue.main.async {
                if (myCell.representedIdentifier == representedIdentifier) { // check "is loaded image need to this cell"
                        myCell.image = img
                }
              }
            }
        }
        return myCell
    }
}

extension ViewController: UICollectionViewDelegate {
    // MARK: delete item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let prevIndexPath = IndexPath(row: indexPath.item, section: indexPath.section)
//        let previousCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: prevIndexPath) as! ImageCellCollectionViewCell
//        previousCell.animationDelete()
        
        self.linkList.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
        collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: set image size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemSize!, height: itemSize!)
    }
    
    // MARK: set cell at center
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let edgeInsets = getSidesInsets(cellWidth: itemSize!, numberOfItems: 1, spaceBetweenCell: 0, collectionView: myCollectionView!)
        return UIEdgeInsets(top: 0, left: edgeInsets.left, bottom: 0, right: edgeInsets.right)
        }

    // MARK: set indent between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
}
