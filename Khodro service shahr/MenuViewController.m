//
//  MenuViewController.m
//  Khodro service shahr
//
//  Created by aDb on 1/18/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import "MenuViewController.h"
#import "UIImage+ImageEffects.h"
#import "UIView+Genie.h"

@interface MenuViewController ()
{
    LNERadialMenu *thisMenu;
}
@property (nonatomic) BOOL viewIsIn;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    CGPoint location =    [[[UIApplication sharedApplication] delegate] window].center;
    
    thisMenu = [[LNERadialMenu alloc] initFromPoint:location withDataSource:self andDelegate:self];
    [thisMenu showMenu:self.view];

}

-(NSInteger) numberOfButtonsForRadialMenu:(LNERadialMenu *)radialMenu{
    
    return 6;
    
}

-(CGFloat) radiusLenghtForRadialMenu:(LNERadialMenu *)radialMenu{
    return 110;
}

-(UIButton *)radialMenu:(LNERadialMenu *)radialMenu elementAtIndex:(NSInteger)index{
    
    UIButton *element = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
    
    switch (index) {
        case 0:
        {
            
            
            UIImage *settingImage = [UIImage imageNamed:@"home.png"] ;
            
            element.backgroundColor = [UIColor whiteColor];
            element.layer.cornerRadius = element.bounds.size.height/2.0;
            
            [element setImage:settingImage forState:UIControlStateNormal];
            element.layer.borderColor = [UIColor blackColor].CGColor;
            element.layer.borderWidth = 1;
            element.tag = index;
        }
            break;
            
            
        case 1:
        {
            
            UIImage *settingImage = [UIImage imageNamed:@"map.png"] ;
            element.backgroundColor = [UIColor whiteColor];
            element.layer.cornerRadius = element.bounds.size.height/2.0;
            
            [element setImage:settingImage forState:UIControlStateNormal];
            element.layer.borderColor = [UIColor blackColor].CGColor;
            element.layer.borderWidth = 1;
            element.tag = index;
            
        }
            break;
            
        case 2:
        {
            UIImage *settingImage = [UIImage imageNamed:@"pol.png"] ;
            
            
            element.backgroundColor = [UIColor whiteColor];
            element.layer.cornerRadius = element.bounds.size.height/2.0;
            
            [element setImage:settingImage forState:UIControlStateNormal];
            element.layer.borderColor = [UIColor blackColor].CGColor;
            element.layer.borderWidth = 1;
            element.tag = index;
            
        }
            break;
            
        case 3:
        {
            UIImage *settingImage = [UIImage imageNamed:@"globe.png"] ;
            
            
            element.backgroundColor = [UIColor whiteColor];
            element.layer.cornerRadius = element.bounds.size.height/2.0;
            
            [element setImage:settingImage forState:UIControlStateNormal];
            element.layer.borderColor = [UIColor blackColor].CGColor;
            element.layer.borderWidth = 1;
            element.tag = index;
            
            
            
        }
            break;
            
        case 4:
        {
            
            UIImage *settingImage = [UIImage imageNamed:@"weather"] ;
            
            element.backgroundColor = [UIColor whiteColor];
            element.layer.cornerRadius = element.bounds.size.height/2.0;
            
            [element setImage:settingImage forState:UIControlStateNormal];
            element.layer.borderColor = [UIColor blackColor].CGColor;
            element.layer.borderWidth = 1;
            element.tag = index;
            
        }
            break;
        case 5:
        {
            
            UIImage *settingImage = [UIImage imageNamed:@"user"] ;
            
            element.backgroundColor = [UIColor whiteColor];
            element.layer.cornerRadius = element.bounds.size.height/2.0;
            
            [element setImage:settingImage forState:UIControlStateNormal];
            element.layer.borderColor = [UIColor blackColor].CGColor;
            element.layer.borderWidth = 1;
            element.tag = index;
            
        }
            break;
            
        default:
            break;
    }
    
    
    
    
    return element;
}

-(void)radialMenu:(LNERadialMenu *)radialMenu didSelectButton:(UIButton *)button{
    NSLog(@"button(element) index:%ld",(long)button.tag);
    
    switch (button.tag) {
        case 0:
        {
            
            [radialMenu closeMenu];
            [self PrepareForNextBoard];
            
        }
            break;
        case 1:
        {
            [radialMenu closeMenu];
            [self PrepareForNextBoard];
            
        }
            break;
            
        case 2:
        {
            [radialMenu closeMenu];
            [self PrepareForNextBoard];
            
        }
            break;
            
        case 3:
        {
            [radialMenu closeMenu];
            [self PrepareForNextBoard];
            
            
        }
            break;
            
        case 4:
        {
            
            [radialMenu closeMenu];
            [self PrepareForNextBoard];
        }
            break;
            
        case 5:
        {
            [radialMenu closeMenu];
            [self PrepareForNextBoard];
            
        }
            break;
            
        default:
            break;
    }
}

-(void)PrepareForNextBoard
{
    [self genieToRect:CGRectMake(self.view.center.x-27, self.view.frame.size.height-90, 50, 50) edge:BCRectEdgeTop];
    [self performSelector:@selector(NextBoard) withObject:nil afterDelay:.25];
}

-(void)NextBoard
{
             [self performSegueWithIdentifier:@"tomain" sender:self];
}

-(UIView *)viewForCenterOfRadialMenu:(LNERadialMenu *)radialMenu{
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    UIImageView *backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_splash_blur.png"]];
    [backImage setFrame:CGRectMake(0, 0, 400, 400)];
    
    UIImageView *logoImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo (2).png"]];
    
    [logoImage setFrame:CGRectMake(42, 30, 70, 75)];
    
    [logoImage setContentMode:UIViewContentModeScaleAspectFill];
    
    
    [centerView addSubview:backImage];
    [centerView addSubview:logoImage];

    return centerView;
}

-(void)radialMenu:(LNERadialMenu *)radialMenu customizationForRadialMenuView:(UIView *)radialMenuView{
    CALayer *bgLayer = [CALayer layer];
    bgLayer.backgroundColor = [UIColor clearColor].CGColor;
    bgLayer.borderColor = [UIColor colorWithWhite:200.0/255.0 alpha:1].CGColor;
    bgLayer.borderWidth = 1;
    bgLayer.cornerRadius = radialMenu.menuRadius;
    bgLayer.frame = CGRectMake(radialMenuView.frame.size.width/2.0-radialMenu.menuRadius, radialMenuView.frame.size.height/2.0-radialMenu.menuRadius, radialMenu.menuRadius*2, radialMenu.menuRadius*2);
    [radialMenuView.layer insertSublayer:bgLayer atIndex:0];
}

-(BOOL)canDragRadialMenu:(LNERadialMenu *)radialMenu{
    return NO;
}

- (void) genieToRect: (CGRect)rect edge: (BCRectEdge) edge
{
    NSTimeInterval duration = .69f;
    
    CGRect endRect = CGRectInset(rect, 5.0, 5.0);
    
        [thisMenu genieInTransitionWithDuration:duration destinationRect:endRect destinationEdge:edge  completion:^{

            
             }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
