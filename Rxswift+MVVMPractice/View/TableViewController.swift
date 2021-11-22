import UIKit
import RxSwift
import RxCocoa

final class TableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    private let viewModel = ViewModel()
    private var eventsDataSource: [Event]?
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")

        // テキストフィールドに入力されたワードをviewModelにバインド
        self.textField.rx.text.orEmpty
            .filter { $0.count >= 1 }
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(viewModel.searchWord)
            .disposed(by: disposeBag)

        // viewModel.eventsはObservableで、イベント検索APIで取得したイベント情報が流れてきます。
        // イベントの検索結果のストリームを購読する。イベント情報が流れてきたらTableViewをリロードする
        viewModel.events // eventStreamがobservableになってる
            .subscribe(onNext: {[weak self] events in
                if let events = events {
                    self?.reloadData(events)
                }
            })
            .disposed(by: disposeBag)

    }
    private func reloadData(_ data: Events) {
            eventsDataSource = data.events
            tableView.reloadData()
        }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let event = eventsDataSource {
            return event.count
        }
        return 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let event = eventsDataSource![indexPath.row]
        cell.configure(event)
        return cell
    }
}
