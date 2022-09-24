import SwiftUI

// TODO
struct PhotoListView: View {
    
    //private var data: [Int] = Array(1...20)
    
    
    //var data: [Photo] = Array(arrayLiteral: Photo(id: "52375202653", farm: 66, server: "65535", secret: "9a3cacb72e"))
    
    @State var imageSource: [Photo] = [Photo]()
    let apiClient:APIClient = APIClient()
    
    private let colors: [Color] = [.red, .green, .blue, .yellow]
    
    @State var searchText = ""
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 170))
    ]
    
    func searchImages() {
        clearData()
        request(apiClient.fetch(query: searchText))
    }
    
    func clearData(){
        imageSource.removeAll()
    }
    
    func request(_ endpoint: URL){
        print(endpoint.absoluteString)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: endpoint) { (data, response, error) in
            if error != nil  {
                print(error!)
                return
            }
            
            if let safeData = data {
                self.parseJson(safeData)
            }
        }
        
        task.resume()
    }
    
    func parseJson (_ response: Data){
        do{
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(FlickrSearchResults.self, from: response)
            
            //let object = FlickrSearchResults(photos: decoderData.photos, stat: decoderData.stat)
            
            if decodedData.stat == "ok" {
                
                    for item in decodedData.photos.photo {
                        let newItem = Photo(id: item.id, farm: item.farm, server: item.server, secret: item.secret)
                        imageSource.append(newItem)
                    }
                
            }
           
        }catch{
            print(error)
        }
        
    }
    
    
    var body: some View {
        NavigationView{
            ScrollView{
                LazyVGrid(columns: adaptiveColumns, spacing: 20){
                    ForEach(imageSource, id: \.id) { item in
                        ZStack{
                            Rectangle()

                                .frame(width: 170, height: 170)
                                .foregroundColor(.white)
                                .cornerRadius(30)
                            //Text("\(number)")
                            //AsyncImage(url: number.thumbnailUrl)
                            
                            
                            AsyncImage(
                                url: item.thumbnailUrl,
                                content: { image in
                              image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(30)
                                .frame(width: 170, height: 170)
                            }, placeholder: {
                              //Color.gray
                                Text("Loading ...")
                            })
                            //Text("\(number.id)")                                .foregroundColor(.white)
                              //  .font(.system(size: 80))
                        }
                    }
                }
                .searchable(text: $searchText)
                .onSubmit(of: .search) {
                    searchImages()
                }
            }
        }
    }
}

struct PhotoListView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoListView()
    }
}
