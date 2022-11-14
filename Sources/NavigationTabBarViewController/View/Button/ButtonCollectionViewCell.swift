//
//  File.swift
//  
//
//  Created by 薮木翔大 on 2022/11/11.
//


import Foundation
import UIKit

protocol reloadDelegate: AnyObject  {
    func reload(indexPath:IndexPath)
}

class ButtonCollectionViewCell:UICollectionViewCell{
    static let identifier = "ButtonCollectionView"
    weak var delegate:reloadDelegate? = nil
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    var titleList = [String]()
    var height = CGFloat()
    var selectedIndexPath: IndexPath?
    
    var selectedText: TabColor?
    var defaultText: TabColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(titleList:[String],defalutText:TabColor,selectedText:TabColor){
        self.titleList = titleList
        self.defaultText = defalutText
        self.selectedText = selectedText
       
    }
    func configureCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        contentView.addSubview(collectionView)
        collectionView.constraints(top: contentView.topAnchor, paddingTop: 0,
                                   left: contentView.leftAnchor, paddingLeft: 0,
                                   right: contentView.rightAnchor, paddingRight: 0,
                                   bottom: contentView.bottomAnchor, paddingBottom: 0)
       
        collectionView.register(ButtonViewCell.self, forCellWithReuseIdentifier: ButtonViewCell.identifier)
        let indexPath:IndexPath = NSIndexPath(row: 0, section: 0) as IndexPath
        self.selectedIndexPath = indexPath
        DispatchQueue.main.async {
            self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        }
    }
    
   
}

extension ButtonCollectionViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonViewCell.identifier, for: indexPath) as! ButtonViewCell
        cell.configure(title: titleList[indexPath.row], defalutText: defaultText!, selectedText: selectedText!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: frame.width / CGFloat(titleList.count), height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.reload(indexPath: indexPath)
    }
    
}
