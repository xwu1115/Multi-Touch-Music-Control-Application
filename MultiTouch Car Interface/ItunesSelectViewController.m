//
//  ItunesSelectViewController.m
//  MultiTouch Car Interface
//
//  Created by Shawn Wu on 4/10/14.
//  Copyright (c) 2014 Shawn Wu. All rights reserved.
//

#import "ItunesSelectViewController.h"
#import "ItunesLibraryController.h"
#import "MusicViewController.h"
@interface ItunesSelectViewController ()

@property ItunesLibraryController *itunesController;
@property NSMutableArray *itunesSelectionTitleArray;
@property NSMutableArray *previousItunesTitleArray;
@property (weak, nonatomic) IBOutlet UITableView *itunesTableView;

@end

@implementation ItunesSelectViewController
@synthesize itunesController = _itunesController,previousItunesTitleArray = _previousItunesTitleArray;
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
     self.itunesTableView.delegate = self;
    self.itunesTableView.dataSource = self;
    // Do any additional setup after loading the view.
    _itunesController = [[ItunesLibraryController alloc]init];
   
    NSDictionary *itunesPlistDic = [self createPlistForItunesPrefs];
    
    self.itunesSelectionTitleArray = [itunesPlistDic objectForKey:@"itunesTitle"];
    _previousItunesTitleArray = [self.itunesSelectionTitleArray copy];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.itunesTableView reloadData];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)handleSelectButtonPressed:(id)sender {
    
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
    [picker setDelegate: self];
    [picker setAllowsPickingMultipleItems: YES];
    [self presentModalViewController: picker animated: YES];
    
}

#pragma marks audio picker delegate method

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker
   didPickMediaItems: (MPMediaItemCollection *) collection
{
    for (int i = 0; i<[collection.items count]; i++ )
    {
        NSString *itemTitle = [[collection.items objectAtIndex:i] valueForProperty:MPMediaItemPropertyTitle];
        
        if (i<[self.itunesSelectionTitleArray count]) {
            [self.itunesSelectionTitleArray removeObjectAtIndex:i];
        }
        
        [self.itunesSelectionTitleArray insertObject:itemTitle atIndex:i];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
 
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(NSDictionary *)createPlistForItunesPrefs
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	// get documents path
	NSString *documentsPath = [paths objectAtIndex:0];
	// get the path to our Data/plist file
	NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"ItunesPrefs.plist"];
    // check to see if Data.plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
	{
		// if not in documents, get property list from main bundle
        
        [[NSFileManager defaultManager]copyItemAtPath: [[NSBundle mainBundle] pathForResource:@"ItunesPrefs" ofType:@"plist"] toPath:plistPath error: nil];
        
	}
    
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	// convert static property liost into dictionary object
	NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
	if (!temp)
	{
		NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
	}
    return temp;
}

-(void)saveTitlesIntoPlist:(NSDictionary *)plistDict{
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	// get documents path
	NSString *documentsPath = [paths objectAtIndex:0];
	// get the path to our Data/plist file
	NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"ItunesPrefs.plist"];
    // check to see if Data.plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
	{
		// if not in documents, get property list from main bundle
		
        NSError *newError = nil;
        [[NSFileManager defaultManager]copyItemAtPath: [[NSBundle mainBundle] pathForResource:@"ItunesPrefs" ofType:@"plist"] toPath:plistPath error: &newError];
        
	}
       
	// create NSData from dictionary
    NSData *plistFile = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
	
    // check is plistData exists
	if(plistFile)
	{
		// write plistData to our Data.plist file
        [plistFile writeToFile:plistPath atomically:YES];
    }
    else
	{
        NSLog(@"Error in saveData: %@", error);
        
    }
}

- (IBAction)canelPrefs:(id)sender {
    
    NSMutableDictionary *itunesPlistDic = [[NSMutableDictionary alloc]init];
    [itunesPlistDic setValue:_previousItunesTitleArray forKey:@"itunesTitle"];
    [self saveTitlesIntoPlist:itunesPlistDic];
    [self dismissViewControllerAnimated:YES completion:nil];
  
}
- (IBAction)savePrefs:(id)sender {
    
    NSMutableDictionary *itunesPlistDic = [[NSMutableDictionary alloc]init];
    [itunesPlistDic setValue:self.itunesSelectionTitleArray forKey:@"itunesTitle"];
    [self saveTitlesIntoPlist:itunesPlistDic];
    
    MusicViewController *musicViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"music"];
    
    [self presentViewController:musicViewController animated:YES completion:nil];
}

#pragma mark tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.itunesSelectionTitleArray) {
        
        return [self.itunesSelectionTitleArray count];
    }
    else{
       return 0 ;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier] ;
    }
    if (self.itunesSelectionTitleArray) {
        
        cell.textLabel.text = [self.itunesSelectionTitleArray objectAtIndex:indexPath.row];

    }
    return cell;
    
}


@end
