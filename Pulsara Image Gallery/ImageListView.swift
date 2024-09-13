import SwiftUI

struct ImageListView: View {
    @ObservedObject var viewModel: ImageListViewModel
    @State var showDetailedView = false
    @State var selectedImage: Int?
    
    private let imageSize = 100
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: CGFloat(imageSize)))], spacing: 20) {
                    ForEach(viewModel.imageIds, id: \.self) { id in
                        if let image = viewModel.image(id: id, size: imageSize) {
                            image.onTapGesture { 
                                showDetailedView.toggle()
                                selectedImage = id
                            }.sheet(isPresented: $showDetailedView, content: {
                                if let id = selectedImage {
                                    ImageDetailView(id: id)
                                }
                            })
                        } else {
                            ProgressView()
                        }
                    }
                }
                .padding()
            }.navigationTitle("Images")
        }
        
    }
}

#Preview {
    ImageListView(viewModel: ImageListViewModel())
}
