//
//  PostScreenVC.swift
//  PikabuApp
//
//  Created by Philip Dolenko on 07.12.2020.
//  Copyright © 2020 Philip Dolenko. All rights reserved.
//

import UIKit

class PostScreenVC: UIViewController {
    
    var viewModel: PostScreenViewModel!
    
    weak var scrollView: UIScrollView!
    weak var titleLbl: UILabel!
    weak var bodyLbl: UILabel!
    weak var saveButton: SaveButton!
    weak var imageTableView: FullContentTableView!
    
    let contentMargin: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        subscribeToViewModelChanges()
        viewModel.viewDidLoad()
    }
    
    private func subscribeToViewModelChanges(){
        viewModel.post.observe { [unowned self] (post) in
            self.updateView(with: post)
        }
    }
    
    private func updateView(with post: Post){
        titleLbl.text = post.title
        bodyLbl.text = post.body
        imageTableView.reloadData()
        saveButton.setState(post.isSaved ? .saved : .unsaved)
        
    }
    
    @objc func didSaveButtonClick(_ sender: UIButton) {
        viewModel.switchPostSaveState()
    }

    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }
    
    // adapt layout after orientation change
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.scrollView.invalidateIntrinsicContentSize()
            
            self.imageTableView.snp.remakeConstraints { (make) in
                make.top.equalTo(self.titleLbl.snp.bottom).offset(8)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.width.equalTo(self.scrollView.frame.width - 16 * 2)
            }
        }, completion: nil)
    }
}


extension PostScreenVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.post.value.images?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostImageCell.identifier, for: indexPath) as? PostImageCell else { return UITableViewCell() }
        
        if let images = viewModel.post.value.images {
            cell.configure(urlString: images[indexPath.row])
        }
        
        return cell
    }
}

