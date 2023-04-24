//
//  ViewController.swift
//  SwiftySpotify
//
//  Created by Maryna Bolotska on 22/04/23.
//

import UIKit
import Kingfisher

class ViewController: UIViewController, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loadedAlbums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath)
        
        let album = loadedAlbums[indexPath.item]
        
        (cell as? AlbumViewCell)?.albumNameLabel.text = album.name
        
        if let path = album.coverImagePath, let url = URL(string: path) {
            (cell as? AlbumViewCell)?.albumCoverImage.kf.setImage(with: .network(url))
        } else {
            (cell as? AlbumViewCell)?.albumCoverImage.image = nil
        }
            
            
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var loadedAlbums: [AlbumModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedCell = sender as? UICollectionViewCell,
              let selectedIndex = collectionView.indexPath(for: selectedCell)?.item,
              let detailsViewController = segue.destination as? DetailsViewController
        else {
            return
        }
        let album = loadedAlbums[selectedIndex]
        detailsViewController.album = album
    }

    func loadData() {

        

        let requestUrl = URL(string: "https://spotify23.p.rapidapi.com/search/?q=%3CREQUIRED%3E&type=multi&offset=0&limit=10&numberOfTopResults=5")! as URL
        
        var request = URLRequest(url: requestUrl,
                                cachePolicy: .useProtocolCachePolicy,
                                timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let headers = [
            "X-RapidAPI-Key": "dc37ccdb74msh83bd9fc6379504ep1684ddjsneb83a6c8af69",
            "X-RapidAPI-Host": "spotify23.p.rapidapi.com"
        ]
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        
        Task {
            do {
                let response = try await session.data(for: request)
                let decoder = JSONDecoder()
                
                let responseDTO = try decoder.decode(SearchAPIResponse.self, from: response.0)
                
                let albums = responseDTO.albums.items.map { dto -> AlbumModel in
                    return AlbumModel(url: dto.data.uri,
                                      name: dto.data.name,
                                      coverImagePath: dto.data.coverArt.sources.first?.url
                    )
                }
                self.loadedAlbums = albums
                print("Response: \(response)")
            } catch {
                print("Error: \(error)")
            }
        }
        
//        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//            if (error != nil) {
//                print(error)
//            } else {
//                let httpResponse = response as? HTTPURLResponse
//                print(httpResponse)
//            }
//        })

       // dataTask.resume()
    }
}

