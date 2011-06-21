//
//  Kitchen_iTimerViewController.m
//  Kitchen iTimer
//
//  Created by Jordan Zucker on 6/20/11.
//  Copyright 2011 University of Illinois. All rights reserved.
//

#import "Kitchen_iTimerViewController.h"



@implementation Kitchen_iTimerViewController


- (void)camerachosen:(UIButton *)sender{
    // Create image picker controller
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // Set source to the camera
	imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
    // Delegate is self
	imagePicker.delegate = self;
    
    // Allow editing of image ?
	imagePicker.allowsEditing = NO;
    
    // Show image picker
	[self presentModalViewController:imagePicker animated:YES];	
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSError *error;
    
	// Access the uncropped image from info dictionary
	UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Create paths to output images
    NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.jpg"];
    
    // Write a UIImage to JPEG with minimum compression (best quality)
    // The value 'image' must be a UIImage object
    // The value '1.0' represents image compression quality as value from 0.0 to 1.0
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
    
    // Write image to PNG
    [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
    
    // Let's check to see if files were successfully written...
    // You can try this when debugging on-device
    
    // Create file manager
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // Point to Document directory
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    // Write out the contents of home directory to console
    NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
    
	// Dismiss the camera
	[self dismissModalViewControllerAnimated:YES];
    
	[picker release];
}


- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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

@end
