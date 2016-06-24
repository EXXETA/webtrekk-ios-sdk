import Foundation
import UIKit


public struct TrackerRequest {

	public var crossDeviceProperties: CrossDeviceProperties
	public let event: Event
	public let properties: Properties
	public var userProperties: UserProperties


	internal init(
		crossDeviceProperties: CrossDeviceProperties,
		event: Event,
		properties: Properties,
		userProperties: UserProperties
	) {
		self.crossDeviceProperties = crossDeviceProperties
		self.event = event
		self.properties = properties
		self.userProperties = userProperties
	}



	public enum Event {

		case action(ActionEvent)
		case media(MediaEvent)
		case pageView(PageViewEvent)
	}



	public struct Properties {

		public var advertisingId: NSUUID?
		public var appVersion: String?
		public var connectionType: ConnectionType?
		public var everId: String
		public var interfaceOrientation: UIInterfaceOrientation?
		public var ipAddress: String?
		public var isFirstEventAfterAppUpdate = false
		public var isFirstEventOfApp = false
		public var isFirstEventOfSession = false
		public var requestQueueSize: Int?
		public var screenSize: (width: Int, height: Int)?
		public var samplingRate: Int
		public var sessionDetails: Set<IndexedProperty>?
		public var timeZone: NSTimeZone
		public var timestamp: NSDate
		public var userAgent: String


		internal init(
			everId: String,
			samplingRate: Int,
			timeZone: NSTimeZone,
			timestamp: NSDate,
			userAgent: String
		) {
			self.everId = everId
			self.samplingRate = samplingRate
			self.timeZone = timeZone
			self.timestamp = timestamp
			self.userAgent = userAgent
		}



		public enum ConnectionType {

			case cellular_2G
			case cellular_3G
			case cellular_4G
			case offline
			case other
			case wifi
		}
	}
}
