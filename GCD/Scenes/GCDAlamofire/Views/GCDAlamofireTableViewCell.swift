//
//  MainTableViewCell.swift
//  GCD
//
//  Created by Анатолий Фетелеу on 07.04.2023.
//

import UIKit

class GCDAlamofireTableViewCell: UITableViewCell {

    var requestStatusLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        setupViews()
        setupConstraints()
    }
    
    private func setup() {
        
    }
    
    private func setupViews() {
        addSubview(requestStatusLabel)
    }
    
    private func setupConstraints() {
        requestStatusLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            
        }
    }
}
