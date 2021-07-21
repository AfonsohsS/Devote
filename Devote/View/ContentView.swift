//
//  ContentView.swift
//  Devote
//
//  Created by Afonso Sabino on 04/07/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    // MARK: - PROPERTY
    
    @State var task: String = ""
    
    private var isButtonDisable: Bool {
        task.isEmpty
    }
    
    // FETCHING DATA
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    // MARK: - BODY
    var body: some View {
        // Embed "List" em um novo container (NavigationView)
        NavigationView {
            ZStack {
                VStack {
                    VStack(alignment: .center, spacing: 16, content: {
                        TextField("New Task", text: $task)
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
                            Spacer()
                        }) //: BUTTON
                        .disabled(isButtonDisable)
                        .padding()
                        .font(.headline)
                        .foregroundColor(.white)
                        // Condicional para status do botão
                        .background(isButtonDisable ? Color.gray : Color.pink)
                        .cornerRadius(10)
                    }) //: VSTACK
                    .padding()
                    
                    List {
                        ForEach(items) { item in
                            VStack(alignment: .leading) {
                                Text(item.task ?? "")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Text("\(item.timestamp!, formatter: itemFormatter)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            } //: LIST ITEM
                        }
                        .onDelete(perform: deleteItems)
                    } //: LIST
                    //Apresentar a lista em bloco com bordas arrendondas
                    .listStyle(InsetGroupedListStyle())
                    //Acrescenta um sombreamento na lista
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    //Ajuste do frame da listagem para visualização em iPAD
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                } //: VSTACK
            } //: ZSTACK
            //Remove o background da tableView
            .onAppear(perform: {
                UITableView.appearance().backgroundColor = UIColor.clear
            })
            .navigationBarTitle("Daily Tasks", displayMode: .large)
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                #endif
    //
    //                ToolbarItem(placement: .navigationBarTrailing) {
    //                    Button(action: addItem) {
    //                        Label("Add Item", systemImage: "plus")
    //                    }
    //                }
                
            } //: TOOLBAR
            .background(
                BackgroundImageView()
            )
            .background(
                backgroundGradient.ignoresSafeArea(.all)
            )
        } //: NAVIGATION
        //Apresentar uma única coluna mesmo em visualizações no iPad
        .navigationViewStyle(StackNavigationViewStyle())
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
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {

                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}


// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
