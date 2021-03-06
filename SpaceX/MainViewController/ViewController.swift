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


class ViewController: UIViewController ,UITableViewDelegate{
    
    private var dataSource: UITableViewDiffableDataSource<ViewController.Section, Launches>!
    private var viewModel = ViewModel()
    private var bag = DisposeBag()
    var load: Bool!

    private lazy var tableView : UITableView = {
        let tv = UITableView(frame: self.view.frame, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()
    
    enum Section {
      case main
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        self.configureDataSource()
        self.viewModel.loadLaunches()
        self.setObservers()
    }
    
}


//MARK: TableView
extension ViewController{
    private func configureDataSource() {
        tableView.delegate = self
        dataSource = UITableViewDiffableDataSource<ViewController.Section, Launches>(tableView: tableView, cellProvider: { (tableView, indexPath, value) -> UITableViewCell? in
          let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel!.text = value.missionName
            return cell
        })
        dataSource.defaultRowAnimation = .fade
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
            self.tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailViewController(viewModel: self.viewModel.data[indexPath.row])
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true, completion: nil)
        
    }
}
extension ViewController{
    private func setObservers(){
        viewModel.canLoadMore.subscribe( onNext: { [weak self] canLoadMore in
            self?.load = canLoadMore
            var snapshot = NSDiffableDataSourceSnapshot<ViewController.Section, Launches>()
            snapshot.appendSections([.main])
            snapshot.appendItems(self!.viewModel.data)
            self?.dataSource.apply(snapshot, animatingDifferences: false)
            
        }).disposed(by: bag)
    }
}


//MARK: Pagination Signal
extension ViewController{
    //load new data in the end of the tableView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pos = scrollView.contentOffset.y
        if self.load{
            if pos > tableView.contentSize.height-50 - scrollView.frame.size.height{
                self.viewModel.updateCurserPosition()
                self.viewModel.loadLaunches()
                debugPrint("Pagination Request")
                viewModel.hasLoaded.onNext(false)
            }
        }
    }
}
