import Foundation


internal extension NSTimer {

	@nonobjc
	internal static func scheduledTimerWithTimeInterval(timeInterval: NSTimeInterval, repeats: Bool = false, closure: Closure) -> NSTimer {
		return scheduledTimerWithTimeInterval(timeInterval, target: timerHandler, selector: #selector(TimerHandler.handle(_:)), userInfo: StrongReference(closure), repeats: repeats)
	}
}



private let timerHandler = TimerHandler()

private class TimerHandler: NSObject {

	@objc
	private func handle(timer: NSTimer) {
		let closureReference = timer.userInfo as! StrongReference<Closure>
		closureReference.target()
	}
}
