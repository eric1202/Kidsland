//
//  McdView.swift
//  kidsland
//
//  Created by 阳鸿 on 2021/8/5.
//

import SwiftUI
import Kingfisher

struct McdView: View {
    @State var isDetectingLongPress = false
    private var columnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @State private var imgs = [UIImage(named:"mcd-logo.jpg")]
    @State var img = UIImage(named:"mcd-logo.jpg")
    @State var products = [JSON()]

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
                                    let imgUrl = products[ index < products.count ? index : 0]["img"].stringValue

                                    let _ = print("\(imgUrl) \n")
                                    VStack(spacing:0){
//                                        Text("\( index >= products.count ? "index" : products[index]["productName"].stringValue)").font(.largeTitle)
                                        KFImage(URL(string: imgUrl))
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
                            let arr = getProducts()
                            let datas = arr.first!["products"].arrayValue
                            products = datas
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
    
    func getProducts() -> [JSON] {
        let path = Bundle.main.path(forResource: "mdl", ofType: "json")!
        let jsonString = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let json = JSON(parseJSON: jsonString!)
        
//        let decoder = JSONDecoder()
//
//        if let jsonPetitions = try? decoder.decode(ProductSection.self, from: json["data"].rawData()) {
//            return jsonPetitions.products
//            }
        
        return json["data"].arrayValue
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
                .onSwipeDown {
                    tap = false
                }
                .onSwipeUp {
                    tap = false

                }

        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(5)
        .shadow(radius: 5)
    }
}
