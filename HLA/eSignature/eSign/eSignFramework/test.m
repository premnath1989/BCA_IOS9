//
//  test.m
//  SDTest1
//
//  Created by Eugen Laukart on 21.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include <string.h>
#include <errno.h>
#include "SignDocSDK-c.h"
#include "test.h"
#include "ConstantStr.h"

#import "NSObject_ConstantTags.h"
static struct SIGNDOC_Exception *ex;
static struct SIGNDOC_DocumentHandler *handler;
static struct SIGNDOC_DocumentLoader *loader;
static struct SIGNDOC_Document *doc;
static const char *test_output_file;
static NSString *doc_path;

static void doThrow ()
{
    @throw [NSException exceptionWithName:@"SignDocException"
                                   reason:@"SignDoc error"
                                 userInfo:nil];
}

static void handleException (struct SIGNDOC_Exception *ex)
{
    char *txt = SIGNDOC_Exception_getText (ex);
    NSLog (@"SignDoc error %u (%s)", SIGNDOC_Exception_getType (ex), txt);
    doThrow ();
}

static void failAlloc (const char *fun)
{
    NSLog (@"%s() failed", fun);
    doThrow ();
}


static void failLoader (struct SIGNDOC_DocumentLoader *loader, const char *fun)
{
    const char *txt = SIGNDOC_DocumentLoader_getErrorMessage (&ex, loader, SIGNDOC_ENCODING_NATIVE);
    NSLog (@"%s() failed, %s", fun, txt);
    doThrow ();
}

static void failDoc (struct SIGNDOC_Document *doc, int rc, const char *fun)
{
    const char *txt = SIGNDOC_Document_getErrorMessage (&ex, doc, SIGNDOC_ENCODING_NATIVE);
    NSLog (@"%s() failed, %d, %s", fun, rc, txt);
    doThrow ();
}

static void checkDocumentRC (struct SIGNDOC_Document *doc, int rc, const char *fun) {
    if (rc == SIGNDOC_SIGNATUREPARAMETERS_RETURNCODE_OK) return;
    failDoc(doc, rc, fun);
}

static void failVer (struct SIGNDOC_VerificationResult *ver, int rc, const char *fun)
{
    const char *txt = SIGNDOC_VerificationResult_getErrorMessage (&ex, ver, SIGNDOC_ENCODING_NATIVE);
    NSLog (@"%s() failed, %d, %s", fun, rc, txt);
    doThrow ();
}

static void checkParam (struct SIGNDOC_SignatureParameters *params, int rc, const char *fun)
{
    if (rc == SIGNDOC_SIGNATUREPARAMETERS_RETURNCODE_OK)
        return;
    const char *txt = SIGNDOC_SignatureParameters_getErrorMessage (&ex, params, SIGNDOC_ENCODING_NATIVE);
    NSLog (@"%s() failed, %d, %s", fun, rc, txt);
    doThrow ();
}

unsigned char *readFile (const char *path, size_t *size)
{
    FILE *f = fopen (path, "rb");
    if (f == NULL)
    {
        NSLog (@"%s: %s", path, strerror (errno));
        doThrow ();
    }
    fseek (f, 0, SEEK_END);
    long len = ftell (f);
    fseek (f, 0, SEEK_SET);
    *size = (size_t)len;
    unsigned char *p = (unsigned char *)malloc (*size);
    if (p == NULL)
    {
        NSLog (@"readFile(): out of memory");
        fclose (f);
        doThrow ();
    }
    size_t n = fread (p, 1, *size, f);
    if (ferror (f))
    {
        NSLog (@"%s: %s", path, strerror (errno));
        fclose (f);
        doThrow ();
    }
    if (n != *size)
    {
        NSLog (@"readFile(): short read");
        fclose (f);
        doThrow ();
    }
    if (fclose (f) != 0)
    {
        NSLog (@"%s: %s", path, strerror (errno));
        doThrow ();
    }
    return p;
}

static void writeFile (const char *path, const void *ptr, size_t size)
{
    FILE *f = fopen (path, "wb");
    if (f == NULL)
    {
        NSLog (@"%s: %s", path, strerror (errno));
        doThrow ();
    }
    fwrite (ptr, 1, size, f);
    if (ferror (f) || fflush (f) != 0)
    {
        NSLog (@"%s: %s", path, strerror (errno));
        fclose (f);
        doThrow ();
    }
    if (fclose (f) != 0)
    {
        NSLog (@"%s: %s", path, strerror (errno));
        doThrow ();
    }
}

