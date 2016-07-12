#import <Foundation/Foundation.h>
#import "USAdditions.h"
#import <libxml/tree.h>
#import "USGlobals.h"
#import "AppDelegate.h"
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
@class AgentWS_CheckVersion;
@class AgentWS_CheckVersionResponse;
@class AgentWS_CheckVersionResult;
@class AgentWS_PartialSync;
@class AgentWS_PartialSyncResponse;
@class AgentWS_PartialSyncResult;
@class AgentWS_LoginAPI;
@class AgentWS_LoginAPIResponse;
@class AgentWS_VersionChecker;
@class AgentWS_VersionCheckerResponse;
@class AgentWS_SupervisorLogin;
@class AgentWS_SupervisorLoginResponse;
@class AgentWS_SupervisorLoginResult;
@class AgentWS_AdminLogin;
@class AgentWS_AdminLoginResponse;
@class AgentWS_ChangeUDID;
@class AgentWS_ChangeUDIDResponse;
@class AgentWS_DataSet;
@class AgentWS_Syncdatareferral;
@class AgentWS_SyncdatareferralResponse;
@class AgentWS_SyncdatareferralResult;
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
    NSString * strUDID;
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
@property (retain) NSString * strUDID;
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
    NSString * strAgentCode;
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
@property (retain) NSString * strAgentCode;
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
@interface AgentWS_CheckVersion : NSObject {
    
