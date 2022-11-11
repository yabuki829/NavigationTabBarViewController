//
//  File.swift
//  
//
//  Created by 薮木翔大 on 2022/11/11.
//
import Foundation
import UIKit



class ContentViewCell:UICollectionViewCell{
    static let identifier = "ContentViewCell"
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title:String){
        label.text = title
        contentView.addSubview(label)
        label.constraints(top: contentView.topAnchor, paddingTop: 0,
                          left: contentView.leftAnchor, paddingLeft: 0,
                          right: contentView.rightAnchor, paddingRight: 0,
                          bottom: contentView.bottomAnchor, paddingBottom: 0)
    }
    
    func configure(view:UIView){
        contentView.addSubview(view)
        view.center(inView: contentView)
        view.sizing(height: self.frame.height,width: self.frame.width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(frame.height,frame.width)
        return CGSize(width:frame.width, height: frame.height )
    }
    
}
