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

    let otherMessages = SwiftMessages()
    // 穿插的广告数据
    private var recommnedAdvertList:[LBFMRecommnedAdvertModel]?
    
    // cell 注册
    private let LBFMRecommendHeaderViewID     = "LBFMRecommendHeaderView"
    private let LBFMRecommendFooterViewID     = "LBFMRecommendFooterView"
    
    // 注册不同的cell
    private let LBFMRecommendHeaderCellID     = "LBFMRecommendHeaderCell"
//    private let FMRecommendGuessLikeCellID  = "FMRecommendGuessLikeCell"
//    private let FMHotAudiobookCellID        = "FMHotAudiobookCell"
//    private let FMAdvertCellID              = "FMAdvertCell"
//    private let FMOneKeyListenCellID        = "FMOneKeyListenCell"
//    private let FMRecommendForYouCellID     = "FMRecommendForYouCell"
//    private let HomeRecommendLiveCellID     = "HomeRecommendLiveCell"
//
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let collection = UICollectionView.init(frame:.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.white
        // MARK -注册头视图和尾视图
//        collection.register(LBFMRecommendHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: LBFMRecommendHeaderViewID)
//        collection.register(LBFMRecommendFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: LBFMRecommendFooterViewID)

        // MARK -注册不同分区cell
        collection.register(LBFMRecommendHeaderCell.self, forCellWithReuseIdentifier: LBFMRecommendHeaderCellID)
//        collection.register(FMRecommendGuessLikeCell.self, forCellWithReuseIdentifier: FMRecommendGuessLikeCellID)
//        collection.register(FMHotAudiobookCell.self, forCellWithReuseIdentifier: FMHotAudiobookCellID)
//        collection.register(FMAdvertCell.self, forCellWithReuseIdentifier: FMAdvertCellID)
//        collection.register(FMOneKeyListenCell.self, forCellWithReuseIdentifier: FMOneKeyListenCellID)
//        collection.register(FMRecommendForYouCell.self, forCellWithReuseIdentifier: FMRecommendForYouCellID)
//        collection.register(HomeRecommendLiveCell.self, forCellWithReuseIdentifier: HomeRecommendLiveCellID)
//        collection.uHead = URefreshHeader{ [weak self] in self?.loadData() }
        return collection
    }()
    lazy var viewModel: LBFMRecommendViewModel = {
        return LBFMRecommendViewModel()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview()
            make.center.equalToSuperview()
        }
//        self.collectionView.uHead.beginRefreshing()
        loadData()
//        setupLoadRecommendAdData()
    }
    
    func loadData(){
        // 加载数据
//        viewModel.updataBlock = { [unowned self] in
////            self.collectionView.uHead.endRefreshing()
//            // 更新列表数据
//            self.collectionView.reloadData()
//        }
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
        if moduleType == "focus"{

//        if moduleType == "focus" || moduleType == "square" || moduleType == "topBuzz" {
            let cell:LBFMRecommendHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMRecommendHeaderCellID, for: indexPath) as! LBFMRecommendHeaderCell
            cell.focusModel = viewModel.focus
//            cell.squareList = viewModel.squareList
//            cell.topBuzzListData = viewModel.topBuzzList
//            cell.delegate = self
            return cell
        }
//        else if moduleType == "guessYouLike" || moduleType == "paidCategory" || moduleType == "categoriesForLong" || moduleType == "cityCategory"{
//            ///横式排列布局cell
//            let cell:FMRecommendGuessLikeCell = collectionView.dequeueReusableCell(withReuseIdentifier: FMRecommendGuessLikeCellID, for: indexPath) as! FMRecommendGuessLikeCell
//            cell.delegate = self
//            cell.recommendListData = viewModel.homeRecommendList?[indexPath.section].list
//            return cell
//        }else if moduleType == "categoriesForShort" || moduleType == "playlist" || moduleType == "categoriesForExplore"{
//            // 竖式排列布局cell
//            let cell:FMHotAudiobookCell = collectionView.dequeueReusableCell(withReuseIdentifier: FMHotAudiobookCellID, for: indexPath) as! FMHotAudiobookCell
//            cell.delegate = self
//            cell.recommendListData = viewModel.homeRecommendList?[indexPath.section].list
//            return cell
//        }else if moduleType == "ad" {
//            let cell:FMAdvertCell = collectionView.dequeueReusableCell(withReuseIdentifier: FMAdvertCellID, for: indexPath) as! FMAdvertCell
//            if indexPath.section == 7 {
//                cell.adModel = self.recommnedAdvertList?[0]
//            }else if indexPath.section == 13 {
//                cell.adModel = self.recommnedAdvertList?[1]
//                //            }else if indexPath.section == 17 {
//                //                cell.adModel = self.recommnedAdvertList?[2]
//            }
//            return cell
//        }else if moduleType == "oneKeyListen" {
//            let cell:FMOneKeyListenCell = collectionView.dequeueReusableCell(withReuseIdentifier: FMOneKeyListenCellID, for: indexPath) as! FMOneKeyListenCell
//            cell.oneKeyListenList = viewModel.oneKeyListenList
//            return cell
//        }else if moduleType == "live" {
//            let cell:HomeRecommendLiveCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRecommendLiveCellID, for: indexPath) as! HomeRecommendLiveCell
//            cell.liveList = viewModel.liveList
//            return cell
//        }
//        else {
//            let cell:FMRecommendForYouCell = collectionView.dequeueReusableCell(withReuseIdentifier: FMRecommendForYouCellID, for: indexPath) as! FMRecommendForYouCell
//            return cell
//
//        }
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    
            return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //每个分区的内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return viewModel.insetForSectionAt(section: section)
    }
    
    //最小 item 间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumInteritemSpacingForSectionAt(section: section)
    }
    
    //最小行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumLineSpacingForSectionAt(section: section)
    }
    
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeForItemAt(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return viewModel.referenceSizeForHeaderInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return viewModel.referenceSizeForFooterInSection(section: section)
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
////        let moduleType = viewModel.homeRecommendList?[indexPath.section].moduleType
//        if kind == UICollectionElementKindSectionHeader {
//            let headerView : LBFMRecommendHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: LBFMRecommendHeaderViewID, for: indexPath) as! LBFMRecommendHeaderView
//
//            return headerView
//        }else if kind == UICollectionElementKindSectionFooter {
//            let footerView : LBFMRecommendFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: LBFMRecommendFooterViewID, for: indexPath) as! LBFMRecommendFooterView
//            return footerView
//        }
//        return UICollectionReusableView()
//    }
}
