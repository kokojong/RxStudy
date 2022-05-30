//
//  ViewModel.swift
//  RxSwift_boxoffice_ex
//
//  Created by kokojong on 2022/05/25.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel {
    private let disposeBag = DisposeBag()
    private let repo = Repository.shared
    
    func transform(input: Input) -> Output {
        let boxOfficeList = ReplaySubject<[DailyBoxOffice]>.create(bufferSize: 1)
        
        Repository.shared.getBoxOfficeListResult.subscribe(onNext: { [weak self] res in
            print("res",res)
            boxOfficeList.onNext(res)
        }).disposed(by: disposeBag)
        
        input.searchText
            .flatMap { [weak self] text -> Observable<[DailyBoxOffice]> in
                guard let self = self else {
                    return Observable.empty()
                }
                let dailyBoxOfficeList =  self.repo.getBoxOffice(date: text)
                return dailyBoxOfficeList
            }
            .subscribe(onNext: { list in
                print("list",list)
                boxOfficeList.onNext(list)
            })
            .disposed(by: disposeBag)
        
        return Output(boxOfficeList: boxOfficeList)
    }
}

extension ViewModel {
    struct Input {
        var searchText: ReplaySubject<String>
    }

    struct Output {
        var boxOfficeList: ReplaySubject<[DailyBoxOffice]>
    }
}

