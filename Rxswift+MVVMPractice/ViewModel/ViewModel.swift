import Foundation
import UIKit
import RxSwift
import RxCocoa

final class ViewModel {
    private let disposeBag = DisposeBag()
   //　プロパティに持つ
    private let searchWordStream = PublishSubject<String>()
    private let eventsStream = PublishSubject<Events?>() // イベント検索APIで取得した情報がeventsStreamに流れてくる
    private let startedAtStream = PublishSubject<String>()
    private let formattedDateStream = PublishSubject<String>()

    init() { // Observerとして公開しているストリームにViewから値が入力された時（通知された時？）、どのような処理を行うか定義
        // Viewの入力から最新のObservableを生成してsubscribeする
        searchWordStream.flatMapLatest { word -> Observable<Events?> in
                    print("searchWord:\(word)")
                    let model = ApiModel()
            return  model.searchEvents(word: word).catchAndReturn(nil)
                }
                .subscribe(eventsStream)
                .disposed(by: disposeBag)
    }
}

// MARK: - Observer　定義　外部に公開
extension ViewModel {
    var searchWord: AnyObserver<(String)> {
        searchWordStream.asObserver()
    }
    var startedAt: AnyObserver<(String)> {
        startedAtStream.asObserver()
    }
}
// MARK: - Observable　定義　外部に公開
extension ViewModel {
    var events: Observable<Events?> {
        return eventsStream.asObservable() // View側でeventsStreamを購読してイベント情報を表示
    }
    var formattedDate: Observable<String> {
        return formattedDateStream.asObservable()
    }
}
