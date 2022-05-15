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
    private var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(CustomRocketCell.nib(), forCellReuseIdentifier: CustomRocketCell.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        self.viewModel.loadLaunches(){
            self.tableView.reloadData()
        }

        
    }
}
extension ViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomRocketCell.cellIdentifier, for: indexPath) as! CustomRocketCell
        
        let model = viewModel.data[indexPath.row]
        cell.title.text = model.missionName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailViewController()
        vc.modalPresentationStyle = .popover
        vc.detailDescription = UITextView()
        self.present(vc, animated: true, completion: nil)
        vc.detailDescription.text = self.viewModel.data[indexPath.row].details

        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pos = scrollView.contentOffset.y
        if viewModel.isThereNewDataOnServer && !viewModel.hasLoaded{
             if pos > tableView.contentSize.height-50 - scrollView.frame.size.height{
                 self.viewModel.pagination += Network.paginationLimit
                 self.viewModel.loadLaunches(){
                     self.tableView.reloadData()
                 }
                 print("hey")
                 viewModel.hasLoaded = true
                 
             }
        }
        
    }

}
