//
//  LBFMHomeVipBannerCell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/25.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
import FSPagerView
/// 添加cell点击代理方法
protocol LBFMHomeVipBannerCellDelegate:NSObjectProtocol {
    func homeVipBannerCellClick(url:String)
}

class LBFMHomeVipBannerCell: UITableViewCell {
    weak var delegate : LBFMHomeVipBannerCellDelegate?
    
    var vipBanner: [LBFMFocusImagesData]?
    
    // - 懒加载滚动图片浏览器
    private lazy var pagerView : FSPagerView = {
        let pagerView = FSPagerView()
        pagerView.delegate = self
        pagerView.dataSource = self
        pagerView.automaticSlidingInterval =  3
        pagerView.isInfinite = true
        pagerView.interitemSpacing = 15
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "LBFMHomeVipBannerCell")
        return pagerView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(self.pagerView)
        self.pagerView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalToSuperview()
        }
        self.pagerView.itemSize = CGSize.init(width: LBFMScreenWidth-60, height: 140)
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var vipBannerList: [LBFMFocusImagesData]? {
        didSet {
            guard let model = vipBannerList else { return }
            self.vipBanner = model
            self.pagerView.reloadData()
        }
    }
}

extension LBFMHomeVipBannerCell: FSPagerViewDelegate, FSPagerViewDataSource {
    // - FSPagerView Delegate
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.vipBanner?.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "LBFMHomeVipBannerCell", at: index)
        cell.imageView?.kf.setImage(with: URL(string:(self.vipBanner?[index].cover)!))
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let url:String = self.vipBanner?[index].link ?? ""
        delegate?.homeVipBannerCellClick(url: url)
    }
}
