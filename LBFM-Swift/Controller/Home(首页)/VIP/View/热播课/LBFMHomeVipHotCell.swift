//
//  LBFMHomeVipHotCell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/25.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
/// 添加cell点击代理方法
protocol LBFMHomeVipHotCellDelegate:NSObjectProtocol {
    func homeVipHotCellItemClick(model:LBFMCategoryContents)
}

class LBFMHomeVipHotCell: UITableViewCell {
    weak var delegate : LBFMHomeVipHotCellDelegate?
    
    private var categoryContents:[LBFMCategoryContents]?
    
    private let LBFMVipHotCellID = "LBFMVipHotCell"
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let collectionView = UICollectionView.init(frame:.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        collectionView.register(LBFMVipHotCell.self, forCellWithReuseIdentifier: LBFMVipHotCellID)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setUpLayout()
    }
    
    func setUpLayout(){
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalToSuperview()
        }
    }
    
    var categoryContentsModel:[LBFMCategoryContents]? {
        didSet {
            guard let model = categoryContentsModel else {return}
            self.categoryContents = model
            self.collectionView.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension LBFMHomeVipHotCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return self.recommendList?.count ?? 0
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:LBFMVipHotCell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMVipHotCellID, for: indexPath) as! LBFMVipHotCell
        cell.categoryContentsModel = self.categoryContents?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.homeVipHotCellItemClick(model: (self.categoryContents?[indexPath.row])!)
    }
    
    //每个分区的内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
    }
    
    //最小 item 间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5;
    }
    
    //最小行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5;
    }
    
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width:((LBFMScreenWidth - 50) / 3),height:self.frame.size.height)
    }
}
