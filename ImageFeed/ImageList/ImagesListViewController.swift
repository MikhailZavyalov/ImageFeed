
import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    let imagesListService = ImagesListService()
    
    
    // MARK: - Outlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        guard let token = OAuth2TokenStorage.token else { return }
        imagesListService.fetchPhotosNextPage(token: token) { _ in
            self.tableView.reloadData()
        }
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            viewController.imageURL = imagesListService.photos[indexPath.row].largeImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - Extensions
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imagesListService.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imagesListCell = cell as? ImagesListCell else {
            return cell
        }
        
        configCell(for: imagesListCell, with: indexPath)
        
        return imagesListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = imagesListService.photos[indexPath.row]
        let imageURL = photo.thumbImageURL
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: imageURL)
        cell.dateLabel.text = dateFormatter.string(from: photo.createdAt)
        let likeImage = photo.isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cell.likeButton.setImage(likeImage, for: .normal)
        cell.onLikeButtonTapped = { [self] in
            guard let token = OAuth2TokenStorage.token else { return }
            UIBlockingProgressHUD.show()
            imagesListService.changeLike(token: token, photo: photo) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    UIBlockingProgressHUD.dismiss()
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                case .failure:
                    break
                }
            }
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageSize = imagesListService.photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = imageSize.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        guard indexPath.row + 1 == imagesListService.photos.count else { return }
        guard let token = OAuth2TokenStorage.token else { return }
        let oldPhotosCount = imagesListService.photos.count
        
        imagesListService.fetchPhotosNextPage(token: token) { result in
            switch result {
            case .success(let photos):
                guard !photos.isEmpty else {
                    return
                }
                let newPhotosCount = oldPhotosCount + photos.count
                
                var newIndexes: [IndexPath] = []
                for i in oldPhotosCount..<newPhotosCount {
                    newIndexes.append(IndexPath(row: i, section: 0))
                }

                tableView.performBatchUpdates {
                    tableView.insertRows(at: newIndexes, with: .automatic)
                } completion: { _ in }
            case .failure(let error):
                print(error)
            }
        }
    }
}
