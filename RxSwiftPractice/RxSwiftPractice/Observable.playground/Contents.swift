import UIKit
import RxSwift

print("-------Just-------")
Observable<Int>.just(1)
    .subscribe(onNext : {
        print($0)
    })

print("-------Of1-------")
Observable<Int>.of(1, 2, 3, 4, 5)
    .subscribe(onNext: {
        print($0)
    }) // 값을 하나씩 순차적으로 표시

print("-------Of2-------")
Observable.of([1, 2, 3, 4, 5])
    .subscribe(onNext: {
        print($0)
    }) //array를 통으로 표시

print("-------From-------")
Observable.from([1, 2, 3, 4, 5]) //array만 다룬다
    .subscribe(onNext: {
        print($0)
    })// 값을 하나씩 순차적으로 표시
//observable은 정의일뿐 subscribe를 적어줘야 작동된다


print("-------subscribe1-------")
Observable.of(1,2,3)
    .subscribe {
        print($0)
}

print("-------subscribe2-------")
Observable.of(1,2,3)
    .subscribe {
        if let element = $0.element {
            print(element)
        }
}
print("-------subscribe3-------")
Observable.of(1,2,3)
    .subscribe ( onNext: {
        print($0)
    }
)
print("-------empty1-------")
Observable.empty()
    .subscribe ( onNext: {
        print($0)
    }
)

print("-------empty2-------")
Observable<Void>.empty()
    .subscribe ( onNext: {
        
    },
    onCompleted: {
        print("completed")
    })

print("-------never-------")
Observable<Void>.never()
    .debug("never")
    .subscribe ( onNext: {
        print($0)
    },
    onCompleted: {
        print("completed")
    })

print("-------Range-------")
Observable.range(start: 1, count: 9)
    .subscribe(onNext: {
        print("2 * \($0) = \(2 * $0)")
    })

print("-------dispose-------")
Observable.of(1,2,3)
    .subscribe ( onNext: {
        print($0)
    }
)
    .dispose() //구독취소

print("-------disposeBag-------")
let disposeBag = DisposeBag()

Observable.of(1,2,3)
    .subscribe ( onNext: {
        print($0)
    }
)
    .disposed(by: disposeBag)

print("-------create1-------")

Observable.create{ observer -> Disposable in
    
    observer.onNext(1)
    observer.onCompleted()
    observer.onNext(2)
    return Disposables.create()
}
.subscribe {
    print($0)
}
.disposed(by: disposeBag)

print("-------create2-------")
enum MyError: Error {
    case anError
}

Observable.create {
    observer -> Disposable in
    
    observer.onNext(1)
    observer.onError(MyError.anError)
    observer.onCompleted()
    observer.onNext(2)
    
    return Disposables.create()
}

.subscribe(
    onNext: {
        print($0)
    },
    onError: {
        print($0.localizedDescription)
    },
    onCompleted: {
        print("disposed")
    }
)
.disposed(by: disposeBag)

print("-------deffered-------")

var backed: Bool = false

let factory: Observable<String> = Observable.deferred {
    backed = !backed
    
    if backed {
        return Observable.of("1")
    } else {
        return Observable.of("2")
    }
}

for _ in 0...3 {
    factory.subscribe(onNext: {
        print($0)
    })
        .disposed(by: disposeBag)
}
