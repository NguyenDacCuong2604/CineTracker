# 🎬 CineTracker

> Ứng dụng iOS quản lý phim cá nhân, được xây dựng bằng SwiftUI + Clean Architecture + MVVM-C. Đây là project học tập production-ready áp dụng đầy đủ các kỹ thuật iOS hiện đại.

![Platform](https://img.shields.io/badge/Platform-iOS%2017%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-purple)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-In%20Development-yellow)

---

## 📖 Mục lục

- [Giới thiệu](#-giới-thiệu)
- [Tính năng](#-tính-năng)
- [Tech Stack](#-tech-stack)
- [Kiến trúc](#-kiến-trúc)
- [Cấu trúc Project](#-cấu-trúc-project)
- [Yêu cầu](#-yêu-cầu)
- [Cài đặt](#-cài-đặt)
- [Cấu hình API Key](#-cấu-hình-api-key)
- [Roadmap & Phases](#-roadmap--phases)
- [Quy ước Coding](#-quy-ước-coding)
- [Git Workflow](#-git-workflow)
- [Testing](#-testing)
- [Tài liệu tham khảo](#-tài-liệu-tham-khảo)
- [License](#-license)

---

## 🎯 Giới thiệu

**CineTracker** là một ứng dụng iOS mô phỏng các app quản lý phim chuyên nghiệp như Letterboxd, Trakt và JustWatch. Project này được xây dựng với mục tiêu áp dụng toàn diện các kỹ thuật phát triển iOS hiện đại:

- ✅ SwiftUI declarative UI
- ✅ Clean Architecture + MVVM-C pattern
- ✅ Async/await concurrency
- ✅ Protocol-oriented programming
- ✅ Dependency Injection
- ✅ Offline-first với Realm
- ✅ Multi-layer caching
- ✅ Comprehensive testing

Dữ liệu phim được lấy từ **[TMDB API](https://www.themoviedb.org/documentation/api)** - một dịch vụ miễn phí với hơn 800,000 phim và TV shows.

---

## ✨ Tính năng

### Core Features

- 🔍 **Khám phá phim**: Trending, Popular, Top Rated, Upcoming
- 🔎 **Tìm kiếm**: Search phim theo tên với debounce
- 📝 **Watchlist cá nhân**: CRUD với swipe actions, batch operations
- ⭐ **Rating & Review**: Đánh giá và viết nhận xét cá nhân
- 🎥 **Chi tiết phim**: Cast, crew, trailer YouTube, similar movies
- 📊 **Statistics**: Dashboard với Swift Charts (genre, monthly, ratings)
- 🌙 **Dark Mode**: Hỗ trợ light/dark theme tự động

### Advanced Features

- 🔐 **Secure Storage**: API key trong Keychain
- 📱 **Home Screen Widget**: Hiển thị watchlist
- 🔔 **Push Notifications**: Nhắc phim sắp ra rạp
- 🌐 **Localization**: Tiếng Việt + English
- ♿️ **Accessibility**: VoiceOver, Dynamic Type
- 🔗 **Deep Linking**: Universal Links + URL Schemes
- 💾 **Offline Mode**: Hoạt động khi không có mạng
- 🎨 **Hero Animation**: Matched geometry transitions
- ↩️ **Undo Operations**: Hủy xóa với toast notification

---

## 🛠 Tech Stack

### Core

| Công nghệ | Phiên bản | Mục đích |
|-----------|-----------|----------|
| Swift | 5.9+ | Ngôn ngữ chính |
| SwiftUI | 5.0+ | UI Framework |
| iOS Target | 17.0+ | Dùng `@Observable` macro |
| Xcode | 15+ | IDE |

### Frameworks & Libraries

| Library | Mục đích |
|---------|----------|
| **RealmSwift** | Local database |
| **Swift Charts** | Biểu đồ thống kê |
| **WidgetKit** | Home screen widget |
| **UserNotifications** | Local notifications |
| **OSLog** | Structured logging |
| **WebKit** | Embed YouTube trailers |

### Development Tools

- **SwiftLint** - Code style enforcement
- **xcconfig** - Multi-environment configuration
- **GitHub Actions** - CI/CD
- **Fastlane** (optional) - Automation

---

## 🏗 Kiến trúc

Project sử dụng **Clean Architecture** với 3 layer chính, kết hợp **MVVM-C** ở Presentation layer.

```
┌─────────────────────────────────────────────┐
│           PRESENTATION LAYER                 │
│  ┌────────────┐  ┌──────────────────────┐   │
│  │   Views    │←→│     ViewModels       │   │
│  │ (SwiftUI)  │  │   (@Observable)      │   │
│  └────────────┘  └──────────┬───────────┘   │
│         ↑                   ↓                │
│  ┌─────────────────────────────────────┐    │
│  │       Coordinator (Navigation)       │    │
│  └─────────────────────────────────────┘    │
└─────────────────────┬───────────────────────┘
                      │ depends on
                      ▼
┌─────────────────────────────────────────────┐
│             DOMAIN LAYER                     │
│  ┌──────────────┐  ┌────────────────────┐   │
│  │  Use Cases   │  │  Domain Models     │   │
│  │  (Business)  │  │  (Pure Swift)      │   │
│  └──────────────┘  └────────────────────┘   │
│  ┌──────────────────────────────────────┐   │
│  │     Repository Protocols              │   │
│  └──────────────────────────────────────┘   │
└─────────────────────┬───────────────────────┘
                      │ implemented by
                      ▼
┌─────────────────────────────────────────────┐
│              DATA LAYER                      │
│  ┌──────────────┐  ┌────────────────────┐   │
│  │ Repositories │  │     Services       │   │
│  │              │  │  (API, Realm, Cache)│   │
│  └──────────────┘  └────────────────────┘   │
│  ┌──────────────────────────────────────┐   │
│  │     DTOs + Mappers                    │   │
│  └──────────────────────────────────────┘   │
└─────────────────────────────────────────────┘
```

### Nguyên tắc thiết kế

1. **Dependency Rule**: Inner layers không biết về outer layers
2. **Protocol-Oriented**: Mọi service đều có protocol để mock được
3. **Single Responsibility**: Mỗi class/struct làm 1 việc duy nhất
4. **Testability**: Toàn bộ business logic test được mà không cần UI

---

## 📁 Cấu trúc Project

```
CineTracker/
│
├── 📱 App/                              # App entry & DI
│   ├── CineTrackerApp.swift             # @main entry point
│   ├── AppDelegate.swift                # Push notifications
│   ├── DI/
│   │   ├── DIContainer.swift            # Dependency container
│   │   ├── ServiceAssembly.swift
│   │   └── RepositoryAssembly.swift
│   └── Environment/
│       ├── AppEnvironment.swift         # dev/staging/prod
│       └── Configuration.swift          # xcconfig wrapper
│
├── 🔧 Core/                             # Reusable utilities
│   ├── Network/
│   │   ├── APIClient.swift              # Protocol
│   │   ├── APIClientImpl.swift          # URLSession impl
│   │   ├── Endpoint.swift               # Enum endpoints
│   │   ├── HTTPMethod.swift
│   │   ├── NetworkMonitor.swift         # Reachability
│   │   ├── RequestInterceptor.swift     # Headers, retry
│   │   └── APIError.swift
│   │
│   ├── Storage/
│   │   ├── Realm/
│   │   │   ├── RealmManager.swift
│   │   │   ├── RealmMigration.swift     # Schema versioning
│   │   │   └── RealmRepository.swift    # Generic repo
│   │   ├── Cache/
│   │   │   ├── ImageCache.swift         # NSCache wrapper
│   │   │   ├── DiskCache.swift          # FileManager
│   │   │   └── MemoryCache.swift
│   │   ├── Keychain/
│   │   │   └── KeychainManager.swift    # Secure storage
│   │   └── Preferences/
│   │       └── UserPreferences.swift    # @AppStorage wrapper
│   │
│   ├── DesignSystem/                    # UI Foundation
│   │   ├── Colors.swift
│   │   ├── Typography.swift
│   │   ├── Spacing.swift
│   │   ├── Components/
│   │   │   ├── PrimaryButton.swift
│   │   │   ├── LoadingView.swift
│   │   │   ├── ErrorView.swift
│   │   │   ├── SkeletonView.swift
│   │   │   └── RatingView.swift
│   │   └── Modifiers/
│   │       ├── CardStyle.swift
│   │       └── ShimmerEffect.swift
│   │
│   ├── Navigation/
│   │   ├── AppCoordinator.swift
│   │   ├── Route.swift                  # Type-safe routes
│   │   ├── DeepLinkHandler.swift
│   │   └── TabCoordinator.swift
│   │
│   ├── Logger/
│   │   └── Logger.swift                 # OSLog wrapper
│   │
│   └── Extensions/
│       ├── View+Extensions.swift
│       ├── String+Extensions.swift
│       └── Date+Extensions.swift
│
├── 💾 Data/                             # Data layer
│   ├── Models/
│   │   ├── DTO/                         # API response
│   │   │   ├── MovieDTO.swift
│   │   │   ├── MovieDetailDTO.swift
│   │   │   ├── CastDTO.swift
│   │   │   └── VideoDTO.swift
│   │   ├── Domain/                      # Business models
│   │   │   ├── Movie.swift
│   │   │   ├── MovieDetail.swift
│   │   │   └── Cast.swift
│   │   ├── Realm/                       # Persistence
│   │   │   ├── SavedMovieObject.swift
│   │   │   └── ReviewObject.swift
│   │   └── Mappers/
│   │       └── MovieMapper.swift        # DTO → Domain
│   │
│   ├── Repositories/
│   │   ├── Protocols/
│   │   │   ├── MovieRepository.swift
│   │   │   └── WatchlistRepository.swift
│   │   └── Implementations/
│   │       ├── MovieRepositoryImpl.swift
│   │       └── WatchlistRepositoryImpl.swift
│   │
│   └── Services/
│       ├── MovieService.swift           # API calls
│       ├── ImageDownloader.swift
│       └── NotificationService.swift
│
├── 🧠 Domain/                           # Business logic
│   └── UseCases/
│       ├── FetchPopularMoviesUseCase.swift
│       ├── SearchMoviesUseCase.swift
│       ├── AddToWatchlistUseCase.swift
│       └── GetMovieStatisticsUseCase.swift
│
├── 🎨 Presentation/                     # Features
│   ├── Discover/
│   │   ├── DiscoverView.swift
│   │   ├── DiscoverViewModel.swift
│   │   ├── DiscoverState.swift
│   │   └── Components/
│   │       ├── MovieCarousel.swift
│   │       ├── HeroBanner.swift
│   │       └── CategorySection.swift
│   │
│   ├── Search/
│   │   ├── SearchView.swift
│   │   ├── SearchViewModel.swift
│   │   └── Components/
│   │       ├── SearchBar.swift
│   │       ├── RecentSearchesView.swift
│   │       └── FilterSheet.swift
│   │
│   ├── MovieDetail/
│   │   ├── MovieDetailView.swift
│   │   ├── MovieDetailViewModel.swift
│   │   ├── Components/
│   │   │   ├── ParallaxHeader.swift
│   │   │   ├── CastSection.swift
│   │   │   ├── TrailerPlayer.swift
│   │   │   └── SimilarMoviesSection.swift
│   │   └── AddReview/
│   │       ├── AddReviewSheet.swift
│   │       └── AddReviewViewModel.swift
│   │
│   ├── Watchlist/
│   │   ├── WatchlistView.swift
│   │   ├── WatchlistViewModel.swift
│   │   └── Components/
│   │       ├── WatchlistRow.swift
│   │       ├── EmptyWatchlistView.swift
│   │       └── FilterChips.swift
│   │
│   ├── Statistics/
│   │   ├── StatisticsView.swift
│   │   ├── StatisticsViewModel.swift
│   │   └── Charts/
│   │       ├── GenreChart.swift
│   │       └── MonthlyChart.swift
│   │
│   └── Profile/
│       ├── ProfileView.swift
│       ├── SettingsView.swift
│       └── AboutView.swift
│
├── 📦 Resources/
│   ├── Assets.xcassets
│   ├── Localizable.strings (en)
│   ├── Localizable.strings (vi)
│   ├── Fonts/
│   ├── Info.plist
│   ├── Debug.xcconfig
│   └── Release.xcconfig
│
├── 🧩 CineTrackerWidget/                # Widget Extension
│   └── WatchlistWidget.swift
│
├── 🧪 CineTrackerTests/                 # Unit tests
│   ├── ViewModels/
│   ├── UseCases/
│   ├── Repositories/
│   └── Mocks/
│
└── 🎭 CineTrackerUITests/               # UI tests
    └── DiscoverFlowTests.swift
```

---

## 📋 Yêu cầu

### Hệ thống

- **macOS**: Sonoma 14.0+ (khuyến nghị Sequoia 15+)
- **Xcode**: 15.0+
- **iOS Simulator**: iOS 17.0+
- **Swift**: 5.9+

### Tài khoản

- [TMDB Account](https://www.themoviedb.org/signup) (miễn phí) để lấy API key
- Apple Developer Account (chỉ cần khi test trên device thật hoặc submit App Store)

---

## 🚀 Cài đặt

### 1. Clone repository

```bash
git clone https://github.com/<your-username>/CineTracker.git
cd CineTracker
```

### 2. Cài đặt dependencies

Project sử dụng **Swift Package Manager**, dependencies sẽ tự động resolve khi mở Xcode.

Mở project bằng Xcode:

```bash
open CineTracker.xcodeproj
```

Hoặc nếu dùng workspace:

```bash
open CineTracker.xcworkspace
```

### 3. Cấu hình API Key

Xem chi tiết ở phần [Cấu hình API Key](#-cấu-hình-api-key) bên dưới.

### 4. Chọn Scheme & Build

- Scheme: `CineTracker-Debug` (development) hoặc `CineTracker-Release` (production)
- Target: iPhone 15 Pro Simulator (hoặc thiết bị thật)
- Build: `⌘ + B`
- Run: `⌘ + R`

---

## 🔑 Cấu hình API Key

### Bước 1: Đăng ký TMDB API Key

1. Truy cập [TMDB](https://www.themoviedb.org/) và tạo tài khoản
2. Vào [Settings → API](https://www.themoviedb.org/settings/api)
3. Request API key (Developer, free tier)
4. Copy `API Read Access Token (v4 auth)`

### Bước 2: Tạo file Secrets.xcconfig

Tạo file `Resources/Secrets.xcconfig` (file này **không commit** lên Git):

```
// Secrets.xcconfig
// CẢNH BÁO: KHÔNG commit file này lên Git!

TMDB_API_KEY = your_api_key_here
TMDB_BASE_URL = https:/$()/api.themoviedb.org/3
TMDB_IMAGE_BASE_URL = https:/$()/image.tmdb.org/t/p
```

> ⚠️ **Lưu ý**: Trong xcconfig, ký tự `//` được coi là comment. Dùng `$()` để escape: `https:/$()/api...`

### Bước 3: Verify .gitignore

Đảm bảo file `.gitignore` đã có:

```gitignore
# Secrets
Resources/Secrets.xcconfig
*.xcconfig.local
```

### Bước 4: Build & Run

API key sẽ được đọc từ `Info.plist` thông qua `Configuration.swift` và lưu vào Keychain ở lần chạy đầu tiên.

---

## 🗓 Roadmap & Phases

Project được chia thành **10 phase**, mỗi phase tập trung vào một mảng kiến thức cụ thể.

### Phase 1: Foundation & Setup `🔴 Critical`
**Thời gian**: 3-4 ngày | **Branch**: `feature/phase-1-foundation`

- [ ] Khởi tạo Xcode project (iOS 17+, SwiftUI)
- [ ] Setup SPM dependencies (Realm)
- [ ] Cấu hình multi-environment (`.xcconfig`)
- [ ] Setup `OSLog` logger
- [ ] Setup SwiftLint
- [ ] Cấu hình `.gitignore`
- [ ] Đăng ký TMDB API + lưu Keychain

**Keywords học**: `Xcode xcconfig multiple environments`, `Swift OSLog production`, `SwiftLint configuration`, `Swift Keychain Services`

---

### Phase 2: Design System `🔴 Critical`
**Thời gian**: 3-4 ngày | **Branch**: `feature/phase-2-design-system`

- [ ] Color palette (light + dark mode)
- [ ] Typography scale
- [ ] Spacing system
- [ ] Core components (Button, Loading, Error, Empty, Rating, Skeleton)
- [ ] Custom ViewModifiers (`.cardStyle()`, `.shimmer()`)
- [ ] Design System Catalog preview

**Keywords học**: `SwiftUI design system`, `SwiftUI custom ViewModifier`, `SwiftUI shimmer effect`, `SwiftUI Color asset catalog`

---

### Phase 3: Networking Layer `🔴 Critical`
**Thời gian**: 4-5 ngày | **Branch**: `feature/phase-3-networking`

- [ ] `APIClient` protocol + impl với async/await
- [ ] Generic `request<T: Decodable>`
- [ ] `Endpoint` enum
- [ ] `RequestInterceptor` (auth, retry)
- [ ] `NetworkMonitor` (NWPathMonitor)
- [ ] `APIError` chi tiết
- [ ] Task cancellation
- [ ] Mock APIClient cho test

**Keywords học**: `Swift async await URLSession production`, `Swift NWPathMonitor`, `Swift Task cancellation`, `Swift generic network layer`

---

### Phase 4: Data Layer - Repository Pattern `🔴 Critical`
**Thời gian**: 3-4 ngày | **Branch**: `feature/phase-4-data-layer`

- [ ] DTO models (Codable)
- [ ] Domain models (pure Swift)
- [ ] Mappers (DTO → Domain)
- [ ] `MovieRepository` với cache strategy
- [ ] `WatchlistRepository` với Realm
- [ ] Generic `RealmRepository<T>`
- [ ] Realm Migration setup
- [ ] 3-layer ImageCache (Memory → Disk → Network)

**Keywords học**: `Swift Repository pattern`, `Realm Swift migration`, `iOS image caching NSCache`, `Swift DTO Domain mapping`

---

### Phase 5: Discover Tab `🔴 Critical`
**Thời gian**: 4-5 ngày | **Branch**: `feature/phase-5-discover`

- [ ] `TabView` với 5 tab
- [ ] `DiscoverView` với multiple sections
- [ ] Hero Banner auto-scroll
- [ ] `LazyHGrid` horizontal carousels
- [ ] `MoviePosterCard` component
- [ ] Parallax scroll effect
- [ ] Pull to refresh
- [ ] `@Observable` ViewModel
- [ ] `ViewState<T>` enum
- [ ] Skeleton loading

**Keywords học**: `SwiftUI TabView paged`, `SwiftUI parallax scroll`, `SwiftUI @Observable iOS 17`, `SwiftUI refreshable`

---

### Phase 6: Navigation & Deep Linking `🔴 Critical`
**Thời gian**: 3-4 ngày | **Branch**: `feature/phase-6-navigation`

- [ ] `AppCoordinator` với `NavigationPath`
- [ ] Type-safe `Route` enum
- [ ] `.navigationDestination(for:)` setup
- [ ] Programmatic navigation
- [ ] URL Scheme: `cinetracker://`
- [ ] Universal Links
- [ ] State restoration

**Keywords học**: `SwiftUI NavigationStack Coordinator`, `iOS deep link URL scheme`, `iOS Universal Links setup`, `SwiftUI onOpenURL`

---

### Phase 7: Movie Detail + Sheets `🔴 Critical`
**Thời gian**: 5-6 ngày | **Branch**: `feature/phase-7-movie-detail`

- [ ] Parallax header với backdrop
- [ ] Info section + genre chips
- [ ] Cast & Crew horizontal scroll
- [ ] YouTube trailer embed
- [ ] Similar Movies section
- [ ] Action buttons (Watchlist, Watched, Share)
- [ ] Add Review Sheet (rating, text, date, photo)
- [ ] Alert error handling
- [ ] Hero animation transition

**Keywords học**: `SwiftUI parallax header GeometryReader`, `SwiftUI WKWebView YouTube`, `SwiftUI matchedGeometryEffect`, `SwiftUI sheet detents`

---

### Phase 8: Watchlist + CRUD `🔴 Critical`
**Thời gian**: 4-5 ngày | **Branch**: `feature/phase-8-watchlist`

- [ ] List view + Grid view toggle
- [ ] Filter chips (All, Want, Watched, Favorites)
- [ ] Sort options
- [ ] Local search trong Realm
- [ ] Swipe Actions (delete, mark watched)
- [ ] Context Menu
- [ ] Batch selection mode
- [ ] Undo delete với toast
- [ ] Empty state
- [ ] Smooth animations

**Keywords học**: `SwiftUI List swipeActions`, `SwiftUI contextMenu`, `SwiftUI EditMode multi-selection`, `Realm Swift query`

---

### Phase 9: Statistics & Charts `🟡 Nice to have`
**Thời gian**: 3-4 ngày | **Branch**: `feature/phase-9-statistics`

- [ ] Swift Charts setup
- [ ] Summary cards
- [ ] Bar chart (monthly)
- [ ] Pie chart (genres)
- [ ] Line chart (rating trend)
- [ ] Top 10 list
- [ ] Calendar heatmap

**Keywords học**: `Swift Charts iOS 16 tutorial`, `Swift Charts customization`, `SwiftUI calendar heatmap`

---

### Phase 10: Polish, Testing, Widget, Localization `🟡 Nice to have`
**Thời gian**: 5-7 ngày | **Branch**: `feature/phase-10-polish`

- [ ] Localization (en, vi)
- [ ] Accessibility (VoiceOver, Dynamic Type)
- [ ] Widget Extension
- [ ] Push Notifications
- [ ] Unit tests (ViewModels, UseCases)
- [ ] UI tests (happy paths)
- [ ] Snapshot tests (optional)
- [ ] CI/CD với GitHub Actions

**Keywords học**: `iOS String Catalog xcstrings`, `SwiftUI accessibility`, `iOS WidgetKit tutorial`, `Swift unit test ViewModel async`, `GitHub Actions iOS`

---

## ✍️ Quy ước Coding

### Naming Conventions

```swift
// Types: PascalCase
struct MovieDetail { }
class MovieViewModel { }
protocol MovieRepository { }
enum APIError { }

// Variables & functions: camelCase
let movieTitle = "Inception"
func fetchPopularMovies() async throws { }

// Constants: camelCase (không UPPER_CASE)
static let maxRetryCount = 3

// Private properties: prefix _ KHÔNG dùng
// Dùng `private` keyword thay vì _
private var cache: [String: Movie] = [:]
```

### File Organization

```swift
// MARK: - Properties
private let repository: MovieRepository
@Published var movies: [Movie] = []

// MARK: - Initialization
init(repository: MovieRepository) {
    self.repository = repository
}

// MARK: - Public Methods
func fetchMovies() async { }

// MARK: - Private Methods
private func handleError(_ error: Error) { }
```

### SwiftUI Best Practices

- ✅ Tách subview khi `body` quá 50 dòng
- ✅ Dùng `@ViewBuilder` cho conditional views
- ✅ Extract complex views thành computed properties (`private var headerView: some View`)
- ❌ Không dùng `AnyView` trừ khi thực sự cần
- ❌ Không nested quá 3 levels of containers

### Async/Await

```swift
// ✅ Tốt: rõ ràng và type-safe
func fetchMovie(id: Int) async throws -> Movie {
    try await repository.movie(id: id)
}

// ❌ Tránh: completion handler trừ khi bắt buộc
func fetchMovie(id: Int, completion: @escaping (Result<Movie, Error>) -> Void) { }
```

---

## 🔀 Git Workflow

### Branch Naming

```
main                           # Production
develop                        # Integration branch
feature/phase-N-description    # Feature branches
bugfix/issue-description       # Bug fixes
hotfix/critical-issue          # Production hotfixes
```

### Commit Convention

Theo [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

**Types**:
- `feat`: Tính năng mới
- `fix`: Sửa bug
- `docs`: Cập nhật documentation
- `style`: Format code, không đổi logic
- `refactor`: Refactor code
- `test`: Thêm/sửa tests
- `chore`: Build, dependencies, config

**Examples**:

```
feat(network): add APIClient with async/await support

Implement protocol-based APIClient with URLSession.
Add generic request method with Decodable constraint.
Add APIError with detailed error cases.

Closes #12
```

```
fix(watchlist): resolve crash when deleting last item

Realm transaction was not properly cancelled when
the result was empty. Added guard check.
```

```
refactor(discover): extract MovieCarousel to component
docs(readme): update Phase 3 keywords
chore(deps): bump RealmSwift to 10.45.0
```

### Pull Request Process

1. Tạo branch từ `develop`: `git checkout -b feature/phase-3-networking develop`
2. Commit theo convention
3. Push: `git push origin feature/phase-3-networking`
4. Tạo PR vào `develop` với template
5. Self-review trước khi merge
6. Squash merge để giữ history clean

---

## 🧪 Testing

### Chạy tests

```bash
# Unit tests
xcodebuild test -scheme CineTracker \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro'

# UI tests
xcodebuild test -scheme CineTrackerUITests \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro'

# Hoặc trong Xcode: ⌘ + U
```

### Coverage Goals

| Layer | Target Coverage |
|-------|----------------|
| Use Cases | 90%+ |
| ViewModels | 80%+ |
| Repositories | 80%+ |
| Mappers | 100% |
| Views | 30%+ (snapshot tests) |

### Mocking Strategy

Mọi service đều có protocol → tạo Mock dễ dàng:

```swift
final class MockMovieRepository: MovieRepository {
    var moviesToReturn: [Movie] = []
    var shouldThrowError = false
    
    func popularMovies() async throws -> [Movie] {
        if shouldThrowError { throw APIError.networkUnavailable }
        return moviesToReturn
    }
}
```

---

## 📚 Tài liệu tham khảo

### Official Docs

- [Apple Developer - SwiftUI](https://developer.apple.com/documentation/swiftui)
- [Swift Language Guide](https://docs.swift.org/swift-book/)
- [Swift Concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

### Architecture

- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [iOS Clean Architecture - kudoleh](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM)
- [Point-Free Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture)

### Libraries

- [RealmSwift Documentation](https://www.mongodb.com/docs/realm/sdk/swift/)
- [Swift Charts Tutorial](https://developer.apple.com/documentation/charts)

### API

- [TMDB API Documentation](https://developer.themoviedb.org/docs)
- [TMDB API Reference](https://developer.themoviedb.org/reference/intro/getting-started)

### Communities

- [Hacking with Swift](https://www.hackingwithswift.com/)
- [Swift by Sundell](https://www.swiftbysundell.com/)
- [Point-Free](https://www.pointfree.co/)
- [r/iOSProgramming](https://www.reddit.com/r/iOSProgramming/)

---

## 🤝 Đóng góp

Đây là project học tập cá nhân. Tuy nhiên, nếu bạn có gợi ý hoặc tìm thấy bug, feel free tạo Issue hoặc PR.

### Reporting Bugs

Khi tạo issue, vui lòng cung cấp:
- iOS version + Device model
- Xcode version
- Steps to reproduce
- Expected vs actual behavior
- Screenshots (nếu có)

---

## 📄 License

Project này được phát hành dưới [MIT License](LICENSE).

```
MIT License

Copyright (c) 2026 <Your Name>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software...
```

---

## 🙏 Acknowledgements

- [TMDB](https://www.themoviedb.org/) - Free movie data API
- [Letterboxd](https://letterboxd.com/) - Design inspiration
- [Apple](https://developer.apple.com/) - SwiftUI & iOS frameworks

---

## 📞 Liên hệ

- **Author**: `<Your Name>`
- **Email**: `<your.email@example.com>`
- **GitHub**: [@your-username](https://github.com/your-username)
- **LinkedIn**: [Your LinkedIn](https://linkedin.com/in/your-profile)

---

<div align="center">

**⭐ Nếu project này hữu ích, hãy cho mình một star nhé! ⭐**

Made with ❤️ and ☕ in Vietnam

</div>
