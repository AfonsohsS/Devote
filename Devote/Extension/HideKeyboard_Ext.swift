//
//  HideKeyboard_Ext.swift
//  Devote
//
//  Created by Afonso Sabino on 20/07/21.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#endif
