//
//  ImagesListPresenter.swift
//  Moments
//
//  Created by Alexey Ponomarev on 18.11.2023.
//

import UIKit

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func configureImageList()
    func updateTableView()
    func getLargeImageURL(from indexPath: IndexPath) -> URL?
    func getPhotosCount() -> Int
    func getPhoto(indexPath: IndexPath) -> Photo?
    func fetchPhotosNextPage(indexPath: IndexPath)
    func changeLike(indexPath: IndexPath?, cell: ImagesListCell)
    func getCellHeight(indexPath: IndexPath,
                       tableViewWidth: CGFloat,
                       imageInsetsLeft: CGFloat,
                       imageInsetsRight: CGFloat,
                       imageInsetsTop: CGFloat,
                       imageInsetsBottom: CGFloat
    ) -> CGFloat
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    private let imagesListService = ImagesListService.shared
    private var photos: [Photo] = []
    
    func configureImageList() {
        imagesListService.fetchPhotosNextPage()
        
        view?.configureImageList()
    }
    
    func updateTableView() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        self.photos = imagesListService.photos
        
        if oldCount != newCount {
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
    
    func getLargeImageURL(from indexPath: IndexPath) -> URL? {
        return URL(string: photos[indexPath.row].largeImageURL)
    }
    
    func getPhotosCount() -> Int {
        return photos.count
    }
    
    func getPhoto(indexPath: IndexPath) -> Photo? {
        return photos[indexPath.row]
    }
    
    func fetchPhotosNextPage(indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func changeLike(indexPath: IndexPath?, cell: ImagesListCell) {
        guard let indexPath = indexPath else {
            return
        }

        let photo = photos[indexPath.row]
        let isLiked = photo.isLiked
        
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
                    view?.showError()
            }
        }

    }
    
    func getCellHeight(indexPath: IndexPath, tableViewWidth: CGFloat, imageInsetsLeft: CGFloat, imageInsetsRight: CGFloat, imageInsetsTop: CGFloat, imageInsetsBottom: CGFloat) -> CGFloat {
        let image = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableViewWidth - imageInsetsLeft - imageInsetsRight
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsetsTop + imageInsetsBottom
        
        return cellHeight

    }
    
    
}