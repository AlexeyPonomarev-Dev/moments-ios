//
//  ProfileViewController.swift
//  Moments
//
//  Created by Alexey Ponomarev on 09.09.2023.
//

import UIKit


class ProfileViewController: UIViewController {
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func logoutAction(_ sender: Any) {
    }
}
