//
//  AppDelegate.swift
//  Bus@NUS
//
//  Created by Jiang Sheng on 1/7/15.
//  Copyright (c) 2015 Gisonrg. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let keyForLastModified = "last_modified"
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        importJSONSeedDataIfNeeded()
        
        // get an array of BusStop and pass to the Explorer VC
        let fetchRequest = NSFetchRequest(entityName:"BusStop")
        
        let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: "localizedStandardCompare:")
        // sort Bus Stops here
        fetchRequest.sortDescriptors = [nameSortDescriptor]
        
        let fetchedResults = try? self.managedObjectContext.executeFetchRequest(fetchRequest) as! [BusStop]
        
        if let results = fetchedResults {
            let navigationController = self.window!.rootViewController as! UINavigationController
            let busExplorerVC = navigationController.topViewController as! BusExplorerViewController
            busExplorerVC.busStopArray = results
        } else {
            NSLog("Cannot fetch busstop information.")
        }
        
        // configure the title font
        let themeColor = AppUtilities.UIColorFromRGB("FFA600", alpha: 1.0)
        let attributes = [NSFontAttributeName : UIFont(name: "JuliusSansOne-Regular", size: 20)!, NSForegroundColorAttributeName : themeColor]
        UINavigationBar.appearance().titleTextAttributes = attributes
        UINavigationBar.appearance().tintColor = themeColor
                
        return true
    }
    
    func importJSONSeedDataIfNeeded() {
        let fetchRequest = NSFetchRequest(entityName: "BusStop")
        var error: NSError? = nil

        let results =
        self.managedObjectContext.countForFetchRequest(fetchRequest,
            error: &error)

        if (results == 0) {
            importJSONSeedData()
        } else {
            // check if need to update the date and time
            let jsonURL = NSBundle.mainBundle().URLForResource("busSeed", withExtension: "json")
            let json = NSData(contentsOfURL: jsonURL!)
            let jsonData = JSON(data: json!)
            let lastModifiedDateString = jsonData["last_modified"].string
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let parsedDate = dateFormatter.dateFromString(lastModifiedDateString!)
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let savedModifiedDate = defaults.objectForKey(keyForLastModified) as! NSDate
            
            if savedModifiedDate < parsedDate! {
                // We need to update the data (:
                importJSONSeedData()
            }
        }
        
    }
    
    func importJSONSeedData() {
        // Delete old data
        let fetchRequest = NSFetchRequest(entityName: "BusStop")
        var results: [BusStop]
        do {
            results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [BusStop]
        } catch {
            results = [BusStop]()
        }
        
        for object in results {
            self.managedObjectContext.deleteObject(object)
        }
        
        let jsonURL = NSBundle.mainBundle().URLForResource("busSeed", withExtension: "json")
        let json = NSData(contentsOfURL: jsonURL!)
        let jsonData = JSON(data: json!)

        let busStopEntity = NSEntityDescription.entityForName("BusStop", inManagedObjectContext: managedObjectContext)
        
        let busEntity = NSEntityDescription.entityForName("Bus", inManagedObjectContext: managedObjectContext)
        let stopArray: Array<JSON> = jsonData["locations"].arrayValue
        
        // every time import, save the last modified date
        let lastModifiedDateString = jsonData["last_modified"].string
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let lastModifiedDate = dateFormatter.dateFromString(lastModifiedDateString!)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(lastModifiedDate, forKey: keyForLastModified)
        
        for stop in stopArray {
            let currentStop = BusStop(entity: busStopEntity!, insertIntoManagedObjectContext: managedObjectContext)
            currentStop.name = stop["name"].string!
            currentStop.id = stop["id"].string!
            currentStop.latitude = stop["latitude"].double!
            currentStop.longitude = stop["longitude"].double!
            
            let busSet = NSMutableOrderedSet()
            for (_,subJson):(String, JSON) in stop["buses"] {
                let currentBus = Bus(entity: busEntity!, insertIntoManagedObjectContext: managedObjectContext)
                currentBus.name = subJson.string!
                currentBus.bus = currentStop
                busSet.addObject(currentBus)
            }
            currentStop.hasBus = NSOrderedSet(orderedSet: busSet)
        }
        self.saveContext()
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "me.gisonrg.Swift2CoreData" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Bus@NUS", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
}

