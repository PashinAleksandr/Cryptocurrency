
import Foundation

enum CoinError: LocalizedError {
    case nowData
    case nowInternet
    case missGrafic
    
    var errorDescription: String? {
        switch self {
        case.missGrafic:
            return "Нет данных для построения графика"
        case.nowData:
            return "Не пришли данные с сервера"
        case.nowInternet:
            return "Проблемы с сетью"
        }
    }
}
