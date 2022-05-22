//
//  MainViewController.swift
//  RxSwift_Github_ex
//
//  Created by kokojong on 2022/05/15.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import Alamofire

class MainViewController: UIViewController {

    let mainView = MainView()
    
    let disposeBag = DisposeBag()
    
    let textSubject: ReplaySubject<String> = ReplaySubject.create(bufferSize: 1)
    
    let repoSubject: ReplaySubject<Repositories> = ReplaySubject.create(bufferSize: 1)
    
    let itemsSubject: ReplaySubject<[Item]> = ReplaySubject.create(bufferSize: 1)
    
    let baseUrl = "https://api.github.com/search/repositories"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        view.addSubview(mainView)
        
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        mainView.tableView.register(RepoTableViewCell.self, forCellReuseIdentifier: RepoTableViewCell.identifier)

        
        mainView.searchTF.rx
            .text
            .orEmpty
            .map { $0 }
            .bind(to: textSubject)
            .disposed(by: disposeBag)
        
        
        textSubject.bind { txt in
            print("textSubject:",txt)
        }.disposed(by: disposeBag)
        
        textSubject
            .map{ self.checkValid(txt: $0) }
            .subscribe(onNext: { valid in
                self.mainView.searchBtn.isEnabled = valid
            })
            .disposed(by: disposeBag)
      
        mainView.searchBtn.rx
            .tap
//            .asObservable()
//            .map { _ in
//                return mainView.searchTF.text ?? ""
//            }
            .asObservable()
            .map {
                [weak self] _ -> String in
                guard let self = self else { return "aaa" }
                return self.mainView.searchTF.text ?? ""
            }
//            .map{
//                return self.mainView.searchTF.text ?? ""
//            }
//            .flatMap({ _ -> Observable<String> in
//                return Observable.just(self.mainView.searchTF.text ?? "")
//            })
//            .withLatestFrom(mainView.searchTF.rx.text.orEmpty)
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
//            .subscribe(onNext: { [weak self] txt in
//                guard let self = self else { return }
//                print("tap")
//                self.searchRepo(txt: )
//            })
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                print($0)
                self.searchRepo(txt: $0)
            })
            .disposed(by: disposeBag)
        
        repoSubject
            .flatMap { repo -> Observable<[Item]> in
                return Observable.just(repo.items ?? [])
            }
            .asObservable()
            .subscribe(onNext: { [weak self] items in
                guard let self = self else { return }
                print("items:",
                      items)
                self.itemsSubject.onNext(items)
            })
            .disposed(by: disposeBag)
            
        
        itemsSubject
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: mainView.tableView.rx
            .items(cellIdentifier: RepoTableViewCell.identifier, cellType: RepoTableViewCell.self)) { idx, element, cell in
                print("element:",element)
                cell.titleLb.text = element.fullName
                cell.descriptionLb.text = element.description
                cell.starLb.text = "\(element.stargazersCount)"
                
            }
            .disposed(by: disposeBag)
            
    }
    
    func checkValid(txt: String) -> Bool {
        if txt.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    func searchRepo(txt: String) {
        
        let url = self.baseUrl + "?q=\(txt)"
        
        let header: HTTPHeaders = [ "Content-Type": "application/json" ]
        
        AF.request(url, method: .get, headers: header)
            .responseDecodable(of: Repositories.self) { response in
                
                self.repoSubject.onNext(response.value ?? Repositories(totalCount: 1, incompleteResults: true, items: [Item(fullName: "검색결과", description: "가", stargazersCount: 0)]))
                
                self.mainView.tableView.reloadData()
                
                
                
                
            }
        

        
    }

}

