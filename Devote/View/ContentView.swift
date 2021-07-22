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
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showNewTaskItem: Bool = false
    
    // FETCHING DATA

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    // MARK: - BODY
    var body: some View {
        // Embed "List" em um novo container (NavigationView)
        NavigationView {
            ZStack {
                
                // MARK: - MAIN VIEW
                
                VStack {
                    
                    // MARK: - HEADER
                    
                    Spacer(minLength: 80)
                    
                    // MARK: - NEW TASK BUTTON
                    
                    Button(action: {
                        showNewTaskItem = true
                    }, label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    })
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            .clipShape(Capsule())
                    )
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)
                    
                    // MARK: - TASKS
                    
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
                
                // MARK: - NEW TASK ITEM
                
                if showNewTaskItem {
                    
                    //Apresenta uma view semitransparente quando a popup view aparecer
                    BlankView()
                        //Retira a blankview e a popupNewTaskItemView quando tocar em qualquer parte da tela.
                        .onTapGesture {
                            withAnimation {
                                showNewTaskItem = false
                            }
                        }
                    
                    NewTaskItemView(isShowing: $showNewTaskItem)
                }
                
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
