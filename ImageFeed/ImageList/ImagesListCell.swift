
import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    var onLikeButtonTapped: (() -> Void)?
    
    @IBAction func tapOnLikeButton(_ sender: Any) {
        onLikeButtonTapped?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onLikeButtonTapped = nil
        // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        cellImage.kf.cancelDownloadTask()
    }
}
