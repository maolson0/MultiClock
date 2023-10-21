//
//  SolarClock.swift
//  MultiClock
//
//  Implements a clock that keeps track of civil and solar time, based on the location of
//  the user. Requires access to system location services for solar time. Will work in a
//  degraded way if those services are not available -- the civil time is correctly set,
//  and solar time is nil.
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

import Foundation
import SwiftUI
import CoreLocation

// The SolarClock object gets the current civil and solar time.
// It uses location data to figure out solar time. It correctly handles the case where the user
// doesn't share location data. That makes the solar clock relatively useless.
class SolarClock: NSObject, CLLocationManagerDelegate {
    
    // We need to know where we are
    private var sc_lm = CLLocationManager()
    
    // These public vars are for the enclosing application to know time, where we are, EoT
    public var sc_civil_time = Date()
    public var sc_solar_time: Date? = nil
    public var sc_loc: CLLocationCoordinate2D? = nil
    public var sc_eot: Double = 0.0
    
    /*
     * days_since_y2k(year, month, day, hour):
     *
     *    Integer number of days since Jan 1, 2000
     *
     *    A century has 36,500 days (plus leap days), so this number needs
     *    to be stored in a 32-1bit integer type.
     *
     *    Input year needs to be between 2000 and 2099, but we don't check
     *    input values for reasonableness.
     *
     *    This is used to compute the equation of time.
     */

    private func days_since_y2k(year: Int, month: Int, day: Int, hour: Int) -> Int
    {
        var a, b, c, d: Int   // Quantity c in particular can overflow a 16-bit integer on Arduino
        var yr, mo: Int

        if (month <= 2) {
            yr = year - 1
            mo = month + 12
        } else {
            yr = year
            mo = month
        }

        a = yr / 100
        b = 2 - a + (a / 4)
        c = Int(365.25 * Double(yr))
        d = Int(30.6001 * (Double(mo) + 1.0));
        
        let dy2k = Int(Double(b + c + d + day) + ((Double(hour) / 24.0) - 730550.5))
        // "convey to gmt"?
        //let dy2k = Int(Double(b + c + d + day) + ((Double(hour+1) / 24.0) - 730550.5))

        return (dy2k);
    }

    /*
     * equation_of_time(year, month, day, hour):
     *
     *    Calculate the adjustment, in minutes, of the actual solar time
     *    at the UTC meridian on the date and hour supplied. Minutes are
     *    computed as a double-precision floating point number, so will
     *    need to be converted to seconds for civil time math.
     *
     *    Solar time is computed from the actual position of the sun in
     *    the sky. Civil time assumes an invariant 24-hour day. The Earth's
     *    orbit is elliptical, and the equatorial plane is slanted relative
     *    to the planet's orbit, so over the course of the year, noon civil
     *    time drifts relative to solar time.
     *
     *    There are other sources of inaccuracy between observed noon and
     *    civil time, including atmospheric refraction that moves the
     *    apparent sun a little bit, small variations in actual length of
     *    day due to mountains slamming into high-pressure blocks of air,
     *    slowing of the Earth's rotation over time, and so on. These are
     *    all negligible for our purposes here.
     *
     *    Researchers at NASA/JPL used a large series of actual observations
     *    of the sun's position in the sky, compared to civil time, and
     *    used linear regression to create a Fourier approximation to the
     *    actual solar position from civil time based on the major components
     *    of the curve of the observed data.
     *
     *    Background and the Visual Basic code are at
     *
     *        https://equation-of-time.info/calculating-the-equation-of-time
     *
     *    This function is accurate to +/-13 seconds for any hour between
     *    2000 and 2099.  It's a cheap function to calculate to get that
     *    degree of accuracy.
     */

    private func equation_of_time(year: Int, month: Int, day: Int, hour: Int) -> Double
    {
        var cycle: Double

        let dy2k = days_since_y2k(year: year, month: month, day: day, hour: hour)
        cycle = 4.0 * Double(dy2k)
        cycle -= (Double(Int(cycle / 1461.0))) * 1461.0
        let theta = cycle * 0.004301;
        let eot1 = 7.353 * sin(1.0 * theta + 6.209);
        let eot2 = 9.927 * sin(2.0 * theta + 0.37);
        let eot3 = 0.337 * sin(3.0 * theta + 0.304);
        let eot4 = 0.232 * sin(4.0 * theta + 0.715);

        let eot = 0.019 + eot1 + eot2 + eot3 + eot4;

        return (eot);
    }
    
