//
//  ImagesListViewController.swift
//  Moments
//
//  Created by Alexey Ponomarev on 28.08.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {
    private let imagesListService = ImagesListService.shared
    private var photos: [Photo] = []
    private var imagesServiceObserver: NSObjectProtocol?
    private var alertPresenter: AlertPresenter? = nil
    private enum Keys {
        static let showSingleImageSegueIdentifier = "ShowSingleImage"
        static let placeholderPreview = "placeholder_preview"
        static let heart = "heart"
        static let heartFilled = "heart-filled"
    }

    @IBOutlet private var tableView: UITableView!
    
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
        
        configureImageList()
        alertPresenter = AlertPresenter(view: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Keys.showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            
            viewController.largeImageURL = URL(string: photos[indexPath.row].largeImageURL)
        } else {
            super.prepare(for: segue, sender: sender)
        }
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
       
        if (cell.gradient == nil) {
            let gradient = getGradien(cell: cell)

            cell.gradientView.roundCorners(corners: [.bottomLeft, .bottomRight],radius: 16)
            cell.gradientView.layer.insertSublayer(gradient, at: 0)
            cell.gradient = gradient
        }
        
       

        let photo = photos[indexPath.row]
        let photoURL = URL(string: photo.thumbImageURL)
        let placholder = UIImage(named: Keys.placeholderPreview)
        
        let likeName = photo.isLiked ? Keys.heartFilled : Keys.heart
        guard let likeImage = UIImage(named: likeName) else {
            return
        }
        
        
        cell.preview.kf.indicatorType = .activity
        cell.preview.kf.setImage(
            with: photoURL,
            placeholder: placholder
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_): break
//                    self.removeGradient()
                case .failure:
//                    self.removeGradient()
                cell.imageView?.image = placholder
            }
        }
        cell.dateLabel.text = dateFormatter.string(from: Date())
        cell.likeButton.setImage(likeImage, for: .normal)
    }
    
    func configureImageList() {
        imagesListService.fetchPhotosNextPage()
        
        imagesServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
        updateTableViewAnimated()
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    func showError() {
        let alert = AlertModel(
            title: "Ощибка соединения",
            message: "Неудалось передать данные",
            buttonText: "Ok",
            completion: nil)
        
        alertPresenter?.show(data: alert)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // создаем переиспользуемую ячейку, по заранее заданому идентификатору
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        )
        
        // пробуем привести ячейку к типу нашей кастомной ячейки
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }

        imageListCell.delegate = self
        
        configCell(for: imageListCell, with: indexPath)
    
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Keys.showSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTappedLikeButton(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let photo = photos[indexPath.row]
        let isLiked = photo.isLiked
        
        UIBlockingProgressHUD.show()
               
       imagesListService.changeLike(
           photoId: photo.id,
           isLike: isLiked
       ) { [weak self] result in
           guard let self = self else { return }
           UIBlockingProgressHUD.dismiss()

           switch result {
               case .success(let isLiked):
                    self.photos[indexPath.row].isLiked = isLiked
                    cell.setLike(isLiked)
               case .failure:
                    self.showError()
           }
       }
    }
}

extension ImagesListViewController: UITableViewDataSource {}


