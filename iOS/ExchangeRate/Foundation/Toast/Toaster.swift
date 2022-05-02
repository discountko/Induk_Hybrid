//
//  Toaster.swift
//  ExchangeRate
//
//  Created by pineone on 2022/05/02.
//

import UIKit

enum ToastType {
    case normal
    case onKeyboard
}

struct Delay {
    public static let short: TimeInterval = 2.0
    public static let long: TimeInterval = 3.5
}

class Toaster: Operation {
    // MARK: Properties

    public var text: String? {
        get { return self.view.text }
        set { self.view.text = newValue }
    }

    private var type: ToastType
    public var delay: TimeInterval
    public var duration: TimeInterval

    private var _executing = false
    override open var isExecuting: Bool {
        get {
            return self._executing
        }
        set {
            self.willChangeValue(forKey: "isExecuting")
            self._executing = newValue
            self.didChangeValue(forKey: "isExecuting")
        }
    }

    private var _finished = false
    override open var isFinished: Bool {
        get {
            return self._finished
        }
        set {
            self.willChangeValue(forKey: "isFinished")
            self._finished = newValue
            self.didChangeValue(forKey: "isFinished")
        }
    }

    // MARK: UI

    public var view = ToastView()

    // MARK: Initializing

    public init(text: String?, delay: TimeInterval = 0, duration: TimeInterval = Delay.short, type: ToastType = .normal) {
        self.type = type
        self.delay = delay
        self.duration = duration
        super.init()
        self.text = text
    }

    // MARK: Factory (Deprecated)

    @available(*, deprecated, message: "Use 'init(text:)' instead.")
    public class func makeText(_ text: String) -> Toaster {
        return Toaster(text: text)
    }

    @available(*, deprecated, message: "Use 'init(text:duration:)' instead.")
    public class func makeText(_ text: String, duration: TimeInterval) -> Toaster {
        return Toaster(text: text, duration: duration)
    }

    @available(*, deprecated, message: "Use 'init(text:delay:duration:)' instead.")
    public class func makeText(_ text: String?, delay: TimeInterval, duration: TimeInterval) -> Toaster {
        return Toaster(text: text, delay: delay, duration: duration)
    }

    // MARK: Showing

    public func show() {
        ToastCenter.default.add(self)
    }

    // MARK: Cancelling

    override open func cancel() {
        super.cancel()
        DispatchQueue.main.async { [weak self] in
            self?.finish()
            self?.view.removeFromSuperview()
        }
    }

    // MARK: Operation Subclassing

    override open func start() {
        let isRunnable = !self.isFinished && !self.isCancelled && !self.isExecuting
        guard isRunnable else { return }
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.start()
            }
            return
        }
        main()
    }

    override open func main() {
        self.isExecuting = true

        DispatchQueue.main.async {[weak self] in
            guard let `self` = self else { return }
            self.view.setNeedsLayout()
            self.view.alpha = 0
            if self.type == .normal {
                UIApplication.shared.keyWindowInConnectedScenes?.addSubview(self.view)
            } else {
                UIApplication.shared.windows.last!.addSubview(self.view)
            }

            //ToastWindow.shared.addSubview(self.view)

            UIView.animate(withDuration: 0.5,
                           delay: self.delay,
                           options: .beginFromCurrentState,
                           animations: { self.view.alpha = 1 },
                           completion: { _ in
                            UIView.animate(withDuration: self.duration,
                                           animations: { self.view.alpha = 1.0001 },
                                           completion: {_ in
                                            self.finish()
                                            UIView.animate(withDuration: 0.5, animations: { self.view.alpha = 0 }, completion: { _ in self.view.removeFromSuperview() })
                            })
            })
        }
    }

    func finish() {
        self.isExecuting = false
        self.isFinished = true
    }
}

