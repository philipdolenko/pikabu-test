//
//  TopBar.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 02.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import SnapKit

protocol TopBarListener {
    func scrollToBarIndex(index: Int)
}

class TopBar: UIView {
    
    private var collectionView: UICollectionView!
    private var tabsNames: [String]!
    private var tabsSize: Int { tabsNames.count }
    private var selectedTabIndicator: UIView!
    private var listener: TopBarListener?
    
    func configure(tabsNames: [String], listener: TopBarListener? = nil, selectedItem: Int = 0){
        self.tabsNames = tabsNames
        self.listener = listener
        
        if tabsSize == 0 {
            #if DEBUG
            fatalError() //tabsNames should not be empty
            #else
            tabsNames = [""]
            #endif
        }
        
        setupColletionView(with: selectedItem)
        setupSelectedTabIndicator()
    }
    
    private func setupColletionView(with selectedItem: Int){
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BarCell.self, forCellWithReuseIdentifier: BarCell.identifier)
        
        addSubview(collectionView)
        
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let selectedIndexPath = IndexPath(item: selectedItem, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .bottom)
    }
    
    private func setupSelectedTabIndicator() {
        let selectedTabIndicator = UIView()
        selectedTabIndicator.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        selectedTabIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(selectedTabIndicator)
        
        selectedTabIndicator.widthAnchor.constraint(
            equalTo: self.widthAnchor, multiplier: 1 / CGFloat(tabsSize)
        ).isActive = true
        
        selectedTabIndicator.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(6)
        }
        
        self.selectedTabIndicator = selectedTabIndicator
    }
    
    func selectItem(_ index: Int){
        guard index >= 0, index < tabsSize else { return }
        
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func moveIndicator(_ x: CGFloat){
        selectedTabIndicator.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(x / CGFloat(tabsSize))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TopBar: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        listener?.scrollToBarIndex(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tabsSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BarCell.identifier, for: indexPath) as! BarCell
        cell.tabLbl.text = tabsNames[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / CGFloat(tabsSize), height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
