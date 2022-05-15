//
//  ViewController.swift
//  SpaceX
//
//  Created by Okan Sarp Kaya on 13.05.2022.
//

import UIKit
import Apollo
import RxSwift
import RxCocoa
import RxDataSources



class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    private var viewModel = ViewModel()
    private var bag = DisposeBag()

    
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

//MARK: TableView
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
}
//MARK: pagination
extension ViewController{
    //load new data in the end of the tableView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pos = scrollView.contentOffset.y
        if viewModel.isThereNewDataOnServer && !viewModel.hasLoaded{
            if pos > tableView.contentSize.height-50 - scrollView.frame.size.height{
                self.viewModel.updateCurserPosition()
                self.viewModel.loadLaunches(){
                    self.tableView.reloadData()
                }
                print("Pagination Request")
                viewModel.hasLoaded = true
            }
        }
    }
}
extension ViewController{
    func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: bag)

        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,SpaceXHistoryQuery.Data.Launch>> { _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomRocketCell", for: indexPath) as! CustomRocketCell
            cell.textLabel?.text = item.details
            cell.detailTextLabel?.text = "\(item.links)"
            return cell
        } titleForHeaderInSection: { dataSorce, sectionIndex in
            return dataSorce[sectionIndex].model
        }

        self.viewModel.dataRx.bind(to: self.tableView.rx.items(dataSource: dataSource)).disposed(by: bag)
        
        tableView.rx.itemDeleted.subscribe(onNext:{ [weak self] indexPath in
            guard let self = self else { return }
            //self.viewModel.deleteUser(indexPath: indexPath)
        }).disposed(by: bag)
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            let alert = UIAlertController(title: "Note", message: "Edit Note", preferredStyle: .alert)
            alert.addTextField { texfield in
                
            }
            alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
                let textField = alert.textFields![0] as UITextField
                //self.viewModel.editUser(title: textField.text ?? "", indexPath: indexPath)
            }))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }).disposed(by: bag)
        
        
    }
}

