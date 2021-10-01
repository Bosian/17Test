//
//  Navigatable.swift
//  MVVM
//
//  Created by 劉柏賢 on 2021/8/12.
//

public protocol Navigatable: ParameterDelegate {
    associatedtype NavigationParameter
    
    var navigationParameter: NavigationParameter? { get set }
}

public protocol ParameterDelegate: AnyObject {
    func get() -> Any?
    func set(parameter: Any?)
}

extension ParameterDelegate where Self: Navigatable {
    public func get() -> Any? {
        return navigationParameter
    }

    public func set(parameter: Any?) {
        navigationParameter = parameter as? NavigationParameter
    }
}
