//
//  MainViewController.swift
//  GCD
//
//  Created by Анатолий Фетелеу on 07.04.2023.
//

import UIKit
import Alamofire
import RxCocoa
import RxSwift


class GCDRxSwiftViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    
    let mainView = GCDRxSwiftView()
    let viewModel = GCDRxSwiftViewModel()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        title = "Responses"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        collectResponsesAndUpdate(for: 10)
    }
    
}

extension GCDRxSwiftViewController {
    struct Cells {
        static let mainCell = "mainCell"
    }
    
    private func configureTableView() {
        mainView.tableView.register(GCDRxSwiftTableViewCell.self, forCellReuseIdentifier: Cells.mainCell)
        
        viewModel.requestStatuses.bind(
            to: self.mainView.tableView.rx.items(
                cellIdentifier: Cells.mainCell,
                cellType: GCDRxSwiftTableViewCell.self)
            ) { row, item, cell in
                cell.requestStatusLabel.text = item?.description
            }.disposed(by: disposeBag)
    }
    
}

extension GCDRxSwiftViewController {
    private func makeRequestViaAlamofireFor(_ count: Int, group: DispatchGroup) {
        let url = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/todos")!)
        for n in 0..<count {
            group.enter()
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(5)) {
                AF.request(url).response { response in
                    guard let response = response.response else { return }
                    let statusCode = response.statusCode
                    self.viewModel.requestStatuses.accept(self.viewModel.requestStatuses.value + [statusCode])
                    debugPrint("[GCDRxSwift] Loaded \(n) request with status code: \(statusCode)")
                    group.leave()
                }
            }
        }
    }
    
    private func collectResponsesAndUpdate(for count: Int) {
        mainView.loaderView.startAnimating()
        let group = DispatchGroup()
        self.makeRequestViaAlamofireFor(count, group: group)
        group.notify(queue: .main) {
            self.mainView.tableView.reloadData()
            self.mainView.loaderView.stopAnimating()
        }
    }
    
}
