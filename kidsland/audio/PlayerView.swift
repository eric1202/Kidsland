//
//  PlayerView.swift
//  MusicPlayer
//
//  Created by Sai Kambampati on 3/18/20.
//  Copyright © 2020 Sai Kambmapati. All rights reserved.
//

import SwiftUI
import AVKit
var audioPlayer: AVAudioPlayer!
struct PlayerView: View {
    //    @Binding var musicPlayer: MPMusicPlayerController
    @State private var isPlaying = false
    @State private var playIndex = 0
    @State var title = ""
    //    @Binding var currentSong: Song
    @State var songQueue = [Song]()
    
    func getAllMP3() -> [String]{
        return Bundle.paths(forResourcesOfType: "MP3", inDirectory: Bundle.main.resourcePath!)
    }
    
    func changeSong() {
        
        if audioPlayer != nil{
            
            audioPlayer.pause()
        }
        if self.playIndex < 0 {
            self.playIndex = 0
        }
        else if self.playIndex == songQueue.count {
            self.playIndex = 0
        }
        
        let song = self.songQueue[self.playIndex]
        
        title = song.name
        do {
            
            let play = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: song.assetPath))
            audioPlayer = play
            audioPlayer.numberOfLoops = 999
            audioPlayer.play()
        } catch let e {
            print(e)
        }
        
        
    }
    
    var body: some View {
        VStack{
            //                WebImage(url: URL(string: self.currentSong.artworkURL.replacingOccurrences(of: "{w}", with: "\(Int(geometry.size.width - 80) * 2)").replacingOccurrences(of: "{h}", with: "\(Int(geometry.size.width - 24) * 2)")))
            //                    .resizable()
            //                    .frame(width: geometry.size.width - 80, height: geometry.size.width - 80)
            //                    .cornerRadius(20)
            //                    .shadow(radius: 10)
            Spacer()
            VStack(spacing: 8) {
                Text(title)
                    .font(Font.system(.title).bold())
                    .multilineTextAlignment(.center)
                //                    Text(self.artist ?? "")
                //                        .font(.system(.headline))
            }
            Spacer()
            HStack(spacing: 40) {
                Button(action: {
                    if audioPlayer.currentTime < 5 {
                        self.playIndex = self.playIndex - 1
                        self.changeSong()
                    } else {
                        self.changeSong()
                        //                            self.musicPlayer.seek(to: CMTime(value: CMTimeValue(10.8), timescale: 1000))
                    }
                }) {
                    ZStack {
                        Circle()
                            .frame(width: 80, height: 80)
                            .accentColor(.pink)
                            .shadow(radius: 10)
                        Image(systemName: "backward.fill")
                            .foregroundColor(.white)
                            .font(.system(.title))
                    }
                }
                
                Button(action: {
                    if !self.isPlaying {
                        audioPlayer.play()
                        self.isPlaying = true
                    } else {
                        audioPlayer.pause()
                        self.isPlaying = false
                    }
                }) {
                    ZStack {
                        Circle()
                            .frame(width: 80, height: 80)
                            .accentColor(.pink)
                            .shadow(radius: 10)
                        Image(systemName: self.isPlaying ? "pause.fill" : "play.fill")
                            .foregroundColor(.white)
                            .font(.system(.title))
                    }
                }
                
                Button(action: {
                    self.playIndex = self.playIndex+1
                    print(self.playIndex)
                    self.changeSong()
                }) {
                    ZStack {
                        Circle()
                            .frame(width: 80, height: 80)
                            .accentColor(.pink)
                            .shadow(radius: 10)
                        Image(systemName: "forward.fill")
                            .foregroundColor(.white)
                            .font(.system(.title))
                    }
                }
            }.padding()
            
        }
        .onDisappear(){
            audioPlayer.pause()
            self.isPlaying = false
        }
        .onAppear() {
            for (i,path) in self.getAllMP3().enumerated() {
                let url = URL(fileURLWithPath: path)
                let name = url.lastPathComponent
//                    let asset = AVPlayerItem(url: url)
                
                self.songQueue.append(Song.init(id: String(i), name: name, artistName: "", artworkURL: "", assetPath: path))

            }
            
            if self.isPlaying {
                //                self.isPlaying = true
            } else {
                if audioPlayer != nil{
                    if audioPlayer.currentTime != 0{
                        audioPlayer.play()
                        self.isPlaying.toggle()
                        return
                    }
                }
                
                
                self.isPlaying.toggle()
                self.changeSong()
            }
        }
    }
}
