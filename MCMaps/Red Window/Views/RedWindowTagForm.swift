//
//  RedWindowTagForm.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-06-2025.
//

import SwiftUI

struct RedWindowTagForm: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var tags: Set<String>

    @State private var tagToAdd = ""

    private var tagArray: [String] {
        Array(tags.sorted())
    }

    var body: some View {
        Form {
            Section {
                HStack {
                    TextField("Create Tag", text: $tagToAdd, prompt: Text("Tag Name"))
                        .onSubmit(submitTag)
                    if !tagToAdd.isEmpty {
                        Button("Create", action: submitTag)
                    }
                }
            } header: {
                Text("Create a new tag...")
            }
            Section {
                if tags.isEmpty {
                    ContentUnavailableView(
                        "No Tags", systemImage: "tag", description: Text("Type a tag above to create it."))
                    .listRowBackground(Color.clear)
                } else {
                    List {
                        ForEach(Array(tagArray.enumerated()), id: \.element.self) { (index, tag) in
                            Label(tag, systemImage: "tag")
                                .contextMenu {
                                    Button("Remove Tag", role: .destructive) {
                                        deleteTags(in: [index])
                                    }
                                }
                        }
                        .onDelete(perform: deleteTags)
                    }
                }
            } header: {
                Text("... or update the existing tags.")
            }
        }
        .navigationTitle("Manage Tags")
        .animation(.default, value: tags)
        .animation(.interactiveSpring, value: tagToAdd)
        .toolbar {
            #if os(iOS)
                ToolbarItem {
                    if !tags.isEmpty {
                        EditButton()
                    }
                }
            #endif
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") { dismiss() }
            }
        }
    }

    private func submitTag() {
        tags.insert(tagToAdd)
        tagToAdd = ""
    }

    private func deleteTags(in indexSet: IndexSet) {
        let tagsToDelete = indexSet.map { index in
            tagArray[index]
        }
        for tag in tagsToDelete {
            tags.remove(tag)
        }
    }
}

#if os(iOS)
    #Preview {
        @Previewable @State var tags: Set<String> = ["Base", "Hotel", "Third Eye"]

        NavigationStack {
            RedWindowTagForm(tags: $tags)
        }
    }
#endif
