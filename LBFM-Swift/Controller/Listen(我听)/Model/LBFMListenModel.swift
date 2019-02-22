//
//  LBFMListenModel.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/22.
//  Copyright © 2019 刘博. All rights reserved.
//

import Foundation
import HandyJSON

/// 订阅 Model
struct AlbumResultsModel: HandyJSON {
    var albumCover: String?
    var albumId: Int = 0
    var albumTitle: String?
    var avatar: String?
    var dynamicType: Int = 0
    var isAuthorized: Bool = false
    var isDraft: Bool = false
    var isPaid: Bool = false
    var isTop: Bool = false
    var lastUpdateAt: NSInteger = 0
    var nickname: String?
    var serialState: Int = 0
    var status: Int = 0
    var timeline: NSInteger = 0
    var trackId: NSInteger = 0
    var trackTitle: String?
    var trackType: Int = 0
    var uid: NSInteger = 0
    var unreadNum: Int = 0
}


/// 一键听 Model
struct ChannelResultsModel: HandyJSON {
    var bigCover: String?
    var channelId: Int = 0
    var channelName: String?
    var channelProperty: String?
    var cover: String?
    var createdAt: Int = 0
    var isRec: Bool = false
    var jumpUrl: String?
    var playParam: PlayParamModel?
    var playUrl: String?
    var slogan: String?
}

struct PlayParamModel: HandyJSON {
    var tabid: String?
    var pageSize: String?
    var albumId: String?
    var pageId: String?
    var isWrap: String?
    
}


/// 推荐 Model
struct albumsModel:HandyJSON {
    var albumId: NSInteger = 0
    var coverMiddle: String?
    var coverSmall: String?
    var isDraft: Bool = false
    var isFinished: Int = 0
    var isPaid: Bool = false
    var lastUpdateAt: NSInteger = 0
    var playsCounts: NSInteger = 0
    var recReason: String?
    var recSrc: String?
    var recTrack: String?
    var refundSupportType: Int = 0
    var title: String?
    var tracks: Int = 0
}

/// 一键听点击添加更多频道 Model
struct MoreChannelListModel: HandyJSON {
    var ret: Int = 0
    var msg: String?
    var slogan: String?
    var lastVisitChannel: ChannelInfosModel?
    var classInfos: [ChannelClassInfoModel]?
    var recSrc: String?
    var recTrack: String?
}

struct ChannelInfosModel: HandyJSON{
    var channelProperty: String?
    var channelId: Int = 0
    var channelName: String?
    var positionId: Int = 0
    var cover: String?
    var bigCover: String?
    var isRec: Bool = false
    var jumpUrl: String?
    var playUrl: String?
    var slogan: String?
    var playParam: PlayParamModel?
    var createdAt: Int = 0
    var subscribe: Bool = false
}

struct ChannelClassInfoModel: HandyJSON {
    var className: String?
    var classId: Int = 0
    var channelInfos:[ChannelInfosModel]?
}





