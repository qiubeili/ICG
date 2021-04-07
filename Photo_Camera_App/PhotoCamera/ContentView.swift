//
//  ContentView.swift
//  PhotoCamera
//
//  Created by Qiubei Li on 2/9/21.
//

import SwiftUI

struct ContentView: View {
  
  let model = MobileNetV2()
  @State private var showSheet: Bool = false
  @State private var showImagePicker: Bool = false
  @State private var sourceType: UIImagePickerController.SourceType = .camera
  @State private var classificationLabel: String = ""
  
  @State private var image: UIImage?
  
  // Returns a boolean representing whether classification succeeded or not.
  // Pre-condition: 'image' is nil or selected from Photo Album
  private func performImageClassification() -> Bool {
    if (image != nil) {
      let resizedImage = image!
        .resizeTo(size: CGSize(width: 224, height: 224))
      let buffer = resizedImage.buffer(from: resizedImage)!
      let output = try? model.prediction(image: buffer)
      if let output = output {
        self.classificationLabel = output.classLabel
        return true;
      }
    }
    return false;
  }
  
  var body: some View {
    VStack(alignment: .leading) { // content
      
      // Title
      Text("Image")
        .font(Font.custom("roboto", size: 65))
      Text("Caption")
        .font(Font.custom("roboto", size: 65))
        .padding(.top, -20)
      Text("Generator")
        .font(Font.custom("roboto", size: 65))
        .padding(.top, -20)
      Text("Generate alternative text for your photos.")
        .font(Font.custom("merriweather", size: 17))
      
      Spacer()
        .frame(height: 25)
      
      // Image preview
      Image(uiImage: image ?? UIImage(named: "image")!)
        .resizable()
        .scaledToFit()
        .frame(width: 350, height: 350)
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
        .opacity((image == nil) ? 0.0 : 1.0)
      
      Text(classificationLabel)
        .font(Font.custom("merriweather", size: 17))
        .frame(width: 350, height: 40)
        .border(Color.black)
        .opacity((classificationLabel.isEmpty) ? 0.0 : 1.0)
      
      Spacer()
        .frame(height: 25)
      
      HStack { // options
        Button(action: {
          self.showSheet = true
          classificationLabel = ""
        }) {
          Image("Photo", label: Text("Choose a photo")).frame(maxWidth: .infinity)
        }
        .actionSheet(isPresented: $showSheet) {
          ActionSheet(title: Text("Select Photo"), message: Text("Choose"), buttons: [
            .default(Text("Photo Library")) {
              self.showImagePicker = true
              self.sourceType = .photoLibrary
            },
            .default(Text("Camera")) {
              self.showImagePicker = true
              self.sourceType = .camera
            },
            .cancel()
          ])
        }
        .padding(20)
        .background(Color("AccentColor"))
        .foregroundColor(Color.white)
        .clipShape(Capsule())
        .font(Font.custom("merriweather", size: 16))
        
        Button("Generate") {
          print(self.performImageClassification())
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color("AccentColor2"))
        .foregroundColor(Color.white)
        .clipShape(Capsule())
        .font(Font.custom("roboto", size: 20))
        
      } // HStack
      .frame(width: 350)
    } // VStack
    .sheet(isPresented: $showImagePicker) {
      ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
    } // NavigationView
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color("Background"))
    .edgesIgnoringSafeArea(.all)
  } // some View
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
