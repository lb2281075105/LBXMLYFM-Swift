//
//  WRProxy.swift
//  WRCycleScrollViewDemo
//
//  Created by wangrui on 2017/5/15.
//  Copyright © 2017年 wangrui. All rights reserved.
//

import UIKit

// 图片资源
enum ImgSource {
    case SERVER(url:URL)
    case LOCAL(name:String)
}

// 图片类型
enum ImgType:Int {
    case SERVER = 0     // default
    case LOCAL = 1
}

struct Proxy
{
    var imgType:ImgType = .SERVER
    var imgArray:[ImgSource] = [ImgSource]()
    
    // 下标法获取imgArray中对应索引的ImgSource
    subscript (index:Int) -> ImgSource {
        get {
            return imgArray[index]
        }
    }
    
    // 构造方法
    init(type:ImgType, array:[String])
    {
        imgType = type
        if imgType == .SERVER
        {
            imgArray = array.map({ (urlStr) -> ImgSource in
                return ImgSource.SERVER(url: URL(string: urlStr)!)
            })
        }
        else
        {
            imgArray = array.map({ (name) -> ImgSource in
                return ImgSource.LOCAL(name: name)
            })
        }
    }
}
