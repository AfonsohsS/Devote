//
//  NewTaskItemView.swift
//  Devote
//
//  Created by Afonso Sabino on 21/07/21.
//

import SwiftUI

struct NewTaskItemView: View {
    
    // MARK: - PROPERTIES
    
    @Environment(\.managedObjectContext) private var viewContext
    @State var task: String = ""
    private var isButtonDisable: Bool {
        task.isEmpty
    }
    @Binding var isShowing: Bool
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            Spacer()
            
            //Caixa de entrada para novas Tasks
            VStack(alignment: .center, spacing: 16, content: {
                TextField("New Task", text: $task)
                    .foregroundColor(.pink)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .padding()
                    .background(
                        Color(UIColor.systemGray6)
                    )
                    .cornerRadius(10)
                
                Button(action: {
                    addItem()
                }, label: {
                    Spacer()
                    Text("SAVE")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Spacer()
                }) //: BUTTON
                .disabled(isButtonDisable)
                .padding()
                .foregroundColor(.white)
                // Condicional para status do botão
                .background(isButtonDisable ? Color.blue : Color.pink)
                .cornerRadius(10)
            }) //: VSTACK
            .padding(.horizontal)
            .padding(.vertical, 20)
            .background(
                Color.white
            )
            .cornerRadius(16)
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 24)
            .frame(maxWidth: 640)
            .padding()
            
        } //: VSTACK
    }
    
    // MARK: - FUNCTIONS
    
    //Função para adicionar item ao Context do CoreData
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()
            
            //Tratamento de erro ao salvar no context
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            task = ""
            hideKeyboard()
            isShowing = false
        }
    }
}

struct NewTaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskItemView(isShowing: .constant(true))
            .background(Color.gray.edgesIgnoringSafeArea(.all))
    }
}