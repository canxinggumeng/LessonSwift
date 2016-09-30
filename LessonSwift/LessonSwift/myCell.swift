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
protocol mydelegate:NSObjectProtocol {
    
    func click(imageview:UIImageView);
}

class mycell: UITableViewCell {
    
    var mylabel = UILabel();
    var myImageView = UIImageView();

    var mydelegate : mydelegate?
    var agelabel :UILabel?
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.myImageView.frame = CGRect.init(x: 5, y: 5, width: 50, height: 50);
        
        self.myImageView.image = UIImage.init(named: "test");
        self.myImageView.backgroundColor = UIColor.red;
        
        
        self.contentView.addSubview(self.myImageView);
        
        
        self.myImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(mycell.click));
        self.myImageView.addGestureRecognizer(tap);
        
        self.mylabel .frame = CGRect.init(x: 60, y: 5, width: 100, height: 15);

        self.contentView.addSubview(self.mylabel)
        
        self.agelabel = UILabel()
        self.agelabel?.frame = CGRect.init(x: 60, y: 30, width: 20, height: 15)
        self.contentView.addSubview(self.agelabel!)
        
        
    }
    
    func click() {
        
      mydelegate?.click(imageview: self.myImageView)
    }
    
    func setValueWith(item:viewModel) -> Void {
        
        self.mylabel.text = item.name
        self.agelabel?.text = String(item.age)
        let url = URL(string: item.imagePath)
        self.myImageView.kf.setImage(with: url)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
