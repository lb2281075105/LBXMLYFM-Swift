//
//  LBFMClassifySubRecommendController.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/5.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMClassifySubRecommendController: UIViewController {
    // - 上页面传过来请求接口必须的参数
    private var categoryId: Int = 0
    convenience init(categoryId:Int = 0) {
        self.init()
        self.categoryId = categoryId
    }
    private let ClassifySubHeaderViewID = "ClassifySubHeaderView"
    private let ClassifySubFooterViewID = "ClassifySubFooterView"
    
    private let ClassifySubHeaderCellID = "ClassifySubHeaderCell"
    private let ClassifySubHorizontalCellID = "ClassifySubHorizontalCell"
    private let ClassifySubVerticalCellID = "ClassifySubVerticalCell"
    private let ClassifySubModuleType20CellID = "ClassifySubModuleType20Cell"
    private let ClassifySubModuleType19CellID = "ClassifySubModuleType19Cell"
    private let ClassifySubModuleType17CellID = "ClassifySubModuleType17Cell"
    private let ClassifySubModuleType4CellID = "ClassifySubModuleType4Cell"
    private let ClassifySubModuleType16CellID = "ClassifySubModuleType16Cell"
    private let ClassifySubModuleType23CellID = "ClassifySubModuleType23Cell"
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let collection = UICollectionView.init(frame:.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.white
        // MARK -注册头视图和尾视图
        collection.register(ClassifySubHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ClassifySubHeaderViewID)
        collection.register(ClassifySubFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: ClassifySubFooterViewID)
        //
        // MARK -注册不同分区cell
        collection.register(ClassifySubHeaderCell.self, forCellWithReuseIdentifier: ClassifySubHeaderCellID)
        collection.register(ClassifySubHorizontalCell.self, forCellWithReuseIdentifier: ClassifySubHorizontalCellID)
        collection.register(ClassifySubVerticalCell.self, forCellWithReuseIdentifier: ClassifySubVerticalCellID)
        collection.register(ClassifySubModuleType20Cell.self, forCellWithReuseIdentifier: ClassifySubModuleType20CellID)
        collection.register(ClassifySubModuleType19Cell.self, forCellWithReuseIdentifier: ClassifySubModuleType19CellID)
        collection.register(ClassifySubModuleType17Cell.self, forCellWithReuseIdentifier: ClassifySubModuleType17CellID)
        collection.register(ClassifySubModuleType4Cell.self, forCellWithReuseIdentifier: ClassifySubModuleType4CellID)
        collection.register(ClassifySubModuleType16Cell.self, forCellWithReuseIdentifier: ClassifySubModuleType16CellID)
        collection.register(ClassifySubModuleType23Cell.self, forCellWithReuseIdentifier: ClassifySubModuleType23CellID)
        collection.uHead = URefreshHeader{ [weak self] in self?.loadRecommendData() }
        
        return collection
    }()
    
    
    lazy var viewModel: ClassifySubRecommendViewModel = {
        return ClassifySubRecommendViewModel()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        self.collectionView.uHead.beginRefreshing()
        loadRecommendData()
    }
    
    func loadRecommendData(){
        viewModel.categoryId = self.categoryId
        // 加载数据
        viewModel.updataBlock = { [unowned self] in
            self.collectionView.uHead.endRefreshing()
            // 更新列表数据
            self.collectionView.reloadData()
        }
        viewModel.refreshDataSource()
    }
}

