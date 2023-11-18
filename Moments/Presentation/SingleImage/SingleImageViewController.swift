//
//  SingleImageViewController.swift
//  Moments
//
//  Created by Alexey Ponomarev on 17.09.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var largeImageURL: URL? = nil
    private var activityController = UIActivityViewController(activityItems: [], applicationActivities: nil)
    private var alertPresenter: AlertPresenter? = nil
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        alertPresenter = AlertPresenter(view: self)
        downloadImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let image = imageView.image {
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    @IBAction func didBackButtonTap(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        let share = UIActivityViewController(
            activityItems: [imageView.image ?? UIImage()],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    func downloadImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: largeImageURL) { [weak self] result in
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()

            switch result {
                case .success(let imageResult):
                    self.rescaleAndCenterImageInScrollView(image: imageResult.image)
                    activityController = UIActivityViewController(
                        activityItems: [imageResult.image as Any],
                        applicationActivities: nil
                    )
                case .failure:
                    self.showError()
            }
        }
    }
    
    func showError() {
        let alert = AlertModel(
            title: "Что-то пошло не так.",
            message: "Попробовать ещё раз?",
            buttonText: "Не надо",
            completion: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            },
            secondButtonText: "Повторить",
            secondCompletion: { [weak self] in
                guard let self = self else { return }
                UIBlockingProgressHUD.show()
                downloadImage()
            })
    
        alertPresenter?.show(alert)
    }

    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
