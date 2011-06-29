//
//  BurnerChooserViewController.h
//  Kitchen iTimer
//
//  Created by Jordan Zucker on 6/21/11.
//  Copyright 2011 University of Illinois. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BurnerChooserViewControllerDelegate;

@class PlacardView;

@interface BurnerChooserViewController : UIViewController {
    IBOutlet UIImageView * pic;
    PlacardView *placardView;
    
    
    
}

//@property (nonatomic, retain) IBOutlet UIImage * pic;

@property (nonatomic, retain) PlacardView *placardView;

- (void)setUpPlacardView;
- (void)animateFirstTouchAtPoint:(CGPoint)touchPoint;
//- (void)animatePlacardViewToCenter;
- (void)resetPlacardView;

@property (nonatomic, assign) id <BurnerChooserViewControllerDelegate> delegate;

- (IBAction) back:(id)sender;

//- (id)initWithImage;

//- (void) setURL;

- (IBAction) addTimer:(id)sender;


@end

@protocol BurnerChooserViewControllerDelegate

- (void)burnerChooserViewControllerDidFinish:(BurnerChooserViewController *)controller;

//- (id)initWithImage:(NSString *)url;


@end