//
//  HomageAppDelegate.m
//  HomagePrototype
//
//  Created by Tomer Harry on 8/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HomageAppDelegate.h"
#import "HMGLog.h"

@implementation HomageAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    // Override point for customization after application launch.
    return YES;
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}

@end
