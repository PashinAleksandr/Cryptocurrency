

import Foundation

protocol DetailsSegmentControlDelegate: AnyObject {
    func segmentControlDidTabted(didSelect section: DetailsSegmentControl.Section)
}
