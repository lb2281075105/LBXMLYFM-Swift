//
//  LBFMHomeVipModel.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/25.
//  Copyright © 2019 刘博. All rights reserved.
//

import Foundation
import HandyJSON
/// 首页VIP数据模型
struct LBFMHomeVipModel: HandyJSON {
    var msg: String?
    var ret: Int = 0
    var focusImages: LBFMFocusImagesModel?
    var serverMilliseconds: Int = 0
    var categoryContents: LBFMCategoryContentsModel?
}

struct LBFMFocusImagesModel: HandyJSON {
    var data:[LBFMFocusImagesData]?
    var responseId: Int = 0
    var ret: Int = 0
}
/// 滚动图片
struct LBFMFocusImagesData: HandyJSON {
    var adId: Int = 0
    var adType: Int = 0
    var buttonShowed: Bool = false
    var clickAction: Int = 0
    var clickTokens: [Any]?
    var clickType: Int = 0
    var cover: String?
    var description: String?
    var displayType: Int = 0
    var isAd: Bool = false
    var isInternal: Int = 0
    var isLandScape: Bool = false
    var isShareFlag: Bool = false
    var link: String?
    var name: String?
    var openlinkType: Int = 0
    var realLink: String?
    var showTokens: [Any]?
    var targetId: Int = 0
    var thirdClickStatUrls: [Any]?
    var thirdShowStatUrls: [Any]?
}

struct LBFMCategoryContentsModel: HandyJSON {
    var list: [LBFMCategoryList]?
    var title: String?
}

/// 滚动按钮
struct LBFMCategoryBtnModel: HandyJSON {
    var bubbleText: String?
    var contentType: String?
    var contentUpdatedAt:Int = 0
    var coverPath: String?
    var displayClass: String?
    var enableShare: Bool = false
    var id: Int = 0
    var isExternalUrl: Bool = false
    var sharePic: String?
    var subtitle: String?
    var title: String?
    var url: String?
    var properties : LBFMCategoryPropertiesModel?
}

struct LBFMCategoryPropertiesModel:HandyJSON {
    var isPaid:Bool = false
    var type:String?
    var uri:String?
}

struct LBFMCategoryList: HandyJSON {
    var calcDimension: String?
    var cardClass: String?
    var contentType: String?
    var hasMore: Bool = false
    var keywordId: Int = 0
    var keywordName: String?
    var list: [LBFMCategoryContents]?
    var moduleType: Int = 0
    var tagName: String?
    var title: String?
}

struct LBFMCategoryContents: HandyJSON {
    var albumCoverUrl290: String?
    var albumId: Int = 0
    var commentsCount: Int = 0
    var coverLarge: String?
    var coverMiddle: String?
    var coverSmall: String?
    var discountedPrice: CGFloat = 0.0
    var displayDiscountedPrice: String?
    var displayPrice: String?
    var id: Int = 0
    var intro: String?
    var isDraft: Bool = false
    var isFinished: Int = 0
    var isPaid: Bool = false
    var isVipFree: Bool = false
    var nickname: String?
    var playsCounts: Int = 0
    var price: CGFloat = 0.0
    var priceTypeEnum: Int = 0
    var priceTypeId: Int = 0
    var priceUnit: String?
    var provider: String?
    var refundSupportType: Int = 0
    var score: CGFloat = 0.0
    var serialState: Int = 0
    var tags: String?
    var title: String?
    var trackId: Int = 0
    var trackTitle: String?
    var tracks: Int = 0
    var uid: Int = 0
    var vipFreeType: Int = 0
}


