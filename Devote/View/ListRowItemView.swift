//
//  ListRowItemView.swift
//  Devote
//
//  Created by Afonso Sabino on 22/07/21.
//

import SwiftUI

struct ListRowItemView: View {
    
    // MARK: - PROPERTIES
    
    @Environment(\.managedObjectContext) var viewContext
    
    //Observador para mudaças na classe Item
    @ObservedObject var item: Item
    
    // MARK: - BODY
    
    var body: some View {
        Toggle(isOn: $item.completion, label: {
            Text(item.task ?? "")
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(item.completion ? Color.pink : Color.primary)
                .padding(.vertical, 12)
                .animation(.default)
        }) //: TOGGLE
        .toggleStyle(CheckboxStyle())
        .onReceive(item.objectWillChange, perform: { _ in
            if self.viewContext.hasChanges {
                try? self.viewContext.save()
            }
        })
        .toggleStyle(SwitchToggleStyle(tint: .pink))
    }
}

//struct ListRowItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListRowItemView()
//    }
//}
