//
//  LBFMListenChannelViewModel.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/25.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON


class LBFMListenChannelViewModel: NSObject {
    var channelResults:[ChannelResultsModel]?
    typealias LBFMAddDataBlock = () ->Void
    // - 数据源更新
    var updataBlock:LBFMAddDataBlock?
}

// - 请求数据
extension LBFMListenChannelViewModel {
    func refreshDataSource() {
        // 一键听接口请求
        FMListenProvider.request(.listenChannelList) { result in
            if case let .success(response) = result {
                // 解析数据
                let data = try? response.mapJSON()
                let json = JSON(data!)
                // 从字符串转换为对象实例
                if let mappedObject = JSONDeserializer<ChannelResultsModel>.deserializeModelArrayFrom(json: json["data"]["channelResults"].description) {
                    self.channelResults = mappedObject as? [ChannelResultsModel]
                    self.updataBlock?()
                }
            }
        }
    }
}

extension LBFMListenChannelViewModel {
    // 每个分区显示item数量
    func numberOfRowsInSection(section: NSInteger) -> NSInteger {
        return self.channelResults?.count ?? 0
    }
}
