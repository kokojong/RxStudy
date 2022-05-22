//
//  RepoTableViewCell.swift
//  RxSwift_Github_ex
//
//  Created by kokojong on 2022/05/15.
//

import UIKit

class RepoTableViewCell: UITableViewCell {
    
    static let identifier = "RepoTableViewCell"
    
    let titleLb = UILabel()
    let descriptionLb = UILabel()
    let starLb = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(titleLb)
        addSubview(descriptionLb)
        addSubview(starLb)
        
        backgroundColor = .brown
        
        titleLb.tintColor = .red
        titleLb.text = "title"
        descriptionLb.tintColor = .blue
        descriptionLb.text = "description"
        starLb.tintColor = .yellow
        starLb.text = "star"
        
        titleLb.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8)
        }
        
        descriptionLb.snp.makeConstraints { make in
            make.top.equalTo(titleLb.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        starLb.snp.makeConstraints { make in
            make.top.equalTo(descriptionLb.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(8)
        }
    }

}
