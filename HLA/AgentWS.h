#import <Foundation/Foundation.h>
#import "USAdditions.h"
#import <libxml/tree.h>
#import "USGlobals.h"
@class AgentWS_ValidateAgentAndDevice;
@class AgentWS_ValidateAgentAndDeviceResponse;
@class AgentWS_ValidateLogin;
@class AgentWS_ValidateLoginResponse;
@class AgentWS_ValidateLoginResult;
@class AgentWS_SaveDocument;
@class AgentWS_SaveDocumentResponse;
@class AgentWS_RetrievePolicyNumber;
@class AgentWS_RetrievePolicyNumberResponse;
@class AgentWS_SendForgotPassword;
@class AgentWS_SendForgotPasswordResponse;
@class AgentWS_ReceiveFirstLogin;
@class AgentWS_ReceiveFirstLoginResponse;
@class AgentWS_ReceiveFirstLoginResult;
@class AgentWS_ChangePassword;
@class AgentWS_ChangePasswordResponse;
@class AgentWS_FullSyncTable;
@class AgentWS_FullSyncTableResponse;
@class AgentWS_FullSyncTableResult;
@class AgentWS_PartialSyncTable;
@class AgentWS_PartialSyncTableResponse;
@class AgentWS_PartialSyncTableResult;
@interface AgentWS_ValidateAgentAndDevice : NSObject {
	
/* elements */
	NSString * strAgentID;
	NSString * strDeviceID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_ValidateAgentAndDevice *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * strAgentID;
@property (retain) NSString * strDeviceID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_ValidateAgentAndDeviceResponse : NSObject {
	
/* elements */
	NSString * ValidateAgentAndDeviceResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_ValidateAgentAndDeviceResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * ValidateAgentAndDeviceResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_ValidateLogin : NSObject {
	
/* elements */
	NSString * strAgentID;
	NSString * strPassword;
	NSString * strDeviceID;
	NSString * strStatus;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_ValidateLogin *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * strAgentID;
@property (retain) NSString * strPassword;
@property (retain) NSString * strDeviceID;
@property (retain) NSString * strStatus;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_ValidateLoginResult : NSObject {
    /* elements */
    NSString * xmlDetails;
    /* attributes */
}
@property (retain) NSString * xmlDetails;
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_ValidateLoginResult *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_ValidateLoginResponse : NSObject {
	
/* elements */
	AgentWS_ValidateLoginResult * ValidateLoginResult;
	NSString * strStatus;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_ValidateLoginResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) AgentWS_ValidateLoginResult * ValidateLoginResult;
@property (retain) NSString * strStatus;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_SaveDocument : NSObject {
	
/* elements */
	NSString * strBinary;
	NSString * strDocName;
	NSString * strFolder;
	NSString * strSource;
	NSString * agentID;
	NSString * totalFile;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_SaveDocument *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * strBinary;
@property (retain) NSString * strDocName;
@property (retain) NSString * strFolder;
@property (retain) NSString * strSource;
@property (retain) NSString * agentID;
@property (retain) NSString * totalFile;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_SaveDocumentResponse : NSObject {
	
/* elements */
	NSString * SaveDocumentResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_SaveDocumentResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * SaveDocumentResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_RetrievePolicyNumber : NSObject {
	
/* elements */
	NSString * agentCode;
	NSString * strPolNo;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_RetrievePolicyNumber *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * agentCode;
@property (retain) NSString * strPolNo;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_RetrievePolicyNumberResponse : NSObject {
	
/* elements */
	NSString * RetrievePolicyNumberResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_RetrievePolicyNumberResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * RetrievePolicyNumberResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_SendForgotPassword : NSObject {
	
/* elements */
	NSString * strAgentId;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_SendForgotPassword *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * strAgentId;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_SendForgotPasswordResponse : NSObject {
	
/* elements */
	NSString * SendForgotPasswordResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_SendForgotPasswordResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * SendForgotPasswordResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_ReceiveFirstLogin : NSObject {
	
/* elements */
	NSString * strAgentId;
	NSString * strAgentPass;
	NSString * strNewPass;
	NSString * strUID;
	NSString * strStatus;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_ReceiveFirstLogin *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * strAgentId;
@property (retain) NSString * strAgentPass;
@property (retain) NSString * strNewPass;
@property (retain) NSString * strUID;
@property (retain) NSString * strStatus;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_ReceiveFirstLoginResult : NSObject {
    /* elements */
    NSString * xmlDetails;
    /* attributes */
}
@property (retain) NSString * xmlDetails;
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_ReceiveFirstLoginResult *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_ReceiveFirstLoginResponse : NSObject {
	
/* elements */
	AgentWS_ReceiveFirstLoginResult * ReceiveFirstLoginResult;
	NSString * strStatus;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_ReceiveFirstLoginResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) AgentWS_ReceiveFirstLoginResult * ReceiveFirstLoginResult;
@property (retain) NSString * strStatus;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_ChangePassword : NSObject {
	
/* elements */
	NSString * strAgentId;
	NSString * strPassword;
	NSString * strNewPass;
	NSString * strUDID;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_ChangePassword *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * strAgentId;
@property (retain) NSString * strPassword;
@property (retain) NSString * strNewPass;
@property (retain) NSString * strUDID;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_ChangePasswordResponse : NSObject {
	
/* elements */
	NSString * ChangePasswordResult;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_ChangePasswordResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * ChangePasswordResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_FullSyncTable : NSObject {
	
/* elements */
	NSString * strStatus;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_FullSyncTable *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * strStatus;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_FullSyncTableResult : NSObject {
	
    /* elements */
    NSString * xmlDetails;
    /* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_FullSyncTableResult *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * xmlDetails;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_FullSyncTableResponse : NSObject {
	
/* elements */
	AgentWS_FullSyncTableResult * FullSyncTableResult;
	NSString * strStatus;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_FullSyncTableResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) AgentWS_FullSyncTableResult * FullSyncTableResult;
@property (retain) NSString * strStatus;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_PartialSyncTable : NSObject {
	
/* elements */
	NSString * strStatus;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_PartialSyncTable *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * strStatus;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_PartialSyncTableResult : NSObject {
	
/* elements */
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_PartialSyncTableResult *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_PartialSyncTableResponse : NSObject {
	
/* elements */
	AgentWS_PartialSyncTableResult * PartialSyncTableResult;
	NSString * strStatus;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_PartialSyncTableResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) AgentWS_PartialSyncTableResult * PartialSyncTableResult;
@property (retain) NSString * strStatus;
/* attributes */
- (NSDictionary *)attributes;
@end
/* Cookies handling provided by http://en.wikibooks.org/wiki/Programming:WebObjects/Web_Services/Web_Service_Provider */
#import <libxml/parser.h>
#import "xsd.h"
#import "AgentWS.h"
@class AgentWSSoapBinding;
@class AgentWSSoap12Binding;
@interface AgentWS : NSObject {
	
}
+ (AgentWSSoapBinding *)AgentWSSoapBinding;
+ (AgentWSSoap12Binding *)AgentWSSoap12Binding;
@end
@class AgentWSSoapBindingResponse;
@class AgentWSSoapBindingOperation;
@protocol AgentWSSoapBindingResponseDelegate <NSObject>
- (void) operation:(AgentWSSoapBindingOperation *)operation completedWithResponse:(AgentWSSoapBindingResponse *)response;
@end
@interface AgentWSSoapBinding : NSObject <AgentWSSoapBindingResponseDelegate> {
	NSURL *address;
	NSTimeInterval defaultTimeout;
	NSMutableArray *cookies;
	BOOL logXMLInOut;
	BOOL synchronousOperationComplete;
	NSString *authUsername;
	NSString *authPassword;
}
@property (copy) NSURL *address;
@property (assign) BOOL logXMLInOut;
@property (assign) NSTimeInterval defaultTimeout;
@property (nonatomic, retain) NSMutableArray *cookies;
@property (nonatomic, retain) NSString *authUsername;
@property (nonatomic, retain) NSString *authPassword;
- (id)initWithAddress:(NSString *)anAddress;
- (void)sendHTTPCallUsingBody:(NSString *)body soapAction:(NSString *)soapAction forOperation:(AgentWSSoapBindingOperation *)operation;
- (void)addCookie:(NSHTTPCookie *)toAdd;
- (AgentWSSoapBindingResponse *)ValidateAgentAndDeviceUsingParameters:(AgentWS_ValidateAgentAndDevice *)aParameters ;
- (void)ValidateAgentAndDeviceAsyncUsingParameters:(AgentWS_ValidateAgentAndDevice *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate;
- (AgentWSSoapBindingResponse *)ValidateLoginUsingParameters:(AgentWS_ValidateLogin *)aParameters ;
- (void)ValidateLoginAsyncUsingParameters:(AgentWS_ValidateLogin *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate;
- (AgentWSSoapBindingResponse *)SaveDocumentUsingParameters:(AgentWS_SaveDocument *)aParameters ;
- (void)SaveDocumentAsyncUsingParameters:(AgentWS_SaveDocument *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate;
- (AgentWSSoapBindingResponse *)RetrievePolicyNumberUsingParameters:(AgentWS_RetrievePolicyNumber *)aParameters ;
- (void)RetrievePolicyNumberAsyncUsingParameters:(AgentWS_RetrievePolicyNumber *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate;
- (AgentWSSoapBindingResponse *)SendForgotPasswordUsingParameters:(AgentWS_SendForgotPassword *)aParameters ;
- (void)SendForgotPasswordAsyncUsingParameters:(AgentWS_SendForgotPassword *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate;
- (AgentWSSoapBindingResponse *)ReceiveFirstLoginUsingParameters:(AgentWS_ReceiveFirstLogin *)aParameters ;
- (void)ReceiveFirstLoginAsyncUsingParameters:(AgentWS_ReceiveFirstLogin *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate;
- (AgentWSSoapBindingResponse *)ChangePasswordUsingParameters:(AgentWS_ChangePassword *)aParameters ;
- (void)ChangePasswordAsyncUsingParameters:(AgentWS_ChangePassword *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate;
- (AgentWSSoapBindingResponse *)FullSyncTableUsingParameters:(AgentWS_FullSyncTable *)aParameters ;
- (void)FullSyncTableAsyncUsingParameters:(AgentWS_FullSyncTable *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate;
- (AgentWSSoapBindingResponse *)PartialSyncTableUsingParameters:(AgentWS_PartialSyncTable *)aParameters ;
- (void)PartialSyncTableAsyncUsingParameters:(AgentWS_PartialSyncTable *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate;
@end
@interface AgentWSSoapBindingOperation : NSOperation {
	AgentWSSoapBinding *binding;
	AgentWSSoapBindingResponse *response;
	id<AgentWSSoapBindingResponseDelegate> delegate;
	NSMutableData *responseData;
	NSURLConnection *urlConnection;
}
@property (retain) AgentWSSoapBinding *binding;
@property (readonly) AgentWSSoapBindingResponse *response;
@property (nonatomic, assign) id<AgentWSSoapBindingResponseDelegate> delegate;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSURLConnection *urlConnection;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)aDelegate;
@end
@interface AgentWSSoapBinding_ValidateAgentAndDevice : AgentWSSoapBindingOperation {
	AgentWS_ValidateAgentAndDevice * parameters;
}
@property (retain) AgentWS_ValidateAgentAndDevice * parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)aDelegate
	parameters:(AgentWS_ValidateAgentAndDevice *)aParameters
;
@end
@interface AgentWSSoapBinding_ValidateLogin : AgentWSSoapBindingOperation {
	AgentWS_ValidateLogin * parameters;
}
@property (retain) AgentWS_ValidateLogin * parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)aDelegate
	parameters:(AgentWS_ValidateLogin *)aParameters
;
@end
@interface AgentWSSoapBinding_SaveDocument : AgentWSSoapBindingOperation {
	AgentWS_SaveDocument * parameters;
}
@property (retain) AgentWS_SaveDocument * parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)aDelegate
	parameters:(AgentWS_SaveDocument *)aParameters
;
@end
@interface AgentWSSoapBinding_RetrievePolicyNumber : AgentWSSoapBindingOperation {
	AgentWS_RetrievePolicyNumber * parameters;
}
@property (retain) AgentWS_RetrievePolicyNumber * parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)aDelegate
	parameters:(AgentWS_RetrievePolicyNumber *)aParameters
;
@end
@interface AgentWSSoapBinding_SendForgotPassword : AgentWSSoapBindingOperation {
	AgentWS_SendForgotPassword * parameters;
}
@property (retain) AgentWS_SendForgotPassword * parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)aDelegate
	parameters:(AgentWS_SendForgotPassword *)aParameters
;
@end
@interface AgentWSSoapBinding_ReceiveFirstLogin : AgentWSSoapBindingOperation {
	AgentWS_ReceiveFirstLogin * parameters;
}
@property (retain) AgentWS_ReceiveFirstLogin * parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)aDelegate
	parameters:(AgentWS_ReceiveFirstLogin *)aParameters
;
@end
@interface AgentWSSoapBinding_ChangePassword : AgentWSSoapBindingOperation {
	AgentWS_ChangePassword * parameters;
}
@property (retain) AgentWS_ChangePassword * parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)aDelegate
	parameters:(AgentWS_ChangePassword *)aParameters
;
@end
@interface AgentWSSoapBinding_FullSyncTable : AgentWSSoapBindingOperation {
	AgentWS_FullSyncTable * parameters;
}
@property (retain) AgentWS_FullSyncTable * parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)aDelegate
	parameters:(AgentWS_FullSyncTable *)aParameters
;
@end
@interface AgentWSSoapBinding_PartialSyncTable : AgentWSSoapBindingOperation {
	AgentWS_PartialSyncTable * parameters;
}
@property (retain) AgentWS_PartialSyncTable * parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)aDelegate
	parameters:(AgentWS_PartialSyncTable *)aParameters
;
@end
@interface AgentWSSoapBinding_envelope : NSObject {
}
+ (AgentWSSoapBinding_envelope *)sharedInstance;
- (NSString *)serializedFormUsingHeaderElements:(NSDictionary *)headerElements bodyElements:(NSDictionary *)bodyElements;
@end
@interface AgentWSSoapBindingResponse : NSObject {
	NSArray *headers;
	NSArray *bodyParts;
	NSError *error;
}
@property (retain) NSArray *headers;
@property (retain) NSArray *bodyParts;
@property (retain) NSError *error;
@end
@class AgentWSSoap12BindingResponse;
@class AgentWSSoap12BindingOperation;
@protocol AgentWSSoap12BindingResponseDelegate <NSObject>
- (void) operation:(AgentWSSoap12BindingOperation *)operation completedWithResponse:(AgentWSSoap12BindingResponse *)response;
@end
@interface AgentWSSoap12Binding : NSObject <AgentWSSoap12BindingResponseDelegate> {
	NSURL *address;
	NSTimeInterval defaultTimeout;
	NSMutableArray *cookies;
	BOOL logXMLInOut;
	BOOL synchronousOperationComplete;
	NSString *authUsername;
	NSString *authPassword;
}
@property (copy) NSURL *address;
@property (assign) BOOL logXMLInOut;
@property (assign) NSTimeInterval defaultTimeout;
@property (nonatomic, retain) NSMutableArray *cookies;
@property (nonatomic, retain) NSString *authUsername;
@property (nonatomic, retain) NSString *authPassword;
- (id)initWithAddress:(NSString *)anAddress;
- (void)sendHTTPCallUsingBody:(NSString *)body soapAction:(NSString *)soapAction forOperation:(AgentWSSoap12BindingOperation *)operation;
- (void)addCookie:(NSHTTPCookie *)toAdd;
- (AgentWSSoap12BindingResponse *)ValidateAgentAndDeviceUsingParameters:(AgentWS_ValidateAgentAndDevice *)aParameters ;
- (void)ValidateAgentAndDeviceAsyncUsingParameters:(AgentWS_ValidateAgentAndDevice *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate;
- (AgentWSSoap12BindingResponse *)ValidateLoginUsingParameters:(AgentWS_ValidateLogin *)aParameters ;
- (void)ValidateLoginAsyncUsingParameters:(AgentWS_ValidateLogin *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate;
- (AgentWSSoap12BindingResponse *)SaveDocumentUsingParameters:(AgentWS_SaveDocument *)aParameters ;
- (void)SaveDocumentAsyncUsingParameters:(AgentWS_SaveDocument *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate;
- (AgentWSSoap12BindingResponse *)RetrievePolicyNumberUsingParameters:(AgentWS_RetrievePolicyNumber *)aParameters ;
- (void)RetrievePolicyNumberAsyncUsingParameters:(AgentWS_RetrievePolicyNumber *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate;
- (AgentWSSoap12BindingResponse *)SendForgotPasswordUsingParameters:(AgentWS_SendForgotPassword *)aParameters ;
- (void)SendForgotPasswordAsyncUsingParameters:(AgentWS_SendForgotPassword *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate;
- (AgentWSSoap12BindingResponse *)ReceiveFirstLoginUsingParameters:(AgentWS_ReceiveFirstLogin *)aParameters ;
- (void)ReceiveFirstLoginAsyncUsingParameters:(AgentWS_ReceiveFirstLogin *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate;
- (AgentWSSoap12BindingResponse *)ChangePasswordUsingParameters:(AgentWS_ChangePassword *)aParameters ;
- (void)ChangePasswordAsyncUsingParameters:(AgentWS_ChangePassword *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate;
- (AgentWSSoap12BindingResponse *)FullSyncTableUsingParameters:(AgentWS_FullSyncTable *)aParameters ;
- (void)FullSyncTableAsyncUsingParameters:(AgentWS_FullSyncTable *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate;
- (AgentWSSoap12BindingResponse *)PartialSyncTableUsingParameters:(AgentWS_PartialSyncTable *)aParameters ;
- (void)PartialSyncTableAsyncUsingParameters:(AgentWS_PartialSyncTable *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate;
@end
@interface AgentWSSoap12BindingOperation : NSOperation {
	AgentWSSoap12Binding *binding;
	AgentWSSoap12BindingResponse *response;
	id<AgentWSSoap12BindingResponseDelegate> delegate;
	NSMutableData *responseData;
	NSURLConnection *urlConnection;
}
@property (retain) AgentWSSoap12Binding *binding;
@property (readonly) AgentWSSoap12BindingResponse *response;
@property (nonatomic, assign) id<AgentWSSoap12BindingResponseDelegate> delegate;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSURLConnection *urlConnection;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)aDelegate;
@end
@interface AgentWSSoap12Binding_ValidateAgentAndDevice : AgentWSSoap12BindingOperation {
	AgentWS_ValidateAgentAndDevice * parameters;
}
@property (retain) AgentWS_ValidateAgentAndDevice * parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)aDelegate
	parameters:(AgentWS_ValidateAgentAndDevice *)aParameters
;
@end
@interface AgentWSSoap12Binding_ValidateLogin : AgentWSSoap12BindingOperation {
	AgentWS_ValidateLogin * parameters;
}
@property (retain) AgentWS_ValidateLogin * parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)aDelegate
	parameters:(AgentWS_ValidateLogin *)aParameters
;
@end
@interface AgentWSSoap12Binding_SaveDocument : AgentWSSoap12BindingOperation {
	AgentWS_SaveDocument * parameters;
}
@property (retain) AgentWS_SaveDocument * parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)aDelegate
	parameters:(AgentWS_SaveDocument *)aParameters
;
@end
@interface AgentWSSoap12Binding_RetrievePolicyNumber : AgentWSSoap12BindingOperation {
	AgentWS_RetrievePolicyNumber * parameters;
}
@property (retain) AgentWS_RetrievePolicyNumber * parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)aDelegate
	parameters:(AgentWS_RetrievePolicyNumber *)aParameters
;
@end
@interface AgentWSSoap12Binding_SendForgotPassword : AgentWSSoap12BindingOperation {
	AgentWS_SendForgotPassword * parameters;
}
@property (retain) AgentWS_SendForgotPassword * parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)aDelegate
	parameters:(AgentWS_SendForgotPassword *)aParameters
;
@end
@interface AgentWSSoap12Binding_ReceiveFirstLogin : AgentWSSoap12BindingOperation {
	AgentWS_ReceiveFirstLogin * parameters;
}
@property (retain) AgentWS_ReceiveFirstLogin * parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)aDelegate
	parameters:(AgentWS_ReceiveFirstLogin *)aParameters
;
@end
@interface AgentWSSoap12Binding_ChangePassword : AgentWSSoap12BindingOperation {
	AgentWS_ChangePassword * parameters;
}
@property (retain) AgentWS_ChangePassword * parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)aDelegate
	parameters:(AgentWS_ChangePassword *)aParameters
;
@end
@interface AgentWSSoap12Binding_FullSyncTable : AgentWSSoap12BindingOperation {
	AgentWS_FullSyncTable * parameters;
}
@property (retain) AgentWS_FullSyncTable * parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)aDelegate
	parameters:(AgentWS_FullSyncTable *)aParameters
;
@end
@interface AgentWSSoap12Binding_PartialSyncTable : AgentWSSoap12BindingOperation {
	AgentWS_PartialSyncTable * parameters;
}
@property (retain) AgentWS_PartialSyncTable * parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)aDelegate
	parameters:(AgentWS_PartialSyncTable *)aParameters
;
@end
@interface AgentWSSoap12Binding_envelope : NSObject {
}
+ (AgentWSSoap12Binding_envelope *)sharedInstance;
- (NSString *)serializedFormUsingHeaderElements:(NSDictionary *)headerElements bodyElements:(NSDictionary *)bodyElements;
@end
@interface AgentWSSoap12BindingResponse : NSObject {
	NSArray *headers;
	NSArray *bodyParts;
	NSError *error;
}
@property (retain) NSArray *headers;
@property (retain) NSArray *bodyParts;
@property (retain) NSError *error;
@end
