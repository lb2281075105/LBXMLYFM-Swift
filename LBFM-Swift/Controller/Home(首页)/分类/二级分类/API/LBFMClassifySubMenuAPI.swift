//
//  LBFMClassifySubMenuAPI.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/4.
//  Copyright © 2019 刘博. All rights reserved.
//

import Foundation
import Moya

let LBFMClassifySubMenuProvider = MoyaProvider<LBFMClassifySubMenuAPI>()
// 请求分类
public enum LBFMClassifySubMenuAPI {
    // 顶部分类传参categoryId
    case headerCategoryList(categoryId: Int)
    // 推荐传参categoryId
    case classifyRecommendList(categoryId: Int)
    // 其他分类传参categoryId
    case classifyOtherContentList(keywordId: Int, categoryId: Int)
}

// 请求配置
extension LBFMClassifySubMenuAPI: TargetType {
    // 服务器地址
    public var baseURL: URL {
        return URL(string: "http://mobile.ximalaya.com")!
    }
    
    // 各个请求的具体路径
    public var path: String {
        switch self {
        case .headerCategoryList:
            return "/discovery-category/keyword/all/1534468874767"
        case .classifyRecommendList:
            return "/discovery-category/v2/category/recommend/ts-1534469064622"
        case .classifyOtherContentList:
            return "/mobile/discovery/v2/category/metadata/albums/ts-1534469378814"
        }
    }
    
    public var method: Moya.Method { return .get }
    public var task: Task {
        var parmeters = [String:Any]()
        switch self {
        case .headerCategoryList(let categoryId):
            parmeters = ["device":"iPhone","gender":9]
            parmeters["categoryId"] = categoryId
        case .classifyRecommendList(let categoryId):
            parmeters = ["appid":0,
                         "device":"iPhone",
                         "gender":9,
                         "inreview":false,
                         "network":"WIFI",
                         "operator":3,
                         "scale":3,
                         "uid":124057809,
                         "version":"6.5.3",
                         "xt": Int32(Date().timeIntervalSince1970),
                         "deviceId": UIDevice.current.identifierForVendor!.uuidString]
            parmeters["categoryId"] = categoryId
            
        case .classifyOtherContentList(let keywordId, let categoryId):
            parmeters = ["calcDimension":"hot",
                         "device":"iPhone",
                         "pageId":1,
                         "pageSize":20,
                         "status":0,
                         "version":"6.5.3"]
            parmeters["keywordId"] = keywordId
            parmeters["categoryId"] = categoryId
        }
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
    
    public var sampleData: Data { return "".data(using: String.Encoding.utf8)! }
    public var headers: [String : String]? { return nil }
}
