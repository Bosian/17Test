//
//  File.swift
//  Test
//
//  Created by 劉柏賢 on 2016/9/24.
//  Copyright © 2016年 劉柏賢. All rights reserved.
//

import UIKit

public protocol PullToRefreshable: UIScrollViewDelegate {

    var scrollView: UIScrollView? { get }
    var refreshControl: UIRefreshControl! { get set }

    func setupPullToRefresh(selector: Selector, attributedTitle: NSAttributedString)
    func refresh(sender: UIRefreshControl)
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    func pullToRefreshScrollViewDidEndDragging(_ scrollView: UIScrollView)
}

extension PullToRefreshable {
    public func setupPullToRefresh(selector: Selector, attributedTitle: NSAttributedString = NSAttributedString(string: "")) {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: selector, for: .valueChanged)

        scrollView?.insertSubview(refreshControl, at: 0)
    }

    public func pullToRefreshScrollViewDidEndDragging(_ scrollView: UIScrollView) {

        if !refreshControl.isRefreshing {
            guard scrollView.contentOffset.y < -115 else {
                return
            }

            refreshControl.beginRefreshing()
            refreshControl.sendActions(for: .valueChanged)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
}
