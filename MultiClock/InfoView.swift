//
//  InfoView.swift
//  MultiClock
//
//  Displays the MultiClock's Info tab.
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

struct InfoView: View {
    var body: some View {
        ScrollView {
            Text("MultiClock")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            Divider()
            VStack(alignment: .leading) {
                Text("For more information on solar time, metric time and the inspiration for this application, please visit https://www.olsons.net/projects/multiclock. Please send questions or bug reports to multiclock@olsons.net.")
                    .italic()
                Divider()
                VStack(alignment: .leading) {
                    Text("Time page")
                        .font(.title2)
                        .bold()
                    Text("    The time page shows the current civil and solar time as hours and minutes, in metric, and as a percent-of-day-elapsed progress bar.")
                    Text(" ")
                    Text("Civil time")
                        .font(.title3)
                        .bold()
                    Text("    Civil time is the local time in your time zone, taking daylight saving rules into account. It's called 'civil' because it's the time agreed upon by civil authorities. Legislatures decide where time zone boundaries are and whether or not they observe daylight saving time.")
                    Text(" ")
                    Text("Solar time")
                        .font(.title3)
                        .bold()
                    Text("    Solar time is the current time as determined by the actual position of the sun in the sky where you are. At solar noon, the sun is at its highest point in the sky. At solar midnight, it's exactly on the other side of the Earth.")
                    Text("    Prior to the establishment of long-distance railroad service in the 1800s and the need for consistent schedules across the network, most towns and cities kept their local time based on the sun. If you traveled from one town to another, you'd adjust your watch to match the local church spire or town hall clock. The adoption of civil time standards ended that practice.")
                    Text("     The moment when the sun is at its highest in the sky depends on where you are on the Earth, of course. As you move west, the sun is directly overhead later. At civil noon -- 12:00 in your time zone -- the sun will be at its highest point only if you are at the meridian that defines that time zone. For most of the time zone, solar noon and civil noon are different. The solar time shown on the clock adjusts the solar time for your actual location.")
                    Text("     Solar noon also shifts, relative to civil noon, over the course of the year. The Earth's orbit around the sun is an ellipse, not a perfect circle. The equator is at a slight angle to the ecliptic.")
                    Text("     The 'equation of time' is the tool that timekeepers use to make that correction. It's not the sort of equation you know from middle school. Rather, it's the number of minutes you need to add or subtract from civil noon to get solar noon. It depends on the date, of course, since that determines the Earth's position in its orbit.")
                    Text("     The clock computes the equation of time for the current date and time and uses that, along with your location, to get the correct solar time.")
                    Text("     You can learn more about the equation of time on Wikipedia at https://en.wikipedia.org/wiki/Equation_of_time.")
                }
                VStack(alignment: .leading) {
                    Text(" ")
                    Text("Metric time")
                        .font(.title3)
                        .bold()
                   Text("    Metric time divides the day into 10,000 equal-sized units and  counts them as they pass. There are 86,400 seconds in a day, so each hundred-microday unit -- the last digit on the four-digit display -- lasts 8.64 seconds. The day begins at 0000 (midnight), and ends at 9999 (the instant before the following midnight.")
                }
                VStack(alignment: .leading) {
                    Text(" ")
                    Text("Sunrise and sunset")
                        .font(.title3)
                        .bold()
                    Text("    The time displays also show the sunrise and sunset times for your location.")
                    Text("    Like solar time, sunrise and sunset depend on where you are. This is true for both civil and solar sunrise and sunset. They vary across your time zone in the same way that solar noon does. You may notice as you move around that those times change on the time display over the course of the day.")
                    Text("    Logically, solar noon should be right in the middle of solar sunrise and solar sunset. If you check your time display, though, you will notice that it's usually close to the midpoint, but not exactly in the middle. That's because over the course of the year, the daylight hours get shorter or longer as the winter and summer solstices approach. Sunrise and sunset get earlier or later, and sunset has more hours in the day to be affected by orbital change. That means noon is a little off the midpoint.")
                    Text("    Solar noon on your MultiClock is accurate to within thirteen seconds, based on the approximation the clock uses to compute the equation of time.")
                }
                VStack(alignment: .leading) {
                    Text(" ")
                    Text("Converter page")
                        .font(.title2)
                        .bold()
                    Text("    The converter page allows you to enter civil or solar time, in hours and minutes or in metric, and convert it to all the other displayed times. This is useful if you want to know what civil time it will be at noon solar, for example. Tap on one of the four time fields and use the keypad to enter a time. Hit the blue 'convert' button to do the conversion.")
                    Text("    Converting between solar and metric times depends on the day of the year, of course, and on your location. The converter allows you to choose a date and and uses the current location when converting times.")
                }
                VStack(alignment: .leading) {
                    Text(" ")
                    Text("Location services and privacy")
                        .font(.title2)
                        .bold()
                    Text("    To show all of these times, MultiClock needs to know your location. It asks to use your location only while you are using the application. If you choose not to share location information, the clock will still show you the civil time, but will not be able to display solar time or to show sunrise/sunset times.")
                    Text("    Your location is never shared off of your device. It is used only to determine solar time and sunrise/sunset times.")
                    Text("    If you allow the application to use your precise location, solar time and sunrise/sunset times will be most accurate. If you share your location, but not your precise location, those times will be slightly less accurate.")
                    Text("    You can change whether and how the clock can access your location in your device settings. Go to Settings -> Privacy and security, or to the app settings for Multiclock in the iOS Settings appliction, to change the setting for this application.")
                }
                VStack(alignment: .leading) {
                    Text(" ")
                    Text("Preferences")
                        .font(.title3)
                        .bold()
                    Text("    You can change the app's behavior in the iOS Settings app, in the entry for Multiclock.")
                    Text("    By default, the clock uses 12-hour, AM/PM display format for hh:mm times. You can switch to a 24-hour clock display. If you have your system-wide preference set for a 24-hour clock (see Preferences -> General -> Date and Time), that setting will override this one.")
                    Text("    Out of respect for prime numbers and the important work that they do, if any of the metric times on the screen is prime, it will be highlighted in red. It's a prime time! You can turn this behavior off or on.")
                    Text("    When your phone is in portrait mode (vertical), the converter displays the keypad below the area where the times are shown. If you turn your phone on its side, to landscape mode, the converter places the keypad next to the time display. You can control whether the keypad is on the left or the right by setting left-handed mode in the settings. This makes it easier to type in times with your dominant hand without covering up the time display.")
                }
            }
        }
        .padding(.vertical, 50)
        .padding(.horizontal, 20)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
