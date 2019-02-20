//
//  LBFMRecommendHeaderCell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/15.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
import FSPagerView


/// 添加按钮点击代理方法
protocol LBFMRecommendHeaderCellDelegate:NSObjectProtocol {
    func recommendHeaderBtnClick(categoryId:String,title:String,url:String)
    func recommendHeaderBannerClick(url:String)
}

class LBFMRecommendHeaderCell: UICollectionViewCell {
    private var focus:LBFMFocusModel?
    private var square:[LBFMSquareModel]?
    private var topBuzzList:[LBFMTopBuzzModel]?
    
    weak var delegate : LBFMRecommendHeaderCellDelegate?
    
    private lazy var pagerView : FSPagerView = {

        let pagerView = FSPagerView()
        pagerView.delegate = self
        pagerView.dataSource = self
        pagerView.automaticSlidingInterval =  3
        pagerView.isInfinite = true
        pagerView.interitemSpacing = 15
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        
        return pagerView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        /// 设置布局
        setupLayOut()
    }
    
    func setupLayOut() {
        self.addSubview(self.pagerView)
        self.pagerView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(150)
        }
        self.pagerView.itemSize = CGSize.init(width: LBFMScreenWidth - 60, height: 140)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var focusModel:LBFMFocusModel? {
        didSet{
            guard let model = focusModel else { return }
            self.focus = model
            self.pagerView.reloadData()
        }
    }
    
}

extension LBFMRecommendHeaderCell:FSPagerViewDelegate,FSPagerViewDataSource{
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.focus?.data?.count ?? 0
    }
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.kf.setImage(with: URL(string:(self.focus?.data?[index].cover)!))
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let url:String = self.focus?.data?[index].link ?? ""
        delegate?.recommendHeaderBannerClick(url: url)
    }
}
//extension LBFMRecommendHeaderCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//
//    
//}
