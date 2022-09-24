import UIKit
import Foundation

class PhotoListViewController: UIViewController, SearchServiceDelegate{
    
    //private let searchController = UISearchController(searchResultsController: nil)
    
    
    @IBOutlet weak var imgCollection: UICollectionView!
    private let searchController = UISearchController()
    
    
    let apiClient: APIClient = APIClient()
    let searchService: SearchService = SearchService()
    
    var imagesSource: [Photo] = [Photo]()
    private let itemsPerRow: CGFloat = 3
    
    private let sectionInsets = UIEdgeInsets(
      top: 50.0,
      left: 20.0,
      bottom: 50.0,
      right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchBar.delegate = self
        searchService.delegate = self
        setupUI()
    }
    

    private func setupUI() {
        navigationItem.title = "Image Finderß"
        navigationItem.searchController = searchController
        //searchController.searchResultsUpdater = self
    }
    
    func addItem(_ item: Photo) {
        imagesSource.append(item)
    }
    
    func updateSource() {
        DispatchQueue.main.async {
            self.imgCollection.reloadData()
        }
    }
    
    func cleanPrevData(){
        self.imagesSource.removeAll()
    }
    
}

extension PhotoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        cleanPrevData()
        searchService.request(apiClient.fetch(query: searchBar.text ?? " " ))
        //imgCollection.reloadData()
    }
}


extension PhotoListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as! PhotoCellCollectionViewCell
        cell.backgroundColor = .white
        cell.imageCell.loadImge(withUrl: imagesSource[indexPath.row].thumbnailUrl!)
        //cell.imageCell.image = imagesSource[indexPath.row].thumbnailUrl
        
        return cell
        
    }
    
    
}

extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
      ) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
      }
      

      func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
      ) -> UIEdgeInsets {
        return sectionInsets
      }
      

      func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
      ) -> CGFloat {
        return sectionInsets.left
      }
    
}


extension UIImageView {
    func loadImge(withUrl url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
