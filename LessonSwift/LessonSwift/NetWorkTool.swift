//
//  NetWorkTool.swift
//  LessonSwift
//
//  Created by iPhone on 2016/9/30.
//  Copyright © 2016年 iPhone. All rights reserved.
//

import Foundation
import Alamofire
class NetWorkTool {

  
    
    /// get
    class func GET(URLString: String, parameters: [String: AnyObject]? = nil, successHandler:(( _ result: AnyObject?) -> Void)?, failureHandler: (( _ error: NSError?) -> Void)?) {
        
        let headers: HTTPHeaders = [
            "Accept": "text/html"
        ]
        
        Alamofire.request(URLString, method:HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            
            if response.result.isSuccess{
            
                successHandler?(response.result.value as AnyObject?)
            }else{
            
                failureHandler?(response.result.error as NSError?)
            }
        }
        
        
    }
    
    
    /// post
    class func POST(URLString: String, parameters: [String: AnyObject]? = nil, successHandler:((_ result: AnyObject?) -> Void)?, failureHandler: ((_ error: NSError?) -> Void)?){

        let headers: HTTPHeaders = [
            "Accept": "text/html"
        ]
        
        Alamofire.request(URLString, method:HTTPMethod.post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            
            if response.result.isSuccess{
                
                successHandler?(response.result.value as AnyObject?)
            }else{
                
                failureHandler?(response.result.error as NSError? )
            }
        }
    
}
    
    
    
}
