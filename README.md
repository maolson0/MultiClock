# MultiClock
iOS clock that shows civil and solar time in hh:mm format, in metric, and as percent of day elapsed.

This clock uses iOS location services to figure out the user's latitude and longitude. It uses OS services to get the current local time. It computes the solar time from the user's distance from the prime meridian (every minute of longitude is equivalent to four minutes' difference on the clock) and the equation of time (see https://en.wikipedia.org/wiki/Equation_of_time). I used an accurate (within 13 seconds anytime in the current century) and efficient calculation to approximate the equation of time from https://equation-of-time.info/calculating-the-equation-of-time.

The clock displays the current civil and solar times in traditional hh:mm format, and in a metric format. For the metric time, I divide the day into 10,000 equal-sized segments. Midnight is 0000 and the instant before the following midnight is 9999. A 24-hour day is 86,400 seconds long. Four digits means the smallest digit is equivalent to 100 microdays. Each 100-microday unit is 8.64 seconds long. The clock counts those as they pass and displays the current count. Finally, the percent-of-day elapsed is displayed as a progress bar. It occurred to me after working with metric time for a while that you could view the 4-digit metric time as a percentage, with a decimal point in the middle, so I added that display.

I use Chris Howell's excellent Solar library (https://github.com/ceeK/Solar) to calculate sunrise and sunset times, and display those for civil and solar hh:mm and metric times.

When any metric time on the display is a prime number, I highlight it in red. I'm crazy about primes. You can turn this off in Preferences.

By default, the clock displays time in 12-hour AM/PM format. You can choose a 24-hour display in Preferences. If the iOS system setting for time display is a 24-hour clock, it will override the app's setting.
