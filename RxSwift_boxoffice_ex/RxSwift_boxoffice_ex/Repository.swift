//
//  Repository.swift
//  RxSwift_boxoffice_ex
//
//  Created by kokojong on 2022/05/29.
//

import Foundation
import RxSwift
import Moya

protocol RepositoryProtocol {
    // MARK: Subjects
    var getBoxOfficeListResult: ReplaySubject<[DailyBoxOffice]> {
        get
    }
    
    // MARK: API
    func getBoxOffice(date: String) -> Observable<[DailyBoxOffice]>
}

class Repository: RepositoryProtocol {
    var getBoxOfficeListResult =  ReplaySubject<[DailyBoxOffice]>.create(bufferSize: 1)
    
    static let shared = Repository()
    private var disposeBag = DisposeBag()
    private init() {}
    
    func getBoxOffice(date: String) -> Observable<[DailyBoxOffice]> {
        let observable = Observable<[DailyBoxOffice]>.create { observer -> Disposable in
            Service.getBoxOffice(date: date)
                .subscribe(onSuccess: { [weak self] item in
                    self?.getBoxOfficeListResult.onNext(item.boxOfficeResult.dailyBoxOfficeList)
                    observer.onNext(item.boxOfficeResult.dailyBoxOfficeList)
                    observer.onCompleted()
                }, onFailure: { error in
                    observer.onError(error)
                    observer.onCompleted()
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
        return observable
    }

    
}
