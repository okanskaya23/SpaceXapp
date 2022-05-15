//
//  ViewController.swift
//  SpaceX
//
//  Created by Okan Sarp Kaya on 13.05.2022.
//

import UIKit
import Apollo


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    private var pagination = 0
    
    var data = [SpaceXHistoryQuery.Data.Launch]()
    private var isThereNewDataOnServer = true
    private var hasLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(CustomRocketCell.nib(), forCellReuseIdentifier: CustomRocketCell.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        self.loadLaunches()

        
    }
    private func loadLaunches() {
        Network.shared.apollo
            .fetch(query: SpaceXHistoryQuery(offset: self.pagination)) { [weak self] result in
          
          guard let self = self else {
            return
          }

          defer {
              self.tableView.reloadData()
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
extension ViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomRocketCell.cellIdentifier, for: indexPath) as! CustomRocketCell
        
        let model = data[indexPath.row]
        cell.title.text = model.missionName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailViewController()
        vc.modalPresentationStyle = .popover
        vc.detailDescription = UITextView()
        self.present(vc, animated: true, completion: nil)
        vc.detailDescription.text = self.data[indexPath.row].details

        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pos = scrollView.contentOffset.y
        if isThereNewDataOnServer && !hasLoaded{
             if pos > tableView.contentSize.height-50 - scrollView.frame.size.height{
                 self.pagination += Network.paginationLimit
                 self.loadLaunches()
                 print("hey")
                 hasLoaded = true
                 
             }
        }
        
    }

}

