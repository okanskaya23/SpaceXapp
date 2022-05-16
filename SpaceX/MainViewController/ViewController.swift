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
        self.bindTableView()
        self.viewModel.loadLaunches()
    }
    
}


//MARK: TableView binding
extension ViewController{
    func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: bag)

        //MARK: Data Binding
        viewModel.data
            .bind(to: tableView.rx.items(cellIdentifier: CustomRocketCell.cellIdentifier,cellType: CustomRocketCell.self)){  row, data, cell in
                cell.title?.text = data.missionName ?? ""
            }.disposed(by: bag)

        //MARK: Didselect
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            self.tableView.deselectRow(at: indexPath, animated: true)
            guard let model = try? self.viewModel.data.value() else { return }
            let vc = DetailViewController(viewModel: model[indexPath.row])
            vc.modalPresentationStyle = .popover
            self.present(vc, animated: true, completion: nil)

        }).disposed(by: bag)
    }
}


//MARK: Pagination Signal
extension ViewController{
    //load new data in the end of the tableView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pos = scrollView.contentOffset.y
        if viewModel.canLoadMore(){
            if pos > tableView.contentSize.height-50 - scrollView.frame.size.height{
                self.viewModel.updateCurserPosition()
                self.viewModel.loadLaunches()
                debugPrint("Pagination Request")
                viewModel.toggeleHasLoaded()
            }
        }
    }
}


