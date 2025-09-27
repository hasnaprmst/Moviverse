////
////  FilterView.swift
////  MyMovieList
////
////  Created by Hasna Paramesti Ahmad on 06/05/25.
////
//
//import SwiftUI
//import Foundation
//
//struct FilterView: View {
//    @Environment(\.dismiss) var dismiss
//
//    @Binding var appliedFilter: Filter?
//    let onApply: (Filter) -> Void
//
//    @State private var selectedDuration = "75–120 min"
//    @State private var selectedPlatform = "Apple TV"
//    @State private var selectedMood = "Menegangkan"
//    @State private var selectedEra = "Terbaru >2024"
//
//    let durations = ["<75 min", "75–120 min", ">120 min"]
//    let platforms = ["Netflix", "Apple TV", "Disney+", "HBO"]
//    let moods = ["Bahagia", "Bikin Mikir", "Menguras Air Mata", "Menegangkan", "Seru", "Berbunga-bunga"]
//    let eras = ["Terbaru >2024", "Gen Alpha (2012–2024)", "Gen Z (2000–2011)", "Jadul (<2000)"]
//
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 16) {
//                ScrollView {
//                    VStack(spacing: 24) {
//                        FilterSection(title: "Durasi", options: durations, selection: $selectedDuration)
//                        FilterSection(title: "Platform", options: platforms, selection: $selectedPlatform)
//                        FilterSection(title: "Mood", options: moods, selection: $selectedMood)
//                        FilterSection(title: "Era", options: eras, selection: $selectedEra)
//                    }
//                    .padding(.horizontal)
//                }
//            }
//            .navigationTitle("Filter")
//            .navigationBarTitleDisplayMode(.inline)
//            .presentationDetents([.medium, .large])
//            .padding(.bottom, 10)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Terapkan") {
//                        let newFilter = Filter(
//                            duration: selectedDuration,
//                            platform: selectedPlatform,
//                            mood: selectedMood,
//                            era: selectedEra
//                        )
//                        onApply(newFilter)
//                        dismiss()
//                    }
//                }
//            }
//            .onAppear {
//                // Optional: Load filter sebelumnya saat sheet dibuka
//                if let existing = appliedFilter {
//                    selectedDuration = existing.duration ?? selectedDuration
//                    selectedPlatform = existing.platform ?? selectedPlatform
//                    selectedMood = existing.mood ?? selectedMood
//                    selectedEra = existing.era ?? selectedEra
//                }
//            }
//        }
//    }
//}
//
//struct FilterSection: View {
//    var title: String
//    var options: [String]
//    @Binding var selection: String
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text(title)
//                .font(.headline)
//
//            LazyVGrid(columns: [GridItem(.adaptive(minimum: 110))], spacing: 10) {
//                ForEach(options, id: \.self) { option in
//                    Button {
//                        selection = option
//                    } label: {
//                        Text(option)
//                            .font(.subheadline)
//                            .foregroundColor(selection == option ? .white : .primary)
//                            .padding(.vertical, 10)
//                            .frame(maxWidth: .infinity)
//                            .background(selection == option ? Color.blue : Color.gray.opacity(0.2))
//                            .clipShape(Capsule())
//                    }
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    struct FilterViewPreviewWrapper: View {
//        @State private var filter: Filter? = nil
//        
//        var body: some View {
//            FilterView(appliedFilter: $filter) { selectedFilter in
//                print("🎯 Filter diterapkan di Preview: \(selectedFilter)")
//            }
//        }
//    }
//
//    return FilterViewPreviewWrapper()
//}
