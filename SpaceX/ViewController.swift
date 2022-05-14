//
//  ViewController.swift
//  SpaceX
//
//  Created by Okan Sarp Kaya on 13.05.2022.
//

import UIKit
import Apollo


class ViewController: UIViewController {

    @IBOutlet var tw: UITextView!
    var data = [SpaceXHistoryQuery.Data.History]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadLaunches()
        
    }
    private func loadLaunches() {
        Network.shared.apollo
          .fetch(query: SpaceXHistoryQuery()) { [weak self] result in
          
          guard let self = self else {
            return
          }

          defer {
              self.tw.text = self.data[0].details
          }
                  
          switch result {
          case .success(let graphQLResult):
              if let launchConnection = graphQLResult.data?.histories {
                self.data.append(contentsOf: launchConnection.compactMap { $0 })
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

