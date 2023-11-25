//
//  ImagesListPresenterSpy.swift
//  Moments Tests
//
//  Created by Alexey Ponomarev on 18.11.2023.
//

import Moments
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: Moments.ImagesListViewControllerProtocol?
    var configureImageListCalled: Bool = false
    
    func configureImageList() {
        configureImageListCalled = true
    }

    
    func updateTableView() {
        
    }
    
    func getLargeImageURL(from indexPath: IndexPath) -> URL? {
        return nil
    }
    
    func getPhotosCount() -> Int {
        return 0
    }
    
    func getPhoto(indexPath: IndexPath) -> Moments.Photo? {
        return nil
    }
    
    func fetchPhotosNextPage(indexPath: IndexPath) {
        
    }
    
    func changeLike(indexPath: IndexPath?, cell: Moments.ImagesListCell) {
        
    }
    
    func getCellHeight(indexPath: IndexPath, tableViewWidth: CGFloat, imageInsetsLeft: CGFloat, imageInsetsRight: CGFloat, imageInsetsTop: CGFloat, imageInsetsBottom: CGFloat) -> CGFloat {
        return CGFloat()
    }

}
