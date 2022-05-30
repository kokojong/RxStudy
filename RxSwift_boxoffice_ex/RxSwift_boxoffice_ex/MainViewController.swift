//
//  ViewController.swift
//  RxSwift_boxoffice_ex
//
//  Created by kokojong on 2022/05/25.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources


class MainViewController: UIViewController {
    @IBOutlet weak var mainTF: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var disposeBag = DisposeBag()
    var viewModel = ViewModel()
    var input = ViewModel.Input(searchText: .create(bufferSize: 1))
    lazy var ouput = viewModel.transform(input: input)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
        bindRX()
    }
    
    private func setUI() {
        tableView.register(UINib(nibName: movieTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: movieTableViewCell.identifier)
        
    }
    
    private func bindRX() {
        searchBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.input.searchText.onNext(self.mainTF.text ?? "")
            }).disposed(by: disposeBag)
        
        
        ouput.boxOfficeList.bind(to: tableView.rx.items(cellIdentifier: movieTableViewCell.identifier, cellType: movieTableViewCell.self)) { index, element, cell in
                
            cell.numberLbl.text = element.rank
            cell.titleLbl.text = element.movieNm
            cell.dateLbl.text = element.openDt
            cell.audLbl.text = element.audiAcc
            
            
        }.disposed(by: disposeBag)
        
    }


}

