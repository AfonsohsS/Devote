//
//  CheckboxStyle.swift
//  Devote
//
//  Created by Afonso Sabino on 22/07/21.
//

import SwiftUI

struct CheckboxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .foregroundColor(configuration.isOn ? .pink : .primary)
                .font(.system(size: 25, weight: .semibold, design: .rounded))
                .onTapGesture {
                    configuration.isOn.toggle()
                    playSound(sound: configuration.isOn ? "sound-rise" : "sound-tap", type: "mp3")
                }
            configuration.label
        } //: HSTACK
    }
}

struct CheckboxStyle_Previews: PreviewProvider {
    static var previews: some View {
        Toggle(isOn: .constant(false), label: {
            Text("Placeholder label")
        })
        .toggleStyle(CheckboxStyle())
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
