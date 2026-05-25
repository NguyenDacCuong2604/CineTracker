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

        static var errorTitle: String {
            tr("common.errorTitle", "Đã có lỗi xảy ra")
        }

        static var save: String {
            tr("common.save", "Lưu")
        }

        static var delete: String {
            tr("common.delete", "Xoá")
        }

        static var edit: String {
            tr("common.edit", "Sửa")
        }

        static var undo: String {
            tr("common.undo", "Hoàn tác")
        }

        static var readMore: String {
            tr("common.readMore", "Đọc thêm")
        }

        static var collapse: String {
            tr("common.collapse", "Thu gọn")
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

        static var trending: String {
            tr("discover.trending", "Trending")
        }

        static var emptyCarousel: String {
            tr("discover.emptyCarousel", "Không có phim")
        }

        static var trendingError: String {
            tr("discover.trendingError", "Không tải được phim trending")
        }
    }

    enum MovieCategory {
        static var trending: String {
            tr("movieCategory.trending", "Trending")
        }

        static var popular: String {
            tr("movieCategory.popular", "Phổ biến")
        }

        static var topRated: String {
            tr("movieCategory.topRated", "Đánh giá cao")
        }

        static var upcoming: String {
            tr("movieCategory.upcoming", "Sắp ra mắt")
        }

        static var nowPlaying: String {
            tr("movieCategory.nowPlaying", "Đang chiếu")
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

        static var notFound: String {
            tr("search.notFound", "Không tìm thấy")
        }

        static func noMatchingMovies(_ query: String) -> String {
            tr("search.noMatchingMovies", "Không có phim nào khớp với \"%@\"", query)
        }

        static var startSearching: String {
            tr("search.startSearching", "Bắt đầu tìm kiếm phim")
        }

        static var searchHint: String {
            tr("search.searchHint", "Nhập tên phim để bắt đầu khám phá")
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

        static var searchPlaceholder: String {
            tr("watchlist.searchPlaceholder", "Tìm trong watchlist...")
        }

        static func selectedCount(_ count: Int) -> String {
            tr("watchlist.selectedCount", "%d đã chọn", count)
        }

        static var addToFavorites: String {
            tr("watchlist.addToFavorites", "Yêu thích")
        }

        static var removeFromFavorites: String {
            tr("watchlist.removeFromFavorites", "Bỏ yêu thích")
        }

        static var markAsWatched: String {
            tr("watchlist.markAsWatched", "Đánh dấu đã xem")
        }

        static var removedFromWatchlist: String {
            tr("watchlist.removedFromWatchlist", "Đã xoá khỏi watchlist")
        }

        static var ratingLabel: String {
            tr("watchlist.ratingLabel", "Đánh giá")
        }

        static var emptyFavoritesTitle: String {
            tr("watchlist.emptyFavoritesTitle", "Chưa có phim yêu thích")
        }

        static var emptyFavoritesMessage: String {
            tr("watchlist.emptyFavoritesMessage", "Đánh dấu yêu thích những bộ phim ấn tượng nhất với bạn")
        }

        static var emptyWatchedTitle: String {
            tr("watchlist.emptyWatchedTitle", "Chưa xem phim nào")
        }

        static var emptyWatchedMessage: String {
            tr("watchlist.emptyWatchedMessage", "Đánh dấu các phim đã xem để theo dõi lịch sử xem")
        }

        static var emptyWantToWatchTitle: String {
            tr("watchlist.emptyWantToWatchTitle", "Chưa có phim muốn xem")
        }

        static var emptyWantToWatchMessage: String {
            tr("watchlist.emptyWantToWatchMessage", "Thêm những bộ phim bạn muốn xem vào danh sách")
        }

        static var emptyAllMessage: String {
            tr("watchlist.emptyAllMessage", "Khám phá và thêm những bộ phim yêu thích vào watchlist")
        }
    }

    enum WatchlistSort {
        static var dateAddedDesc: String {
            tr("watchlistSort.dateAddedDesc", "Mới thêm gần đây")
        }

        static var dateAddedAsc: String {
            tr("watchlistSort.dateAddedAsc", "Thêm lâu nhất")
        }

        static var ratingDesc: String {
            tr("watchlistSort.ratingDesc", "Rating cao nhất")
        }

        static var ratingAsc: String {
            tr("watchlistSort.ratingAsc", "Rating thấp nhất")
        }

        static var titleAsc: String {
            tr("watchlistSort.titleAsc", "Tên A-Z")
        }

        static var titleDesc: String {
            tr("watchlistSort.titleDesc", "Tên Z-A")
        }

        static var releaseDateDesc: String {
            tr("watchlistSort.releaseDateDesc", "Mới phát hành")
        }

        static var releaseDateAsc: String {
            tr("watchlistSort.releaseDateAsc", "Cũ nhất")
        }
    }

    enum MovieStatus {
        static var wantToWatch: String {
            tr("movieStatus.wantToWatch", "Muốn xem")
        }

        static var watched: String {
            tr("movieStatus.watched", "Đã xem")
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

        static var contentTitle: String {
            tr("movieDetail.contentTitle", "Nội dung")
        }

        static var noDescription: String {
            tr("movieDetail.noDescription", "Chưa có mô tả")
        }

        static var mightLike: String {
            tr("movieDetail.mightLike", "Có thể bạn cũng thích")
        }

        static var noSuggestions: String {
            tr("movieDetail.noSuggestions", "Không có gợi ý")
        }

        static var noCastInfo: String {
            tr("movieDetail.noCastInfo", "Không có thông tin diễn viên")
        }

        static var watchlistLabel: String {
            tr("movieDetail.watchlistLabel", "Watchlist")
        }
    }

    enum Review {
        static var yourRating: String {
            tr("review.yourRating", "Đánh giá của bạn")
        }

        static var yourFeelings: String {
            tr("review.yourFeelings", "Cảm nhận của bạn")
        }

        static var placeholder: String {
            tr("review.placeholder", "Viết cảm nhận về phim...")
        }

        static func characterCount(_ count: Int) -> String {
            tr("review.characterCount", "%d / 1000 ký tự", count)
        }

        static var maxRating: String {
            tr("review.maxRating", "/ 5.0")
        }

        static func watchedOn(_ date: String) -> String {
            tr("review.watchedOn", "Đã xem ngày %@", date)
        }

        static var sheetTitle: String {
            tr("review.sheetTitle", "Đánh dấu đã xem")
        }
    }

    enum CastDetail {
        static var birthday: String {
            tr("castDetail.birthday", "Sinh nhật")
        }

        static var lifeStatusCurrent: String {
            tr("castDetail.lifeStatusCurrent", "Hiện tại")
        }

        static var lifeStatusDeceased: String {
            tr("castDetail.lifeStatusDeceased", "Đã mất")
        }

        static var placeOfBirth: String {
            tr("castDetail.placeOfBirth", "Nơi sinh")
        }

        static var biography: String {
            tr("castDetail.biography", "Tiểu sử")
        }

        static var filmography: String {
            tr("castDetail.filmography", "Phim đã tham gia")
        }

        static var noFilmography: String {
            tr("castDetail.noFilmography", "Không có thông tin filmography")
        }

        static func role(_ character: String) -> String {
            tr("castDetail.role", "Vai: %@", character)
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

        static var avgRatingFull: String {
            tr("statistics.avgRatingFull", "Rating trung bình")
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

        static var topMoviesTitle: String {
            tr("statistics.topMoviesTitle", "🏆 Top 15 phim của bạn")
        }

        static var noData: String {
            tr("statistics.noData", "Chưa có dữ liệu")
        }

        static var monthAxisLabel: String {
            tr("statistics.monthAxisLabel", "Tháng")
        }

        static var movieCountAxisLabel: String {
            tr("statistics.movieCountAxisLabel", "Số phim")
        }

        static var emptyMessage: String {
            tr("statistics.emptyMessage", "Thêm phim vào watchlist và đánh dấu đã xem để thấy thống kê của bạn")
        }

        static var exploreMovies: String {
            tr("statistics.exploreMovies", "Khám phá phim")
        }

        static var last12Months: String {
            tr("statistics.last12Months", "12 tháng gần nhất")
        }

        static var wantToWatch: String {
            tr("statistics.wantToWatch", "Muốn xem")
        }

        static var favorites: String {
            tr("statistics.favorites", "Yêu thích")
        }

        static var ratingDistribution: String {
            tr("statistics.ratingDistribution", "Phân bố đánh giá")
        }

        static var ratingSubtitle: String {
            tr("statistics.ratingSubtitle", "Số phim theo số sao bạn đã rate")
        }

        static var noRated: String {
            tr("statistics.noRated", "Chưa rate phim nào")
        }

        static var noGenreData: String {
            tr("statistics.noGenreData", "Chưa có dữ liệu thể loại")
        }

        static var watchingActivity: String {
            tr("statistics.watchingActivity", "Hoạt động xem phim")
        }

        static func yearLabel(_ year: Int) -> String {
            tr("statistics.yearLabel", "Năm %d", year)
        }

        static var moviesUnit: String {
            tr("statistics.moviesUnit", "phim")
        }

        static var few: String {
            tr("statistics.few", "Ít")
        }

        static var many: String {
            tr("statistics.many", "Nhiều")
        }

        static var tapCellHint: String {
            tr("statistics.tapCellHint", "Chạm ô để xem chi tiết")
        }

        static var noWatchOnDay: String {
            tr("statistics.noWatchOnDay", "Không xem phim")
        }

        static func moviesOnDay(_ count: Int) -> String {
            tr("statistics.moviesOnDay", "%d phim", count)
        }

        static func noWatchActivity(_ year: Int) -> String {
            tr("statistics.noWatchActivity", "Chưa có hoạt động xem phim trong năm %d", year)
        }

        static var dateLocale: String {
            tr("statistics.dateLocale", "vi_VN")
        }

        static func monthShort(_ month: Int) -> String {
            let key = "statistics.monthShort.\(month)"
            let defaults = ["T1", "T2", "T3", "T4", "T5", "T6",
                            "T7", "T8", "T9", "T10", "T11", "T12"]
            guard month >= 1 && month <= 12 else { return "" }
            return tr(key, defaults[month - 1])
        }

        static func weekdayShort(_ day: Int) -> String {
            let key = "statistics.weekdayShort.\(day)"
            let defaults = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"]
            guard day >= 0 && day < 7 else { return "" }
            return tr(key, defaults[day])
        }
    }

    enum AllMovies {
        static var loadError: String {
            tr("allMovies.loadError", "Không thể tải phim")
        }

        static var loadingMore: String {
            tr("allMovies.loadingMore", "Đang tải thêm")
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

        static var calculatingCache: String {
            tr("profile.calculatingCache", "Đang tính")
        }
    }

    enum APIError {
        static var noInternet: String {
            tr("apiError.noInternet", "Không có kết nối internet. Vui lòng kiểm tra mạng.")
        }

        static var timeout: String {
            tr("apiError.timeout", "Kết nối quá lâu. Vui lòng thử lại.")
        }

        static var cancelled: String {
            tr("apiError.cancelled", "Yêu cầu đã bị huỷ.")
        }

        static var badRequest: String {
            tr("apiError.badRequest", "Yêu cầu không hợp lệ.")
        }

        static var unauthorized: String {
            tr("apiError.unauthorized", "API key không hợp lệ hoặc đã hết hạn.")
        }

        static var forbidden: String {
            tr("apiError.forbidden", "Bạn không có quyền truy cập tài nguyên này.")
        }

        static var notFound: String {
            tr("apiError.notFound", "Không tìm thấy nội dung.")
        }

        static func serverError(_ code: Int) -> String {
            tr("apiError.serverError", "Lỗi máy chủ (%d). Vui lòng thử lại sau.", code)
        }

        static func httpError(_ code: Int) -> String {
            tr("apiError.httpError", "Lỗi HTTP %d", code)
        }

        static func decodingFailed(_ description: String) -> String {
            tr("apiError.decodingFailed", "Không xử lý được dữ liệu: %@", description)
        }

        static var invalidURL: String {
            tr("apiError.invalidURL", "URL không hợp lệ.")
        }

        static var invalidResponse: String {
            tr("apiError.invalidResponse", "Phản hồi không hợp lệ.")
        }
    }

    enum Person {
        static var departmentActing: String {
            tr("person.departmentActing", "Diễn viên")
        }

        static var departmentDirecting: String {
            tr("person.departmentDirecting", "Đạo diễn")
        }

        static var departmentWriting: String {
            tr("person.departmentWriting", "Biên kịch")
        }

        static var departmentProduction: String {
            tr("person.departmentProduction", "Sản xuất")
        }

        static var departmentCamera: String {
            tr("person.departmentCamera", "Quay phim")
        }

        static var departmentEditing: String {
            tr("person.departmentEditing", "Dựng phim")
        }

        static var departmentSound: String {
            tr("person.departmentSound", "Âm thanh")
        }

        static var departmentArt: String {
            tr("person.departmentArt", "Mỹ thuật")
        }

        static func deceasedOn(_ date: String) -> String {
            tr("person.deceasedOn", "Đã mất ngày %@", date)
        }

        static func ageYears(_ age: Int) -> String {
            tr("person.ageYears", "%d tuổi", age)
        }

        static var birthdayLocale: String {
            tr("person.birthdayLocale", "vi_VN")
        }
    }

    enum Stats {
        static func daysWatched(_ days: Double) -> String {
            tr("stats.daysWatched", "%.1f ngày", days)
        }
    }

    enum Genre {
        static var action: String {
            tr("genre.action", "Hành động")
        }

        static var adventure: String {
            tr("genre.adventure", "Phiêu lưu")
        }

        static var animation: String {
            tr("genre.animation", "Hoạt hình")
        }

        static var comedy: String {
            tr("genre.comedy", "Hài")
        }

        static var crime: String {
            tr("genre.crime", "Tội phạm")
        }

        static var documentary: String {
            tr("genre.documentary", "Tài liệu")
        }

        static var drama: String {
            tr("genre.drama", "Chính kịch")
        }

        static var family: String {
            tr("genre.family", "Gia đình")
        }

        static var fantasy: String {
            tr("genre.fantasy", "Giả tưởng")
        }

        static var history: String {
            tr("genre.history", "Lịch sử")
        }

        static var horror: String {
            tr("genre.horror", "Kinh dị")
        }

        static var music: String {
            tr("genre.music", "Âm nhạc")
        }

        static var mystery: String {
            tr("genre.mystery", "Bí ẩn")
        }

        static var romance: String {
            tr("genre.romance", "Lãng mạn")
        }

        static var scienceFiction: String {
            tr("genre.scienceFiction", "Khoa học viễn tưởng")
        }

        static var thriller: String {
            tr("genre.thriller", "Giật gân")
        }

        static var war: String {
            tr("genre.war", "Chiến tranh")
        }

        static var western: String {
            tr("genre.western", "Cao bồi")
        }

        static var other: String {
            tr("genre.other", "Khác")
        }
    }

    enum Widget {
        static var displayName: String {
            tr("widget.displayName", "CineTracker Watchlist")
        }

        static var description: String {
            tr("widget.description", "Hiển thị danh sách phim trong watchlist của bạn.")
        }

        static var emptySmall: String {
            tr("widget.emptySmall", "Watchlist trống")
        }

        static var emptyMedium: String {
            tr("widget.emptyMedium", "Chưa có phim trong watchlist")
        }

        static var emptyLargeTitle: String {
            tr("widget.emptyLargeTitle", "Watchlist trống")
        }

        static var emptyLargeMessage: String {
            tr("widget.emptyLargeMessage", "Thêm phim trong app để hiển thị ở đây")
        }

        static func watchlistHeader(_ count: Int) -> String {
            tr("widget.watchlistHeader", "Watchlist (%d)", count)
        }

        static func movieCount(_ count: Int) -> String {
            tr("widget.movieCount", "%d phim", count)
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
            tr("settings.sourceCode", "Mã nguồn (GitHub)")
        }

        static var poweredByTMDB: String {
            tr("settings.poweredByTMDB", "Powered by TMDB")
        }
    }
}
