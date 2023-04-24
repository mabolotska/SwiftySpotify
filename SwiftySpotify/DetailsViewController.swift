//
//  DetailsViewController.swift
//  SwiftySpotify
//
//  Created by Maryna Bolotska on 24/04/23.
//

import UIKit
import Kingfisher

class DetailsViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var albumLabel: UILabel!
    
    var album: AlbumModel? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let path = album?.coverImagePath, let url = URL(string: path) else { return }
        
        imageView.kf.setImage(with: .network(url))
        albumLabel.text = album?.name
    }

}
