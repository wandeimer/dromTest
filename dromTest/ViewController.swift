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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.main.bounds
        // set item size from screen width independent of orientation
        let itemSize = screenSize.height > screenSize.width ? screenSize.width - 20 : screenSize.height - 20
        let view = UIView()
        view.backgroundColor = .white
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        refreshControl.addTarget(self, action: #selector(refreshListObjc(_:)), for: .valueChanged)
        
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
        myCollectionView?.refreshControl = refreshControl

        myCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
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
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        myCell.backgroundColor = itemColor
        return myCell
    }
}

extension ViewController: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       print("User tapped on item \(indexPath.row)")
    }
}
