//
//  GameTimerView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 9/4/24.
//

import Foundation
import SwiftUI

struct GameTimerView: View {
    let timeInterval: TimeInterval
    let screenWidth: CGFloat = Constants.screenWidth

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .fill(Color(#colorLiteral(red: 0.1921568627, green: 0.5019607843, blue: 0.8235294118, alpha: 1)))
                    .frame(width: screenWidth, height: 50)
                    .position(x: geometry.size.width / 2)

                Text("\(Int(timeInterval.rounded()))")
                    .foregroundColor(.black)
                    .font(.title)
                    .position(x:
                        geometry.size.width / 2)
            }
        }
    }
}

struct GameTimerView_Previews: PreviewProvider {
    static var previews: some View {
        GameTimerView(timeInterval: 60)
    }
}
