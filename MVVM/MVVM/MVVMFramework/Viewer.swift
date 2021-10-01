//
//  Viewer.swift
//  MVVM
//
//  Created by 劉柏賢 on 2021/8/11.
//

public protocol Viewer: Binder {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
}

extension Viewer {
    public var dataContext: Any? {
        get {
            return viewModel
        }
        
        set {
            viewModel = newValue as? ViewModelType
        }
    }
}
