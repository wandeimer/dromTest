//
//  ViewController.swift
//  dromTest
//
//  Created by Artem Yurchenko on 16.02.2022.
//

import UIKit

//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//
//
//    }
//
//}

class ViewController : UIViewController {
    private var myCollectionView:UICollectionView?
    private let refreshControl = UIRefreshControl()
    private var itemColor = UIColor.blue // color items while image is not loaded
    private var linkList : LinkList?
    private var itemSize : Double? // size of image(without edge insets)
    let networker = NetworkManager.networkManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = UIView()
        view.backgroundColor = .white
        
        // get item size from screen width independent of orientation
        let screenSize: CGRect = UIScreen.main.bounds
        itemSize = screenSize.height > screenSize.width ? screenSize.width - 20 : screenSize.height - 20
        
        linkList = LinkList() // load list of image link
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // edge insets of Collection View
        layout.itemSize = CGSize(width: itemSize ?? 0.0, height: itemSize ?? 0.0) // set size of item (include edge insets)
        
        refreshControl.addTarget(self, action: #selector(refreshListObjc(_:)), for: .valueChanged)
        
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
        myCollectionView?.refreshControl = refreshControl

        myCollectionView?.register(ImageCellCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView?.backgroundColor = UIColor.white
        
        

        view.addSubview(myCollectionView ?? UICollectionView())
        self.view = view
    }
    
    @objc private func refreshListObjc(_ sender: Any) {
        refreshList()
    }
    
    private func refreshList(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // add delay
            // change item fill color(while has no image)
            self.itemColor = (self.itemColor == UIColor.blue) ? UIColor.red : UIColor.blue
            
            // refresh Collection View
            self.myCollectionView?.reloadData()
            
            // disable refresh indicator
            self.refreshControl.endRefreshing()
        }
    }
}



extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let countOfCell : Int = self.linkList?.linkList.count ?? 0
        return countOfCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! ImageCellCollectionViewCell
        
        myCell.color = self.itemColor
        
        // setting an identifier for a cell so that only the image that corresponds to it gets into the cell
        let representedIdentifier = self.linkList!.linkList[indexPath.item]
        myCell.representedIdentifier = representedIdentifier
        
        // check "data received". if not - return an empty UIImage
        func image(data: Data?) -> UIImage? {
          if let data = data {
            return UIImage(data: data)
          }
          return UIImage()
        }
        
        // load image data from url and set image to myCell
        if (self.linkList != nil){
            let url = URL(string: self.linkList!.linkList[indexPath.item])!
            networker.download(imageURL: url) { data, error  in
              let img = image(data: data)
              DispatchQueue.main.async {
                if (myCell.representedIdentifier == representedIdentifier) {
                        myCell.image = img
                }
              }
            }
        }
        return myCell
    }
}

extension ViewController: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       print("User tapped on item \(indexPath.row)")
    }
}
