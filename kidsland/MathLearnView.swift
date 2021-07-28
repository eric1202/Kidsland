//
//  MathLearnView.swift
//  kidsland
//
//  Created by 阳鸿 on 2021/7/28.
//

import SwiftUI

struct MathLearnView: View {
    @State var letter = "a"
    @State private var animationAmount: CGFloat = 1
    @State var taps = 0
    @State var color = Color.blue
    var body: some View {
        VStack{
            Spacer()
            
            Text(letter)
                .font(.system(size: 180,weight: .semibold))
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
        let letters = "0123456789"
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

struct MathLearnView_Previews: PreviewProvider {
    static var previews: some View {
        MathLearnView()
    }
}

