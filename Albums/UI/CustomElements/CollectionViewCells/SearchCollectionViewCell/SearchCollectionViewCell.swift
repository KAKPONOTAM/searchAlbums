import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    private lazy var albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = self.layer.cornerRadius
        return imageView
    }()
    
    private let albumTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let groupNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let songsAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray5
        layer.cornerRadius = 10
        addSubview()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        albumImageView.image = nil
        groupNameLabel.text = nil
        songsAmountLabel.text = nil
        albumTitleLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addSubview() {
        contentView.addSubview(albumImageView)
        contentView.addSubview(groupNameLabel)
        contentView.addSubview(albumTitleLabel)
        contentView.addSubview(songsAmountLabel)
    }
    
    private func setupConstraints() {
        let offset: CGFloat = 5
        NSLayoutConstraint.activate([
            albumImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            albumImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            albumImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            albumImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1 / 2)
        ])
        
        NSLayoutConstraint.activate([
            albumTitleLabel.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: offset),
            albumTitleLabel.leadingAnchor.constraint(equalTo: albumImageView.leadingAnchor),
            albumTitleLabel.trailingAnchor.constraint(equalTo: albumImageView.trailingAnchor),
            albumTitleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1 / 8)
        ])
        
        NSLayoutConstraint.activate([
            groupNameLabel.topAnchor.constraint(equalTo: albumTitleLabel.bottomAnchor, constant: offset),
            groupNameLabel.leadingAnchor.constraint(equalTo: albumTitleLabel.leadingAnchor),
            groupNameLabel.trailingAnchor.constraint(equalTo: albumTitleLabel.trailingAnchor),
            groupNameLabel.heightAnchor.constraint(equalTo: albumTitleLabel.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            songsAmountLabel.topAnchor.constraint(equalTo: groupNameLabel.bottomAnchor, constant: offset),
            songsAmountLabel.leadingAnchor.constraint(equalTo: groupNameLabel.leadingAnchor),
            songsAmountLabel.trailingAnchor.constraint(equalTo: groupNameLabel.trailingAnchor),
            songsAmountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -offset)
        ])
    }
    
    func configure(with album: Album, albumImage: UIImage) {
        albumTitleLabel.text = album.collectionName
        groupNameLabel.text = album.artistName
        songsAmountLabel.text = "\(album.trackCount)"
        albumImageView.image = albumImage
    }
}
