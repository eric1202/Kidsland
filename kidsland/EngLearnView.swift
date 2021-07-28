//
//  EngLearnView.swift
//  kidsland
//
//  Created by 阳鸿 on 2021/7/28.
//

import SwiftUI

struct EngLearnView: View {
    @State var letter = "a"
    @State private var animationAmount: CGFloat = 1
    @State var taps = 0
    @State var color = Color.blue
    var body: some View {
        VStack{
            Spacer()
            
            Text(letter)
                .font(.system(size: 160,weight: .black))
                .modifier(Bounce(animCount: taps))
                .foregroundColor(color)
            Spacer()
            Button(action: {
                change()
            }) {
                Image(systemName: "gamecontroller").font(.largeTitle)
            }
            Spacer()
            
        }.onAppear{
            change()
        }
    }
    
    func generateRandomColor() -> UIColor {
        let redValue = CGFloat(drand48())
        let greenValue = CGFloat(drand48())
        let blueValue = CGFloat(drand48())
            
        let randomColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
            
        return randomColor
    }
    
    func randomString(of length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var s = ""
        for _ in 0 ..< length {
            s.append(letters.randomElement()!)
        }
        return s
    }
    
    func change(){
        letter = randomString(of:1)
        color = Color(generateRandomColor())
        withAnimation(Animation.linear(duration: 1)) {
            taps += 1
        }
        
    }
}

struct EngLearnView_Previews: PreviewProvider {
    static var previews: some View {
        EngLearnView()
    }
}

struct Bounce: AnimatableModifier {
    let animCount: Int
    var animValue: CGFloat
    var amplitude: CGFloat  // 振幅
    var bouncingTimes: Int
    
    init(animCount: Int, amplitude: CGFloat = 10, bouncingTimes: Int = 3) {
        self.animCount = animCount
        self.animValue = CGFloat(animCount)
        self.amplitude = amplitude
        self.bouncingTimes = bouncingTimes
    }
    
    var animatableData: CGFloat {
        get { animValue }
        set { animValue = newValue }
    }
    
    func body(content: Content) -> some View {
        let t = animValue - CGFloat(animCount)
        let offset: CGFloat = -abs(pow(CGFloat(M_E), -t) * sin(t * .pi * CGFloat(bouncingTimes)) * amplitude)
        return content.offset(y: offset)
    }
}
