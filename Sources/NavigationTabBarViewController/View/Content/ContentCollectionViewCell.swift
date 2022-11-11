//
//  File.swift
//  
//
//  Created by 薮木翔大 on 2022/11/11.
//

import Foundation
import UIKit

class ContentCollectionViewCell:UICollectionViewCell{
    static let identifier = "ContentCollectionViewCell"
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        return cv
    }()
 
    var controllers = [UIViewController]()
    var contentViewCell = ContentViewCell()
    var height = CGFloat()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    func configure(controllers:[UIViewController]){
        self.controllers = controllers
    }
    func configureCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        contentView.addSubview(collectionView)
        collectionView.constraints(top: contentView.topAnchor, paddingTop: 0,
                                   left: contentView.leftAnchor, paddingLeft: 0,
                                   right: contentView.rightAnchor, paddingRight: 0,
                                   bottom: contentView.bottomAnchor, paddingBottom: 0)
        collectionView.register(ContentViewCell.self, forCellWithReuseIdentifier: ContentViewCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
   
}

extension ContentCollectionViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        contentViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentViewCell.identifier, for: indexPath) as! ContentViewCell
        contentViewCell.configure(view: controllers[indexPath.row].view)
        return contentViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:frame.width , height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
