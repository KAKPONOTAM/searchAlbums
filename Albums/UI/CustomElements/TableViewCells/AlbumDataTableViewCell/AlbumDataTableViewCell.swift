import UIKit

class AlbumDataTableViewCell: UITableViewCell {
    private let albumDetailInfoLabel: UILabel = {
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
        contentView.addSubview(albumDetailInfoLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            albumDetailInfoLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            albumDetailInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            albumDetailInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            albumDetailInfoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureForFirstSection(with cellTypes: AlbumDataCellTypes, album: Album) {
        switch cellTypes {
        case .albumName:
            albumDetailInfoLabel.text = album.collectionName
        case .groupName:
            albumDetailInfoLabel.text = album.artistName
        case .albumReleaseDate:
            let correctReleaseDateFormat = Date.changeStringDateFormat(releaseDate: album.releaseDate)
            albumDetailInfoLabel.text = correctReleaseDateFormat
        }
    }
    
    func configureForSecondSection(with track: Track) {
        albumDetailInfoLabel.text = track.trackName ?? "unowned track"
    }
}
