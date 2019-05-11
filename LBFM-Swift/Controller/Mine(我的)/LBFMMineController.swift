//
//  LBFMMineController.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/1.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
let kNavBarBottom = WRNavigationBar.navBarBottom()

class LBFMMineController: UIViewController {
    private let LBFMMineMakeCellID = "LBFMMineMakeCell"
    private let LBFMMineShopCellID = "LBFMMineShopCell"
    
    private lazy var dataSource: Array = {
        return [[["icon":"钱数", "title": "分享赚钱"],
                 ["icon":"沙漏", "title": "免流量服务"]],
                [["icon":"扫一扫", "title": "扫一扫"],
                 ["icon":"月亮", "title": "夜间模式"]],
                [["icon":"意见反馈", "title": "帮助与反馈"]]]
    }()
    
    
    // 懒加载顶部头视图
    private lazy var headerView:LBFMMineHeaderView = {
        let view = LBFMMineHeaderView.init(frame: CGRect(x:0, y:0, width:LBFMScreenWidth, height: 300))
        view.delegate = self
        return view
    }()
    // 懒加载TableView
    private lazy var tableView : UITableView = {
        let tableView = UITableView.init(frame:CGRect(x:0, y:0, width:LBFMScreenWidth, height:LBFMScreenHeight), style: UITableView.Style.plain)
        tableView.contentInset = UIEdgeInsets(top: -CGFloat(kNavBarBottom), left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = LBFMDownColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(LBFMMineMakeCell.self, forCellReuseIdentifier: LBFMMineMakeCellID)
        tableView.tableHeaderView = headerView
        return tableView
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.headerView.stopAnimationViewAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        super.wr_viewWillAppear(animated)
        self.headerView.setAnimationViewAnimation()
    }
    
    // - 导航栏左边按钮
    private lazy var leftBarButton:UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x:0, y:0, width:30, height: 30)
        button.setImage(UIImage(named: "msg"), for: .normal)
        button.addTarget(self, action: #selector(leftBarButtonClick), for: UIControl.Event.touchUpInside)
        return button
    }()
    // - 导航栏右边按钮
    private lazy var rightBarButton:UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x:0, y:0, width:30, height: 30)
        button.setImage(UIImage(named: "set"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(rightBarButtonClick), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置导航栏颜色
        navBarBarTintColor = UIColor.init(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1.0)
        // 设置初始导航栏透明度
        self.navBarBackgroundAlpha = 0
        self.navigationItem.title = "我的"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.tableView)
        
        // 导航栏左右item
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarButton)
    }
    
    // - 导航栏左边消息点击事件
    @objc func leftBarButtonClick() {
        
    }
    // - 导航栏右边设置点击事件
    @objc func rightBarButtonClick() {
        let setVC = LBFMMineSetController()
        self.navigationController?.pushViewController(setVC, animated: true)
    }
}

// - 代理
extension LBFMMineController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 || section == 2 {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 100
        }else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell:LBFMMineMakeCell = tableView.dequeueReusableCell(withIdentifier: LBFMMineMakeCellID, for: indexPath) as! LBFMMineMakeCell
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            let sectionArray = dataSource[indexPath.section-1]
            let dict: [String: String] = sectionArray[indexPath.row]
            cell.imageView?.image =  UIImage(named: dict["icon"] ?? "")
            cell.textLabel?.text = dict["title"]
            if indexPath.section == 3 && indexPath.row == 1{
                let cellSwitch = UISwitch.init()
                cell.accessoryView = cellSwitch
            }else {
                cell.accessoryType = .disclosureIndicator
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = LBFMDownColor
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = LBFMDownColor
        return headerView
    }
    
    // 控制向上滚动显示导航栏标题和左右按钮
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if (offsetY > 0)
        {
            let alpha = offsetY / CGFloat(kNavBarBottom)
            navBarBackgroundAlpha = alpha
        }else{
            navBarBackgroundAlpha = 0
        }
    }
}

/// 首页视图左消息，右设置 按钮点击代理方法
extension LBFMMineController : LBFMMineHeaderViewDelegate {
    func shopBtnClick(tag:Int) {
        
    }
}








