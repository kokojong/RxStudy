//
//  MainViewController.swift
//  RxSwiftStudy
//
//  Created by kokojong on 2022/04/07.
//

import SnapKit
import UIKit
import RxCocoa
import RxSwift

class MainViewController: UIViewController {
    
    let testSwitch = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        testSwitch.backgroundColor = .blue
        
        view.addSubview(testSwitch)
        testSwitch.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        testSwitch.rx.isOn.subscribe { isOn in
            print(isOn)
        } onError: { error in
            print(error)
        } onCompleted: {
            print("oncompleted")
        } onDisposed: {
            print("disposed")
        }

        let justEx = Observable.just("just")
        justEx.subscribe { just in
            print(just)
        }
//        출력 결과
//        next(just)
//        completed
//        하나의 값만 emit하고 complete된다

        let ofEx = Observable.of("of1","of2","of3")
        ofEx.subscribe { of in
            print(of)
        }
//        next(of1)
//        next(of2)
//        next(of3)
//        completed
        
        let ofEx2 = Observable.of(["of1","of2","of3"],["of11","of22","of33"])
        ofEx2.subscribe { of in
            print(of)
        }
//        next(["of1", "of2", "of3"])
//        next(["of11", "of22", "of33"])
//        completed
        
        let fromEx = Observable.from(["from1","from2","from3"])
        fromEx.subscribe { from in
            print(from)
        }
//        next(from1)
//        next(from2)
//        next(from3)
//        completed
        
        fromEx.subscribe { from in
            if let element = from.element {
                print(element)
            }
        }
//        from1
//        from2
//        from3

        let disposeBag = DisposeBag()
        
        Observable.of("a","b","c")
            .subscribe {
                print($0)
            }.disposed(by: disposeBag)
//        next(a)
//        next(b)
//        next(c)
//        completed
            
        Observable<String>.create { observer in
            observer.onNext("1")
            observer.onNext("2")
            observer.onCompleted()
            observer.onNext("3")
            
            return Disposables.create()
        }.subscribe {
            print("next - \($0)")
        } onError: {
            print("error - \($0)")
        } onCompleted: {
            print("completed")
        } onDisposed: {
            print("disposed")
        }.disposed(by: disposeBag)
//        next - 1
//        next - 2
//        completed
//        disposed
        
        fromEx.subscribe(<#T##on: (Event<String>) -> Void##(Event<String>) -> Void#>)
        
    }
    

}
