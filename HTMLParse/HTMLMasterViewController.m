//
//  HTMLMasterViewController.m
//  HTMLParse
//
//  Created by Sagar Mutha on 4/18/14.
//  Copyright (c) 2014 Sagar Mutha. All rights reserved.
//

#import "HTMLMasterViewController.h"

#import "HTMLDetailViewController.h"
#import "TFHpple.h"
#import "Tutorial.h"
#import "Contributor.h"

#define BASE_WEBSITE_URL @"http://www.desirulez.net/"

@interface HTMLMasterViewController () {
    NSMutableArray *_objects;
    NSMutableArray *_contributors;
}
@end

@implementation HTMLMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)loadContributors {
    // 1
    NSURL *contributorsUrl = [NSURL URLWithString:@"http://www.raywenderlich.com/about"];
    NSData *contributorsHtmlData = [NSData dataWithContentsOfURL:contributorsUrl];
    
    // 2
    TFHpple *contributorsParser = [TFHpple hppleWithHTMLData:contributorsHtmlData];
    
    // 3
    NSString *contributorsXpathQueryString = @"//ul[@class='team-members']/li";
    NSArray *contributorsNodes = [contributorsParser searchWithXPathQuery:contributorsXpathQueryString];
    
    // 4
    NSMutableArray *newContributors = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in contributorsNodes) {
        // 5
        Contributor *contributor = [[Contributor alloc] init];
        [newContributors addObject:contributor];
        
        // 6
        for (TFHppleElement *child in element.children) {
            if ([child.tagName isEqualToString:@"img"]) {
                // 7
                @try {
                    contributor.imageUrl = [@"http://www.raywenderlich.com" stringByAppendingString:[child objectForKey:@"src"]];
                }
                @catch (NSException *e) {}
            } else if ([child.tagName isEqualToString:@"h3"]) {
                // 8
                contributor.name = [[child firstChild] content];
            }
        }
    }
    
    // 9
    _contributors = newContributors;
    [self.tableView reloadData];
}

-(void)loadTutorials {
    // 1
    NSURL *tutorialsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/forumdisplay.php?f=176", BASE_WEBSITE_URL]];
//    NSURL *tutorialsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/forumdisplay.php?f=20", BASE_WEBSITE_URL]];
    NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
    NSString *html = [[NSString alloc] initWithData:tutorialsHtmlData encoding:NSUTF8StringEncoding];
    
    // 2
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:tutorialsHtmlData];
    
    // 3
//    NSString *tutorialsXpathQueryString = @"//h3[@class='threadtitle']";
    NSString *tutorialsXpathQueryString = @"//h2[@class='forumtitle']";
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    
    // 4
    NSMutableArray *newTutorials = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in tutorialsNodes) {
        // 5
        Tutorial *tutorial = [[Tutorial alloc] init];
        BOOL isValid = YES;
        
        // 6
        for (TFHppleElement *child in element.children) {
            // 6
            NSString *title = [[child firstChild] content];
            if(!title && [title rangeOfString:@"Past Shows" options:NSCaseInsensitiveSearch].location != NSNotFound)
                isValid = NO;
            tutorial.title = title;
            
            // 7
            NSString *url = [child objectForKey:@"href"];
            
            if(url && [url rangeOfString:@"http"].location == NSNotFound)
            {
                url = [NSString stringWithFormat:@"%@%@", BASE_WEBSITE_URL, url];
                tutorial.url = url;
            }
            else
                isValid = NO;
        }
        
        if(isValid)
            [newTutorials addObject:tutorial];
    }
    
    // 8
    _objects = newTutorials;
    [self.tableView reloadData];
}

