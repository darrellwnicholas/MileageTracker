//
//  TutorialViewController.h
//  MileageTracker
//
//  Created by Darrell Nicholas on 1/3/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import "ViewController.h"

@interface TutorialViewController : ViewController

@end

// NOTES:
/* 
 Need to walk the user through creating their first vehicle *(IF NO VEHICLES EXIST!!!)*, I want the user to be able to launch the tutorial again from somewhere in the app after first launch. I can do that by just launching the Tutorial, and then use their current vehicle with pointers to buttons and explanations of what they do and so on...
 
 For now and until the app is complete and working, you need to create a test vehicle and work on the rest of the app and get it working and looking the way you want it. Then come back and do some "layer overlays" of screenshots of the app or something along those lines.
 
 This tutorial serves 2 main essential functions. 
    1. It Welcomes the user to the app and gets them oriented on how it works.
    2. It sets up a root object (the first vehicle) that all other objects must relate to.
 
 TODO Next:
 (keep this section updated Darrell, please! -self
 Create a "Create Vehicle" page that the tutorial ends with, then transitions to the "ViewController" screen.
    -on this page you will need to add a vehicle object to the Realm Database
    -on the main view controller that people will see on normal opening of app you need either a 
        segmented control (defaulted to gas entry) with a big "+" button or something like that to add a fuel entry
    -I'm considering having this app in a tabbed view controller with a global "active vehicle" that affects all the tabs. Having one tab devoted to settings, where the active vehicle can be selected and in-app purchases can
        be promoted.
    -I could also go another direction where there is just a list of icons on the main screen to take you to different parts of the app and embed the whole thing in a navigation controller. You can link to the settings page from all pages if needed.
    -maybe just a toolbar at the bottom of the navigation controller that has different bar button items depending on the page the user is on. Kind of like the way the app "Overcast" is designed.
 */