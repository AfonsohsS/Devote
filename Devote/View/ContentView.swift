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
//    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    // FETCHING DATA

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    // MARK: - BODY
    
    var body: some View {
        
        
        NavigationView {
            ZStack {
                
                // MARK: - MAIN VIEW
                
                VStack {
                    
                    // MARK: - HEADER
                    
                    HeaderView()
                    Spacer(minLength: 80)
                    
                    // MARK: - NEW TASK BUTTON
                    
                    Button(action: {
                        showNewTaskItem = true
                        playSound(sound: "sound-ding", type: "mp3")
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
                            ListRowItemView(item: item)
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
                // Blur effect quando a pop up view Add Item aparecer
                .blur(radius: showNewTaskItem ? 8.0 : 0.0, opaque: false)
                .transition(.move(edge: .bottom))
                .animation(.easeOut(duration: 0.5))
                
                // MARK: - NEW TASK ITEM
                
                if showNewTaskItem {
                    
                    //Apresenta uma view modificada quando a popup view aparecer
                    BlankView(backgroundColor: isDarkMode ? .black : .gray,
                              backgroundOpacity: isDarkMode ? 0.3 : 0.5)
                        //Retira a blankview e a popupNewTaskItemView quando tocar em qualquer parte da tela.
                        .onTapGesture {
                            playSound(sound: "sound-tap", type: "mp3")
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
            .navigationBarHidden(true)
            .background(
                // MARK: - Background Image
                BackgroundImageView()
                    .blur(radius: showNewTaskItem ? 8.0 : 0.0, opaque: false)
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
    
//    private func updateColorScheme() {
//
//        switch colorScheme {
//        case .dark: isDarkMode = true
//        case .light: isDarkMode = false
//        @unknown default:
//            fatalError()
//        }
//
//    }
}


// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
