//
//  ViewModel.swift
//  17Test
//
//  Created by 劉柏賢 on 2021/10/1.
//

import WebAPI
import MVVM
import PromiseKit

struct ViewModel: Refreshable, Updateable, MutatingClosure {

    weak var binder: Binder?
    var isUpdate: Bool = false

    private var isDataLoaded: Bool = false
    private let perPage: Int = 50
    private var page: Int = 1
    private var totalCount: Int? = nil
    
    var input: String = "" {
        didSet {
            refresh()
        }
    }
    
    private(set) var cellViewModels: [CellViewModel] = []
    private(set) var model: SearchUsersModel? {
        didSet {
            cellViewModels = model?.items.map { CellViewModel(model: $0) } ?? []
        }
    }
    
    init(binder: Binder)
    {
        self.binder = binder
        refresh()
    }

    mutating func refresh(callback: (() -> Void)? = nil) {

        isDataLoaded = false

        clean()

        guard !input.isEmpty else {
            isDataLoaded = true
            callback?()
            return
        }
        
        let copySelf = self

        let parameter: SearchUsersParameter = SearchUsersParameter(perPage: perPage, page: page, q: input)
        _ = callWebAPI(parameter: parameter).ensure {
            copySelf.mutating { (mutatingSelf: inout ViewModel) in
                mutatingSelf.isDataLoaded = true
            }
        }
    }

    private mutating func clean() {
        model = nil
        page = 1
        totalCount = nil
    }

    func loadMoreIfNeeded() {

        guard isDataLoaded, !isUpdate else {
            return
        }

        if let totalCount = totalCount,
           let model = model {
            
            guard model.items.count < totalCount else {
                return
            }
        }

        mutating { (mutatingSelf: inout ViewModel) in
            mutatingSelf.loadMore(callback: nil)
        }
    }

    private mutating func loadMore(callback: (() -> Void)?) {
        page += 1
        loadMore(page: page, callback: callback)
    }

    private mutating func loadMore(page: Int, callback: (() -> Void)?) {
        let parameter: SearchUsersParameter = SearchUsersParameter(perPage: perPage, page: page, q: input)
        _ = callWebAPI(parameter: parameter).ensure {
            callback?()
        }
    }
    
    private mutating func callWebAPI(parameter: SearchUsersParameter) -> Promise<Void> {

        isUpdate = true
        
        let copySelf = self
        
        let promise = SearchUsersWebAPI().invokeAsync(parameter).done { (partialModel: SearchUsersModel) in
            copySelf.mutating { (mutatingSelf: inout ViewModel) in

                mutatingSelf.totalCount = partialModel.totalCount

                guard var model = mutatingSelf.model else {
                    mutatingSelf.model = partialModel
                    return
                }
                
                model.items.append(contentsOf: partialModel.items)
                mutatingSelf.model = model
            }
        }.recover { (error: Error) in
            copySelf.mutating { (mutatingSelf: inout ViewModel) in
                print(error.localizedDescription)
                mutatingSelf.clean()
            }
            
            throw error
        }
        .ensure {
            copySelf.mutating { (mutatingSelf: inout ViewModel) in
                mutatingSelf.isUpdate = false
            }
        }
        
        return promise
    }
}
