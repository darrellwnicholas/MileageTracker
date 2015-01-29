# MileageTracker
Complete vehicle expense tracking app for both commercial and non-commercial use.
Users of this app will be able to track fuel cost, oil change cost, other service costs, and monthly mileage entries.

A lot of drivers of commercially owned vehicles need to input monthly mileage and have a break down of personal
versus business miles. This is an IRS requirement in the United States. 

This app will have a feature that will help the driver that has to enter odometer and/or driver ID number at the pump
through the use of an Apple Watch extension. This feature will allow users to leave their phone in the vehicle and
not run the risk of dropping it while trying to pump gas. They will be able to look at their Apple Watch for all the
information they need for each time they fuel their vehicle.

Another feature is oil change reminder. Every time the user creates and entry for fuel, service, or monthly mileage 
the app will update the current mileage of the selected vehicle. It will also know when the next oil change will be
due and so when the current mileage gets close to the oil change mileage, the app will remind the user.

I plan on adding the feature to "share" a vehicle with another person or persons. This will come in useful when
more than one person uses a vehicle (i.e. Family car, Taxi with day shift and night shift drivers, things of that
sort). The only requirement will be that the app be installed on both phones. I am only planning on an iOS release
at this stage, but if it becomes popular enough, I may bring in a team to help with an Android and/or Windows Phone
version.

Last and most certainly not least is reports. The user of this app will be able to run a myriad of built in reports
as well as (hopefully, but not yet designed) custom formatted reports. The user will be able to view these reports
in app and as well as export them in several formats. 

That is the vision of this app as it stands today. Everything is subject to change. The app currently uses the Realm
mobile database engine. This has the unique feature of being cross-platform compatible in case I decide on supporting
other platforms. It also has the advantage of being the only database engine I know of that is designed strictly to
run on mobile platforms. 

--If this code is shared with you...---
To build this project, you must clone it to your computer, then use cocoapods to install the Realm framework. See
http://www.realm.io for more details.
