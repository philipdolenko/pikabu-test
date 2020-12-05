//
//  FeedVC.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 02.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {
    
    var viewModel: FeedViewModel!
    
    weak var topBar: TopBar!
    weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        viewModel.viewDidLoad()
        configureCollectionView()
        subscribeToViewModelChanges()
        topBar.configure(
            tabsNames: FeedViewModel.SectionType.allCases.map({$0.title}),
            listener: self
        )
    }
    
    private func subscribeToViewModelChanges(){
        viewModel.posts.observe { [unowned self] (posts) in
            let feedIndex = FeedViewModel.SectionType.feed.rawValue
            let indexToUpdate = IndexPath(row: feedIndex, section: 0)
            
            guard let collectionViewCell = self.collectionView.cellForItem(at: indexToUpdate) as? FeedCell else { return }
            
            self.storedOffsets[indexToUpdate.row] = collectionViewCell.collectionViewOffset
            
            self.collectionView.reloadItems(at: [indexToUpdate])
        }
        viewModel.savedPosts.observe { [unowned self] (posts) in
            let savedFeedIndex = FeedViewModel.SectionType.savedFeed.rawValue
            let indexToUpdate = IndexPath(row: savedFeedIndex, section: 0)
            
            guard let collectionViewCell = self.collectionView.cellForItem(at: indexToUpdate) as? FeedCell else { return }
            
            self.storedOffsets[indexToUpdate.row] = collectionViewCell.collectionViewOffset
            
            self.collectionView.reloadItems(at: [indexToUpdate])
        }
    }
    
    private func configureCollectionView() {
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    var storedOffsets = [Int: CGFloat]()
}

extension FeedVC {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard let collectionView = collectionView else { return }
        let offset = collectionView.contentOffset
        let width = collectionView.bounds.size.width

        let index = round(offset.x / width)
        let newOffset = CGPoint(x: index * size.width, y: offset.y)

        coordinator.animate(alongsideTransition: { (context) in
            collectionView.reloadData()
            collectionView.setContentOffset(newOffset, animated: false)
        }, completion: nil)
        
        topBar.invalidateLayout()
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
        FeedViewModel.SectionType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexPath) as! FeedCell
        
        guard let section = FeedViewModel.SectionType.init(rawValue: indexPath.row) else { return UICollectionViewCell() }
        
        let posts = viewModel.getPosts(for: section)
        let offset = storedOffsets[indexPath.row] ?? 0
        
        cell.configure(with: posts, postSaver: viewModel, scrollOffset: offset)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension FeedVC {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
