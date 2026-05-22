# Kidsland

一款面向儿童的 iOS 教育娱乐应用，提供学习、娱乐和实用工具功能。

## 功能模块

| 模块 | 说明 |
|------|------|
| 英文 | 英语学习 |
| 数学 | 数学学习 |
| 古诗 | 中国古典诗词 |
| 儿歌 | 儿童歌曲播放器 |
| 电脑 | 计算机知识学习 |
| AI对话 | ChatGPT 智能对话 |
| 录像 | 视频录制 |
| 录音 | 音频录制 |
| 相册 | 照片浏览 |
| 扫码 | 二维码/条形码扫描 |
| 蓝牙 | 蓝牙设备连接 |
| 温度 | 温度显示 |
| 健康码 | 健康码小组件 |
| 麦当劳 | 麦当劳主题 |
| 摸鱼 | 休闲娱乐 |
| 聊天 | 聊天功能 |

## 技术栈

- **语言**: Swift
- **UI**: SwiftUI
- **音频**: AVFoundation、AudioToolbox
- **扩展**: WidgetKit（健康码桌面小组件）
- **其他**: AVSpeechSynthesizer（中文语音合成）、SwiftyJSON

## 权限要求

- 相机（扫码）
- 麦克风（录音）
- 蓝牙
- Apple Music

## 项目结构

```
kidsland/
├── ContentView.swift       # 主页网格导航
├── kidslandApp.swift       # 应用入口
├── Section/                # 各功能模块视图
├── Model/                  # 数据模型
├── Utils/                  # 工具类
└── Resources/              # 图片、音频资源
HealthQR/                   # 健康码 Widget 扩展
```

## 开发环境

- Xcode
- iOS（支持 iPhone 和 iPad）
- 最低支持架构：armv7

## License

见 [LICENSE](LICENSE) 文件。
