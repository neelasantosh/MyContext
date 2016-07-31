//
//  ViewController.h
//  MyContext
//
//  Created by Rajesh on 19/12/15.
//  Copyright © 2015 CDAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface ViewController : UIViewController<ABPeoplePickerNavigationControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textName;
@property (strong, nonatomic) IBOutlet UITextField *textEmail;

@property (strong, nonatomic) IBOutlet UITextField *textMobile;
@property (strong, nonatomic) IBOutlet UITextView *textViewAddress;
@property (strong, nonatomic) IBOutlet UILabel *labelLatLong;
@property (strong, nonatomic) IBOutlet UIImageView *contactImage;
@property (strong, nonatomic) IBOutlet UILabel *lableLongitude;
@property NSString *imagePath;
- (IBAction)actionContact:(id)sender;
- (IBAction)actionMap:(id)sender;

- (IBAction)actionGallary:(id)sender;
- (IBAction)actionAddContact:(id)sender;


@end

