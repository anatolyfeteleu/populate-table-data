//
//  MainView.swift
//  GCD
//
//  Created by Анатолий Фетелеу on 07.04.2023.
//

import UIKit
import SnapKit


class GCDRxSwiftView: UIView {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .clear
        tableView.rowHeight = 35
        return tableView
    }()
    
    let loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        return loader
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .white
    }
    
    private func setupViews() {
        addSubview(tableView)
        addSubview(loaderView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.topMargin.equalToSuperview().offset(70)
            $0.left.equalToSuperview().offset(35)
            $0.right.equalToSuperview().inset(35)
            $0.bottomMargin.equalToSuperview().inset(70)
            $0.centerX.equalToSuperview()
        }
        loaderView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
