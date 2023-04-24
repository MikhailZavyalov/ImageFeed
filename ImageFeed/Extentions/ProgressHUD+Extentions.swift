
import Foundation
import ProgressHUD

extension ProgressHUD {
    static func setup() {
        ProgressHUD.animationType = .systemActivityIndicator
        ProgressHUD.colorHUD = .black
        ProgressHUD.colorAnimation = .lightGray
    }
}
