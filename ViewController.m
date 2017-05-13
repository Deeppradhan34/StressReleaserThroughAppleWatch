//
//  ViewController.m
//  HueAutomate
//
//  Created by Deep Pradhan on 4/13/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "ViewController.h"
#import "PHLoadingViewController.h"
#define MAX_HUE 65535


@interface ViewController ()
@property (nonatomic, strong) PHLoadingViewController *loadingView;
@property (nonatomic, strong) PHBridgeSearching *bridgeSearch;

@property (nonatomic, strong) UIAlertView *noConnectionAlert;
@property (nonatomic, strong) UIAlertView *noBridgeFoundAlert;
@property (nonatomic, strong) UIAlertView *authenticationFailedAlert;

@property (nonatomic, strong) PHBridgePushLinkViewController *pushLinkViewController;
@property (nonatomic, strong) PHBridgeSelectionViewController *bridgeSelectionViewController;
//@property (nonatomic, strong) PHControlLightsViewController *controlLightsViewController;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bridgeIDLabel.text=@"Not Connected";
    self.bridgeIPLabel.text=@"Not Connected";
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onclickIntegrate:(id)sender {
    //code to integrate HUE SDK
    
    
    // Create sdk instance
    
    self.phHueSDK = [[PHHueSDK alloc] init];
    [self.phHueSDK startUpSDK];
    [self.phHueSDK enableLogging:YES];
    
    PHNotificationManager *notificationManager = [PHNotificationManager defaultManager];
    [notificationManager registerObject:self withSelector:@selector(localConnection) forNotification:LOCAL_CONNECTION_NOTIFICATION];
    [notificationManager registerObject:self withSelector:@selector(noLocalConnection) forNotification:NO_LOCAL_CONNECTION_NOTIFICATION];
    [notificationManager registerObject:self withSelector:@selector(notAuthenticated) forNotification:NO_LOCAL_AUTHENTICATION_NOTIFICATION];

     [self enableLocalHeartbeat];
   
}

- (void)localConnection {
    // Check current connection state
    [self checkConnectionState];
}

/**
 Notification receiver for failed local connection
 */
- (void)noLocalConnection {
    // Check current connection state
    [self checkConnectionState];
}

/**
 Notification receiver for failed local authentication
 */
- (void)notAuthenticated {
    /***************************************************
     We are not authenticated so we start the authentication process
     *****************************************************/
    
    // Move to main screen (as you can't control lights when not connected)
    
    
    // Remove no connection alert
    if (self.noConnectionAlert != nil) {
        [self.noConnectionAlert dismissWithClickedButtonIndex:[self.noConnectionAlert cancelButtonIndex] animated:YES];
        self.noConnectionAlert = nil;
    }
    
    /***************************************************
     doAuthentication will start the push linking
     *****************************************************/
    
    // Start local authenticion process
    [self performSelector:@selector(doAuthentication) withObject:nil afterDelay:0.5];
}


- (void)checkConnectionState {
    if (!self.phHueSDK.localConnected) {
        // Dismiss modal views when connection is lost
        
        if (self.navigationController.presentedViewController) {
            [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
        }
        
        // No connection at all, show connection popup
        
        if (self.noConnectionAlert == nil) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            // Showing popup, so remove this view
            [self removeLoadingView];
            [self showNoConnectionDialog];
        }
        
    }
    else {
        // One of the connections is made, remove popups and loading views
        
        if (self.noConnectionAlert != nil) {
            [self.noConnectionAlert dismissWithClickedButtonIndex:[self.noConnectionAlert cancelButtonIndex] animated:YES];
            self.noConnectionAlert = nil;
        }
        [self removeLoadingView];
     //   [self performSegueWithIdentifier:@"Lights" sender:nil];
        
    }
}

/**
 Shows the first no connection alert with more connection options
 */
- (void)showNoConnectionDialog {
    
    self.noConnectionAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No connection", @"No connection alert title")
                                                        message:NSLocalizedString(@"Connection to bridge is lost", @"No Connection alert message")
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"Reconnect", @"No connection alert reconnect button"), NSLocalizedString(@"Find new bridge", @"No connection find new bridge button"),NSLocalizedString(@"Cancel", @"No connection cancel button"), nil];
    self.noConnectionAlert.tag = 1;
    [self.noConnectionAlert show];
    
}
/**
 Starts the local heartbeat with a 10 second interval
 */
- (void)enableLocalHeartbeat {
    /***************************************************
     The heartbeat processing collects data from the bridge
     so now try to see if we have a bridge already connected
     *****************************************************/
    
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    if (cache != nil && cache.bridgeConfiguration != nil && cache.bridgeConfiguration.ipaddress != nil) {
        //
        [self showLoadingViewWithText:NSLocalizedString(@"Connecting...", @"Connecting text")];
        
        // Enable heartbeat with interval of 10 seconds
        
        [self.phHueSDK enableLocalConnection];
        
        // Check if we have connected to a bridge before
        
            
        // Set the ip address of the bridge
        self.bridgeIPLabel.text = cache.bridgeConfiguration.ipaddress;
        
        // Set the identifier of the bridge
        self.bridgeIDLabel.text = cache.bridgeConfiguration.bridgeId;
  
         [self performSegueWithIdentifier:@"Lights" sender:nil];
            // Check if we are connected to the bridge right now
        }
    else {
        
        // Automaticly start searching for bridges
        [self searchForBridgeLocal];
    }
}

