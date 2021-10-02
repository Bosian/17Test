//
//  ViewController.swift
//  17Test
//
//  Created by 劉柏賢 on 2021/10/1.
//

import UIKit
import MVVM

class ViewController: UIViewController, Viewer, PullToRefreshable {

    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var refreshControl: UIRefreshControl!

    var scrollView: UIScrollView? { collectionView }

    private var windowInterfaceOrientation: UIInterfaceOrientation? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        } else {
            return UIApplication.shared.statusBarOrientation
        }
    }

    private var currentTypingTime: DispatchTime?
    
    private var cellWidth: CGFloat {
        let count: CGFloat = {
            if let windowInterfaceOrientation = windowInterfaceOrientation, windowInterfaceOrientation.isPortrait {
                return 4
            } else {
                return 8
            }
        }()
        
        let horizontalMargin: CGFloat = 8
        let space: CGFloat = 1 * (count - 1)
        let width: CGFloat = collectionView.bounds.size.width - horizontalMargin - space
        return width / count
    }
    
    typealias ViewModelType = ViewModel
    var viewModel: ViewModelType! {
        didSet {
            collectionView.reloadData()
            showProgress(isUpdate: viewModel.isUpdate)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPullToRefresh(selector: #selector(refresh(sender:)))

        viewModel = ViewModelType(binder: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        inputText.becomeFirstResponder()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        handlePrepare(for: segue, sender: sender)
    }

    override func viewDidLayoutSubviews() {

        collectionView.contentInset.top = inputText.frame.maxY
        collectionView.contentInset.bottom = self.view.safeAreaInsets.bottom

        super.viewDidLayoutSubviews()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard let previousTraitCollection = previousTraitCollection, traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass ||
            traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass else {
                return
        }

        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }

    /// 下拉更新
    ///
    /// - Parameter sender: sender description
    @objc func refresh(sender: UIRefreshControl) {
        
        viewModel.refresh(callback: {
            sender.endRefreshing()
        })
    }

    func showProgress(isUpdate: Bool) {
        activityIndicator.isHidden = !isUpdate
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {

        weak var weakSelf = self
        runOnce(delay: 0.4, saveCurrent: &currentTypingTime, getCurrent: weakSelf?.currentTypingTime) {
            weakSelf?.viewModel.input = sender.text ?? ""
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let id: String = "\(type(of: viewModel.cellViewModels[indexPath.row]))"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! (UICollectionViewCell & Binder)
        cell.dataContext = viewModel.cellViewModels[indexPath.row]
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= viewModel.cellViewModels.count - 1 {
            viewModel.loadMoreIfNeeded()
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        pullToRefreshScrollViewDidEndDragging(scrollView)
    }
}

