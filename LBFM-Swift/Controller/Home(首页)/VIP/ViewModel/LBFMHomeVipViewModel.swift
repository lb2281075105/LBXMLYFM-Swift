//
//  LBFMHomeVipViewModel.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/25.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class LBFMHomeVipViewModel: NSObject {
    
    var homevipData :LBFMHomeVipModel?
    var focusImages: [LBFMFocusImagesData]?
    var categoryList:[LBFMCategoryList]?
    var categoryBtnList: [LBFMCategoryBtnModel]?
    // Mark: -数据源更新
    typealias LBFMAddDataBlock = () ->Void
    var updataBlock:LBFMAddDataBlock?
    
    // 每个分区显示item数量
    func numberOfRowsInSection(section: NSInteger) -> NSInteger {
        switch section {
        case LBFMHomeVipSectionVip:
            return self.categoryList?[section].list?.count ?? 0
        default:
            return 1
        }
    }
    // 高度
    func heightForRowAt(indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case LBFMHomeVipSectionBanner:
            return 150
        case LBFMHomeVipSectionGrid:
            return 80
        case LBFMHomeVipSectionHot:
            return 190
        case LBFMHomeVipSectionEnjoy:
            return 230
        default:
            return 120
        }
    }
    
    // header高度
    func heightForHeaderInSection(section:Int) ->CGFloat {
        if section == LBFMHomeVipSectionBanner || section == LBFMHomeVipSectionGrid {
            return 0.0
        }else {
            return 50
        }
    }
    
    // footer 高度
    func heightForFooterInSection(section:Int) ->CGFloat {
        if section == LBFMHomeVipSectionBanner {
            return 0.0
        }else {
            return 10
        }
    }
}

// Mark:-请求数据
extension LBFMHomeVipViewModel {
    func refreshDataSource() {
        // 首页vip接口请求
        LBFMHomeVipAPIProvider.request(.homeVipList) { result in
            if case let .success(response) = result {
                //解析数据
                let data = try? response.mapJSON()
                let json = JSON(data!)
                if let mappedObject = JSONDeserializer<LBFMHomeVipModel>.deserializeFrom(json: json.description) {
                    self.homevipData = mappedObject
                    self.focusImages = mappedObject.focusImages?.data
                    self.categoryList = mappedObject.categoryContents?.list
                }
                if let categorybtn = JSONDeserializer<LBFMCategoryBtnModel>.deserializeModelArrayFrom(json:json["categoryContents"]["list"][0]["list"].description){
                    self.categoryBtnList = categorybtn as? [LBFMCategoryBtnModel]
                }
                self.updataBlock?()
            }
        }
    }
}



