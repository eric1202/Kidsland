//
//  ScanView.swift
//  kidsland
//
//  Created by 阳鸿 on 2021/7/28.
//

import SwiftUI
import CarBode
import AVFoundation
import AudioToolbox

struct ScanView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let synthesizer = AVSpeechSynthesizer()
    
    let texts = ["扫码成功","长者银联卡","付款成功","学生卡"]
    var body: some View {
        CBScanner(
            supportBarcode: .constant([.qr, .code128, .ean13]), //Set type of barcode you want to scan
            scanInterval: .constant(2.0) //Event will trigger every 5 seconds
        ){
            //When the scanner found a barcode
            print("BarCodeType =",$0.type.rawValue, "Value =",$0.value)
            AudioServicesPlaySystemSound(1057);
            
            if $0.type == AVMetadataObject.ObjectType.qr{
                let number = Int.random(in: 0...texts.count-1)

                let utterance = AVSpeechUtterance(string:texts[number])
                utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
                utterance.rate = 0.5
                synthesizer.speak(utterance)
            }
            else if $0.type == AVMetadataObject.ObjectType.ean13{
                let utterance = AVSpeechUtterance(string:"\($0.value)")
                utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
                utterance.rate = 0.7
                synthesizer.speak(utterance)
            }
            

        }
        onDraw: {
            print("Preview View Size = \($0.cameraPreviewView.bounds)")
            print("Barcode Corners = \($0.corners)")
            
            //line width
            let lineWidth = 2
            
            //line color
            let lineColor = UIColor.red
            
            //Fill color with opacity
            //You also can use UIColor.clear if you don't want to draw fill color
            let fillColor = UIColor(red: 0, green: 1, blue: 0.2, alpha: 0.4)
            
            //Draw box
            $0.draw(lineWidth: CGFloat(lineWidth), lineColor: lineColor, fillColor: fillColor)
        }

        
    }
}

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanView()
    }
}