extension LBFMClassifySubRecommendController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections(collectionView:collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsIn(section: section)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cardClass = viewModel.classifyCategoryContentsList?[indexPath.section].cardClass
        let moduleType = viewModel.classifyCategoryContentsList?[indexPath.section].moduleType
        if moduleType == 14 {
            let cell:ClassifySubHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassifySubHeaderCellID, for: indexPath) as! ClassifySubHeaderCell
            cell.focusModel = viewModel.focus
            cell.classifyCategoryContentsListModel = viewModel.classifyCategoryContentsList?[indexPath.section]
            return cell
        }else if moduleType == 3 {
            if cardClass == "horizontal" {
                let cell:ClassifySubHorizontalCell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassifySubHorizontalCellID, for: indexPath) as! ClassifySubHorizontalCell
                cell.classifyVerticalModel = viewModel.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row]
                return cell
            }else {
                let cell:ClassifySubVerticalCell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassifySubVerticalCellID, for: indexPath) as! ClassifySubVerticalCell
                cell.classifyVerticalModel = viewModel.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row]
                return cell
            }
        }else if moduleType == 5{
            if cardClass == "horizontal" {
                let cell:ClassifySubHorizontalCell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassifySubHorizontalCellID, for: indexPath) as! ClassifySubHorizontalCell
                cell.classifyVerticalModel = viewModel.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row]
                return cell
            }else {
                let cell:ClassifySubVerticalCell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassifySubVerticalCellID, for: indexPath) as! ClassifySubVerticalCell
                cell.classifyVerticalModel = viewModel.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row]
                return cell
            }
        }else if moduleType == 20 {
            let cell:ClassifySubModuleType20Cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassifySubModuleType20CellID, for: indexPath) as! ClassifySubModuleType20Cell
            cell.classifyVerticalModel = viewModel.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row]
            return cell
        }else if moduleType == 19 {
            let cell:ClassifySubModuleType19Cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassifySubModuleType19CellID, for: indexPath) as! ClassifySubModuleType19Cell
            cell.classifyVerticalModel = viewModel.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row]
            return cell
        }else if moduleType == 17 {
            let cell:ClassifySubModuleType17Cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassifySubModuleType17CellID, for: indexPath) as! ClassifySubModuleType17Cell
            cell.classifyVerticalModel = viewModel.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row]
            return cell
        }else if moduleType == 4 {
            let cell:ClassifySubModuleType4Cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassifySubModuleType4CellID, for: indexPath) as! ClassifySubModuleType4Cell
            cell.classifyVerticalModel = viewModel.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row]
            return cell
        }else if moduleType == 16 {
            let cell:ClassifySubModuleType16Cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassifySubModuleType16CellID, for: indexPath) as! ClassifySubModuleType16Cell
            cell.classifyVerticalModel = viewModel.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row]
            return cell
        }else if moduleType == 23{
            let cell:ClassifySubModuleType23Cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassifySubModuleType23CellID, for: indexPath) as! ClassifySubModuleType23Cell
            //            cell.classifyVerticalModel = self.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row]
            return cell
        }else if moduleType == 18{
            let cell:ClassifySubVerticalCell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassifySubVerticalCellID, for: indexPath) as! ClassifySubVerticalCell
            cell.classifyVerticalModel = viewModel.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row]
            return cell
        }else {
            let cell:ClassifySubVerticalCell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassifySubVerticalCellID, for: indexPath) as! ClassifySubVerticalCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let albumId = viewModel.classifyCategoryContentsList?[indexPath.section].list?[indexPath.row].albumId ?? 0
        let vc = FMPlayDetailController(albumId:albumId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //每个分区的内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return viewModel.insetForSectionAt(section: section)
    }
    
    //最小 item 间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumInteritemSpacingForSectionAt(section: section)
    }
    
    //最小行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumLineSpacingForSectionAt(section: section)
    }
    
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeForItemAt(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return viewModel.referenceSizeForHeaderInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return viewModel.referenceSizeForFooterInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView : ClassifySubHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ClassifySubHeaderViewID, for: indexPath) as! ClassifySubHeaderView
            headerView.classifyCategoryContents = viewModel.classifyCategoryContentsList?[indexPath.section]
            return headerView
        }else if kind == UICollectionElementKindSectionFooter {
            let footerView : ClassifySubFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: ClassifySubFooterViewID, for: indexPath) as! ClassifySubFooterView
            return footerView
        }
        return UICollectionReusableView()
    }
}
