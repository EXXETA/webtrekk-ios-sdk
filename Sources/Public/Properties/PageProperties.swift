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


import UIKit


public struct PageProperties {

	public var details: [Int: TrackingValue]?
	public var groups: [Int: TrackingValue]?
	public var name: String?
	public var internalSearch: String?
	public var viewControllerType: UIViewController.Type?
    public var url: String? {
        didSet {
            if !isURLCanBeSet(self.url) {
                printInvalidURL(self.url!)
            }
        }
    }
    var internalSearchConfig: PropertyValue?


	public init(
		name: String?,
		details: [Int: TrackingValue]? = nil,
		groups: [Int: TrackingValue]? = nil,
		internalSearch: String? = nil,
		url: String? = nil
	) {
		self.details = details
		self.groups = groups
		self.name = name
		self.internalSearch = internalSearch
        setUpURL(url)
	}


	public init(
		viewControllerType: UIViewController.Type?,
		details: [Int: TrackingValue]? = nil,
		groups: [Int: TrackingValue]? = nil,
		internalSearch: String? = nil,
		url: String? = nil
	) {
		self.details = details
		self.groups = groups
		self.internalSearch = internalSearch
		setUpURL(url)
		self.viewControllerType = viewControllerType
	}
    
    
    init(
        nameComplex: String?,
        details: [Int: TrackingValue]? = nil,
        groups: [Int: TrackingValue]? = nil,
        internalSearchConfig: PropertyValue? = nil,
        url: String? = nil
        ) {
        self.details = details
        self.groups = groups
        self.name = nameComplex
        self.internalSearchConfig = internalSearchConfig
        setUpURL(url)
    }
	
	@warn_unused_result
    internal func merged(over other: PageProperties) -> PageProperties {
		var new = self
		new.details = details.merged(over: other.details)
		new.groups = groups.merged(over: other.groups)
		new.name = name ?? other.name
        new.internalSearchConfig = internalSearchConfig ?? other.internalSearchConfig
        new.internalSearch = internalSearch ?? other.internalSearch
		new.viewControllerType = viewControllerType ?? other.viewControllerType
		new.url = url ?? other.url
		return new
	}
    
    mutating func processKeys(event: TrackingEvent)
    {
        if let internalSearch = internalSearchConfig?.serialized(for: event) {
            self.internalSearch = internalSearch
        }
    }
    
    mutating private func setUpURL(url: String?){
    
    if isURLCanBeSet(url) {
        self.url = url
    } else {
        printInvalidURL(url!)
    }
    }
    
    private func isURLCanBeSet(url: String?) -> Bool {
       return url == nil || url!.isValidURL()
    }
    
    private func printInvalidURL(url: String) {
        WebtrekkTracking.defaultLogger.logError("Invalid URL \(url) for pu parameter")
    }
}
