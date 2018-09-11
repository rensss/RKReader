//
//  RKHomeListTableViewCell.h
//  RKReader
//
//  Created by MBP on 2018/9/4.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKHomeListBooks.h"

@interface RKHomeListTableViewCell : UITableViewCell

@property (nonatomic, strong) RKHomeListBooks *bookInfo; /**< 书籍信息*/
@property (nonatomic, strong) RKBook *book; /**< 书籍*/

@end
