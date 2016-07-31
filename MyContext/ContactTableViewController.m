//
//  ContactTableViewController.m
//  MyContext
//
//  Created by Rajesh on 19/12/15.
//  Copyright © 2015 CDAC. All rights reserved.
//

#import "ContactTableViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
@interface ContactTableViewController ()

@end

@implementation ContactTableViewController
@synthesize arrayPerson;
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    AppDelegate *appDelegate=[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *objContext=[appDelegate managedObjectContext];
    
    //prepare selection query request to fetch student objects
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"Person"];
    //execute fetch request
    NSError *err;
    NSArray *array=[objContext executeFetchRequest:request error:&err];
    arrayPerson=[[NSMutableArray alloc]initWithArray:array];
    if (err == nil)
    {
        //NULL for basic data type
      //  NSLog(@"person data %@",arrayPerson);
        [self.tableView reloadData];
    }
    else
    {
        NSLog(@"Error : %@",err);
    }
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return arrayPerson.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    NSManagedObject *obj=[arrayPerson objectAtIndex:indexPath.row];
    NSString *name=[obj valueForKey:@"name"];
    NSNumber *mobile=[obj valueForKey:@"mobileNo"];
    NSString *imagePath1=[obj valueForKey:@"image"];
  //  NSString *str=[NSString stringWithFormat:@"%@/%@.png",imagePath,mobile];
  //  NSLog(@" name %@ mobile %@  image %@",name,mobile,imagePath1);
    NSLog(@"image path %@",imagePath1);
    cell.imageView.image=[UIImage imageWithContentsOfFile:imagePath1];
    
    cell.textLabel.text=name;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",mobile];
    
    return cell;

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *obj=[arrayPerson objectAtIndex:indexPath.row];
    NSString *name=[obj valueForKey:@"name"];
    NSNumber *mobile=[obj valueForKey:@"mobileNo"];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Person" message:name delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:@"CALL",@"Email",@"MAP", nil];
    [alert show];
}
@end
