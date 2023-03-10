//
//  MoYuView.swift
//  kidsland
//
//  Created by 中战云台 on 2023/3/9.
//

import SwiftUI

struct MoYuResponseInfo: Codable {
    var status: Int?
    var message: String?
    var data: [MoYuResponseInfoDatum]?
}

// MARK: - ChatGPTResponseInfoDatum
struct MoYuResponseInfoDatum: Codable {
    var id, sort: Int?
    var name, sourceKey, iconColor: String?
    var data: [MoYuDatum]?
    var createTime: String?
    
    enum CodingKeys: String, CodingKey {
        case id, sort, name
        case sourceKey = "source_key"
        case iconColor = "icon_color"
        case data
        case createTime = "create_time"
    }
}

// MARK: - DatumDatum
struct MoYuDatum: Codable {
    var id: Int?
    var extra: String?
    var title, link: String?
}


struct MoYuView: View {
    @State private var selection = 0
    
    @State var items = [MoYuResponseInfoDatum]()
//    @State var showItmes = [MoYuDatum]()

    var body: some View {
        VStack{
            segmentView()
            if items.count > 0{
                List {
                    if let values = items[selection].data {
                        ForEach(values, id: \.id) { item in
                            
                            let urlEncoded = (item.link ?? "https://momoyu.cc/" ).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                            Link(destination: URL(string: urlEncoded!)!) {
                                Text(item.title!)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("摸鱼")
        .onAppear{
            fetchData()
        }
    }
    func makeLinksList() -> some View {
        List {
            ForEach(items, id: \.id) { dataSource in
                Section(header: Text(dataSource.name ?? "")) {
                    ForEach(dataSource.data ?? [], id: \.id) { item in
                        Link(destination: URL(string: item.link ?? "https://momoyu.cc/")!) {
                            Text(item.title ?? "")
                        }
                    }
                }
            }
        }
    }

    
    func segmentView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                if items.count > 0 {
                    ForEach(0..<items.count) { index in
                        Text(items[index].name ?? "")
                        //                        .tag(index)
                            .font(.headline)
                            .padding(10)
                            .foregroundColor(.white)
                            .background(index == selection ? Color.blue : Color.gray)
                            .cornerRadius(10)
                            .onTapGesture {
                                self.selection = index
                            }
                    }
                }
            }
            .padding(.horizontal, 10)
        }
        .frame(height: 50)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    func fetchData(){
        let urlStr = "https://momoyu.cc/api/hot/list?type=0"
        
        guard let url = URL(string: urlStr) else {
            fatalError("Invalid URL")
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            guard let response = decodeJSONResponse(data) else {
                print("Failed to decode response")
                return
            }
            
            if let datas = response.data{
                items = datas
            }
        }

        task.resume()

    }
    
    // 定义一个用于解析JSON的函数
    private func decodeJSONResponse(_ data: Data) -> MoYuResponseInfo? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let response = try decoder.decode(MoYuResponseInfo.self, from: data)
            return response
        } catch {
            print("Error decoding response: \(error.localizedDescription)")
            return nil
        }
    }
}

struct MoYuView_Previews: PreviewProvider {
    static var previews: some View {
        MoYuView()
    }
}
