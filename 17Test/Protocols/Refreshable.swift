//
//  Refreshable.swift
//  Zoo
//
//  Created by 劉柏賢 on 2021/8/11.
//

protocol Refreshable {
    mutating func refresh(callback: (() -> Void)?)
}
