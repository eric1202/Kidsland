//
//  PhotoListView.swift
//  kidsland
//
//  Created by 中战云台 on 2022/3/7.
//

import SwiftUI

struct PhotoObj {
    var title:String
    var img:UIImage
}

struct PhotoListView: View {
    @State var showAlert = false
    @State var datas : [PhotoObj] = []
    @State var image = UIImage()
    var body: some View {
        Form{
            ForEach(0..<datas.count, id: \.self) { i in
            HStack{
                Text(String(i))
                Image(uiImage: datas[i].img).resizable().scaledToFit().frame(width: 100, height: 100)
            }.padding().onLongPressGesture(minimumDuration: 1.5) {
                print("Long pressed!")
            }
            }
            Section {
                Button(action: {
                    print("Perform an action here...")
                    showAlert.toggle()
                }) {
                    
                    HStack {
                        Image(systemName: "plus")
                        Text("add")
                        Spacer()
                    }
                }.padding()
            }.sheet(isPresented: $showAlert) {
                ImagePickerView(sourceType: .photoLibrary) { image in
                    self.image = image
                    //add title
                    datas.append(PhotoObj(title: Date().description, img: image))
                }
            }
        }
    }
    
    func add(_ obj:PhotoObj) {
        UserDefaults.standard.setImage(image: image, forKey: "imageData")
    }
}

struct PhotoListView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoListView()
    }
}
