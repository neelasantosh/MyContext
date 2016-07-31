//
//  ViewController.m
//  MyContext
//
//  Created by Rajesh on 19/12/15.
//  Copyright © 2015 CDAC. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "MapViewController.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize textEmail,textMobile,textName,textViewAddress,labelLatLong,lableLongitude,contactImage,imagePath;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    imagePath=[NSString stringWithFormat:@"%@/profile.png",[pathArray objectAtIndex:0]];
    
  //  contactImage.image=[UIImage imageWithContentsOfFile:imagePath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionContact:(id)sender {
    
    ABPeoplePickerNavigationController *peopleCon=[[ABPeoplePickerNavigationController alloc]init];
    
    peopleCon.peoplePickerDelegate=self;
    
    [self presentViewController:peopleCon animated:true completion:nil];
}

- (IBAction)actionMap:(id)sender {
    
}

//delegate method to receive picked contact

-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    NSLog(@"the contact : %@",person);
    [peoplePicker dismissViewControllerAnimated:true completion:nil];
    //get first name from person record
    // CFTypeRef v= ABRecordCopyValue(person, <#ABPropertyID property#>);
    
    CFTypeRef cfTypeName=ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    //convert core foundation type into Nsstring
    
    NSString *fName=(__bridge_transfer NSString *)cfTypeName;
    
    NSString *lName=(__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    textName.text=[NSString stringWithFormat:@"%@ %@",fName,lName];
    
    //get multiple values like mobile or email from person record
    ABMultiValueRef phoneRef=ABRecordCopyValue(person,kABPersonPhoneProperty);
    
    //get one phone at a time from multivalue type
    long count=ABMultiValueGetCount(phoneRef);
    for (int i=0; i<count; i++) {
        CFTypeRef cfTypePhone = ABMultiValueCopyValueAtIndex(phoneRef, i);
        NSString *phone=(__bridge_transfer NSString *)cfTypePhone;
        textMobile.text=phone;
        
        
      //  NSLog(@"%d %@",i,phone);
        
        
        ABMultiValueRef emailRef=ABRecordCopyValue(person,kABPersonEmailProperty);
        
        //get one email at a time from multivalue type
        long count=ABMultiValueGetCount(emailRef);
        for (int i=0; i<count; i++) {
            CFTypeRef cfTypeEmail = ABMultiValueCopyValueAtIndex(emailRef, i);
            NSString *email=(__bridge_transfer NSString *)cfTypeEmail;
            textEmail.text=email;
            
           // NSLog(@"%d %@",i,email);
            
        }
        
    }

}



- (IBAction)actionGallary:(id)sender {
    
    //common controller to pick image from either gallary or camera
    UIImagePickerController *imgCon=[[UIImagePickerController alloc]init];
    //setgallary as image source
    imgCon.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //set delegate
    imgCon.delegate=self;
    imgCon.allowsEditing=true;
    
    //show the controller
    [self presentViewController:imgCon animated:true completion:nil];
}

//method from delegate protocol to receive selected image

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickedImage=[info objectForKey:UIImagePickerControllerEditedImage];
    
    contactImage.image=pickedImage;
    //close imagePickerController
    [picker dismissViewControllerAnimated:true completion:nil];
    
    //save picked image at imagePath
    
    
    
    NSLog(@"image path : %@",imagePath);
}

- (IBAction)actionAddContact:(id)sender {
    
    
    //access Managed Object context which is in appdelegate
    AppDelegate *delegate=[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *objContext=[delegate managedObjectContext];
    
    //create a new empty entity for student in object context
    
    NSManagedObject *obj=[NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:objContext];
    
    //set attribute value in empty object
    
    NSNumber *mobile=[NSNumber numberWithInt:[textMobile.text intValue]];
    NSNumber *lat=[NSNumber numberWithInt:[labelLatLong.text floatValue]];
    NSNumber *longitude=[NSNumber numberWithInt:[lableLongitude.text floatValue]];
    NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    imagePath=[NSString stringWithFormat:@"%@/%@.png",[pathArray objectAtIndex:0],mobile];
    
    NSData *imageData = UIImagePNGRepresentation(contactImage.image);
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    [fileManager createFileAtPath:imagePath contents:imageData attributes:nil];
    
    [obj setValue:lat forKey:@"mobileNo"];
    [obj setValue:mobile forKey:@"latitude"];
    [obj setValue:longitude forKey:@"longitude"];
    [obj setValue:textName.text forKey:@"name"];
    [obj setValue:textEmail.text forKey:@"email"];
    [obj setValue:textViewAddress.text forKey:@"address"];
    [obj setValue:imagePath forKey:@"image"];
    //save object context
    NSError *err;
    BOOL result=[objContext save:&err];
    NSLog(@"result : %d error : %@",result,err);
    if (result==true)
    {
        textViewAddress.text=@"";
        textName.text=@"";
        textEmail.text=@"";
        textMobile.text=@"";
        lableLongitude.text=@"";
        labelLatLong.text=@"";
        contactImage.image=nil;
        NSLog(@"image save at %@",imagePath);
    }
    else
    {
        NSLog(@"Error");
    }
    

}
@end
