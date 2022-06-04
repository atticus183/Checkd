//
//  ContentView.swift
//  Checkd
//
//  Created by Josh R on 6/3/22.
//

import CoreData
import SwiftUI

struct ListView: View {
    @StateObject var viewModel = ListViewViewModel()
    @State private var showingCreateListView = false

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.lists, id: \.id) { list in
                        NavigationLink(destination: Text("Todo")) {
                            ListRow(list: list)
                        }
                    }.onDelete { indexSet in
                        viewModel.deleteList(at: indexSet)
                    }.onMove { indexSet, destination in
                        viewModel.moveList(from: indexSet, to: destination)
                    }
                }
                .listStyle(.insetGrouped)

                VStack {
                    Spacer()
                    AddButtonView {
                        showingCreateListView.toggle()
                    }.sheet(isPresented: $showingCreateListView) {
                        CreateListView()
                    }.padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .navigationTitle("Lists")
        }.navigationViewStyle(StackNavigationViewStyle())   //fixes console errors
    }
}

struct ListRow: View {
    let list: ListEntity

    var body: some View {
        HStack {
            Label {
                Text(list.name ?? "")
            } icon: {
                Image(systemName: "list.dash")
            }
            Spacer()
            Text("\(list.todoCount)")

        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListEntity.createForPreview()
        return ListView()
    }
}
