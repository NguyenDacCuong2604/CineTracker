//
//  L10n.swift
//  CineTracker
//
//  Created by MAC VN on 25/5/26.
//
import Foundation

enum L10n {
    private static func tr(_ key: String, _ defaultValue: String) -> String {
        LocalizationManager.shared.localizedString(forKey: key, defaultValue: defaultValue)
    }

    private static func tr(_ key: String, _ defaultValue: String, _ args: CVarArg...) -> String {
        let template = LocalizationManager.shared.localizedString(forKey: key, defaultValue: defaultValue)
        return String(format: template, arguments: args)
    }

    enum Common {
        static var cancel: String {
            tr("common.cancel", "Huỷ")
        }

        static var confirm: String {
            tr("common.confirm", "Xác nhận")
        }

        static var done: String {
            tr("common.done", "Xong")
        }

        static var retry: String {
            tr("common.retry", "Thử lại")
        }

        static var loading: String {
            tr("common.loading", "Đang tải...")
        }

        static var error: String {
            tr("common.error", "Đã xảy ra lỗi")
        }
    }

    enum Tabs {
        static var discover: String {
            tr("tabs.discover", "Khám phá")
        }

        static var search: String {
            tr("tabs.search", "Tìm kiếm")
        }

        static var watchlist: String {
            tr("tabs.watchlist", "Watchlist")
        }

        static var statistics: String {
            tr("tabs.statistics", "Thống kê")
        }

        static var profile: String {
            tr("tabs.profile", "Cá nhân")
        }
    }

    enum Discover {
        static var title: String {
            tr("discover.title", "Khám phá")
        }

        static var popular: String {
            tr("discover.popular", "🔥 Phổ biến")
        }

        static var topRated: String {
            tr("discover.topRated", "⭐ Đánh giá cao")
        }

        static var upcoming: String {
            tr("discover.upcoming", "🎬 Sắp ra mắt")
        }

        static var nowPlaying: String {
            tr("discover.nowPlaying", "🎥 Đang chiếu")
        }

        static var seeAll: String {
            tr("discover.seeAll", "Xem tất cả")
        }
    }

    enum Search {
        static var title: String {
            tr("search.title", "Tìm kiếm")
        }

        static var placeholder: String {
            tr("search.placeholder", "Tìm phim...")
        }

        static var recent: String {
            tr("search.recent", "Tìm kiếm gần đây")
        }

        static var clearAll: String {
            tr("search.clearAll", "Xoá tất cả")
        }

        static var noResults: String {
            tr("search.noResults", "Không tìm thấy phim")
        }
    }

    enum Watchlist {
        static var title: String {
            tr("watchlist.title", "Watchlist")
        }

        static var all: String {
            tr("watchlist.all", "Tất cả")
        }

        static var wantToWatch: String {
            tr("watchlist.wantToWatch", "Muốn xem")
        }

        static var watched: String {
            tr("watchlist.watched", "Đã xem")
        }

        static var favorites: String {
            tr("watchlist.favorites", "Yêu thích")
        }

        static var empty: String {
            tr("watchlist.empty", "Watchlist trống")
        }

        static var emptyMessage: String {
            tr("watchlist.emptyMessage", "Thêm phim từ Khám phá để bắt đầu")
        }

        static var exploreCTA: String {
            tr("watchlist.exploreCTA", "Khám phá phim")
        }
    }

    enum MovieDetail {
        static var cast: String {
            tr("movieDetail.cast", "Diễn viên")
        }

        static var trailer: String {
            tr("movieDetail.trailer", "Trailer")
        }

        static var similar: String {
            tr("movieDetail.similar", "Phim tương tự")
        }

        static var yourReview: String {
            tr("movieDetail.yourReview", "Đánh giá của bạn")
        }

        static var addToWatchlist: String {
            tr("movieDetail.addToWatchlist", "Thêm vào Watchlist")
        }

        static var inWatchlist: String {
            tr("movieDetail.inWatchlist", "Đã thêm")
        }

        static var markWatched: String {
            tr("movieDetail.markWatched", "Đánh dấu đã xem")
        }

        static var edit: String {
            tr("movieDetail.edit", "Sửa")
        }
    }

    enum Statistics {
        static var title: String {
            tr("statistics.title", "Thống kê")
        }

        static var totalMovies: String {
            tr("statistics.totalMovies", "Tổng phim")
        }

        static var watched: String {
            tr("statistics.watched", "Đã xem")
        }

        static var watchTime: String {
            tr("statistics.watchTime", "Thời gian xem")
        }

        static var avgRating: String {
            tr("statistics.avgRating", "Rating TB")
        }

        static var monthly: String {
            tr("statistics.monthly", "Phim đã xem theo tháng")
        }

        static var genres: String {
            tr("statistics.genres", "Phân bố thể loại")
        }

        static var topMovies: String {
            tr("statistics.topMovies", "🏆 Top 10 phim của bạn")
        }
    }

    enum Profile {
        static var title: String {
            tr("profile.title", "Cá nhân")
        }

        static var welcome: String {
            tr("profile.welcome", "Xin chào!")
        }

        static var subtitle: String {
            tr("profile.subtitle", "Quản lý ứng dụng của bạn")
        }

        static var totalMovies: String {
            tr("profile.totalMovies", "Phim đã thêm")
        }

        static var watched: String {
            tr("profile.watched", "Đã xem")
        }

        static var settings: String {
            tr("profile.settings", "Cài đặt")
        }

        static var clearCache: String {
            tr("profile.clearCache", "Xoá bộ nhớ đệm")
        }

        static var clearCacheTitle: String {
            tr("profile.clearCacheTitle", "Xoá cache?")
        }

        static var clearCacheMessage: String {
            tr("profile.clearCacheMessage", "Các ảnh đã cache sẽ phải tải lại từ network")
        }

        static var madeWith: String {
            tr("profile.madeWith", "Made with ❤️ in Vietnam")
        }

        static func version(_ version: String) -> String {
            tr("profile.version", "Phiên bản %@", version)
        }
    }

    enum Settings {
        static var title: String {
            tr("settings.title", "Cài đặt")
        }

        static var appearance: String {
            tr("settings.appearance", "Giao diện")
        }

        static var theme: String {
            tr("settings.theme", "Chế độ")
        }

        static var themeSystem: String {
            tr("settings.themeSystem", "Theo hệ thống")
        }

        static var themeLight: String {
            tr("settings.themeLight", "Sáng")
        }

        static var themeDark: String {
            tr("settings.themeDark", "Tối")
        }

        static var language: String {
            tr("settings.language", "Ngôn ngữ")
        }

        static var languageSelect: String {
            tr("settings.languageSelect", "Chọn ngôn ngữ")
        }

        static var languageNote: String {
            tr("settings.languageNote", "Khởi động lại app để áp dụng")
        }

        static var content: String {
            tr("settings.content", "Nội dung")
        }

        static var showSpoilers: String {
            tr("settings.showSpoilers", "Hiển thị spoiler")
        }

        static var showSpoilersNote: String {
            tr("settings.showSpoilersNote", "Cho phép hiển thị tên vai diễn có thể spoiler")
        }

        static var about: String {
            tr("settings.about", "Về ứng dụng")
        }

        static var sourceCode: String {
            tr("settings.sourceCode", "Mã nguồn (GitHub) }")
        }
    }
}
