//
//  ViewController.swift
//  testswfit
//
//  Created by iPhone on 2016/9/29.
//  Copyright © 2016年 iPhone. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,mydelegate {
    
//    var nameList = ["1","2","3"]
    let arraymodel = NSMutableArray();
    var tableview : UITableView!
    var pageNo = 1
    

    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        self.tableview.frame = self.view.frame;
    }
    
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
        
        self.title = "TableViewList"
        self.tableview = UITableView.init(frame: self.view.frame);
        self.tableview.delegate = self;
        self.tableview.dataSource = self;
//        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(self.tableview);
        

       let _ =   self.tableview.es_addPullToRefresh{
        
            [weak self] in
            self?.refreshHeader()
            
        }
        
      let _ =   self.tableview.es_addInfiniteScrolling {
           
            
            [weak self] in
            self?.refreshFooter()
            
            }
        self.tableview.es_startPullToRefresh()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraymodel.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        if arraymodel.count>0 {
            
            let model = arraymodel[indexPath.row] as! viewModel
            
            // 采用第三方
            return mycell.hyb_cellHeight(forTableView: tableView, config: { (cell) in
                
                let itemCell = cell as? mycell
                itemCell?.setValueWith(item: model )
                
                }, updateCacheIfNeeded: { () -> (key: String, stateKey: String, shouldUpdate: Bool) in
                    return (model.Ids," ",true)
            })+10
            
            // 自己写的方法
//            return mycell.cellForheigh(item: model)
            
            
        }else{
        
            return 0
        }
       
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
        
        let detialVC = DetialViewController()
        
        self.navigationController?.pushViewController(detialVC, animated: true);
//        let alter = UIAlertController.init(title: "提示", message: String(indexPath.row),preferredStyle: UIAlertControllerStyle.actionSheet);
//        let alertViewAction: UIAlertAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
//            
//            let detialVC = DetialViewController()
//            
//            self.navigationController?.pushViewController(detialVC, animated: true);
//        })
//        
//       
//        
//        let alertViewCancelAction: UIAlertAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
//        alter.addAction(alertViewAction)
//        alter.addAction(alertViewCancelAction)
//        self.present(alter, animated: true) {
//            
//        }
        
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
    
    
    func refreshHeader() {
    
        pageNo = 1
        arraymodel.removeAllObjects()
        
        alamofireRequest(pageNo: String.init(pageNo))
        
        
    }
    
    func refreshFooter() {
        pageNo += 1;
        
        alamofireRequest(pageNo: String.init(pageNo))
        
    }
    
    func alamofireRequest(pageNo:String ) {

        let url = "http://a.haaaaaa.com/mobile/home/indexInWorks.do"
        
        let params = [
        
            "level":"1",
            "pageNo":pageNo,
            "pageSize":"10"
        ]
        

        NetWorkTool.POST(URLString: url, parameters: params as [String : AnyObject]?, successHandler: {(result) in
            
     
            //  采用swiftyjson来解析数据 更安全
            let j = JSON.init(result)
            
            let path = ["data","works"]
            
            let w = j[path].arrayObject
            
            for dic in w!{
                
                let mode = viewModel.init(item: dic as! NSDictionary)
                
                self.arraymodel.add(mode);
                
            }
            
            
            // 常规解析方法
            
//            if let json = result as? NSDictionary{
//                
//                let data = json.value(forKey: "data") as? NSDictionary
//                
//                let works = data?.object(forKey: "works") as? NSArray
//                
//                for dic in works!{
//                    
//                    let mode = viewModel.init(item: dic as! NSDictionary)
//                    
//                    self.arraymodel.add(mode);
//                    
//                }
//                
//            }
            
            self.tableview.reloadData();

            self.tableview.es_stopPullToRefresh(completion: true)
            self.tableview.es_stopLoadingMore()
            
            }) { (error) in
                
                print("=====\(error)======")
                self.tableview.es_stopPullToRefresh(completion: true)
                self.tableview.es_stopLoadingMore()
        }
    
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