void initTest ()
{
    NSArray *doc_paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    doc_path = [doc_paths objectAtIndex:0];
    
	ex = SIGNDOC_Exception_new (SIGNDOC_EXCEPTION_TYPE_PDF, NULL);
	if (ex == NULL)
        failAlloc ("SIGNDOC_Exception_new");
	SIGNDOC_Exception_setHandler (handleException);
	

    const void* license =
    "h:SPLM2 4.10\n"
    "i:ID:239\n"
    "i:Product:SignDocSDK\n"
    "i:Manufacturer:SOFTPRO GmbH\n"
    "i:Customer:Kofax Singapore Pte. Ltd.\n"
    "i:Version:99\n"
    "i:OS:all\n"
    "a:product:unlimited\n"
    "a:signware:unlimited\n"
    "a:dynamic:unlimited\n"
    "a:static:unlimited\n"
    "a:sign:2017-01-07\n"
    "a:capture:unlimited\n"
    "a:render:unlimited\n"
    "ps:CustomerCompany:Kofax Singapore Pte. Ltd.\n"
    "ps:CustomerMail:APJdealdesk@kofax.com\n"
    "s:acad329d8371eb6928c03b7fc79364f2bf9193ad8b39b10ff72efb648c2f1838\n"
    "s:ab498d22aa3bc0c73b2fb32815f5d7742428e5bdebfb01f23b5d8372470c5b17\n"
    "s:f1bb159c9cc70758f1fe1013dd5dda77a914cc802744b2cf249a155363923260\n"
    "s:635309a40bafa135c6131755883ccc48f1f103ba3914368997d500d10a3fa2d7\n";
    
    
    NSLog(@"Length of license: %lu", strlen(license));
    if (!SIGNDOC_DocumentLoader_setLicenseKey(&ex, license, strlen(license), NULL, NULL, NULL, 0)) {
        NSLog (@"Cannot initialize license");
        doThrow ();
    }else {
        NSLog(@"License key approved");
    }
    
    
//    	// The magic numbers are for SignDocSDK.lic
//	if (!SIGNDOC_DocumentLoader_initLicenseManager(&ex, 423343885, 1494518706))
//	{
//		NSLog (@"Cannot initilize license");
//		doThrow ();
//	}
	
	// Create loader
	
	loader = SIGNDOC_DocumentLoader_new (&ex);
	handler = SIGNDOC_PdfDocumentHandler_new (&ex);
	if (!SIGNDOC_DocumentLoader_registerDocumentHandler (&ex, loader, handler))
        failLoader (loader, "SIGNDOC_DocumentLoader_registerDocumentHandler");
	
	// Load document
	
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *documentPath = [documentsDirectory stringByAppendingPathComponent:@"output.pdf"];
    NSString *thePath = GetPDFPath;
    const char *input_path4 = [thePath UTF8String];
//	NSLog (@"Input file: %s", input_path4);
	
	doc = SIGNDOC_DocumentLoader_loadFromFile (&ex, loader, SIGNDOC_ENCODING_NATIVE, input_path4, SIGNDOC_TRUE);
	if (doc == NULL)
        failLoader (loader, "SIGNDOC_DocumentLoader_loadFromFile");
}
void setValueToField (NSString *value, NSString *fieldName)
{
    getSignatureRect();
    if ([value length]) {
//        struct SIGNDOC_FieldArray *field = SIGNDOC_FieldArray_new(&ex);
//        int rc = SIGNDOC_Document_getFields(&ex, doc, 0, field);
//        if (rc != SIGNDOC_DOCUMENT_RETURNCODE_OK)
//            NSLog(@"SIGNDOC_Document_getFields %@",fieldName);
        struct SIGNDOC_Field *aField = SIGNDOC_Field_new(&ex);
        int rc = SIGNDOC_Document_getField (&ex,doc,SIGNDOC_ENCODING_UTF_8,(char*)[fieldName UTF8String],aField);
        if (rc!=SIGNDOC_DOCUMENT_RETURNCODE_OK) {
            NSLog(@"SIGNDOC_Document_getField Faield %@",fieldName);
        }
        
        
        SIGNDOC_Field_setValue (&ex, aField, SIGNDOC_ENCODING_NATIVE,
                                [value UTF8String]);

        int set_field_flags = SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_FAIL;
        rc = SIGNDOC_Document_setField (&ex, doc, aField, set_field_flags);
        if (rc != SIGNDOC_DOCUMENT_RETURNCODE_OK)
            NSLog(@"SIGNDOC_Document_setField %@ Value = %@",fieldName,value);
    }
}
void saveField()
{
    int rc = SIGNDOC_Document_saveToFile (&ex, doc, SIGNDOC_ENCODING_NATIVE, NULL, SIGNDOC_DOCUMENT_SAVEFLAGS_INCREMENTAL);
    if (rc != SIGNDOC_DOCUMENT_RETURNCODE_OK)
        failDoc (doc, rc, "SIGNDOC_Document_saveToFile");
    NSLog (@"Document saved");
}
struct SIGNDOC_ByteArray *renderTest(unsigned int height)
{
    struct SIGNDOC_ByteArray *blob;
    struct SIGNDOC_RenderParameters *rp;
    struct SIGNDOC_RenderOutput *ro;
    
