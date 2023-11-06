//
//  ImagesListCell.swift
//  Moments
//
//  Created by Alexey Ponomarev on 03.09.2023.
//

import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTappedLikeButton(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    var gradient: CAGradientLayer? = nil
    let imageListService = ImagesListService.shared
    weak var delegate: ImagesListCellDelegate?
    private enum Keys {
        static let heart = "heart"
        static let heartFilled = "heart-filled"
    }

    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var preview: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        preview.kf.cancelDownloadTask()
    }
    
    @IBAction func didTappedLikeButton(_ sender: Any) {
        delegate?.imageListCellDidTappedLikeButton(self)
    }
    
    func setLike(_ isLiked: Bool) {
        let likeImageText = isLiked ? Keys.heartFilled : Keys.heart
        guard let likeImage = UIImage(named: likeImageText) else { return }
        likeButton.setImage(likeImage, for: .normal)
    }
}
