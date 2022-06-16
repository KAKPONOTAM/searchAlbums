import UIKit
class SearchAlbumsViewController: UIViewController {
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private var albums: [Album] = []
    
    private lazy var searchAlbumsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setupConstraints()
        setupNavigationController()
    }
    
    private func setupNavigationController() {
        guard let userData = UserDataManager.receiveResults() else { return }
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemGray6
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = "\(userData.name + " " + userData.surname)"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: ModuleImages.getImage(by: .profileImage), style: .done, target: self, action: #selector(profileButtonTapped))
        
        let signOutBarButton = UIBarButtonItem(image: nil, style: .done, target: self, action: #selector(signOutButtonTapped))
        signOutBarButton.title = Titles.getTitle(from: .signOutButtonTitle)
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = signOutBarButton
        
        navigationController?.navigationBar.tintColor = .black
        navigationItem.searchController = searchController
    }
    
    @objc private func profileButtonTapped() {
        let profileViewController = ProfileDataViewController()
        present(profileViewController, animated: true)
    }
    
    @objc private func signOutButtonTapped() {
        createAndPresentAlert(title: Titles.getTitle(from: .signOutAlertTitle), message: nil, handlerForOkButton: { _ in
            UIView.animate(withDuration: 1) {
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = .clear
                self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
                self.view.alpha = 0
            } completion: { _ in
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let navigationController = UINavigationController(rootViewController: AuthorizationViewController())
                appDelegate.window? = UIWindow(frame: UIScreen.main.bounds)
                appDelegate.window?.rootViewController = navigationController
                appDelegate.window?.makeKeyAndVisible()
            }

        }, handlerForCancel: nil, titleForCancel: Titles.getTitle(from: .cancelActionTitle))
    }
    
    private func addSubview() {
        view.addSubview(searchAlbumsCollectionView)
    }
    
    private func setupConstraints() {
        let offset: CGFloat = 50
        NSLayoutConstraint.activate([
            searchAlbumsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: offset / 5),
            searchAlbumsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset / 10),
            searchAlbumsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset / 10),
            searchAlbumsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SearchAlbumsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        let album = albums[indexPath.item]

        NetworkManager.getAlbumImageFromData(urlString: album.artworkUrl100) { albumImage in
            cell.configure(with: album, albumImage: albumImage)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 2) - 5
        let height = collectionView.frame.width / 2
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = albums[indexPath.item]
        NetworkManager.getAlbumImageFromData(urlString: album.artworkUrl100) { [weak self] albuImage in
            let albumDataViewController = AlbumDataViewController(album: album, titleImage: albuImage)
            albumDataViewController.modalPresentationStyle = .overFullScreen
            self?.navigationController?.pushViewController(albumDataViewController, animated: true)
        }
    }
}

extension SearchAlbumsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            NetworkManager.getAlbums(searchAlbum: searchText) { [weak self] albumData in
                let sortedAlbums = albumData.results.sorted(by: { $0.artistName < $1.artistName })
                self?.albums = sortedAlbums
                self?.searchAlbumsCollectionView.reloadData()
            }
        }
    }
}