    blob = SIGNDOC_ByteArray_new(&ex);
    if (blob == NULL)
        failAlloc ("SIGNDOC_ByteArray_new");
    rp = SIGNDOC_RenderParameters_new (&ex);
    ro = SIGNDOC_RenderOutput_new (&ex);
    
    int pageNo = [[NSUserDefaults standardUserDefaults]integerForKey:@"pageNo"];
    
    SIGNDOC_RenderParameters_setFormat (&ex, rp, "png");
    SIGNDOC_RenderParameters_setPage (&ex, rp, pageNo);
    SIGNDOC_RenderParameters_fitHeight (&ex, rp, height);
    struct SIGNDOC_Rect *clip = NULL;
    
    int rc = SIGNDOC_Document_renderPageAsImage (&ex, doc, blob, ro, rp, clip);
    if (rc != SIGNDOC_DOCUMENT_RETURNCODE_OK) {
        failDoc (doc, rc, "SIGNDOC_Document_renderPageAsImage");
    }
    else {
//        NSLog (@"Image width:  %d", SIGNDOC_RenderOutput_getWidth (ro, ex));
//        NSLog (@"Image height: %d", SIGNDOC_RenderOutput_getHeight (ro, ex));
    }
    
    if (ro != NULL)
        SIGNDOC_RenderOutput_delete (ro);
    if (rp != NULL)
        SIGNDOC_RenderParameters_delete (rp);
    
    return blob;
}

UIImage * getSignatureImage(unsigned int height, CGRect frame) {
    struct SIGNDOC_ByteArray *blob;
    struct SIGNDOC_RenderParameters *rp;
    struct SIGNDOC_RenderOutput *ro;
    
    blob = SIGNDOC_ByteArray_new (&ex);
    if (blob == NULL)
        failAlloc ("SIGNDOC_ByteArray_new");
    rp = SIGNDOC_RenderParameters_new (&ex);
    ro = SIGNDOC_RenderOutput_new (&ex);
    
    SIGNDOC_RenderParameters_setFormat (&ex, rp, "png");
    SIGNDOC_RenderParameters_setPage (&ex, rp, 4);
    SIGNDOC_RenderParameters_fitHeight (&ex, rp, height);
    struct SIGNDOC_Rect *clipForRenderPageAsImage = SIGNDOC_Rect_newXY(&ex, frame.origin.x, frame.size.height, frame.origin.y, frame.size.width);
    
    int rc = SIGNDOC_Document_renderPageAsImage (&ex, doc, blob, ro, rp, clipForRenderPageAsImage);
    if (rc==SIGNDOC_DOCUMENT_RETURNCODE_UNEXPECTED_ERROR) {
        NSLog(@"Unexpected Error");
    }
    if (rc != SIGNDOC_DOCUMENT_RETURNCODE_OK) {
        failDoc (doc, rc, "SIGNDOC_Document_renderPageAsImage");
    }
    else {
        NSLog (@"Image width:  %d", SIGNDOC_RenderOutput_getWidth (ro));
        NSLog (@"Image height: %d", SIGNDOC_RenderOutput_getHeight (ro));
    }
    
    NSData *data = [NSData dataWithBytes:SIGNDOC_ByteArray_data(blob) length:SIGNDOC_ByteArray_count(blob)];
    UIImage *signatureImage = [UIImage imageWithData:data];
    SIGNDOC_ByteArray_delete(blob);
    SIGNDOC_Rect_delete(clipForRenderPageAsImage);
    if (ro != NULL)
    SIGNDOC_RenderOutput_delete (ro);
    if (rp != NULL)
    SIGNDOC_RenderParameters_delete (rp);
    return signatureImage;
    
}