/**
 Stops the local heartbeat
 */
- (void)disableLocalHeartbeat {
    [self.phHueSDK disableLocalConnection];
}

#pragma mark - Bridge searching and selection

/**
 Search for bridges using UPnP and portal discovery, shows results to user or gives error when none found.
 */
- (void)searchForBridgeLocal {
    // Stop heartbeats
    [self disableLocalHeartbeat];
    
    // Show search screen
    [self showLoadingViewWithText:NSLocalizedString(@"Searching...", @"Searching for bridges text")];
    /***************************************************
     A bridge search is started using UPnP to find local bridges
     *****************************************************/
    
    // Start search
    self.bridgeSearch = [[PHBridgeSearching alloc] initWithUpnpSearch:YES andPortalSearch:YES andIpAdressSearch:YES];
    [self.bridgeSearch startSearchWithCompletionHandler:^(NSDictionary *bridgesFound) {
        // Done with search, remove loading view
        [self removeLoadingView];
        
        /***************************************************
         The search is complete, check whether we found a bridge
         *****************************************************/
        
        // Check for results
        if (bridgesFound.count > 0) {
            
            // Results were found, show options to user (from a user point of view, you should select automatically when there is only one bridge found)
            self.bridgeSelectionViewController = [[PHBridgeSelectionViewController alloc] initWithNibName:@"PHBridgeSelectionViewController" bundle:[NSBundle mainBundle] bridges:bridgesFound delegate:self];
            
            /***************************************************
             Use the list of bridges, present them to the user, so one can be selected.
             *****************************************************/
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.bridgeSelectionViewController];
            navController.modalPresentationStyle = UIModalPresentationFormSheet;
            [self.navigationController presentViewController:navController animated:YES completion:nil];
            NSLog(@"YES FOUND");
           
            
        }
        else {
            /***************************************************
             No bridge was found was found. Tell the user and offer to retry..
             *****************************************************/
            
            // No bridges were found, show this to the user
            
            self.noBridgeFoundAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No bridges", @"No bridge found alert title")
                                                                 message:NSLocalizedString(@"Could not find bridge", @"No bridge found alert message")
                                                                delegate:self
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:NSLocalizedString(@"Retry", @"No bridge found alert retry button"),NSLocalizedString(@"Cancel", @"No bridge found alert cancel button"), nil];
            self.noBridgeFoundAlert.tag = 1;
            [self.noBridgeFoundAlert show];
        }
    }];
}

/**
 Delegate method for PHbridgeSelectionViewController which is invoked when a bridge is selected
 */
- (void)bridgeSelectedWithIpAddress:(NSString *)ipAddress andBridgeId:(NSString *)bridgeId {
    
    /***************************************************
     Removing the selection view controller takes us to
     the 'normal' UI view
     *****************************************************/
    
    // Remove the selection view controller
    self.bridgeSelectionViewController = nil;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    // Show a connecting view while we try to connect to the bridge
    [self showLoadingViewWithText:NSLocalizedString(@"Connecting...", @"Connecting text")];
    
    // Set SDK to use bridge and our default username (which should be the same across all apps, so pushlinking is only required once)
    //NSString *username = [PHUtilities whitelistIdentifier];
    
    /***************************************************
     Set the ipaddress and bridge id,
     as the bridge properties that the SDK framework will use
     *****************************************************/
    
    [self.phHueSDK setBridgeToUseWithId:bridgeId ipAddress:ipAddress];
    
    /***************************************************
     Setting the hearbeat running will cause the SDK
     to regularly update the cache with the status of the
     bridge resources
     *****************************************************/
    
    // Start local heartbeat again
    [self performSelector:@selector(enableLocalHeartbeat) withObject:nil afterDelay:1];
}

#pragma mark - Bridge authentication

/**
 Start the local authentication process
 */
- (void)doAuthentication {
    // Disable heartbeats
    [self disableLocalHeartbeat];
    
    /***************************************************
     To be certain that we own this bridge we must manually
     push link it. Here we display the view to do this.
     *****************************************************/
    
    // Create an interface for the pushlinking
    self.pushLinkViewController = [[PHBridgePushLinkViewController alloc] initWithNibName:@"PHBridgePushLinkViewController" bundle:[NSBundle mainBundle] hueSDK:self.phHueSDK delegate:self];
    
    [self.navigationController presentViewController:self.pushLinkViewController animated:YES completion:^{
        /***************************************************
         Start the push linking process.
         *****************************************************/
        
        // Start pushlinking when the interface is shown
        [self.pushLinkViewController startPushLinking];
    }];
}

