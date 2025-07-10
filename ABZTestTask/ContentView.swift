import SwiftUI
import Kingfisher

struct ContentView: View {
    
    @State private var isActive = false
    
    private let userEventService = UserEventService()
    private let splashScreenDelay = 2.0

    var body: some View {
        Group {
            if isActive {
                MainTabView()
                    .environment(\.userEventService, userEventService)
            } else {
                SplashScreenView()
            }
        }
        .onAppear {
            /// Отрабатываем анимацию и можем создать пространство для preload сервисов, кэша и тд
            preloadCachedImages()
            DispatchQueue.main.asyncAfter(deadline: .now() + splashScreenDelay) {
                isActive.toggle()
            }
        }
    }
    
    private func preloadCachedImages() {
        let urls = Persistance.avatarUrlStrings.compactMap { URL(string: $0) }
        let prefetcher = ImagePrefetcher(
            urls: urls,
            options: [.transition(.fade(0.2))],
            progressBlock: nil
        )
        prefetcher.start()
    }
}
