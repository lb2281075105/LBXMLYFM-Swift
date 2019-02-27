//
//  LBFMHomeBroadcastAPI.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/27.
//  Copyright © 2019 刘博. All rights reserved.
//

import Foundation
import Moya

let LBFMHomeBroadcastAPIProvider = MoyaProvider<LBFMHomeBroadcastAPI>()

// 请求分类
public enum LBFMHomeBroadcastAPI {
    case homeBroadcastList
    case categoryBroadcastList(path:String)
    case moreCategoryBroadcastList(categoryId:Int)
    
}

// 请求配置
extension LBFMHomeBroadcastAPI: TargetType {
    // 服务器地址
    public var baseURL: URL {
        return URL(string: "http://live.ximalaya.com")!
    }
    
    // 各个请求的具体路径
    public var path: String {
        switch self {
        case .homeBroadcastList:
            return "/live-web/v5/homepage"
        case .categoryBroadcastList(let path):
            return path
        case .moreCategoryBroadcastList:
            return "/live-web/v2/radio/category"
        }
    }
    
    // 请求类型
    public var method: Moya.Method {
        return .get
    }
    
    // 请求任务事件（这里附带上参数）
    public var task: Task {
        
        switch self {
        case .homeBroadcastList:
            return .requestPlain
        case .categoryBroadcastList:
            let parmeters = [
                "device":"iPhone",
                "pageNum":1,
                "pageSize":30,
                "provinceCode":"310000"] as [String : Any]
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
        case .moreCategoryBroadcastList(let categoryId):
            var parmeters = [
                "device":"iPhone",
                "pageNum":1,
                "pageSize":30] as [String : Any]
            parmeters["categoryId"] = categoryId
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
        }
    }
    
    // 是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    
    // 这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    // 请求头
    public var headers: [String: String]? {
        return nil
    }
}
