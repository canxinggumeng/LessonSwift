//
//  DetialViewController.swift
//  LessonSwift
//
//  Created by iPhone on 2016/9/30.
//  Copyright © 2016年 iPhone. All rights reserved.
//

import Foundation
import UIKit
class DetialViewController: UIViewController {
    
    var label = ActiveLabel()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let customType = ActiveType.Custom(pattern: "\\sare\\b") //Looks for "are"
        let customType2 = ActiveType.Custom(pattern: "\\sit\\b") //Looks for "it"
        
        label.enabledTypes.append(customType)
        label.enabledTypes.append(customType2)

        label.urlMaximumLength = 50
        label.backgroundColor = Tools.hexStringToColor(hexString: "#999999")
        
       let _  = label.customize { label in
            label.text = "This is a post with #multiple# and #hashtags# and a @userhandle. Links are also supported like" +
                " this one: http://optonaut.co. Now it also supports custom patterns -> are\n\n" +
            "Let's trim a long link: \nhttps://twitter.com/twicket_app/status/649678392372121601"
            label.numberOfLines = 0
            label.lineSpacing = 10
            
            label.textColor = UIColor(red: 102.0/255, green: 117.0/255, blue: 127.0/255, alpha: 1)
            label.hashtagColor = UIColor(red: 85.0/255, green: 172.0/255, blue: 238.0/255, alpha: 1)
            label.mentionColor = UIColor(red: 238.0/255, green: 85.0/255, blue: 96.0/255, alpha: 1)
            label.URLColor = UIColor(red: 85.0/255, green: 238.0/255, blue: 151.0/255, alpha: 1)
            label.URLSelectedColor = UIColor(red: 82.0/255, green: 190.0/255, blue: 41.0/255, alpha: 1)
            
            label.handleMentionTap { self.alert(title: "Mention", message: $0) }
            label.handleHashtagTap { self.alert(title: "Hashtag", message: $0) }
            label.handleURLTap { self.alert(title: "URL", message: $0.absoluteString!) }
            
            //Custom types
            
            label.customColor[customType] = UIColor.purple
            label.customSelectedColor[customType] = UIColor.green
            label.customColor[customType2] = UIColor.magenta
            label.customSelectedColor[customType2] = UIColor.green
            
            label.handleCustomTap(for: customType) { self.alert(title: "Custom type", message: $0) }
            label.handleCustomTap(for: customType2) { self.alert(title: "Custom type", message: $0) }
        }
        
       label.frame = CGRect.init(x:10, y: 70, width: view.frame.width - 40, height: Tools.getLabHeighWithLineSpeace(labelStr: label.text!, font: label.font, width: self.view.frame.width-40, lineSpeace: CGFloat(label.lineSpacing)))
        
       self.view.addSubview(label)
        
        self.title = "ActiveLabel"
        
        // 系统的
//        self.systemNavigationItem()
       
        // 自定义的
        
        self.DIYNavigationItem()
        
    }
    
    func alert(title: String, message: String) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        vc.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(vc, animated: true, completion: nil)
    }
    
    
    // 自定义的
    
    func DIYNavigationItem(){
        
        let btn = UIButton.init(type: UIButtonType.custom)
        btn.frame = CGRect.init(x: 0, y: 0, width: 50, height: 30)
        btn.setTitle("分享", for: UIControlState.normal)
        btn.setTitleColor(UIColor.red, for: UIControlState.normal)
        let item2 = UIBarButtonItem.init(customView: btn)
        self.navigationItem.setRightBarButton(item2, animated: true)
        
        
        
    }
    
    
    func systemNavigationItem() {
        
        let rightBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit,
                                       target: self, action: #selector(self.onMove))
        self.navigationItem.setRightBarButton(rightBtn, animated: true)
    }
    
    func onMove() {
        
        print("edit")
    }
    
    
    
}
