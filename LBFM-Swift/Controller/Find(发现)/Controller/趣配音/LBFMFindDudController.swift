//
//  LBFMFindDudController.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/28.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
import LTScrollView
import HandyJSON
import SwiftyJSON

class LBFMFindDudController:  UIViewController , LTTableViewProtocal{
    private var findDudList: [LBFMFindDudModel]?
    
    private let LBFMFindDudCellID = "FindDudCell"
    
    private lazy var tableView: UITableView = {
        let tableView = tableViewConfig(CGRect(x: 0, y: 0, width:LBFMScreenWidth, height: LBFMScreenHeight - LBFMNavBarHeight - LBFMTabBarHeight), self, self, nil)
        tableView.register(LBFMFindDudCell.self, forCellReuseIdentifier: LBFMFindDudCellID)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(tableView)
        glt_scrollView = tableView
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        setupLoadData()
    }
    
    func setupLoadData(){
        // 1. 获取json文件路径
        let path = Bundle.main.path(forResource: "FindDud", ofType: "json")
        // 2. 获取json文件里面的内容,NSData格式
        let jsonData = NSData(contentsOfFile: path!)
        // 3. 解析json内容
        let json = JSON(jsonData!)
        if let mappedObject = JSONDeserializer<LBFMFMFindDudModel>.deserializeFrom(json: json.description) {
            self.findDudList = mappedObject.data
            self.tableView.reloadData()
        }
    }
}
extension LBFMFindDudController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.findDudList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LBFMFindDudCell = tableView.dequeueReusableCell(withIdentifier: LBFMFindDudCellID, for: indexPath) as! LBFMFindDudCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.findDudModel = self.findDudList?[indexPath.row]
        return cell
    }
}
