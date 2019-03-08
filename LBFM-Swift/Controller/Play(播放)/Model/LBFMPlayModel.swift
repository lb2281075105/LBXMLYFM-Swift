//
//  LBFMPlayModel.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/8.
//  Copyright © 2019 刘博. All rights reserved.
//

import Foundation
import HandyJSON
struct LBFMPlayModel:HandyJSON {
    var ret:Int = 0
    var albumInfo:LBFMPlayAlbumInfo?
    var associationAlbumsInfo:[LBFMPlayAssociationAlbumsInfo]?
    var noCacheInfo:LBFMPlayNoCacheInfo?
    var trackInfo:LBFMPlayTrackInfo?
    var userInfo:LBFMPlayUserInfo?
}

struct LBFMPlayAlbumInfo:HandyJSON {
    var albumId:Int = 0
    var categoryId:Int = 0
    var createdAt:Int = 0
    var saleScope:Int = 0
    var serializeStatus:Int = 0
    var status:Int = 0
    var uid:Int = 0
    var updatedAt:Int = 0
    var vipFreeType:Int = 0
    var hasNew:Bool = false
    var isAlbumOpenGift:Bool = false
    var isAuthorized:Bool = false
    var isDraft:Bool = false
    var isFavorite:Bool = false
    var isPaid:Bool = false
    
    var coverLarge:String?
    var coverMiddle:String?
    var coverOrigin:String?
    var coverSmall:String?
    var coverWebLarge:String?
    var intro:String?
    var tags:String?
    var title:String?
}

struct LBFMPlayAssociationAlbumsInfo:HandyJSON {
    var isDraft:Bool = false
    var albumId:Int = 0
    var uid:Int = 0
    var updatedAt:Int = 0
    var vipFreeType:Int = 0
    
    var coverMiddle:String?
    var coverSmall:String?
    var intro:String?
    var recSrc:String?
    var recTrack:String?
    var title:String?
    
}

struct LBFMPlayNoCacheInfo:HandyJSON {
    var recAlbumsPanelTitle:String?
    var associationAlbumsInfo:[LBFMPlayAssociationAlbumsInfo]?
    var communityInfo:LBFMPlayCommunityInfo?
    var commentInfo:LBFMPlayCommentInfoList?
}
struct LBFMPlayCommentInfoList:HandyJSON {
    var list:[LBFMPlayCommentInfo]?
}
struct LBFMPlayCommentInfo:HandyJSON {
    var createdAt:Int = 0
    var id:Int = 0
    var likes:Int = 0
    var replyCount:Int = 0
    var trackId:Int = 0
    var trackUid:Int = 0
    var track_id:Int = 0
    var uid:Int = 0
    var updatedAt:Int = 0
    var content:String?
    var nickname:String?
    var smallHeader:String?
    var isVip:Bool = false
    var liked:Bool = false
    var replies:[LBReplies]?
}
struct LBReplies:HandyJSON {
    var content:String?
    var nickname:String?
    var pNickName:String?
    var smallHeader:String?
    var isVip:Bool = false
    var liked:Bool = false
    
    var createdAt:Int = 0
    var id:Int = 0
    var likes:Int = 0
    var trackId:Int = 0
    var trackUid:Int = 0
    var track_id:Int = 0
    var uid:Int = 0
    var updatedAt:Int = 0
    var parentId:Int = 0
    var parentUid:Int = 0
    var replyCount:Int = 0
}


struct LBFMPlayCommunityInfo:HandyJSON {
    var articleCount:Int = 0
    var id:Int = 0
    var memberCount:Int = 0
    var sectionId:Int = 0
    var isJoin:Bool = false
    var introduce:String?
    var logo:String?
    var logoMiddle:String?
    var logoSmall:String?
    var url:String?
    var name:String?
}

struct LBFMPlayTrackInfo:HandyJSON {
    var albumId:Int = 0
    var bulletSwitchType:Int = 0
    var categoryId:Int = 0
    var comments:Int = 0
    var createdAt:Int = 0
    var downloadAacSize:Int = 0
    var downloadSize:Int = 0
    var duration:Int = 0
    var likes:Int = 0
    var playtimes:Int = 0
    var priceTypeEnum:Int = 0
    var priceTypeId:Int = 0
    var processState:Int = 0
    var relatedId:Int = 0
    var ret:Int = 0
    var sampleDuration:Int = 0
    var shares:Int = 0
    var status:Int = 0
    var trackId:Int = 0
    var type:Int = 0
    var uid:Int = 0
    var isAuthorized:Bool = false
    var isDraft:Bool = false
    var isFree:Bool = false
    var isLike:Bool = false
    var isPaid:Bool = false
    var isPublic:Bool = false
    var isRichAudio:Bool = false
    var isVideo:Bool = false
    var isVipFree:Bool = false
    var albumTitle:String?
    var categoryName:String?
    var coverLarge:String?
    var coverMiddle:String?
    var coverSmall:String?
    var downloadAacUrl:String?
    var downloadUrl:String?
    var intro:String?
    var playPathAacv164:String?
    var playPathAacv224:String?
    var playPathHq:String?
    var playUrl32:String?
    var playUrl64:String?
    var shortRichIntro:String?
    var title:String?
    
    var images:[Any]?
    var priceTypes:[Any]?
    
}


struct LBFMPlayUserInfo:HandyJSON {
    var albums:Int = 0
    var anchorGrade:Int = 0
    var answerCount:Int = 0
    var followers:Int = 0
    var tracks:Int = 0
    var uid:Int = 0
    var verifyType:Int = 0
    
    var isOpenAskAndAnswer:Bool = false
    var isVerified:Bool = false
    var isVip:Bool = false
    
    var askAndAnswerBrief:String?
    var askPrice:String?
    var nickname:String?
    var personDescribe:String?
    var personalSignature:String?
    var ptitle:String?
    var skilledTopic:String?
    var smallLogo:String?
}



