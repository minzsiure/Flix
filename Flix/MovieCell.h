//
//  MovieCell.h
//  Flix
//
//  Created by Eva Xie on 6/23/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieCell : UITableViewCell

// don't use word imageView or textLabel cuz it's pre-existing
// 3 pointers
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;


@end

NS_ASSUME_NONNULL_END
