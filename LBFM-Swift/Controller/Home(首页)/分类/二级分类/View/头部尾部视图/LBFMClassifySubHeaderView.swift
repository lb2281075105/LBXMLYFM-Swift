//
//  LBFMClassifySubHeaderView.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/7.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMClassifySubHeaderView: UICollectionReusableView {
    // 标题
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    // 更多
    private var moreBtn:UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setTitle("更多 >", for: UIControl.State.normal)
        button.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    // 收听全部
    private var allBtn:UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "category_rec_play_all_122x46_"), for: UIControl.State.normal)
        button.isHidden = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    // 布局
    func setUpLayout(){
        self.addSubview(self.titleLabel)
        self.titleLabel.text = "猜你喜欢"
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.equalTo(200)
            make.top.equalTo(5)
            make.height.equalTo(30)
        }
        
        self.addSubview(self.moreBtn)
        self.moreBtn.snp.makeConstraints { (make) in
            make.right.equalTo(15)
            make.top.equalTo(5)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        self.addSubview(self.allBtn)
        self.allBtn.layer.masksToBounds = true
        self.allBtn.layer.cornerRadius = 15
        self.allBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(5)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
    }
    
    var classifyCategoryContents:LBFMClassifyCategoryContentsList?{
        didSet {
            guard let model = classifyCategoryContents else {return}
            self.titleLabel.text = model.title
            if model.moduleType == 19 {
                self.moreBtn.isHidden = true
                self.allBtn.isHidden = false
            }else {
                self.moreBtn.isHidden = false
                self.allBtn.isHidden = true
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
