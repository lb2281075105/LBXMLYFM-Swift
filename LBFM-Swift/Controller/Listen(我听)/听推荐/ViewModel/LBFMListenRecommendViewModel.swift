//
//  LBFMListenRecommendViewModel.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/25.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON
class LBFMListenRecommendViewModel: NSObject {
    var albums:[albumsModel]?
    // - 数据源更新
    typealias LBFMAddDataBlock = () ->Void
    var updataBlock:LBFMAddDataBlock?
}

// - 请求数据
extension LBFMListenRecommendViewModel {
    func refreshDataSource() {
        // 1. 获取json文件路径
        let path = Bundle.main.path(forResource: "listenRecommend", ofType: "json")
        // 2. 获取json文件里面的内容,NSData格式
        let jsonData=NSData(contentsOfFile: path!)
        // 3. 解析json内容
        let json = JSON(jsonData!)
        if let mappedObject = JSONDeserializer<albumsModel>.deserializeModelArrayFrom(json: json["data"]["albums"].description) {
            self.albums = mappedObject as? [albumsModel]
            self.updataBlock?()
        }
    }
}

extension LBFMListenRecommendViewModel {
    // 每个分区显示item数量
    func numberOfRowsInSection(section: NSInteger) -> NSInteger {
        return self.albums?.count ?? 0
    }
}
