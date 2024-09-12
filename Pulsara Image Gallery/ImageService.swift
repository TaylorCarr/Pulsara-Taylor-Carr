import Foundation

class ImageService {
    
    static var sharedService = ImageService()
    
    func fetchImage(id: Int, size: Int, completion: (Data) -> Void) {
        if let url = URL(string: "https://picsum.photos/id/\(id)/\(size)") {
            if let imageData = try? Data(contentsOf: url) {
                completion(imageData)
            }
        }
    }
    
    
    /*
     example usage:
     
     fetchImageInfo(with: id) { id, author, width, height, imageURL, downloadURL in
         // here we have access to the meta, so we can do whatever we need to do
     }
     
     */
    func fetchImageInfo(with id: Int, completionClosure: @escaping (Int?, String?, Int?, Int?, String?, String?) -> Void ) {
        let urlPath: String = "https://picsum.photos/id/\(id)/info"
        if let url: URL = URL(string: urlPath) {
            let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)

            // the task of downloading the data, and a completion handler to handle the data
            let task = defaultSession.dataTask(with: url) { (data, response, error) in
                var imageID: Int?
                var author: String?
                var width: Int?
                var height: Int?
                var imageURL: String?
                var downloadURL: String?
                
                if error != nil { print("Error in DataRetriever.fetchImageInfo(), dataTask error") }
                else {
                    if let data = data {
                        if let jsonResult = try? JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) {
                            if let jsonDict = jsonResult as? NSDictionary {
                                // retrieve the  from the json data
                                imageID = jsonDict["id"] as? Int
                                author = jsonDict["author"] as? String
                                width = jsonDict["width"] as? Int
                                height = jsonDict["height"] as? Int
                                imageURL = jsonDict["url"] as? String
                                downloadURL = jsonDict["download_url"] as? String
                            } else { print("Error in DataRetriever.fetchImageInfo(), jsonResult could not be cast to NSDictionary") }
                        } else { print("Error in DataRetriever.fetchImageInfo(), failed to get json object from data")}
                    } else { print("Error in DataRetriever.fetchImageInfo(), data was nil") }
                }
                
                completionClosure(imageID, author, width, height, imageURL, downloadURL)
            }
            task.resume()
        } else { print("Error in DataRetriever.fetchImageInfo(), failed to create URL")}
    }
}
