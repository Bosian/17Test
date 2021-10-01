//
//  Progressor.swift
//  Zoo
//
//  Created by 劉柏賢 on 2021/8/12.
//

import MVVM
import UIKit

protocol Progressor: Viewer where ViewModelType: Updateable {
    func showProgress(isUpdate: Bool)
}