    /* elements */
    NSString * strVesion;
    NSString * strStatus;
    /* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_CheckVersion *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * strVesion;
@property (retain) NSString * strStatus;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_CheckVersionResult : NSObject {
    /* elements */
    NSString * xmlDetails;
    /* attributes */
}
@property (retain) NSString * xmlDetails;
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_CheckVersionResult *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_CheckVersionResponse : NSObject {
    
    /* elements */
    AgentWS_CheckVersionResult * CheckVersionResult;
    NSString * strStatus;
    /* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_CheckVersionResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) AgentWS_CheckVersionResult * CheckVersionResult;
@property (retain) NSString * strStatus;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_PartialSync : NSObject {
    
    /* elements */
    NSString * MasterInfo;
    NSString * DataCabang;
    NSString * eProposalCreditCardBank;
    NSString * eProposalIdentification;
    NSString * eProposalLADetails;
    NSString * eProposalMaritalStatus;
    NSString * eProposalNationality;
    NSString * eProposalOCCP;
    NSString * eProposalReferralSource;
    NSString * eProposalRelation;
    NSString * eProposalReligion;
    NSString * eProposalSourceIncome;
    NSString * eProposalTitle;
    NSString * eProposalVIPClass;
    NSString * DataReferral;
    NSString * kodepos;
    NSString * strStatus;
    /* attributes */
    
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_PartialSync *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * MasterInfo;
@property (retain) NSString * DataCabang;
@property (retain) NSString * eProposalCreditCardBank;
@property (retain) NSString * eProposalIdentification;
@property (retain) NSString * eProposalLADetails;
@property (retain) NSString * eProposalMaritalStatus;
@property (retain) NSString * eProposalNationality;
@property (retain) NSString * eProposalOCCP;
@property (retain) NSString * eProposalReferralSource;
@property (retain) NSString * eProposalRelation;
@property (retain) NSString * eProposalReligion;
@property (retain) NSString * eProposalSourceIncome;
@property (retain) NSString * eProposalTitle;
@property (retain) NSString * eProposalVIPClass;
@property (retain) NSString * DataReferral;
@property (retain) NSString * kodepos;
@property (retain) NSString * strStatus;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_PartialSyncResult : NSObject {
    
    /* elements */
    NSString * xmlDetails;
    /* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_PartialSyncResult *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property(retain)  NSString * xmlDetails;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_PartialSyncResponse : NSObject {
    
    /* elements */
    AgentWS_PartialSyncResult * PartialSyncResult;
    /* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_PartialSyncResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) AgentWS_PartialSyncResult * PartialSyncResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_LoginAPI : NSObject {
    
    /* elements */
    NSString * strAgentCode;
    NSString * strPass;
    NSString * strStatus;
    /* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_LoginAPI *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * strAgentCode;
@property (retain) NSString * strPass;
@property (retain) NSString * strStatus;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_LoginAPIResponse : NSObject {
    
    /* elements */
    NSString * LoginAPIResult;
    /* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_LoginAPIResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * LoginAPIResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_VersionChecker : NSObject {
    
    /* elements */
    NSString * strVersion;
    /* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_VersionChecker *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * strVersion;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_VersionCheckerResponse : NSObject {
    
    /* elements */
    NSString * VersionCheckerResult;
    /* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_VersionCheckerResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * VersionCheckerResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_SupervisorLogin : NSObject {
    
    /* elements */
    NSString * strAgentcode;
    NSString * strSupervisorname;
    NSString * strSupervisorPass;
    NSString * strStatus;
    /* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_SupervisorLogin *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * strAgentcode;
@property (retain) NSString * strSupervisorname;
@property (retain) NSString * strSupervisorPass;
@property (retain) NSString * strStatus;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_SupervisorLoginResult : NSObject {
    
    /* elements */
    NSString * xmlDetails;
    /* attributes */
}
@property (retain) NSString * xmlDetails;
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_SupervisorLoginResult *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_SupervisorLoginResponse : NSObject {
    
    /* elements */
    AgentWS_SupervisorLoginResult * SupervisorLoginResult;
    NSString * strStatus;
    /* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_SupervisorLoginResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) AgentWS_SupervisorLoginResult * SupervisorLoginResult;
@property (retain) NSString * strStatus;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_AdminLogin : NSObject {
    
    /* elements */
    NSString * stradmin;
    NSString * stradminpass;
    NSString * strStatus;
    /* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_AdminLogin *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * stradmin;
@property (retain) NSString * stradminpass;
@property (retain) NSString * strStatus;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_AdminLoginResponse : NSObject {
    
    /* elements */
    NSString * AdminLoginResult;
    /* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_AdminLoginResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * AdminLoginResult;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_DataSet : NSObject {
    
    /* elements */
    NSString * xmlDetails;
    /* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_DataSet *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property(retain) NSString * xmlDetails;
/* attributes */
- (NSDictionary *)attributes;
@end

@interface AgentWS_ChangeUDID : NSObject {
    
    /* elements */
    NSString * strAgentcode;
    NSString * strUDID;
    NSString * strStatus;
    /* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_ChangeUDID *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * strAgentcode;
@property (retain) NSString * strUDID;
@property (retain) NSString * strStatus;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_ChangeUDIDResponse : NSObject {
    
    /* elements */
    NSString * ChangeUDIDResult;
    NSString * strStatus;
    /* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_ChangeUDIDResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * ChangeUDIDResult;
@property (retain) NSString * strStatus;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_Syncdatareferral : NSObject {
    
    /* elements */
    NSString * strUpdateDate;
    NSString * strstatus;
    /* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_Syncdatareferral *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) NSString * strUpdateDate;
@property (retain) NSString * strstatus;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_SyncdatareferralResult : NSObject {
    /* elements */
    NSString * xmlDetails;
    /* attributes */
}
@property (retain) NSString * xmlDetails;
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_SyncdatareferralResult *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AgentWS_SyncdatareferralResponse : NSObject {
    
    /* elements */
    AgentWS_SyncdatareferralResult * SyncdatareferralResult;
    NSString * strstatus;
    /* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AgentWS_SyncdatareferralResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
/* elements */
@property (retain) AgentWS_SyncdatareferralResult * SyncdatareferralResult;
@property (retain) NSString * strstatus;
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
- (AgentWSSoapBindingResponse *)CheckVersionUsingParameters:(AgentWS_CheckVersion *)aParameters ;
- (void)CheckVersionAsyncUsingParameters:(AgentWS_CheckVersion *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate;
- (AgentWSSoapBindingResponse *)PartialSyncUsingParameters:(AgentWS_PartialSync *)aParameters ;
- (void)PartialSyncAsyncUsingParameters:(AgentWS_PartialSync *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate;
- (AgentWSSoapBindingResponse *)LoginAPIUsingParameters:(AgentWS_LoginAPI *)aParameters ;
- (void)LoginAPIAsyncUsingParameters:(AgentWS_LoginAPI *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate;
- (AgentWSSoapBindingResponse *)VersionCheckerUsingParameters:(AgentWS_VersionChecker *)aParameters ;
- (void)VersionCheckerAsyncUsingParameters:(AgentWS_VersionChecker *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate;
- (AgentWSSoapBindingResponse *)SupervisorLoginUsingParameters:(AgentWS_SupervisorLogin *)aParameters ;
- (void)SupervisorLoginAsyncUsingParameters:(AgentWS_SupervisorLogin *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate;
- (AgentWSSoapBindingResponse *)AdminLoginUsingParameters:(AgentWS_AdminLogin *)aParameters ;
- (void)AdminLoginAsyncUsingParameters:(AgentWS_AdminLogin *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate;
- (AgentWSSoapBindingResponse *)ChangeUDIDUsingParameters:(AgentWS_ChangeUDID *)aParameters ;
- (void)ChangeUDIDAsyncUsingParameters:(AgentWS_ChangeUDID *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate;
- (AgentWSSoapBindingResponse *)SyncdatareferralUsingParameters:(AgentWS_Syncdatareferral *)aParameters ;
- (void)SyncdatareferralAsyncUsingParameters:(AgentWS_Syncdatareferral *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate;
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
@interface AgentWSSoapBinding_CheckVersion : AgentWSSoapBindingOperation {
    AgentWS_CheckVersion * parameters;
}
@property (retain) AgentWS_CheckVersion * parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)aDelegate
           parameters:(AgentWS_CheckVersion *)aParameters
;
@end
@interface AgentWSSoapBinding_PartialSync : AgentWSSoapBindingOperation {
    AgentWS_PartialSync * parameters;
}
@property (retain) AgentWS_PartialSync * parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)aDelegate
           parameters:(AgentWS_PartialSync *)aParameters
;
@end
@interface AgentWSSoapBinding_LoginAPI : AgentWSSoapBindingOperation {
    AgentWS_LoginAPI * parameters;
}
@property (retain) AgentWS_LoginAPI * parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)aDelegate
           parameters:(AgentWS_LoginAPI *)aParameters
;
@end
@interface AgentWSSoapBinding_VersionChecker : AgentWSSoapBindingOperation {
    AgentWS_VersionChecker * parameters;
}
@property (retain) AgentWS_VersionChecker * parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)aDelegate
           parameters:(AgentWS_VersionChecker *)aParameters
;
@end
@interface AgentWSSoapBinding_SupervisorLogin : AgentWSSoapBindingOperation {
    AgentWS_SupervisorLogin * parameters;
}
@property (retain) AgentWS_SupervisorLogin * parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)aDelegate
           parameters:(AgentWS_SupervisorLogin *)aParameters
;
@end
@interface AgentWSSoapBinding_AdminLogin : AgentWSSoapBindingOperation {
    AgentWS_AdminLogin * parameters;
}
@property (retain) AgentWS_AdminLogin * parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)aDelegate
           parameters:(AgentWS_AdminLogin *)aParameters
;
@end
@interface AgentWSSoapBinding_ChangeUDID : AgentWSSoapBindingOperation {
    AgentWS_ChangeUDID * parameters;
}
@property (retain) AgentWS_ChangeUDID * parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)aDelegate
           parameters:(AgentWS_ChangeUDID *)aParameters
;
@end
@interface AgentWSSoapBinding_Syncdatareferral : AgentWSSoapBindingOperation {
    AgentWS_Syncdatareferral * parameters;
}
@property (retain) AgentWS_Syncdatareferral * parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)aDelegate
           parameters:(AgentWS_Syncdatareferral *)aParameters
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
- (AgentWSSoap12BindingResponse *)CheckVersionUsingParameters:(AgentWS_CheckVersion *)aParameters ;
- (void)CheckVersionAsyncUsingParameters:(AgentWS_CheckVersion *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate;
- (AgentWSSoap12BindingResponse *)PartialSyncUsingParameters:(AgentWS_PartialSync *)aParameters ;
- (void)PartialSyncAsyncUsingParameters:(AgentWS_PartialSync *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate;
- (AgentWSSoap12BindingResponse *)LoginAPIUsingParameters:(AgentWS_LoginAPI *)aParameters ;
- (void)LoginAPIAsyncUsingParameters:(AgentWS_LoginAPI *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate;
- (AgentWSSoap12BindingResponse *)VersionCheckerUsingParameters:(AgentWS_VersionChecker *)aParameters ;
- (void)VersionCheckerAsyncUsingParameters:(AgentWS_VersionChecker *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate;
- (AgentWSSoap12BindingResponse *)SupervisorLoginUsingParameters:(AgentWS_SupervisorLogin *)aParameters ;
- (void)SupervisorLoginAsyncUsingParameters:(AgentWS_SupervisorLogin *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate;
- (AgentWSSoap12BindingResponse *)AdminLoginUsingParameters:(AgentWS_AdminLogin *)aParameters ;
- (void)AdminLoginAsyncUsingParameters:(AgentWS_AdminLogin *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate;
- (AgentWSSoap12BindingResponse *)ChangeUDIDUsingParameters:(AgentWS_ChangeUDID *)aParameters ;
- (void)ChangeUDIDAsyncUsingParameters:(AgentWS_ChangeUDID *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate;
- (AgentWSSoap12BindingResponse *)SyncdatareferralUsingParameters:(AgentWS_Syncdatareferral *)aParameters ;
- (void)SyncdatareferralAsyncUsingParameters:(AgentWS_Syncdatareferral *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate;
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
@interface AgentWSSoap12Binding_CheckVersion : AgentWSSoap12BindingOperation {
    AgentWS_CheckVersion * parameters;
}
@property (retain) AgentWS_CheckVersion * parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)aDelegate
           parameters:(AgentWS_CheckVersion *)aParameters
;
@end
@interface AgentWSSoap12Binding_PartialSync : AgentWSSoap12BindingOperation {
    AgentWS_PartialSync * parameters;
}
@property (retain) AgentWS_PartialSync * parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)aDelegate
           parameters:(AgentWS_PartialSync *)aParameters
;
@end
@interface AgentWSSoap12Binding_LoginAPI : AgentWSSoap12BindingOperation {
    AgentWS_LoginAPI * parameters;
}
@property (retain) AgentWS_LoginAPI * parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)aDelegate
           parameters:(AgentWS_LoginAPI *)aParameters
;
@end
@interface AgentWSSoap12Binding_VersionChecker : AgentWSSoap12BindingOperation {
    AgentWS_VersionChecker * parameters;
}
@property (retain) AgentWS_VersionChecker * parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)aDelegate
           parameters:(AgentWS_VersionChecker *)aParameters
;
@end
@interface AgentWSSoap12Binding_SupervisorLogin : AgentWSSoap12BindingOperation {
    AgentWS_SupervisorLogin * parameters;
}
@property (retain) AgentWS_SupervisorLogin * parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)aDelegate
           parameters:(AgentWS_SupervisorLogin *)aParameters
;
@end
@interface AgentWSSoap12Binding_AdminLogin : AgentWSSoap12BindingOperation {
    AgentWS_AdminLogin * parameters;
}
@property (retain) AgentWS_AdminLogin * parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)aDelegate
           parameters:(AgentWS_AdminLogin *)aParameters
;
@end
@interface AgentWSSoap12Binding_ChangeUDID : AgentWSSoap12BindingOperation {
    AgentWS_ChangeUDID * parameters;
}
@property (retain) AgentWS_ChangeUDID * parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)aDelegate
           parameters:(AgentWS_ChangeUDID *)aParameters
;
@end
@interface AgentWSSoap12Binding_Syncdatareferral : AgentWSSoap12BindingOperation {
    AgentWS_Syncdatareferral * parameters;
}
@property (retain) AgentWS_Syncdatareferral * parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)aDelegate
           parameters:(AgentWS_Syncdatareferral *)aParameters
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
