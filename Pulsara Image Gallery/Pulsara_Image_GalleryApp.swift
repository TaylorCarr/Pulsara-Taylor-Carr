//
//  Pulsara_Image_GalleryApp.swift
//  Pulsara Image Gallery
//
//  Created by Spencer Debuf on 9/12/24.
//

import SwiftUI

@main
struct Pulsara_Image_GalleryApp: App {
    var body: some Scene {
        WindowGroup {
            ImageListView(viewModel: ImageListViewModel())
        }
    }
}
