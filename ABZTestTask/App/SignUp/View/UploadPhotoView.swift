import SwiftUI

struct UploadPhotoView: View {
    
    @ObservedObject var viewModel: SignUpViewModel

    @State private var showActionSheet = false
    @State private var showImagePicker = false
    @State private var showPhotoPicker = false

    var borderColor: Color {
        viewModel.isNeedShowPhotoError ? .error : .noNamedTFBorder
    }

    var body: some View {
        VStack(alignment: .leading) {
            Button {
                showActionSheet = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor, lineWidth: 1)
                        .frame(height: 56)
                    HStack(spacing: 0) {
                        Text(LocalizeStrings.uploadYourPhoto)
                            .font(FontName.regular.fontNunitoSansFontWeightSans(16))
                            .foregroundColor(borderColor)
                        Spacer()
                        Text(viewModel.selectedImage != nil ? LocalizeStrings.imageSelected : LocalizeStrings.upload)
                            .font(FontName.regular.fontNunitoSansFontWeightSans(16))
                            .foregroundStyle(.baseSecondary)
                    }
                    .padding()
                }
            }
            .confirmationDialog(LocalizeStrings.choosePhoto, isPresented: $showActionSheet, titleVisibility: .visible) {
                Button(LocalizeStrings.camera) {
                    showImagePicker = true
                    viewModel.isNeedShowPhotoError = false
                }
                Button(LocalizeStrings.gallery) {
                    showPhotoPicker = true
                    viewModel.isNeedShowPhotoError = false
                }
                Button(LocalizeStrings.cancel, role: .cancel) {}
            }

            if viewModel.isNeedShowPhotoError {
                Text(LocalizeStrings.photoRequired)
                    .font(FontName.regular.fontNunitoSansFontWeightSans(12))
                    .foregroundColor(borderColor)
                    .padding(.leading, 16)
            }
        }
        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePicker(selectedImageData: $viewModel.selectedImage)
                .background(Color.black)
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $viewModel.selectedImageItem, matching: .images)
    }
}