void saveDocument() {
    SIGNDOC_Document_saveToFile(&ex, doc, SIGNDOC_ENCODING_NATIVE, NULL, SIGNDOC_DOCUMENT_SAVEFLAGS_INCREMENTAL);
    SIGNDOC_Exception_delete(ex);
}

int signTest (const char *field_name_sig, unsigned char *signature_data, size_t signature_size, unsigned char *signature_img, size_t image_size, const char *dst_file, BOOL selfSigned)
{
    int rc;
    struct SIGNDOC_SignatureParameters *sp = NULL;
    
    rc = SIGNDOC_Document_createSignatureParameters (&ex, doc, SIGNDOC_ENCODING_NATIVE, field_name_sig, "", &sp);
    if (rc != SIGNDOC_DOCUMENT_RETURNCODE_OK)
        failDoc (doc, rc, "SIGNDOC_Document_createSignatureParameters");
    
    rc = SIGNDOC_SignatureParameters_setInteger (&ex, sp, "Method", SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED);
    checkParam (sp, rc, "SIGNDOC_SignatureParameters_setInteger");
    rc = SIGNDOC_SignatureParameters_setInteger (&ex, sp, "DetachedHashAlgorithm", SIGNDOC_SIGNATUREPARAMETERS_DETACHEDHASHALGORITHM_SHA256);
    checkParam (sp, rc, "SIGNDOC_SignatureParameters_setInteger");
    rc = SIGNDOC_SignatureParameters_setLength (&ex, sp, "FontSize", SIGNDOC_SIGNATUREPARAMETERS_VALUETYPE_ABS, 8);
    checkParam (sp, rc, "SIGNDOC_SignatureParameters_setLength");
    rc = SIGNDOC_SignatureParameters_setInteger (&ex, sp, "BiometricEncryption", SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_RSA);
    checkParam (sp, rc, "SIGNDOC_SignatureParameters_setInteger");
    rc = SIGNDOC_SignatureParameters_setString(&ex, sp, SIGNDOC_ENCODING_UTF_8, "BiometricKeyPath", [[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"test-public.key"] UTF8String]);
    checkParam (sp, rc, "SIGNDOC_SignatureParameters_setString(bio key)");
    rc = SIGNDOC_SignatureParameters_setInteger (&ex, sp, "GenerateKeyPair", 1024);
    checkParam (sp, rc, "SIGNDOC_SignatureParameters_setInteger");
    rc = SIGNDOC_SignatureParameters_setString (&ex, sp, SIGNDOC_ENCODING_NATIVE, "CommonName", [GetSignerName UTF8String]);
    checkParam (sp, rc, "SIGNDOC_SignatureParameters_setInteger");
    if (selfSigned) {
        rc = SIGNDOC_SignatureParameters_setString (&ex, sp, SIGNDOC_ENCODING_NATIVE, "Signer", [GetSignerName UTF8String]);
        checkParam (sp, rc, "SIGNDOC_SignatureParameters_setString");
    }

    rc = SIGNDOC_SignatureParameters_setBlob (&ex, sp, "BiometricData", signature_data, signature_size);
    checkParam (sp, rc, "SIGNDOC_SignatureParameters_setBlob");
    rc = SIGNDOC_SignatureParameters_setBlob (&ex, sp, "Image", signature_img, image_size);
    checkParam (sp, rc, "SIGNDOC_SignatureParameters_setBlob");
    
    rc = SIGNDOC_Document_addSignature (&ex, doc, sp);
    if (rc != SIGNDOC_DOCUMENT_RETURNCODE_OK)
        failDoc (doc, rc, "SIGNDOC_Document_addSignature");
    
    if (sp != NULL)
        SIGNDOC_SignatureParameters_delete (sp);
    
    return rc;
}

