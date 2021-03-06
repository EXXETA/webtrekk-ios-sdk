//The MIT License (MIT)
//
//Copyright (c) 2016 Webtrekk GmbH
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the
//"Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish,
//distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject
//to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//  Created by Widgetlabs
//

import Foundation


public final class DefaultTrackingLogger: TrackingLogger {

	/** Enable or disable logging completly */
	public var enabled = true

	/** Filter the amount of log output by setting different `TrackingLogLevel` */
	public var minimumLevel = TrackingLogLevel.warning

	/** Attach a message to the log output with a spezific `TackingLogLevel` */
	public func log(@autoclosure message message: () -> String, level: TrackingLogLevel) {
		guard enabled && level.rawValue >= minimumLevel.rawValue else {
			return
		}

		NSLog("%@", "[Webtrekk] [\(level.title)] \(message())")
	}
}


public enum TrackingLogLevel: Int {

	case debug   = 1
	case info    = 2
	case warning = 3
	case error   = 4


	private var title: String {
		switch (self) {
		case .debug:   return "Debug"
		case .info:    return "Info"
		case .warning: return "Warning"
		case .error:   return "ERROR"
		}
	}
}


public protocol TrackingLogger: class {

	func log (@autoclosure message message: () -> String, level: TrackingLogLevel)
}


public extension TrackingLogger {

	public func logDebug(@autoclosure message: () -> String) {
		log(message: message, level: .debug)
	}


	public func logError(@autoclosure message: () -> String) {
		log(message: message, level: .error)
	}


	public func logInfo(@autoclosure message: () -> String) {
		log(message: message, level: .info)
	}


	public func logWarning(@autoclosure message: () -> String) {
		log(message: message, level: .warning)
	}
}
