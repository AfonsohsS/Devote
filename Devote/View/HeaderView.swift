//
//  HeaderView.swift
//  Devote
//
//  Created by Afonso Sabino on 22/07/21.
//

import SwiftUI

struct HeaderView: View {
    
    // MARK: - PROPERTIES
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
//    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - BODY
    
    var body: some View {
        HStack(spacing: 10) {
            // MARK: - TITLE
            
            Text("Devote")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.heavy)
                .padding(.leading, 4)
            
            Spacer()
            
            // MARK: - EDIT BUTTON
            
            EditButton()
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .padding(.horizontal, 10)
                .frame(minWidth: 70, minHeight: 24)
                .background(
                    Capsule().stroke(Color.white, lineWidth: 2)
                )
            
            
            // MARK: - APPEARANCE BUTTON
            
            Button(action: {
                // TOGGLE APPEARANCE
                isDarkMode.toggle()
            }, label: {
                Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .font(.system(.title, design: .rounded))
            })
            
        } //: HSTACK
        .padding()
        .foregroundColor(.white)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
            .background(
                Color.black
            )
            .edgesIgnoringSafeArea(.all)
    }
}
