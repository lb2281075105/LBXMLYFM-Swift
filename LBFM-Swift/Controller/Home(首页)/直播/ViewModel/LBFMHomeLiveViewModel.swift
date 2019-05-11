//
//  LBFMHomeLiveViewModel.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/25.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class LBFMHomeLiveViewModel: NSObject {
    // 外部传值请求接口
    var categoryType :Int = 0
    convenience init(categoryType: Int = 0) {
        self.init()
        self.categoryType = categoryType
    }
    
    var homeLiveData: LBFMHomeLiveDataModel?
    var lives:[LBFMLivesModel]?
    var categoryVoList:[LBFMCategoryVoList]?
    var homeLiveBanerList:[LBFMHomeLiveBanerList]?
    var multidimensionalRankVos: [LBFMMultidimensionalRankVosModel]?
    
    // - 数据源更新
    typealias LBFMAddDataBlock = () ->Void
    var updataBlock:LBFMAddDataBlock?
}

// - 请求数据
extension LBFMHomeLiveViewModel {
    func refreshDataSource() {
        loadLiveData()
    }
    
    func loadLiveData(){
        let grpup = DispatchGroup()
        grpup.enter()
        // 首页直播接口请求
        LBFMHomeLiveAPIProvider.request(.liveList) { result in
            if case let .success(response) = result {
                // 解析数据
                let data = try? response.mapJSON()
                let json = JSON(data!)
                // 从字符串转换为对象实例
                if let mappedObject = JSONDeserializer<LBFMHomeLiveModel>.deserializeFrom(json: json.description) {
                    self.lives = mappedObject.data?.lives
                    self.categoryVoList = mappedObject.data?.categoryVoList
                    //  self.collectionView.reloadData()
                    // 更新tableView数据
                    //  self.updataBlock?()
                    grpup.leave()
                }
            }
        }
        
        grpup.enter()
        // 首页直播滚动图接口请求
        LBFMHomeLiveAPIProvider.request(.liveBannerList) { result in
            if case let .success(response) = result {
                // 解析数据
                let data = try? response.mapJSON()
                let json = JSON(data!)
                if let mappedObject = JSONDeserializer<LBFMHomeLiveBanerModel>.deserializeFrom(json: json.description) { // 从字符串转换为对象实例
                    self.homeLiveBanerList = mappedObject.data
                    // let index: IndexPath = IndexPath.init(row: 0, section: 1)
                    // self.collectionView.reloadItems(at: [index])
                    // 更新tableView数据
                    // self.updataBlock?()
                    grpup.leave()
                }
            }
        }
        
        grpup.enter()
        // 首页直播排行榜接口请求
        LBFMHomeLiveAPIProvider.request(.liveRankList) { result in
            if case let .success(response) = result {
                // 解析数据
                let data = try? response.mapJSON()
                let json = JSON(data!)
                // 从字符串转换为对象实例
                if let mappedObject = JSONDeserializer<LBFMHomeLiveRankModel>.deserializeFrom(json: json.description) {
                    self.multidimensionalRankVos = mappedObject.data?.multidimensionalRankVos
                    //  let index: IndexPath = IndexPath.init(row: 0, section: 2)
                    //  self.collectionView.reloadItems(at: [index])
                    // 更新tableView数据
                    //  self.updataBlock?()
                    grpup.leave()
                }
            }
        }
        
        grpup.notify(queue: DispatchQueue.main) {
            self.updataBlock?()
        }
    }
}

// - 点击分类刷新主页数据请求数据
extension LBFMHomeLiveViewModel {
    func refreshCategoryLiveData() {
        loadCategoryLiveData()
    }
    func loadCategoryLiveData(){
        LBFMHomeLiveAPIProvider.request(.categoryTypeList(categoryType:self.categoryType)) { result in
            if case let .success(response) = result {
                // 解析数据
                let data = try? response.mapJSON()
                let json = JSON(data!)
                if let mappedObject = JSONDeserializer<LBFMLivesModel>.deserializeModelArrayFrom(json: json["data"]["lives"].description) {
                    self.lives = mappedObject as? [LBFMLivesModel]
                }
                self.updataBlock?()
            }
        }
    }
}


// - collectionview数据
extension LBFMHomeLiveViewModel {
    // 每个分区显示item数量
    func numberOfItemsIn(section: NSInteger) -> NSInteger {
        if section == LBFMHomeLiveSectionLive {
            return self.lives?.count ?? 0
        }else {
            return 1
        }
    }
    // 每个分区的内边距
    func insetForSectionAt(section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0);
    }
    
    // 最小 item 间距
    func minimumInteritemSpacingForSectionAt(section:Int) ->CGFloat {
        return 5
    }
    
    // 最小行间距
    func minimumLineSpacingForSectionAt(section:Int) ->CGFloat {
        return 10
    }
    
    // item 尺寸
    func sizeForItemAt(indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case LBFMHomeLiveSectionGrid:
            return CGSize.init(width:LBFMScreenWidth - 30,height:90)
        case LBFMHomeLiveSectionBanner:
            return CGSize.init(width:LBFMScreenWidth - 30,height:110)
        case LBFMHomeLiveSectionRank:
            return CGSize.init(width:LBFMScreenWidth - 30,height:70)
        default:
            return CGSize.init(width:(LBFMScreenWidth - 40)/2,height:230)
        }
    }
    
    // 分区头视图size
    func referenceSizeForHeaderInSection(section: Int) -> CGSize {
        if section == LBFMHomeLiveSectionLive{
            return CGSize.init(width: LBFMScreenWidth, height: 40)
        }else {
            return .zero
        }
    }
}
