//
//  LBFMFindAttentionPicCell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/28.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMFindAttentionPicCell: UICollectionViewCell {
    private lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 布局
        setupLayout()
    }
    // 布局
    func setupLayout() {
        self.addSubview(self.imageView)
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 5
        self.imageView.contentMode = UIView.ContentMode.scaleAspectFill
        self.imageView.clipsToBounds = true
        self.imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var picModel :LBFMFindAPicInfos? {
        didSet {
            guard let model = picModel else {return}
            self.imageView.kf.setImage(with: URL(string:model.originUrl! ))
        }
    }
}
