//
//  LBFMHomeLiveModel.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/25.
//  Copyright © 2019 刘博. All rights reserved.
//

import Foundation
import HandyJSON

/// 直播顶部排行榜数据模型
struct LBFMHomeLiveRankModel: HandyJSON {
    var data: LBFMHomeLiveRankListModel?
    var ret: Int = 0
}

struct LBFMHomeLiveRankListModel: HandyJSON {
    var hpRankRollMillisecond: Int = 0
    var multidimensionalRankVos: [LBFMMultidimensionalRankVosModel]?
}

struct LBFMMultidimensionalRankVosModel: HandyJSON {
    var dimensionName: String?
    var dimensionType: Int = 0
    var htmlUrl: String?
    var ranks: [LBFMRankList]?
}

struct LBFMRankList: HandyJSON {
    var coverSmall: String?
    var nickname: String?
    var uid: Int = 0
}

/// 直播顶部banner数据模型
struct LBFMHomeLiveBanerModel: HandyJSON {
    var ret: Int = 0
    var responseId: Int = 0
    var data:[LBFMHomeLiveBanerList]?
    var adIds: [Any]?
    var adTypes: [Any]?
    var source: Int = 0
}

struct LBFMHomeLiveBanerList: HandyJSON {
    var shareData: String?
    var isShareFlag: String?
    var thirdStatUrl: String?
    var thirdShowStatUrls: [Any]?
    var thirdClickStatUrls: [Any]?
    var showTokens: [Any]?
    var clickTokens: [Any]?
    var recSrc: String?
    var recTrack: String?
    var link: String?
    var realLink: String?
    var adMark: String?
    var isLandScape: Bool = false
    var isInternal: Int = 0
    var bucketIds: String?
    var adpr: String?
    var planId: Int = 0
    var cover: String?
    var showstyle: Int = 0
    var name: String?
    var description: String?
    var scheme: String?
    var linkType: Int = 0
    var displayType: Int = 0
    var clickType: Int = 0
    var openlinkType: Int = 0
    var loadingShowTime: Int = 0
    var apkUrl: String?
    var adtype: Int = 0
    var auto: Bool = false
    var isAd: Bool = false
    var targetId: Int = 0
    var clickAction: Int = 0
    var template: String?
    var buttonText: String?
    var buttonShowed: Bool = false
    var categoryTitle: String?
    var color: String?
    var adid: Int = 0
}

/// 直播顶部分类数据模型
struct LBFMHomeLiveClassifyModel: HandyJSON {
    var data: LBFMHomeLiveClassify?
    var ret: Int = 0
}

struct LBFMHomeLiveClassify: HandyJSON {
    var materialVoList: [LBFMMaterialVoList]?
    var showed: Bool = false
}

struct LBFMMaterialVoList: HandyJSON {
    var coverPath: String?
    var id: Int = 0
    var targetUrl: String?
    var title: String?
    var type: Int = 0
}

/// 直播主播数据模型
struct LBFMHomeLiveModel: HandyJSON {
    var data:LBFMHomeLiveDataModel?
    var ret: Int = 0
}

struct LBFMHomeLiveDataModel: HandyJSON {
    var categoryVoList:[LBFMCategoryVoList]?
    var lastPage: Bool = false
    var lives:[LBFMLivesModel]?
    var pageId: Int = 0
    var pageSize: Int = 0
}

struct LBFMCategoryVoList: HandyJSON {
    var id: String?
    var name: String?
}

struct LBFMLivesModel: HandyJSON {
    var actualStartAt: Int = 0
    var avatar: String?
    var categoryId: Int = 0
    var categoryName: String?
    var chatId: Int = 0
    var coverLarge: String?
    var coverMiddle: String?
    var coverSmall: String?
    var id: Int = 0
    var mode: LBFMMode?
    var name: String?
    var nickname: String?
    var permissionType: Int = 0
    var playCount: Int = 0
    
    var price: Int = 0
    var roomId: Int = 0
    var status: Int = 0
    var uid: Int = 0
    var type: Int = 0
}

struct LBFMMode: HandyJSON {
    var firstColor: String?
    var modeName: String?
    var modeType: Int = 0
    var secondColor: String?
}
















