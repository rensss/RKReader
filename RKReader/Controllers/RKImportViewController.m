//
//  RKImportViewController.m
//  RKReader
//
//  Created by MBP on 2018/9/4.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKImportViewController.h"
#import "GCDWebUploader.h"
#import "RKFile.h"

@interface RKImportViewController () <GCDWebUploaderDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) GCDWebUploader *webUploader; /**< 网页上传*/

@property (nonatomic, strong) UILabel *addressLabel; /**< 地址*/
@property (nonatomic, strong) UITableView *tableView; /**< 列表*/
@property (nonatomic, strong) NSMutableArray *dataArray; /**< 数据源*/

@end

@implementation RKImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"局域网导入书籍";
    
    [self.webUploader start];
    RKLog(@"Visit %@ in your web browser", self.webUploader.serverURL);
    
    [self.view addSubview:self.addressLabel];
    [self.view addSubview:self.tableView];
    
    self.addressLabel.text = [NSString stringWithFormat:@"浏览器访问->%@",self.webUploader.serverURL];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.addressLabel.frame = CGRectMake(0, 0, self.view.width, 25);
    
    CGFloat addressLabelMaxY = self.addressLabel.frame.size.height + self.addressLabel.frame.origin.y;
    
    self.tableView.frame = CGRectMake(0, addressLabelMaxY, self.view.frame.size.width, self.view.frame.size.height - addressLabelMaxY);
}

- (void)dealloc {
    [self.webUploader stop];
}

#pragma mark - 函数
/// 刷新列表
- (void)reloadTableView {
    self.dataArray = nil;
    [self.tableView reloadData];
}

#pragma mark - 点击事件
- (void)handleTapOnLabel:(UILabel *)label {
    // 剪切板
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.webUploader.serverURL.absoluteString];
    
    RKAlertMessage(@"已复制到剪切板", self.view);
}

#pragma mark - 代理
#pragma mark -- GCDWebUploaderDelegate
/**
 *  This method is called whenever a file has been downloaded.
 */
- (void)webUploader:(GCDWebUploader*)uploader didDownloadFileAtPath:(NSString*)path {
    RKLog(@"didDownloadFileAtPath---->\n");
    [self reloadTableView];
}

/**
 *  This method is called whenever a file has been uploaded.
 */
- (void)webUploader:(GCDWebUploader*)uploader didUploadFileAtPath:(NSString*)path {
    RKLog(@"didUploadFileAtPath---->\n");
    
    NSString *title = [path stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",uploader.uploadDirectory]  withString:@""];
    
    NSString *alertMessageStr = [NSString stringWithFormat:@"%@ 上传成功",title];
    
    RKAlertMessage(alertMessageStr,self.view);
    
    [self reloadTableView];
}

/**
 *  This method is called whenever a file or directory has been moved.
 */
- (void)webUploader:(GCDWebUploader*)uploader didMoveItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
    RKLog(@"didMoveItemFromPath---->\n");
    [self reloadTableView];
}

/**
 *  This method is called whenever a file or directory has been deleted.
 */
- (void)webUploader:(GCDWebUploader*)uploader didDeleteItemAtPath:(NSString*)path {
    RKLog(@"didDeleteItemAtPath---->\n");
    [self reloadTableView];
}

/**
 *  This method is called whenever a directory has been created.
 */
- (void)webUploader:(GCDWebUploader*)uploader didCreateDirectoryAtPath:(NSString*)path {
    RKLog(@"didCreateDirectoryAtPath---->\n");
    [self reloadTableView];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    RKFile *file = self.dataArray[indexPath.row];
    cell.textLabel.text = file.fileName;
    
    return cell;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    R_FileModel *file = self.dataArray[indexPath.row];
//
//    if (self.isEditing) {
//        if (self.selectFileArray.count >= 9) {
//            RAlertMessage(@"一次最多9张图", self.view);
//            [tableView deselectRowAtIndexPath:indexPath animated:YES];
//            return;
//        }
//        [self.selectFileArray addObject:file];
//    }else {
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//        // 文件信息
//        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:file.filePath error:nil];
//        // 是否图片后缀
//        if ([file.fileType isEqualToString:@"jpeg"] || [file.fileType isEqualToString:@"jpg"] || [file.fileType isEqualToString:@"png"]) {
//
//            R_ImagePreviewViewController *imageVC = [[R_ImagePreviewViewController alloc] init];
//
//            imageVC.path = file.filePath;
//            //        imageVC.preferredContentSize = [self getImageSizeWithPath:path];
//            imageVC.modalPresentationStyle = UIModalPresentationPopover;
//
//            UIPopoverPresentationController *popvc = imageVC.popoverPresentationController;
//            popvc.delegate = self;
//            popvc.sourceView = cell;
//            popvc.sourceRect = cell.bounds;
//            popvc.permittedArrowDirections = UIPopoverArrowDirectionAny;
//
//            [self presentViewController:imageVC animated:YES completion:nil];
//
//        }else {
//            // 显示文件信息
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"文件" message:[NSString stringWithFormat:@"%@",dict] preferredStyle:UIAlertControllerStyleAlert];
//
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
//            [alertController addAction:cancelAction];
//
//            [self presentViewController:alertController animated:YES completion:nil];
//        }
//    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//    R_FileModel *file = self.dataArray[indexPath.row];
//    [self.selectFileArray removeObject:file];
}

#pragma mark -- 删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",kBookSavePath,self.dataArray[indexPath.row]];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    //文件名
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!blHave) {
        RKAlertMessage(@"未找到该文件", self.view);
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:path error:nil];
        if (blDele) {
            [self reloadTableView];
        }else {
            RKAlertMessage(@"删除失败", self.view);
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


#pragma mark - getting
- (GCDWebUploader *)webUploader {
    if (!_webUploader) {
        _webUploader = [[GCDWebUploader alloc] initWithUploadDirectory:kBookSavePath];
        _webUploader.delegate = self;
        _webUploader.allowedFileExtensions = @[@"txt",@"epub"];
        _webUploader.prologue = @"点击Upload Files... 选择上传文件 ps:仅支持txt/epub格式文件";
        _webUploader.epilogue = @"直接拖拽文件到此处上传";
        _webUploader.footer = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];
    }
    return _webUploader;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = [UIColor blueColor];
        _addressLabel.font = [UIFont systemFontOfSize:15];
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        
        _addressLabel.userInteractionEnabled = YES;
        [_addressLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnLabel:)]];
        
    }
    return _addressLabel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSFileManager *manager = [NSFileManager defaultManager];
        //获取数据
        //①只获取文件名
        NSArray *fileNameArray = [NSMutableArray arrayWithArray:[manager contentsOfDirectoryAtPath:kBookSavePath error:nil]];
        
        for (NSString *fileName in fileNameArray) {
            RKFile *file = [RKFile new];
            file.fileName = fileName;
            file.filePath = [NSString stringWithFormat:@"%@/%@",kBookSavePath,fileName];
            file.fileType = [[fileName componentsSeparatedByString:@"."] lastObject];
            [_dataArray addObject:file];
        }
        
    }
    return _dataArray;
}

@end
