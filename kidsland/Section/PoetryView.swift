import SwiftUI
import AVFoundation

struct Poem {
    let title: String
    let author: String
    let lines: [String]
}

struct PoetryView: View {
    let poems: [Poem] = [
        Poem(title: "静夜思", author: "李白", lines: ["床前明月光，", "疑是地上霜。", "举头望明月，", "低头思故乡。"]),
        Poem(title: "春晓", author: "孟浩然", lines: ["春眠不觉晓，", "处处闻啼鸟。", "夜来风雨声，", "花落知多少。"]),
        Poem(title: "悯农", author: "李绅", lines: ["锄禾日当午，", "汗滴禾下土。", "谁知盘中餐，", "粒粒皆辛苦。"]),
        Poem(title: "登鹳雀楼", author: "王之涣", lines: ["白日依山尽，", "黄河入海流。", "欲穷千里目，", "更上一层楼。"]),
        Poem(title: "咏鹅", author: "骆宾王", lines: ["鹅，鹅，鹅，", "曲项向天歌。", "白毛浮绿水，", "红掌拨清波。"]),
    ]

    @State private var index = 0
    let synthesizer = AVSpeechSynthesizer()

    var poem: Poem { poems[index] }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text(poem.title)
                .font(.system(size: 36, weight: .bold))
            Text("— \(poem.author)")
                .font(.title3)
                .foregroundColor(.secondary)
            VStack(spacing: 12) {
                ForEach(poem.lines, id: \.self) { line in
                    Text(line)
                        .font(.system(size: 28, weight: .medium))
                }
            }
            .padding(.top, 8)
            Spacer()
            HStack(spacing: 40) {
                Button(action: prev) {
                    Image(systemName: "chevron.left.circle.fill").font(.system(size: 44))
                }
                .disabled(index == 0)
                Button(action: read) {
                    Image(systemName: "speaker.wave.2.fill").font(.system(size: 44))
                }
                Button(action: next) {
                    Image(systemName: "chevron.right.circle.fill").font(.system(size: 44))
                }
                .disabled(index == poems.count - 1)
            }
            .padding(.bottom, 40)
        }
        .navigationTitle("古诗学习")
        .onAppear { read() }
    }

    func read() {
        let text = poem.title + "。" + poem.author + "。" + poem.lines.joined()
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        utterance.rate = 0.4
        synthesizer.stopSpeaking(at: .immediate)
        synthesizer.speak(utterance)
    }

    func prev() { if index > 0 { index -= 1; read() } }
    func next() { if index < poems.count - 1 { index += 1; read() } }
}
