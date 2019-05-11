//
//  LBFMClassifySubMenuController.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/5.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON
import DNSPageView

// 分类二级界面主页面
class LBFMClassifySubMenuController: UIViewController {
    private var categoryId: Int = 0
    private var isVipPush:Bool = false
    
    convenience init(categoryId: Int = 0,isVipPush:Bool = false) {
        self.init()
        self.categoryId = categoryId
        self.isVipPush = isVipPush
    }
    
    private var Keywords:[LBFMClassifySubMenuKeywords]?
    private lazy var nameArray = NSMutableArray()
    private lazy var keywordIdArray = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // 加载头部分类数据
        loadHeaderCategoryData()
    }
    // 加载头部分类数据
    func loadHeaderCategoryData(){
        //分类二级界面顶部分类接口请求
        LBFMClassifySubMenuProvider.request(LBFMClassifySubMenuAPI.headerCategoryList(categoryId: self.categoryId)) { result in
            if case let .success(response) = result {
                // 解析数据
                let data = try? response.mapJSON()
                let json = JSON(data!)
                // 从字符串转换为对象实例
                if let mappedObject = JSONDeserializer<LBFMClassifySubMenuKeywords>.deserializeModelArrayFrom(json: json["keywords"].description) {
                    self.Keywords = mappedObject as? [LBFMClassifySubMenuKeywords]
                    for keyword in self.Keywords! {
                        self.nameArray.add(keyword.keywordName!)
                    }
                    if !self.isVipPush{
                        self.nameArray.insert("推荐", at: 0)
                    }
                    self.setupHeaderView()
                }
            }
        }
    }
    
    func setupHeaderView(){
        // 创建DNSPageStyle，设置样式
        let style = DNSPageStyle()
        style.isTitleViewScrollEnabled = true
        style.isTitleScaleEnabled = true
        style.isShowBottomLine = true
        style.titleSelectedColor = UIColor.black
        style.titleColor = UIColor.gray
        style.bottomLineColor = LBFMButtonColor
        style.bottomLineHeight = 2
        style.titleViewBackgroundColor = LBFMDownColor
        
        // 创建每一页对应的controller
        var viewControllers = [UIViewController]()
        for keyword in self.Keywords! {
            let controller = LBFMClassifySubContentController(keywordId:keyword.keywordId, categoryId:keyword.categoryId)
            viewControllers.append(controller)
        }
        if !self.isVipPush{
            // 这里需要插入推荐的控制器，因为接口数据中并不含有推荐
            let categoryId = self.Keywords?.last?.categoryId
            viewControllers.insert(LBFMClassifySubRecommendController(categoryId:categoryId!), at: 0)
        }
        
        for vc in viewControllers{
            self.addChild(vc)
        }
        let pageView = DNSPageView(frame: CGRect(x: 0, y: LBFMNavBarHeight, width: LBFMScreenWidth, height: LBFMScreenHeight - LBFMNavBarHeight), style: style, titles: nameArray as! [String], childViewControllers: viewControllers)
        view.addSubview(pageView)
    }
}





