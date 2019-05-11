//
//  LBFMClassifySubModuleType20Cell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/8.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMClassifySubModuleType20Cell: UICollectionViewCell {
    private var albums:[LBFMClassifyModuleType20List]?
    // 图片
    private lazy var imageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    // 标题
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    // 查看更多
    private lazy var moreBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("-(查看更多)-", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.titleLabel?.textAlignment = NSTextAlignment.center
        return button
    }()
    
    
    // - 懒加载collectionView
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width:(LBFMScreenWidth - 40) / 3, height:180)
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        let collectionView = UICollectionView.init(frame:.zero, collectionViewLayout: layout)
        collectionView.contentSize = CGSize.init(width: LBFMScreenWidth - 40, height: 180)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(LBFMClassifySubHorizontalCell.self, forCellWithReuseIdentifier:"LBFMClassifySubHorizontalCell")
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(100)
        }
        
        self.imageView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        
        self.imageView.addSubview(self.moreBtn)
        self.moreBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.width.equalTo(150)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.imageView.snp.bottom).offset(15)
        }
    }
    
    var classifyVerticalModel: LBFMClassifyVerticalModel? {
        didSet {
            guard let model = classifyVerticalModel else {return}
            self.imageView.kf.setImage(with: URL(string: model.coverPathBig!))
            self.titleLabel.text = model.title
            self.albums = model.albums
            self.collectionView.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}

extension LBFMClassifySubModuleType20Cell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albums?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:LBFMClassifySubHorizontalCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LBFMClassifySubHorizontalCell", for: indexPath) as! LBFMClassifySubHorizontalCell
        cell.classifyModuleType20Model = self.albums?[indexPath.row]
        return cell
    }
}
