import UIKit

class TableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    private var eventsDataSource: [Event]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    private func reloadData(_ data:Events) {
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
