//
//  MainViewController.swift
//  GCD
//
//  Created by Анатолий Фетелеу on 07.04.2023.
//

import UIKit
import Alamofire

class GCDAlamofireViewController: UIViewController {
    
    let mainView = GCDAlamofireView()
    let viewModel = GCDAlamofireViewModel()
    
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

extension GCDAlamofireViewController: UITableViewDelegate, UITableViewDataSource {
    enum Cells: String {
        case mainCell
    }
    
    // How many rows do I show?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.requestStatuses.count
    }
    
    // What cells am I showing?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.mainCell.rawValue) as! GCDAlamofireTableViewCell
        let requestStatus = viewModel.requestStatuses[indexPath.row]
        cell.requestStatusLabel.text = requestStatus?.description
        return cell
    }
    
    func configureTableView() {
        mainView.tableView.register(GCDAlamofireTableViewCell.self, forCellReuseIdentifier: Cells.mainCell.rawValue)
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
}

extension GCDAlamofireViewController {
    private func makeRequestViaAlamofireFor(_ count: Int, group: DispatchGroup) {
        let url = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/todos")!)
        for n in 0..<count {
            AF.request(url).response { response in
                guard let response = response.response else { return }
                let statusCode = response.statusCode
                self.viewModel.requestStatuses.append(statusCode)
                debugPrint("[GCDAlamofire] Loaded request \(n) with status code: \(statusCode)")
                group.leave()
            }
            group.enter()
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
