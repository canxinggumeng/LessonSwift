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

    // 获取高度
    class  func getLabHeigh(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        
        let statusLabelText: NSString = labelStr as NSString
        
        let size = CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        
        return strSize.height
        
    }
    
    // 添加行间距的获取高度
class  func getLabHeighWithLineSpeace(labelStr:String,font:UIFont,width:CGFloat,lineSpeace:CGFloat) -> CGFloat {
        
        let statusLabelText: NSMutableAttributedString = NSMutableAttributedString.init(string: labelStr)
        
        let size = CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpeace
        
        statusLabelText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle,
                                     range: NSRange.init(location: 0, length: statusLabelText.length))
        statusLabelText.addAttributes(dic as! [String : Any], range: NSRange.init(location: 0, length: statusLabelText.length))
        
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).size
        
        return strSize.height
        
    }
    
    //获取宽度
    class func getLabWidth(labelStr:String,font:UIFont,height:CGFloat) -> CGFloat {
        let statusLabelText: NSString = labelStr as NSString
        let size = CGSize.init(width: CGFloat.greatestFiniteMagnitude,height: height)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
        return strSize.width
    }
    
    
}


    


