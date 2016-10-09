
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
    var   des:String!
    var   Ids : String!
    
    
    init(item:NSDictionary) {
        name = item.object(forKey: "artistName") as! String!
        age = item.object(forKey: "age") as! Int!
        imagePath = item.object(forKey: "path")as! String!
        des = item.object(forKey: "description") as! String!
        
        Ids = String(item.object(forKey: "artistId") as! Int!)
        //        address = item.object(forKey: "address") as! String
//        image = UIImage.init(named: item.object(forKey: "image") as! String)!;
    }

    
    
    
}
