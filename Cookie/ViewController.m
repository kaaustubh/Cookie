//
//  ViewController.m
//  Cookie
//
//  Created by Kaustubh on 13/09/15.
//  Copyright (c) 2015 Default. All rights reserved.
//

#import "ViewController.h"
#import "ProductsManager.h"
#import "ProductCell.h"
#import "Product.h"



@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate, UIPickerViewDelegate>
{
    int currentPageIndex;
}

@property (nonatomic, strong) NSMutableArray *arrOfProducts;
@property (nonatomic, weak) IBOutlet UITableView *productsTable;
@property (assign) SortType currentSortType;
@property (nonatomic, strong) UIPickerView *sortPicketView;
@property (nonatomic, strong) NSArray *pickerArr;
@property (nonatomic, strong) UIActionSheet *pickerViewPopup;



@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pickerArr=[[NSArray alloc]initWithObjects:@"Name: Ascending", @"Name: Descending",@"Price: Ascending",@"Price: Descending", nil];
    _currentSortType=SORT_TYPE_NONE;
    _productsTable.delegate=self;
    _productsTable.dataSource=self;
    currentPageIndex=0;
    [self getNextProductLineUp];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arrOfProducts.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCell *cell;
    if (indexPath.section==_arrOfProducts.count)
    {
        static NSString *loadingCellId = @"LoadingCell";
        UITableViewCell *loadingCell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:loadingCellId];
        UIActivityIndicatorView *actView=(UIActivityIndicatorView *)[loadingCell viewWithTag:1];
        [actView startAnimating];
        return loadingCell;
    }
    else
    {
        ProductCell *cell;
        static NSString *simpleTableIdentifier = @"CustomCell";
        cell = (ProductCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cell.layer.borderWidth=1.0;
        cell.layer.cornerRadius=5.0;
        [self setUpCustomCell:cell forProduct:_arrOfProducts[indexPath.section]];
        return cell;
    }
    return cell;
}


-(void)setUpCustomCell:(ProductCell*)cell forProduct:(Product *)product
{
    cell.priceLabel.text=[NSString stringWithFormat:@"$%.2f", product.productPrice];
    cell.nameLabel.text=[NSString stringWithFormat:@"%@", product.productName];
    cell.brandLabel.text=[NSString stringWithFormat:@"%@", product.productBrand];
    [cell.custImageView setURLString:product.productImages[0]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //this is the space
    return 10.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] init];
    view.backgroundColor=[UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height;
    if (indexPath.section==_arrOfProducts.count)
    {
        height=50.0f;
    }
    else
    {
        height=120.0f;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==_arrOfProducts.count)
    {
        [self getNextProductLineUp];
    }
}


-(void)getNextProductLineUp
{
    currentPageIndex+=1;
    [[ProductsManager sharedManager] getAllProductsForPageIndex:currentPageIndex Completion:^(NSArray *arr, NSError *error)
     {
         if (!_arrOfProducts)
         {
             _arrOfProducts=[NSMutableArray array];
         }
         [_arrOfProducts addObjectsFromArray:arr];
         [_productsTable reloadData];
     }];
}

-(IBAction)showSortPicker:(id)sender
{

}

-(void)cancelButtonTapped
{
    
}

-(void)doneButtonTapped
{
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"Picket selected");
}
// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_pickerArr count];
}

// tell the picker how many components it will have
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_pickerArr objectAtIndex: row];
}

-(void)addPicker
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Sort" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet showInView:self.view];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 470.0)];
    
    UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0.0, 44.0, 320.0, 250.0)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleBlack;
    [pickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *btnBarCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
    [barItems addObject:btnBarCancel];
    
    [pickerToolbar setItems:barItems animated:YES];
    
    [actionSheet addSubview:pickerToolbar];
    [actionSheet addSubview:pickerView];
    [self.view addSubview:actionSheet];
}

@end
