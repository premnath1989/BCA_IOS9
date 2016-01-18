//
//  test.h
//  SDTest1
//
//  Created by Eugen Laukart on 21.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

void doTest ();
void initTest ();

void setValueToField (NSString *value, NSString *fieldName);
void saveField();

int signTest (const char *field_name_sig, unsigned char *signature_data, size_t signature_size, unsigned char *signature_img, size_t image_size, const char *dst_file, BOOL selfSigned);
struct SIGNDOC_ByteArray *renderTest(unsigned int height);
UIImage *getPageImage(unsigned int height);
UIImage * getSignatureImage(unsigned int height, CGRect frame);
CGRect getSignatureSignDocCoordinates();
NSString* getNameOfSignatureWithLocation(CGPoint location);

unsigned char *readFile (const char *path, size_t *size);

CGRect getSignatureRect();
double getDocumentHeight();
double getDocumentWidth();
void clearSignatures();
void saveDocument();