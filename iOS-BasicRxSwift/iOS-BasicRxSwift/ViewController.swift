//
//  ViewController.swift
//  iOS-BasicRxSwift
//
//  Created by Jack Wong on 2019/01/08.
//  Copyright © 2019 Jack Wong. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class ViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    @IBOutlet private var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //runObserveString()
        //runObserveInterval()
        //runRepeatly()
        //runMap()
        runFilter()
    }

}

extension ViewController {
    private func runObserveString() {
        
        // Observable
        let observable = Observable<String>.create { (observer) -> Disposable in
            
                Thread.sleep(forTimeInterval: 5)
                observer.onNext("Hello World My Friend🌏")
                observer.onCompleted()
            
            return Disposables.create()
        }
        // Observer
        observable.subscribe(onNext: { (element) in
            self.textLabel.text = element
        }).disposed(by: disposeBag)
        observable.subscribe(onCompleted: {
            print("Bye My World")
        }).disposed(by: disposeBag)
    }
    
    private func runObserveInterval() {
        // Observable
        let observable = Observable<Int>.interval(0.3, scheduler: MainScheduler.instance)
        // Observer
        observable.subscribe { (element) in
            print("Interval", element)
        }.disposed(by: disposeBag)
    }
    
    private func runRepeatly() {
        let observable = Observable<String>.repeatElement("Good Weather🌞")
        observable.subscribe(onNext: { (element) in
            print(element)
        }).disposed(by: disposeBag)
    }
    
    // Map
    private func runMap() {
        let observable = Observable<Int>.create { (observer) -> Disposable in
            observer.onNext(1)
            return Disposables.create()
        }
        let boolObservable : Observable<Bool> = observable.map {(element) -> Bool in
            if element == 0 {
                return false
            } else {
                return true
            }
        }
        boolObservable.subscribe(onNext: { (boolElement) in
            print(boolElement)
        }).disposed(by: disposeBag)
    }
    
    // Filter
    private func runFilter() {
        let observable = Observable<String>.create { (observer) -> Disposable in
            observer.onNext("🐷")
            observer.onNext("🐔")
            observer.onNext("🐷")
            observer.onNext("🐷")
            observer.onNext("🐔")
            return Disposables.create()
        }
        observable.filter { (element) -> Bool in
            return element == "🐷"
            }.debounce(2, scheduler: MainScheduler.instance)
            .subscribe(onNext: { (filterElement) in
                print(filterElement)
            }).disposed(by: disposeBag)
        //debounce in this example just skips elements that aren’t at least 2 seconds apart. So if an element will be emitted after 1 second after the last one, it’ll be skipped, if it’s emitted 2.5 seconds after the last one, it’ll be emitted.
    }
}
