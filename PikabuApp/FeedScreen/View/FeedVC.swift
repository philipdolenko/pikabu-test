//
//  FeedVC.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 02.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {
    
    private struct Section {
        let type: SectionType
        let posts: () -> [Post]
    }
    
    private enum SectionType: String {
        case feed = "Лента"
        case savedFeed = "Сохраненные"
    }
    
    private var viewModel = FeedViewModel()
    
    private lazy var sections: [Section] = {
        [
            .init(
                type: .feed,
                posts: { [unowned self] in
                    self.viewModel.posts.value
                }
            ),
            .init(
                type: .savedFeed,
                posts: { [unowned self] in
                    self.viewModel.savedPosts.value
                }
            )
        ]
    }()
    
    weak var topBar: TopBar!
    weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        viewModel.viewDidLoad()
        configureCollectionView()
        subscribeToViewModelChanges()
        topBar.configure(
            tabsNames: sections.map({$0.type.rawValue}),
            listener: self
        )
    }
    
    
    private func subscribeToViewModelChanges(){
        viewModel.posts.observe { [unowned self] (posts) in
            let feedIndex = self.sections.firstIndex(where: {$0.type == .feed})!// TODO replace by ?? 0
            let indexToUpdate = IndexPath(row: feedIndex, section: 0)
            
            self.collectionView.reloadItems(at: [indexToUpdate])
        }
        viewModel.savedPosts.observe { [unowned self] (posts) in
            let savedFeedIndex = self.sections.firstIndex(where: {$0.type == .savedFeed})!// TODO replace by ?? 0
            let indexToUpdate = IndexPath(row: savedFeedIndex, section: 0)
            
            self.collectionView.reloadItems(at: [indexToUpdate])
        }
    }
    
    private func configureCollectionView() {
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension FeedVC : TopBarListener, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    func scrollToBarIndex(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        topBar.moveIndicator(scrollView.contentOffset.x)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / view.frame.width)
        topBar.selectItem(index)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexPath) as! FeedCell
        cell.configure(with: sections[indexPath.row].posts())
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
