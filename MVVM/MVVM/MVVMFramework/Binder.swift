//
//  Binder.swift
//  MVVM
//
//  Created by 劉柏賢 on 2021/8/11.
//

public protocol Binder: AnyObject {
    var dataContext: Any? { get set }
}
