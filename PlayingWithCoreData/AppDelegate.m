//
//  AppDelegate.m
//  PlayingWithCoreData
//
//  Created by Michael Vilabrera on 5/4/15.
//  Copyright (c) 2015 Giving Tree. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Person.h"

@interface AppDelegate ()

@property (nonatomic) ViewController *viewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
//    
//    if (person) {
//        person.firstName = @"Romey";
//        person.lastName = @"Roam";
//        person.age = @45;
//        
//        NSError *saveError = nil;
//        
//        if ([self.managedObjectContext save:&saveError]) {
//            NSLog(@"Saved the context");
//        } else {
//            NSLog(@"Failed to save the context. Error = %@", saveError.localizedDescription);
//        }
//    } else {
//        NSLog(@"Failed to create new person");
//    }
    
    // read data from Core Data
//    [self createNewPersonWithFirstName:@"Dude" lastName:@"Harley" age:45];
//    [self createNewPersonWithFirstName:@"Marv" lastName:@"In" age:99];
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
//    NSError *requestError = nil;
//    
//    NSArray *persons = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
//    
//    if ([persons count] > 0) {
//        NSUInteger counter = 1;
//        for (Person *thisGuy in persons) {
//            NSLog(@"Person %lu First Name = %@", (unsigned long)counter, thisGuy.firstName);
//            NSLog(@"Person %lu Last Name = %@", (unsigned long)counter, thisGuy.lastName);
//            NSLog(@"Person %lu Age = %ld", (unsigned long)counter, (unsigned long)[thisGuy.age unsignedIntegerValue]);
//            counter++;
//        }
//    } else {
//        NSLog(@"Could not find any Person entities in the context");
//    }
    
    // delete data from Core Data
    [self createNewPersonWithFirstName:@"Tony" lastName:@"Robbins" age:53];
    [self createNewPersonWithFirstName:@"Dick" lastName:@"Branson" age:63];
    
    // create fetch request first
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    NSError *fetchError = nil;
    
    // execute fetch request on the context
    NSArray *persons = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    // make sure we get the array
    if ([persons count] > 0) {
        // delete the last person in the array (Dick Branson)
        Person *lastPerson = [persons lastObject];
        [self.managedObjectContext deleteObject:lastPerson];
        
        NSError *savingError = nil;
        if ([self.managedObjectContext save:&savingError]) {
            NSLog(@"Successfully deleted last person in the array");
        } else {
            NSLog(@"Failed to delete the last person in the array");
        }
    } else {
        NSLog(@"Could not find any Person entities in the context");
    }
    
    self.viewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
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
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.GivingTree.PlayingWithCoreData" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// this file will represent the data model.
// in other words, this is the schema.
- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PlayingWithCoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// layer above the persistent store, the persistent store coordinator
// coordinates reading and writing between the managed object context and
// the persistent store.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PlayingWithCoreData.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

// the state of information
// working area for managed objects
- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - NSFetchRequest
- (BOOL) createNewPersonWithFirstName:(NSString *)firstName
                             lastName:(NSString *)lastName
                                  age:(NSUInteger)age
{
    BOOL result = NO;
    
    if ([firstName length] == 0 || [lastName length] == 0) {
        NSLog(@"first and last names are mandatory!");
        return result;  // still evaluates to 'NO'
    }
    
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    
    if (person == nil) {
        NSLog(@"Failed to create new person");
        return result;  // still evaluates to 'NO'
    }
    
    person.firstName = firstName;
    person.lastName = lastName;
    person.age = @(age);
    
    NSError *saveError = nil;
    
    if ([self.managedObjectContext save:&saveError]) {
        return YES;     // does not change value of boolean 'result'
    }
    else {
        NSLog(@"Failed to save the new person. Error: %@", saveError.localizedDescription);
    }
    return result;      // still evaluates to 'NO'
}

@end
