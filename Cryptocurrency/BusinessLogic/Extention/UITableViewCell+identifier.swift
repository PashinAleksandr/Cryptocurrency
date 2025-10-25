
import UIKit

extension UITableViewCell {
    
    static var identifier: String {
        String(describing: Self.self)
    }
    
    var identifier: String {
        Self.identifier
    }
}
