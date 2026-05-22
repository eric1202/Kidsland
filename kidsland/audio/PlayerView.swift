//
//  PlayerView.swift
//  MusicPlayer
//
//  Created by Sai Kambampati on 3/18/20.
//  Copyright © 2020 Sai Kambmapati. All rights reserved.
//

import SwiftUI
import AVKit
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
        AudioManager.shared.pauseMusic()
        if self.playIndex < 0 { self.playIndex = 0 }
        else if self.playIndex == songQueue.count { self.playIndex = 0 }
        let song = self.songQueue[self.playIndex]
        title = song.name
        AudioManager.shared.playMusic(path: song.assetPath)
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
                    if AudioManager.shared.musicCurrentTime < 5 {
                        self.playIndex = self.playIndex - 1
                        self.changeSong()
                    } else {
                        self.changeSong()
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
                        AudioManager.shared.resumeMusic()
                        self.isPlaying = true
                    } else {
                        AudioManager.shared.pauseMusic()
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
        .onDisappear {
            AudioManager.shared.pauseMusic()
            self.isPlaying = false
        }
        .onAppear {
            for (i, path) in self.getAllMP3().enumerated() {
                let url = URL(fileURLWithPath: path)
                self.songQueue.append(Song(id: String(i), name: url.lastPathComponent, artistName: "", artworkURL: "", assetPath: path))
            }
            if !self.isPlaying {
                if !AudioManager.shared.isMusicNil && AudioManager.shared.musicCurrentTime != 0 {
                    AudioManager.shared.resumeMusic()
                    self.isPlaying = true
                } else {
                    self.isPlaying = true
                    self.changeSong()
                }
            }
        }
    }
}
