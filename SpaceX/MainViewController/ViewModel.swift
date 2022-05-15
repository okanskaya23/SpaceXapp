//
//  ViewModel.swift
//  SpaceX
//
//  Created by Okan Sarp Kaya on 15.05.2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class ViewModel{
    
    var data = BehaviorSubject(value: [SpaceXHistoryQuery.Data.Launch]())

    var paginationCursor = 0
    var isThereNewDataOnServer = true
    var hasLoaded = false
    
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
                        do {
                            try self.data.onNext(self.data.value() + launchConnection.compactMap { $0 })
                            let count = try self.data.value().count
                            if count < self.paginationCursor{
                                self.isThereNewDataOnServer = false
                            }

                        } catch {
                            debugPrint(error)
                        }
                        self.hasLoaded = false
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

