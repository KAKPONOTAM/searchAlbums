import UIKit

class UserDataTableViewCell: UITableViewCell {
    private let userGeneralInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addSubview() {
        contentView.addSubview(userGeneralInfoLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            userGeneralInfoLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            userGeneralInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            userGeneralInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            userGeneralInfoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with cellTypes: RegistrationCellType) {
        guard let userData = UserDataManager.receiveResults() else { return }
        switch cellTypes {
        case .name:
            userGeneralInfoLabel.text = userData.name
        case .surname:
            userGeneralInfoLabel.text = userData.surname
        case .age:
            userGeneralInfoLabel.text = userData.age
        case .phoneNumber:
            userGeneralInfoLabel.text = userData.phoneNumber
        case .email:
            userGeneralInfoLabel.text = userData.email
        case .password:
            userGeneralInfoLabel.text = userData.password
        default:
            break
        }
    }
}
