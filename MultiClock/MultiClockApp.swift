//
//  MultiClockApp.swift
//  MultiClock
//
//  Show the time in multiple ways. Maintains civil time in the current time zone and solar
//  time based on the user's location. Computes sunrise/sunset times for both. Requires
//  location services from the system. If those aren't available, will work in degraded
//  mode -- civil time is available, but solar and sunrise/sunset times are nil.
//
//  Displays both civil and solar time in three ways: Conventional hh:mm time, a metric time
//  (a four-digit counter of hundred-microday intervals), and as progress bars showing how
//  much of the day has elapsed. The hh:mm and metric views include sunrise and sunset times.
//
//  Relies on Chris Howell's Solar package for sunrise/sunset computation.
//
//  Copyright 2023, Michael A. Olson.
//
//  Redistribution and use in source and binary forms, with or without modification, are
//  permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of
//     conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of
//     conditions and the following disclaimer in the documentation and/or other materials
//     provided with the distribution.
//
//  3. Neither the name of the copyright holder nor the names of its contributors may be
//     used to endorse or promote products derived from this software without specific prior
//     written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND ANY EXPRESS
//  OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
//  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
//  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
//  OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
//  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
//  TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import SwiftUI
import MapKit
import CoreLocation
import Solar            // this is for sunrise/sunset times

extension Date
{
    var timeIntervalSinceMidnightLocal: TimeInterval?{
        return self.timeIntervalSince(self.localMidnight)
    }
    
    // local time at midnight today
    var localMidnight: Date {
        var cal = Calendar.current
        cal.timeZone = TimeZone.current
        return cal.startOfDay(for: self)
    }

    var timeIntervalSinceMidnightGMT: TimeInterval?{
        return self.timeIntervalSince(self.GMTMidnight)
    }
    
