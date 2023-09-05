//
//  ImagesListViewController.swift
//  Moments
//
//  Created by Alexey Ponomarev on 28.08.2023.
//

import UIKit

class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(
            top: 12,
            left: 0,
            bottom: 12,
            right: 0
        )
    }
    
    private func getGradien(cell: ImagesListCell) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = cell.gradientView.bounds
        gradient.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor, UIColor.ypBlack.cgColor]
        gradient.opacity = 0.5
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        
        return gradient
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let likeName = indexPath.row % 2 == 0 ? "heart" : "heart-filled"
        
        if (cell.gradient == nil) {
            let gradient = getGradien(cell: cell)

            cell.gradientView.roundCorners(corners: [.bottomLeft, .bottomRight],radius: 16)
            cell.gradientView.layer.insertSublayer(gradient, at: 0)
            cell.gradient = gradient
        }
        
       
        guard let likeImage = UIImage(named: likeName) else {
            print("Не удалось создать картинку для кнопки 'лайк' по индексу \(indexPath.row)")
            return
        }
        
        guard let previewImage = UIImage(named: photosName[indexPath.row]) else {
            print("Не удалось создать картинку для превью по индексу \(indexPath.row)")
            return
        }

        cell.preview.image =  previewImage
        cell.dateLabel.text = dateFormatter.string(from: Date())
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // создаем переиспользуемую ячейку, по заранее заданому идентификатору
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        )
        
        // пробуем привести ячейку к типу нашей кастомной ячейки
        guard let imageListCell = cell as? ImagesListCell else {
            // в случае не удачи возвращаем пустую ячейки и лоигруем это в консоль
            print("Ошибка создания ячейки")
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
    
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}

extension ImagesListViewController: UITableViewDataSource {
    
}
