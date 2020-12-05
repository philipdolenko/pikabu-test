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
            tabsNames: viewModel.sections.map({$0.type.rawValue}),
            listener: self
        )
    }
    
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
    
    
    private func subscribeToViewModelChanges(){
        viewModel.posts.observe { [unowned self] (posts) in
            let feedIndex = self.viewModel.sections.firstIndex(where: {$0.type == .feed})!// TODO replace by ?? 0
            let indexToUpdate = IndexPath(row: feedIndex, section: 0)
            
            guard let collectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexToUpdate) as? FeedCell else { return }
            print(collectionViewCell.lastValidOffset)
            self.storedOffsets[indexToUpdate.row] = collectionViewCell.lastValidOffset
            self.collectionView.reloadItems(at: [indexToUpdate])
        }
        viewModel.savedPosts.observe { [unowned self] (posts) in
            let savedFeedIndex = self.viewModel.sections.firstIndex(where: {$0.type == .savedFeed})!// TODO replace by ?? 0
            let indexToUpdate = IndexPath(row: savedFeedIndex, section: 0)
            
            guard let collectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexToUpdate) as? FeedCell else { return }
            print(collectionViewCell.lastValidOffset)
            self.storedOffsets[indexToUpdate.row] = collectionViewCell.lastValidOffset
            
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

extension FeedVC : TopBarListener, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    

//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        guard let collectionViewCell = cell as? FeedCell else { return }
//        let offset = storedOffsets[indexPath.row] ?? 0
//        collectionViewCell.layoutIfNeeded()
//        collectionViewCell.collectionViewOffset = offset
//    }
//
//     func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        guard let collectionViewCell = cell as? FeedCell else { return }
//        let offset = collectionViewCell.collectionViewOffset
//        storedOffsets[indexPath.row] = offset
//    }
    
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
        self.viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexPath) as! FeedCell
        let section = viewModel.sections[indexPath.row]
        cell.configure(with: section.posts(), postSaver: section.postSaver, scrollOffset: storedOffsets[indexPath.row] ?? 0)
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
