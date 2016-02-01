//
//  ViewController.swift
//  Alamofire网络请求
//
//  Created by 张昭 on 16/1/11.
//  Copyright © 2016年 张昭. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let url = "http://c.3g.163.com/recommend/getChanRecomNews?channel=duanzi&passport=&devId=676BEC68-01DA-4BB3-9F8F-0A99F9ADFEE2&size=20"
    var dataArray = NSMutableArray()
    var tableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        handleData()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        creatTableView()
        
        headerRefresh()
        
        footerRefresh()
        
        
    }
    
    func creatTableView() {
        tableView = UITableView.init(frame: CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64), style: UITableViewStyle.Plain)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuse")
    
    }
    
    func headerRefresh() {
        
        self.tableView.addHeaderWithCallback { () -> Void in
            
            self.handleData()
        }
        self.tableView.headerBeginRefreshing()
    }
    
    func footerRefresh() {
        self.tableView.addFooterWithCallback { () -> Void in
            
            print("上拉加载")
            self.handleData()
        }
        
    }
    
    
    func handleData() {
        Alamofire.request(.GET, url).responseJSON { response in

            if let JSON = response.result.value {
                print(JSON.dynamicType)

                
                for dic in JSON.objectForKey("段子") as! NSArray {
                    
                    self.dataArray.addObject(dic.objectForKey("title")!)
            
                }
                self.tableView.reloadData()
                self.tableView.headerEndRefreshing()
                self.tableView.footerEndRefreshing()
            }
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell = tableView.dequeueReusableCellWithIdentifier("reuse")!
        cell.textLabel?.text = dataArray.objectAtIndex(indexPath.row) as? String
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

