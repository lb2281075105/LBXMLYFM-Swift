//
//  LBFMHomeRecommendController.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/1.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON
import SwiftMessages

class LBFMHomeRecommendController: UIViewController {

    // 穿插的广告数据
    private var recommnedAdvertList:[LBFMRecommnedAdvertModel]?
    
    // cell 注册
    private let LBFMRecommendHeaderViewID     = "LBFMRecommendHeaderView"
    private let LBFMRecommendFooterViewID     = "LBFMRecommendFooterView"
    
    // 注册不同的cell
    private let LBFMRecommendHeaderCellID     = "LBFMRecommendHeaderCell"
    // 猜你喜欢
    private let LBFMRecommendGuessLikeCellID  = "LBFMRecommendGuessLikeCell"
    // 热门有声书
    private let LBFMHotAudiobookCellID        = "LBFMHotAudiobookCell"
    // 广告
    private let LBFMAdvertCellID              = "LBFMAdvertCell"
    // 懒人电台
    private let LBFMOneKeyListenCellID        = "LBFMOneKeyListenCell"
    // 为你推荐
    private let LBFMRecommendForYouCellID     = "LBFMRecommendForYouCell"
    // 推荐直播
    private let LBFMHomeRecommendLiveCellID   = "LBFMHomeRecommendLiveCell"
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let collection = UICollectionView.init(frame:.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.white
        // - 注册头视图和尾视图
        collection.register(LBFMRecommendHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LBFMRecommendHeaderViewID)
        collection.register(LBFMRecommendFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LBFMRecommendFooterViewID)

        // - 注册不同分区cell
        // 默认
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.register(LBFMRecommendHeaderCell.self, forCellWithReuseIdentifier: LBFMRecommendHeaderCellID)
        // 猜你喜欢
        collection.register(LBFMRecommendGuessLikeCell.self, forCellWithReuseIdentifier: LBFMRecommendGuessLikeCellID)
        // 热门有声书
        collection.register(LBFMHotAudiobookCell.self, forCellWithReuseIdentifier: LBFMHotAudiobookCellID)
        // 广告
        collection.register(LBFMAdvertCell.self, forCellWithReuseIdentifier: LBFMAdvertCellID)
        // 懒人电台
        collection.register(LBFMOneKeyListenCell.self, forCellWithReuseIdentifier: LBFMOneKeyListenCellID)
        // 为你推荐
        collection.register(LBFMRecommendForYouCell.self, forCellWithReuseIdentifier: LBFMRecommendForYouCellID)
        // 推荐直播
        collection.register(LBFMHomeRecommendLiveCell.self, forCellWithReuseIdentifier: LBFMHomeRecommendLiveCellID)
        collection.uHead = URefreshHeader{ [weak self] in self?.setupLoadData() }
        return collection
    }()
    lazy var viewModel: LBFMRecommendViewModel = {
        return LBFMRecommendViewModel()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // 添加滑动视图
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        self.collectionView.uHead.beginRefreshing()
        setupLoadData()
        setupLoadRecommendAdData()
    }
    
    func setupLoadData(){
        // 加载数据
        viewModel.updateDataBlock = { [unowned self] in
            self.collectionView.uHead.endRefreshing()
            // 更新列表数据
            self.collectionView.reloadData()
        }
        viewModel.refreshDataSource()
    }
    func setupLoadRecommendAdData() {
        // 首页穿插广告接口请求
        LBFMRecommendProvider.request(.recommendAdList) { result in
            if case let .success(response) = result {
                // 解析数据
                let data = try? response.mapJSON()
                let json = JSON(data!)
                if let advertList = JSONDeserializer<LBFMRecommnedAdvertModel>.deserializeModelArrayFrom(json: json["data"].description) { // 从字符串转换为对象实例
                    self.recommnedAdvertList = advertList as? [LBFMRecommnedAdvertModel]
                    self.collectionView.reloadData()
                }
            }
        }
        
    }
}

extension LBFMHomeRecommendController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections(collectionView:collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsIn(section: section)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let moduleType = viewModel.homeRecommendList?[indexPath.section].moduleType
        
        if moduleType == "focus" || moduleType == "square" || moduleType == "topBuzz" {
            let cell:LBFMRecommendHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMRecommendHeaderCellID, for: indexPath) as! LBFMRecommendHeaderCell
            cell.focusModel = viewModel.focus
            cell.squareList = viewModel.squareList
            cell.topBuzzListData = viewModel.topBuzzList
            cell.delegate = self
            return cell
        }else if moduleType == "guessYouLike" || moduleType == "paidCategory" || moduleType == "categoriesForLong" || moduleType == "cityCategory"{
            // 横式排列布局cell
            let cell:LBFMRecommendGuessLikeCell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMRecommendGuessLikeCellID, for: indexPath) as! LBFMRecommendGuessLikeCell
            cell.delegate = self
            cell.recommendListData = viewModel.homeRecommendList?[indexPath.section].list
            return cell
        }else if moduleType == "categoriesForShort" || moduleType == "playlist" || moduleType == "categoriesForExplore"{
            // 竖式排列布局cell
            let cell:LBFMHotAudiobookCell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMHotAudiobookCellID, for: indexPath) as! LBFMHotAudiobookCell
            cell.delegate = self
            cell.recommendListData = viewModel.homeRecommendList?[indexPath.section].list
            return cell
        }else if moduleType == "ad" {
            let cell:LBFMAdvertCell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMAdvertCellID, for: indexPath) as! LBFMAdvertCell
            if indexPath.section == 7 {
                cell.adModel = self.recommnedAdvertList?[0]
            }else if indexPath.section == 13 {
                cell.adModel = self.recommnedAdvertList?[1]
            // }else if indexPath.section == 17 {
            // cell.adModel = self.recommnedAdvertList?[2]
            }
            return cell
        }else if moduleType == "oneKeyListen" {
            let cell:LBFMOneKeyListenCell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMOneKeyListenCellID, for: indexPath) as! LBFMOneKeyListenCell
            cell.oneKeyListenList = viewModel.oneKeyListenList
            return cell
        }else if moduleType == "live" {
            let cell:LBFMHomeRecommendLiveCell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMHomeRecommendLiveCellID, for: indexPath) as! LBFMHomeRecommendLiveCell
            cell.liveList = viewModel.liveList
            return cell
        }else {
            let cell:LBFMRecommendForYouCell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMRecommendForYouCellID, for: indexPath) as! LBFMRecommendForYouCell
            return cell

        }
