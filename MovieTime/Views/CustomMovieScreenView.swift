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

struct CustomMovieScreenView: View {
    @State var movieLength: String = ""
    @State var isShowPhotoLibrary = false
    @State private var image: Image?
    @State private var inputImage: UIImage?
    
    @State var facts: [String] = ["для", "кря"]
    
    @ObservedObject var viewModel: CustomMovieViewModel

    init(mode: CustomMovieViewModel.Mode) {
        _viewModel = ObservedObject(wrappedValue: CustomMovieViewModel(mode: mode))
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            GeometryReader { geometry in
                ScrollView {
                    MoviePosterBox(
                        name: viewModel.nameField,
                        year: viewModel.selectedYear,
                        rating: 5.0,
                        posterView: AnyView(
                            ZStack {
                                Color.appPrimary200
                                image?
                                    .resizable()
                                    .scaledToFill()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                print("sdfsdf")
                                isShowPhotoLibrary = true
                            }
                        ),
                        geometry: geometry
                    )
                    .onChange(of: inputImage) { _ in
                        guard let inputImage = inputImage else { return }
                        image = Image(uiImage: inputImage)
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
                            CustomTextField(text: $movieLength, placeholder: "в минутах")
                        ))
                        VStack(alignment: .leading) {
                            Text("Жанры")
                                .bodyText5()
                                .foregroundColor(.white)
                            LazyVGrid(
                                columns: [GridItem(.flexible()), GridItem(.flexible())],
                                spacing: 20
                            ) {
                                let categories = FilterCategoryModel.generateCategories()
                                ForEach(categories.indices, id: \.self) { index in
                                    let category = categories[index]
                                    CustomCheckbox(
                                        checked: false,
                                        onCheck: {
                                        },
                                        title: category.name,
                                        isDisabled: false
                                    )
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 23)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        Image(category.pictureName)
                                            .resizable()
                                            .cornerRadius(8)
                                    )
                                    .onTapGesture {
                                        //                                    viewModel.onChooseFilterCategory(category.id)
                                    }
                                    //                                .opacity(viewModel.filterCategoriesVisibility[index] ? 1 : 0)
                                }
                            }
                        }
                        SectionView(title: "Факты", innerContent: AnyView(
                            VStack(alignment: .leading) {
                                ForEach(facts.indices) { factIndex in
                                    TextField(text: $facts[factIndex]) {
                                        Text("Факт \(factIndex + 1)")
                                            .foregroundColor(.appSecondary300.opacity(0.5))
                                            .bodyText3()
                                    }
                                    .accentColor(.appPrimary)
                                    .foregroundColor(.appSecondary300)
                                }
                                Button("Добавить факт") {
                                    
                                }
                                .foregroundColor(.appPrimary)
                            }
                        ))
                    }
                    .padding()
                }
                .ignoresSafeArea()
                
            }
            .ignoresSafeArea()
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(image: $inputImage)
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
