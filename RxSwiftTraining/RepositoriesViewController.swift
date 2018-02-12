//
//  ViewController.swift
//  RxSwiftTraining
//
//  Created by Nguyen Dinh Dung on 2018/02/11.
//  Copyright © 2018年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import ObjectMapper
import RxAlamofire
import RxCocoa
import RxSwift

class RepositoriesViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    var repositoryNetworkModel: RepositoryNetworkModel!
    
    var rx_searchBarText: Observable<String> {
        return searchBar.rx.text
            .filter { ($0?.count)! > 0 }
            .map{$0!}
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
    }

    func setupRx() {
        repositoryNetworkModel = RepositoryNetworkModel(withNameObservable: rx_searchBarText)
        
        repositoryNetworkModel
            .rx_repositories
            .drive(tableView.rx.items) {
                (tblView, rowNumber, repository) in
                let cell = tblView.dequeueReusableCell(withIdentifier :"repositoryCell", for: IndexPath(row: rowNumber, section: 0))
                cell.textLabel?.text = repository.name
                
                return cell
                }
            .addDisposableTo(disposeBag)
    
        repositoryNetworkModel
            .rx_repositories
            .drive( onNext: { repositories in
                if repositories.count == 0 {
                    let alert = UIAlertController(title: ":(", message: "Can't find any repositories with this address", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    if self.navigationController?.visibleViewController is UIAlertController != true {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
            .addDisposableTo(disposeBag)
    }

}

