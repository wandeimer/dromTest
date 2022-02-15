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
    var myCollectionView:UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView()
        view.backgroundColor = .white
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 300, height: 300)
        
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self

        myCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView?.backgroundColor = UIColor.white
        
        

        view.addSubview(myCollectionView ?? UICollectionView())
        self.view = view
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        myCell.backgroundColor = UIColor.blue
        return myCell
    }
}

extension ViewController: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       print("User tapped on item \(indexPath.row)")
    }
}
