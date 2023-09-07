//
//  ImagesListCell.swift
//  Moments
//
//  Created by Alexey Ponomarev on 03.09.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    var gradient: CAGradientLayer? = nil
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var preview: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
}
