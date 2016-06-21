import Foundation


internal final class FileManager {

	private let _directoryUrl: NSURL
	private let identifier: String

	internal var logger: Webtrekk.Logger


	internal init(logger: Webtrekk.Logger, identifier: String) {
		self.logger = logger
		self.identifier = identifier
		#if os(iOS)
			_directoryUrl = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .AllDomainsMask, appropriateForURL: nil, create: true)
		#elseif os(watchOS)
			_directoryUrl = try! NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .AllDomainsMask, appropriateForURL: nil, create: true)
		#endif
	}


	internal var configurationFileUrl: NSURL {
		return directoryUrl.URLByAppendingPathComponent("config.json")
	}


	private var directoryUrl: NSURL {
		let directory = _directoryUrl.URLByAppendingPathComponent(identifier)
		if !NSFileManager.defaultManager().fileExistsAtPath(directory.path!) {
			do {
				try NSFileManager.defaultManager().createDirectoryAtURL(directory, withIntermediateDirectories: true, attributes: nil)
			}
			catch let error {
				logger.logError("Cannot create directory '\(directory)': \(error)")
				return _directoryUrl
			}
		}
		return directory
	}


	internal var eventFileUrl: NSURL {
		return directoryUrl.URLByAppendingPathComponent("events.json")
	}


	internal func restoreConfiguration(trackingId: String) -> TrackerConfiguration? {
		guard let data = NSData(contentsOfURL: configurationFileUrl) else {
			logger.logError("Couldn't find a config for this trackingId.")
			return nil
		}
		guard let conf = (try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String : AnyObject])!, let config = TrackerConfiguration.fromJson(conf) else {
			logger.logError("Couldn't read stored config for this trackingId.")
			return nil
		}
		return config
	}


	internal func restoreData(fromFileUrl fileUrl: NSURL) -> NSData? {
		guard NSFileManager.defaultManager().fileExistsAtPath(fileUrl.path!) else {
			return nil
		}
		guard let data: NSData = NSData(contentsOfURL: fileUrl) else {
			logger.logError("Couldn't find a data at \(fileUrl) for restoring data.")
			return nil
		}
		return data
	}


	internal func saveConfiguration(config: TrackerConfiguration) {
		guard let data = try? NSJSONSerialization.dataWithJSONObject(config.toJson(), options: NSJSONWritingOptions()) else {
			logger.logError("Could not prepare config for saving to file.")
			return
		}
		guard let _ = try? data.writeToURL(configurationFileUrl, options: .DataWritingAtomic) else {
			logger.logError("Writing config to file failed.")
			return
		}
	}


	internal func saveData(toFileUrl fileUrl: NSURL, data: NSData) {
		guard let url: NSURL = fileUrl.URLByDeletingLastPathComponent else {
			logger.logError("\(fileUrl) is not a valid url to save data to.")
			return
		}

		if !NSFileManager.defaultManager().fileExistsAtPath(url.path!) {
			do {
				try NSFileManager.defaultManager().createDirectoryAtURL(url, withIntermediateDirectories: false, attributes: nil)
			}
			catch let error {
				logger.logError("Cannot create directory '\(url)': \(error)")
				return
			}
		}
		guard let _ = try? data.writeToURL(fileUrl, options: .DataWritingAtomic) else {
			logger.logError("Writing data to file at \(fileUrl) failed.")
			return
		}
	}
}