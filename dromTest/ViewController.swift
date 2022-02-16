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
    private var itemColor = UIColor.blue
    private var linkList : LinkList?
    private var itemSize : Double?
    let networker = NetworkManager.networkManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.main.bounds
        // set item size from screen width independent of orientation
        itemSize = screenSize.height > screenSize.width ? screenSize.width - 20 : screenSize.height - 20
        let view = UIView()
        view.backgroundColor = .white
        
        linkList = LinkList()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: itemSize ?? 0.0, height: itemSize ?? 0.0)
        
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
        // Fetch Weather Data
        refreshList()
    }
    
    private func refreshList(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("refresh")
            self.itemColor = (self.itemColor == UIColor.blue) ? UIColor.red : UIColor.blue
            print(self.itemColor)
            self.myCollectionView?.reloadData()
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
        let representedIdentifier = self.linkList!.linkList[indexPath.item]
        myCell.representedIdentifier = representedIdentifier
        
        func image(data: Data?) -> UIImage? {
          if let data = data {
            return UIImage(data: data)
          }
          return UIImage()
        }
        
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
