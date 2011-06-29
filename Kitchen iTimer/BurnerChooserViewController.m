//
//  BurnerChooserViewController.m
//  Kitchen iTimer
//
//  Created by Jordan Zucker on 6/21/11.
//  Copyright 2011 University of Illinois. All rights reserved.
//

#import "BurnerChooserViewController.h"
#import "PlacardView.h"

#import <QuartzCore/QuartzCore.h>


@implementation BurnerChooserViewController

@synthesize delegate=_delegate;
@synthesize placardView;


// start of placard animations

/*
 If the view is stored in the nib file, when it's unarchived it's sent -initWithCoder:.
 This is the case in the example as provided.  See also initWithFrame:.
 */
- (id)initWithCoder:(NSCoder *)coder {
	
	self = [super initWithCoder:coder];
	if (self) {
		[self setUpPlacardView];
	}
	return self;
}


- (void)setUpPlacardView {
	// Create the placard view -- its init method calculates its frame based on its image
	PlacardView *aPlacardView = [[PlacardView alloc] init];
	self.placardView = aPlacardView;
	[aPlacardView release];
	placardView.center = pic.center;
	[pic addSubview:placardView];
    [pic bringSubviewToFront:placardView];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// We only support single touches, so anyObject retrieves just that touch from touches
	UITouch *touch = [touches anyObject];
	
	// Only move the placard view if the touch was in the placard view
	if ([touch view] != placardView) {
		// In case of a double tap outside the placard view, update the placard's display string
		if ([touch tapCount] == 2) {
			[placardView setupNextDisplayString];
		}
		return;
	}
	// Animate the first touch
	CGPoint touchPoint = [touch locationInView:pic];
	[self animateFirstTouchAtPoint:touchPoint];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	// If the touch was in the placardView, move the placardView to its location
	if ([touch view] == placardView) {
		CGPoint location = [touch locationInView:pic];
		placardView.center = location;		
		return;
	}
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	// If the touch was in the placardView, bounce it back to the center
	if ([touch view] == placardView) {
		// Disable user interaction so subsequent touches don't interfere with animation
		pic.userInteractionEnabled = NO;
        
		//[self animatePlacardViewToCenter];
        [self resetPlacardView];
		return;
	}		
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	
	/*
     To impose as little impact on the device as possible, simply set the placard view's center and transformation to the original values.
     */
	placardView.center = pic.center;
	placardView.transform = CGAffineTransformIdentity;
}


/*
 First of two possible implementations of animateFirstTouchAtPoint: illustrating different behaviors.
 To choose the second, replace '1' with '0' below.
 */

#if 1

- (void)growAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	
#define MOVE_ANIMATION_DURATION_SECONDS 0.15
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:MOVE_ANIMATION_DURATION_SECONDS];
	placardView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);	
	/*
	 Move the placardView to under the touch.
	 We passed the location wrapped in an NSValue as the context.
	 Get the point from the value, then release the value because we retained it in touchesBegan:withEvent:.
	 */
	NSValue *touchPointValue = (NSValue *)context;
	placardView.center = [touchPointValue CGPointValue];
	[touchPointValue release];
	[UIView commitAnimations];
}

- (void)animateFirstTouchAtPoint:(CGPoint)touchPoint {
	/*
	 "Pulse" the placard view by scaling up then down, then move the placard to under the finger.
	 
	 This illustrates using UIView's built-in animation.  We want, though, to animate the same property (transform) twice -- first to scale up, then to shrink.  You can't animate the same property more than once using the built-in animation -- the last one wins.  So we'll set a delegate action to be invoked after the first animation has finished.  It will complete the sequence.
	 Note that we can pass information -- in this case, the using the context.  The context needs to be a pointer. A convenient way to pass a CGPoint here is to wrap it in an NSValue object.  However, the value returned from valueWithCGPoint is autoreleased.  Normally this wouldn't be an issue because typically if you need to use the value later you store it as an instance variable using an accessor method that retains it, or pass it to another object which retains it.  In this case, though, it's being passed as a void * parameter, and it's not retained by the UIView class.  By the time the delegate method is called, therefore, the autorelease pool will have been popped and the value would no longer be valid.  To address this problem, retain the value here, and release it in the delegate method.
	 */
	
#define GROW_ANIMATION_DURATION_SECONDS 0.15
	
	NSValue *touchPointValue = [[NSValue valueWithCGPoint:touchPoint] retain];
	[UIView beginAnimations:nil context:touchPointValue];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
	CGAffineTransform transform = CGAffineTransformMakeScale(1.2f, 1.2f);
	placardView.transform = transform;
	[UIView commitAnimations];
}

#else

/*
 Alternate behavior.
 The preceding implementation grows the placard in place then moves it to the new location and shrinks it at the same time.  An alternative is to move the placard for the total duration of the grow and shrink operations; this gives a smoother effect.
 
 */

