//
//  InfoView.swift
//  MultiClock
//
//  Displays the MultiClock's "info" tab.
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
                    Text("Two times")
                        .font(.title3)
                        .bold()
                    Text("    This clock shows two different times.")
                    Text("    First, it shows the current civil time. This is the local time in your time zone, taking daylight saving rules into account.")
                    Text("    Second, it shows the current solar time. That's the time based on the actual position of the sun in the sky where you are. At solar noon, the sun is at its highest point in the sky. At solar midnight, it's exactly on the other side of the Earth.")
                    Text("    Prior to the establishment of long-distance railroad service in the 1800s and the need for consistent schedules across the network, most towns and cities kept their local time based on the sun. If you traveled from one town to another, you'd adjust your watch to match the local church spire or town hall clock. This app takes care of that for you.")
                    Text("     The moment when the sun is at its highest in the sky depends on where you are on the Earth, of course. As you move west, the sun is directly overhead later. At civil noon -- 12:00 in your time zone -- the sun will be at its highest point only if you are at the meridian that defines that time zone. The solar time shown on the clock adjusts solar noon for your actual location.")
                    Text("     But solar noon also shifts, relative to civil noon, over the course of the year. The Earth's orbit around the sun is an ellipse, not a perfect circle. The equator is at a slight angle to the ecliptic.")
                    Text("     The 'equation of time' is the tool that timekeepers use to make that correction. It's not the sort of equation you know from middle school. Rather, it's the number of minutes you need to add or subtract from civil noon to get solar noon. It depends on the date, of course, since that determines the Earth's position in its orbit.")
                    Text("     The clock computes the equation of time for the current date and time and uses that, along with your location, to get the correct solar time.")
                    Text("     You can learn more about the equation of time on Wikipedia at https://en.wikipedia.org/wiki/Equation_of_time.")
                }
                VStack(alignment: .leading) {
                    Text(" ")
                    Text("Which time is which?")
                        .bold()
                    Text("    The tab marked by the government building")
                    Image(systemName: "building.columns")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                    Text("at the bottom of the screen will show you the current civil time.")
                    Text("    The tab marked by the sun")
                    Image(systemName: "sun.max")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                    Text("shows the current solar time.")
                }
                VStack(alignment: .leading) {
                    Text(" ")
                    Text("Conventional and metric time")
                        .font(.title3)
                        .bold()
                    Text("    Each of the time displays shows you the time in several ways.")
                    Text("    The hh:mm view shows the time in hours and minutes, in the way that most clocks do. It also shows the current equation of time in minutes.")
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "deskclock")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                            Text(" 4:20 PM")
                                .font(.title2)
                            Spacer()
                        }
                    }
                    Text("    The metric display divides the day into 10,000 equal-sized units, and then counts them as they pass. There are 86,400 seconds in a day, so each hundred-microday unit lasts 8.64 seconds. The day begins at 0000 (midnight), and ends at 9999 (the instant before the following midnight. It also shows the current metric equation of time, in hundred-microday units.")
                    HStack {
                        Image(systemName: "ruler")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text(" 0420")
                            .font(.title2)
                        Spacer()
                    }
                    Text("    Finally, the day progress view shows how much of the day has elapsed.")
                    HStack {
                        Image(systemName: "chart.bar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text(" ")
                        ProgressView(value: 42, total: 100)
                            .scaleEffect(x: 1, y: 4, anchor: .center)
                        Text("42%")
                        Text(" ")
                    }
                }
                VStack(alignment: .leading) {
                    Text(" ")
                    Text("Sunrise and sunset")
                        .font(.title3)
                        .bold()
                    Text("    The time displays also show the sunrise and sunset times for your location.")
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "sunrise")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                            Text(" sunrise time")
                                .font(.title2)
                                .italic()
                            Spacer()
                        }
                        HStack {
                            Image(systemName: "sunset")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                            Text(" sunset time")
                                .font(.title2)
                                .italic()
                            Spacer()
                        }
                    }
                }
                VStack(alignment: .leading) {
                    Text(" ")
                    Text("Your location")
                        .font(.title3)
                        .bold()
                    Text("    To show all of these times, the clock needs to know your location. It asks to use your location only while you are using the application. If you choose not to share location information, the clock will still show you the civil time, but will not be able to display solar time or to show sunrise/sunset times.")
                    Text("    Your location is never shared off of your device. It is used only to determine solar time and sunrise/sunset times.")
                    Text("    If you allow the application to use your precise location, solar time and sunrise/sunset times will be most accurate. If you share your location, but not your precise location, those times will be slightly less accurate.")
                    Text("    You can change whether and how the clock can access your location in your device settings. Go to Settings -> Privacy and security and change the setting for this application.")
                    Text("    As you move around, you may notice that the solar time and sunrise/sunset times change. That's because all those times depend on your location. When your location changes, so do they.")
                }
                VStack(alignment: .leading) {
                    Text(" ")
                    Text("Preferences")
                        .font(.title3)
                        .bold()
                    Text("     You can change the app's behavior using the preferences tab.")
                    HStack {
                        Image(systemName: "gearshape")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text(" Preferences")
                            .font(.title2)
                            .italic()
                    }
                    Text("     By default, the clock uses 12-hour, AM/PM display format for hh:mm times. You can switch to a 24-hour clock display. If you have your system-wide preference set for a 24-hour clock (see Preferences -> General -> Date and Time), that setting will override this one.")
                    Text("      Out of respect for prime numbers and the important work that they do, if any of the metric times on the screen is prime, it will be highlighted in red. It's a prime time! You can turn this behavior off or on.")
                }
            }
        }
        .padding(10)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
