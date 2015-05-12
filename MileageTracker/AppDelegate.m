//
//  AppDelegate.m
//  MileageTracker
//
//  Created by Darrell Nicholas on 1/1/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import "AppDelegate.h"
#import "FilePath.h"
#import "Car.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
// self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
//  --Leave this part commented until you are done with the Tutorial--  //
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstLaunch"]) {
        // TutorialComplete value is YES
        NSLog(@"no first launch");
    } else {
        // TutorialComplete value is NO or doesn't exist yet
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstLaunch"];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        Car *car = [[Car alloc] init];
        
        car.name = @"My Vehicle";
        
        NSString *nameOfCar = @"theStandardCarPhoto.png";
        PhotoObject *defaultCarPhoto = [[PhotoObject alloc] init];
        defaultCarPhoto.imageName = nameOfCar;
        
        NSLog(@"%@",[UIImage imageNamed:defaultCarPhoto.imageName]);
        /*
         BOOL isDir;
         NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
         NSString *documentsDirectory = [paths objectAtIndex:0]; //Get the docs directory
         NSString *carFolderPath = [documentsDirectory stringByAppendingString:@"/Photos/CarPhotos"];
         NSString *uuidImageName = [NSString stringWithFormat:@"%@-CarImage.png",[self.selectedCar uuid]];
         NSString *photoPath = [NSString stringWithFormat:@"/Photos/CarPhotos/%@", uuidImageName];
         if (![[NSFileManager defaultManager] fileExistsAtPath:carFolderPath isDirectory:&isDir]) {
         [[NSFileManager defaultManager] createDirectoryAtPath:carFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
         }
         NSString *filePath = [documentsDirectory stringByAppendingPathComponent:photoPath];
         */


        
        [realm beginWriteTransaction];
        [realm addObject:car];
        [realm addObject:defaultCarPhoto];
        //defaultCarPhoto.imageName = imageURL;
        [car.carPhoto addObject:defaultCarPhoto];
        [realm commitWriteTransaction];
        [[NSUserDefaults standardUserDefaults] setValue:car.uuid forKey:@"activeCar"];
        [[NSUserDefaults standardUserDefaults] setInteger:car.currentMileage forKey:@"LastKnownMileage"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        /*
         Car *car = [[Car alloc] init];
         
         car.name = textField.text;
         NSString *imageURL = [[NSBundle mainBundle] pathForResource:@"greenCar" ofType:@"png"];
         PhotoObject *defaultCarPhoto = [[PhotoObject alloc] init];
         defaultCarPhoto.imageURLString = imageURL;
         
         
         [realm beginWriteTransaction];
         [car.carPhoto addObject:defaultCarPhoto];
         [realm addObject:car];
         [realm commitWriteTransaction];
*/

//        self.viewController = [storyboard instantiateViewControllerWithIdentifier:@"TutorialViewController"];
//        
    }
//    self.window.rootViewController = self.viewController;
//    [self.window makeKeyAndVisible];
//    
//    NSURL *filePath = [[[FilePath alloc] init] applicationDocumentsDirectory];
//    NSString *filePathString = filePath.path;
//    NSString *databaseFilePath = [filePathString stringByAppendingString:@"MileageTrackerMainRealm"];
    
    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
