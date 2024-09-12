import SwiftUI

struct ImageListView: View {
    @ObservedObject var viewModel: ImageListViewModel
    
    private let imageSize = 100
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: CGFloat(imageSize)))], spacing: 20) {
                ForEach(viewModel.imageIds, id: \.self) { id in
                    if let image = viewModel.image(id: id, size: imageSize) {
                        image.onTapGesture { viewModel.imageTapped(id: id) }
                    } else {
                        ProgressView()
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ImageListView(viewModel: ImageListViewModel())
}
