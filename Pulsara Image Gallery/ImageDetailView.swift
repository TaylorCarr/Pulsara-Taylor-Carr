//
//  ImageDetailView.swift
//  Pulsara Image Gallery
//
//  Created by Taylor Carr on 9/12/24.
//

import SwiftUI

/*
 Description: this struct houses the details for an individual images as returned by the info API
 */
struct imageDetails {
    var imageId: Int?
    var author: String?
    var width: Int?
    var height: Int?
    var imageURL: String?
    var downloadURL: String?
}

/*
 Description: This view shows the individual details of a specific image that has been selected by the user. It presents a larger version of the image that can be pinched to zoom. It also shows the author of the image, the pixel dimens and the image ID
 Parameters:
    - details: State var of the imageDetails struct. This object is updated once the additional info is returned from the API
    - currentZoom: State var used to track the current zoom of the image
    - totalZoom: State var used to track the total zoom calculated by the pinch distance
    - id: Int - the id of the image selected by the user
 */
struct ImageDetailView: View {
    @State var details = imageDetails()
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    var id: Int

    
    var body: some View {
        NavigationStack {
            VStack {
                AsyncImage(url: fetchImageUrl(id: id)) { image in
                    image
                        .resizable()
                        .frame(width: CGFloat(exactly: 300), height: CGFloat(exactly: 300))
                        .scaledToFit()
                        .scaleEffect(1 + currentZoom)
                        .padding()
                        .gesture(MagnifyGesture()
                            .onChanged { value in
                                currentZoom = value.magnification - 1
                            }
                            .onEnded { value in
                                totalZoom += currentZoom
                                currentZoom = 0
                            })
                        .accessibilityZoomAction { action in
                            if action.direction == .zoomIn {
                                totalZoom += 1
                            } else {
                                totalZoom -= 1
                            }
                        }
                } placeholder: {
                    ProgressView().frame(width: CGFloat(exactly: 300), height: CGFloat(exactly: 300)).padding()
                }
                List {
                    Text(verbatim: "Author: \(details.author ?? "unknown")")
                    Text(verbatim: "Image ID: \(details.imageId ?? id)")
                    Text(verbatim: "Pixels: \(details.width ?? 0) x \(details.height ?? 0)")
                }
            }
        }.onAppear {
            ImageService.sharedService.fetchImageInfo(with: id, completionClosure: {imageId, author, width, height, imageUrl, downloadUrl in
                details.imageId = imageId
                details.author = author
                details.width = width
                details.height = height
                details.downloadURL = downloadUrl
                details.imageURL = imageUrl
            })
            print(details)
        }
    }
    
    func fetchImageUrl(id: Int) -> URL {
        if let width = details.width, let height = details.height {
            return URL(string: "https://picsum.photos/id/\(id)/\(width)/\(height)")!
        } else { return URL(string: "https://picsum.photos/id/\(id)")! }
    }
}

#Preview {
    ImageDetailView(id: 0)
}
