//
//  ContentView.swift
//  kidsland
//
//  Created by 阳鸿 on 2021/7/28.
//

import SwiftUI
import SwiftUIX
import AVFoundation
import AudioToolbox

struct ContentView: View {
    
    @State private var selection = 0
    @State private var currentSong = Song(id: "", name: "", artistName: "", artworkURL: "", assetPath: "")
    
    let synthesizer = AVSpeechSynthesizer()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State private var showingSheet = false
    @State private var selectIndex = 0
    @State private var timeString = "你好"
    @State private var isShowingDetailView = false

    private var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    private var symbols = ["video.fill", "abc", "thermometer", "q.square.fill", "plus.slash.minus", "desktopcomputer", "t.bubble.fill", "tv.music.note", "mic", "plus.bubble", "leaf.fill"]
    private var colors: [Color] = [.yellow, .purple, .green, .blue, .orange, .systemRed]
    
    var body: some View {
        GeometryReader(content: { geometry in

        NavigationView {
            ScrollView {
                NavigationLink(
                    destination: view(index: selectIndex),
                    isActive: $isShowingDetailView) { EmptyView()
                }
                LazyVGrid(columns: threeColumnGrid,spacing:20) {
                    ForEach((0...10), id: \.self) {
                        let index = $0
                        
                        Image(systemName: symbols[$0 % symbols.count])
                            .font(.system(size: 44))
                            .foregroundColor(Color(UIColor.init(white: 0.1, alpha: 0.8)))
                            .frame(width: (geometry.size.width-80)/3, height: 80)
                            .background(colors[$0 % colors.count])
                            .cornerRadius(10).onTapGesture {
                                click(index: index)
                            }
                    }
                }
            }.padding(2).sheet(isPresented: $showingSheet) {
                ScanView()
            }.navigationBarTitle(timeString)
            
        }
        })
        .onReceive(timer) { input in
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            timeString = formatter.string(from: Date())
        }
    }
    func view(index:Int)-> AnyView{
        switch index {
        case 1:
            return AnyView(EngLearnView())
        case 4:
            return AnyView(MathLearnView())
        case 7:
            return AnyView(PlayerView())
        default:
            return AnyView(Text("\(selectIndex) View"))
        }
    }
    func click(index:Int){
        selectIndex = index
        switch index {
        case 0:
            speak("录像功能")
        case 1:
            speak("英文学习")
            isShowingDetailView = true
        case 2:
            AudioServicesPlaySystemSound(1057);
            speak("温度正常")
        case 3:
            showingSheet.toggle()
        case 4:
            speak("数学学习")
            isShowingDetailView = true
        case 5:
            speak("电脑学习")
        case 6:
            speak("古诗学习")
            isShowingDetailView = true
        case 7:
            speak("儿歌学习")
            isShowingDetailView = true
        case 8:
            speak("录音学习")
        case 9:
            speak("儿歌学习")
        default:
            print(index)
            speak("还没开发好")
        }
    }
    func speak(_ s:String){
        let utterance = AVSpeechUtterance(string:s)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
