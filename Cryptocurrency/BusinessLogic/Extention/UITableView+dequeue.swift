
import UIKit

extension UITableView { 
    func dequeueReusableCell<Cell: UITableViewCell>(_ cellType: Cell.Type, indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as? Cell else {
            fatalError("\(Cell.identifier) is not registered in tableView")
        }
        return cell
    }
}