    // GMT time at midnight today
    var GMTMidnight: Date {
        var cal = Calendar(identifier: .iso8601)
        cal.timeZone = TimeZone(identifier: "UTC")!
        return (cal.startOfDay(for: self))
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

enum Selection {
    case civil_hhmm
    case civil_metric
    case solar_hhmm
    case solar_metric
}

class TimeConverter {
    var tc_civil_hhmm = ""
    var tc_civil_metric = ""
    var tc_solar_hhmm = ""
    var tc_solar_metric = ""
}

class MultiClock: ObservableObject {
    // The solar clock does the work of solar/civil time computation
    private var mc_sc = SolarClock()
    
    // we want to update our clock every ten microdays, 0.864 seconds
    // fast enough to keep the display right, infrequent enough to avoid wasting CPU time
    private var mc_timer = Timer()
    
    // settable in the iOS Settings app
    var mc_primetime = true
    var mc_12hour = true
    var mc_lhconverter = false
    
    // These are all strings to simplify their display in their respective views

    // These are all strings to simplify their display in ContentView
    // clock times for the civil and metric views
    @Published var solar_hhmm = "---"
    @Published var solar_metric = "---"
    @Published var civil_hhmm = "---"
    @Published var civil_metric = "---"
    
    // sunrise/sunset times for the hh:mm and metric time views
    @Published var solar_metric_sunrise = "---"
    @Published var solar_metric_sunset = "---"
    @Published var solar_hhmm_sunrise = "---"
    @Published var solar_hhmm_sunset = "---"
    @Published var civil_metric_sunrise = "---"
    @Published var civil_metric_sunset = "---"
    @Published var civil_hhmm_sunrise = "---"
    @Published var civil_hhmm_sunset = "---"
    
    // These are used in the day progress view
    @Published var civil_day_progress = 0.0
    @Published var civil_day_prog_pct = "0%"
    @Published var solar_day_progress = 0.0
    @Published var solar_day_prog_pct = "--"
    
    // turn any of the metric times in the metric time view into a four-digit number, 0000-9999
    private func getMetricTimeString(t: Double) -> String {
        let metricFormatter = NumberFormatter()
        metricFormatter.maximumFractionDigits = 0
        metricFormatter.minimumIntegerDigits = 4
        metricFormatter.numberStyle = .none

        // only tick over when a whole microday has elapsed -- else, this rounds up for >= 0.5 fractional
        metricFormatter.roundingMode = .floor
        
        return(metricFormatter.string(from: t as NSNumber)!)
    }
    
    // turn any of the times in the hh:mm time view into hours and minutes
    private func getHHMMTimeString(d: Date, useGMT: Bool) -> String {
        let dateFormatter = DateFormatter()
        
        // Show 12- or 24-hr clock time. System setting for 24-hour clock overrides this.
        if (mc_12hour) {
            dateFormatter.dateFormat = "h:mm a"
        } else {
            dateFormatter.dateFormat = "HH:mm"
        }
        
        // We use GMT for the solar time displays to avoid daylight saving changes
        if (useGMT) {
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
        }
        
        return (dateFormatter.string(from: d))
    }
    
    private func updateTimes() -> Void {
        // get current civil and solar times from our solar clock
        mc_sc.updateTimes()
        
        let civilTime = mc_sc.sc_civil_time
        
        civil_hhmm = getHHMMTimeString(d: civilTime, useGMT: false)

        // compute civil metric time from seconds since local midnight
        // four digits of metric time is hundred-microday resolution
        let secs_per_hundred_udays = 8.64
        let hundred_microdays_since_midnight =  (civilTime.timeIntervalSinceMidnightLocal! / secs_per_hundred_udays)
        
        civil_metric = getMetricTimeString(t: hundred_microdays_since_midnight)
        civil_day_progress = Double(Int(civil_metric)!) / 100.0
        let f = NumberFormatter()
        f.maximumFractionDigits = 0
        f.numberStyle = .percent
        civil_day_prog_pct = f.string(from: (civil_day_progress / 100.0) as NSNumber)!

        // solar time is only available from the solar clock if location services are available
        // if the user declind that permission, the time will be nil
        // that's not very interesting for a civil/solar metric clock, but we handle it properly here
        if let solarTime = mc_sc.sc_solar_time {
            let solar_civil_delta = civilTime.distance(to: solarTime)
            solar_hhmm = getHHMMTimeString(d: solarTime, useGMT: true)
            
            // compute civil metric time from seconds since local midnight
            // four digits of metric time is hundred-microday resolution
            let t = solarTime.timeIntervalSinceMidnightGMT!
            let hundred_microdays_since_midnight_gmt = (t / secs_per_hundred_udays)
            
            // turn it into a four-digit integer, as a string with leading zeros
            solar_metric = getMetricTimeString(t: hundred_microdays_since_midnight_gmt)
            solar_day_progress = Double(Int(solar_metric)!) / 100.0
            f.maximumFractionDigits = 0
            f.numberStyle = .percent
            solar_day_prog_pct = f.string(from: (solar_day_progress / 100.0) as NSNumber)!

            // If we know our location, get all the sunrise and sunset times
            // Given we have a solar time, this should always be okay, but let's be careful
            if let curLoc = mc_sc.sc_loc {
                
                // Solar is the sunrise/sunset library
                if let s = Solar(for: civilTime, coordinate: CLLocationCoordinate2D(latitude: curLoc.latitude, longitude: curLoc.longitude)) {
                    
                    // sunrise can be nil if we're in arctic/antarctic "sun doesn't rise" territory
                    if let sunrise = s.sunrise {
                        var hundred_udays: Double
                        
                        civil_hhmm_sunrise = getHHMMTimeString(d: sunrise, useGMT: false)
                        hundred_udays = sunrise.timeIntervalSinceMidnightLocal! / secs_per_hundred_udays;
                        civil_metric_sunrise = getMetricTimeString(t: hundred_udays)
                        
                        let adjustedSunrise = sunrise.addingTimeInterval(solar_civil_delta)
                        solar_hhmm_sunrise = getHHMMTimeString(d: adjustedSunrise, useGMT: true)
                        hundred_udays = adjustedSunrise.timeIntervalSinceMidnightGMT! / secs_per_hundred_udays;
                        solar_metric_sunrise = getMetricTimeString(t: hundred_udays)
                    } else {
                        // the sun did not rise today
                        civil_hhmm_sunrise = "none"
                        civil_metric_sunrise = "none"
                        solar_hhmm_sunrise = "none"
                        solar_metric_sunrise = "none"
                    }
                    
                    // sunset can be nil if we're in arctic/antarctic "sun doesn't set" territory
                    if let sunset = s.sunset {
                        var hundred_udays: Double
                        
                        civil_hhmm_sunset = getHHMMTimeString(d: sunset, useGMT: false)
                        hundred_udays = sunset.timeIntervalSinceMidnightLocal! / secs_per_hundred_udays;
                        civil_metric_sunset = getMetricTimeString(t: hundred_udays)
                        
                        let adjustedSunset = sunset.addingTimeInterval(solar_civil_delta)
                        solar_hhmm_sunset = getHHMMTimeString(d: adjustedSunset, useGMT: true)
                        hundred_udays = adjustedSunset.timeIntervalSinceMidnightGMT! / secs_per_hundred_udays;
                        solar_metric_sunset = getMetricTimeString(t: hundred_udays)
                    } else {
                        // the sun did not set today
                        civil_hhmm_sunset = "none"
                        civil_metric_sunset = "none"
                        solar_hhmm_sunset = "none"
                        solar_metric_sunset = "none"
                    }
                }
            } else {
                // we don't know our location, so none of the sun times are computable
                civil_hhmm_sunrise = "---"
                civil_hhmm_sunset = "---"
                civil_metric_sunrise = "---"
                civil_metric_sunset = "---"
                
                solar_hhmm = "---"
                solar_metric = "---"
                solar_hhmm_sunrise = "---"
                solar_hhmm_sunset = "---"
                solar_metric_sunrise = "---"
                solar_metric_sunset = "---"
                solar_day_progress = 0.0
                solar_day_prog_pct = "--"
            }
        } else {
            solar_hhmm = "---"
            solar_metric = "---"
            solar_hhmm_sunrise = "---"
            solar_hhmm_sunset = "---"
            solar_metric_sunrise = "---"
            solar_metric_sunset = "---"
            solar_day_progress = 0.0
            solar_day_prog_pct = "--"
        }
    }
    
    func start() {
        // as soon as you wake up, look at the clock!
        self.updateTimes()
        
        // get settings from the user defaults
        self.initDefaults()
        
        // Finest-grained time display is in the metric time view. The low digit of that number changes
        // every one hundred microdays. We set a timer here to get the current time every ten microdays,p
        // or every 0.864 seconds. That's fast enough for our displays to be correct and means we're not
        // doing a lot of work to recalculate and redisplay the time when stuff can't be changing.
        let updateInterval = 0.864
        mc_timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { _ in
            // when the timer goes off, call our updateTimes routine to figure out if anything has changed
            self.updateTimes() }
    }
    
    init() {
        start()
    }
    
    // is this necessary?
    deinit {
        // turn off the timer when the app shuts down
        mc_timer.invalidate()
    }
    
    private func initDefaults() {
        // First time we run on a device, need to register the defaults set in the Setting bundle with
        // the UserDefaults database. It's kind of bogus that iOS doesn't do this for you automatically.
        // Thanks, StackOverflow!
        let settingsUrl = Bundle.main.url(forResource: "Settings", withExtension: "bundle")!.appendingPathComponent("Root.plist")
        let settingsPlist = NSDictionary(contentsOf:settingsUrl)!
        let preferences = settingsPlist["PreferenceSpecifiers"] as! [NSDictionary]
        
        var defaultsToRegister = Dictionary<String, Any>()
        
        for preference in preferences {
            guard let key = preference["Key"] as? String else {
                NSLog("Key not found")
                continue
            }
            defaultsToRegister[key] = preference["DefaultValue"]
        }
        UserDefaults.standard.register(defaults: defaultsToRegister)
    }
    
    func loadDefaults() {
        let defaults = UserDefaults.standard
        self.mc_12hour = defaults.bool(forKey: "mc_12hour")
        self.mc_primetime = defaults.bool(forKey: "mc_primetime")
        self.mc_lhconverter = defaults.bool(forKey: "mc_lefthanded")
    }
}

extension MultiClock {
    func started() -> MultiClock {
        start()
        return self
    }
}

// The MultiClock has a converter tab that lets the user enter a solar or metric time in metric or hh:mm format,
// pick a date, and convert the input time to all the other varieties as of that date. The function below supports
// that converter. The t parameter is a 4-digit input, the which parameter identifies solar/civil hhmm/metric,
// and the case statement handles the bookkeeping for each of those cases.
extension MultiClock {
    func convertTime(t: Int, dd: Int, mm: Int, yyyy: Int, which: Selection) -> TimeConverter {
        let new_tc = TimeConverter()
        
        switch which {
        case .civil_hhmm:
            let hr = t / 100
            let min = t % 100
            let secsSinceMidnight = Double(((hr * 60) + min) * 60)
            let civmet = secsSinceMidnight / 8.64
            new_tc.tc_civil_metric = getMetricTimeString(t: civmet)
            
            let components = DateComponents(year: yyyy, month: mm, day: dd, hour: hr, minute: min)
            let cal = Calendar.current
            let civdate = cal.date(from: components)
            new_tc.tc_civil_hhmm = getHHMMTimeString(d: civdate!, useGMT: false)
            
            if let solar_civil_delta = mc_sc.sc_delta(yyyy: yyyy, mm: mm, dd: dd, hh: hr) {
                let soldate = civdate!.addingTimeInterval(solar_civil_delta)
                new_tc.tc_solar_hhmm = getHHMMTimeString(d: soldate, useGMT: true)
                let solarSecsSinceMidnight = soldate.timeIntervalSinceMidnightGMT
                let solmet = solarSecsSinceMidnight! / 8.64
                new_tc.tc_solar_metric = getMetricTimeString(t: solmet)
            } else {
                // no solar delta available -- location services off
                new_tc.tc_solar_metric = "---"
                new_tc.tc_solar_hhmm = "---"
            }

        case .solar_hhmm:
            let hr = t / 100
            let min = t % 100
            let solarSecsSinceMidnight = Double(((hr * 60) + min) * 60)
            let solmet = solarSecsSinceMidnight / 8.64
            new_tc.tc_solar_metric = getMetricTimeString(t: solmet)
            
            let components = DateComponents(year: yyyy, month: mm, day: dd, hour: hr, minute: min)
            var cal = Calendar(identifier: .iso8601)
            cal.timeZone = TimeZone(identifier: "UTC")!
            let soldate = cal.date(from: components)
            new_tc.tc_solar_hhmm = getHHMMTimeString(d: soldate!, useGMT: true)

            if let solar_civil_delta = mc_sc.sc_delta(yyyy: yyyy, mm: mm, dd: dd, hh: hr) {
                let civdate = soldate!.addingTimeInterval(0.0 - solar_civil_delta)
                new_tc.tc_civil_hhmm = getHHMMTimeString(d: civdate, useGMT: false)
                let secsSinceMidnight = civdate.timeIntervalSinceMidnightLocal
                let civmet = secsSinceMidnight! / 8.64
                new_tc.tc_civil_metric = getMetricTimeString(t: civmet)
            } else {
                // no solar delta available -- location services off
                new_tc.tc_civil_metric = "---"
                new_tc.tc_civil_hhmm = "---"
            }

        case .solar_metric:
            new_tc.tc_solar_metric = getMetricTimeString(t: Double(t))
            
            let solarSecsSinceMidnight = Double(t) * 8.64
            var cal = Calendar(identifier: .iso8601)
            cal.timeZone = TimeZone(identifier: "UTC")!
            let components = DateComponents(year: yyyy, month: mm, day: dd, hour: 0, minute: 0)
            let soldate = cal.date(from: components)!.addingTimeInterval(solarSecsSinceMidnight)
            new_tc.tc_solar_hhmm = getHHMMTimeString(d: soldate, useGMT: true)
            let hh = Int(solarSecsSinceMidnight / 3600.0)
            if let solar_civil_delta = mc_sc.sc_delta(yyyy: yyyy, mm: mm, dd: dd, hh: hh) {
                let civdate = soldate.addingTimeInterval(0.0 - solar_civil_delta)
                new_tc.tc_civil_hhmm = getHHMMTimeString(d: civdate, useGMT: false)
                let secsSinceMidnight = civdate.timeIntervalSinceMidnightLocal
                let civmet = secsSinceMidnight! / 8.64
                new_tc.tc_civil_metric = getMetricTimeString(t: civmet)
            } else {
                // no solar delta available -- location services off
                new_tc.tc_civil_metric = "---"
                new_tc.tc_civil_hhmm = "---"
            }

        case .civil_metric:
            new_tc.tc_civil_metric = getMetricTimeString(t: Double(t))
            
            let secsSinceMidnight = Double(t) * 8.64
            let cal = Calendar.current
            let components = DateComponents(year: yyyy, month: mm, day: dd, hour: 0, minute: 0)
            let civdate = cal.date(from: components)!.addingTimeInterval(secsSinceMidnight)
            new_tc.tc_civil_hhmm = getHHMMTimeString(d: civdate, useGMT: false)
            let hh = Int(secsSinceMidnight / 3600.0)
            if let solar_civil_delta = mc_sc.sc_delta(yyyy: yyyy, mm: mm, dd: dd, hh: hh) {
                let soldate = civdate.addingTimeInterval(solar_civil_delta)
                new_tc.tc_solar_hhmm = getHHMMTimeString(d: soldate, useGMT: true)
                let solarSecsSinceMidnight = soldate.timeIntervalSinceMidnightGMT
                let solmet = solarSecsSinceMidnight! / 8.64
                new_tc.tc_solar_metric = getMetricTimeString(t: solmet)
            } else {
                // no solar delta available -- location services off
                new_tc.tc_solar_metric = "---"
                new_tc.tc_solar_hhmm = "---"
            }
        }
        
        return (new_tc)
    }
}

@main
struct Solar_metric_clockApp: App {
    // we make this a state object so it's visible in the views -- it's where we put all the display info
    @StateObject private var mc = MultiClock()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(mc)
        }
    }
}
