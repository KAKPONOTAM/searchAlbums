import UIKit
protocol FinishRegistrationTableViewCellDelegate: AnyObject {
    func registrationButtonTapped()
}

class FinishRegistrationTableViewCell: UITableViewCell {
    weak var delegate: FinishRegistrationTableViewCellDelegate?
    private lazy var finishRegistrationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false 
        button.backgroundColor = .black
        button.setTitle(Titles.getTitle(from: .finishRegistrationButtonTitle), for: .normal)
        button.addTarget(self, action: #selector(registrationTapped), for: .touchUpInside)
        return button
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
        contentView.addSubview(finishRegistrationButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            finishRegistrationButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            finishRegistrationButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            finishRegistrationButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            finishRegistrationButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    @objc private func registrationTapped() {
        delegate?.registrationButtonTapped()
    }
}
