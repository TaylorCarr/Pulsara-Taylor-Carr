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
    
    func imageTapped(id: Int) {
        
    }
    
    private func fetchImage(id: Int, size: Int) {
        DispatchQueue.main.async {
            self.images[id] = (hasFetched: true, image: nil)
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

