//
//  HomeLiveRankCell.swift
//  YYSwiftProject
//
//  Created by Domo on 2018/7/28.
//  Copyright © 2018年 知言网络. All rights reserved.
//

import UIKit

class LBFMHomeLiveRankCell: UICollectionViewCell {
    
    private var multidimensionalRankVosList: [LBFMMultidimensionalRankVosModel]?

    
    private let LBFMLiveRankCellID = "LBFMLiveRankCell"
    // - 滚动排行榜
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: (LBFMScreenWidth - 30), height:self.frame.size.height)
//        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        let collectionView = UICollectionView.init(frame:.zero, collectionViewLayout: layout)
        collectionView.contentSize = CGSize(width: (LBFMScreenWidth - 30), height: self.frame.size.height)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(LBFMLiveRankCell.self, forCellWithReuseIdentifier:LBFMLiveRankCellID)
        
        return collectionView
    }()
    
    var timer: Timer?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        // 开启定时器
        starTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // 界面赋值并刷新
    var multidimensionalRankVos:[LBFMMultidimensionalRankVosModel]? {
        didSet {
            guard let model = multidimensionalRankVos else { return }
            self.multidimensionalRankVosList = model
            self.collectionView.reloadData()
        }
    }
}
extension LBFMHomeLiveRankCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.multidimensionalRankVosList?.count ?? 0)*100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:LBFMLiveRankCell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMLiveRankCellID, for: indexPath) as! LBFMLiveRankCell
        cell.backgroundColor = UIColor.init(red: 248/255.0, green: 245/255.0, blue: 246/255.0, alpha: 1)
        cell.multidimensionalRankVos = self.multidimensionalRankVosList?[indexPath.row%(self.multidimensionalRankVosList?.count)!]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row % (self.multidimensionalRankVosList?.count)!)
    }
    
    /// 开启定时器
    func starTimer () {
        let timer = Timer.init(timeInterval: 3, target: self, selector: #selector(nextPage), userInfo: nil, repeats: true)
        // 这一句代码涉及到runloop 和 主线程的知识,则在界面上不能执行其他的UI操作
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        self.timer = timer
    }
    
    /// 在1秒后,自动跳转到下一页
    @objc func nextPage() {
        // 1.获取collectionView的X轴滚动的偏移量
        let currentOffsetX = collectionView.contentOffset.x
        let offsetX = currentOffsetX + collectionView.bounds.width
        // 2.滚动该位置
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    /// 当collectionView开始拖动的时候,取消定时器
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    /// 当用户停止拖动的时候,开启定时器
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        starTimer()
    }

}


