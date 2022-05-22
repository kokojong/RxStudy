//
//  MainView.swift
//  RxSwift_Github_ex
//
//  Created by kokojong on 2022/05/15.
//

import UIKit
import SnapKit

class MainView: UIView {
    
    let headerView = UIView()
    let titleLb = UILabel()
    let loginBtn = UIButton()
    
    let seachBarView = UIView()
    let searchTF = UITextField()
    let searchBtn = UIButton()
    
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        attributeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.addSubview(headerView)
        headerView.addSubview(titleLb)
        headerView.addSubview(loginBtn)
        
        self.addSubview(seachBarView)
        seachBarView.addSubview(searchTF)
        seachBarView.addSubview(searchBtn)
        
        self.addSubview(tableView)
        
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        titleLb.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        loginBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
        
        seachBarView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        searchTF.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.trailing.equalTo(searchBtn)
        }
        
        searchBtn.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalTo(80)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(seachBarView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func attributeUI() {
        headerView.backgroundColor = .black
        titleLb.text = "GitHub"
        titleLb.textColor = .white
        titleLb.font = .boldSystemFont(ofSize: 20)
        loginBtn.setTitle("로그인", for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        
        seachBarView.backgroundColor = .yellow
        searchBtn.backgroundColor = .black
        
        searchBtn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchBtn.tintColor = .white
        
        tableView.backgroundColor = .lightGray
        tableView.rowHeight = 100
        
    }
    
}
