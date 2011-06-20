//
//  Kitchen_iTimerAppDelegate.h
//  Kitchen iTimer
//
//  Created by Jordan Zucker on 6/20/11.
//  Copyright 2011 University of Illinois. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Kitchen_iTimerViewController;

@interface Kitchen_iTimerAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet Kitchen_iTimerViewController *viewController;

@end
