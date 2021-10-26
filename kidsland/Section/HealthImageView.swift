//
//  HealthImageView.swift
//  kidsland
//
//  Created by 阳鸿 on 2021/8/11.
//

import SwiftUI

struct HealthImageView: View {
    
    @State var showImagePicker: Bool = false
    @State var image: UIImage?
    
    func save() {
        UserDefaults.standard.setImage(image: image, forKey: "imageData")
    }
    
    var body: some View {
        ZStack{
            Image(uiImage: (image != nil ? image : UIImage(named: "701628666462_.pic.jpg"))!).resizable()
                .onTapGesture(perform: {
                    showImagePicker.toggle()
                })
                .aspectRatio(contentMode: .fill).fill(alignment: .top)
                .navigationBarHidden(true)
                .statusBar(hidden: true).ignoresSafeArea()
        }.sheet(isPresented: $showImagePicker) {
            ImagePickerView(sourceType: .photoLibrary) { image in
                self.image = image
                self.save()
            }
        }.onAppear{
            if let data = UserDefaults.standard.imageForKey(key: "imageData") {
                
                self.image = data
                return
            }
            
            self.image = UIImage(named: "701628666462_.pic.jpg")
        }
    }
}

struct HealthImageView_Previews: PreviewProvider {
    static var previews: some View {
        HealthImageView()
    }
}
extension UserDefaults {
    func imageForKey(key: String) -> UIImage? {
        var image: UIImage?
        if let imageData = data(forKey: key) {
            image = NSKeyedUnarchiver.unarchiveObject(with: imageData) as? UIImage
        }
        return image
    }
    func setImage(image: UIImage?, forKey key: String) {
        var imageData: NSData?
        if let image = image {
            imageData = NSKeyedArchiver.archivedData(withRootObject: image) as NSData?
        }
        set(imageData, forKey: key)
    }
}
