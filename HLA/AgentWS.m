#import "AgentWS.h"
#import <libxml/xmlstring.h>
#if TARGET_OS_IPHONE
#import <CFNetwork/CFNetwork.h>
#endif
@implementation AgentWS_ValidateAgentAndDevice
- (id)init
{
    if((self = [super init])) {
        strAgentID = 0;
        strDeviceID = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(strAgentID != nil) [strAgentID release];
    if(strDeviceID != nil) [strDeviceID release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.strAgentID != 0) {
        xmlAddChild(node, [self.strAgentID xmlNodeForDoc:node->doc elementName:@"strAgentID" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strDeviceID != 0) {
        xmlAddChild(node, [self.strDeviceID xmlNodeForDoc:node->doc elementName:@"strDeviceID" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize strAgentID;
@synthesize strDeviceID;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_ValidateAgentAndDevice *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_ValidateAgentAndDevice *newObject = [[AgentWS_ValidateAgentAndDevice new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strAgentID")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strAgentID = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strDeviceID")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strDeviceID = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_ValidateAgentAndDeviceResponse
- (id)init
{
    if((self = [super init])) {
        ValidateAgentAndDeviceResult = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(ValidateAgentAndDeviceResult != nil) [ValidateAgentAndDeviceResult release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.ValidateAgentAndDeviceResult != 0) {
        xmlAddChild(node, [self.ValidateAgentAndDeviceResult xmlNodeForDoc:node->doc elementName:@"ValidateAgentAndDeviceResult" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize ValidateAgentAndDeviceResult;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_ValidateAgentAndDeviceResponse *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_ValidateAgentAndDeviceResponse *newObject = [[AgentWS_ValidateAgentAndDeviceResponse new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "ValidateAgentAndDeviceResult")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.ValidateAgentAndDeviceResult = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_ValidateLogin
- (id)init
{
    if((self = [super init])) {
        strAgentID = 0;
        strPassword = 0;
        strUDID = 0;
        strStatus = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(strAgentID != nil) [strAgentID release];
    if(strPassword != nil) [strPassword release];
    if(strUDID != nil) [strUDID release];
    if(strStatus != nil) [strStatus release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.strAgentID != 0) {
        xmlAddChild(node, [self.strAgentID xmlNodeForDoc:node->doc elementName:@"strAgentID" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strPassword != 0) {
        xmlAddChild(node, [self.strPassword xmlNodeForDoc:node->doc elementName:@"strPassword" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strUDID != 0) {
        xmlAddChild(node, [self.strUDID xmlNodeForDoc:node->doc elementName:@"strUDID" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strStatus != 0) {
        xmlAddChild(node, [self.strStatus xmlNodeForDoc:node->doc elementName:@"strStatus" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize strAgentID;
@synthesize strPassword;
@synthesize strUDID;
@synthesize strStatus;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_ValidateLogin *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_ValidateLogin *newObject = [[AgentWS_ValidateLogin new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strAgentID")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strAgentID = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strPassword")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strPassword = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strUDID")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strUDID = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strStatus")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strStatus = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_ValidateLoginResult
@synthesize xmlDetails;
- (id)init
{
    if((self = [super init])) {
    }
    
    return self;
}
- (void)dealloc
{
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
}
/* elements */
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_ValidateLoginResult *)deserializeNode:(xmlNodePtr)cur
{
    xmlBufferPtr buff = xmlBufferCreate();
    int result = xmlNodeDump(buff, NULL, cur, 0, 1);
    NSString *str = @"";
    
    if (result > -1) {
        str = [[NSString alloc] initWithBytes:(xmlBufferContent(buff))
                                       length:(NSUInteger)(xmlBufferLength(buff))
                                     encoding:NSUTF8StringEncoding];
    }
    xmlBufferFree(buff);
    
    AgentWS_ValidateLoginResult *newObject = [[AgentWS_ValidateLoginResult new] autorelease];
    newObject.xmlDetails = str;
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
}
@end
@implementation AgentWS_ValidateLoginResponse
- (id)init
{
    if((self = [super init])) {
        ValidateLoginResult = 0;
        strStatus = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(ValidateLoginResult != nil) [ValidateLoginResult release];
    if(strStatus != nil) [strStatus release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.ValidateLoginResult != 0) {
        xmlAddChild(node, [self.ValidateLoginResult xmlNodeForDoc:node->doc elementName:@"ValidateLoginResult" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strStatus != 0) {
        xmlAddChild(node, [self.strStatus xmlNodeForDoc:node->doc elementName:@"strStatus" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize ValidateLoginResult;
@synthesize strStatus;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_ValidateLoginResponse *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_ValidateLoginResponse *newObject = [[AgentWS_ValidateLoginResponse new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "ValidateLoginResult")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [AgentWS_ValidateLoginResult class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.ValidateLoginResult = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strStatus")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strStatus = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_SaveDocument
- (id)init
{
    if((self = [super init])) {
        strBinary = 0;
        strDocName = 0;
        strFolder = 0;
        strSource = 0;
        agentID = 0;
        totalFile = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(strBinary != nil) [strBinary release];
    if(strDocName != nil) [strDocName release];
    if(strFolder != nil) [strFolder release];
    if(strSource != nil) [strSource release];
    if(agentID != nil) [agentID release];
    if(totalFile != nil) [totalFile release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.strBinary != 0) {
        xmlAddChild(node, [self.strBinary xmlNodeForDoc:node->doc elementName:@"strBinary" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strDocName != 0) {
        xmlAddChild(node, [self.strDocName xmlNodeForDoc:node->doc elementName:@"strDocName" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strFolder != 0) {
        xmlAddChild(node, [self.strFolder xmlNodeForDoc:node->doc elementName:@"strFolder" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strSource != 0) {
        xmlAddChild(node, [self.strSource xmlNodeForDoc:node->doc elementName:@"strSource" elementNSPrefix:@"AgentWS"]);
    }
    if(self.agentID != 0) {
        xmlAddChild(node, [self.agentID xmlNodeForDoc:node->doc elementName:@"agentID" elementNSPrefix:@"AgentWS"]);
    }
    if(self.totalFile != 0) {
        xmlAddChild(node, [self.totalFile xmlNodeForDoc:node->doc elementName:@"totalFile" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize strBinary;
@synthesize strDocName;
@synthesize strFolder;
@synthesize strSource;
@synthesize agentID;
@synthesize totalFile;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_SaveDocument *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_SaveDocument *newObject = [[AgentWS_SaveDocument new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strBinary")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strBinary = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strDocName")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strDocName = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strFolder")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strFolder = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strSource")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strSource = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "agentID")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.agentID = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "totalFile")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.totalFile = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_SaveDocumentResponse
- (id)init
{
    if((self = [super init])) {
        SaveDocumentResult = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(SaveDocumentResult != nil) [SaveDocumentResult release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.SaveDocumentResult != 0) {
        xmlAddChild(node, [self.SaveDocumentResult xmlNodeForDoc:node->doc elementName:@"SaveDocumentResult" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize SaveDocumentResult;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_SaveDocumentResponse *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_SaveDocumentResponse *newObject = [[AgentWS_SaveDocumentResponse new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "SaveDocumentResult")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.SaveDocumentResult = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_RetrievePolicyNumber
- (id)init
{
    if((self = [super init])) {
        agentCode = 0;
        strPolNo = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(agentCode != nil) [agentCode release];
    if(strPolNo != nil) [strPolNo release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.agentCode != 0) {
        xmlAddChild(node, [self.agentCode xmlNodeForDoc:node->doc elementName:@"agentCode" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strPolNo != 0) {
        xmlAddChild(node, [self.strPolNo xmlNodeForDoc:node->doc elementName:@"strPolNo" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize agentCode;
@synthesize strPolNo;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_RetrievePolicyNumber *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_RetrievePolicyNumber *newObject = [[AgentWS_RetrievePolicyNumber new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "agentCode")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.agentCode = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strPolNo")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strPolNo = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_RetrievePolicyNumberResponse
- (id)init
{
    if((self = [super init])) {
        RetrievePolicyNumberResult = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(RetrievePolicyNumberResult != nil) [RetrievePolicyNumberResult release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.RetrievePolicyNumberResult != 0) {
        xmlAddChild(node, [self.RetrievePolicyNumberResult xmlNodeForDoc:node->doc elementName:@"RetrievePolicyNumberResult" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize RetrievePolicyNumberResult;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_RetrievePolicyNumberResponse *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_RetrievePolicyNumberResponse *newObject = [[AgentWS_RetrievePolicyNumberResponse new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "RetrievePolicyNumberResult")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.RetrievePolicyNumberResult = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_SendForgotPassword
- (id)init
{
    if((self = [super init])) {
        strAgentId = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(strAgentId != nil) [strAgentId release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.strAgentId != 0) {
        xmlAddChild(node, [self.strAgentId xmlNodeForDoc:node->doc elementName:@"strAgentId" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize strAgentId;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_SendForgotPassword *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_SendForgotPassword *newObject = [[AgentWS_SendForgotPassword new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strAgentId")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strAgentId = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_SendForgotPasswordResponse
- (id)init
{
    if((self = [super init])) {
        SendForgotPasswordResult = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(SendForgotPasswordResult != nil) [SendForgotPasswordResult release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.SendForgotPasswordResult != 0) {
        xmlAddChild(node, [self.SendForgotPasswordResult xmlNodeForDoc:node->doc elementName:@"SendForgotPasswordResult" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize SendForgotPasswordResult;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_SendForgotPasswordResponse *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_SendForgotPasswordResponse *newObject = [[AgentWS_SendForgotPasswordResponse new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "SendForgotPasswordResult")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.SendForgotPasswordResult = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_ReceiveFirstLogin
- (id)init
{
    if((self = [super init])) {
        strAgentId = 0;
        strAgentPass = 0;
        strNewPass = 0;
        strUID = 0;
        strStatus = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(strAgentId != nil) [strAgentId release];
    if(strAgentPass != nil) [strAgentPass release];
    if(strNewPass != nil) [strNewPass release];
    if(strUID != nil) [strUID release];
    if(strStatus != nil) [strStatus release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.strAgentId != 0) {
        xmlAddChild(node, [self.strAgentId xmlNodeForDoc:node->doc elementName:@"strAgentId" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strAgentPass != 0) {
        xmlAddChild(node, [self.strAgentPass xmlNodeForDoc:node->doc elementName:@"strAgentPass" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strNewPass != 0) {
        xmlAddChild(node, [self.strNewPass xmlNodeForDoc:node->doc elementName:@"strNewPass" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strUID != 0) {
        xmlAddChild(node, [self.strUID xmlNodeForDoc:node->doc elementName:@"strUID" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strStatus != 0) {
        xmlAddChild(node, [self.strStatus xmlNodeForDoc:node->doc elementName:@"strStatus" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize strAgentId;
@synthesize strAgentPass;
@synthesize strNewPass;
@synthesize strUID;
@synthesize strStatus;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_ReceiveFirstLogin *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_ReceiveFirstLogin *newObject = [[AgentWS_ReceiveFirstLogin new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strAgentId")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strAgentId = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strAgentPass")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strAgentPass = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strNewPass")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strNewPass = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strUID")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strUID = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strStatus")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strStatus = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_ReceiveFirstLoginResult
@synthesize xmlDetails;
- (id)init
{
    if((self = [super init])) {
    }
    
    return self;
}
- (void)dealloc
{
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
}
/* elements */
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_ReceiveFirstLoginResult *)deserializeNode:(xmlNodePtr)cur
{
    xmlBufferPtr buff = xmlBufferCreate();
    int result = xmlNodeDump(buff, NULL, cur, 0, 1);
    NSString *str = @"";
    
    if (result > -1) {
        str = [[NSString alloc] initWithBytes:(xmlBufferContent(buff))
                                       length:(NSUInteger)(xmlBufferLength(buff))
                                     encoding:NSUTF8StringEncoding];
    }
    xmlBufferFree(buff);
    
    AgentWS_ReceiveFirstLoginResult *newObject = [[AgentWS_ReceiveFirstLoginResult new] autorelease];
    newObject.xmlDetails = str;
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
}
@end
@implementation AgentWS_ReceiveFirstLoginResponse
- (id)init
{
    if((self = [super init])) {
        ReceiveFirstLoginResult = 0;
        strStatus = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(ReceiveFirstLoginResult != nil) [ReceiveFirstLoginResult release];
    if(strStatus != nil) [strStatus release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.ReceiveFirstLoginResult != 0) {
        xmlAddChild(node, [self.ReceiveFirstLoginResult xmlNodeForDoc:node->doc elementName:@"ReceiveFirstLoginResult" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strStatus != 0) {
        xmlAddChild(node, [self.strStatus xmlNodeForDoc:node->doc elementName:@"strStatus" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize ReceiveFirstLoginResult;
@synthesize strStatus;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_ReceiveFirstLoginResponse *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_ReceiveFirstLoginResponse *newObject = [[AgentWS_ReceiveFirstLoginResponse new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "ReceiveFirstLoginResult")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [AgentWS_ReceiveFirstLoginResult class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.ReceiveFirstLoginResult = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strStatus")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strStatus = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_ChangePassword
- (id)init
{
    if((self = [super init])) {
        strAgentId = 0;
        strPassword = 0;
        strNewPass = 0;
        strUDID = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(strAgentId != nil) [strAgentId release];
    if(strPassword != nil) [strPassword release];
    if(strNewPass != nil) [strNewPass release];
    if(strUDID != nil) [strUDID release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.strAgentId != 0) {
        xmlAddChild(node, [self.strAgentId xmlNodeForDoc:node->doc elementName:@"strAgentId" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strPassword != 0) {
        xmlAddChild(node, [self.strPassword xmlNodeForDoc:node->doc elementName:@"strPassword" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strNewPass != 0) {
        xmlAddChild(node, [self.strNewPass xmlNodeForDoc:node->doc elementName:@"strNewPass" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strUDID != 0) {
        xmlAddChild(node, [self.strUDID xmlNodeForDoc:node->doc elementName:@"strUDID" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize strAgentId;
@synthesize strPassword;
@synthesize strNewPass;
@synthesize strUDID;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_ChangePassword *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_ChangePassword *newObject = [[AgentWS_ChangePassword new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strAgentId")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strAgentId = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strPassword")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strPassword = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strNewPass")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strNewPass = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strUDID")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strUDID = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_ChangePasswordResponse
- (id)init
{
    if((self = [super init])) {
        ChangePasswordResult = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(ChangePasswordResult != nil) [ChangePasswordResult release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.ChangePasswordResult != 0) {
        xmlAddChild(node, [self.ChangePasswordResult xmlNodeForDoc:node->doc elementName:@"ChangePasswordResult" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize ChangePasswordResult;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_ChangePasswordResponse *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_ChangePasswordResponse *newObject = [[AgentWS_ChangePasswordResponse new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "ChangePasswordResult")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.ChangePasswordResult = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_FullSyncTable
- (id)init
{
    if((self = [super init])) {
        strAgentCode = 0;
        strStatus = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(strAgentCode != nil) [strAgentCode release];
    if(strStatus != nil) [strStatus release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.strAgentCode != 0) {
        xmlAddChild(node, [self.strAgentCode xmlNodeForDoc:node->doc elementName:@"strAgentCode" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strStatus != 0) {
        xmlAddChild(node, [self.strStatus xmlNodeForDoc:node->doc elementName:@"strStatus" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize strAgentCode;
@synthesize strStatus;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_FullSyncTable *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_FullSyncTable *newObject = [[AgentWS_FullSyncTable new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strAgentCode")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strAgentCode = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strStatus")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strStatus = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_FullSyncTableResult
@synthesize xmlDetails;
- (id)init
{
    if((self = [super init])) {
    }
    
    return self;
}
- (void)dealloc
{
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
}
/* elements */
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_FullSyncTableResult *)deserializeNode:(xmlNodePtr)cur
{
    xmlBufferPtr buff = xmlBufferCreate();
    int result = xmlNodeDump(buff, NULL, cur, 0, 1);
    NSString *str = @"";
    
    if (result > -1) {
        str = [[NSString alloc] initWithBytes:(xmlBufferContent(buff))
                                       length:(NSUInteger)(xmlBufferLength(buff))
                                     encoding:NSUTF8StringEncoding];
    }
    xmlBufferFree(buff);
    
    AgentWS_FullSyncTableResult *newObject = [[AgentWS_FullSyncTableResult new] autorelease];
    newObject.xmlDetails = str;
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
}

@end
@implementation AgentWS_FullSyncTableResponse
- (id)init
{
    if((self = [super init])) {
        FullSyncTableResult = 0;
        strStatus = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(FullSyncTableResult != nil) [FullSyncTableResult release];
    if(strStatus != nil) [strStatus release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.FullSyncTableResult != 0) {
        xmlAddChild(node, [self.FullSyncTableResult xmlNodeForDoc:node->doc elementName:@"FullSyncTableResult" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strStatus != 0) {
        xmlAddChild(node, [self.strStatus xmlNodeForDoc:node->doc elementName:@"strStatus" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize FullSyncTableResult;
@synthesize strStatus;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_FullSyncTableResponse *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_FullSyncTableResponse *newObject = [[AgentWS_FullSyncTableResponse new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "FullSyncTableResult")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [AgentWS_FullSyncTableResult class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.FullSyncTableResult = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strStatus")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strStatus = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_CheckVersion
- (id)init
{
    if((self = [super init])) {
        strVesion = 0;
        strStatus = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(strVesion != nil) [strVesion release];
    if(strStatus != nil) [strStatus release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.strVesion != 0) {
        xmlAddChild(node, [self.strVesion xmlNodeForDoc:node->doc elementName:@"strVesion" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strStatus != 0) {
        xmlAddChild(node, [self.strStatus xmlNodeForDoc:node->doc elementName:@"strStatus" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize strVesion;
@synthesize strStatus;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_CheckVersion *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_CheckVersion *newObject = [[AgentWS_CheckVersion new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strVesion")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strVesion = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strStatus")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strStatus = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_CheckVersionResult
@synthesize xmlDetails;
- (id)init
{
    if((self = [super init])) {
    }
    
    return self;
}
- (void)dealloc
{
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
}
/* elements */
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_CheckVersionResult *)deserializeNode:(xmlNodePtr)cur
{
    xmlBufferPtr buff = xmlBufferCreate();
    int result = xmlNodeDump(buff, NULL, cur, 0, 1);
    NSString *str = @"";
    
    if (result > -1) {
        str = [[NSString alloc] initWithBytes:(xmlBufferContent(buff))
                                       length:(NSUInteger)(xmlBufferLength(buff))
                                     encoding:NSUTF8StringEncoding];
    }
    xmlBufferFree(buff);
    
    AgentWS_CheckVersionResult *newObject = [[AgentWS_CheckVersionResult new] autorelease];
    newObject.xmlDetails = str;
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
}
@end
@implementation AgentWS_CheckVersionResponse
- (id)init
{
    if((self = [super init])) {
        CheckVersionResult = 0;
        strStatus = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(CheckVersionResult != nil) [CheckVersionResult release];
    if(strStatus != nil) [strStatus release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.CheckVersionResult != 0) {
        xmlAddChild(node, [self.CheckVersionResult xmlNodeForDoc:node->doc elementName:@"CheckVersionResult" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strStatus != 0) {
        xmlAddChild(node, [self.strStatus xmlNodeForDoc:node->doc elementName:@"strStatus" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize CheckVersionResult;
@synthesize strStatus;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_CheckVersionResponse *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_CheckVersionResponse *newObject = [[AgentWS_CheckVersionResponse new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "CheckVersionResult")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [AgentWS_CheckVersionResult class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.CheckVersionResult = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strStatus")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strStatus = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_PartialSync
- (id)init
{
    if((self = [super init])) {
        MasterInfo = 0;
        DataCabang = 0;
        eProposalCreditCardBank = 0;
        eProposalIdentification = 0;
        eProposalLADetails = 0;
        eProposalMaritalStatus = 0;
        eProposalNationality = 0;
        eProposalOCCP = 0;
        eProposalReferralSource = 0;
        eProposalRelation = 0;
        eProposalReligion = 0;
        eProposalSourceIncome = 0;
        eProposalTitle = 0;
        eProposalVIPClass = 0;
        DataReferral = 0;
        kodepos = 0;
        strStatus = 0;
    }
    
    return self;
    
    return self;
}
- (void)dealloc
{
    if(MasterInfo != nil) [MasterInfo release];
    if(DataCabang != nil) [DataCabang release];
    if(eProposalCreditCardBank != nil) [eProposalCreditCardBank release];
    if(eProposalIdentification != nil) [eProposalIdentification release];
    if(eProposalLADetails != nil) [eProposalLADetails release];
    if(eProposalMaritalStatus != nil) [eProposalMaritalStatus release];
    if(eProposalNationality != nil) [eProposalNationality release];
    if(eProposalOCCP != nil) [eProposalOCCP release];
    if(eProposalReferralSource != nil) [eProposalReferralSource release];
    if(eProposalRelation != nil) [eProposalRelation release];
    if(eProposalReligion != nil) [eProposalReligion release];
    if(eProposalSourceIncome != nil) [eProposalSourceIncome release];
    if(eProposalTitle != nil) [eProposalTitle release];
    if(eProposalVIPClass != nil) [eProposalVIPClass release];
    if(DataReferral != nil) [DataReferral release];
    if(kodepos != nil) [kodepos release];
    if(strStatus != nil) [strStatus release];
    
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.MasterInfo != 0) {
        xmlAddChild(node, [self.MasterInfo xmlNodeForDoc:node->doc elementName:@"MasterInfo" elementNSPrefix:@"AgentWS"]);
    }
    if(self.DataCabang != 0) {
        xmlAddChild(node, [self.DataCabang xmlNodeForDoc:node->doc elementName:@"DataCabang" elementNSPrefix:@"AgentWS"]);
    }
    if(self.eProposalCreditCardBank != 0) {
        xmlAddChild(node, [self.eProposalCreditCardBank xmlNodeForDoc:node->doc elementName:@"eProposalCreditCardBank" elementNSPrefix:@"AgentWS"]);
    }
    if(self.eProposalIdentification != 0) {
        xmlAddChild(node, [self.eProposalIdentification xmlNodeForDoc:node->doc elementName:@"eProposalIdentification" elementNSPrefix:@"AgentWS"]);
    }
    if(self.eProposalLADetails != 0) {
        xmlAddChild(node, [self.eProposalLADetails xmlNodeForDoc:node->doc elementName:@"eProposalLADetails" elementNSPrefix:@"AgentWS"]);
    }
    if(self.eProposalMaritalStatus != 0) {
        xmlAddChild(node, [self.eProposalMaritalStatus xmlNodeForDoc:node->doc elementName:@"eProposalMaritalStatus" elementNSPrefix:@"AgentWS"]);
    }
    if(self.eProposalNationality != 0) {
        xmlAddChild(node, [self.eProposalNationality xmlNodeForDoc:node->doc elementName:@"eProposalNationality" elementNSPrefix:@"AgentWS"]);
    }
    if(self.eProposalOCCP != 0) {
        xmlAddChild(node, [self.eProposalOCCP xmlNodeForDoc:node->doc elementName:@"eProposalOCCP" elementNSPrefix:@"AgentWS"]);
    }
    if(self.eProposalReferralSource != 0) {
        xmlAddChild(node, [self.eProposalReferralSource xmlNodeForDoc:node->doc elementName:@"eProposalReferralSource" elementNSPrefix:@"AgentWS"]);
    }
    if(self.eProposalRelation != 0) {
        xmlAddChild(node, [self.eProposalRelation xmlNodeForDoc:node->doc elementName:@"eProposalRelation" elementNSPrefix:@"AgentWS"]);
    }
    if(self.eProposalReligion != 0) {
        xmlAddChild(node, [self.eProposalReligion xmlNodeForDoc:node->doc elementName:@"eProposalReligion" elementNSPrefix:@"AgentWS"]);
    }
    if(self.eProposalSourceIncome != 0) {
        xmlAddChild(node, [self.eProposalSourceIncome xmlNodeForDoc:node->doc elementName:@"eProposalSourceIncome" elementNSPrefix:@"AgentWS"]);
    }
    if(self.eProposalTitle != 0) {
        xmlAddChild(node, [self.eProposalTitle xmlNodeForDoc:node->doc elementName:@"eProposalTitle" elementNSPrefix:@"AgentWS"]);
    }
    if(self.eProposalVIPClass != 0) {
        xmlAddChild(node, [self.eProposalVIPClass xmlNodeForDoc:node->doc elementName:@"eProposalVIPClass" elementNSPrefix:@"AgentWS"]);
    }
    if(self.DataReferral != 0) {
        xmlAddChild(node, [self.DataReferral xmlNodeForDoc:node->doc elementName:@"DataReferral" elementNSPrefix:@"AgentWS"]);
    }
    if(self.kodepos != 0) {
        xmlAddChild(node, [self.kodepos xmlNodeForDoc:node->doc elementName:@"kodepos" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strStatus != 0) {
        xmlAddChild(node, [self.strStatus xmlNodeForDoc:node->doc elementName:@"strStatus" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize MasterInfo;
@synthesize DataCabang;
@synthesize eProposalCreditCardBank;
@synthesize eProposalIdentification;
@synthesize eProposalLADetails;
@synthesize eProposalMaritalStatus;
@synthesize eProposalNationality;
@synthesize eProposalOCCP;
@synthesize eProposalReferralSource;
@synthesize eProposalRelation;
@synthesize eProposalReligion;
@synthesize eProposalSourceIncome;
@synthesize eProposalTitle;
@synthesize eProposalVIPClass;
@synthesize DataReferral;
@synthesize kodepos;
@synthesize strStatus;
/* attributes */

- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_PartialSync *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_PartialSync *newObject = [[AgentWS_PartialSync new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "MasterInfo")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.MasterInfo = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "DataCabang")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.DataCabang = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "eProposalCreditCardBank")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.eProposalCreditCardBank = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "eProposalIdentification")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.eProposalIdentification = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "eProposalLADetails")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.eProposalLADetails = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "eProposalMaritalStatus")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.eProposalMaritalStatus = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "eProposalNationality")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.eProposalNationality = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "eProposalOCCP")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.eProposalOCCP = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "eProposalReferralSource")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.eProposalReferralSource = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "eProposalRelation")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.eProposalRelation = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "eProposalReligion")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.eProposalReligion = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "eProposalSourceIncome")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.eProposalSourceIncome = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "eProposalTitle")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.eProposalTitle = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "eProposalVIPClass")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.eProposalVIPClass = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "DataReferral")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.DataReferral = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "kodepos")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.kodepos = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strStatus")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strStatus = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_PartialSyncResult
@synthesize xmlDetails;
- (id)init
{
    if((self = [super init])) {
    }
    
    return self;
}
- (void)dealloc
{
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
}
/* elements */
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_PartialSyncResult *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_PartialSyncResult *newObject = [[AgentWS_PartialSyncResult new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
}
@end
@implementation AgentWS_PartialSyncResponse
- (id)init
{
    if((self = [super init])) {
        PartialSyncResult = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(PartialSyncResult != nil) [PartialSyncResult release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.PartialSyncResult != 0) {
        xmlAddChild(node, [self.PartialSyncResult xmlNodeForDoc:node->doc elementName:@"PartialSyncResult" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize PartialSyncResult;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_PartialSyncResponse *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_PartialSyncResponse *newObject = [[AgentWS_PartialSyncResponse new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "PartialSyncResult")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [AgentWS_PartialSyncResult class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.PartialSyncResult = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_LoginAPI
- (id)init
{
    if((self = [super init])) {
        strAgentCode = 0;
        strPass = 0;
        strStatus = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(strAgentCode != nil) [strAgentCode release];
    if(strPass != nil) [strPass release];
    if(strStatus != nil) [strStatus release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.strAgentCode != 0) {
        xmlAddChild(node, [self.strAgentCode xmlNodeForDoc:node->doc elementName:@"strAgentCode" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strPass != 0) {
        xmlAddChild(node, [self.strPass xmlNodeForDoc:node->doc elementName:@"strPass" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strStatus != 0) {
        xmlAddChild(node, [self.strStatus xmlNodeForDoc:node->doc elementName:@"strStatus" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize strAgentCode;
@synthesize strPass;
@synthesize strStatus;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_LoginAPI *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_LoginAPI *newObject = [[AgentWS_LoginAPI new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strAgentCode")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strAgentCode = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strPass")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strPass = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strStatus")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strStatus = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_LoginAPIResponse
- (id)init
{
    if((self = [super init])) {
        LoginAPIResult = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(LoginAPIResult != nil) [LoginAPIResult release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.LoginAPIResult != 0) {
        xmlAddChild(node, [self.LoginAPIResult xmlNodeForDoc:node->doc elementName:@"LoginAPIResult" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize LoginAPIResult;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_LoginAPIResponse *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_LoginAPIResponse *newObject = [[AgentWS_LoginAPIResponse new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "LoginAPIResult")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.LoginAPIResult = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_VersionChecker
- (id)init
{
    if((self = [super init])) {
        strVersion = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(strVersion != nil) [strVersion release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.strVersion != 0) {
        xmlAddChild(node, [self.strVersion xmlNodeForDoc:node->doc elementName:@"strVersion" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize strVersion;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_VersionChecker *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_VersionChecker *newObject = [[AgentWS_VersionChecker new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strVersion")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strVersion = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_VersionCheckerResponse
- (id)init
{
    if((self = [super init])) {
        VersionCheckerResult = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(VersionCheckerResult != nil) [VersionCheckerResult release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.VersionCheckerResult != 0) {
        xmlAddChild(node, [self.VersionCheckerResult xmlNodeForDoc:node->doc elementName:@"VersionCheckerResult" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize VersionCheckerResult;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_VersionCheckerResponse *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_VersionCheckerResponse *newObject = [[AgentWS_VersionCheckerResponse new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "VersionCheckerResult")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.VersionCheckerResult = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_SupervisorLogin
- (id)init
{
    if((self = [super init])) {
        strAgentcode = 0;
        strSupervisorname = 0;
        strSupervisorPass = 0;
        strStatus = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(strAgentcode != nil) [strAgentcode release];
    if(strSupervisorname != nil) [strSupervisorname release];
    if(strSupervisorPass != nil) [strSupervisorPass release];
    if(strStatus != nil) [strStatus release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.strAgentcode != 0) {
        xmlAddChild(node, [self.strAgentcode xmlNodeForDoc:node->doc elementName:@"strAgentcode" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strSupervisorname != 0) {
        xmlAddChild(node, [self.strSupervisorname xmlNodeForDoc:node->doc elementName:@"strSupervisorname" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strSupervisorPass != 0) {
        xmlAddChild(node, [self.strSupervisorPass xmlNodeForDoc:node->doc elementName:@"strSupervisorPass" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strStatus != 0) {
        xmlAddChild(node, [self.strStatus xmlNodeForDoc:node->doc elementName:@"strStatus" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize strAgentcode;
@synthesize strSupervisorname;
@synthesize strSupervisorPass;
@synthesize strStatus;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_SupervisorLogin *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_SupervisorLogin *newObject = [[AgentWS_SupervisorLogin new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strAgentcode")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strAgentcode = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strSupervisorname")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strSupervisorname = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strSupervisorPass")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strSupervisorPass = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strStatus")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strStatus = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_SupervisorLoginResult
@synthesize xmlDetails;
- (id)init
{
    if((self = [super init])) {
    }
    
    return self;
}
- (void)dealloc
{
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
}
/* elements */
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_SupervisorLoginResult *)deserializeNode:(xmlNodePtr)cur
{
    xmlBufferPtr buff = xmlBufferCreate();
    int result = xmlNodeDump(buff, NULL, cur, 0, 1);
    NSString *str = @"";
    
    if (result > -1) {
        str = [[NSString alloc] initWithBytes:(xmlBufferContent(buff))
                                       length:(NSUInteger)(xmlBufferLength(buff))
                                     encoding:NSUTF8StringEncoding];
    }
    xmlBufferFree(buff);
    
    AgentWS_SupervisorLoginResult *newObject = [[AgentWS_SupervisorLoginResult new] autorelease];
    newObject.xmlDetails = str;
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
}
@end
@implementation AgentWS_SupervisorLoginResponse
- (id)init
{
    if((self = [super init])) {
        SupervisorLoginResult = 0;
        strStatus = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(SupervisorLoginResult != nil) [SupervisorLoginResult release];
    if(strStatus != nil) [strStatus release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.SupervisorLoginResult != 0) {
        xmlAddChild(node, [self.SupervisorLoginResult xmlNodeForDoc:node->doc elementName:@"SupervisorLoginResult" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strStatus != 0) {
        xmlAddChild(node, [self.strStatus xmlNodeForDoc:node->doc elementName:@"strStatus" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize SupervisorLoginResult;
@synthesize strStatus;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_SupervisorLoginResponse *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_SupervisorLoginResponse *newObject = [[AgentWS_SupervisorLoginResponse new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "SupervisorLoginResult")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [AgentWS_SupervisorLoginResult class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.SupervisorLoginResult = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strStatus")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strStatus = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_AdminLogin
- (id)init
{
    if((self = [super init])) {
        stradmin = 0;
        stradminpass = 0;
        strStatus = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(stradmin != nil) [stradmin release];
    if(stradminpass != nil) [stradminpass release];
    if(strStatus != nil) [strStatus release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.stradmin != 0) {
        xmlAddChild(node, [self.stradmin xmlNodeForDoc:node->doc elementName:@"stradmin" elementNSPrefix:@"AgentWS"]);
    }
    if(self.stradminpass != 0) {
        xmlAddChild(node, [self.stradminpass xmlNodeForDoc:node->doc elementName:@"stradminpass" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strStatus != 0) {
        xmlAddChild(node, [self.strStatus xmlNodeForDoc:node->doc elementName:@"strStatus" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize stradmin;
@synthesize stradminpass;
@synthesize strStatus;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_AdminLogin *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_AdminLogin *newObject = [[AgentWS_AdminLogin new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "stradmin")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.stradmin = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "stradminpass")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.stradminpass = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strStatus")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strStatus = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_AdminLoginResponse
- (id)init
{
    if((self = [super init])) {
        AdminLoginResult = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(AdminLoginResult != nil) [AdminLoginResult release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.AdminLoginResult != 0) {
        xmlAddChild(node, [self.AdminLoginResult xmlNodeForDoc:node->doc elementName:@"AdminLoginResult" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize AdminLoginResult;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_AdminLoginResponse *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_AdminLoginResponse *newObject = [[AgentWS_AdminLoginResponse new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "AdminLoginResult")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.AdminLoginResult = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_DataSet
@synthesize xmlDetails;
- (id)init
{
    if((self = [super init])) {
    }
    
    return self;
}
- (void)dealloc
{
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
}
/* elements */
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_DataSet *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_DataSet *newObject = [[AgentWS_DataSet new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
}
@end

@implementation AgentWS_ChangeUDID
- (id)init
{
    if((self = [super init])) {
        strAgentcode = 0;
        strUDID = 0;
        strStatus = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(strAgentcode != nil) [strAgentcode release];
    if(strUDID != nil) [strUDID release];
    if(strStatus != nil) [strStatus release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.strAgentcode != 0) {
        xmlAddChild(node, [self.strAgentcode xmlNodeForDoc:node->doc elementName:@"strAgentcode" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strUDID != 0) {
        xmlAddChild(node, [self.strUDID xmlNodeForDoc:node->doc elementName:@"strUDID" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strStatus != 0) {
        xmlAddChild(node, [self.strStatus xmlNodeForDoc:node->doc elementName:@"strStatus" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize strAgentcode;
@synthesize strUDID;
@synthesize strStatus;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_ChangeUDID *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_ChangeUDID *newObject = [[AgentWS_ChangeUDID new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strAgentcode")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strAgentcode = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strUDID")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strUDID = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strStatus")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strStatus = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_ChangeUDIDResponse
- (id)init
{
    if((self = [super init])) {
        ChangeUDIDResult = 0;
        strStatus = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(ChangeUDIDResult != nil) [ChangeUDIDResult release];
    if(strStatus != nil) [strStatus release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.ChangeUDIDResult != 0) {
        xmlAddChild(node, [self.ChangeUDIDResult xmlNodeForDoc:node->doc elementName:@"ChangeUDIDResult" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strStatus != 0) {
        xmlAddChild(node, [self.strStatus xmlNodeForDoc:node->doc elementName:@"strStatus" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize ChangeUDIDResult;
@synthesize strStatus;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_ChangeUDIDResponse *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_ChangeUDIDResponse *newObject = [[AgentWS_ChangeUDIDResponse new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "ChangeUDIDResult")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.ChangeUDIDResult = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strStatus")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strStatus = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_Syncdatareferral
- (id)init
{
    if((self = [super init])) {
        strUpdateDate = 0;
        strstatus = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(strUpdateDate != nil) [strUpdateDate release];
    if(strstatus != nil) [strstatus release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.strUpdateDate != 0) {
        xmlAddChild(node, [self.strUpdateDate xmlNodeForDoc:node->doc elementName:@"strUpdateDate" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strstatus != 0) {
        xmlAddChild(node, [self.strstatus xmlNodeForDoc:node->doc elementName:@"strstatus" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize strUpdateDate;
@synthesize strstatus;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_Syncdatareferral *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_Syncdatareferral *newObject = [[AgentWS_Syncdatareferral new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strUpdateDate")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strUpdateDate = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strstatus")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strstatus = newChild;
            }
        }
    }
}
@end
@implementation AgentWS_SyncdatareferralResult
@synthesize xmlDetails;
- (id)init
{
    if((self = [super init])) {
    }
    
    return self;
}
- (void)dealloc
{
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
}
/* elements */
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_SyncdatareferralResult *)deserializeNode:(xmlNodePtr)cur
{
    xmlBufferPtr buff = xmlBufferCreate();
    int result = xmlNodeDump(buff, NULL, cur, 0, 1);
    NSString *str = @"";
    
    if (result > -1) {
        str = [[NSString alloc] initWithBytes:(xmlBufferContent(buff))
                                       length:(NSUInteger)(xmlBufferLength(buff))
                                     encoding:NSUTF8StringEncoding];
    }
    xmlBufferFree(buff);
    
    AgentWS_SyncdatareferralResult *newObject = [[AgentWS_SyncdatareferralResult new] autorelease];
    newObject.xmlDetails = str;
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
}
@end
@implementation AgentWS_SyncdatareferralResponse
- (id)init
{
    if((self = [super init])) {
        SyncdatareferralResult = 0;
        strstatus = 0;
    }
    
    return self;
}
- (void)dealloc
{
    if(SyncdatareferralResult != nil) [SyncdatareferralResult release];
    if(strstatus != nil) [strstatus release];
    
    [super dealloc];
}
- (NSString *)nsPrefix
{
    return @"AgentWS";
}
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix
{
    NSString *nodeName = nil;
    if(elNSPrefix != nil && [elNSPrefix length] > 0)
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", elNSPrefix, elName];
    }
    else
    {
        nodeName = [NSString stringWithFormat:@"%@:%@", @"AgentWS", elName];
    }
    
    xmlNodePtr node = xmlNewDocNode(doc, NULL, [nodeName xmlString], NULL);
    
    
    [self addAttributesToNode:node];
    
    [self addElementsToNode:node];
    
    return node;
}
- (void)addAttributesToNode:(xmlNodePtr)node
{
    
}
- (void)addElementsToNode:(xmlNodePtr)node
{
    
    if(self.SyncdatareferralResult != 0) {
        xmlAddChild(node, [self.SyncdatareferralResult xmlNodeForDoc:node->doc elementName:@"SyncdatareferralResult" elementNSPrefix:@"AgentWS"]);
    }
    if(self.strstatus != 0) {
        xmlAddChild(node, [self.strstatus xmlNodeForDoc:node->doc elementName:@"strstatus" elementNSPrefix:@"AgentWS"]);
    }
}
/* elements */
@synthesize SyncdatareferralResult;
@synthesize strstatus;
/* attributes */
- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    return attributes;
}
+ (AgentWS_SyncdatareferralResponse *)deserializeNode:(xmlNodePtr)cur
{
    AgentWS_SyncdatareferralResponse *newObject = [[AgentWS_SyncdatareferralResponse new] autorelease];
    
    [newObject deserializeAttributesFromNode:cur];
    [newObject deserializeElementsFromNode:cur];
    
    return newObject;
}
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur
{
}
- (void)deserializeElementsFromNode:(xmlNodePtr)cur
{
    
    
    for( cur = cur->children ; cur != NULL ; cur = cur->next ) {
        if(cur->type == XML_ELEMENT_NODE) {
            xmlChar *elementText = xmlNodeListGetString(cur->doc, cur->children, 1);
            NSString *elementString = nil;
            
            if(elementText != NULL) {
                elementString = [NSString stringWithCString:(char*)elementText encoding:NSUTF8StringEncoding];
                [elementString self]; // avoid compiler warning for unused var
                xmlFree(elementText);
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "SyncdatareferralResult")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [AgentWS_SyncdatareferralResult class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.SyncdatareferralResult = newChild;
            }
            if(xmlStrEqual(cur->name, (const xmlChar *) "strstatus")) {
                
                Class elementClass = nil;
                xmlChar *instanceType = xmlGetNsProp(cur, (const xmlChar *) "type", (const xmlChar *) "http://www.w3.org/2001/XMLSchema-instance");
                if(instanceType == NULL) {
                    elementClass = [NSString  class];
                } else {
                    NSString *elementTypeString = [NSString stringWithCString:(char*)instanceType encoding:NSUTF8StringEncoding];
                    
                    NSArray *elementTypeArray = [elementTypeString componentsSeparatedByString:@":"];
                    
                    NSString *elementClassString = nil;
                    if([elementTypeArray count] > 1) {
                        NSString *prefix = [elementTypeArray objectAtIndex:0];
                        NSString *localName = [elementTypeArray objectAtIndex:1];
                        
                        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
                        
                        NSString *standardPrefix = [[USGlobals sharedInstance].wsdlStandardNamespaces objectForKey:[NSString stringWithCString:(char*)elementNamespace->href encoding:NSUTF8StringEncoding]];
                        
                        elementClassString = [NSString stringWithFormat:@"%@_%@", standardPrefix, localName];
                    } else {
                        elementClassString = [elementTypeString stringByReplacingOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [elementTypeString length])];
                    }
                    
                    elementClass = NSClassFromString(elementClassString);
                    xmlFree(instanceType);
                }
                
                id newChild = [elementClass deserializeNode:cur];
                
                self.strstatus = newChild;
            }
        }
    }
}
@end

@implementation AgentWS
+ (void)initialize
{
    [[USGlobals sharedInstance].wsdlStandardNamespaces setObject:@"xsd" forKey:@"http://www.w3.org/2001/XMLSchema"];
    [[USGlobals sharedInstance].wsdlStandardNamespaces setObject:@"AgentWS" forKey:@"http://tempuri.org/"];
}
+ (AgentWSSoapBinding *)AgentWSSoapBinding
{
    NSString *serverURL = [NSString stringWithFormat:@"%@/webservices/AgentWS.asmx", [(AppDelegate*)[[UIApplication sharedApplication] delegate] serverURL]];
    return [[[AgentWSSoapBinding alloc] initWithAddress:serverURL] autorelease];
}
+ (AgentWSSoap12Binding *)AgentWSSoap12Binding
{
    NSString *serverURL = [NSString stringWithFormat:@"%@/webservices/AgentWS.asmx", [(AppDelegate*)[[UIApplication sharedApplication] delegate] serverURL]];
    return [[[AgentWSSoap12Binding alloc] initWithAddress:serverURL] autorelease];
}
@end
@implementation AgentWSSoapBinding
@synthesize address;
@synthesize defaultTimeout;
@synthesize logXMLInOut;
@synthesize cookies;
@synthesize authUsername;
@synthesize authPassword;
- (id)init
{
    if((self = [super init])) {
        address = nil;
        cookies = nil;
        defaultTimeout = 10;//seconds
        logXMLInOut = NO;
        synchronousOperationComplete = NO;
    }
    
    return self;
}
- (id)initWithAddress:(NSString *)anAddress
{
    if((self = [self init])) {
        self.address = [NSURL URLWithString:anAddress];
    }
    
    return self;
}
- (void)addCookie:(NSHTTPCookie *)toAdd
{
    if(toAdd != nil) {
        if(cookies == nil) cookies = [[NSMutableArray alloc] init];
        [cookies addObject:toAdd];
    }
}
- (AgentWSSoapBindingResponse *)performSynchronousOperation:(AgentWSSoapBindingOperation *)operation
{
    synchronousOperationComplete = NO;
    [operation start];
    
    // Now wait for response
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    
    while (!synchronousOperationComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    return operation.response;
}
- (void)performAsynchronousOperation:(AgentWSSoapBindingOperation *)operation
{
    [operation start];
}
- (void) operation:(AgentWSSoapBindingOperation *)operation completedWithResponse:(AgentWSSoapBindingResponse *)response
{
    synchronousOperationComplete = YES;
}
- (AgentWSSoapBindingResponse *)ValidateAgentAndDeviceUsingParameters:(AgentWS_ValidateAgentAndDevice *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoapBinding_ValidateAgentAndDevice*)[AgentWSSoapBinding_ValidateAgentAndDevice alloc] initWithBinding:self delegate:self
                                                                                                                                                  parameters:aParameters
                                               ] autorelease]];
}
- (void)ValidateAgentAndDeviceAsyncUsingParameters:(AgentWS_ValidateAgentAndDevice *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoapBinding_ValidateAgentAndDevice*)[AgentWSSoapBinding_ValidateAgentAndDevice alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                                             parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoapBindingResponse *)ValidateLoginUsingParameters:(AgentWS_ValidateLogin *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoapBinding_ValidateLogin*)[AgentWSSoapBinding_ValidateLogin alloc] initWithBinding:self delegate:self
                                                                                                                                parameters:aParameters
                                               ] autorelease]];
}
- (void)ValidateLoginAsyncUsingParameters:(AgentWS_ValidateLogin *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoapBinding_ValidateLogin*)[AgentWSSoapBinding_ValidateLogin alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                           parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoapBindingResponse *)SaveDocumentUsingParameters:(AgentWS_SaveDocument *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoapBinding_SaveDocument*)[AgentWSSoapBinding_SaveDocument alloc] initWithBinding:self delegate:self
                                                                                                                              parameters:aParameters
                                               ] autorelease]];
}
- (void)SaveDocumentAsyncUsingParameters:(AgentWS_SaveDocument *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoapBinding_SaveDocument*)[AgentWSSoapBinding_SaveDocument alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                         parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoapBindingResponse *)RetrievePolicyNumberUsingParameters:(AgentWS_RetrievePolicyNumber *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoapBinding_RetrievePolicyNumber*)[AgentWSSoapBinding_RetrievePolicyNumber alloc] initWithBinding:self delegate:self
                                                                                                                                              parameters:aParameters
                                               ] autorelease]];
}
- (void)RetrievePolicyNumberAsyncUsingParameters:(AgentWS_RetrievePolicyNumber *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoapBinding_RetrievePolicyNumber*)[AgentWSSoapBinding_RetrievePolicyNumber alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                                         parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoapBindingResponse *)SendForgotPasswordUsingParameters:(AgentWS_SendForgotPassword *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoapBinding_SendForgotPassword*)[AgentWSSoapBinding_SendForgotPassword alloc] initWithBinding:self delegate:self
                                                                                                                                          parameters:aParameters
                                               ] autorelease]];
}
- (void)SendForgotPasswordAsyncUsingParameters:(AgentWS_SendForgotPassword *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoapBinding_SendForgotPassword*)[AgentWSSoapBinding_SendForgotPassword alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                                     parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoapBindingResponse *)ReceiveFirstLoginUsingParameters:(AgentWS_ReceiveFirstLogin *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoapBinding_ReceiveFirstLogin*)[AgentWSSoapBinding_ReceiveFirstLogin alloc] initWithBinding:self delegate:self
                                                                                                                                        parameters:aParameters
                                               ] autorelease]];
}
- (void)ReceiveFirstLoginAsyncUsingParameters:(AgentWS_ReceiveFirstLogin *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoapBinding_ReceiveFirstLogin*)[AgentWSSoapBinding_ReceiveFirstLogin alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                                   parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoapBindingResponse *)ChangePasswordUsingParameters:(AgentWS_ChangePassword *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoapBinding_ChangePassword*)[AgentWSSoapBinding_ChangePassword alloc] initWithBinding:self delegate:self
                                                                                                                                  parameters:aParameters
                                               ] autorelease]];
}
- (void)ChangePasswordAsyncUsingParameters:(AgentWS_ChangePassword *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoapBinding_ChangePassword*)[AgentWSSoapBinding_ChangePassword alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                             parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoapBindingResponse *)FullSyncTableUsingParameters:(AgentWS_FullSyncTable *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoapBinding_FullSyncTable*)[AgentWSSoapBinding_FullSyncTable alloc] initWithBinding:self delegate:self
                                                                                                                                parameters:aParameters
                                               ] autorelease]];
}
- (void)FullSyncTableAsyncUsingParameters:(AgentWS_FullSyncTable *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoapBinding_FullSyncTable*)[AgentWSSoapBinding_FullSyncTable alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                           parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoapBindingResponse *)CheckVersionUsingParameters:(AgentWS_CheckVersion *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoapBinding_CheckVersion*)[AgentWSSoapBinding_CheckVersion alloc] initWithBinding:self delegate:self
                                                                                                                              parameters:aParameters
                                               ] autorelease]];
}
- (void)CheckVersionAsyncUsingParameters:(AgentWS_CheckVersion *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoapBinding_CheckVersion*)[AgentWSSoapBinding_CheckVersion alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                         parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoapBindingResponse *)PartialSyncUsingParameters:(AgentWS_PartialSync *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoapBinding_PartialSync*)[AgentWSSoapBinding_PartialSync alloc] initWithBinding:self delegate:self
                                                                                                                            parameters:aParameters
                                               ] autorelease]];
}
- (void)PartialSyncAsyncUsingParameters:(AgentWS_PartialSync *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoapBinding_PartialSync*)[AgentWSSoapBinding_PartialSync alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                       parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoapBindingResponse *)LoginAPIUsingParameters:(AgentWS_LoginAPI *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoapBinding_LoginAPI*)[AgentWSSoapBinding_LoginAPI alloc] initWithBinding:self delegate:self
                                                                                                                      parameters:aParameters
                                               ] autorelease]];
}
- (void)LoginAPIAsyncUsingParameters:(AgentWS_LoginAPI *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoapBinding_LoginAPI*)[AgentWSSoapBinding_LoginAPI alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                 parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoapBindingResponse *)VersionCheckerUsingParameters:(AgentWS_VersionChecker *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoapBinding_VersionChecker*)[AgentWSSoapBinding_VersionChecker alloc] initWithBinding:self delegate:self
                                                                                                                                  parameters:aParameters
                                               ] autorelease]];
}
- (void)VersionCheckerAsyncUsingParameters:(AgentWS_VersionChecker *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoapBinding_VersionChecker*)[AgentWSSoapBinding_VersionChecker alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                             parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoapBindingResponse *)SupervisorLoginUsingParameters:(AgentWS_SupervisorLogin *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoapBinding_SupervisorLogin*)[AgentWSSoapBinding_SupervisorLogin alloc] initWithBinding:self delegate:self
                                                                                                                                    parameters:aParameters
                                               ] autorelease]];
}
- (void)SupervisorLoginAsyncUsingParameters:(AgentWS_SupervisorLogin *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoapBinding_SupervisorLogin*)[AgentWSSoapBinding_SupervisorLogin alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                               parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoapBindingResponse *)AdminLoginUsingParameters:(AgentWS_AdminLogin *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoapBinding_AdminLogin*)[AgentWSSoapBinding_AdminLogin alloc] initWithBinding:self delegate:self
                                                                                                                          parameters:aParameters
                                               ] autorelease]];
}
- (void)AdminLoginAsyncUsingParameters:(AgentWS_AdminLogin *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoapBinding_AdminLogin*)[AgentWSSoapBinding_AdminLogin alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                     parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoapBindingResponse *)ChangeUDIDUsingParameters:(AgentWS_ChangeUDID *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoapBinding_ChangeUDID*)[AgentWSSoapBinding_ChangeUDID alloc] initWithBinding:self delegate:self
                                                                                                                          parameters:aParameters
                                               ] autorelease]];
}
- (void)ChangeUDIDAsyncUsingParameters:(AgentWS_ChangeUDID *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoapBinding_ChangeUDID*)[AgentWSSoapBinding_ChangeUDID alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                     parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoapBindingResponse *)SyncdatareferralUsingParameters:(AgentWS_Syncdatareferral *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoapBinding_Syncdatareferral*)[AgentWSSoapBinding_Syncdatareferral alloc] initWithBinding:self delegate:self
                                                                                                                                      parameters:aParameters
                                               ] autorelease]];
}
- (void)SyncdatareferralAsyncUsingParameters:(AgentWS_Syncdatareferral *)aParameters  delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoapBinding_Syncdatareferral*)[AgentWSSoapBinding_Syncdatareferral alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                                 parameters:aParameters
                                          ] autorelease]];
}
- (void)sendHTTPCallUsingBody:(NSString *)outputBody soapAction:(NSString *)soapAction forOperation:(AgentWSSoapBindingOperation *)operation
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.address
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:self.defaultTimeout];
    NSData *bodyData = [outputBody dataUsingEncoding:NSUTF8StringEncoding];
    
    if(cookies != nil) {
        [request setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:cookies]];
    }
    [request setValue:@"wsdl2objc" forHTTPHeaderField:@"User-Agent"];
    [request setValue:soapAction forHTTPHeaderField:@"SOAPAction"];
    [request setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%u", [bodyData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:self.address.host forHTTPHeaderField:@"Host"];
    [request setHTTPMethod: @"POST"];
    // set version 1.1 - how?
    [request setHTTPBody: bodyData];
    
    if(self.logXMLInOut) {
        NSLog(@"OutputHeaders:\n%@", [request allHTTPHeaderFields]);
        NSLog(@"OutputBody:\n%@", outputBody);
    }
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:operation];
    
    operation.urlConnection = connection;
    [connection release];
}
- (void) dealloc
{
    [address release];
    [cookies release];
    [super dealloc];
}
@end
@implementation AgentWSSoapBindingOperation
@synthesize binding;
@synthesize response;
@synthesize delegate;
@synthesize responseData;
@synthesize urlConnection;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)aDelegate
{
    if ((self = [super init])) {
        self.binding = aBinding;
        response = nil;
        self.delegate = aDelegate;
        self.responseData = nil;
        self.urlConnection = nil;
    }
    
    return self;
}
-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] == 0) {
        NSURLCredential *newCredential;
        newCredential=[NSURLCredential credentialWithUser:self.binding.authUsername
                                                 password:self.binding.authPassword
                                              persistence:NSURLCredentialPersistenceForSession];
        [[challenge sender] useCredential:newCredential
               forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Authentication Error" forKey:NSLocalizedDescriptionKey];
        NSError *authError = [NSError errorWithDomain:@"Connection Authentication" code:0 userInfo:userInfo];
        [self connection:connection didFailWithError:authError];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)urlResponse
{
    NSHTTPURLResponse *httpResponse;
    if ([urlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
        httpResponse = (NSHTTPURLResponse *) urlResponse;
    } else {
        httpResponse = nil;
    }
    
    if(binding.logXMLInOut) {
        NSLog(@"ResponseStatus: %u\n", [httpResponse statusCode]);
        NSLog(@"ResponseHeaders:\n%@", [httpResponse allHeaderFields]);
    }
    
    NSMutableArray *cookies = [[NSHTTPCookie cookiesWithResponseHeaderFields:[httpResponse allHeaderFields] forURL:binding.address] mutableCopy];
    
    binding.cookies = cookies;
    [cookies release];
    if ([urlResponse.MIMEType rangeOfString:@"application/soap+xml"].length == 0) {
        NSError *error = nil;
        [connection cancel];
        if ([httpResponse statusCode] >= 400) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]] forKey:NSLocalizedDescriptionKey];
            
            error = [NSError errorWithDomain:@"AgentWSSoapBindingResponseHTTP" code:[httpResponse statusCode] userInfo:userInfo];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:
                                      [NSString stringWithFormat: @"Unexpected response MIME type to SOAP call:%@", urlResponse.MIMEType]
                                                                 forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"AgentWSSoapBindingResponseHTTP" code:1 userInfo:userInfo];
        }
        
        [self connection:connection didFailWithError:error];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (responseData == nil) {
        responseData = [data mutableCopy];
    } else {
        [responseData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (binding.logXMLInOut) {
        NSLog(@"ResponseError:\n%@", error);
    }
    response.error = error;
    [delegate operation:self completedWithResponse:response];
}
- (void)dealloc
{
    [binding release];
    [response release];
    delegate = nil;
    [responseData release];
    [urlConnection release];
    
    [super dealloc];
}
@end
@implementation AgentWSSoapBinding_ValidateAgentAndDevice
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_ValidateAgentAndDevice *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoapBindingResponse new];
    
    AgentWSSoapBinding_envelope *envelope = [AgentWSSoapBinding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"ValidateAgentAndDevice"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/ValidateAgentAndDevice" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoapBindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "ValidateAgentAndDeviceResponse")) {
                                    AgentWS_ValidateAgentAndDeviceResponse *bodyObject = [AgentWS_ValidateAgentAndDeviceResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) &&
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoapBinding_ValidateLogin
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_ValidateLogin *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoapBindingResponse new];
    
    AgentWSSoapBinding_envelope *envelope = [AgentWSSoapBinding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"ValidateLogin"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/ValidateLogin" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoapBindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "ValidateLoginResponse")) {
                                    AgentWS_ValidateLoginResponse *bodyObject = [AgentWS_ValidateLoginResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) &&
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoapBinding_SaveDocument
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_SaveDocument *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoapBindingResponse new];
    
    AgentWSSoapBinding_envelope *envelope = [AgentWSSoapBinding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"SaveDocument"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/SaveDocument" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoapBindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "SaveDocumentResponse")) {
                                    AgentWS_SaveDocumentResponse *bodyObject = [AgentWS_SaveDocumentResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) &&
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoapBinding_RetrievePolicyNumber
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_RetrievePolicyNumber *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoapBindingResponse new];
    
    AgentWSSoapBinding_envelope *envelope = [AgentWSSoapBinding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"RetrievePolicyNumber"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/RetrievePolicyNumber" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoapBindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "RetrievePolicyNumberResponse")) {
                                    AgentWS_RetrievePolicyNumberResponse *bodyObject = [AgentWS_RetrievePolicyNumberResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) &&
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoapBinding_SendForgotPassword
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_SendForgotPassword *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoapBindingResponse new];
    
    AgentWSSoapBinding_envelope *envelope = [AgentWSSoapBinding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"SendForgotPassword"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/SendForgotPassword" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoapBindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "SendForgotPasswordResponse")) {
                                    AgentWS_SendForgotPasswordResponse *bodyObject = [AgentWS_SendForgotPasswordResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) &&
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoapBinding_ReceiveFirstLogin
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_ReceiveFirstLogin *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoapBindingResponse new];
    
    AgentWSSoapBinding_envelope *envelope = [AgentWSSoapBinding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"ReceiveFirstLogin"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/ReceiveFirstLogin" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoapBindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "ReceiveFirstLoginResponse")) {
                                    AgentWS_ReceiveFirstLoginResponse *bodyObject = [AgentWS_ReceiveFirstLoginResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) &&
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoapBinding_ChangePassword
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_ChangePassword *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoapBindingResponse new];
    
    AgentWSSoapBinding_envelope *envelope = [AgentWSSoapBinding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"ChangePassword"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/ChangePassword" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoapBindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "ChangePasswordResponse")) {
                                    AgentWS_ChangePasswordResponse *bodyObject = [AgentWS_ChangePasswordResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) &&
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoapBinding_FullSyncTable
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_FullSyncTable *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoapBindingResponse new];
    
    AgentWSSoapBinding_envelope *envelope = [AgentWSSoapBinding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"FullSyncTable"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/FullSyncTable" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoapBindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "FullSyncTableResponse")) {
                                    AgentWS_FullSyncTableResponse *bodyObject = [AgentWS_FullSyncTableResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) &&
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoapBinding_CheckVersion
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_CheckVersion *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoapBindingResponse new];
    
    AgentWSSoapBinding_envelope *envelope = [AgentWSSoapBinding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"CheckVersion"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/CheckVersion" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoapBindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "CheckVersionResponse")) {
                                    AgentWS_CheckVersionResponse *bodyObject = [AgentWS_CheckVersionResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) &&
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoapBinding_PartialSync
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_PartialSync *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoapBindingResponse new];
    
    AgentWSSoapBinding_envelope *envelope = [AgentWSSoapBinding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"PartialSync"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/PartialSync" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoapBindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "PartialSyncResponse")) {
                                    AgentWS_PartialSyncResponse *bodyObject = [AgentWS_PartialSyncResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) &&
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoapBinding_LoginAPI
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_LoginAPI *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoapBindingResponse new];
    
    AgentWSSoapBinding_envelope *envelope = [AgentWSSoapBinding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"LoginAPI"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/LoginAPI" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoapBindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "LoginAPIResponse")) {
                                    AgentWS_LoginAPIResponse *bodyObject = [AgentWS_LoginAPIResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) &&
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoapBinding_VersionChecker
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_VersionChecker *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoapBindingResponse new];
    
    AgentWSSoapBinding_envelope *envelope = [AgentWSSoapBinding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"VersionChecker"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/VersionChecker" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoapBindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "VersionCheckerResponse")) {
                                    AgentWS_VersionCheckerResponse *bodyObject = [AgentWS_VersionCheckerResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) &&
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoapBinding_SupervisorLogin
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_SupervisorLogin *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoapBindingResponse new];
    
    AgentWSSoapBinding_envelope *envelope = [AgentWSSoapBinding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"SupervisorLogin"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/SupervisorLogin" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoapBindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "SupervisorLoginResponse")) {
                                    AgentWS_SupervisorLoginResponse *bodyObject = [AgentWS_SupervisorLoginResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) &&
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoapBinding_AdminLogin
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_AdminLogin *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoapBindingResponse new];
    
    AgentWSSoapBinding_envelope *envelope = [AgentWSSoapBinding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"AdminLogin"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/AdminLogin" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoapBindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "AdminLoginResponse")) {
                                    AgentWS_AdminLoginResponse *bodyObject = [AgentWS_AdminLoginResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) &&
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoapBinding_ChangeUDID
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_ChangeUDID *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoapBindingResponse new];
    
    AgentWSSoapBinding_envelope *envelope = [AgentWSSoapBinding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"ChangeUDID"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/ChangeUDID" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoapBindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "ChangeUDIDResponse")) {
                                    AgentWS_ChangeUDIDResponse *bodyObject = [AgentWS_ChangeUDIDResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) &&
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoapBinding_Syncdatareferral
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoapBinding *)aBinding delegate:(id<AgentWSSoapBindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_Syncdatareferral *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoapBindingResponse new];
    
    AgentWSSoapBinding_envelope *envelope = [AgentWSSoapBinding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"Syncdatareferral"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/Syncdatareferral" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoapBindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "SyncdatareferralResponse")) {
                                    AgentWS_SyncdatareferralResponse *bodyObject = [AgentWS_SyncdatareferralResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) &&
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end

static AgentWSSoapBinding_envelope *AgentWSSoapBindingSharedEnvelopeInstance = nil;
@implementation AgentWSSoapBinding_envelope
+ (AgentWSSoapBinding_envelope *)sharedInstance
{
    if(AgentWSSoapBindingSharedEnvelopeInstance == nil) {
        AgentWSSoapBindingSharedEnvelopeInstance = [AgentWSSoapBinding_envelope new];
    }
    
    return AgentWSSoapBindingSharedEnvelopeInstance;
}
- (NSString *)serializedFormUsingHeaderElements:(NSDictionary *)headerElements bodyElements:(NSDictionary *)bodyElements
{
    xmlDocPtr doc;
    
    doc = xmlNewDoc((const xmlChar*)XML_DEFAULT_VERSION);
    if (doc == NULL) {
        NSLog(@"Error creating the xml document tree");
        return @"";
    }
    
    xmlNodePtr root = xmlNewDocNode(doc, NULL, (const xmlChar*)"Envelope", NULL);
    xmlDocSetRootElement(doc, root);
    
    xmlNsPtr soapEnvelopeNs = xmlNewNs(root, (const xmlChar*)"http://www.w3.org/2003/05/soap-envelope", (const xmlChar*)"soap");
    xmlSetNs(root, soapEnvelopeNs);
    
    xmlNsPtr xslNs = xmlNewNs(root, (const xmlChar*)"http://www.w3.org/1999/XSL/Transform", (const xmlChar*)"xsl");
    xmlNewNs(root, (const xmlChar*)"http://www.w3.org/2001/XMLSchema-instance", (const xmlChar*)"xsi");
    
    xmlNewNsProp(root, xslNs, (const xmlChar*)"version", (const xmlChar*)"1.0");
    
    xmlNewNs(root, (const xmlChar*)"http://www.w3.org/2001/XMLSchema", (const xmlChar*)"xsd");
    xmlNewNs(root, (const xmlChar*)"http://tempuri.org/", (const xmlChar*)"AgentWS");
    
    if((headerElements != nil) && ([headerElements count] > 0)) {
        xmlNodePtr headerNode = xmlNewDocNode(doc, soapEnvelopeNs, (const xmlChar*)"Header", NULL);
        xmlAddChild(root, headerNode);
        
        for(NSString *key in [headerElements allKeys]) {
            id header = [headerElements objectForKey:key];
            xmlAddChild(headerNode, [header xmlNodeForDoc:doc elementName:key elementNSPrefix:nil]);
        }
    }
    
    if((bodyElements != nil) && ([bodyElements count] > 0)) {
        xmlNodePtr bodyNode = xmlNewDocNode(doc, soapEnvelopeNs, (const xmlChar*)"Body", NULL);
        xmlAddChild(root, bodyNode);
        
        for(NSString *key in [bodyElements allKeys]) {
            id body = [bodyElements objectForKey:key];
            xmlAddChild(bodyNode, [body xmlNodeForDoc:doc elementName:key elementNSPrefix:nil]);
        }
    }
    
    xmlChar *buf;
    int size;
    xmlDocDumpFormatMemory(doc, &buf, &size, 1);
    
    NSString *serializedForm = [NSString stringWithCString:(const char*)buf encoding:NSUTF8StringEncoding];
    xmlFree(buf);
    
    xmlFreeDoc(doc);
    return serializedForm;
}
@end
@implementation AgentWSSoapBindingResponse
@synthesize headers;
@synthesize bodyParts;
@synthesize error;
- (id)init
{
    if((self = [super init])) {
        headers = nil;
        bodyParts = nil;
        error = nil;
    }
    
    return self;
}
-(void)dealloc {
    self.headers = nil;
    self.bodyParts = nil;
    self.error = nil;
    [super dealloc];
}
@end
@implementation AgentWSSoap12Binding
@synthesize address;
@synthesize defaultTimeout;
@synthesize logXMLInOut;
@synthesize cookies;
@synthesize authUsername;
@synthesize authPassword;
- (id)init
{
    if((self = [super init])) {
        address = nil;
        cookies = nil;
        defaultTimeout = 10;//seconds
        logXMLInOut = NO;
        synchronousOperationComplete = NO;
    }
    
    return self;
}
- (id)initWithAddress:(NSString *)anAddress
{
    if((self = [self init])) {
        self.address = [NSURL URLWithString:anAddress];
    }
    
    return self;
}
- (void)addCookie:(NSHTTPCookie *)toAdd
{
    if(toAdd != nil) {
        if(cookies == nil) cookies = [[NSMutableArray alloc] init];
        [cookies addObject:toAdd];
    }
}
- (AgentWSSoap12BindingResponse *)performSynchronousOperation:(AgentWSSoap12BindingOperation *)operation
{
    synchronousOperationComplete = NO;
    [operation start];
    
    // Now wait for response
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    
    while (!synchronousOperationComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    return operation.response;
}
- (void)performAsynchronousOperation:(AgentWSSoap12BindingOperation *)operation
{
    [operation start];
}
- (void) operation:(AgentWSSoap12BindingOperation *)operation completedWithResponse:(AgentWSSoap12BindingResponse *)response
{
    synchronousOperationComplete = YES;
}
- (AgentWSSoap12BindingResponse *)ValidateAgentAndDeviceUsingParameters:(AgentWS_ValidateAgentAndDevice *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoap12Binding_ValidateAgentAndDevice*)[AgentWSSoap12Binding_ValidateAgentAndDevice alloc] initWithBinding:self delegate:self
                                                                                                                                                      parameters:aParameters
                                               ] autorelease]];
}
- (void)ValidateAgentAndDeviceAsyncUsingParameters:(AgentWS_ValidateAgentAndDevice *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoap12Binding_ValidateAgentAndDevice*)[AgentWSSoap12Binding_ValidateAgentAndDevice alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                                                 parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoap12BindingResponse *)ValidateLoginUsingParameters:(AgentWS_ValidateLogin *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoap12Binding_ValidateLogin*)[AgentWSSoap12Binding_ValidateLogin alloc] initWithBinding:self delegate:self
                                                                                                                                    parameters:aParameters
                                               ] autorelease]];
}
- (void)ValidateLoginAsyncUsingParameters:(AgentWS_ValidateLogin *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoap12Binding_ValidateLogin*)[AgentWSSoap12Binding_ValidateLogin alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                               parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoap12BindingResponse *)SaveDocumentUsingParameters:(AgentWS_SaveDocument *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoap12Binding_SaveDocument*)[AgentWSSoap12Binding_SaveDocument alloc] initWithBinding:self delegate:self
                                                                                                                                  parameters:aParameters
                                               ] autorelease]];
}
- (void)SaveDocumentAsyncUsingParameters:(AgentWS_SaveDocument *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoap12Binding_SaveDocument*)[AgentWSSoap12Binding_SaveDocument alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                             parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoap12BindingResponse *)RetrievePolicyNumberUsingParameters:(AgentWS_RetrievePolicyNumber *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoap12Binding_RetrievePolicyNumber*)[AgentWSSoap12Binding_RetrievePolicyNumber alloc] initWithBinding:self delegate:self
                                                                                                                                                  parameters:aParameters
                                               ] autorelease]];
}
- (void)RetrievePolicyNumberAsyncUsingParameters:(AgentWS_RetrievePolicyNumber *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoap12Binding_RetrievePolicyNumber*)[AgentWSSoap12Binding_RetrievePolicyNumber alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                                             parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoap12BindingResponse *)SendForgotPasswordUsingParameters:(AgentWS_SendForgotPassword *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoap12Binding_SendForgotPassword*)[AgentWSSoap12Binding_SendForgotPassword alloc] initWithBinding:self delegate:self
                                                                                                                                              parameters:aParameters
                                               ] autorelease]];
}
- (void)SendForgotPasswordAsyncUsingParameters:(AgentWS_SendForgotPassword *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoap12Binding_SendForgotPassword*)[AgentWSSoap12Binding_SendForgotPassword alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                                         parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoap12BindingResponse *)ReceiveFirstLoginUsingParameters:(AgentWS_ReceiveFirstLogin *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoap12Binding_ReceiveFirstLogin*)[AgentWSSoap12Binding_ReceiveFirstLogin alloc] initWithBinding:self delegate:self
                                                                                                                                            parameters:aParameters
                                               ] autorelease]];
}
- (void)ReceiveFirstLoginAsyncUsingParameters:(AgentWS_ReceiveFirstLogin *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoap12Binding_ReceiveFirstLogin*)[AgentWSSoap12Binding_ReceiveFirstLogin alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                                       parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoap12BindingResponse *)ChangePasswordUsingParameters:(AgentWS_ChangePassword *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoap12Binding_ChangePassword*)[AgentWSSoap12Binding_ChangePassword alloc] initWithBinding:self delegate:self
                                                                                                                                      parameters:aParameters
                                               ] autorelease]];
}
- (void)ChangePasswordAsyncUsingParameters:(AgentWS_ChangePassword *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoap12Binding_ChangePassword*)[AgentWSSoap12Binding_ChangePassword alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                                 parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoap12BindingResponse *)FullSyncTableUsingParameters:(AgentWS_FullSyncTable *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoap12Binding_FullSyncTable*)[AgentWSSoap12Binding_FullSyncTable alloc] initWithBinding:self delegate:self
                                                                                                                                    parameters:aParameters
                                               ] autorelease]];
}
- (void)FullSyncTableAsyncUsingParameters:(AgentWS_FullSyncTable *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoap12Binding_FullSyncTable*)[AgentWSSoap12Binding_FullSyncTable alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                               parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoap12BindingResponse *)CheckVersionUsingParameters:(AgentWS_CheckVersion *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoap12Binding_CheckVersion*)[AgentWSSoap12Binding_CheckVersion alloc] initWithBinding:self delegate:self
                                                                                                                                  parameters:aParameters
                                               ] autorelease]];
}
- (void)CheckVersionAsyncUsingParameters:(AgentWS_CheckVersion *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoap12Binding_CheckVersion*)[AgentWSSoap12Binding_CheckVersion alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                             parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoap12BindingResponse *)PartialSyncUsingParameters:(AgentWS_PartialSync *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoap12Binding_PartialSync*)[AgentWSSoap12Binding_PartialSync alloc] initWithBinding:self delegate:self
                                                                                                                                parameters:aParameters
                                               ] autorelease]];
}
- (void)PartialSyncAsyncUsingParameters:(AgentWS_PartialSync *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoap12Binding_PartialSync*)[AgentWSSoap12Binding_PartialSync alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                           parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoap12BindingResponse *)LoginAPIUsingParameters:(AgentWS_LoginAPI *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoap12Binding_LoginAPI*)[AgentWSSoap12Binding_LoginAPI alloc] initWithBinding:self delegate:self
                                                                                                                          parameters:aParameters
                                               ] autorelease]];
}
- (void)LoginAPIAsyncUsingParameters:(AgentWS_LoginAPI *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoap12Binding_LoginAPI*)[AgentWSSoap12Binding_LoginAPI alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                     parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoap12BindingResponse *)VersionCheckerUsingParameters:(AgentWS_VersionChecker *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoap12Binding_VersionChecker*)[AgentWSSoap12Binding_VersionChecker alloc] initWithBinding:self delegate:self
                                                                                                                                      parameters:aParameters
                                               ] autorelease]];
}
- (void)VersionCheckerAsyncUsingParameters:(AgentWS_VersionChecker *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoap12Binding_VersionChecker*)[AgentWSSoap12Binding_VersionChecker alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                                 parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoap12BindingResponse *)SupervisorLoginUsingParameters:(AgentWS_SupervisorLogin *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoap12Binding_SupervisorLogin*)[AgentWSSoap12Binding_SupervisorLogin alloc] initWithBinding:self delegate:self
                                                                                                                                        parameters:aParameters
                                               ] autorelease]];
}
- (void)SupervisorLoginAsyncUsingParameters:(AgentWS_SupervisorLogin *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoap12Binding_SupervisorLogin*)[AgentWSSoap12Binding_SupervisorLogin alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                                   parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoap12BindingResponse *)AdminLoginUsingParameters:(AgentWS_AdminLogin *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoap12Binding_AdminLogin*)[AgentWSSoap12Binding_AdminLogin alloc] initWithBinding:self delegate:self
                                                                                                                              parameters:aParameters
                                               ] autorelease]];
}
- (void)AdminLoginAsyncUsingParameters:(AgentWS_AdminLogin *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoap12Binding_AdminLogin*)[AgentWSSoap12Binding_AdminLogin alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                         parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoap12BindingResponse *)ChangeUDIDUsingParameters:(AgentWS_ChangeUDID *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoap12Binding_ChangeUDID*)[AgentWSSoap12Binding_ChangeUDID alloc] initWithBinding:self delegate:self
                                                                                                                              parameters:aParameters
                                               ] autorelease]];
}
- (void)ChangeUDIDAsyncUsingParameters:(AgentWS_ChangeUDID *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoap12Binding_ChangeUDID*)[AgentWSSoap12Binding_ChangeUDID alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                         parameters:aParameters
                                          ] autorelease]];
}
- (AgentWSSoap12BindingResponse *)SyncdatareferralUsingParameters:(AgentWS_Syncdatareferral *)aParameters
{
    return [self performSynchronousOperation:[[(AgentWSSoap12Binding_Syncdatareferral*)[AgentWSSoap12Binding_Syncdatareferral alloc] initWithBinding:self delegate:self
                                                                                                                                          parameters:aParameters
                                               ] autorelease]];
}
- (void)SyncdatareferralAsyncUsingParameters:(AgentWS_Syncdatareferral *)aParameters  delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
{
    [self performAsynchronousOperation: [[(AgentWSSoap12Binding_Syncdatareferral*)[AgentWSSoap12Binding_Syncdatareferral alloc] initWithBinding:self delegate:responseDelegate
                                                                                                                                     parameters:aParameters
                                          ] autorelease]];
}
- (void)sendHTTPCallUsingBody:(NSString *)outputBody soapAction:(NSString *)soapAction forOperation:(AgentWSSoap12BindingOperation *)operation
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.address
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:self.defaultTimeout];
    NSData *bodyData = [outputBody dataUsingEncoding:NSUTF8StringEncoding];
    
    if(cookies != nil) {
        [request setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:cookies]];
    }
    [request setValue:@"wsdl2objc" forHTTPHeaderField:@"User-Agent"];
    [request setValue:soapAction forHTTPHeaderField:@"SOAPAction"];
    [request setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%u", [bodyData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:self.address.host forHTTPHeaderField:@"Host"];
    [request setHTTPMethod: @"POST"];
    // set version 1.1 - how?
    [request setHTTPBody: bodyData];
    
    if(self.logXMLInOut) {
        NSLog(@"OutputHeaders:\n%@", [request allHTTPHeaderFields]);
        NSLog(@"OutputBody:\n%@", outputBody);
    }
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:operation];
    
    operation.urlConnection = connection;
    [connection release];
}
- (void) dealloc
{
    [address release];
    [cookies release];
    [super dealloc];
}
@end
@implementation AgentWSSoap12BindingOperation
@synthesize binding;
@synthesize response;
@synthesize delegate;
@synthesize responseData;
@synthesize urlConnection;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)aDelegate
{
    if ((self = [super init])) {
        self.binding = aBinding;
        response = nil;
        self.delegate = aDelegate;
        self.responseData = nil;
        self.urlConnection = nil;
    }
    
    return self;
}
-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] == 0) {
        NSURLCredential *newCredential;
        newCredential=[NSURLCredential credentialWithUser:self.binding.authUsername
                                                 password:self.binding.authPassword
                                              persistence:NSURLCredentialPersistenceForSession];
        [[challenge sender] useCredential:newCredential
               forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Authentication Error" forKey:NSLocalizedDescriptionKey];
        NSError *authError = [NSError errorWithDomain:@"Connection Authentication" code:0 userInfo:userInfo];
        [self connection:connection didFailWithError:authError];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)urlResponse
{
    NSHTTPURLResponse *httpResponse;
    if ([urlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
        httpResponse = (NSHTTPURLResponse *) urlResponse;
    } else {
        httpResponse = nil;
    }
    
    if(binding.logXMLInOut) {
        NSLog(@"ResponseStatus: %u\n", [httpResponse statusCode]);
        NSLog(@"ResponseHeaders:\n%@", [httpResponse allHeaderFields]);
    }
    
    NSMutableArray *cookies = [[NSHTTPCookie cookiesWithResponseHeaderFields:[httpResponse allHeaderFields] forURL:binding.address] mutableCopy];
    
    binding.cookies = cookies;
    [cookies release];
    if ([urlResponse.MIMEType rangeOfString:@"application/soap+xml"].length == 0) {
        NSError *error = nil;
        [connection cancel];
        if ([httpResponse statusCode] >= 400) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]] forKey:NSLocalizedDescriptionKey];
            
            error = [NSError errorWithDomain:@"AgentWSSoap12BindingResponseHTTP" code:[httpResponse statusCode] userInfo:userInfo];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:
                                      [NSString stringWithFormat: @"Unexpected response MIME type to SOAP call:%@", urlResponse.MIMEType]
                                                                 forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"AgentWSSoap12BindingResponseHTTP" code:1 userInfo:userInfo];
        }
        
        [self connection:connection didFailWithError:error];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (responseData == nil) {
        responseData = [data mutableCopy];
    } else {
        [responseData appendData:data];
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (binding.logXMLInOut) {
        NSLog(@"ResponseError:\n%@", error);
    }
    response.error = error;
    [delegate operation:self completedWithResponse:response];
}
- (void)dealloc
{
    [binding release];
    [response release];
    delegate = nil;
    [responseData release];
    [urlConnection release];
    
    [super dealloc];
}
@end
@implementation AgentWSSoap12Binding_ValidateAgentAndDevice
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_ValidateAgentAndDevice *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoap12BindingResponse new];
    
    AgentWSSoap12Binding_envelope *envelope = [AgentWSSoap12Binding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"ValidateAgentAndDevice"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/ValidateAgentAndDevice" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoap12BindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "ValidateAgentAndDeviceResponse")) {
                                    AgentWS_ValidateAgentAndDeviceResponse *bodyObject = [AgentWS_ValidateAgentAndDeviceResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) && 
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoap12Binding_ValidateLogin
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_ValidateLogin *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoap12BindingResponse new];
    
    AgentWSSoap12Binding_envelope *envelope = [AgentWSSoap12Binding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"ValidateLogin"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/ValidateLogin" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoap12BindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "ValidateLoginResponse")) {
                                    AgentWS_ValidateLoginResponse *bodyObject = [AgentWS_ValidateLoginResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) && 
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoap12Binding_SaveDocument
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_SaveDocument *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoap12BindingResponse new];
    
    AgentWSSoap12Binding_envelope *envelope = [AgentWSSoap12Binding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"SaveDocument"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/SaveDocument" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoap12BindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "SaveDocumentResponse")) {
                                    AgentWS_SaveDocumentResponse *bodyObject = [AgentWS_SaveDocumentResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) && 
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoap12Binding_RetrievePolicyNumber
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_RetrievePolicyNumber *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoap12BindingResponse new];
    
    AgentWSSoap12Binding_envelope *envelope = [AgentWSSoap12Binding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"RetrievePolicyNumber"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/RetrievePolicyNumber" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoap12BindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "RetrievePolicyNumberResponse")) {
                                    AgentWS_RetrievePolicyNumberResponse *bodyObject = [AgentWS_RetrievePolicyNumberResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) && 
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoap12Binding_SendForgotPassword
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_SendForgotPassword *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoap12BindingResponse new];
    
    AgentWSSoap12Binding_envelope *envelope = [AgentWSSoap12Binding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"SendForgotPassword"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/SendForgotPassword" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoap12BindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "SendForgotPasswordResponse")) {
                                    AgentWS_SendForgotPasswordResponse *bodyObject = [AgentWS_SendForgotPasswordResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) && 
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoap12Binding_ReceiveFirstLogin
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_ReceiveFirstLogin *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoap12BindingResponse new];
    
    AgentWSSoap12Binding_envelope *envelope = [AgentWSSoap12Binding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"ReceiveFirstLogin"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/ReceiveFirstLogin" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoap12BindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "ReceiveFirstLoginResponse")) {
                                    AgentWS_ReceiveFirstLoginResponse *bodyObject = [AgentWS_ReceiveFirstLoginResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) && 
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoap12Binding_ChangePassword
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_ChangePassword *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoap12BindingResponse new];
    
    AgentWSSoap12Binding_envelope *envelope = [AgentWSSoap12Binding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"ChangePassword"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/ChangePassword" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoap12BindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "ChangePasswordResponse")) {
                                    AgentWS_ChangePasswordResponse *bodyObject = [AgentWS_ChangePasswordResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) && 
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoap12Binding_FullSyncTable
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_FullSyncTable *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoap12BindingResponse new];
    
    AgentWSSoap12Binding_envelope *envelope = [AgentWSSoap12Binding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"FullSyncTable"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/FullSyncTable" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoap12BindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "FullSyncTableResponse")) {
                                    AgentWS_FullSyncTableResponse *bodyObject = [AgentWS_FullSyncTableResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) && 
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoap12Binding_CheckVersion
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_CheckVersion *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoap12BindingResponse new];
    
    AgentWSSoap12Binding_envelope *envelope = [AgentWSSoap12Binding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"CheckVersion"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/CheckVersion" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoap12BindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "CheckVersionResponse")) {
                                    AgentWS_CheckVersionResponse *bodyObject = [AgentWS_CheckVersionResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) && 
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoap12Binding_PartialSync
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_PartialSync *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoap12BindingResponse new];
    
    AgentWSSoap12Binding_envelope *envelope = [AgentWSSoap12Binding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"PartialSync"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/PartialSync" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoap12BindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "PartialSyncResponse")) {
                                    AgentWS_PartialSyncResponse *bodyObject = [AgentWS_PartialSyncResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) && 
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoap12Binding_LoginAPI
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_LoginAPI *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoap12BindingResponse new];
    
    AgentWSSoap12Binding_envelope *envelope = [AgentWSSoap12Binding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"LoginAPI"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/LoginAPI" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoap12BindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "LoginAPIResponse")) {
                                    AgentWS_LoginAPIResponse *bodyObject = [AgentWS_LoginAPIResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) && 
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoap12Binding_VersionChecker
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_VersionChecker *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoap12BindingResponse new];
    
    AgentWSSoap12Binding_envelope *envelope = [AgentWSSoap12Binding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"VersionChecker"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/VersionChecker" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoap12BindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "VersionCheckerResponse")) {
                                    AgentWS_VersionCheckerResponse *bodyObject = [AgentWS_VersionCheckerResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) && 
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoap12Binding_SupervisorLogin
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_SupervisorLogin *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoap12BindingResponse new];
    
    AgentWSSoap12Binding_envelope *envelope = [AgentWSSoap12Binding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"SupervisorLogin"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/SupervisorLogin" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoap12BindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "SupervisorLoginResponse")) {
                                    AgentWS_SupervisorLoginResponse *bodyObject = [AgentWS_SupervisorLoginResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) && 
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoap12Binding_AdminLogin
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_AdminLogin *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoap12BindingResponse new];
    
    AgentWSSoap12Binding_envelope *envelope = [AgentWSSoap12Binding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"AdminLogin"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/AdminLogin" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoap12BindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "AdminLoginResponse")) {
                                    AgentWS_AdminLoginResponse *bodyObject = [AgentWS_AdminLoginResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) && 
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoap12Binding_ChangeUDID
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_ChangeUDID *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoap12BindingResponse new];
    
    AgentWSSoap12Binding_envelope *envelope = [AgentWSSoap12Binding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"ChangeUDID"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/ChangeUDID" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoap12BindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "ChangeUDIDResponse")) {
                                    AgentWS_ChangeUDIDResponse *bodyObject = [AgentWS_ChangeUDIDResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) &&
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
@implementation AgentWSSoap12Binding_Syncdatareferral
@synthesize parameters;
- (id)initWithBinding:(AgentWSSoap12Binding *)aBinding delegate:(id<AgentWSSoap12BindingResponseDelegate>)responseDelegate
           parameters:(AgentWS_Syncdatareferral *)aParameters
{
    if((self = [super initWithBinding:aBinding delegate:responseDelegate])) {
        self.parameters = aParameters;
    }
    
    return self;
}
- (void)dealloc
{
    if(parameters != nil) [parameters release];
    
    [super dealloc];
}
- (void)main
{
    [response autorelease];
    response = [AgentWSSoap12BindingResponse new];
    
    AgentWSSoap12Binding_envelope *envelope = [AgentWSSoap12Binding_envelope sharedInstance];
    
    NSMutableDictionary *headerElements = nil;
    headerElements = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *bodyElements = nil;
    bodyElements = [NSMutableDictionary dictionary];
    if(parameters != nil) [bodyElements setObject:parameters forKey:@"Syncdatareferral"];
    
    NSString *operationXMLString = [envelope serializedFormUsingHeaderElements:headerElements bodyElements:bodyElements];
    
    [binding sendHTTPCallUsingBody:operationXMLString soapAction:@"http://tempuri.org/Syncdatareferral" forOperation:self];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (responseData != nil && delegate != nil)
    {
        xmlDocPtr doc;
        xmlNodePtr cur;
        
        if (binding.logXMLInOut) {
            NSLog(@"ResponseBody:\n%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        }
        
        doc = xmlParseMemory([responseData bytes], [responseData length]);
        
        if (doc == NULL) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Errors while parsing returned XML" forKey:NSLocalizedDescriptionKey];
            
            response.error = [NSError errorWithDomain:@"AgentWSSoap12BindingResponseXML" code:1 userInfo:userInfo];
            [delegate operation:self completedWithResponse:response];
        } else {
            cur = xmlDocGetRootElement(doc);
            cur = cur->children;
            
            for( ; cur != NULL ; cur = cur->next) {
                if(cur->type == XML_ELEMENT_NODE) {
                    
                    if(xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
                        NSMutableArray *responseBodyParts = [NSMutableArray array];
                        
                        xmlNodePtr bodyNode;
                        for(bodyNode=cur->children ; bodyNode != NULL ; bodyNode = bodyNode->next) {
                            if(cur->type == XML_ELEMENT_NODE) {
                                if(xmlStrEqual(bodyNode->name, (const xmlChar *) "SyncdatareferralResponse")) {
                                    AgentWS_SyncdatareferralResponse *bodyObject = [AgentWS_SyncdatareferralResponse deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                                if (xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix) &&
                                    xmlStrEqual(bodyNode->name, (const xmlChar *) "Fault")) {
                                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode];
                                    //NSAssert1(bodyObject != nil, @"Errors while parsing body %s", bodyNode->name);
                                    if (bodyObject != nil) [responseBodyParts addObject:bodyObject];
                                }
                            }
                        }
                        
                        response.bodyParts = responseBodyParts;
                    }
                }
            }
            
            xmlFreeDoc(doc);
        }
        
        xmlCleanupParser();
        [delegate operation:self completedWithResponse:response];
    }
}
@end
static AgentWSSoap12Binding_envelope *AgentWSSoap12BindingSharedEnvelopeInstance = nil;
@implementation AgentWSSoap12Binding_envelope
+ (AgentWSSoap12Binding_envelope *)sharedInstance
{
    if(AgentWSSoap12BindingSharedEnvelopeInstance == nil) {
        AgentWSSoap12BindingSharedEnvelopeInstance = [AgentWSSoap12Binding_envelope new];
    }
    
    return AgentWSSoap12BindingSharedEnvelopeInstance;
}
- (NSString *)serializedFormUsingHeaderElements:(NSDictionary *)headerElements bodyElements:(NSDictionary *)bodyElements
{
    xmlDocPtr doc;
    
    doc = xmlNewDoc((const xmlChar*)XML_DEFAULT_VERSION);
    if (doc == NULL) {
        NSLog(@"Error creating the xml document tree");
        return @"";
    }
    
    xmlNodePtr root = xmlNewDocNode(doc, NULL, (const xmlChar*)"Envelope", NULL);
    xmlDocSetRootElement(doc, root);
    
    xmlNsPtr soapEnvelopeNs = xmlNewNs(root, (const xmlChar*)"http://www.w3.org/2003/05/soap-envelope", (const xmlChar*)"soap");
    xmlSetNs(root, soapEnvelopeNs);
    
    xmlNsPtr xslNs = xmlNewNs(root, (const xmlChar*)"http://www.w3.org/1999/XSL/Transform", (const xmlChar*)"xsl");
    xmlNewNs(root, (const xmlChar*)"http://www.w3.org/2001/XMLSchema-instance", (const xmlChar*)"xsi");
    
    xmlNewNsProp(root, xslNs, (const xmlChar*)"version", (const xmlChar*)"1.0");
    
    xmlNewNs(root, (const xmlChar*)"http://www.w3.org/2001/XMLSchema", (const xmlChar*)"xsd");
    xmlNewNs(root, (const xmlChar*)"http://tempuri.org/", (const xmlChar*)"AgentWS");
    
    if((headerElements != nil) && ([headerElements count] > 0)) {
        xmlNodePtr headerNode = xmlNewDocNode(doc, soapEnvelopeNs, (const xmlChar*)"Header", NULL);
        xmlAddChild(root, headerNode);
        
        for(NSString *key in [headerElements allKeys]) {
            id header = [headerElements objectForKey:key];
            xmlAddChild(headerNode, [header xmlNodeForDoc:doc elementName:key elementNSPrefix:nil]);
        }
    }
    
    if((bodyElements != nil) && ([bodyElements count] > 0)) {
        xmlNodePtr bodyNode = xmlNewDocNode(doc, soapEnvelopeNs, (const xmlChar*)"Body", NULL);
        xmlAddChild(root, bodyNode);
        
        for(NSString *key in [bodyElements allKeys]) {
            id body = [bodyElements objectForKey:key];
            xmlAddChild(bodyNode, [body xmlNodeForDoc:doc elementName:key elementNSPrefix:nil]);
        }
    }
    
    xmlChar *buf;
    int size;
    xmlDocDumpFormatMemory(doc, &buf, &size, 1);
    
    NSString *serializedForm = [NSString stringWithCString:(const char*)buf encoding:NSUTF8StringEncoding];
    xmlFree(buf);
    
    xmlFreeDoc(doc);	
    return serializedForm;
}
@end
@implementation AgentWSSoap12BindingResponse
@synthesize headers;
@synthesize bodyParts;
@synthesize error;
- (id)init
{
    if((self = [super init])) {
        headers = nil;
        bodyParts = nil;
        error = nil;
    }
    
    return self;
}
-(void)dealloc {
    self.headers = nil;
    self.bodyParts = nil;
    self.error = nil;	
    [super dealloc];
}
@end
