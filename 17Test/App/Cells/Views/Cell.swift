//
//  Cell.swift
//  17Test
//
//  Created by 劉柏賢 on 2021/9/24.
//  
//

import UIKit
import MVVM

class Cell: UICollectionViewCell, Viewer {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var gradient: UIView!
    
    typealias ViewModelType = CellViewModel
    var viewModel: ViewModelType! {
        didSet {
            titleLabel.text = viewModel.model.login
            icon.setImage(urlString: viewModel.model.avatarUrl, placeholder: nil)
            gradient.updateGradientLayer()
        }
    }

    override func layoutSubviews() {

        gradient.updateGradientLayer()

        super.layoutSubviews()
    }
}
