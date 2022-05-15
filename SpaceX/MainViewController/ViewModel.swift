//
//  ViewModel.swift
//  SpaceX
//
//  Created by Okan Sarp Kaya on 15.05.2022.
//

import Foundation

class ViewModel{
    var data = [SpaceXHistoryQuery.Data.Launch]()
    var pagination = 0
    var isThereNewDataOnServer = true
    var hasLoaded = false
    
    func loadLaunches(completion: @escaping () -> ()) {
        Network.shared.apollo
            .fetch(query: SpaceXHistoryQuery(offset: self.pagination)) { [weak self] result in
          
          guard let self = self else {
            return
          }

          defer {
              completion()
          }
                  
          switch result {
          case .success(let graphQLResult):
              if let launchConnection = graphQLResult.data?.launches {
                self.data.append(contentsOf: launchConnection.compactMap { $0 })
                  if self.data.count < self.pagination{
                    self.isThereNewDataOnServer = false
                }
                  self.hasLoaded = false
              }
                      
              if let errors = graphQLResult.errors {
                let message = errors
                      .map { $0.localizedDescription }
                      .joined(separator: "\n")
              }

          case .failure(let error):
              print("error")
          }
        }
      }
}

