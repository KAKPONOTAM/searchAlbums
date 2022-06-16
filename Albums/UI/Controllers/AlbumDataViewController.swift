import UIKit

class AlbumDataViewController: UIViewController {
    private var tracks: TracksData?
    private var album: Album
    private lazy var albumTitleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var albumDataTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AlbumDataTableViewCell.self, forCellReuseIdentifier: AlbumDataTableViewCell.identifier)
        return tableView
    }()
    
    init(album: Album, titleImage: UIImage?) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
        self.albumTitleImageView.image = titleImage
        getTracksData()
    }
    
    required init?(coder: NSCoder) {
        album = Album(artistName: "", artworkUrl100: "", collectionId: 0, collectionName: "", country: "", primaryGenreName: "", releaseDate: "", trackCount: 0)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setupConstraints()
    }
    
    private func getTracksData() {
        NetworkManager.getAlbumTracks(collectionId: album.collectionId) { [weak self] tracks in
            self?.tracks = tracks
            self?.albumDataTableView.reloadData()
        }
    }
    
    private func addSubview() {
        view.addSubview(albumTitleImageView)
        view.addSubview(albumDataTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            albumTitleImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            albumTitleImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            albumTitleImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            albumTitleImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 / 3)
        ])
        
        NSLayoutConstraint.activate([
            albumDataTableView.topAnchor.constraint(equalTo: albumTitleImageView.bottomAnchor),
            albumDataTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            albumDataTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            albumDataTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension AlbumDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = AlbumDataSection.getSection(index: section)
        
        switch section {
        case .descriptionSection:
            return AlbumDataCellTypes.allCases.count
        case .trackNameSection:
            return tracks?.results.count ?? 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return AlbumDataSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.defaultHeightForRow
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let generalInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: AlbumDataTableViewCell.identifier, for: indexPath) as? AlbumDataTableViewCell else { return UITableViewCell() }
        let section = AlbumDataSection.getSection(index: indexPath.section)
        
        switch section {
        case .descriptionSection:
            let cell = AlbumDataCellTypes.getRow(index: indexPath.row)
            generalInfoTableViewCell.configureForFirstSection(with: cell, album: album)
        case .trackNameSection:
            guard let track = tracks?.results[indexPath.row] else { return UITableViewCell() }
            generalInfoTableViewCell.configureForSecondSection(with: track)
        }
        
        return generalInfoTableViewCell
    }
}
