//
//  LBFMHomeVIPController.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/1.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
import SwiftMessages

let LBFMHomeVipSectionBanner    = 0   // 滚动图片section
let LBFMHomeVipSectionGrid      = 1   // 分类section
let LBFMHomeVipSectionHot       = 2   // 热section
let LBFMHomeVipSectionEnjoy     = 3   // 尊享section
let LBFMHomeVipSectionVip       = 4   // vip section

/// 首页vip控制器
class LBFMHomeVIPController: UIViewController {
    // - 上页面传过来请求接口必须的参数
    convenience init(isRecommendPush:Bool = false) {
        self.init()
        self.tableView.frame = CGRect(x:0,y:0,width:LBFMScreenWidth,height:LBFMScreenHeight)
    }
    
    private let LBFMHomeVIPCellID           = "LBFMHomeVIPCell"
    private let LBFMHomeVipHeaderViewID     = "LBFMHomeVipHeaderView"
    private let LBFMHomeVipFooterViewID     = "LBFMHomeVipFooterView"
    private let LBFMHomeVipBannerCellID     = "LBFMHomeVipBannerCell"
    private let LBFMHomeVipCategoriesCellID = "LBFMHomeVipCategoriesCell"
    private let LBFMHomeVipHotCellID        = "LBFMHomeVipHotCell"
    private let LBFMHomeVipEnjoyCellID      = "LBFMHomeVipEnjoyCell"
    
    
    private var currentTopSectionCount: Int64 = 0
    
    lazy var headView : UIView = {
        let view = UIView.init(frame: CGRect(x:0, y:0, width: LBFMScreenWidth, height: 30))
        view.backgroundColor = UIColor.purple
        return view
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView.init(frame: CGRect(x:0, y:0, width: LBFMScreenWidth, height:LBFMScreenHeight - LBFMNavBarHeight - 44 - LBFMTabBarHeight), style: UITableView.Style.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        // 注册头尾视图
        tableView.register(LBFMHomeVipHeaderView.self, forHeaderFooterViewReuseIdentifier: LBFMHomeVipHeaderViewID)
        tableView.register(LBFMHomeVipFooterView.self, forHeaderFooterViewReuseIdentifier: LBFMHomeVipFooterViewID)
        // 注册分区cell
        tableView.register(LBFMHomeVIPCell.self, forCellReuseIdentifier: LBFMHomeVIPCellID)
        tableView.register(LBFMHomeVipBannerCell.self, forCellReuseIdentifier: LBFMHomeVipBannerCellID)
        tableView.register(LBFMHomeVipCategoriesCell.self, forCellReuseIdentifier: LBFMHomeVipCategoriesCellID)
        tableView.register(LBFMHomeVipHotCell.self, forCellReuseIdentifier: LBFMHomeVipHotCellID)
        tableView.register(LBFMHomeVipEnjoyCell.self, forCellReuseIdentifier: LBFMHomeVipEnjoyCellID)
        tableView.uHead = URefreshHeader{ [weak self] in self?.setupLoadData() }
        return tableView
    }()
    
    lazy var viewModel: LBFMHomeVipViewModel = {
        return LBFMHomeVipViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        //刚进页面进行刷新
        self.tableView.uHead.beginRefreshing()
        setupLoadData()
    }
    
    func setupLoadData() {
        // 加载数据
        viewModel.updataBlock = { [unowned self] in
            self.tableView.uHead.endRefreshing()
            // 更新列表数据
            self.tableView.reloadData()
        }
        viewModel.refreshDataSource()
    }
}

extension LBFMHomeVIPController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.categoryList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRowAt(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case LBFMHomeVipSectionBanner:
            let cell:LBFMHomeVipBannerCell = tableView.dequeueReusableCell(withIdentifier: LBFMHomeVipBannerCellID, for: indexPath) as! LBFMHomeVipBannerCell
            cell.vipBannerList = viewModel.focusImages
            cell.delegate = self
            return cell
        case LBFMHomeVipSectionGrid:
            let cell:LBFMHomeVipCategoriesCell = tableView.dequeueReusableCell(withIdentifier: LBFMHomeVipCategoriesCellID, for: indexPath) as! LBFMHomeVipCategoriesCell
            cell.categoryBtnModel = viewModel.categoryBtnList
            cell.delegate = self
            return cell
        case LBFMHomeVipSectionHot:
            let cell:LBFMHomeVipHotCell = tableView.dequeueReusableCell(withIdentifier: LBFMHomeVipHotCellID, for: indexPath) as! LBFMHomeVipHotCell
            cell.categoryContentsModel = viewModel.categoryList?[indexPath.section].list
            cell.delegate = self
            return cell
        case LBFMHomeVipSectionEnjoy:
            let cell:LBFMHomeVipEnjoyCell = tableView.dequeueReusableCell(withIdentifier: LBFMHomeVipEnjoyCellID, for: indexPath) as! LBFMHomeVipEnjoyCell
            cell.categoryContentsModel = viewModel.categoryList?[indexPath.section].list
            cell.delegate = self
            return cell
        default:
            let cell:LBFMHomeVIPCell = tableView.dequeueReusableCell(withIdentifier: LBFMHomeVIPCellID, for: indexPath) as! LBFMHomeVIPCell
            cell.categoryContentsModel = viewModel.categoryList?[indexPath.section].list?[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = LBFMPlayDetailController(albumId: (viewModel.categoryList?[indexPath.section].list?[indexPath.row].albumId)!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.heightForHeaderInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView:LBFMHomeVipHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: LBFMHomeVipHeaderViewID) as! LBFMHomeVipHeaderView
        headerView.titStr = viewModel.categoryList?[section].title
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.heightForFooterInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = LBFMDownColor
        return view
    }
}
extension LBFMHomeVIPController:LBFMHomeVipBannerCellDelegate{
    func homeVipBannerCellClick(url: String) {
        let warning = MessageView.viewFromNib(layout: .cardView)
        warning.configureTheme(.warning)
        warning.configureDropShadow()
        
        let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
        warning.configureContent(title: "Warning", body: "暂时没有点击功能", iconText: iconText)
        warning.button?.isHidden = true
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: warningConfig, view: warning)
    }
}

// - 点击顶部分类按钮 delegate
extension LBFMHomeVIPController:LBFMHomeVipCategoriesCellDelegate{
    func homeVipCategoriesCellItemClick(id: String, url: String,title:String) {
        if url == ""{
            let vc = LBFMClassifySubMenuController(categoryId: Int(id)!,isVipPush:true)
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = LBFMWebViewController(url:url)
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
// - 点击Vip尊享课item delegate
extension LBFMHomeVIPController:LBFMHomeVipEnjoyCellDelegate{
    func homeVipEnjoyCellItemClick(model: LBFMCategoryContents) {
        let vc = LBFMPlayDetailController(albumId: model.albumId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
// - 点击热播item delegate
extension LBFMHomeVIPController:LBFMHomeVipHotCellDelegate{
    func homeVipHotCellItemClick(model: LBFMCategoryContents) {
        let vc = LBFMPlayDetailController(albumId: model.albumId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
