//
//  ViewControllerExtension.swift
//  17Test
//
//  Created by 劉柏賢 on 2021/9/24.
//

import UIKit
import MVVM

extension UIViewController {
    func handlePrepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let parameterDelegate = segue.destination as? ParameterDelegate
        {
            parameterDelegate.set(parameter: sender)
        }
    }
}





//import UIKit
//import MVVM
//
//extension UIViewController {
//    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let parameterDelegate = segue.destination as? ParameterDelegate
//        {
//            parameterDelegate.set(parameter: sender)
//        }
//    }
//}
