//
//  LBFMRecommendGuessLikeCell.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/22.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON
/// 添加cell点击代理方法
protocol LBFMRecommendGuessLikeCellDelegate:NSObjectProtocol {
    func recommendGuessLikeCellItemClick(model:LBFMRecommendListModel)
}
class LBFMRecommendGuessLikeCell: UICollectionViewCell {
    
    weak var delegate : LBFMRecommendGuessLikeCellDelegate?
    
    private var recommendList:[LBFMRecommendListModel]?
    
    private let LBFMGuessYouLikeCellID = "LBFMGuessYouLikeCell"
    private lazy var changeBtn:UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setTitle("换一批", for: UIControl.State.normal)
        button.setTitleColor(LBFMButtonColor, for: UIControl.State.normal)
        button.backgroundColor = UIColor.init(red: 254/255.0, green: 232/255.0, blue: 227/255.0, alpha: 1)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(updataBtnClick(button:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let collectionView = UICollectionView.init(frame:.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        collectionView.register(LBFMGuessYouLikeCell.self, forCellWithReuseIdentifier: LBFMGuessYouLikeCellID)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    func setUpLayout(){
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.left.top.equalTo(15)
            make.bottom.equalToSuperview().offset(-50)
            make.right.equalToSuperview().offset(-15)
        }
        
        self.addSubview(self.changeBtn)
        self.changeBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var recommendListData:[LBFMRecommendListModel]? {
        didSet{
            guard let model = recommendListData else { return }
            self.recommendList = model
            self.collectionView.reloadData()
        }
    }
    // 更换一批按钮刷新cell
    @objc func updataBtnClick(button:UIButton){
        // 首页推荐接口请求
        LBFMRecommendProvider.request(.changeGuessYouLikeList) { result in
            if case let .success(response) = result {
                // 解析数据
                let data = try? response.mapJSON()
                let json = JSON(data!)
                if let mappedObject = JSONDeserializer<LBFMRecommendListModel>.deserializeModelArrayFrom(json: json["list"].description) {
                    self.recommendList = mappedObject as? [LBFMRecommendListModel]
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
}
    
extension LBFMRecommendGuessLikeCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.recommendList?.count ?? 0
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell:LBFMGuessYouLikeCell = collectionView.dequeueReusableCell(withReuseIdentifier: LBFMGuessYouLikeCellID, for: indexPath) as! LBFMGuessYouLikeCell
            cell.recommendData = self.recommendList?[indexPath.row]
            return cell
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            delegate?.recommendGuessLikeCellItemClick(model: (self.recommendList?[indexPath.row])!)
        }

        //每个分区的内边距
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0);
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
            return CGSize.init(width:(LBFMScreenWidth - 55) / 3,height:180)
        }
}

