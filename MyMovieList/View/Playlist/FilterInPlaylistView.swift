//
//  FilterInPlaylistView.swift
//  MyMovieList
//
//  Created by Hasna Paramesti Ahmad on 06/05/25.
//

import SwiftUI

struct FilterInPlaylistView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var selectedGenre: String?
    @Binding var selectedMood: String?
    @Binding var selectedEras: String?
    
    let availableGenres: [String]

    let moods: [String: [String]] = [
        "Romantic-Uplifting": ["Romance", "Musical", "Animation"],
        "Make You Think": ["Science Fiction", "Mystery", "History", "Documentary"],
        "Tear-Jerking": ["Romance", "Drama", "Family"],
        "Thrilling-Intens": ["Action", "War", "Horror", "Thriller", "Crime"],
        "Exciting": ["Action", "Adventure", "Fantasy"],
        "Make You Laugh": ["Comedy"]
    ]

    let durations = ["<75 min", "75–120 min", ">120 min"]
    let platforms = ["Netflix", "Apple TV", "Disney +", "HBO"]
    let eras = ["Vintage < 2000","Gen A 2012 - 2024","Gen Z 2000 – 2011","Latest > 2024"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Mood
                    Text("Mood").font(.headline)
                    filterCapsules(options: Array(moods.keys).sorted(), selection: $selectedMood) { mood in
                        if let genres = moods[mood] {
                            selectedGenre = nil // Reset genre if mood is selected
                            print("Mood selected: \(mood), applying genres: \(genres.joined(separator: ", "))")
                        }
                    }
                    // Era
                    Text("Era").font(.headline)
                    filterCapsules(options: eras, selection: $selectedEras) // Placeholder
                    
//                    // Duration
//                    Text("Duration").font(.headline)
//                    filterCapsules(options: durations, selection: .constant(nil)) // Placeholder
//
//                    // Platform
//                    Text("Platform").font(.headline)
//                    filterCapsules(options: platforms, selection: .constant(nil)) // Placeholder
                }
                .padding()
            }
            .navigationTitle("Filter")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") {
                        selectedMood = nil
                        selectedEras = nil
                    }
                    .foregroundColor(.red)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func filterCapsules(
        options: [String],
        selection: Binding<String?>,
        onSelect: ((String) -> Void)? = nil
    ) -> some View {
        let columns = [GridItem(.adaptive(minimum: 120), spacing: 12)]
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(options, id: \.self) { option in
                Text(option)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .frame(minWidth: 180, minHeight: 50) // Ensure consistency
                    .background(
                        selection.wrappedValue == option ? Color.teal.opacity(0.8) : Color.gray.opacity(0.4)
                    )
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .onTapGesture {
                        if selection.wrappedValue == option {
                            selection.wrappedValue = nil
                        } else {
                            selection.wrappedValue = option
                            onSelect?(option)
                        }
                    }
            }
        }
    }
}

struct FilterInPlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        FilterInPlaylistView(
            selectedGenre: .constant(nil),
            selectedMood: .constant(nil),
            selectedEras: .constant(nil),
            availableGenres: ["Action", "Drama", "Romance", "Comedy"]
        )
        .previewDevice("iPhone 13")
        .previewLayout(.sizeThatFits)
    }
}
