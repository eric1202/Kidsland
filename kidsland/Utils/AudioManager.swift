import AVFoundation

final class AudioManager {
    static let shared = AudioManager()
    private init() {}

    private var musicPlayer: AVAudioPlayer?
    private var jinglePlayer: AVAudioPlayer?

    // MARK: - Music (PlayerView)

    var musicCurrentTime: TimeInterval { musicPlayer?.currentTime ?? 0 }
    var isMusicNil: Bool { musicPlayer == nil }

    func playMusic(path: String, loops: Int = 999) {
        musicPlayer?.pause()
        do {
            let player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            player.numberOfLoops = loops
            player.play()
            musicPlayer = player
        } catch {
            print(error)
        }
    }

    func pauseMusic() { musicPlayer?.pause() }
    func resumeMusic() { musicPlayer?.play() }

    // MARK: - Jingle (ContentView case 9)

    func toggleJingle(resource: String, ext: String) {
        if let p = jinglePlayer, p.isPlaying {
            p.stop()
            jinglePlayer = nil
        } else if let url = Bundle.main.url(forResource: resource, withExtension: ext),
                  let player = try? AVAudioPlayer(contentsOf: url) {
            player.play()
            jinglePlayer = player
        }
    }
}
