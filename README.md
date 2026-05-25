# CineTracker

> Personal iOS movie tracking app built with SwiftUI, Clean Architecture, and MVVM.
> Portfolio-friendly presentation + production-style technical documentation.

![Platform](https://img.shields.io/badge/Platform-iOS%2017%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-5f9ea0)
![License](https://img.shields.io/badge/License-MIT-green)

## Table of Contents

- [Portfolio Overview](#portfolio-overview)
- [Feature Highlights](#feature-highlights)
- [Demo Shots](#demo-shots)
- [Technical Documentation](#technical-documentation)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Deep Link](#deep-link)
- [Localization](#localization)
- [Dependencies](#dependencies)
- [License](#license)

## Portfolio Overview

CineTracker là ứng dụng iOS giúp quản lý danh sách phim cá nhân theo hướng hiện đại:

- Khám phá phim từ TMDB
- Theo dõi watchlist cá nhân
- Đánh giá và ghi chú phim đã xem
- Trực quan hóa thói quen xem phim bằng biểu đồ
- Hỗ trợ Widget + Deep Link + đa ngôn ngữ

Mục tiêu của project:

- Thể hiện khả năng xây app iOS end-to-end bằng SwiftUI
- Áp dụng kiến trúc sạch, dễ mở rộng, dễ test
- Tổ chức code theo chuẩn thực tế để có thể nâng cấp production

## Feature Highlights

### Discover
- Nạp danh sách `Popular`, `Top Rated`, `Upcoming`, `Now Playing`
- UI theo section/carousel, điều hướng tới chi tiết phim

### Search
- Tìm kiếm phim theo tên
- Lưu và quản lý recent searches

### Movie Detail
- Hiển thị thông tin chi tiết phim
- Danh sách cast
- Trailer YouTube
- Similar movies
- Chia sẻ deep link phim

### Watchlist
- Thêm/Xóa phim
- Đánh dấu đã xem
- Đánh giá và review cá nhân
- Đánh dấu yêu thích
- Lọc, sắp xếp, tìm kiếm
- Batch remove + khôi phục

### Statistics
- Dashboard thống kê từ dữ liệu watchlist:
  - Monthly bar chart
  - Genre pie chart
  - Rating distribution
  - Activity heatmap
  - Top rated movies

### Profile & Settings
- Cấu hình ngôn ngữ `vi/en`
- Màn hình cài đặt cơ bản

### Widget & Deep Link
- Widget hiển thị nhanh phim trong watchlist
- Deep link:
  - `cinetracker://movie/{id}`
  - `cinetracker://watchlist`

## Demo Shots

Thêm screenshot vào thư mục `docs/images` rồi cập nhật links bên dưới:

```md
![Discover](docs/images/discover.png)
![Movie Detail](docs/images/movie-detail.png)
![Watchlist](docs/images/watchlist.png)
![Statistics](docs/images/statistics.png)
![Widget](docs/images/widget.png)
```

## Technical Documentation

Phần này tập trung vào chi tiết kỹ thuật để reviewer/dev có thể đọc nhanh cấu trúc và cách chạy project.

## Architecture

### High-level

- `Presentation`: SwiftUI Views + ViewModels
- `Domain`: Entities, Repository protocols, UseCases
- `Data`: Repository implementations, API client, DTO/Mapper, Realm persistence
- `Core`: Design system, navigation, localization, logger, cache, keychain
- `App`: entry point, environment, DI container

### Data Flow

1. View trigger action tới ViewModel.
2. ViewModel gọi UseCase.
3. UseCase làm việc qua Repository protocol.
4. Data layer triển khai repository, gọi network/local DB.
5. Kết quả map về domain model và trả lại Presentation.

### Dependency Injection

`DIContainer` cung cấp:
- `APIClient`
- `MovieRepository`
- `WatchlistRepository`
- `RecentSearchesRepository`
- Toàn bộ UseCases theo feature

### Persistence

- Realm lưu watchlist/review dữ liệu cục bộ
- Sử dụng App Group Realm để app + widget đọc chung dữ liệu

### Networking

- `APIClientImpl` dựa trên `URLSession` + async/await
- `Endpoint` định nghĩa path/query thống nhất
- Error mapping rõ ràng (`APIError`)
- Retry logic trong request interceptor

## Project Structure

```text
CineTracker/
├─ App/
│  ├─ CineTrackerApp.swift
│  ├─ DI/
│  └─ Environment/
├─ Core/
│  ├─ DesignSystem/
│  ├─ Localization/
│  ├─ Logger/
│  ├─ Navigation/
│  └─ Storage/
├─ Data/
│  ├─ DTOs/
│  ├─ Mappers/
│  ├─ Network/
│  ├─ Realm/
│  └─ Repositories/
├─ Domain/
│  ├─ Entities/
│  ├─ Repositories/
│  └─ UseCases/
├─ Presentation/
│  ├─ Discover/
│  ├─ Search/
│  ├─ MovieDetail/
│  ├─ Watchlist/
│  ├─ Statistics/
│  ├─ Profile/
│  └─ CastDetail/
├─ Resources/
├─ CineTrackerWidget/
└─ CineTracker.xcodeproj/
```

## Tech Stack

- Swift 5.9+
- SwiftUI (iOS 17+)
- Combine
- Async/Await
- RealmSwift
- YouTubePlayerKit
- Swift Charts
- WidgetKit
- OSLog

## Getting Started

### 1. Clone repository

```bash
git clone https://github.com/<your-username>/CineTracker.git
cd CineTracker
```

### 2. Create secrets file

Tạo file `CineTracker/Resources/Secrets.xcconfig`:

```xcconfig
TMDB_API_KEY = your_api_key_here
TMDB_BASE_URL = https:/$()/api.themoviedb.org/3
TMDB_IMAGE_BASE_URL = https:/$()/image.tmdb.org/t/p
ENABLE_VERBOSE_LOGGING = YES
```

Lưu ý: dùng `https:/$()/...` trong `.xcconfig` để tránh `//` bị parse như comment.

### 3. Verify gitignore

Đảm bảo không commit secrets:

```gitignore
CineTracker/Resources/Secrets.xcconfig
*.xcconfig.local
```

### 4. Open and run

```bash
open CineTracker/CineTracker.xcodeproj
```

Chọn scheme `CineTracker` và chạy trên iOS 17+ simulator/device.

## Configuration

- `Configuration.swift` đọc key từ `Info.plist`
- `Debug.xcconfig`/`Release.xcconfig` include `Secrets.xcconfig`
- `RealmConfig.swift` cấu hình Realm cho App Group `group.codewithcuongnd.CineTracker`

## Deep Link

- `cinetracker://movie/{id}`: mở Movie Detail theo id
- `cinetracker://watchlist`: chuyển tab sang Watchlist

## Localization

- Hỗ trợ `vi` và `en`
- Tài nguyên:
  - `CineTracker/Resources/vi.lproj/Localizable.strings`
  - `CineTracker/Resources/en.lproj/Localizable.strings`

## Dependencies

Swift Package Manager đang sử dụng:

- `realm-swift` (community branch)
- `realm-core`
- `YouTubePlayerKit` (2.0.5)

## License

MIT License. Xem [LICENSE](LICENSE).
