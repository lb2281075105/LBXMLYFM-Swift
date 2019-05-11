//
//  LBFMHomeBroadcastViewModel.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/27.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class LBFMHomeBroadcastViewModel: NSObject {
    // 更多电台分类是否展开状态
    var isUnfold: Bool = false
    /// 一下三个model是控制展开收起时电台数据显示
    let bottomModel = LBFMRadiosCategoriesModel.init(id: 10000, name: "arrows_bottom.png")
    let topModel = LBFMRadiosCategoriesModel.init(id: 10000, name:"arrows_top.png")
    let coverModel = LBFMRadiosCategoriesModel.init(id: 10000, name:" ")
    
    var titleArray = ["上海","排行榜"]
    // 数据模型
    var categories: [LBFMRadiosCategoriesModel]?
    var localRadios: [LBFMLocalRadiosModel]?
    var radioSquareResults: [LBFMRadioSquareResultsModel]?
    var topRadios: [LBFMTopRadiosModel]?
    
    // - 数据源更新
    typealias LBFMAddDataBlock = () ->Void
    var updataBlock:LBFMAddDataBlock?
}

// - 请求数据
extension LBFMHomeBroadcastViewModel {
    func refreshDataSource() {
        // 首页广播接口请求
        LBFMHomeBroadcastAPIProvider.request(.homeBroadcastList) { result in
            if case let .success(response) = result {
                // 解析数据
                let data = try? response.mapJSON()
                let json = JSON(data!)
                // 从字符串转换为对象实例
                if let mappedObject = JSONDeserializer<LBFMHomeBroadcastModel>.deserializeFrom(json: json.description) {
                    self.categories = mappedObject.data?.categories
                    self.localRadios = mappedObject.data?.localRadios
                    self.radioSquareResults = mappedObject.data?.radioSquareResults
                    self.topRadios = mappedObject.data?.topRadios
                    self.categories?.insert(self.bottomModel, at: 7)
                    self.categories?.append(self.topModel)
                    
                    self.updataBlock?()
                }
            }
        }
    }
}

// - collectionview数据
extension LBFMHomeBroadcastViewModel {
    // 每个分区显示item数量
    func numberOfItemsIn(section: NSInteger) -> NSInteger {
        if section == LBFMHomeBroadcastSectionTel {
            return 1
        }else if section == LBFMHomeBroadcastSectionMoreTel {
            if self.isUnfold {
                return self.categories?.count ?? 0
            }else {
                let num:Int = self.categories?.count ?? 0
                return num / 2
            }
        }else if section == LBFMHomeBroadcastSectionLocal {
            return self.localRadios?.count ?? 0
        }else {
            return self.topRadios?.count ?? 0
        }
    }
    // 每个分区的内边距
    func insetForSectionAt(section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
    }
    
    // 最小 item 间距
    func minimumInteritemSpacingForSectionAt(section:Int) ->CGFloat {
        if section == LBFMHomeBroadcastSectionMoreTel {
            return 1
        }else {
            return 0.0
        }
    }
    
    // 最小行间距
    func minimumLineSpacingForSectionAt(section:Int) ->CGFloat {
        if section == LBFMHomeBroadcastSectionMoreTel {
            return 1
        }else {
            return 0.0
        }
    }
    
    // item 尺寸
    func sizeForItemAt(indexPath: IndexPath) -> CGSize {
        if indexPath.section == LBFMHomeBroadcastSectionTel {
            return CGSize.init(width:LBFMScreenWidth,height:90)
        }else if indexPath.section == LBFMHomeBroadcastSectionMoreTel {
            return CGSize.init(width:(LBFMScreenWidth-5)/4,height:45)
        }else {
            return CGSize.init(width:LBFMScreenWidth,height:120)
        }
    }
    
    // 分区头视图size
    func referenceSizeForHeaderInSection(section: Int) -> CGSize {
        if section == LBFMHomeBroadcastSectionTel || section == LBFMHomeBroadcastSectionMoreTel {
            return .zero
        }else {
            return CGSize.init(width: LBFMScreenWidth, height: 40)
        }
    }
    
    
    // 分区尾视图size
    func referenceSizeForFooterInSection(section: Int) -> CGSize {
        if section == LBFMHomeBroadcastSectionTel || section == LBFMHomeBroadcastSectionMoreTel {
            return .zero
        }else {
            return CGSize.init(width: LBFMScreenWidth, height: 10)
        }
    }
}
