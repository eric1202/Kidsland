//
//  McdView.swift
//  kidsland
//
//  Created by 阳鸿 on 2021/8/5.
//

import SwiftUI

struct McdView: View {
    @State var isDetectingLongPress = false
    private var columnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @State private var imgs = [UIImage(named:"mcd-logo.jpg")]
    @State var img = UIImage(named:"mcd-logo.jpg")
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack{

            VStack(spacing:0){
                Image(uiImage: UIImage(named: "header-mobile-bg")!).fill(alignment: .top).frame(height: 100)
                
                    ScrollView {
                        VStack{
                            Spacer()
                            LazyVGrid(columns: columnGrid,spacing:2) {
                                ForEach((0...imgs.count-1), id: \.self) {
                                    let index = $0
                                    VStack(spacing:0){
                                        Text("\(index)").font(.largeTitle)
                                        Image(uiImage:imgs[index]!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 100)
                                            .onTapGesture {
                                                
                                                img = imgs[index]
                                                isDetectingLongPress.toggle()
                                            }
                                        Spacer(minLength: 20)
                                    }
                                }
                                Spacer()
                                Text("select")
                            }.blur(radius: isDetectingLongPress ? 5 : 0)
                            
                        }.onAppear(){
                            imgs = getFiles().first!.map({ (name) -> UIImage in
                                return UIImage(named: name)!
                            })
                        }
                    }.padding()
                }
                if isDetectingLongPress {
                    ImagePreview(img: $img,tap: $isDetectingLongPress)
                        .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.95)
                        .transition(.scale)
                }
            }.ignoresSafeArea()
        })
        
    }
    
    func getFiles() -> [[String]] {
        var arr:[[String]] = []
        var temp:[String] = []
        let p = "Resources/dessert"
        
        let dir = Bundle.main.urls(forResourcesWithExtension: "png", subdirectory: nil)
        //        let myDirectoryEnumerator = FileManager.default.enumerator(atPath: dir)
        for path in dir!{
            temp.append(path.lastPathComponent)
        }
        arr.append(temp)
        
        return arr
    }
}

struct McdView_Previews: PreviewProvider {
    static var previews: some View {
        McdView()
    }
}


struct ImagePreview : View {
    @Binding var img : UIImage?
    @Binding var tap : Bool

    var body: some View {
        ZStack {
            Image(uiImage:img ?? UIImage(named:"mcd-logo.jpg")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .onTapGesture {
                    tap.toggle()
                }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(5)
        .shadow(radius: 5)
    }
}
