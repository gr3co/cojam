//
//  AppDelegate.m
//  CoJam
//
//  Created by Stephen Greco on 4/23/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

#import <Parse/Parse.h>
#import <Spotify/Spotify.h>
#import "AppDelegate.h"
#import "CJMainViewController.h"
#import "CJSpotifyHelper.h"
#import "CJUser.h"

static NSString* const parseAppId = @"waRB2NWEkLHS0y1OezpmRZFhI8vSbnGm0uznT9tC";
static NSString* const parseClientKey = @"Neyfbq0ibmZqnKxkYtUXRyPuAB8CqM30dkFAJfUb";
static NSString* const spotifyClientId = @"100501836e2e494c97c10613da0587d2";
static NSString* const spotifySwapURL = @"https://cojam.parseapp.com/swap";
static NSString* const spotifyRefreshURL = @"https://cojam.parseapp.com/refresh";
static NSString* const spotifyCallbackURL = @"cojam://spotify/callback";
static NSString* const spotifySessionDefaultsKey = @"spotifySession";

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Initialize Parse.
    [CJUser load];
    [CJRoom load];
    
    [Parse setApplicationId:parseAppId clientKey:parseClientKey];
    [CJUser enableAutomaticUser];
    
    // Create SPTAuth instance; create login URL and open it
    SPTAuth *auth = [SPTAuth defaultInstance];
    [auth setClientID:spotifyClientId];
    [auth setRedirectURL:[NSURL URLWithString:spotifyCallbackURL]];
    [auth setRequestedScopes:@[@"user-read-email", @"streaming", @"user-follow-read"]];
    [auth setTokenSwapURL:[NSURL URLWithString:spotifySwapURL]];
    [auth setTokenRefreshURL:[NSURL URLWithString:spotifyRefreshURL]];
    [auth setSessionUserDefaultsKey:spotifySessionDefaultsKey];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    CJMainViewController *main = [[CJMainViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]  initWithRootViewController:main];
    [nav setNavigationBarHidden:YES];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(BOOL)application:(UIApplication *)application
           openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation {
    
    // Ask SPTAuth if the URL given is a Spotify authentication callback
    if ([[SPTAuth defaultInstance] canHandleURL:url]) {
        
        // Call the token swap service to get a logged in session
        [[SPTAuth defaultInstance]
         handleAuthCallbackWithTriggeredAuthURL:url
         callback:^(NSError *error, SPTSession *session) {
             
             if (error != nil) {
                 NSLog(@"*** Auth error: %@", error);
                 return;
             }
             
         }];
        return YES;
    }
    
    // Otherwise it's probably a custom URL, have it handled here
    return [[CJSpotifyHelper defaultHelper] handleURL:url];
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
