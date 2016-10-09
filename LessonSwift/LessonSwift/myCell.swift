//
//  myCell.swift
//  testswfit
//
//  Created by iPhone on 2016/9/29.
//  Copyright © 2016年 iPhone. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import SnapKit
protocol mydelegate:NSObjectProtocol {
    
    func click(imageview:UIImageView);
}


class mycell: UITableViewCell {
    
    var mylabel = UILabel();
    var myImageView = UIImageView();

    var mydelegate : mydelegate!
    var agelabel :UILabel!
    var desLabel = UILabel()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        self.myImageView.frame = CGRect.init(x: 5, y: 5, width: 50, height: 50);
        
        self.myImageView.image = UIImage.init(named: "test");
        self.myImageView.backgroundColor = UIColor.red;
        self.myImageView.layer.masksToBounds = true
        self.myImageView.layer.cornerRadius = 5.0
        
        self.contentView.addSubview(self.myImageView);
        
        self.myImageView.snp.makeConstraints { (make) in
            
            make.left.equalTo(5)
            make.top.equalTo(5)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        self.myImageView.layer.masksToBounds = true
        
        
        
        self.myImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(mycell.click));
        self.myImageView.addGestureRecognizer(tap);
        
        self.contentView.addSubview(self.mylabel)
        self.mylabel.snp.makeConstraints { (make) in
            
            make.left.equalTo(self.myImageView.snp.right).offset(5)
            make.top.equalTo(self.contentView.snp.top).offset(5)
            make.height.equalTo(15)
        }
        
        
//        self.agelabel = UILabel()
//        self.contentView.addSubview(self.agelabel)
//        self.agelabel?.snp.makeConstraints({ (make) in
//            make.left.equalTo(self.mylabel.snp.left)
//            make.top.equalTo(self.mylabel.snp.bottom).offset(5)
//            
//        })
        
       desLabel.numberOfLines = 0
       desLabel.font = UIFont.systemFont(ofSize: 13)
        self.contentView.addSubview(desLabel)
        desLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(self.mylabel.snp.bottom).offset(5)
            make.left.equalTo(self.mylabel.snp.left)
            
        }
        let width = UIScreen.main.bounds.size.width
        desLabel.preferredMaxLayoutWidth = width - 60
        
        
        
      
        


//        self.hyb_lastViewInCell = desLabel
//        self.hyb_bottomOffsetToCell = 10.0
        
        
       
        
        
    }
    
    func click() {
        
      mydelegate.click(imageview: self.myImageView)
    }
    
    func setValueWith(item:viewModel) -> Void {
        
        self.mylabel.text = item.name
        self.agelabel?.text = String(item.age)
        desLabel.text = item.des
        let url = URL(string: item.imagePath)
        self.myImageView.kf.setImage(with: url)
        
        let h = Tools.getLabHeigh(labelStr:  desLabel.text!, font: desLabel.font, width: desLabel.preferredMaxLayoutWidth)
        
        if 55 > (h+25){
            self.hyb_lastViewInCell = myImageView
        }else{
            self.hyb_lastViewInCell = desLabel
        }
//        self.hyb_bottomOffsetToCell = 10
    }
    
    

    class  func cellForheigh(item:viewModel) -> CGFloat {
        
        let h:CGFloat = 60
        let width = UIScreen.main.bounds.size.width

        let h1 = Tools.getLabHeigh(labelStr: item.des, font: UIFont.systemFont(ofSize: 13), width: width-60)
        
        
        if h>(h1+30) {
            return h
            
        }else{
            
            return 30+h1
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
