//
//  CustomMovieScreenView.swift
//  MovieTime
//
//  Created by Артём Грищенко on 01.06.2023.
//

import Foundation
import UIKit
import SwiftUI
import PhotosUI
import Combine

struct CustomMovieScreenView: View {
    @ObservedObject var viewModel: CustomMovieViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    init(mode: CustomMovieViewModel.Mode) {
        _viewModel = ObservedObject(wrappedValue: CustomMovieViewModel(mode: mode))
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.appBackground.ignoresSafeArea()
            GeometryReader { geometry in
                ScrollView {
                    MoviePosterBox(
                        name: viewModel.nameField,
                        year: viewModel.selectedYear,
                        rating: nil,
                        genres: viewModel.selectedGenres,
                        durationString: viewModel.movieLengthFormatted,
                        posterView: AnyView(
                            ZStack {
                                Color.appPrimary200
                                if let image = viewModel.image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } else {
                                    VStack(spacing: 15) {
                                        Image(systemName: "camera")
                                            .foregroundColor(.white)
                                            .font(.system(size: 55))
                                        Text("Нажмите, чтобы добавить изображение")
                                            .font(.sf(.regular, size: 24))
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                            }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    viewModel.isShowPhotoLibrary = true
                                }
                        ),
                        geometry: geometry
                    )
                    .onChange(of: viewModel.inputImage) { _ in
                        guard let inputImage = viewModel.inputImage else { return }
                        viewModel.image = Image(uiImage: inputImage)
                    }
                    VStack(spacing: 0) {
                        SectionView(title: "Название фильма*", innerContent: AnyView(
                            CustomTextField(text: $viewModel.nameField, placeholder: "Например, Шоу Трумана")
                        ))
                        SectionView(title: "Описание", innerContent: AnyView(
                            CustomTextField(text: $viewModel.descriptionField, placeholder: "Пару слов о фильме")
                        ))
                        SectionView(title: "Год", innerContent: AnyView(
                            Picker("", selection: $viewModel.selectedYearIndex) {
                                ForEach(viewModel.availableYears.indices) { yearIndex in
                                    Text(String(viewModel.availableYears[yearIndex]))
                                        .foregroundColor(Color.appPrimary)
                                }
                            }
                                .pickerStyle(WheelPickerStyle())
                        ))
                        SectionView(title: "Продолжительность", innerContent: AnyView(
                            CustomTextField(text: $viewModel.movieLengthField, placeholder: "в минутах")
                                .keyboardType(.numberPad)
                                .onReceive(Just(viewModel.movieLengthField)) { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    if newValue.count > 5 {
                                        self.viewModel.movieLengthField = String(Array(newValue).prefix(5))
                                    }
                                    if filtered != newValue {
                                        self.viewModel.movieLengthField = filtered
                                    }
                                }
                        ))
                        GenreSelector(
                            genres: viewModel.genres,
                            selectedGenresIndexes: viewModel.selectedGenresIndexes,
                            onChange: viewModel.onChangeSelectedGenres
                        )
                        .padding(.top, 20)
                        if viewModel.showCreateButton {
                            CustomButton(
                                action: {
                                    presentationMode.wrappedValue.dismiss()
                                    viewModel.createMovie()
                                },
                                title: "Добавить фильм"
                            )
                            .padding(.top, 20)
                        }
                    }
                    .padding()
                }
                .ignoresSafeArea()
            }
            Image(R.image.icons.arrowBack.name)
                .background(
                    Circle()
                        .fill(Color.appBackground.opacity(0.95))
                        .frame(width: 45, height: 45)
                )
                .padding()
                .padding(.leading, 8)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $viewModel.isShowPhotoLibrary) {
            ImagePicker(image: $viewModel.inputImage)
        }
    }
}

struct CustomMovieScreenView_Previews: PreviewProvider {
    static var previews: some View {
        CustomMovieScreenView(mode: .create)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}

private struct SectionView: View {
    let title: String
    var paddingBottom: CGFloat = 20.0
    let innerContent: AnyView

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .bodyText3()
                .foregroundColor(.appTextWhite)
                .padding(.bottom, 4)
            innerContent
        }
        .padding(.bottom, paddingBottom)
    }
}

private struct CustomTextField: View {
    let text: Binding<String>
    let placeholder: String

    var body: some View {
        TextField(text: text) {
            Text(placeholder)
                .foregroundColor(.appSecondary300.opacity(0.5))
                .bodyText3()
        }
        .accentColor(.appPrimary)
        .foregroundColor(.appSecondary300)
    }
}
