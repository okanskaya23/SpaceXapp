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
    var data = [SpaceXHistoryQuery.Data.Launch]()
    var dataRx = BehaviorSubject(value: [SectionModel(model: "", items: [SpaceXHistoryQuery.Data.Launch]())])

    var paginationCursor = 0
    var isThereNewDataOnServer = true
    var hasLoaded = false
    
    func loadLaunches(completion: @escaping () -> ()) {
        Network.shared.apollo
            .fetch(query: SpaceXHistoryQuery(offset: self.paginationCursor)) { [weak self] result in
                
                guard let self = self else {
                    return
                }
                
                defer {
                    //Reload TableView with new data
                    completion()
                }
                
                switch result {
                case .success(let graphQLResult):
                    if let launchConnection = graphQLResult.data?.launches {
                        self.data.append(contentsOf: launchConnection.compactMap { $0 })
                        let a = SectionModel(model: "Second", items: launchConnection.compactMap { $0 })
                        self.dataRx.on(.next([a]))
                        if self.data.count < self.paginationCursor{
                            self.isThereNewDataOnServer = false
                        }
                        self.hasLoaded = false
                    }
                    
                    if let errors = graphQLResult.errors {
                        let message = errors
                            .map { $0.localizedDescription }
                            .joined(separator: "\n")
                        print(message)
                        
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func updateCurserPosition(){
        self.paginationCursor += Network.paginationLimit
    }
}

