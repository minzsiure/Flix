//
//  MoviesViewController.m
//  Flix
//
//  Created by Eva Xie on 6/23/21.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

// this class implements this protocal, meaning i wil implement methods defined in <___>
@interface MoviesViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


// create a property. it does both setter and getter in java
// nonatomic (in most cases it will use nonatomic) and
// strong ("data don't go away") means how compiler generates
@property (nonatomic, strong) NSArray *movies;
@property (strong, nonatomic) NSArray *filteredMovies;
@property (strong, nonatomic) NSArray *movieTitles;
@property (nonatomic, strong) UIRefreshControl *refreshControl;


@end

@implementation MoviesViewController
// property can be override here


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
    
    // tableView will call dataSource or delegate, expecting self to know stuff
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    
    // Do any additional setup after loading the view.
    // set up
    [self fetchMovies];
    
    
    //init an instance
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    //addTarget, the object u wanna call; action, functions u wanna call
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.tableView addSubview:self.refreshControl]; //addSubview is a part of UIView, can be added anywhere
}

- (void)networkError{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The internet connection appears to be offline." preferredStyle:(UIAlertControllerStyleAlert)];

    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle cancel response here. Doing nothing will dismiss the view.
                                                      }];
    // add the cancel action to the alertController
    [alert addAction:cancelAction];

    // create an TryAgain action
    UIAlertAction *TryAgainAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
        //Call on network again
        [self fetchMovies];
        
                                                     }];
    // add the TryAgain action to the alert controller
    [alert addAction:TryAgainAction];

    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];

}

- (void)fetchMovies{
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //once network request comes back
           if (error != nil) {
               //if there's an error
               [self networkError];
//               [self networkError];
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               //else gets to API
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               //NSLog(@"%@", dataDictionary); // every api call gives a dataDic
               
               //gives a key (ie. results) to access the dictionary
               // this creates an NSArray named movies
               self.movies = dataDictionary[@"results"];
               
               // iterate through each movie in movies and print out "titles"
               NSMutableArray *movieTitles = [NSMutableArray array];
               for (NSDictionary *movie in self.movies){
                   [movieTitles addObject:movie[@"title"]];
                   //NSLog(@"%@", movie[@"title"]);
                   //NSLog(@"movie %@", movie);
               }
               self.filteredMovies = self.movies;
               
               //call your data source again bc the underlying data may have changed
               [self.tableView reloadData];
               
           }
            [self.refreshControl endRefreshing];
       }];
    [task resume];

}

- (void) didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredMovies.count;
}

// it is a UITableView set up
// datasourse <> tableView, loading as scrolling; as soon as scrolling down, the data gets removed, will load again if scroll back.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //create an UITableViewCell instance
    //UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    // call reuseable cells
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    // make right movie associates with right row
    NSDictionary *movie = self.filteredMovies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
    //cocopod set up
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    //NSURL is similar to string, but it checks if input is a valid URL
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:posterURL];
    
    // cell.textLabel.text = [NSString stringWithFormat:@"row: %d, section %d", indexPath.row, indexPath.section];
    // cell.textLabel.text = movie[@"title"];
    
    return cell;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"HERE");
    if (searchText.length != 0) {
        
//        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
//            return [evaluatedObject containsString:searchText];
//        }];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(title CONTAINS[cd] %@)", searchText];
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:predicate];
        
        NSLog(@"%@", self.filteredMovies);
        
    }
    else {
        self.filteredMovies = self.movies;
    }
    
    [self.tableView reloadData];
 
}


//a lifecycle method
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row]; //grab the movie
    
    
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    
    detailsViewController.movie = movie;
    //NSLog(@"tapping on a movie");
}



@end
