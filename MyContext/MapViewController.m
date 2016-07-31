//
//  MapViewController.m
//  MyContext
//
//  Created by Rajesh on 19/12/15.
//  Copyright © 2015 CDAC. All rights reserved.
//

#import "MapViewController.h"
#import "ViewController.h"
@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapContact,locManager;
- (void)viewDidLoad {
    [super viewDidLoad];

    locManager=[[CLLocationManager alloc]init];
    [locManager requestWhenInUseAuthorization];
    
    //map proerties
    mapContact.delegate=self;
    [mapContact setZoomEnabled:true];
    [mapContact setMapType:MKMapTypeStandard];
    
    //attach longPress gesture recognizer with map
    
    UILongPressGestureRecognizer *longPressRecognize=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(onMapLongPress:)];
    
    [mapContact addGestureRecognizer:longPressRecognize];
    [mapContact setUserInteractionEnabled:true];
    longPressRecognize.minimumPressDuration=0.5;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onMapLongPress:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state==UIGestureRecognizerStateRecognized)
    {
        CGPoint pointOfTouch=[gesture locationInView:mapContact];
        //convert x,y to lat long
        
        CLLocationCoordinate2D loc=[mapContact convertPoint:pointOfTouch toCoordinateFromView:mapContact];
        
        
        CLGeocoder *geo=[[CLGeocoder alloc]init];
        CLLocation *location1=[[CLLocation alloc]initWithLatitude:loc.latitude longitude:loc.longitude];
        [geo reverseGeocodeLocation:location1 completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)
         {
             //get nearest address
             CLPlacemark *place=[placemarks objectAtIndex:0];
             NSLog(@"%@",place.addressDictionary);
             ViewController *con=[[self.navigationController viewControllers] objectAtIndex:0];
             con.labelLatLong.text=[NSString stringWithFormat:@"%f",loc.latitude];
             con.lableLongitude.text=[NSString stringWithFormat:@"%f",loc.longitude];
             con.textViewAddress.text=[place.addressDictionary objectForKey:@"State"];
             [self.navigationController popViewControllerAnimated:true];
             
         }];
    }
}

@end
