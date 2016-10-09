//
//  Tools.swift
//  LessonSwift
//
//  Created by iPhone on 2016/10/8.
//  Copyright © 2016年 iPhone. All rights reserved.
//

import Foundation
import UIKit

class Tools{

    
    class  func getLabHeigh(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        
        let statusLabelText: NSString = labelStr as NSString
        
        //        let size = CGSizeMa(width, 900)
        let size = CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        
        return strSize.height
        
    }
    
    
}


    


