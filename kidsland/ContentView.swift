//
//  ContentView.swift
//  kidsland
//
//  Created by 阳鸿 on 2021/7/28.
//

import SwiftUI

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
    private var symbols = ["video.fill", "abc", "thermometer", "q.square.fill", "plus.slash.minus", "desktopcomputer", "t.bubble.fill", "tv.music.note", "mic", "plus.bubble", "leaf.fill","cross.circle.fill","newspaper.fill"]
    private var colors: [Color] = [.yellow, .purple, .green, .blue, .orange, .red]
    
    var body: some View {
        GeometryReader(content: { geometry in

        NavigationView {
            ScrollView {
                NavigationLink(
                    destination: view(index: selectIndex),
                    isActive: $isShowingDetailView) { EmptyView()
                }
                LazyVGrid(columns: threeColumnGrid,spacing:20) {
                    ForEach((0..<symbols.count), id: \.self) {
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
            }
            .padding(2).sheet(isPresented: $showingSheet) {
                ScanView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitle(timeString)
            .onOpenURL { url in
                print(url)
                guard url.scheme == "widget" else { return }
                click(index: -1)
                
                
            }
            
        }
        })
        .onAppear(perform: {
            
            WifiHelper.shared.getWifiList()
        })
        .onReceive(timer) { input in
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            timeString = formatter.string(from: Date())
        }
    }
    
    @ViewBuilder
    func view(index:Int)-> some View{
        switch index {
        case -1:
            HealthImageView()
        case 1:
            EngLearnView()
        case 4:
            MathLearnView()
        case 7:
            PlayerView()
        case 10:
            McdView()
        case 11:
            HealthImageView()
        case 12:
            PhotoListView()
        default:
            Text("\(selectIndex) View")
        }
    }
    func click(index:Int){
        selectIndex = index
        switch index {
        case -1:
            isShowingDetailView = true
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
//            isShowingDetailView = true
        case 7:
            speak("儿歌学习")
            isShowingDetailView = true
        case 8:
            speak("录音学习")
        case 9:

            let play = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "familymart", withExtension: "mp3")!)
            audioPlayer = play
//            audioPlayer.numberOfLoops =
            audioPlayer.play()
        case 10:
            isShowingDetailView = true
        case 11,12:
            isShowingDetailView = true
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

//struct ContentView_Previews: PreviewProvider {
//    @State static private var linkActive = false
//
//    static var previews: some View {
//        ContentView(linkActive: $linkActive)
//    }
//}
