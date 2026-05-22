import SwiftUI
import AVFoundation

struct RecordingView: View {
    @State private var isRecording = false
    @State private var isPlaying = false
    @State private var recorder: AVAudioRecorder?
    @State private var player: AVAudioPlayer?

    private var recordURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("recording.m4a")
    }

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            Image(systemName: isRecording ? "waveform.circle.fill" : "mic.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(isRecording ? .red : .blue)
                .scaleEffect(isRecording ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: isRecording)

            Text(isRecording ? "录音中..." : "点击开始录音")
                .font(.title2)

            Button(action: toggleRecord) {
                Text(isRecording ? "停止录音" : "开始录音")
                    .font(.title3)
                    .padding(.horizontal, 32).padding(.vertical, 12)
                    .background(isRecording ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }

            if FileManager.default.fileExists(atPath: recordURL.path) {
                Button(action: togglePlay) {
                    Label(isPlaying ? "停止播放" : "播放录音",
                          systemImage: isPlaying ? "stop.circle" : "play.circle")
                        .font(.title3)
                        .padding(.horizontal, 32).padding(.vertical, 12)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            Spacer()
        }
        .navigationTitle("录音学习")
        .onDisappear {
            recorder?.stop()
            player?.stop()
        }
    }

    func toggleRecord() {
        if isRecording {
            recorder?.stop()
            isRecording = false
        } else {
            #if !os(macOS)
            let session = AVAudioSession.sharedInstance()
            try? session.setCategory(.playAndRecord, mode: .default)
            try? session.setActive(true)
            #endif
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
            ]
            recorder = try? AVAudioRecorder(url: recordURL, settings: settings)
            recorder?.record()
            isRecording = true
        }
    }

    func togglePlay() {
        if isPlaying {
            player?.stop()
            isPlaying = false
        } else {
            player = try? AVAudioPlayer(contentsOf: recordURL)
            player?.play()
            isPlaying = true
        }
    }
}
