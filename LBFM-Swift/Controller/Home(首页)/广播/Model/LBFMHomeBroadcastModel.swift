//
//  LBFMHomeBroadcastModel.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/27.
//  Copyright © 2019 刘博. All rights reserved.
//

import Foundation
import HandyJSON
// 首页广播数据模型
struct LBFMHomeBroadcastModel : HandyJSON {
    var data:LBFMRadiosModel?
    var ret: Int = 0
}

struct LBFMRadiosModel: HandyJSON {
    var categories: [LBFMRadiosCategoriesModel]?
    var localRadios: [LBFMLocalRadiosModel]?
    var location: String?
    var radioSquareResults: [LBFMRadioSquareResultsModel]?
    var topRadios: [LBFMTopRadiosModel]?
}

struct LBFMRadiosCategoriesModel: HandyJSON{
    var id: Int = 0
    var name: String?
}

struct LBFMLocalRadiosModel :HandyJSON {
    var coverLarge: String?
    var coverSmall: String?
    var fmUid: Int = 0
    var id: Int = 0
    var name: String?
    var playCount: Int = 0
    var playUrl: [LBFMRadiosPlayUrlModel]?
    var programId: Int = 0
    var programName: String?
    var programScheduleId: Int = 0
}

struct LBFMRadiosPlayUrlModel :HandyJSON {
    var aac24: String?
    var aac64: String?
    var ts24: String?
    var ts64: String?
}

struct LBFMRadioSquareResultsModel: HandyJSON {
    var icon: String?
    var id: Int = 0
    var title: String?
    var uri: String?
}

struct LBFMTopRadiosModel: HandyJSON {
    var coverLarge: String?
    var coverSmall: String?
    var fmUid: Int = 0
    var id: Int = 0
    var name: String?
    var playCount: Int = 0
    var playUrl: [LBFMRadiosPlayUrlModel]?
    var programId: Int = 0
    var programName: String?
    var programScheduleId: Int = 0
}
