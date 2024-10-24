import Gifu
import Then
import UIKit
import SnapKit
import DesignSystem

public enum LoadingStyle {
    case transparentsGIf
    case transparentsDialog(String, String)
    case inParentProgress(UIView)
}

public class LoadingManager {
    
    public static let shared = LoadingManager()
    
    public var isTapToDismissEnabled = false
    
    public var isQueueEnabled = false
}

public extension UIViewController {
    
    struct LoadingKeys {
        static var activeLoadings = "kr.co.supermove.loading.activeLoadings"
        static var queue        = "kr.co.supermove.loading.queue"
    }
    
    private static var _isLoading = [String:Bool]()
    
    var isLoading: Bool {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return UIViewController._isLoading[tmpAddress] ?? false
        }
        set(newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            UIViewController._isLoading[tmpAddress] = newValue
            
            if newValue { showLoading() } else { hideLoading() }
        }
    }
    
    var activeLoadings: NSMutableArray {
        get {
            if let activeLoadings = objc_getAssociatedObject(self, &LoadingKeys.activeLoadings) as? NSMutableArray {
                return activeLoadings
            } else {
                let activeLoadings = NSMutableArray()
                objc_setAssociatedObject(self, &LoadingKeys.activeLoadings, activeLoadings, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return activeLoadings
            }
        }
    }
}

extension UIViewController {
    
    private func transparentViewForLoading() -> UIView {
        let backgroundView = UIView().then {
            $0.backgroundColor = UIColor(hex: "333333").withAlphaComponent(0.3)
        }
        let gifImageView = GIFImageView().then{
            $0.animate(withGIFNamed: "loading")
        }
        let iconView = UIView().then {
            $0.backgroundColor = .white
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 50
        }
        
        backgroundView.addSubview(iconView)
        iconView.addSubview(gifImageView)
        
        iconView.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.center.equalToSuperview()
        }
        
        gifImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        return backgroundView
    }
    
    private func dialogViewForLoading(with title: String, contents: String) -> UIView {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00).withAlphaComponent(0.3)
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        
        let gifImageView = GIFImageView()
        gifImageView.animate(withGIFNamed: "loading")
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = .spoqaFont(size: 20, weight: .bold)
            $0.textColor = .sm(.primary)
            $0.textAlignment = .center
        }
        let contentsLabel = UILabel().then {
            $0.text = contents
            $0.font = .spoqaFont(size: 14, weight: .regular)
            $0.textColor = .sm(.primary)
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }
        
        backgroundView.addSubview(containerView)
        
        containerView.addSubview(gifImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(contentsLabel)
        
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        gifImageView.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(gifImageView.snp.bottom).offset(2)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        contentsLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview().inset(24)
        }
        
        return backgroundView
    }
    
    private func progressViewForLoading(in parentView: UIView) -> UIView? {
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        let indicator = ProgressView(
            frame: CGRect.init(x: 0, y: 0, width: 15, height: 15),
            colors: [ .sm(.primary) ],
            lineWidth: 3
        )
        
        parentView.addSubview(backgroundView)
        backgroundView.addSubview(indicator)
        backgroundView.backgroundColor = .white
        
        backgroundView.snp.makeConstraints {
            $0.edges.width.height.equalToSuperview()
        }
        
        indicator.snp.makeConstraints {
            $0.top.equalToSuperview().offset(140)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        
        indicator.animateStroke()
        indicator.animateRotation()
        
        return backgroundView
    }
    
    public func toggleLoading(isLoading: Bool, style loadingStyle: LoadingStyle = .transparentsGIf) {
        if isLoading {
            showLoading(style: loadingStyle)
        } else {
            hideLoading()
        }
    }
    
    public func showLoading(style loadingStyle: LoadingStyle = .transparentsGIf) {
        var loadingView: UIView?
        
        switch loadingStyle {
        case let .transparentsDialog(title, contents): loadingView = dialogViewForLoading(with: title, contents: contents)
        case .transparentsGIf: loadingView = transparentViewForLoading()
        case let .inParentProgress(parentView): loadingView = progressViewForLoading(in: parentView)
        }
        
        guard let loadingView else { return }
        
        if case .inParentProgress = loadingStyle {
        
        } else {
            guard let window = UIApplication.shared.windows.first else { return }
            loadingView.frame = window.frame
            window.addSubview(loadingView)
        }
        activeLoadings.add(loadingView)
    }
    
    public func hideLoading() {
        guard let activeLoading = activeLoadings.firstObject as? UIView else { return }
        activeLoading.removeFromSuperview()
        self.activeLoadings.remove(activeLoading)
    }
}