//- (void)getTvData
//{
//    NSDictionary *tv_data = @{"channels": {"UTV Stars":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/uu/utv_stars.jpg",
//            "channelType": "IND",
//            "running_tvshows_url": "/forumdisplay.php?f=1274",
//            "finished_tvshows_url": "/forumdisplay.php?f=1435"},
//        "Star Plus":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/ss/star_plus.jpg",
//            "channelType": "IND",
//            "running_tvshows_url": "/forumdisplay.php?f=42",
//            "finished_tvshows_url": "/forumdisplay.php?f=209"},
//        "Zee TV":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/zz/zee_tv.jpg",
//            "channelType": "IND",
//            "running_tvshows_url": "/forumdisplay.php?f=73",
//            "finished_tvshows_url": "/forumdisplay.php?f=211"},
//        "Sony TV":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/ss/set_in.jpg",
//            "channelType": "IND",
//            "running_tvshows_url": "/forumdisplay.php?f=63",
//            "finished_tvshows_url": "/forumdisplay.php?f=210"},
//        "Life OK":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/ll/life_ok_in.jpg",
//            "channelType": "IND",
//            "running_tvshows_url": "/forumdisplay.php?f=1375",
//            "finished_tvshows_url": "/forumdisplay.php?f=1581"},
//        "Star Jalsha":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/ss/star_jalsha.jpg",
//            "channelType": "IND",
//            "running_tvshows_url": "/forumdisplay.php?f=667",
//            "finished_tvshows_url": "/forumdisplay.php?f=1057"},
//        "Sahara One":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/ss/sahara_one.jpg",
//            "channelType": "IND",
//            "running_tvshows_url": "/forumdisplay.php?f=134",
//            "finished_tvshows_url": "/forumdisplay.php?f=213"},
//        "Colors TV":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/cc/colors_in.jpg",
//            "channelType": "IND",
//            "running_tvshows_url": "/forumdisplay.php?f=176",
//            "finished_tvshows_url": "/forumdisplay.php?f=374"},
//        "Sab TV":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/ss/sony_sab_tv.jpg",
//            "channelType": "IND",
//            "running_tvshows_url": "/forumdisplay.php?f=254",
//            "finished_tvshows_url": "/forumdisplay.php?f=454"},
//        "MTV":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/mm/mtv_india.jpg",
//            "channelType": "IND",
//            "running_tvshows_url": "/forumdisplay.php?f=339",
//            "finished_tvshows_url": "/forumdisplay.php?f=532"},
//        "Bindass TV":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/uu/utv_bindass.jpg",
//            "channelType": "IND",
//            "running_tvshows_url": "/forumdisplay.php?f=504",
//            "finished_tvshows_url": "/forumdisplay.php?f=960"},
//        "Channel [V]":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/cc/channel_v_in.jpg",
//            "channelType": "IND",
//            "running_tvshows_url": "/forumdisplay.php?f=633",
//            "finished_tvshows_url": "/forumdisplay.php?f=961"},
//        "DD National":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/dd/dd_national.jpg",
//            "channelType": "IND",
//            "running_tvshows_url": "/forumdisplay.php?f=535",
//            "finished_tvshows_url": "/forumdisplay.php?f=801"},
//        "Ary Digital":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/aa/atn_ary_digital.jpg",
//            "channelType": "PAK",
//            "running_tvshows_url": "/forumdisplay.php?f=384",
//            "finished_tvshows_url": "/forumdisplay.php?f=950"},
//        "GEO TV":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/gg/geo_tv.jpg",
//            "channelType": "PAK",
//            "running_tvshows_url": "/forumdisplay.php?f=413",
//            "finished_tvshows_url": "/forumdisplay.php?f=894"},
//        "HUM TV":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/hh/hum_tv.jpg",
//            "channelType": "PAK",
//            "running_tvshows_url": "/forumdisplay.php?f=448",
//            "finished_tvshows_url": "/forumdisplay.php?f=794"},
//        "A PLUS":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/aa/a_plus.jpg",
//            "channelType": "PAK",
//            "running_tvshows_url": "/forumdisplay.php?f=1327",
//            "finished_tvshows_url": "/forumdisplay.php?f=1334"},
//        "POGO":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/pp/pogo.jpg",
//            "channelType": "IND",
//            "running_tvshows_url": "/forumdisplay.php?f=500",
//            "finished_tvshows_url": None},
//        "Disney Channel":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/dd/disney_channel_in.jpg",
//            "channelType": "IND",
//            "running_tvshows_url": "/forumdisplay.php?f=479",
//            "finished_tvshows_url": None},
//        "Hungama TV":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/hh/hungama.jpg",
//            "channelType": "IND",
//            "running_tvshows_url": "/forumdisplay.php?f=472",
//            "finished_tvshows_url": "/forumdisplay.php?f=2102"},
//        "Cartoon Network":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/cc/cartoon_network_in.jpg",
//            "channelType": "IND",
//            "running_tvshows_url": "/forumdisplay.php?f=509",
//            "finished_tvshows_url": None},
//        "Star Pravah":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/ss/star_pravah.jpg",
//            "channelType": "IND",
//            "running_tvshows_url": "/forumdisplay.php?f=1138",
//            "finished_tvshows_url": "/forumdisplay.php?f=1466"},
//        "Zee Marathi":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/zz/zee_marathi.jpg",
//            "channelType": "IND",
//            "running_tvshows_url": "/forumdisplay.php?f=1299",
//            "finished_tvshows_url": "/forumdisplay.php?f=1467"},
//        "Star Vijay":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/ss/star_vijay_in.jpg",
//            "channelType": "IND",
//            "running_tvshows_url": "/forumdisplay.php?f=1609",
//            "finished_tvshows_url": "/forumdisplay.php?f=1747"},
//        "ZEE Bangla":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/zz/zee_bangla.jpg",
//            "channelType": "IND",
//            "running_tvshows_url": "/forumdisplay.php?f=676",
//            "finished_tvshows_url": "/forumdisplay.php?f=802"},
//        "Mahuaa TV":
//        {"iconimage":"http://www.lyngsat-logo.com/logo/tv/mm/mahuaa_bangla.jpg",
//            "channelType": "IND",
//            "running_tvshows_url": "/forumdisplay.php?f=772",
//            "finished_tvshows_url": "/forumdisplay.php?f=803"},
//#                   "Movies":
//#                   {"iconimage":"http://2.bp.blogspot.com/-8IURT2pXsb4/T5BqxR2OhfI/AAAAAAAACd0/cc5fwuEQIx8/s1600/the_movies.jpg",
//#                    "channelType": "IND",
//#                    "running_tvshows_url": "/forumdisplay.php?f=260",
//#                    "finished_tvshows_url": None},
//#                   "Latest & HQ Movies":
//#                   {"iconimage":"http://2.bp.blogspot.com/-8IURT2pXsb4/T5BqxR2OhfI/AAAAAAAACd0/cc5fwuEQIx8/s1600/the_movies.jpg",
//#                    "channelType": "IND",
//#                    "running_tvshows_url": "/forumdisplay.php?f=20",
//#                    "finished_tvshows_url": None},
//#                   "Awards & Concerts":
//#                   {"iconimage":"http://1.bp.blogspot.com/-63HEiUpB9rk/T2oJwqA-O8I/AAAAAAAAG78/g4WdztLscJE/s1600/filmfare-awards-20121.jpg",
//#                    "channelType": "IND",
//#                    "running_tvshows_url": "/forumdisplay.php?f=36",
//#                    "finished_tvshows_url": None};
//    }
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    [self loadTutorials];
//    [self loadContributors];
    
