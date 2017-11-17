//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "Three20Core/TTGlobalCorePaths.h"
#include <sys/xattr.h>

static NSBundle* globalBundle = nil;


///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL TTIsBundleURL(NSString* URL) {
  return [URL hasPrefix:@"bundle://"];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL TTIsDocumentsURL(NSString* URL) {
  return [URL hasPrefix:@"documents://"];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
void TTSetDefaultBundle(NSBundle* bundle) {
  [bundle retain];
  [globalBundle release];
  globalBundle = bundle;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
NSBundle* TTGetDefaultBundle() {
  return (nil != globalBundle) ? globalBundle : [NSBundle mainBundle];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
NSString* TTPathForBundleResource(NSString* relativePath) {
  NSString* resourcePath = [TTGetDefaultBundle() resourcePath];
  return [resourcePath stringByAppendingPathComponent:relativePath];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
NSString* TTPathForDocumentsResource(NSString* relativePath) {
  static NSString* documentsPath = nil;
    if (nil == documentsPath) {
    NSArray* dirs = NSSearchPathForDirectoriesInDomains(
    NSLibraryDirectory, NSUserDomainMask, YES);
    documentsPath = [dirs objectAtIndex:0];
    documentsPath = [[documentsPath stringByAppendingPathComponent:@"Private Documents"] retain];

    NSError *error;
        NSFileManager *fm = [NSFileManager defaultManager];
[fm createDirectoryAtPath:documentsPath
withIntermediateDirectories:YES attributes:nil error:&error];
    }
    const char* filePath = [documentsPath fileSystemRepresentation];
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    //int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    //NSLog(@"The do not backup result:%d",result);
    return [documentsPath stringByAppendingPathComponent:relativePath];
    /*if (nil == documentsPath) {
     NSArray* dirs = NSSearchPathForDirectoriesInDomains(
     NSDocumentDirectory, NSUserDomainMask, YES);
     documentsPath = [[dirs objectAtIndex:0] retain];
     }
     return [documentsPath stringByAppendingPathComponent:relativePath];
     */
}