//- (void)doAuthentication {
//    // Disable heartbeats
//    [self disableLocalHeartbeat];
//    
//    /***************************************************
//     To be certain that we own this bridge we must manually
//     push link it. Here we display the view to do this.
//     *****************************************************/
//    
//    // Create an interface for the pushlinking
//    self.pushLinkViewController = [[PHBridgePushLinkViewController alloc] initWithNibName:@"PHBridgePushLinkViewController" bundle:[NSBundle mainBundle] hueSDK:self.phHueSDK delegate:self];
//    
//    [self.navigationController presentViewController:self.pushLinkViewController animated:YES completion:^{
//        /***************************************************
//         Start the push linking process.
//         *****************************************************/
//        
//        // Start pushlinking when the interface is shown
//        [self.pushLinkViewController startPushLinking];
//    
//}

/**
 Delegate method for PHBridgePushLinkViewController which is invoked if the pushlinking was successfull
 */
- (void)pushlinkSuccess {
    /***************************************************
     Push linking succeeded we are authenticated against
     the chosen bridge.
     *****************************************************/
    
    // Remove pushlink view controller
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    self.pushLinkViewController = nil;
    
    // Start local heartbeat
    [self performSelector:@selector(enableLocalHeartbeat) withObject:nil afterDelay:1];
}


/**
 Delegate method for PHBridgePushLinkViewController which is invoked if the pushlinking was not successfull
 */

- (void)pushlinkFailed:(PHError *)error {
    // Remove pushlink view controller
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    self.pushLinkViewController = nil;
    
    // Check which error occured
    if (error.code == PUSHLINK_NO_CONNECTION) {
        // No local connection to bridge
        [self noLocalConnection];
        
        // Start local heartbeat (to see when connection comes back)
        [self performSelector:@selector(enableLocalHeartbeat) withObject:nil afterDelay:1];
    }
    else {
        // Bridge button not pressed in time
        self.authenticationFailedAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Authentication failed", @"Authentication failed alert title")
                                                                    message:NSLocalizedString(@"Make sure you press the button within 30 seconds", @"Authentication failed alert message")
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:NSLocalizedString(@"Retry", @"Authentication failed alert retry button"), NSLocalizedString(@"Cancel", @"Authentication failed cancel button"), nil];
        [self.authenticationFailedAlert show];
    }
}

#pragma mark - Alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == self.noConnectionAlert && alertView.tag == 1) {
        // This is a no connection alert with option to reconnect or more options
        self.noConnectionAlert = nil;
        
        if (buttonIndex == 0) {
            // Retry, just wait for the heartbeat to finish
            [self showLoadingViewWithText:NSLocalizedString(@"Connecting...", @"Connecting text")];
        }
        else if (buttonIndex == 1) {
            // Find new bridge button
            [self searchForBridgeLocal];
        }
        else if (buttonIndex == 2) {
            // Cancel and disable local heartbeat unit started manually again
            [self disableLocalHeartbeat];
        }
    }
    else if (alertView == self.noBridgeFoundAlert && alertView.tag == 1) {
        // This is the alert which is shown when no bridges are found locally
        self.noBridgeFoundAlert = nil;
        
        if (buttonIndex == 0) {
            // Retry
            [self searchForBridgeLocal];
        } else if (buttonIndex == 1) {
            // Cancel and disable local heartbeat unit started manually again
            [self disableLocalHeartbeat];
        }
    }
    else if (alertView == self.authenticationFailedAlert) {
        // This is the alert which is shown when local pushlinking authentication has failed
        self.authenticationFailedAlert = nil;
        
        if (buttonIndex == 0) {
            // Retry authentication
            [self doAuthentication];
        } else if (buttonIndex == 1) {
            // Remove connecting loading message
            [self removeLoadingView];
            // Cancel authentication and disable local heartbeat unit started manually again
            [self disableLocalHeartbeat];
        }
    }
}

#pragma mark - Loading view

/**
 Shows an overlay over the whole screen with a black box with spinner and loading text in the middle
 @param text The text to display under the spinner
 */
- (void)showLoadingViewWithText:(NSString *)text {
    // First remove
    [self removeLoadingView];
    
    // Then add new
    self.loadingView = [[PHLoadingViewController alloc] initWithNibName:@"PHLoadingViewController" bundle:[NSBundle mainBundle]];
    self.loadingView.view.frame = self.navigationController.view.bounds;
    [self.navigationController.view addSubview:self.loadingView.view];
    self.loadingView.loadingLabel.text = text;
}

/**
 Removes the full screen loading overlay.
 */
- (void)removeLoadingView {
    if (self.loadingView != nil) {
        [self.loadingView.view removeFromSuperview];
        self.loadingView = nil;
    }
}

@end