//    [self getTvData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Tutorial *thisTutorial = [_objects objectAtIndex:indexPath.row];
    cell.textLabel.text = thisTutorial.title;
    cell.detailTextLabel.text = thisTutorial.url;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)retrieveVideoLinks:(NSString *)url
{
    NSLog(@"Video URL - %@\n", url);
    
    NSURL *tutorialsUrl = [NSURL URLWithString:url];
    NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
    NSString *html = [[NSString alloc] initWithData:tutorialsHtmlData encoding:NSUTF8StringEncoding];
    
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:tutorialsHtmlData];
    
    NSString *tutorialsXpathQueryString = @"//blockquote[starts-with(@class,'postcontent')]";
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    
    for (TFHppleElement *element in tutorialsNodes) {
        
        for (TFHppleElement *child in element.children) {
            
            for(TFHppleElement *grandChild in child.children){
                
                NSLog(@"%@", [grandChild objectForKey:@"href"] ? [grandChild objectForKey:@"href"] : @"");
            }
        }
    }
}

- (void)retrieveEpisodes:(NSString *)url
{
    NSLog(@"Thread URL - %@\n", url);
    NSURL *tutorialsUrl = [NSURL URLWithString:url];
    NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
    NSString *html = [[NSString alloc] initWithData:tutorialsHtmlData encoding:NSUTF8StringEncoding];
    
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:tutorialsHtmlData];
    
    NSString *tutorialsXpathQueryString = @"//a[starts-with(@class,'title')]";
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    
    NSLog(@"Total nodes = %d", tutorialsNodes.count);
    
    if([tutorialsNodes count]){
        NSMutableArray *newTutorials = [[NSMutableArray alloc] initWithCapacity:0];
        
        __block int count = 0;
        for (TFHppleElement *element in tutorialsNodes) {
            
            NSString *title = [element text];
            
            NSError *error = NULL;
            NSRegularExpression *regex = [NSRegularExpression
                                          regularExpressionWithPattern:@"\\b(Watch|Episode|Video|Promo)\\b"
                                          options:NSRegularExpressionCaseInsensitive
                                          error:&error];
            NSTextCheckingResult *match = [regex firstMatchInString:title options:0 range:NSMakeRange(0, title.length)];
            if(!match)
                continue;
            else
            {
                
                NSLog(@"%d", ++count);
                NSLog(@"%@", title);
                // your code to handle matches here
         
            
                NSString *url = [element objectForKey:@"href"];
                
                if(![[url lowercaseString] hasPrefix:BASE_WEBSITE_URL])
                {
                    if(url.length && [url hasPrefix:@"/"])
                        url = [NSString stringWithFormat:@"/%@", url];
                    url = [NSString stringWithFormat:@"%@%@", BASE_WEBSITE_URL, url];
                    
                    [self retrieveVideoLinks:url];
                    
                    //Sagar TODO remove this
                    break;
                }
            }
        }
    }
    //TODO Sagar : Check if it ever enters here
    else
    {
        tutorialsXpathQueryString = @"//a[starts-with(@class='TITLE')]";
        tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
        if([tutorialsNodes count])
            NSAssert(NO, @"Abey ye toh caps me haiiiiii!");
        else
            NSAssert(NO, @"BC kahi bhi nahi haiiiiii!");
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tutorial *thisTutorial = [_objects objectAtIndex:indexPath.row];
    NSString *url = thisTutorial.url;
    [self retrieveEpisodes:url];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
