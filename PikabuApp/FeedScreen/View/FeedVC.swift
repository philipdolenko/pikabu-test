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
    weak var navigationCollectionView: UICollectionView!
    
    private var storedOffsets = [Int: CGFloat]()
    
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
    
    private func configureCollectionView() {
        navigationCollectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
        navigationCollectionView.dataSource = self
        navigationCollectionView.delegate = self
    }
    
    private func subscribeToViewModelChanges(){
        viewModel.posts.observe { [unowned self] (posts) in
            self.updateSection(.feed)
        }
        viewModel.savedPosts.observe { [unowned self] (posts) in
            self.updateSection(.savedFeed)
        }
    }
    
    private func updateSection(_ section: FeedViewModel.SectionType) {
        let sectionIndex = section.rawValue
        let indexToUpdate = IndexPath(row: sectionIndex, section: 0)
        
        if let cell = self.navigationCollectionView.cellForItem(at: indexToUpdate) as? FeedCell {
            let offset = cell.collectionViewOffset
            self.storedOffsets[sectionIndex] = offset
        }
        
        self.navigationCollectionView.reloadItems(at: [indexToUpdate])
    }
}

extension FeedVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let feedCell = cell as? FeedCell else { return }
        let offset = storedOffsets[indexPath.row] ?? 0
        feedCell.setScrollOffset(offset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let feedCell = cell as? FeedCell else { return }
        let offset = feedCell.collectionViewOffset
        storedOffsets[indexPath.row] = offset
    }
}

extension FeedVC : TopBarListener  {
    
    func scrollToBarIndex(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        navigationCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        topBar.moveIndicator(scrollView.contentOffset.x)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / view.frame.width)
        topBar.selectItem(index)
    }
    
}

extension FeedVC {
    
    // adapt layout after orientation change
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard let collectionView = navigationCollectionView else { return }
        let offset = collectionView.contentOffset
        let width = collectionView.bounds.size.width

        let index = round(offset.x / width)
        let newOffset = CGPoint(x: index * size.width, y: offset.y)

        collectionView.isHidden = true
        coordinator.animate(alongsideTransition: { (context) in
            collectionView.reloadData()
            collectionView.setContentOffset(newOffset, animated: false)
        }, completion: { _ in
            collectionView.isHidden = false
        })
        
        topBar.invalidateLayout()
    }
}

extension FeedVC {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
