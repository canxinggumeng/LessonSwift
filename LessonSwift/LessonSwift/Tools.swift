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

extension UIColor{

    // 颜色转换
    class func hexStringToColor(hexString: String) -> UIColor{
        var cString: String = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if cString.characters.count < 6 {return UIColor.black}
        if cString.hasPrefix("0X") {cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 2))}
        if cString.hasPrefix("#"){cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))}
        
        if cString.characters.count != 6 {return UIColor.black}
        
        var range: NSRange = NSMakeRange(0, 2)
        
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        Scanner.init(string: rString).scanHexInt32(&r)
        Scanner.init(string: gString).scanHexInt32(&g)
        Scanner.init(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1))
        
    }
}


