//
//  TRDetailViewController.m
//  TheRanking
//
//  Created by Jesús Emilio Fernández de Frutos on 07/02/15.
//  Copyright (c) 2015 Jesús Emilio Fernández de Frutos. All rights reserved.
//

#import "TRDetailViewController.h"
#import <MapKit/MapKit.h>
#import "Photo.h"
#import "User.h"


@interface TRDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cameraLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imagePhoto;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation TRDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:[self.detailItem valueForKey:@"name"]];
    [self setViews];
    
}


-(void) setViews
{
    
    Photo *photo = self.detailItem;
    [self.descriptionLabel setText:[photo description_]];
    [self.cameraLabel setText:[photo camera]];
    [self.imagePhoto addObserver:self forKeyPath:@"image" options:0 context:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRDownloadImage"
                                                        object:self
                                                      userInfo:@{@"imageView":self.imagePhoto, @"url":[photo image_url]}];
    
    
    User* user = (User*)[photo user];
    [self.userNameLabel setText:[user fullname]];
    [self.avatar addObserver:self forKeyPath:@"imageAvatar" options:0 context:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRDownloadImage"
                                                        object:self
                                                      userInfo:@{@"imageView":self.avatar, @"url":[user userpic_https_url]}];
    
    if ([photo.latitude doubleValue]>0)
    {
        CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake ([photo.latitude doubleValue], [photo.longitude doubleValue]);
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:centerCoordinate];
        [self.mapView addAnnotation:annotation];
        
        MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
        MKCoordinateRegion region = {centerCoordinate, span};
        [self.mapView setRegion:region];
    }
    else
        [self.mapView setHidden:TRUE];
    
    
    self.userNameLabel.alpha = 0;
    self.cameraLabel.alpha = 0;
    self.descriptionLabel.alpha = 0;
    self.mapView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.userNameLabel.alpha = 1;
        self.cameraLabel.alpha = 1;
        self.descriptionLabel.alpha = 1;
        self.mapView.alpha = 1;
    }];
    
}

- (void)dealloc
{
    [self.imagePhoto removeObserver:self forKeyPath:@"image"];
    [self.avatar removeObserver:self forKeyPath:@"imageAvatar"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    self.imagePhoto.alpha = 0;
    self.avatar.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.imagePhoto.alpha = 1;
        self.avatar.alpha = 1;
    }];
    
    
    
}

@end