void clearSignatures() {
    int rc = SIGNDOC_Document_clearAllSignatures(&ex, doc);
    checkDocumentRC (doc, rc, "SIGNDOC_Document_clearAllSignatures");
}

struct SIGNDOC_FieldArray *getDocumentFields(struct SIGNDOC_Document *doc) {
    struct SIGNDOC_FieldArray *fields = SIGNDOC_FieldArray_new(&ex);
    int rc = SIGNDOC_Document_getFields(&ex, doc, 0, fields);
    checkDocumentRC (doc, rc, "SIGNDOC_Document_getFields");
    return fields;
}

CGRect getFieldFrameRect(struct SIGNDOC_Field *field, int pageHeight) {
    int left = SIGNDOC_Field_getLeft(&ex, field);
    int right = SIGNDOC_Field_getRight(&ex, field);
    int top = SIGNDOC_Field_getTop(&ex, field);
    int bottom = SIGNDOC_Field_getBottom(&ex, field);
    return CGRectMake(left, pageHeight-top, right-left, top-bottom);
}

CGRect getSignatureRect () {
    struct SIGNDOC_FieldArray *fields = getDocumentFields(doc);
    for (int i=0; i<SIGNDOC_FieldArray_count(fields); i++) {
        struct SIGNDOC_Field *currentField = SIGNDOC_FieldArray_at(fields,i);
        int type = SIGNDOC_Field_getType(&ex, currentField);
        const char *name = SIGNDOC_Field_getName(&ex, currentField,SIGNDOC_ENCODING_UTF_8);
        NSLog(@"Field Name = %s",name);
        NSString *comparedTo = GetObjectSigName;
        
        if (type == SIGNDOC_FIELD_TYPE_SIGNATURE_SIGNDOC || type == SIGNDOC_FIELD_TYPE_SIGNATURE_DIGSIG) {
            if ([comparedTo isEqualToString:[NSString stringWithUTF8String:name]]){
                NSLog(@"RECT FOR >>> %s",name);
                return getFieldFrameRect(currentField, getDocumentHeight());
            }
        }
        
        
        
    }
    return CGRectMake(0, 0, 0, 0);
}

CGRect getSignatureSignDocCoordinates () {
    struct SIGNDOC_FieldArray *fields = getDocumentFields(doc);
    for (int i=0; i<SIGNDOC_FieldArray_count(fields); i++) {
        struct SIGNDOC_Field *currentField = SIGNDOC_FieldArray_at(fields,i);
        int type = SIGNDOC_Field_getType(&ex, currentField);
        const char *name = SIGNDOC_Field_getName(&ex, currentField,SIGNDOC_ENCODING_UTF_8);
        NSString *comparedTo = GetObjectSigName;

        if (type == SIGNDOC_FIELD_TYPE_SIGNATURE_SIGNDOC || type == SIGNDOC_FIELD_TYPE_SIGNATURE_DIGSIG) {
            if ([comparedTo isEqualToString:[NSString stringWithUTF8String:name]]){
            int left = SIGNDOC_Field_getLeft(&ex, currentField);
            int right = SIGNDOC_Field_getRight(&ex, currentField);
            int top = SIGNDOC_Field_getTop(&ex, currentField);
            int bottom = SIGNDOC_Field_getBottom(&ex, currentField);
            return CGRectMake(left, right, top, bottom);
            }
        }
    }
    return CGRectMake(0, 0, 0, 0);
}
NSString* getNameOfSignatureWithLocation(CGPoint location) {
    NSString *result = nil;
    struct SIGNDOC_FieldArray *fields = getDocumentFields(doc);
    for (int i=0; i<SIGNDOC_FieldArray_count(fields); i++) {
        struct SIGNDOC_Field *currentField = SIGNDOC_FieldArray_at(fields,i);
        int type = SIGNDOC_Field_getType(&ex, currentField);
        if (type == SIGNDOC_FIELD_TYPE_SIGNATURE_SIGNDOC || type == SIGNDOC_FIELD_TYPE_SIGNATURE_DIGSIG) {
            CGRect currentSignatureRect = getFieldFrameRect(currentField, getDocumentHeight());
            if (currentSignatureRect.origin.x < location.x && location.x < currentSignatureRect.origin.x + currentSignatureRect.size.width && currentSignatureRect.origin.y < location.y && location.y < currentSignatureRect.origin.y + currentSignatureRect.size.height) {
                result = [NSString stringWithUTF8String:SIGNDOC_Field_getName(&ex, currentField, SIGNDOC_ENCODING_NATIVE)];
                SIGNDOC_FieldArray_delete(fields);
                return result;
            }
        }
    }
    SIGNDOC_FieldArray_delete(fields);
    return result;
}
double getDocumentHeight() {
    double height, width;
    int rc = SIGNDOC_Document_getPageSize(&ex, doc, 4, &width, &height);
    checkDocumentRC (doc, rc, "SIGNDOC_Document_getPageSize");
    return height;
}

