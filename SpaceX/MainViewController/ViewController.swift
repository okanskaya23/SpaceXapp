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



class ViewController: UIViewController ,UITableViewDelegate{
    
    private var viewModel = ViewModel()
    private var bag = DisposeBag()
    lazy var tableView : UITableView = {
        let tv = UITableView(frame: self.view.frame, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(CustomRocketCell.nib(), forCellReuseIdentifier: CustomRocketCell.cellIdentifier)
        return tv
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        bindTableView()
        self.viewModel.loadLaunches()
        
        
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
                self.viewModel.loadLaunches()
                print("Pagination Request")
                viewModel.hasLoaded = true
            }
        }
    }
}
extension ViewController{
    func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: bag)


        viewModel.data
            .bind(to: tableView.rx.items(cellIdentifier: CustomRocketCell.cellIdentifier,cellType: CustomRocketCell.self)){  row, data, cell in
                cell.title?.text = data.missionName
            }.disposed(by: bag)

        
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            self.tableView.deselectRow(at: indexPath, animated: true)
            let vc = DetailViewController()
            vc.modalPresentationStyle = .popover
            vc.detailDescription = UITextView()
            self.present(vc, animated: true, completion: nil)
            guard var model = try? self.viewModel.data.value() else { return }
            vc.detailDescription.text = model[indexPath.row].details == nil ? "Empty Descripton" : model[indexPath.row].details
        }).disposed(by: bag)

        
        
    }
}

