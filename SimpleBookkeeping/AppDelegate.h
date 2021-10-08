//
//  AppDelegate.h
//  SimpleBookkeeping
//
//  Created by 贺显臣 on 2021/10/8.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

