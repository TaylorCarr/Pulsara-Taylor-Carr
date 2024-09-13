import SwiftUI

class ImageListViewModel: ObservableObject {
    
    // hasFetched is a just a way for us to "store" whether or not we have fired off an api request to fetch the image (so that we don't attempt to fetch again, and so that we can show a loading spinner). So while the image is being fetched, hasFetched will be true and image will be nil
    @Published private var images = [Int: (hasFetched: Bool, image: UIImage?)]()
    @Published private var maxImageId = 100
    
    private let imageService = ImageService.sharedService
    private let thresholdToAddMoreImages = 40
    
    var imageIds: ClosedRange<Int> { 1...maxImageId }
    
    func image(id: Int, size: Int) -> Image? {
        if let (_, image) = images[id] {
            if let image { return Image(uiImage: image) }
            return nil
        } else {
            fetchImage(id: id, size: size)
            return nil
        }
    }

// not currently used
//    func imageTapped(id: Int) {
//        
//    }
    
    /*
     Description: this function utilizes a DispatchQueue to fetch images from the API. The initial max is 100 images but if a user keeps scrolling, it will add 100 more as necessary.
     Parameters:
        - id: Int - this is the id of the individual image being fetched
        - size: Int - this is the pixel size of the image
     */
    
    private func fetchImage(id: Int, size: Int) {
        DispatchQueue.main.async {
            self.images[id] = (hasFetched: true, image: nil)
            if (id + self.thresholdToAddMoreImages > self.maxImageId) {
                self.maxImageId += 100
            }
        }
        DispatchQueue.global(qos: .userInitiated).async {
            self.imageService.fetchImage(id: id, size: size) { imageData in
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.images[id] = (hasFetched: true, image: image)
                    }
                }
            }
        }
    }
}