    // This delegate gets called when the OS notices we've moved. Save the new location in clock state.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations[0]
        
        sc_loc = loc.coordinate
    }
    
    // This delegate gets called when we are allowed/disallowed from using location data, and when
    // we first start up (.notDetermined). In that last case, ask the OS for permission.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
            sc_lm.startUpdatingLocation()
            break
            
        case .restricted, .denied:  // Location services currently unavailable.
            sc_loc = nil
            sc_solar_time = nil
            break
            
        case .notDetermined:        // Authorization not determined yet.
            manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
    
    // Register this object as a delegate for location data events
    override init() {
        super.init()
        sc_lm.delegate = self
    }
    
    // When the app shuts down, the OS doesn't need to tell us about location changes anymore
    deinit {
        sc_lm.stopUpdatingLocation()
    }
    
    // The enclosing app calls this when it wants to know what time it is
    public func updateTimes() {
        sc_civil_time = Date()
        
        // compute the solar time if we know our location
        if let curLoc = sc_loc {
            let hour = Calendar.current.component(.hour, from: sc_civil_time)
            let day = Calendar.current.component(.day, from: sc_civil_time)
            let month = Calendar.current.component(.month, from: sc_civil_time)
            let year = Calendar.current.component(.year, from: sc_civil_time)
            
            // compute the equation of time for the current day/hour
            sc_eot = equation_of_time(year: year, month: month, day: day, hour: hour)
            
            /*
             * The tricky bit! If the sign of EoT is positive, that means that the solar clock is
             * ahead of the civil clock -- solar noon comes after civil noon. We're going to compute
             * solar time starting from civil time, so we need to subtract the difference due to EoT
             * instead of adding it. So, we flip the sign in our solarDelta calculation.
             *
             * We also need to adjust for our location on the face of the planet. We use our location
             * to get current longitude. Every degree of longitude is 4 minutes of clock time (24
             * notional one-hour time zones, each 15 minutes wide). So we compute minutes due to
             * longitude and add that in as well.
             *
             * The TimeInterval type is in seconds so we need to convert from minutes to seconds.
             *
             *  A week of debugging taught me: Always know the sign of the equation of time!
             */
            let solarDelta = (-sc_eot + (curLoc.longitude * 4.0)) * 60.0

            sc_solar_time = sc_civil_time.addingTimeInterval(solarDelta)
        } else {
            // If we don't know our location we can't know the solar time
            sc_solar_time = nil
        }
    }
    
    // This interface allows a caller to get the solar/civil delta as of a particular date and hour.
    // It supports a requested feature for the MultiClock: converting among solar and civil times.
    func sc_delta(yyyy: Int, mm: Int, dd: Int, hh: Int) -> Double?
    {
        // Only accurate for the current century
        if (yyyy < 2000 || yyyy > 2099) {
            return nil
        }
        
        if let curLoc = sc_loc {
            // compute the equation of time for the supplied day/hour
            let ondate_eot = equation_of_time(year: yyyy, month: mm, day: dd, hour: hh)
            
            /*
             * The tricky bit! If the sign of EoT is positive, that means that the solar clock is
             * ahead of the civil clock -- solar noon comes after civil noon. We're going to compute
             * solar time starting from civil time, so we need to subtract the difference due to EoT
             * instead of adding it. So, we flip the sign in our solarDelta calculation.
             *
             * We also need to adjust for our location on the face of the planet. We use our location
             * to get current longitude. Every degree of longitude is 4 minutes of clock time (24
             * notional one-hour time zones, each 15 minutes wide). So we compute minutes due to
             * longitude and add that in as well.
             *
             * The TimeInterval type is in seconds so we need to convert from minutes to seconds.
             *
             *  A week of debugging taught me: Always know the sign of the equation of time!
             */
            let solarDelta = (-ondate_eot + (curLoc.longitude * 4.0)) * 60.0
            
            return solarDelta
        }
        
        return nil
    }
}
