
//
//  viewModel.swift
//  LessonSwift
//
//  Created by iPhone on 2016/9/30.
//  Copyright © 2016年 iPhone. All rights reserved.
//

import Foundation
import UIKit
class viewModel: NSObject {
    
     var  name:String!
    
     var  age:Int!
    
    var   address = String()
    var   imagePath :String!
    
    init(item:NSDictionary) {
        name = item.object(forKey: "artistName") as! String!
        age = item.object(forKey: "age") as! Int!
        imagePath = item.object(forKey: "path")as! String!
//        address = item.object(forKey: "address") as! String
//        image = UIImage.init(named: item.object(forKey: "image") as! String)!;
    }

    
    
    
}
