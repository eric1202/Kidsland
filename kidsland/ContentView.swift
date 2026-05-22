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
    private var symbols = ["video.fill", "abc", "thermometer", "q.square.fill", "plus.slash.minus", "desktopcomputer", "t.bubble.fill", "tv.music.note", "mic", "plus.bubble", "leaf.fill","cross.circle.fill","newspaper.fill","person.fill.questionmark","hare","link.icloud.fill"]
    private var labels = ["录像", "英文", "温度", "扫码", "数学", "电脑", "古诗", "儿歌", "录音", "聊天", "麦当劳", "健康码", "相册", "AI对话", "摸鱼", "蓝牙"]
    private var colors: [Color] = [.yellow, .purple, .green, .blue, .orange, .red, .brown]

    var body: some View {
        GeometryReader(content: { geometry in

        NavigationView {
            ScrollView {
                NavigationLink(
                    destination: view(index: selectIndex),
                    isActive: $isShowingDetailView) { EmptyView()
                }
                LazyVGrid(columns: threeColumnGrid, spacing: 20) {
                    ForEach(0..<symbols.count, id: \.self) { index in
                        tileView(index: index, width: (geometry.size.width - 80) / 3)
                    }
                }
            }
            .padding(2).sheet(isPresented: $showingSheet) {
                ScanView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background{
                LinearGradient(gradient: Gradient(colors: [Color.gray, Color.cyan]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            }
            .navigationBarTitle(timeString)
            .onOpenURL { url in
                guard url.scheme == "widget" else { return }
                click(index: -1)
            }
        }
        .navigationViewStyle(.stack)
        })
        .onAppear {
            WifiHelper.shared.getWifiList()
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
        .onReceive(timer) { _ in
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            timeString = formatter.string(from: Date())
        }
    }
    
    @ViewBuilder
    func tileView(index: Int, width: CGFloat) -> some View {
        VStack(spacing: 4) {
            Image(systemName: symbols[index])
                .font(.system(size: 44))
                .foregroundColor(Color(UIColor(white: 0.1, alpha: 0.8)))
                .frame(width: width, height: 70)
                .background(colors[index % colors.count])
                .cornerRadius(10)
            Text(labels[index])
                .font(.caption)
                .foregroundColor(.white)
        }
        .onTapGesture { click(index: index) }
    }

    @ViewBuilder
    func view(index: Int) -> some View {
        switch index {
        case -1: HealthImageView()
        case 1:  EngLearnView()
        case 4:  MathLearnView()
        case 6:  PoetryView()
        case 7:  PlayerView()
        case 8:  RecordingView()
        case 10: McdView()
        case 11: HealthImageView()
        case 12: PhotoListView()
        case 13: ChatGPTView()
        case 14: MoYuView()
        case 15: BlueToothView()
        default: Text("敬请期待")
        }
    }

    func click(index: Int) {
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
            AudioServicesPlaySystemSound(1057)
            speak("温度正常")
        case 3:
            showingSheet.toggle()
        case 4:
            speak("数学学习")
            isShowingDetailView = true
        case 5:
            speak("电脑学习")
        case 6, 7, 8:
            isShowingDetailView = true
        case 9:
            AudioManager.shared.toggleJingle(resource: "familymart", ext: "mp3")
        case 10, 11, 12, 13, 14, 15:
            isShowingDetailView = true
        default:
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
    @State static private var linkActive = false

    static var previews: some View {
        ContentView()
    }
}