double getDocumentWidth() {
    double height, width;
    int rc = SIGNDOC_Document_getPageSize(&ex, doc, 4, &width, &height);
    checkDocumentRC (doc, rc, "SIGNDOC_Document_getPageSize");
    return width;
}

void doTest ()
{
    struct SIGNDOC_TextFieldAttributes *tfa = NULL;
    struct SIGNDOC_FindTextPositionArray *pos = NULL;
    struct SIGNDOC_Field *field = NULL;
    struct SIGNDOC_VerificationResult *ver = NULL;
    struct SIGNDOC_ByteArray *blob = NULL;
    const char *image_path = "output.png";
    const char *bio_path = "test.bio";
    const char *bmp_path = "test.bmp";
    const char *field_name_text = "text1";
    const char *field_name_sig = "sig1";
    
    NSLog (@"Test started");
	
    @try
    {
        // Initialize
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *documentPath = [documentsDirectory stringByAppendingPathComponent:@"output.pdf"];
        test_output_file = [documentPath UTF8String];
        NSLog (@"Output file: %s", test_output_file);
        
        {
            // Set properties
            
            int rc = SIGNDOC_Document_setStringProperty (&ex, doc, SIGNDOC_ENCODING_NATIVE,
                                                         "encrypted", "priv1", "one");
            if (rc != SIGNDOC_DOCUMENT_RETURNCODE_OK)
                failDoc (doc, rc, "SIGNDOC_Document_setStringProperty");
            
            rc = SIGNDOC_Document_setStringProperty (&ex, doc, SIGNDOC_ENCODING_NATIVE,
                                                     "public", "pub2", "two");
            if (rc != SIGNDOC_DOCUMENT_RETURNCODE_OK)
                failDoc (doc, rc, "SIGNDOC_Document_setStringProperty");
        }
        
        {
            // Insert text field
            
            tfa = SIGNDOC_TextFieldAttributes_new (&ex);
            SIGNDOC_TextFieldAttributes_setFontName (&ex,tfa, SIGNDOC_ENCODING_NATIVE, "Helvetica");
            SIGNDOC_TextFieldAttributes_setFontSize (&ex, tfa, 12);
            
            field = SIGNDOC_Field_new (&ex);
            SIGNDOC_Field_setName (&ex, field, SIGNDOC_ENCODING_NATIVE, field_name_text);
            SIGNDOC_Field_setType (&ex, field, SIGNDOC_FIELD_TYPE_TEXT);
            SIGNDOC_Field_setPage (&ex, field, 1);
            SIGNDOC_Field_setLeft (&ex, field, 450);
            SIGNDOC_Field_setRight (&ex, field, 550);
            SIGNDOC_Field_setBottom (&ex, field, 720);
            SIGNDOC_Field_setTop (&ex, field, 750);
            SIGNDOC_Field_setTextFieldAttributes (&ex, field, tfa);
            SIGNDOC_Field_setJustification(&ex, field, SIGNDOC_FIELD_JUSTIFICATION_LEFT);
            
            
            int set_field_flags = SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_FAIL;
            int rc = SIGNDOC_Document_addField (&ex, doc, field, set_field_flags);
            if (rc != SIGNDOC_DOCUMENT_RETURNCODE_OK)
                failDoc (doc, rc, "SIGNDOC_Document_addField");
            NSLog (@"Text field added");
            SIGNDOC_Field_delete (field);
            field = NULL;
        }
        
        {
            // Change text field
            
            field = SIGNDOC_Field_new (&ex);
            int rc = SIGNDOC_Document_getField (&ex, doc, SIGNDOC_ENCODING_NATIVE,
                                                field_name_text, field);
            if (rc != SIGNDOC_DOCUMENT_RETURNCODE_OK)
                failDoc (doc, rc, "SIGNDOC_Document_getField");
            
            SIGNDOC_Field_setValue (&ex, field, SIGNDOC_ENCODING_NATIVE,
                                    "Set by SDTest1");
            
            int set_field_flags = SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_FAIL;
            rc = SIGNDOC_Document_setField (&ex, doc, field, set_field_flags);
            if (rc != SIGNDOC_DOCUMENT_RETURNCODE_OK)
                failDoc (doc, rc, "SIGNDOC_Document_setField");
            NSLog (@"Text field changed");
            SIGNDOC_Field_delete (field);
            field = NULL;
        }
        
        // Find text
        
        pos = SIGNDOC_FindTextPositionArray_new (&ex);
        if (pos == NULL)
            failAlloc ("SIGNDOC_FindTextPositionArray_new");
        int find_text_flags = 0;
        int rc = SIGNDOC_Document_findText (&ex, doc, SIGNDOC_ENCODING_NATIVE,
                                            1, 1, "Investoren", find_text_flags,
                                            pos);
        if (rc != SIGNDOC_DOCUMENT_RETURNCODE_OK)
            failDoc (doc, rc, "SIGNDOC_Document_findText");
        NSLog (@"Text positions: %u", SIGNDOC_FindTextPositionArray_count (pos));
        
        int doc_signed = 0;
        if (SIGNDOC_FindTextPositionArray_count (pos) >= 1)
        {
            // Insert signature field
            
            struct SIGNDOC_FindTextPosition *pos2 = SIGNDOC_FindTextPositionArray_at (pos, 0);
            struct SIGNDOC_CharacterPosition *pos3 = SIGNDOC_FindTextPosition_getLast (pos2);
            struct SIGNDOC_Point *pos4 = SIGNDOC_CharacterPosition_getRef (pos3);
            double x = SIGNDOC_Point_getX (pos4);
            double y = SIGNDOC_Point_getY (pos4);
            NSLog (@"x=%g, y=%g", x, y);
            field = SIGNDOC_Field_new (&ex);
            SIGNDOC_Field_setName (&ex, field, SIGNDOC_ENCODING_NATIVE, field_name_sig);
            SIGNDOC_Field_setType (&ex, field, SIGNDOC_FIELD_TYPE_SIGNATURE_DIGSIG);
            SIGNDOC_Field_setPage (&ex, field, 1);
            SIGNDOC_Field_setLeft (&ex, field, x - 150);
            SIGNDOC_Field_setRight (&ex, field, x + 10);
            SIGNDOC_Field_setBottom (&ex, field, y - 30);
            SIGNDOC_Field_setTop (&ex, field, y + 30);
            int set_field_flags = SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_FAIL;
            rc = SIGNDOC_Document_addField (&ex, doc, field, set_field_flags);
            if (rc != SIGNDOC_DOCUMENT_RETURNCODE_OK)
                failDoc (doc, rc, "SIGNDOC_Document_addField");
            NSLog (@"Signature field added");
            
            // Sign
            
            NSString *bio_path2 = [NSString stringWithUTF8String:bio_path];
            NSString *bio_path3 = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:bio_path2];
            const char *bio_path4 = [bio_path3 UTF8String];
            NSLog (@"bio file: %s", bio_path4);
            size_t bio_size = 0;
            unsigned char *bio_ptr = readFile (bio_path4, &bio_size);
            
            NSString *bmp_path2 = [NSString stringWithUTF8String:bmp_path];
            NSString *bmp_path3 = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:bmp_path2];
            const char *bmp_path4 = [bmp_path3 UTF8String];
            NSLog (@"bmp file: %s", bmp_path4);
            size_t bmp_size = 0;
            unsigned char *bmp_ptr = readFile (bmp_path4, &bmp_size);
            
            signTest(field_name_sig, bio_ptr, bio_size, bmp_ptr, bmp_size, test_output_file, TRUE);
            
            NSLog (@"Document signed");
            doc_signed = 1;
            free (bio_ptr);
            free (bmp_ptr);
        }
        
        if (doc_signed)
        {
            // Verify
            
            rc = SIGNDOC_Document_verifySignature (&ex, doc, SIGNDOC_ENCODING_NATIVE, field_name_sig, &ver);
            if (rc != SIGNDOC_DOCUMENT_RETURNCODE_OK)
                failDoc (doc, rc, "SIGNDOC_Document_verifySignature");
            int ss = -17;
            rc = SIGNDOC_VerificationResult_getState (&ex, ver, &ss);
            /** @todo SIGNDOC_VERIFICATIONRESULT_RETURNCODE_OK */
            if (rc != SIGNDOC_DOCUMENT_RETURNCODE_OK)
                failVer (ver, rc, "SIGNDOC_VerificationResult_getState");
            if (ss == SIGNDOC_VERIFICATIONRESULT_SIGNATURESTATE_UNMODIFIED)
                NSLog (@"Document unmodified");
            else
                NSLog (@"State = %d", ss);
        }
        
        // Render page as image
        
        NSString *image_path2 = [NSString stringWithUTF8String:image_path];
        NSString *image_path3 = [doc_path stringByAppendingPathComponent:image_path2];
        const char *image_path4 = [image_path3 UTF8String];
        NSLog (@"Image file: %s", image_path4);
        remove (image_path4);
        
        blob = renderTest(1024);
        writeFile (image_path4, SIGNDOC_ByteArray_data (blob),
                   SIGNDOC_ByteArray_count (blob));
        NSLog (@"Image saved");
        
        if (!doc_signed)
        {
            // Save document
            rc = SIGNDOC_Document_saveToFile (&ex, doc, SIGNDOC_ENCODING_NATIVE, NULL, SIGNDOC_DOCUMENT_SAVEFLAGS_INCREMENTAL);
            if (rc != SIGNDOC_DOCUMENT_RETURNCODE_OK)
                failDoc (doc, rc, "SIGNDOC_Document_saveToFile");
            NSLog (@"Document saved");
        }
        
        {
            // Check properties
            SIGNDOC_Document_delete (doc);
            doc = NULL;
            
            doc = SIGNDOC_DocumentLoader_loadFromFile (&ex, loader, SIGNDOC_ENCODING_NATIVE, test_output_file, SIGNDOC_TRUE);
            if (doc == NULL)
                failLoader (loader, "SIGNDOC_DocumentLoader_loadFromFile");
            
            char *v = NULL;
            int rc = SIGNDOC_Document_getStringProperty (&ex, doc, SIGNDOC_ENCODING_NATIVE, "encrypted", "priv1", &v);
            if (rc != SIGNDOC_DOCUMENT_RETURNCODE_OK)
                failDoc (doc, rc, "SIGNDOC_Document_getStringProperty");
            NSLog (@"priv1=%s", v);
            if (strcmp (v, "one") != 0)
                NSLog (@"Wrong value for priv1");
             SIGNDOC_free (v);
            
            v = NULL;
            rc = SIGNDOC_Document_getStringProperty (&ex, doc, SIGNDOC_ENCODING_NATIVE, "public", "pub2", &v);
            if (rc != SIGNDOC_DOCUMENT_RETURNCODE_OK)
                failDoc (doc, rc, "SIGNDOC_Document_getStringProperty");
            NSLog (@"pub2=%s", v);
            if (strcmp (v, "two") != 0)
                NSLog (@"Wrong value for pub2");
            SIGNDOC_free (v);
        }
    }
    @catch (NSException *e)
    {
        NSLog (@"Exception: %@", e);
    }
    @finally
    {
        NSLog (@"Executing finally clause");
        if (blob != NULL)
            SIGNDOC_ByteArray_delete (blob);
        if (ver != NULL)
            SIGNDOC_VerificationResult_delete (ver);
        if (tfa != NULL)
            SIGNDOC_TextFieldAttributes_delete (tfa);
        if (field != NULL)
            SIGNDOC_Field_delete (field);
        if (pos != NULL)
            SIGNDOC_FindTextPositionArray_delete (pos);
    }
    NSLog (@"Test done");
}
