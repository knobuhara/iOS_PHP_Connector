//
//  ViewController.m
//  Nobu_iOS_App
//
//  Created by KNobuhara on 11/30/3 R.
//  Copyright © 3 Reiwa KNobuhara. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    _result.text = @"Eメールとパスワードを入力して認証を行います。";
    _resultTitle.text = @"";
    _elem = @"タイトル不明";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)login:(id)sender {
    NSLog(@"on login");
    _isHtml = false;
    // サーバーへリクエストを送信
    NSURL *url                   = [NSURL URLWithString:@"http://nobuhara.tk/PHPWebApp/login.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *post               = [NSString stringWithFormat:@"email=%@&password=%@", _userName.text, _password.text];
    NSData *postData             = [post dataUsingEncoding:NSUTF8StringEncoding];
    NSURLResponse *response      = nil;
    NSError *error               = nil;
    [request setHTTPMethod:@"POST"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:postData];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    // エラー情報
    if ( error )
    {
        NSLog(@"Connection failed. Error - %@ %d %@", error.domain, error.code, error.localizedDescription);
        return;
    }
    
    // レスポンス情報
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSLog(@"expectedContentLength:%lld", httpResponse.expectedContentLength);
    NSLog(@"MIMTType:%@", httpResponse.MIMEType);
    NSLog(@"suggestedFieldname:%@", httpResponse.suggestedFilename);
    NSLog(@"textEncodingName:%@", httpResponse.textEncodingName);
    NSLog(@"URL:%@", httpResponse.URL);
    NSLog(@"statusCode:%d", httpResponse.statusCode);
    NSLog(@"localizedStringForStatusCode:%@", [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode]);
    if ( httpResponse.statusCode != 200 )
    {
        NSLog(@"statusCode:%d (%@)", httpResponse.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode]);
        return;
    }

    // NSDataをXMLParserで解析
    if ( ! data )
    {
        _result.text = [NSString stringWithFormat:@"通信エラー、エラーコード:(%d)",(int)httpResponse.statusCode];
        NSLog(@"data:nil");
        return;
    }
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
//    NSArray *xmlData  = [[NSArray alloc] init];
    [parser parse];
//    NSString *result  = xmlData[0];
//    NSLog(@"result:%@", result);
}

-(void) parserDidStartDocument:(NSXMLParser *)parser{

    NSLog(@"解析開始");
    
}

//デリゲートメソッド(要素の開始タグを読み込んだ時)
- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
     attributes:(NSDictionary *)attributeDict{
    
     NSLog(@"要素の開始タグを読み込んだ:%@",elementName);
    _elem = elementName;
    if([elementName isEqualToString:@"title"]){
        _isHtml = true;
    }
    
}

//デリゲートメソッド(タグ以外のテキストを読み込んだ時)
- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    NSLog(@"タグ以外のテキストを読み込んだ:%@", string);
    _resultTitle.text = _isHtml&&([_elem isEqualToString:@"title"]) ? string : @"";
}

//デリゲートメソッド(要素の終了タグを読み込んだ時)
- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName{
    
    NSLog(@"要素の終了タグを読み込んだ:%@",elementName);
    
}

//デリゲートメソッド(解析終了時)
-(void) parserDidEndDocument:(NSXMLParser *)parser{
    
    NSLog(@"解析終了");
    
    if (_isHtml) {
        _result.text = @"認証成功、宣原登録システムに登録済みです。";
    } else{
        _result.text = @"認証失敗、宣原登録システムに未登録です。";
    }
}

// エラー
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    // エラーの内容を出力
    NSLog(@"Error: %d, Column: %d, Line: %d, Description: %@",
        (int)[parseError code],
        (int)[parser columnNumber],
        (int)[parser lineNumber],
        [parseError description]);
    if (_isHtml) {
        _result.text = @"認証成功、宣原登録システムに登録済みです。";
    } else{
        _result.text = @"認証失敗、宣原登録システムに未登録です。";
    }
}
@end
