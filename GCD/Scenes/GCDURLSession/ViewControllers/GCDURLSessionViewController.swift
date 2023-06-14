//
//  MainViewController.swift
//  GCD
//
//  Created by Анатолий Фетелеу on 07.04.2023.
//

import UIKit


class GCDURLSessionViewController: UIViewController {
    
    let mainView = GCDURLSessionView()
    let viewModel = GCDURLSessionViewModel()
    
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

extension GCDURLSessionViewController: UITableViewDelegate, UITableViewDataSource {
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

extension GCDURLSessionViewController {
    private func makeRequestViaURLSessionFor(_ count: Int) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
        let urlRequest = URLRequest(url: url)
        let urlSession = URLSession.shared
        
        let queue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
        let group = DispatchGroup()
                
        queue.async(group: group) {
            for n in 1..<count {
                group.enter()
                urlSession.dataTask(with: urlRequest) { data, response, error in
                    let httpResponse = response as? HTTPURLResponse
                    let statusCode = httpResponse?.statusCode
                    self.viewModel.requestStatuses.append(try! Double("\(statusCode!).\(n)", format: .number))
                     debugPrint("[GCDURLSession] Loaded request \(n) with status code: \(statusCode ?? 500)")
                    group.leave()
                }.resume()
            }
        }
        
        group.notify(queue: queue) {
            DispatchQueue.main.async {
                let sortedRequestStatuses = self.viewModel.requestStatuses.sorted(by: { a, b in
                    guard let a = a else { return false }
                    guard let b = b else { return false }
                    return a < b
                })
                self.viewModel.requestStatuses = sortedRequestStatuses
                self.mainView.tableView.reloadData()
                self.mainView.loaderView.stopAnimating()
            }
        }
    }
    
    private func collectResponsesAndUpdate(for count: Int) {
        mainView.loaderView.startAnimating()
        self.makeRequestViaURLSessionFor(count)
    }
    
}
