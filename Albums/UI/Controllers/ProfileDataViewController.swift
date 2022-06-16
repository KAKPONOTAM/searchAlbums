import UIKit

class ProfileDataViewController: UIViewController {
    private lazy var userDataTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserDataTableViewCell.self, forCellReuseIdentifier: UserDataTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        setupConstraints()
    }
    
    private func addSubview() {
        view.addSubview(userDataTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            userDataTableView.topAnchor.constraint(equalTo: view.topAnchor),
            userDataTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userDataTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userDataTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ProfileDataViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RegistrationCellType.getSectionAmounts() - 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.defaultHeightForRow
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserDataTableViewCell.identifier, for: indexPath) as? UserDataTableViewCell else { return UITableViewCell() }
        let cellType = RegistrationCellType.getRow(from: indexPath.row)
        cell.configure(with: cellType)
        return cell
    }
}
