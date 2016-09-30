//
//  ViewController.swift
//  testswfit
//
//  Created by iPhone on 2016/9/29.
//  Copyright © 2016年 iPhone. All rights reserved.
//

import UIKit
import Alamofire
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,mydelegate {
    
//    var nameList = ["1","2","3"]
    let arraymodel = NSMutableArray();
    var tableview : UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        let button = UIButton();
        //        button.frame = CGRect(x: 100, y: 100, width: 150, height: 40)
        //        button.setTitle("改变颜色", for: UIControlState.normal)
        //        button.backgroundColor = UIColor.red;
        //
        //        self.view.addSubview(button);
        //        button.addTarget(self, action: #selector(ViewController.changcolor), for: UIControlEvents.touchUpInside);
        //
        //        let textfeild = UITextField()
        //        textfeild.placeholder = "ce";
        //
        //        textfeild.frame = CGRect(x: 100, y: 150, width: 150, height: 40)
        //        self.view.addSubview(textfeild)
        //
        //
        //        var a = 10;
        //        a=20
        //        print(a)
        //
        //        self.changcolor();
        
        
        self.tableview = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height));
        self.tableview?.delegate = self;
        self.tableview?.dataSource = self;
        self.view.addSubview(self.tableview!);
        
//        creatData();
        
        alamofireRequest();
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraymodel.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return  60;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifer = "indentifer"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifer) as! mycell!
        
        if cell == nil {
            cell = mycell(style: UITableViewCellStyle.default, reuseIdentifier: identifer);
            
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none;
        if indexPath.row<arraymodel.count {
            
                cell?.setValueWith(item: arraymodel[indexPath.row] as! viewModel)
        }

        
        cell?.mydelegate = self;
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alter = UIAlertController.init(title: "提示", message: String(indexPath.row),preferredStyle: UIAlertControllerStyle.actionSheet);
        let alertViewAction: UIAlertAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            
            let detialVC = DetialViewController()
            
            self.navigationController?.pushViewController(detialVC, animated: true);
        })
        
       
        
        let alertViewCancelAction: UIAlertAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        alter.addAction(alertViewAction)
        alter.addAction(alertViewCancelAction)
        self.present(alter, animated: true) {
            
        }
        
    }
    
    
    
    
    func click(imageview :UIImageView) {
        print("点击了图片");
    }
    func changcolor( button:UIButton) -> Void {
        self.view.backgroundColor = UIColor.black;
    }
    
    func creatData() {
        
        let nameList = ["撒比套1","撒比套2","撒比套3","likun4","撒比套5","撒比套6","撒比套7","撒比套8","撒比套9","撒比套10",]
        let age = [1,2,3,4,5,6,7,8,9,10]
        
     
        for i in 0 ..< nameList.count {
            
            let dic = ["name":nameList[i],"age":age[i]] as [String : Any]
            
            let model = viewModel.init(item: dic as NSDictionary)
            
            arraymodel.add(model);
            
            
        }

        
    
    }
    
    
    func alamofireRequest() {

        let url = "http://a.haaaaaa.com/mobile/home/indexInWorks.do"
        
        let params = [
        
            "level":"1",
            "pageNo":"1",
            "pageSize":"10"
        ]
        

        NetWorkTool.POST(URLString: url, parameters: params as [String : AnyObject]?, successHandler: {(result) in
            
            if let json = result as? NSDictionary{
                
                let data = json.value(forKey: "data") as? NSDictionary
                
                let works = data?.object(forKey: "works") as? NSArray
                
                for dic in works!{
                    
                    let mode = viewModel.init(item: dic as! NSDictionary)
                    
                    self.arraymodel.add(mode);
                    
                }
                
            }
            
            self.tableview?.reloadData();

            
            }) { (error) in
                
                
        }
    
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

