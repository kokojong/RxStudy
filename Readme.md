## 기본 개념 훑어보기

RxCocoa

- UIKit 및 Cocoa 개발을 지원하는 클래스를 가지고 있는 RxSwift 동반 라이브러리 → 다양한 UI구성 요소에 대한 reactive extension 기능을 추가하여 UI이벤트를 추가 가능

## Observable

- 여러 이벤트들을 생성(또는 emit)할 수 있는 대상을 가리킨다.
- 이를 간혹 Sequence라고 부르는데 이는 Observe한 결과 사건들을 sequence라고 한다(일련의 과정이라서 이렇게 부르나보다)
- next, completed, error로 구성된다.

### Observable.just()

- 오직 하나의 요소만을 포함하는 시퀀스를 생성한다. 단, 배열이 들어오게 되면 배열조차도 하나의 요소로 처리한다.

```swift
let justEx = Observable.just("just")
justEx.subscribe { just in
    print(just)
}
//        출력 결과
//        next(just)
//        completed
//        하나의 값만 emit하고 complete된다
```

### Observable.of()

- 타입 추론을 이용해서 시퀀스를 생성한다. just와 다른 점은 여러개의 값을 방출 할 수 있는 것이다.

```swift
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
```

### Observable.from()

- 배열의 값을 방출함

```swift
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
```

## Dispose

- Observable은 옵저버가 계속 구독하는 형태이기 때문에 memory leak이 발생가능하다. 그래서 완료후에는 dispose를 통해 메모리에서 해제를 해줘야한다.
- 즉, subscribe를 취소하는 것이다.
- DisposeBag는 dispose를 할 객체를 담는 가방이다. 즉, 여러가지 Observable 객체들을 담아서 dispose가 가능하다.

```swift
let disposeBag = DisposeBag()
        
Observable.of("a","b","c")
    .subscribe {
        print($0)
    }.disposed(by: disposeBag)
//        next(a)
//        next(b)
//        next(c)
//        completed
```

### Observable.create()

- 클로저 형식이며 다양한 값(OnNext, onCompleted, onError 등)을 생성할 수 있다.

```swift
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
//        3보다 전에 Completed가 되기 때문에 3은 나타나지 않는다.
```
