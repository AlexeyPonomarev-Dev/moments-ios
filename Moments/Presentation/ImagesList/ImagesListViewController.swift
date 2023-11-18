//
//  ImagesListViewController.swift
//  Moments
//
//  Created by Alexey Ponomarev on 28.08.2023.
//

import UIKit

public protocol ImagesListViewControllerProtocol: AnyObject {
    func configureImageList()
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func showError()
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    private var imagesServiceObserver: NSObjectProtocol?
    private var alertPresenter: AlertPresenter? = nil
    private var presenter: ImagesListPresenterProtocol?

    private enum Keys {
        static let showSingleImageSegueIdentifier = "ShowSingleImage"
        static let placeholderPreview = "placeholder_preview"
        static let heart = "heart"
        static let heartFilled = "heart-filled"
    }

    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    func configure(_ presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.contentInset = UIEdgeInsets(
            top: 12,
            left: 0,
            bottom: 12,
            right: 0
        )

        presenter?.configureImageList()
        alertPresenter = AlertPresenter(view: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Keys.showSingleImageSegueIdentifier {
            let viewController = segue.destination as? SingleImageViewController
            let indexPath = sender as? IndexPath
            
            guard let viewController = viewController,
                  let indexPath = indexPath else {
                return
            }
            
            viewController.largeImageURL = presenter?.getLargeImageURL(from: indexPath)
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
        
        guard let presenter = presenter,
              let photo = presenter.getPhoto(indexPath: indexPath) else { return }

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
        )
        cell.likeButton.setImage(likeImage, for: .normal)
        if let photoDate = photo.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: photoDate)
        } else {
            cell.dateLabel.text = ""
        }
    }
    
    func configureImageList() {
        imagesServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.presenter?.updateTableView()
        }
        presenter?.updateTableView()
    }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
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
        
        alertPresenter?.show(alert)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath
    ) {
        presenter?.fetchPhotosNextPage(indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else { return 0 }
        return presenter.getPhotosCount()

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
        guard let presenter = presenter else { return CGFloat() }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        return presenter.getCellHeight(
            indexPath: indexPath,
            tableViewWidth: tableView.bounds.width,
            imageInsetsLeft: imageInsets.left,
            imageInsetsRight: imageInsets.right,
            imageInsetsTop: imageInsets.top,
            imageInsetsBottom: imageInsets.bottom
        )
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Keys.showSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTappedLikeButton(_ cell: ImagesListCell) {
        presenter?.changeLike(indexPath: tableView.indexPath(for: cell), cell: cell)
    }
}

extension ImagesListViewController: UITableViewDataSource {}