- (void)animateFirstTouchAtPoint:(CGPoint)touchPoint {
	
#define GROW_ANIMATION_DURATION_SECONDS 0.15
#define SHRINK_ANIMATION_DURATION_SECONDS 0.15
	
	/*
	 Create two separate animations, the first for the grow, which uses a delegate method as before to start an animation for the shrink operation. The second animation here lasts for the total duration of the grow and shrink animations and is responsible for performing the move.
	 */
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
	CGAffineTransform transform = CGAffineTransformMakeScale(1.2, 1.2);
	placardView.transform = transform;
	[UIView commitAnimations];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS + SHRINK_ANIMATION_DURATION_SECONDS];
	placardView.center = touchPoint;
	[UIView commitAnimations];
}


- (void)growAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:SHRINK_ANIMATION_DURATION_SECONDS];
	placardView.transform = CGAffineTransformMakeScale(1.1, 1.1);	
	[UIView commitAnimations];
}


#endif
 /*

- (void)animatePlacardViewToCenter {
	
	// Bounces the placard back to the center
    
	CALayer *welcomeLayer = placardView.layer;
	
	// Create a keyframe animation to follow a path back to the center
	CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	bounceAnimation.removedOnCompletion = NO;
	
	CGFloat animationDuration = 1.5f;
    
	
	// Create the path for the bounces
	CGMutablePathRef thePath = CGPathCreateMutable();
	
	CGFloat midX = self.center.x;
	CGFloat midY = self.center.y;
	CGFloat originalOffsetX = placardView.center.x - midX;
	CGFloat originalOffsetY = placardView.center.y - midY;
	CGFloat offsetDivider = 4.0f;
	
	BOOL stopBouncing = NO;
	
	// Start the path at the placard's current location
	CGPathMoveToPoint(thePath, NULL, placardView.center.x, placardView.center.y);
	CGPathAddLineToPoint(thePath, NULL, midX, midY);
	
	// Add to the bounce path in decreasing excursions from the center
	while (stopBouncing != YES) {
		CGPathAddLineToPoint(thePath, NULL, midX + originalOffsetX/offsetDivider, midY + originalOffsetY/offsetDivider);
		CGPathAddLineToPoint(thePath, NULL, midX, midY);
        
		offsetDivider += 4;
		animationDuration += 1/offsetDivider;
		if ((abs(originalOffsetX/offsetDivider) < 6) && (abs(originalOffsetY/offsetDivider) < 6)) {
			stopBouncing = YES;
		}
	}
	
	bounceAnimation.path = thePath;
	bounceAnimation.duration = animationDuration;
	CGPathRelease(thePath);
	
	// Create a basic animation to restore the size of the placard
	CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	transformAnimation.removedOnCompletion = YES;
	transformAnimation.duration = animationDuration;
	transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
	
	
	// Create an animation group to combine the keyframe and basic animations
	CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	
	// Set self as the delegate to allow for a callback to reenable user interaction
	theGroup.delegate = self;
	theGroup.duration = animationDuration;
	theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	
	theGroup.animations = [NSArray arrayWithObjects:bounceAnimation, transformAnimation, nil];
	
	
	// Add the animation group to the layer
	[welcomeLayer addAnimation:theGroup forKey:@"animatePlacardViewToCenter"];
	
	// Set the placard view's center and transformation to the original values in preparation for the end of the animation
	//placardView.center = self.center;
	placardView.transform = CGAffineTransformIdentity;
}
*/


- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
	//Animation delegate method called when the animation's finished:
	// restore the transform and reenable user interaction
	placardView.transform = CGAffineTransformIdentity;
	pic.userInteractionEnabled = YES;
}

- (void) resetPlacardView {
    placardView.transform = CGAffineTransformIdentity;
    pic.userInteractionEnabled = YES;
}


// end of placard animations

//@synthesize pic;

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 */

- (void)dealloc
{
    [placardView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/stove.jpg"];
    
    NSLog(@"jpgPath is %@", jpgPath);
    
    
    //UIImage *img = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: jpgPath]]];
    
    //UIImage *image = [UIImage imageNamed: @"stove.jpg"];
    
    //[BurnerChooserViewController.pic setImage:[UIImage imageNamed:value]];
    
    //NSLog(@"img is %@", img);
    
    //pic.image = [UIImage imageNamed:@"stove.jpg"];
    
    UIImage *image = [UIImage imageWithContentsOfFile: jpgPath];
    
    //NSLog(@"image is %@", image);
    
    //[self.pic.imgView setImage:img];
    
    //NSLog(@"image is %@", image);
    
    [pic setImage:image];
    
    //[pic setHidden: NO];
    
    NSError *error;
    
    // Let's check to see if files were successfully written...
    // You can try this when debugging on-device
    
    // Create file manager
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // Point to Document directory
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    // Write out the contents of home directory to console
    NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma Actions

- (IBAction)back:(id)sender
{
    [self.delegate burnerChooserViewControllerDidFinish:self];
}

- (IBAction) addTimer:(id)sender {
    [self setUpPlacardView];
}

/*
- (void) setURL {
    
    NSError *error;
    
    // Let's check to see if files were successfully written...
    // You can try this when debugging on-device
    
    // Create file manager
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // Point to Document directory
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    // Write out the contents of home directory to console
    NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
}
 */



@end
