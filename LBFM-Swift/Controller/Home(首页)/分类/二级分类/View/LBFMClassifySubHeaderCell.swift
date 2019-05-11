//
//  LBFMClassifySubHeaderCell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/8.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
import FSPagerView

class LBFMClassifySubHeaderCell: UICollectionViewCell {
    private var focus:LBFMFocusModel?
    private var classifyCategoryContentsList:LBFMClassifyCategoryContentsList?
    
    let LBFMClassifySubCategoryCellID = "LBFMClassifySubCategoryCell"
    // - 懒加载滚动图片浏览器
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
    private lazy var layout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        return layout
    }()
    // - 懒加载九宫格分类按钮
    private lazy var gridView: UICollectionView = {
        //        let layout = UICollectionViewFlowLayout.init()
        let collectionView = UICollectionView.init(frame:.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(LBFMClassifySubCategoryCell.self, forCellWithReuseIdentifier: LBFMClassifySubCategoryCellID)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.pagerView)
        self.pagerView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(150)
        }
        self.addSubview(self.gridView)
        self.gridView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.pagerView.snp.bottom)
            make.height.equalTo(80)
        }
        self.pagerView.itemSize = CGSize.init(width: LBFMScreenWidth - 60, height: 140)
    }
    
    var focusModel:LBFMFocusModel? {
        didSet{
            guard let model = focusModel else { return }
            self.focus = model
            self.pagerView.reloadData()
        }
    }
    
    var classifyCategoryContentsListModel:LBFMClassifyCategoryContentsList? {
        didSet{
            guard let model = classifyCategoryContentsListModel else {return}
            self.classifyCategoryContentsList = model
            if (self.classifyCategoryContentsList?.list?.count)! == 10 {
                self.layout.scrollDirection = UICollectionView.ScrollDirection.vertical
            }else {
                self.layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
            }
            self.gridView.reloadData()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
// 顶部循环滚动视图
extension LBFMClassifySubHeaderCell: FSPagerViewDelegate, FSPagerViewDataSource {
    // - FSPagerView Delegate
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.focus?.data?.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.kf.setImage(with: URL(string:(self.focus?.data?[index].cover)!))
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
    }
}
// 顶部分类九宫格视图
extension LBFMClassifySubHeaderCell:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.classifyCategoryContentsList?.list?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:LBFMClassifySubCategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMClassifySubCategoryCellID, for: indexPath) as! LBFMClassifySubCategoryCell
        cell.classifyVerticalModel = self.classifyCategoryContentsList?.list?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    // 每个分区的内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // 最小 item 间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // 最小行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let num:Int = (self.classifyCategoryContentsList?.list?.count)!
        if num <= 6 {
            return CGSize.init(width: LBFMScreenWidth / CGFloat(num), height: 80)
        }else if num < 10 {
            return CGSize.init(width: LBFMScreenWidth / 6, height: 80)
        }else {
            self.gridView.snp.updateConstraints { (make) in
                make.height.equalTo(160)
            }
            return CGSize.init(width: LBFMScreenWidth / 5, height: 80)
        }
    }
}