//        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    // 每个分区的内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return viewModel.insetForSectionAt(section: section)
    }
    
    // 最小item间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumInteritemSpacingForSectionAt(section: section)
    }
    
    // 最小行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumLineSpacingForSectionAt(section: section)
    }
    
    // item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeForItemAt(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return viewModel.referenceSizeForHeaderInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return viewModel.referenceSizeForFooterInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let moduleType = viewModel.homeRecommendList?[indexPath.section].moduleType
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView : LBFMRecommendHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LBFMRecommendHeaderViewID, for: indexPath) as! LBFMRecommendHeaderView
            headerView.homeRecommendList = viewModel.homeRecommendList?[indexPath.section]
            // 分区头右边更多按钮点击跳转
            headerView.headerMoreBtnClick = {[weak self]() in
                if moduleType == "guessYouLike"{
                    let vc = LBFMHomeGuessYouLikeMoreController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }else if moduleType == "paidCategory" {
                    let vc = LBFMHomeVIPController(isRecommendPush:true)
                    vc.title = "精品"
                    self?.navigationController?.pushViewController(vc, animated: true)
                }else if moduleType == "live"{
                    let vc = LBFMHomeLiveController()
                    vc.title = "直播"
                    self?.navigationController?.pushViewController(vc, animated: true)
                }else {
                    guard let categoryId = self?.viewModel.homeRecommendList?[indexPath.section].target?.categoryId else {return}
                    if categoryId != 0 {
                        let vc = LBFMClassifySubMenuController(categoryId:categoryId,isVipPush:false)
                        vc.title = self?.viewModel.homeRecommendList?[indexPath.section].title
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            return headerView
        }else if kind == UICollectionView.elementKindSectionFooter {
            let footerView : LBFMRecommendFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LBFMRecommendFooterViewID, for: indexPath) as! LBFMRecommendFooterView
            return footerView
        }
        return UICollectionReusableView()
    }
}
// - 点击顶部分类按钮进入相对应界面
extension LBFMHomeRecommendController:LBFMRecommendHeaderCellDelegate {
    
    func recommendHeaderBannerClick(url: String) {
        
        let status2 = MessageView.viewFromNib(layout: .statusLine)
        status2.backgroundView.backgroundColor = LBFMButtonColor
        status2.bodyLabel?.textColor = UIColor.white
        status2.configureContent(body: "暂时没有点击功能")
        var status2Config = SwiftMessages.defaultConfig
        status2Config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        status2Config.preferredStatusBarStyle = .lightContent
        SwiftMessages.show(config: status2Config, view: status2)

    }

    func recommendHeaderBtnClick(categoryId:String,title:String,url:String){
        if url == ""{
            if categoryId == "0"{
                let warning = MessageView.viewFromNib(layout: .cardView)
                warning.configureTheme(.warning)
                warning.configureDropShadow()

                let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
                warning.configureContent(title: "Warning", body: "暂时没有数据!!!", iconText: iconText)
                warning.button?.isHidden = true
                var warningConfig = SwiftMessages.defaultConfig
                warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
                SwiftMessages.show(config: warningConfig, view: warning)
            }else{
                let vc = LBFMClassifySubMenuController(categoryId:Int(categoryId)!)
                vc.title = title
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            let vc = LBFMWebViewController(url:url)
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
// - 点击猜你喜欢cell代理方法
extension LBFMHomeRecommendController:LBFMRecommendGuessLikeCellDelegate {
    func recommendGuessLikeCellItemClick(model: LBFMRecommendListModel) {
        let vc = LBFMPlayDetailController(albumId: model.albumId)
        self.navigationController?.pushViewController(vc, animated: true)
        print("点击猜你喜欢")
    }
}

// - 点击热门有声书等cell代理方法
extension LBFMHomeRecommendController:LBFMHotAudiobookCellDelegate {
    func hotAudiobookCellItemClick(model: LBFMRecommendListModel) {
        let vc = LBFMPlayDetailController(albumId: model.albumId)
        self.navigationController?.pushViewController(vc, animated: true)
        print("点击热门有声书")
    }
}





