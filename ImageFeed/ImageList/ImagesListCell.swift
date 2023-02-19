
import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseID: String = String(describing: ImagesListCell.self)
    private let dateLabel = UILabel()
    private let cellImage = UIImageView()
    private let likeButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cellImage)
        contentView.addSubview(dateLabel)
        contentView.addSubview(likeButton)
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .white
        cellImage.layer.masksToBounds = true
        cellImage.layer.cornerRadius = 16
        backgroundColor = .clear
        NSLayoutConstraint.activate([
            cellImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabel.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: -8),
            likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor, constant: 8),
            likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: ImageCellModel) {
        cellImage.image = model.image
        dateLabel.text = model.date
        let likeImage = model.isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
}
