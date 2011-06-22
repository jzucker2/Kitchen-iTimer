//
//  Kitchen_iTimerViewController.h
//  Kitchen iTimer
//
//  Created by Jordan Zucker on 6/20/11.
//  Copyright 2011 University of Illinois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BurnerChooserViewController.h"

@interface Kitchen_iTimerViewController : UIViewController <UINavigationControllerDelegate, BurnerChooserViewControllerDelegate, UIImagePickerControllerDelegate>{
    /*UIButton *button;
    UIButton * sender
     */

}

- (IBAction) camerachosen:(id)sender;
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (IBAction) chooseburners:(id)sender;


@end
