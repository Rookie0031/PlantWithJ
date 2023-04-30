//
//  TestView.swift
//  PlantWithJ
//
//  Created by 장지수 on 2023/04/30.
//

import SwiftUI
import UIKit

struct CameraView: View {
    @State private var showSelection: Bool = false
    @State private var showPicker: Bool = false
    @State private var type: UIImagePickerController.SourceType = .photoLibrary
    @Binding var imageData: Data?
    let originalImageData: Data?
    
    var body: some View {
        
        VStack {
            Button {
                showSelection.toggle()
            } label: {
                if let imageData, let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                } else {
                    if let originalImageData, let image = UIImage(data: originalImageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                    } else {
                        Image("PicturePlaceholder")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .confirmationDialog("Label",
                            isPresented: $showSelection,
                            titleVisibility: .hidden) {
            
            Button("Camera") {
                showPicker = true
                type = .camera
            }
            
            Button("Photos") {
                showPicker = true
                type = .photoLibrary
                
            }
        }
                            .fullScreenCover(isPresented: $showPicker) {
                                ImagePickerView(sourceType: type) { image in
                                    let imageData = image.jpegData(compressionQuality: 0.3)
                                    self.imageData = imageData ?? Data()
                                }
                                .edgesIgnoringSafeArea(.all)
                            }
    }
}

struct ImagePickerView: UIViewControllerRepresentable {
    
    private var sourceType: UIImagePickerController.SourceType
    private let onImagePicked: (UIImage) -> Void
    
    @Environment(\.presentationMode) private var presentationMode
    
    public init(sourceType: UIImagePickerController.SourceType, onImagePicked: @escaping (UIImage) -> Void) {
        self.sourceType = sourceType
        self.onImagePicked = onImagePicked
    }
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = self.sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(
            onDismiss: { self.presentationMode.wrappedValue.dismiss() },
            onImagePicked: self.onImagePicked
        )
    }
    
    final public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        private let onDismiss: () -> Void
        private let onImagePicked: (UIImage) -> Void
        
        init(onDismiss: @escaping () -> Void, onImagePicked: @escaping (UIImage) -> Void) {
            self.onDismiss = onDismiss
            self.onImagePicked = onImagePicked
        }
        
        public func imagePickerController(_ picker: UIImagePickerController,
                                          didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                self.onImagePicked(image)
            }
            self.onDismiss()
        }
        public func imagePickerControllerDidCancel(_: UIImagePickerController) {
            self.onDismiss()
        }
    }
}
