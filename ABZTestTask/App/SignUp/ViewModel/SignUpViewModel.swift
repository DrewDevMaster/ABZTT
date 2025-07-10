import SwiftUI
import PhotosUI

@Observable
final class SignUpViewModel: ObservableObject {
    var name = ""
    var email = ""
    var phone = ""
    var selectedPositionId: Int?
    var isNeedShowPhotoError = false
    
    var selectedImage: Data?
    var positions: [Position] = []
    var selectedImageItem: PhotosPickerItem? {
        didSet { transformAndResizePhotosPickerItemToData() }
    }
    var showSuccess = false
    var showError = false
    var errorMessage = ""
    var isLoading = false
    
    @ObservationIgnored
    private let cache: JSONCacheManager
    @ObservationIgnored
    private let userFetchingService: UserFetchingServiceProtocol
    
    @ObservationIgnored
    var isValidParams: Bool {
        !name.isEmpty && email.isValidEmail() && phone.isValidPhoneNumber()
    }
    
    init(
        cache: JSONCacheManager = JSONCacheManager(),
        userFetchingService: UserFetchingServiceProtocol)
    {
        self.cache = cache
        self.userFetchingService = userFetchingService
    }
    
    func getPositions() {
        NetworkManager.getPositions { [weak self] model in
            self?.positions = model.positions
            self?.cache.save(PositionsResponse.self, data: model.data)
        } failure: { [weak self] error in
            self?.errorMessage = error.displayMessage
            self?.showError = true
        }
    }
    
    func preloadCache() {
        Task(priority: .high) {
            guard let cache = cache.load(PositionsResponse.self) else { return }
            await MainActor.run {
                self.positions = cache.positions
            }
        }
    }
    
    func register() async {
        guard let image = selectedImage else {
            isNeedShowPhotoError = true
            return
        }
        guard isValidParams, let selectedPositionId else { return }
        isLoading = true
        NetworkManager.registerUser(name: name, email: email, phone: phone, positionId: selectedPositionId, photo: image) { [weak self] response in
            defer { self?.isLoading = false }
            guard let self else { return }
            self.userFetchingService.fetchUserAndNotify(id: response.userId)
            self.showSuccess = true
            self.resetForm()
        } failure: { [weak self] error in
            self?.errorMessage = error.displayMessage
            self?.showError = true
            self?.isLoading = false
        }
    }
}

private extension SignUpViewModel {
    
    private func transformAndResizePhotosPickerItemToData() {
        Task(priority: .userInitiated) {
            do {
                let data = try await selectedImageItem?.loadTransferable(type: Data.self)
                guard let data, let uiImage = UIImage(data: data) else { return }
                let image = resizeImage(image: uiImage, targetSize: CGSize(width: 70, height: 70))
                let finalData = image.jpegData(compressionQuality: 1)
                
                await MainActor.run {
                    selectedImage = finalData
                    isNeedShowPhotoError = false
                }
            } catch {
                await MainActor.run {
                    selectedImage = nil
                    isNeedShowPhotoError = true
                }
                print("Transform error \(error)")
            }
        }
    }

    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    private func resetForm() {
        name = ""
        email = ""
        phone = ""
        selectedImage = nil
        selectedImageItem = nil
    }
}
