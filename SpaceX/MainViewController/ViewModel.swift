//
//  ViewModel.swift
//  SpaceX
//
//  Created by Okan Sarp Kaya on 15.05.2022.
//

import Foundation
import RxSwift
import RxCocoa


class ViewModel{
        
    private var paginationCursor = 0
    private var isThereNewDataOnServer:BehaviorSubject<Bool> = BehaviorSubject(value: true)
    var hasLoaded:BehaviorSubject<Bool> = BehaviorSubject(value: true)
    var data = [Launches]()

    var canLoadMore:Observable<Bool> {
        return Observable.combineLatest(hasLoaded, isThereNewDataOnServer).map({ $0 && $1 })
    }
    
    func updateCurserPosition(){
        self.paginationCursor += Network.paginationLimit
    }
    
    func loadLaunches() {
        Network.shared.apollo
            .fetch(query: SpaceXHistoryQuery(offset: self.paginationCursor)) { [weak self] result in
                
                guard let self = self else {
                    return
                }
                
                switch result {
                case .success(let graphQLResult):
                    if let launchConnection = graphQLResult.data?.launches {
                        
                        self.data.append(contentsOf: launchConnection.compactMap { $0 })
                        
                        let count = self.data.count
                        if count < self.paginationCursor{
                            self.isThereNewDataOnServer.onNext(false)
                        }
                        
                        self.hasLoaded.onNext(true)
                    }
                    if let errors = graphQLResult.errors {
                        let message = errors
                            .map { $0.localizedDescription }
                            .joined(separator: "\n")
                        debugPrint(message)
                    }
                    
                case .failure(let error):
                    debugPrint(error)
                }
            }
    }
}

