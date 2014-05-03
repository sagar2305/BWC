//
//  HTMLDetailViewController.h
//  HTMLParse
//
//  Created by Sagar Mutha on 4/18/14.
//  Copyright (c) 2014 Sagar Mutha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWCDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
