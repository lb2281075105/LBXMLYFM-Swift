//
//  LBFMHomeRecommendController.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/1.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON
import SwiftMessages

class LBFMHomeRecommendController: UIViewController {

    let otherMessages = SwiftMessages()
    // 穿插的广告数据
    private var recommnedAdvertList:[LBFMRecommnedAdvertModel]?
    
    // cell 注册
    private let FMRecommendHeaderViewID     = "FMRecommendHeaderView"
    private let FMRecommendFooterViewID     = "FMRecommendFooterView"
    
    private let FMRecommendHeaderCellID     = "FMRecommendHeaderCell"
    private let FMRecommendGuessLikeCellID  = "FMRecommendGuessLikeCell"
    private let FMHotAudiobookCellID        = "FMHotAudiobookCell"
    private let FMAdvertCellID              = "FMAdvertCell"
    private let FMOneKeyListenCellID        = "FMOneKeyListenCell"
    private let FMRecommendForYouCellID     = "FMRecommendForYouCell"
    private let HomeRecommendLiveCellID     = "HomeRecommendLiveCell"
    
    
//    lazy var collectionView : UICollectionView = {
//        let layout = UICollectionViewFlowLayout.init()
//        let collection = UICollectionView.init(frame:.zero, collectionViewLayout: layout)
//        collection.delegate = self
//        collection.dataSource = self
//        collection.backgroundColor = UIColor.white
//        // MARK -注册头视图和尾视图
//        collection.register(FMRecommendHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: FMRecommendHeaderCellID)
//        collection.register(FMRecommendFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: FMRecommendFooterViewID)
//
//        // MARK -注册不同分区cell
//        collection.register(FMRecommendHeaderCell.self, forCellWithReuseIdentifier: FMRecommendHeaderCellID)
//        collection.register(FMRecommendGuessLikeCell.self, forCellWithReuseIdentifier: FMRecommendGuessLikeCellID)
//        collection.register(FMHotAudiobookCell.self, forCellWithReuseIdentifier: FMHotAudiobookCellID)
//        collection.register(FMAdvertCell.self, forCellWithReuseIdentifier: FMAdvertCellID)
//        collection.register(FMOneKeyListenCell.self, forCellWithReuseIdentifier: FMOneKeyListenCellID)
//        collection.register(FMRecommendForYouCell.self, forCellWithReuseIdentifier: FMRecommendForYouCellID)
//        collection.register(HomeRecommendLiveCell.self, forCellWithReuseIdentifier: HomeRecommendLiveCellID)
//        collection.uHead = URefreshHeader{ [weak self] in self?.loadData() }
//        return collection
//    }()
    lazy var viewModel: LBFMRecommendViewModel = {
        return LBFMRecommendViewModel()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        viewModel.refreshDataSource()
        setupLoadRecommendAdData()
    }
    
    func setupLoadRecommendAdData() {
        // 首页穿插广告接口请求
        LBFMRecommendProvider.request(.recommendAdList) { result in
            if case let .success(response) = result {
                // 解析数据
                let data = try? response.mapJSON()
                let json = JSON(data!)
                if let advertList = JSONDeserializer<LBFMRecommnedAdvertModel>.deserializeModelArrayFrom(json: json["data"].description) { // 从字符串转换为对象实例
                    self.recommnedAdvertList = advertList as? [LBFMRecommnedAdvertModel]
//                    self.collectionView.reloadData()
                }
            }
        }
        
    }
}
