/*==============================================================*
 * SOFTPRO SignWare                                             *
 * ADSV developer Toolkit                                       *
 * Module: SPGuiAcqu.h                                          *
 * Created by: uko                                              *
 *                                                              *
 * Copyright SOFTPRO GmbH                                       *
 * Wilhelmstrasse 34, D-71034 Boeblingen                        *
 * All rights reserved.                                         *
 *                                                              *
 * This software is the confidential and proprietary            *
 * information of SOFTPRO ("Confidential Information"). You     *
 * shall not disclose such Confidential Information and shall   *
 * use it only in accordance with the terms of the license      *
 * agreement you entered into with SOFTPRO.                     *
 *==============================================================*/
/**
 * @file SPGuiAcqu.h
 * @author uko
 *
 * @brief SignWare Dynamic Development toolkit, acquire signatures
 *
 * This header includes the graphical user interface for capturing
 * signatures on a tablet.
 * <br>
 * Signware also includes an object to capture signatures / references without 
 * native GUI, please read  @ref secGuiAcquVsAcquire for a comparison
 * of SPAcquire and SPGuiAcqu.
 * <br>The functions declared in this header are not yet implemented for Linux.
 *
 * @section gui_spGuiAcqu SPGuiAcqu
 * The SPGuiAcqu object captures one or more signatures from a tablet.
 * It will either create a new window (@ref SPGuiAcquCreate) or use an existing
 * client window (@ref SPGuiAcquCreateInClient) and draw all vectors inside
 * the client window.
 *
 * It supports the @ref gui_Window and adds capabilities to define special
 * regions. These regions will be interpreted as clickable areas, virtual buttons. 
 * When the user clicks these regions then either a window message will be sent
 * to the component or a callback function will be called.

 * The acquiry object creates a signature and a reference object. The signature
 * object will be filled during acquiry (as long as acquire mode is active). The
 * signature object will be appended to the reference object if
 * @ref SPGuiAcquAcquireDone is called with @ref SP_IDOK.
 * In any case, the signature object will not be accessable
 * after calling SPGuiAcquAcquireDone. The typical usage of the signature object is to
 * check for empty signatures and to deny accepting empty signatures. Always
 * use the created reference object as the result of an acquire operation.
 *
 * The application must differentiate several types of tablet hardware:
 *      - Standard tablets: these devices have no display, so there is no
 *          feedback for users when they hit any special regions or virtual buttons. 
 *          It is thus not recommended to define virtual buttons on these devices.
 *      - Full-screen tablets: these devices include a screen that typically
 *          displays the entire workstation. It is recommended to use buttons
 *          on these devices and handle the according button notifications.
 *          <br> TabletPCs are supported by SignWare, SPGuiAcqu subclasses the main
 *          application window to detect display changes (either resolution or 
 *          ratation changes) and handle this event correctly.
 *          <br> The WM_DISPLAYCHANGE event is also passed to the application.
 *      - Tablets with integrated screen: these devices integrate a screen that
 *          allows for direct feedback of the strokes. These devices also
 *          allow for a visual representation of virtual buttons. It is recommended
 *          to register virtual buttons on these devices. Set the flag @ref SP_TABLET_COORDINATE
 *          to display virtual buttons at the correct position on the screen, else
 *          the application must trace position and size of the registered rectangle.
 *          <br> Screen updates on these devices are typically relatively slow, it
 *          is not recommended to dynamically update the screen.
 *          <br>The tablet screen is only updated during state transitions from 
 *          connect state to acquire state, the screen can thus not be updated 
 *          when acquiry mode is active.
 *      - Tablets which cannot send vectors in real time (SPTabletGetTybletType() 
 *          returns bit SP_TABLET_NO_REALTIME_VECTORS is set): a GUI should not
 *          display a OK-button unless the the user can see the tablet contents.
 *      - The application must evaluate hardware buttons for tablets that set the flag 
 *          SP_TABLET_HARDWARE_AS_VIRTUAL_BUTTONS.
 *      .
 *
 * You may define buttons that are clickable with the tablet. Two versions of
 * buttons are supported:
 *      - Buttons with a native window assigned, see @ref SPGuiAcquRegisterComponent
 *      - Virtual buttons, see @ref SPGuiAcquRegisterRect and @ref SPGuiAcquRegisterRect2
 *      .
 *
 * Please see the provided samples for correct use of the acquiry object.
 *
 * @note Some low-level tablet drivers use window messages to communicate with the application. 
 *      - Wintab uses message ID's in the range
 *        WM_USER + 0x7BF0 (0x7FF0) through WM_USER + 0xFBFF (0x7FFF),
 *      - SOFTPRO drivers use message ID's in the range
 *        WM_USER + 0x7BD0 (0x7FD0) through WM_USER + 0x7BDF (0x7FDF).
 *      - SPGuiAcqu uses message ID's in the range
 *        WM_USER + 0x7BB0 (0x7FB0) through WM_USER + 0x7BBF (0x7FBF).
 *      .
 * Please assure that these message ID's do not conflict with message
 * ID's in your application.
 *
 * @section sec_MobileDevices Mobile Devices
 *
 * Mobile devices such as iPad are becoming popular and many people would like to use
 * a mobile device as an input to enter the signature.
 * <br> A few limitations apply due to technical limitations of these devices:
 *      - the sample rate is too low to evaluate the biometrical identity,
 *        captured signatures cannot be compared.
 *      .
 * The devices cannot be directly accessed from an application, SOFTPRO has developed 
 * two access modules for such devices, which are furtheron referenced as TabletServer
 * and RemoteTablet.
 * <br> The module TabletServer is currently rated experimental, it is not recommended
 * to access this module at this time. 
 * <br> The module RemoteTablet is currently rated experimental, it is not recommended
 * to access this module at this time. 
 *
 * An application may need to implement some special requirements to support 
 * Tablets that communicate through the SOFTPRO TabletServer module, please 
 * see @ref page_SPTabletServer for details.
 *
 * An application may need to implement some special requirements to support 
 * Tablets that communicate through the SOFTPRO RemoteTablet module, please 
 * see @ref page_SPRemoteTablet for details.
 *
 * @section gui_Window Standard window properties
 * SignWare GUI objects support these properties:
 *      - Flags:
 *          - SP_ERASE_BACKGROUND: the signware object will erase the background using the
 *              background color whenever the WM_ERASEBKGND message
 *              is sent, else the WM_ERASEBKGND message will be dispatched
 *              to the parent or standard window procedure.
 *          - SP_DRAW_TABLET_BORDER: draw a rectangle around the active tablet region in
 *              black color to display the active tablet size. Without this property, no rectangle is drawn.
 *          - SP_DRAW_HWND_BORDER: draw a border around the size of the window, excluding the
 *              borders.
 *          .
 *      - Borders set the size of a border within the window rectangle.
 *      - Foreground color: the color used for tablet strokes with maximum pressure
 *      - Background color: the color used for tablet strokes with no pressure
 *      .
 *
 * @section sec_SpGuiAcquProperties Supported properties
 * 
 * The table below lists all supported Properties.
 *
 * @htmlonly
 * <table border=1 width="95%") <tbody>
 *   <tr>
 *     <th width='150px'> Name </th> <th width='70px'> Default </th><th width='100px'> Range </th><th> Description </th>
 *   </tr>
 *   <tr> <td> "BackgroundColor" </td>  <td> 0xFFFFFF </td>  <td>  </td>          <td> Background color, format 0xrrggbb, rr: red, gg: green, bb: blue </td> </tr>
 *   <tr> <td> "ForegroundColor" </td>  <td> 0x000000 </td>  <td>  </td>          <td> Foreground color, format 0xrrggbb, rr: red, gg: green, bb: blue </td> </tr>
 *   <tr> <td> "RectangleColor" </td>   <td> 0x000000 </td>  <td>  </td>           <td> Border color, format 0xrrggbb, rr: red, gg: green, bb: blue </td> </tr>
 *   <tr> <td> "PenThickness" </td>     <td> 127 </td>       <td> 1 ... 255 </td> <td> Pen thickness, see SPTabletSetTabletOption for details </td> </tr>
 *   <tr> <td> "ScrBorder" </td>        <td> 5 </td>         <td> 0 ... 255 </td> <td> Size of the border in pixel </td> </tr>
 *   <tr> <td> "WindowBorder" </td>     <td> false </td>     <td> SPBOOL </td>    <td> Draw a border around the window, see SP_DRAW_HWND_BORDER for details </td> </tr>
 *   <tr> <td> "TabletBorder" </td>     <td> false </td>     <td> SPBOOL </td>    <td> Draw a border around the tablet, see SP_DRAW_TABLET_BORDER for details </td> </tr>
 *   <tr> <td> "MirrorTablet" </td>     <td> false </td>     <td> SPBOOL </td>    <td> Mirror tablet, see SP_DRAW_MIRROR_TABLET for details </td> </tr>
 *   <tr> <td> "NoStrokeEcho" </td>     <td> false </td>     <td> SPBOOL </td>    <td> set stroke echo, see SP_VIRTUAL_BUTTON_MODE for details </td> </tr>
 *   <tr> <td> "ButtonClickMode" </td>  <td> true </td>      <td> SPBOOL </td>    <td> set button click mode, see SP_VIRTUAL_BUTTON_CLICK for details </td> </tr>
 *   <tr> <td> "ReleaseFokus" </td>     <td> false </td>     <td> SPBOOL </td>    <td> end acquiry when loosing the focus, see SP_RELEASE_FOCUS for details </td> </tr>
 *   <tr> <td> "EraseBackground" </td>  <td> false </td>     <td> SPBOOL </td>    <td> erase the background, see SP_ERASE_BACKGROUND for details </td> </tr>
 *   <tr> <td> "EmulateCursor" </td>    <td> false </td>     <td> SPBOOL </td>    <td> emulate the cursor, see SP_EMULATE_PEN_CURSOR for details </td> </tr>
 *   <tr> <td> "DisableCursor" </td>    <td> false </td>     <td> SPBOOL </td>    <td> disable the cursor, see SP_DISABLE_CURSOR for details </td> </tr>
 *   <tr> <td> "DrawBackgroundImage" </td> <td> false </td>  <td> SPBOOL </td>    <td> display the background image, see SP_DRAW_BACKGROUND_IMAGE for details </td> </tr>
 *   <tr> <td> "DrawTabletImage" </td>  <td> false </td>     <td> SPBOOL </td>    <td> display the tablet background image, see SP_DRAW_TABLET_IMAGE_IN_WINDOW for details </td> </tr>
 *   <tr> <td> "DrawBuffered" </td>     <td> false </td>     <td> SPBOOL </td>    <td> double buffer the screen image, see SP_DRAW_BUFFERED for details </td> </tr>
 * </table>
 * @endhtmlonly
 * 
 * @section sec_XML_Data Description of parameters passed as XML strings
 *
 * @section sec_VirtualButtonDescriptionDTD Virtual Buttons
 * Several regions on the tablet may be defined as virtual buttons. These regions are
 * passed in a call to either @ref SPGuiAcquRegisterRect or @ref SPGuiAcquRegisterRect2.
 * SPGuiAcquRegisterRect passes all parameters directly, which is a  bit simpler to
 * use, but lacks flexibility. SPGuiAcquRegisterRect2 passes an XML string
 * that describes the position, text, font etc. to be displayed within the registered region.
 *
 * A virtual button is defined by element SPSWVirtualButton. It validates to the @ref sec_SignWareDTD.
 *
 * Please use the XML declaration to specify the character encoding of
 * the XML document. Supported encodings are ASCII, UTF-8, and ISO-8859-1.
 *
 * Example (C):
 @code
  void registerButton(pSPGUIACQU_T pSpGA, const char *aText, RECT rcl, int *piId,
                      pSPGUIACQURECTLISTENER_T pRectListener)
  {
      int rc;
      char szXML[8192];
      _snprintf (szXML, sizeof(szXML),
              "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
              "<!DOCTYPE SPSWObjects SYSTEM "SPSWObjects.dtd">\n"
              "<SPSWVirtualButton DrawFlags=\"%d\">\n"
              "  <SPSWCoordinate Origin=\"tablet\" Left=\"%d\" Right=\"%d\" Top=\"%d\" Bottom=\"%d\" />\n"
              "  <SPSWText Caption=\"%s\" DrawFlags=\"%d\">\n"
              "    <SPSWFont Face=\"Arial\" Size=\"12\" />\n"
              "    <SPSWCoordinate Origin=\"tablet\" Left=\"%d\" Right=\"%d\" Top=\"%d\" Bottom=\"%d\" />\n"
              "  </SPSWText>\n"
              "</SPSWVirtualButton>\n"
              3,          // DrawFlags
              rcl.left, rcl.right, rcl.top, rcl.bottom,
              pszName,    // caption text
              3,
              rcl.left, rcl.right, rcl.top, rcl.bottom
              );         // DrawFlags
      rc = SPGuiAcquRegisterRect2(pSpGA, piId, szXML, pRectListener);
      return rc;
  }
 @endcode
 *
 *
 * @section sec_TextDescriptionDTD Text fields
 * It may be required to dynamically draw text on the screen of a tablet. The text is passed
 * in a call to @ref SPGuiAcquAddBackgroundText. This function requires a string that is interpreted according
 * to the @ref sec_SignWareDTD.
 *
 * Please use the XML declaration to specify the character encoding of
 * the XML document. Supported encodings are ASCII, UTF-8, and ISO-8859-1.
 *
 * A text entry is defined by element SPSWText for a single text field, or element
 * SPSWTextFields to define several text regions in one descriptor.
 *
 * @note The element SPSWCoordinate is mandatory in text descriptors (although the DTD marks it
 * optional).
 *
 * If a font is defined with a size of 0, then this will be
 * interpreted as the greatest font size allowing the text to be
 * displayed within the given coordinates. Some restrictions may apply
 * to alignment flags when auto word break is set.
 *
 * Example (C):
 @code
  void addBackroundText(pSPGUIACQU_T pSpGA, const char *aText, RECT rcl)
  {
      char szXML[8192];
      int rc;
      _snprintf (szXML, sizeof(szXML),
              "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
              "<!DOCTYPE SPSWObjects SYSTEM "SPSWObjects.dtd">\n"
              "<SPSWObjects>\n"
              "  <SPSWTextFields>\n"
              "    <SPSWText Caption=\"%s\" DrawFlags=\"%d\">\n"
              "      <SPSWCoordinate Origin=\"tablet\" Left=\"%d\" Top=\"%d\" Right=\"%d\" Bottom=\"%d\" />\n"
              "      <SPSWFont Face=\"Arial\" Size=\"12\" />\n"
              "    </SPSWText>\n"
              "  </SPSWTextFields>\n"
              "</SPSWObjects>\n",
              aText,
              3, // SPSW_TEXT_DRAW_TABLET | SPSW_TEXT_DRAW_SCREEN,
              rcl.left, rcl.top, rcl.right, rcl.bottom);
      rc = SPGuiAcquAddBackgroundText(pSpGA, szXML);
      return rc;
  }
 @endcode
 *
 * @section sec_ImageDescriptionDTD Image fields
 * It may be required to dynamically draw images on the screen of a tablet. The images are passed
 * in a call to @ref SPGuiAcquAddBackgroundImage. This function requires a string that is interpreted according
 * to the @ref sec_SignWareDTD.
 *
 * An image is defined by element SPSWImage for a single image, or by element
 * SPSWImageFields for several image regions in one descriptor.
 *
 * @note The element SPSWCoordinate is mandatory in image descriptors (although the DTD marks it
 * optional).
 *
 * Example (C):
 @code
  void addBackroundImage(pSPGUIACQU_T pSpGA, const char *aImage, int aImageLen, RECT rcl)
  {
      char *pszImage = 0;
      int rc;
      int iBase64 = 0;
      char *pszBase64 = 0;
      SPBase64Encode(aImage, aImageLen, &pszBase64);
      iBase64 = strlen(pszBase64);
      pszImage = malloc(iBase64 + 1024);
      _snprintf (pszImage, iBase64 + 1024,
              "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
              "<!DOCTYPE SPSWObjects SYSTEM "SPSWObjects.dtd">\n"
              "<SPSWObjects>\n"
              "  <SPSWImageFields>\n"
              "    <SPSWImage DrawFlags=\"%d\" Format=\"3\">\n"
              "      <SPSWCoordinate Origin=\"tablet\" Left=\"%d\" Top=\"%d\" Right=\"%d\" Bottom=\"%d\" />\n"
              "    %s\n"
              "    </SPSWImage>\n"
              "  </SPSWImageFields>\n"
              "</SPSWObjects>\n",
              0x13, // SPSW_IMAGE_DRAW_TABLET | SPSW_IMAGE_DRAW_SCREEN | SPSWIMAGE_DRAW_TRANSPARENT,
              rcl.left, rcl.top, rcl.right, rcl.bottom,
              pszBase64);
      rc = SPGuiAcquAddBackgroundImage(pSpGA, pszImage);
      free(spzImage;
      SPFreeString(&pszBase64);
      return rc;
  }
 @endcode
 *
 * @section sec_DocumentDescriptionDTD Image fields
 * It may be required to dynamically view documents on the screen of a tablet. The documents are passed
 * in a call to @ref SPGuiAcquAddBackgroundDocument. This function requires a string that is interpreted according
 * to the @ref sec_SignWareDTD.
 *
 * A document is defined by element SPSWDocument for a single document, or by element
 * SPSWDocumentFields for several document in one descriptor.
 * A document view may add vertical and horizontal sliders, and virtual buttons, predefined built-in
 * actions are zoom-in and zoom-out.
 *
 * The document descriptor may reference an empty document, the application may assign the document
 * dynamically, see @ref SPAcquireSetDocumentContent, @ref SPGuiAcquSetDocumentContent).
 * The application may add one or more virtual virtual buttons dynamically (see @ref SPAcquireRegisterDocumentRect,
 * @ref SPGuiAcquRegisterDocumentRect).
 * <br> A typical application will load the generic document descriptor with empty content. It will then render the
 * document to an image and set document content. The application may register virtual buttons for all
 * entry fields in the document.
 * <br> The application may modify the visual representation of a virtual button whenever the virtual button is
 * registered again (the button id defines which virtual button will be overwritten).
 * <br> Virtual buttons in a document require an Action attribute, which must ne "none" for buttons that
 * should invoke the registered listener or one of the predefined actions.
 *
 * @note The element SPSWCoordinate is mandatory in document descriptors (although the DTD marks it
 * optional).
 *
 * Example (C):
 @code
  void addBackroundDocument(pSPGUIACQU_T pSpGA, const char *aDocument, int aDocumentLen, RECT rcl)
  {
      char *pszDocument = 0;
      int rc;
      int iBase64 = 0;
      char *pszBase64 = 0;
      SPBase64Encode(aDocument, aDocumentLen, &pszBase64);
      iBase64 = strlen(pszBase64);
      pszDocument = malloc(iBase64 + 1024);
      _snprintf (pszDocument, iBase64 + 1024,
              "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
              "<!DOCTYPE SPSWObjects SYSTEM "SPSWObjects.dtd">\n"
              " <SPSWDocumentFields>\n"
              "   <SPSWDocument DrawFlags=\"%d\" Format=\"3\">\n"
              "      <SPSWCoordinate Origin=\"tablet\" Left=\"%d\" Top=\"%d\" Right=\"%d\" Bottom=\"%d\" />\n"
              "    %s\n"
              "    <SPSWSlider DrawFlags=\"%d\" Clickable=\"pen-and-mouse\" orientation=\"vertical\" " 
                    " Foreground=\"0x008000\" >\n" 
                 "</SPSWSlider>\n" 
              "    <SPSWSlider DrawFlags=\""%d" Clickable=\"pen-and-mouse\" orientation=\"horizontal\" " 
                   " Foreground=\"0x008000\" >" 
              "      <SPSWCoordinate Origin=\"Tablet\" Left=\"0\" Right=\"950\" Top=\"850\" Bottom=\"900\" />\n" 
                   "</SPSWSlider>\n" 
              "    <SPSWVirtualButton DrawFlags=\"" + iDrawFlags + "\" Clickable=\"pen-and-mouse\" "  
                   " Foreground=\"0x008000\" Action=\"zoom-in\" Id=\"0x10000\">" 
              "      <SPSWCoordinate Origin=\"Tablet\" Left=\"100\" Right=\"150\" Top=\"0\" Bottom=\"100\" />\n" 
              "      <SPSWText DrawFlags=\"%d\" Group=\"ButtonGroup\">\n" 
              "        <SPSWFont Face=\"Helvetica\" Size=\"0\" />\n + \n" 
              "      </SPSWText>\n" 
              "    </SPSWVirtualButton>\n" 
              "    <SPSWVirtualButton DrawFlags=\"%d\" Clickable=\"pen-and-mouse\" "  
                   " Foreground=\"0x008000\" Action=\"zoom-out\" Id=\"0x10001\">" 
              "      <SPSWCoordinate Origin=\"Tablet\" Left=\"180\" Right=\"230\" Top=\"0\" Bottom=\"100\" />\n" +
              "      <SPSWText DrawFlags=\"%d\" Group=\"ButtonGroup\">\n" +
              "        <SPSWFont Face=\"Helvetica\" Size=\"0\" />\n - \n" 
              "      </SPSWText>\n" 
              "    </SPSWVirtualButton>\n" 
              "   </SPSWDocument>\n"
              " </SPSWDocumentFields>\n",
              0x13, // SPSW_IMAGE_DRAW_TABLET | SPSW_IMAGE_DRAW_SCREEN | SPSWIMAGE_DRAW_TRANSPARENT,
              rcl.left, rcl.top, rcl.right, rcl.bottom,
              pszBase64,
              0x13 ,
              0x13 ,
              0x13 , 0x13,
              0x13 , 0x13
              );
      rc = SPGuiAcquAddBackgroundDocument(pSpGA, pszDocument);
      free(pszDocument;
      SPFreeString(&pszBase64);
      return rc;
  }
 @endcode
 *
 * @section sec_ObjectDescriptionDTD Mixed image, document and text fields
 * It may be required to dynamically draw images, documents, text and rectangle on the screen of a tablet. 
 * Images, Documents, Rectangles and text are passed
 * in a call to @ref SPGuiAcquAddBackgroundObject. This function requires a string containing an XML document 
 * that is interpreted according to @ref sec_SignWareDTD.
 *
 * Please use the XML declaration to specify the character encoding of
 * the XML document. Supported encodings are ASCII, UTF-8, and ISO-8859-1.
 * Don't forget to use character references for '"' (\&quot;), '&' (\&amp;),
 * and '<' (\&lt;).
 *
 * @note SPGuiAcquAddBackgroundObject allows SPSWRect, SPSWRectfields, SPSWVirtualButton, SPSWVirtualButtonfields, 
 * SPSWText, SPSWTextfields, SPSWImage, SPSWImageFields, SPSWDocument and SPSWDocumentFields elements.
 * SPSWRect, SPSWRectfields are 
 * not assigned an action, these elements will only be drawn. SPSWVirtualButton, SPSWVirtualButtonfields
 * will be assigned to an action defined by the id that must be specified.
 *
 * @section sec_SignWareDTD SPSignware XML Document Type Description
 * All SignWare XML strings must comply with these rules (DTD):
 *
 * @verbinclude SPSWObjects.dtd
 */

/**
 */
#ifndef SPGUIACQU_H__
#define SPGUIACQU_H__
#include "SPSignWare.h"

/*==============================================================*
 * Constant definitions                                         *
 *==============================================================*/

/*==============================================================*
 * Structures and type definitions                              *
 *==============================================================*/

#ifdef SP_TARGET_LINUX
#ifndef SP_DEFINED_LONG
#define SP_DEFINED_LONG
typedef long LONG;
#endif
#ifndef SP_DEFINED_RECT
#define SP_DEFINED_RECT
typedef struct _RECT
{
  LONG left;
  LONG top;
  LONG right;
  LONG bottom;
} RECT, *PRECT, *LPRECT;
#endif
#endif

/*==============================================================*
 * Function declarations                                        *
 *==============================================================*/
#ifdef __cplusplus
extern "C" {
#endif  /* __cplusplus */

/**
 * @brief Callback function that is called when a timeout occurs.
 *
 * A pointer to a function that is called to notify the application
 * about a timeout condition during acquiry mode.
 *
 * @param ulOptParameter [i]
 *     the user-defined parameter that was passed when the callback function
 *     was registered.
 * @return 0 on success, else error code, error codes are not evaluated
 * @see SPGuiAcquAcquire, SPGuiAcquSetTimeout
 */
typedef int (SPCALLBACK * pSPGUIACQUTIMEOUT_T)(SPVPTR ulOptParameter);

/**
 * @brief Callback function that is called when a timeout occurs.
 *
 * A pointer to a function that is called to notify the application
 * about a timeout condition during acquiry mode.
 *
 * @param pSpGuiAcqu [i]
 *     pointer to the associated SPGuiAcqu object
 * @return 0 on success, else error code, error codes are not evaluated
 * @see SPGuiAcquAcquire, SPGuiAcquSetTimeout
 */
typedef int (SPCALLBACK * pSPGUIACQUTIMEOUT2_T)(pSPGUIACQU_T pSpGuiAcqu);

/**
 * @brief Callback function that is called when the tablet hardware status changes,
 * please read @ref sec_TabletStatusChanges "tablet status change notifications" 
 * for more details.
 *
 * A pointer to a function that is called to notify the application
 * about tablet hardware status changes.
 *
 * @param pSpGuiAcqu [i]
 *     pointer to the associated SPGuiAcqu object
 * @param iMajor [i]
 *     major event description
 * @param iDetail detail event description
 * @return 0 on success, else error code, error codes are not evaluated
 * @see SPGuiAcquSetStatusListener
 */
typedef int (SPCALLBACK * pSPGUIACQUSTATUS_T)(pSPGUIACQU_T pSpGuiAcqu, int iMajor, int iDetail);

/**
 * @brief Callback function that is called when a virtual button (registered rectangle)
 *        is 'clicked'.
 *
 * @param pSpGuiAcqu [i] pointer to the associated pSPGUIACQU_T object
 * @param uId [i]
 *      the identifier of the rectangle that was clicked.
 * @return 0 on success, else error code, error codes are not evaluated
 * @see SPGuiAcquRegisterRect, SPGuiAcquRegisterRect2
 */
typedef int (SPCALLBACK *pSPGUIACQURECTLISTENER_T)(pSPGUIACQU_T pSpGuiAcqu, SPUINT32 uId);

/**
 * @brief Callback function that is called when a virtual button (registered rectangle)
 *        is 'clicked'.
 *
 * @param pSpGuiAcqu [i] pointer to the associated pSPGUIACQU_T object
 * @param uDocId [i]
 *      the identifier of the document that was clicked.
 * @param uRectId [i]
 *      the identifier of the rectangle that was clicked.
 * @return 0 on success, else error code, error codes are not evaluated
 * @see SPGuiAcquRegisterRect, SPGuiAcquRegisterRect2
 */
typedef int (SPCALLBACK *pSPGUIACQUDOCRECTLISTENER_T)(pSPGUIACQU_T pSpGuiAcqu, SPUINT32 iDocId, SPUINT32 uRectId);

/**
 * @brief Callback function that is called when a hardware button is pressed
 *        on the tablet.
 *
 * A pointer to a function that is called to notify the application
 * about a hardware tablet button being pressed during acquiry mode.
 *
 * @param pSpGuiAcqu [i]
 *      pointer to the SPGuiAcqu object for which the callback function
 *      has been registered.
 * @param iButtonId [i]
 *      a value identifying the button that was pressed.  The value depends
 *      on the tablet, see @ref page_TabletHardwareButtons
 * @param iPress [i] the value depends on the tablet, see @ref page_TabletHardwareButtons.
 *  
 * @see SPGuiAcquSetButtonListener
 * @return 0 on success, else error code, error codes are not evaluated
 */
typedef int (SPCALLBACK * pSPGUIACQUBUTTON_T)(pSPGUIACQU_T pSpGuiAcqu, SPINT32 iButtonId, SPINT32 iPress);

/**
 * @brief Callback function that is called for each vector.
 *
 * A pointer to a function that is called for every significant vector
 * (sample) received from the tablet in acquiry mode.
 *  
 * @note SPAcquire handles all vectors internally, typically an application 
 * does not handle vectors. 
 *
 * @param pSpGuiAcqu [i]
 *      pointer to the SPGuiAcqu object that generated the event.
 * @param iX [i]
 *      the X coordinate (in tablet coordinates) of the vector.
 * @param iY [i]
 *      the Y coordinate (in tablet coordinates) of the vector.
 * @param iPress [i]
 *      the pressure value of the vector, normalized to 0 through 1023.
 * @param iTime [i]
 *      the time value of the vector, may be -1 if the time is not measured.
 * @return always @ref SP_NOERR, currently ignored.
 */
typedef int (SPCALLBACK * pSPGUIACQULINETO_T)(pSPGUIACQU_T pSpGuiAcqu, SPINT32 iX, SPINT32 iY, SPINT32 iPress, SPINT32 iTime);

/**
 * @brief Create an SPGuiAcqu object (window).
 *  
 * SPGuiAcquNew creates the native object, but does not instantiate any visual 
 * components. 
 * <br>Call SPGuiAcquSetClient to create the visual components. 
 *  
 * @note The calling sequence SPGuiAcquNew and SPGuiAcquSetClient equals the call 
 * SPGuiAcquCreate or SPGuiAcquCreateInClient 
 *  
 * @param ppSPGuiAcqu [o]
 *      pointer to a variable that will be filled with a pointer to a new
 *      SPGuiAcqu object.  The caller is responsible for deallocating the
 *      new object by calling @ref SPGuiAcquFree.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_MEMERR        out of memory
 *     .
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPGuiAcquSetClient, SPGuiAcquFree
 * @ref gui_spGuiAcqu "SPGuiAcqu"
 *
 * @todo Implement for Linux
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquNew(pSPGUIACQU_T *ppSPGuiAcqu);

/**
 * @brief Create visual components for a SPGuiAcqu object.
 *
 * If @a hwndChild is a valid window handle then SPGuiAcqu subclasses the
 * native window identified by @a hwndChild. It uses this window to draw
 * background objects and tablet strokes, and sends user messages to this
 * window with message ID's starting at WM_USER + 1000.
 *
 * If @a hwndChild is a not valid window handle then SPGuiAcqu creates a native
 * window. It sends user messages to the created window with message ID's starting
 * at WM_USER + 1000.
 *
 * @param pSPGuiAcqu [i]
 *      a valid SPGuiAcqu object, as created by SPGuiAcquNew.
 * @param hwndParent [i]
 *      window handle of the parent window.
 * @param hwndChild [i]
 *      window handle of the child window to use, may be NULL.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_MEMERR        out of memory
 *     .
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPGuiAcquCreate, SPGuiAcquFree, SPGuiAcquSetBoolProperty
 * @ref gui_spGuiAcqu "SPGuiAcqu"
 *
 * @todo Implement for Linux
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquSetClient(pSPGUIACQU_T pSPGuiAcqu, SPHWND hwndChild, SPHWND hwndParent);

/**
 * @brief Create an SPGuiAcqu object (window).
 *
 * The default draw mode is set to @ref SP_RELEASE_FOCUS | SP_VIRTUAL_BUTTON_CLICK.
 *
 * SPGuiAcqu creates a native window. It sends user messages to this
 * window with message ID's starting at WM_USER + 1000.
 *
 * @param ppSPGuiAcqu [o]
 *      pointer to a variable that will be filled with a pointer to a new
 *      SPGuiAcqu object.  The caller is responsible for deallocating the
 *      new object by calling @ref SPGuiAcquFree.
 * @param hwndParent [i]
 *      window handle of the parent window.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_MEMERR        out of memory
 *     .
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPGuiAcquCreateInClient, SPGuiAcquFree, SPGuiAcquSetBoolProperty
 * @ref gui_spGuiAcqu "SPGuiAcqu"
 *
 * @todo Implement for Linux
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquCreate(pSPGUIACQU_T *ppSPGuiAcqu, SPHWND hwndParent);

/**
 * @brief Create an SPGuiAcqu object inside a given window.
 *
 * The default draw mode is set to @ref SP_RELEASE_FOCUS | SP_VIRTUAL_BUTTON_CLICK.
 *
 * If @a hwndChild is a valid window handle then SPGuiAcqu subclasses the
 * native window identified by @a hwndChild. It uses this window to draw
 * background objects and tablet strokes, and sends user messages to this
 * window with message ID's starting at WM_USER + 1000.
 *
 * If @a hwndChild is a not valid window handle then SPGuiAcqu creates a native
 * window. It sends user messages to the created window with message ID's starting
 * at WM_USER + 1000.
 *
 * @param ppSPGuiAcqu [o]
 *      pointer to a variable that will be filled with a pointer to a new
 *      SPGuiAcqu object.  The caller is responsible for deallocating the
 *      new object by calling @ref SPGuiAcquFree.
 * @param hwndParent [i]
 *      window handle of the parent window.
 * @param hwndChild [i]
 *      window handle of the child window to use.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_MEMERR        out of memory
 *     .
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPGuiAcquCreate, SPGuiAcquFree, SPGuiAcquSetBoolProperty
 * @ref gui_spGuiAcqu "SPGuiAcqu"
 *
 * @todo Implement for Linux
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquCreateInClient(pSPGUIACQU_T *ppSPGuiAcqu, SPHWND hwndChild, SPHWND hwndParent);

/**
 * @brief Free all resources used by an SPGuiAcqu object.
 *
 * The SPGuiAcqu object must have been created by
 * @ref SPGuiAcquCreate, @ref SPGuiAcquCreateInClient.
 *
 * It is an error to free an SPGuiAcqu object while processing a
 * windows message for the window handle assigned to that SPGuiAcqu
 * object.
 *
 * @param ppSPGuiAcqu [io]
 *      pointer to a variable containing a pointer to an SPGuiAcqu object.
 *      The variable will be set to NULL if this function succeeds.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPGuiAcquCreate, SPGuiAcquCreateInClient
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquFree(pSPGUIACQU_T *ppSPGuiAcqu);

/**
 * @brief Get the window handle of the window associated with an
 *        SPGuiAcqu object.
 *
 * For an SPGuiAcqu object created with SPGuiAcquCreateInClient, this
 * function returns the handle of the client window.
 *
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param pHwnd [o]
 *      pointer to a variable that will be filled with the window handle
 *      of the window associated with the SPGuiAcqu object.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPGuiAcquCreate, SPGuiAcquCreateInClient
 *
 * @todo Implement for Linux
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquGetHwnd(pSPGUIACQU_T pSPGuiAcqu, SPHWND *pHwnd);

/**
 * @brief Get the rectangle (size) of an SPGuiAcqu object's window.
 *
 * The returned rectangle reflects the size and position of the
 * SPGuiAcqu window in client coordinates.
 *
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param pRect [o]
 *      pointer to a variable that will be filled with the window rectangle
 *      of the window associated with the SPGuiAcqu object.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPGuiAcquCreate, SPGuiAcquGetTabletRect
 *
 * @todo Implement for Linux
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquGetHwndRect(pSPGUIACQU_T pSPGuiAcqu, RECT *pRect);

/**
 * @brief Get the rectangle (size) of an SPGuiAcqu object's tablet window.
 *
 * The returned rectangle reflects the size and position of the tablet
 * window in client coordinates, relative to the SPGuiAcqu window. The
 * tablet window is always smaller than the SPGuiAcqu window, as the
 * zoom factor is calculated such that the aspect ratio of the tablet
 * hardware is maintained and the entire tablet will be visible within
 * the SPGuiAcqu window.
 *
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param pRect [o]
 *      pointer to a variable that will be filled with the window rectangle
 *      of the tablet window associated with the SPGuiAcqu object.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPGuiAcquCreate, SPGuiAcquGetHwndRect
 *
 * @todo Implement for Linux
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquGetTabletRect(pSPGUIACQU_T pSPGuiAcqu, RECT *pRect);

/**
 * @brief Set a property
 *
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param pszName [i] Name of the property, see @ref sec_SpGuiAcquProperties "SPGuiAcqu Properties"
 * @param iValue [i] the value of the property
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_UNSUPPORTEDERR    unsupported property, unknown property name
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquSetIntProperty(pSPGUIACQU_T pSPGuiAcqu, const SPCHAR *pszName, SPINT32 iValue);

/**
 * @brief Query a property
 *
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param pszName [i] Name of the property, see @ref sec_SpGuiAcquProperties "SPGuiAcqu Properties"
 * @param piValue [i] pointer to avariable that will be filled with the value of the property
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_UNSUPPORTEDERR    unsupported property, unknown property name
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquGetIntProperty(pSPGUIACQU_T pSPGuiAcqu, const SPCHAR *pszName, SPINT32 *piValue);

/**
 * @brief Set a property
 *
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param pszName [i] Name of the property, see @ref sec_SpGuiAcquProperties "SPGuiAcqu Properties"
 * @param bValue [i] the value of the property
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_UNSUPPORTEDERR    unsupported property, unknown property name
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquSetBoolProperty(pSPGUIACQU_T pSPGuiAcqu, const SPCHAR *pszName, SPBOOL bValue);

/**
 * @brief Query a property
 *  
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param pszName [i] Name of the property, see @ref sec_SpGuiAcquProperties "SPGuiAcqu Properties"
 * @param pbValue [i] pointer to avariable that will be filled with the value of the property
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_UNSUPPORTEDERR    unsupported property, unknown property name
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquGetBoolProperty(pSPGUIACQU_T pSPGuiAcqu, const SPCHAR *pszName, SPBOOL *pbValue);

/**
 * @brief Get the size of the border in an SPGuiAcqu object.
 *
 * The border size is 5 pixels by default.
 *
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param piBorder [o]
 *      pointer to a variable that will be filled with the border size
 *      (in screen pixels).
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPGuiAcquCreate, SPGuiAcquSetBorder
 *
 * @todo Implement for Linux
 */
INLINE SPINT32 SPGuiAcquGetBorder(pSPGUIACQU_T pSPGuiAcqu, SPINT32 *piBorder) { return SPGuiAcquGetIntProperty(pSPGuiAcqu, "ScrBorder", piBorder); }

/**
 * @brief Set the size of the border in an SPGuiAcqu object.
 *
 * The border size is 5 pixels by default.
 *
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param iBorder [i]
 *      the new border size (in screen pixels)
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPGuiAcquCreate, SPGuiAcquGetBorder
 *
 * @todo Implement for Linux
 */
INLINE SPINT32 SPGuiAcquSetBorder(pSPGUIACQU_T pSPGuiAcqu, SPINT32 iBorder) { return SPGuiAcquSetIntProperty(pSPGuiAcqu, "ScrBorder", iBorder); }

/**
 * @brief Set the background color.
 *
 * The background color is used to draw a pen stroke that has zero
 * pressure. It will also be used to erase the background if
 * @ref SP_ERASE_BACKGROUND is set.
 *
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param iBackgroundColor [i]
 *      the new background color as integer 0xrrggbb with rr = red, 
 *      gg = green, bb = blue, each color being in the range 0 through 0xff.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPGuiAcquCreate, SPGuiAcquGetBackgroundColor, SPGuiAcquSetForegroundColor
 *
 * @todo Implement for Linux
 */
INLINE SPINT32 SPGuiAcquSetBackgroundColor(pSPGUIACQU_T pSPGuiAcqu, SPINT32 iBackgroundColor) { return SPGuiAcquSetIntProperty(pSPGuiAcqu, "BackgroundColor", iBackgroundColor); }

/**
 * @brief Get the background color.
 *
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param piBackgroundColor [i]
 *      pointer to a variable that will be filled with the background color
 *      (see @ref SPGuiAcquSetBackgroundColor for details).
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPGuiAcquCreate, SPGuiAcquGetForegroundColor, SPGuiAcquSetBackgroundColor
 *
 * @todo Implement for Linux
 */
INLINE SPINT32 SPGuiAcquGetBackgroundColor(pSPGUIACQU_T pSPGuiAcqu, SPINT32 *piBackgroundColor) { return SPGuiAcquGetIntProperty(pSPGuiAcqu, "BackgroundColor", piBackgroundColor); }

/**
 * @brief Set the foreground color.
 *
 * The foreground color is used to draw a pen stroke that has maximum
 * pressure.
 *
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param iForegroundColor [i]
 *      the new foreground color as integer 0xrrggbb with rr = red, 
 *      gg = green, bb = blue, each color being in the range 0 through 0xff.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_APPLERR       object was created by SPGuiAcquCreateWithoutWindow
 *     .
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPGuiAcquCreate, SPGuiAcquGetForegroundColor, SPGuiAcquSetBackgroundColor
 *
 * @todo Implement for Linux
 */
INLINE SPINT32 SPGuiAcquSetForegroundColor(pSPGUIACQU_T pSPGuiAcqu, SPINT32 iForegroundColor) { return SPGuiAcquSetIntProperty(pSPGuiAcqu, "ForegroundColor", iForegroundColor); }

/**
 * @brief Get the foreground color.
 *
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param piForegroundColor [i]
 *      pointer to a variable that will be filled with the foreground color
 *      (see @ref SPGuiAcquSetForegroundColor for details).
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPGuiAcquCreate, SPGuiAcquGetBackgroundColor, SPGuiAcquSetForegroundColor
 *
 * @todo Implement for Linux
 */
INLINE SPINT32 SPGuiAcquGetForegroundColor(pSPGUIACQU_T pSPGuiAcqu, SPINT32 *piForegroundColor) { return SPGuiAcquGetIntProperty(pSPGuiAcqu, "ForegroundColor", piForegroundColor); }

/**
 * @brief Set the draw mode of an SPGuiAcqu object.
 *
 * The tablet area may be smaller than the window area because the
 * tablet area will be zoomed to maintain the aspect ratio of the
 * tablet hardware.
 *
 * @ref SP_RELEASE_FOCUS is implemented by subclassing the parent window.
 * The subclassing is released when acquiry mode is stopped.
 *
 * @ref SP_RELEASE_FOCUS causes
 * @ref SPTabletAcquireDone(SPGuiAcquGetTablet(pSpGui))
 * to be called when loosing focus and
 * @ref SPTabletAcquire(SPGuiAcquGetTablet(pSpGui), SPGuiAcquGetHwnd(pSpGui))
 * to be called when gaining focus.
 *
 * The pen position is normally drawn as a caret. Carets cannot be used
 * when the client window is not the topmost window. The emulated pen cursor
 * is available for these cases. However the emulated pen cursor may not be
 * erased in all cases - especially if the application draws on the client area.
 *
 * @note Do not change the draw mode once acquiry mode is turned on.
 * <br> Use @ref SPGuiAcquSetBoolProperty instead 
 *
 * @param pSpGui [i]
 *      pointer to an SPGuiAcqu object.
 * @param iDrawMode [i] drawing mode, a combination of:
 *  - @ref SP_DRAW_TABLET_BORDER draw a rectangle around the tablet area
 *  - @ref SP_DRAW_HWND_BORDER   draw a rectangle around the display window
 *  - @ref SP_RELEASE_FOCUS      pause acquiry mode when the parent window looses focus
 *  - @ref SP_ERASE_BACKGROUND   explicitly erase the background
 *  - @ref SP_EMULATE_PEN_CURSOR   draw a cursor at the pen position using a caret
 *  - @ref SP_DISABLE_CURSOR     don't draw a cursor, this is useful on TabletPCs
 *  - @ref SP_DRAW_BACKGROUND_IMAGE draw the image in the signing region of the client window
 *  - @ref SP_VIRTUAL_BUTTON_MODE  don't draw any strokes neither on PC screen nor on tablet LCD screen
 *  - @ref SP_DRAW_TABLET_IMAGE_IN_WINDOW draw the tablet LCD image on the PC screen. This should be used for debug purposes only
 *  - @ref SP_DRAW_MIRROR_TABLET Mirror the tablet along the horizontal axes
 *  - @ref SP_VIRTUAL_BUTTON_CLICK  set the virtual button click mode
 *  - @ref SP_DRAW_BUFFERED       turn on double buffering when drawing the entry region to prevent flickering screen updates
 *  .
 * 
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 * 
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SP_DRAW_TABLET_BORDER, SP_DRAW_HWND_BORDER, SP_RELEASE_FOCUS, SP_ERASE_BACKGROUND, SP_EMULATE_PEN_CURSOR, 
 * SP_DISABLE_CURSOR, SP_VIRTUAL_BUTTON_MODE, SP_DRAW_BACKGROUND_IMAGE, SP_DRAW_TABLET_IMAGE_IN_WINDOW, 
 * SP_DRAW_MIRROR_TABLET, SP_VIRTUAL_BUTTON_CLICK
 * @see SPGuiAcquSetBoolProperty, SPGuiAcquGetTablet, SPGuiAcquGetHwnd, SPTabletAcquire, SPTabletAcquireDone
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquSetDrawMode(pSPGUIACQU_T pSpGui, SPINT32 iDrawMode);

/**
 * @brief Get the draw mode of an SPGuiAcqu object.
 *
 * @note Use @ref SPGuiAcquGetBoolProperty instead 
 *  
 * @param pSpGui [i]
 *      pointer to an SPGuiAcqu object.
 * @param piDrawMode [o]
 *      pointer to a variable that will be filled with the draw mode.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 * 
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPGuiAcquGetBoolProperty
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquGetDrawMode(pSPGUIACQU_T pSpGui, SPINT32 *piDrawMode);

/**
 * @brief Set the timeout of an acquiry of an SPGuiAcqu object.
 *
 * The timeout handler will be called if there was no pen stroke for the duration of
 * @em iTimeout milliseconds.
 *
 * @param pSpGui [i]
 *      pointer to an SPGuiAcqu object.
 * @param pTimeoutListener [i]
 *      function that will be called when the timeout expires.
 * @param ulOptParameter [i]
 *      user-defined parameter that will be passed to @a pTimeoutListener
 *      (not used by SignWare).
 * @param iTimeout [i]
 *      timeout (in milliseconds) or 0 to disable timeout checking.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquSetTimeout(pSPGUIACQU_T pSpGui, pSPGUIACQUTIMEOUT_T pTimeoutListener, SPVPTR ulOptParameter, SPINT32 iTimeout);

/**
 * @brief Set the timeout of an acquiry of an SPGuiAcqu object.
 *
 * The timeout handler will be called if there was no pen stroke for the duration of
 * @em iTimeout milliseconds.
 *
 * @param pSpGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param iTimeout [i]
 *      timeout (in milliseconds) or 0 to disable timeout checking.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquSetTimeout2(pSPGUIACQU_T pSpGuiAcqu, SPINT32 iTimeout);

/**
 * @brief Set the hardware status listener of an SPGuiAcqu object.
 *
 * @param pSpGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param pNotifyStatus [i]
 *      function that is to be called when a hardware status of the tablet changes,
 *      or when the tablet driver reports errors.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPTabletSetStatusListener 
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquSetStatusListener(pSPGUIACQU_T pSpGuiAcqu, pSPGUIACQUSTATUS_T pNotifyStatus);

/**
 * @brief Set a vector listener of an SPAcquire object.
 *
 * @param pSpGuiAcqu [i]
 *      pointer to an SPAcquire object.
 * @param pNotifyVector [i]
 *      function that is to be called when a vector was captured.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquSetVectorListener(pSPGUIACQU_T pSpGuiAcqu, pSPGUIACQULINETO_T pNotifyVector);

/**
 * @brief Set the hardware status listener of an SPGuiAcqu object.
 *
 * @param pSpGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param pNotifyTimeout [i]
 *      function that is to be called when the timeout expires
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPTabletSetStatusListener 
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquSetTimeoutListener(pSPGUIACQU_T pSpGuiAcqu, pSPGUIACQUTIMEOUT2_T pNotifyTimeout);

/**
 * @brief Get the associated SPTablet object.
 *
 * @ref SP_PARAMERR will be returned if the tablet has not yet been
 * created. You should neither register any listeners in the returned
 * tablet nor set any properties. The object is available to get
 * tablet type, size etc. only.
 * 
 * @note The returned tablet object is not a copy. Do not free this object.
 * 
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param ppTablet [o]
 *      pointer to a variable that will receive a pointer to the SPTablet
 *      object of the SPGuiAcqu object.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPGuiAcquCreateTablet
 *
 * @par Example:
 * @code 
 * int getTabletSize(pSPGUIACQU_T pGuiAcqu, SIZE *pSize)
 * {
 *     pSPTABLET_T pTablet = 0;
 *     int rc = SPGuiAcquGetTablet(pGuiAcqu, &pTablet);
 *     if(rc != SP_NOERR) return rc;
 *     int iWidth, iHeight;
 *     rc = SPTabletGetTabletSize(pTablet, &iWidth, &iHeight);
 *     if(rc != SP_NOERR) return rc;
 *     pSize->cx = iWidth;
 *     pSize->cy = iHeight;
 *     pTablet = 0;
 *     return SP_NOERR;
 * }
 * @endcode
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquGetTablet(pSPGUIACQU_T pSPGuiAcqu, pSPTABLET_T *ppTablet);

/**
 * @brief Create the native tablet object that is required to connect to
 *        or acquire from the tablet hardware.
 *
 * This is a convenience function provided for applications that might
 * need to access the tablet driver before it is connected. The tablet
 * driver object will be created when it is internally required, the
 * application does not have to call this function.
 *
 * A typical use for this function would be to select an image
 * depending on the tablet device. Create the tablet driver object,
 * get the device ID, pass the device-specific image, and then
 * connect to the tablet.
 *
 * Please read @ref page_TabletCreation for a list of supported drivers
 * 
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param iDriver [i] the driver number, pass SP_UNKNOWN_DRV to use any driver.
 * 
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_BUSYERR       the device is used by another application
 *     - @ref SP_UNSUPPORTEDERR the tablet is not supported in this context
 *     - @ref SP_NOPADERR      no tablet found
 *     .
 * 
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPGuiAcquGetTablet
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquCreateTablet(pSPGUIACQU_T pSPGuiAcqu, SPINT32 iDriver);

/**
 * @brief Create a native tablet object specified by class name.
 *
 * This is a convenience function provided for applications that might
 * need to access the tablet driver before it is connected. In most
 * other cases the tablet driver object will be created when it is
 * internally required, the application does not have to call this
 * function.
 *
 * A typical use for this function would be to select an image
 * depending on the tablet device. Create the tablet driver object,
 * get the device ID, pass the device specific image, and then
 * connect to the tablet.
 *
 * This function will not reinstantiate the tablet driver if a driver
 * already exists.
 *
 * Please read @ref page_TabletCreation for a list of supported options
 * 
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param pszTabletClass [i]
 *      class name of the SOFTPRO tablet access module.
 * @param pszConfig [i]
 *      pass optional configuration data. Configuration data depends
 *      on the detected hardware driver (see @ref pg_PadInstallation).
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_BUSYERR       the device is used by another application
 *     - @ref SP_UNSUPPORTEDERR the tablet is not supported in this context
 *     - @ref SP_NOPADERR      no tablet found
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPGuiAcquConnectEx, SPGuiAcquDisconnect, SPGuiAcquAcquire, SPGuiAcquAcquireDone, SPTabletCreateEx
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquCreateTabletEx(pSPGUIACQU_T pSPGuiAcqu, const char *pszTabletClass, const char *pszConfig);

/**
 * @brief Create a new SPTablet object based on an Alias.
 * 
 * Please read @ref page_TabletCreation for resolving the Alias
 * 
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param pszAlias [i] the alias name of the tablet
 * 
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter, e. g.pszAlias is NULL or empty
 *   - @ref SP_MEMERR        out of memory
 *   - @ref SP_BUSYERR       the device is used by another application
 *   - @ref SP_NOPADERR      the device is not accessible
 *   - @ref SP_INVALIDERR    alias not resolveable
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPTabletCreateByAlias, SPGuiAcquCreateTablet, SPGuiAcquCreateTabletEx, SPGuiAcquConnectByAlias
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquCreateTabletByAlias(pSPGUIACQU_T pSPGuiAcqu, const char *pszAlias);

/**
 * @brief Create a new SPTablet object based on an enumeration.
 * 
 * Please read @ref page_TabletCreation for tablet enumeration.
 * 
 * @note This function creates a default tablet if spDescriptor is NULL 
 *  
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param spDescriptor [i] the descriptor of the tablet as returned from a pSPTABLETENUM object
 * 
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter, e. g.pszAlias is NULL or empty
 *   - @ref SP_MEMERR        out of memory
 *   - @ref SP_BUSYERR       the device is used by another application
 *   - @ref SP_NOPADERR      the device is not accessible
 *   - @ref SP_INVALIDERR    alias not resolveable
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPTabletCreateByEnum, SPGuiAcquCreateTablet, SPGuiAcquCreateTabletEx, SPGuiAcquConnectByEnum
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquCreateTabletByEnum(pSPGUIACQU_T pSPGuiAcqu, pSPPROPERTYMAP_T spDescriptor);

/**
 * @brief Clear all internal signature data of any acquiries of an
 *        SPGuiAcqu object.
 *
 * This function will clear the SPReference object that is embedded in this
 * object; this means that all signatures that were entered so far will be deleted.
 * This function may be required to reenter a signature / reference
 * when the prior entry was not accepted, e.g., because the reference
 * did not satisfy the quality criteria.
 *
 * @param pSpGui [i] pointer to an SPGuiAcqu object.
 * @param iFlags [i] reserved parameter, should be 0.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquClearEntries(pSPGUIACQU_T pSpGui, int iFlags);

/**
 * @brief Connect to a tablet specified by driver number.
 *
 * Please read @ref page_TabletCreation for a list of supported drivers
 * 
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param iDriver [i] the driver number, pass SP_UNKNOWN_DRV to use any driver.
 * 
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_BUSYERR       the tablet is in use by another application
 *     - @ref SP_UNSUPPORTEDERR the tablet is not supported in this context
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPGuiAcquCreate, SPGuiAcquFree
 * @see SP_UNKNOWN_DRV, SP_WINTAB_DRV, SP_PADCOM_DRV, SP_NATIVE_DRV, SP_TCP_DRV
 * @see SPGuiAcquConnectEx, SPGuiAcquCreateTablet, SPTabletConnect, SPTabletDisconnect
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquConnect(pSPGUIACQU_T pSPGuiAcqu, SPINT32 iDriver);

/**
 * @brief Connect to a tablet specified by class name.
 *
 * Please read @ref page_TabletCreation for a list of supported options
 * 
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param pszTabletClass [i]
 *      the class name of SOFTPRO tablet access module.
 * @param pszConfig [i]
 *      pass optional configuration data. 
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_BUSYERR       the tablet is in use by another application
 *     - @ref SP_UNSUPPORTEDERR the tablet is not supported in this context
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * 
 * @see SPGuiAcquConnect, SPGuiAcquCreate, SPGuiAcquFree
 * @see SP_UNKNOWN_DRV, SP_WINTAB_DRV, SP_PADCOM_DRV, SP_NATIVE_DRV, SP_TCP_DRV
 * @see SPGuiAcquCreateTabletEx, SPTabletConnect, SPTabletDisconnect, SPTabletCreateEx
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquConnectEx(pSPGUIACQU_T pSPGuiAcqu, const char *pszTabletClass, const char *pszConfig);

/**
 * @brief Connect to a tablet specified by an alias name.
 * 
 * Please read @ref page_TabletCreation for resolving the Alias
 * 
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param pszAlias [i] the alias name of the tablet
 * 
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter, e. g.pszAlias is NULL or empty
 *   - @ref SP_MEMERR        out of memory
 *   - @ref SP_BUSYERR       the device is used by another application
 *   - @ref SP_NOPADERR      the device is not accessible
 *   - @ref SP_INVALIDERR    alias not resolveable
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPTabletCreateByAlias, SPGuiAcquConnect, SPGuiAcquConnectEx, SPGuiAcquCreateTabletByAlias
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquConnectByAlias(pSPGUIACQU_T pSPGuiAcqu, const char *pszAlias);

/**
 * @brief Connect to a tablet specified by a descriptor.
 * 
 * Please read @ref page_TabletCreation for resolving the enumeration
 * 
 * @note This function connects with the default tablet if spDescriptor is NULL 
 *  
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param spDescriptor [i] the enumarated tablet descriptor
 * 
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter, e. g.pszAlias is NULL or empty
 *   - @ref SP_MEMERR        out of memory
 *   - @ref SP_BUSYERR       the device is used by another application
 *   - @ref SP_NOPADERR      the device is not accessible
 *   - @ref SP_INVALIDERR    alias not resolveable
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPTabletCreateByAlias, SPGuiAcquConnect, SPGuiAcquConnectEx, SPGuiAcquCreateTabletByAlias
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquConnectByEnum(pSPGUIACQU_T pSPGuiAcqu, pSPPROPERTYMAP_T spDescriptor);

/**
 * @brief Disconnect from a tablet.
 *
 * @param pSPGuiAcqu [i] pointer to an SPGuiAcqu object.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPReferenceCreateFromGuiAcqu, SPTabletConnect, SPTabletDisconnect
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquDisconnect(pSPGUIACQU_T pSPGuiAcqu);

/**
 * @brief Start tablet acquiry mode.
 *
 * Switch the tablet into acquiry mode.
 * 
 * SPTablet switches the tablet from pointer mode to pen entry mode
 * during acquiry. Any registered rectangles will be notified in pen
 * entry mode when the pen is pressed on a rectangle.
 *
 * Pen entry mode is exclusive and will not send any pointer move
 * notifications to any application.
 *
 * This function enables aquiry mode and returns immediately.  The actual 
 * state change of the tablet is signaled by callback functions, see
 * @ref SPAcquireSetStatusListener.
 * 
 * Further callbacks are called during aquiry mode, see
 * @ref SPAcquireSetTimeout, @ref SPAcquireRegisterRect, @ref SPAcquireRegisterRect2,
 * @ref SPAcquireSetButtonListener.
 *
 * Events resulting in callbacks being called are stored in a queue.
 * If the object was created by SPGuiAcquCreate or
 * SPGuiAcquCreateInClient, or if SP_GAWW_EVENTS was set in @a iFlags
 * of SPGuiAcquCreateWithoutWindow, the system's queue will be used,
 * that is, either the Windows message queue (for Windows) or the X11
 * event queue (for X11, not yet implemented).  If SP_GAWW_EVENTS was
 * not set in @a iFlags of SPGuiAcquCreateWithoutWindow, an event
 * queue internal to SignWare will be used.
 *
 * In all cases, the queue must be read.  This is done by
 * - using a message loop under Windows (SP_GAWW_EVENTS was set)
 * - or using an X11 event loop under Linux (SP_GAWW_EVENTS was set, not yet
 *   implemented)
 * - or calling SPGuiAcquAcquireWait
 * - or calling SPGuiAcquAcquireProcessMessages in a loop.
 * .
 *
 * SPGuiAcquAcquireWait processes events and waits until
 * SPGuiAcquAcquireDone is called, e. g. in response to a virtual
 * button click notification.
 *
 * @note Acquire mode will not be activated directly but may be delayed due to 
 * limitations caused by some drivers. This means that errors
 * that occur while processing the state switch may not be passed to the application.
 * <br> The application may set a timer to check the state of the tablet object, the state will be
 * SP_TABLET_STATE_ACQUIRE on success. Some drivers notify the application
 * if errors are detected while switching to acquiry mode by calling the
 * registered status callback, see @ref SPAcquireSetStatusListener.
 *
 * @param pSPGuiAcqu [i] pointer to an SPGuiAcqu object.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_BUSYERR       the device is used by another application
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPGuiAcquAcquireWait, SPTabletAcquire, SPTabletAcquireDone
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquAcquire(pSPGUIACQU_T pSPGuiAcqu);

/**
 * @brief Terminate tablet acquiry mode.
 *
 * Turn off tablet aquiry mode.
 *
 * This function makes SPGuiAcquAcquireWait return.
 *
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param iResult [i]
 *      command; either @ref SP_IDOK (add signature to reference)
 *      or @ref SP_IDCANCEL (ignore signature)
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPGuiAcquGetReference, SPGuiAcquGetSignature, SPTabletAcquire, SPTabletAcquireDone
 * @see SP_IDOK, SP_IDCANCEL
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquAcquireDone(pSPGUIACQU_T pSPGuiAcqu, SPINT32 iResult);

/** 
 * @cond INTERNAL
 */
/**
 * @brief Create an SPGuiAcqu object without window.
 *
 * Under Windows an invisible message window will be created. 
 * You can query the handle of that window by calling SPGuiAcquGetHwnd.
 * If SP_GAWW_EVENTS is set in @a iFlags, SPGuiAcqu sends messages
 * with ID's starting at WM_USER + 1000 to that message window.
 *
 * The creation of a tablet object will fail if the connected tablet is a full screen device
 * such as TabletPC or Wacom Cintiqu.
 * 
 * Under Windows most tablets, especially tablet using a Wintab driver, send
 * vector notifications through as message events, which reqire message
 * loop. Therefore, SP_GAWW_EVENTS must be set under Windows.
 *
 * @note Under Linux, this is currently the only way to create an
 *       SPGuiAcqu object.
 *
 * @param ppSPGuiAcqu [o]
 *      pointer to a variable that will be filled with a pointer to a new
 *      SPGuiAcqu object.  The caller is responsible for deallocating the
 *      new object by calling @ref SPGuiAcquFree.
 * @param iFlags [i], a combination of:
 *  - @ref SP_GAWW_EVENTS      Use Windows messages (or X11 events).
 *        <br>If this flag is set,then a message loop (or event loop) is
 *        required during acquiry (see SPGuiAcquAcquireWait and
 *        SPGuiAcquAcquireProcessMessages).
 *        <br>If this flag is not set, an internal event queue will be used
 *        (see SPGuiAcquAcquireWait and SPGuiAcquAcquireProcessMessages).
 *        <br>This flag must be set under Windows.
 *        <br>Currently, this flag must not be set under Linux as X11 is
 *        not yet supported.
 *  .
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_MEMERR        out of memory
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPGuiAcquAcquire, SPGuiAcquCreate, SPGuiAcquCreateInClient, SPGuiAcquFree, SPGuiAcquGetHwnd, SPGuiAcquSetBoolProperty, SPGuiAcquAcquireWait,
 * SPGuiAcquAcquireProcessMessages 
 *  
 * @ref gui_spGuiAcqu "SPGuiAcqu"
 * 
 * @todo Implement SP_GAWW_EVENTS for Linux
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquCreateWithoutWindow(pSPGUIACQU_T *ppSPGuiAcqu, SPINT32 iFlags);

/**
 * @brief Wait until tablet acquiry mode is terminated.
 *
 * This function processes messages (or events) and waits until
 * SPGuiAcquAcquireDone is called in acquiry mode.
 *
 * A Windows GUI application typically runs the message queue for all
 * windows within this process, so typically there is no need to call
 * this method.
 * 
 * Non-GUI applications do not process message queues. These
 * applications must call either SPGuiAcquAcquireWait or periadically
 * call SPGuiAcquAcquireProcessMessages to dispatch the messages for
 * this object.
 * 
 * This function runs a message loop under Windows.
 *
 * @param pSPGuiAcqu [i] pointer to an SPGuiAcqu object.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_BUSYERR       the device is used by another application
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPGuiAcquAcquire, SPGuiAcquAcquireDone, SPGuiAcquCreateWithoutWindow
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquAcquireWait(pSPGUIACQU_T pSPGuiAcqu);

/**
 * @brief Process pending messages if the tablet is in acquiry mode.
 *
 * This function processes messages (or events) while in acquiry mode.
 * SPGuiAcquAcquireProcessMessages returns as soon as all pending
 * messages (or events) for this object have been processed whereas
 * SPGuiAcquAcquireWait does not return until SPGuiAcquAcquireDone is called.
 * 
 * A GUI application typically processes the message queue for all 
 * windows within this process, so typically there is no need to call 
 * this method.
 * 
 * Non-GUI applications do not process message queues. These applications
 * must call either SPGuiAcquAcquireWait or periadically call SPGuiAcquAcquireProcessMessages
 * to dispatch the messages for this object.
 * 
 * SPGuiAcquAcquireProcessMessages returns as soon as all pending
 * messages (or events) for this object have been processed whereas
 * SPGuiAcquAcquireWait does not return until SPGuiAcquAcquireDone is called.
 * 
 * This function runs a message loop under Windows.
 *
 * @param pSPGuiAcqu [i] pointer to an SPGuiAcqu object.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_BUSYERR       the device is used by another application
 *     .
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPGuiAcquAcquire, SPGuiAcquAcquireDone, SPGuiAcquCreateWithoutWindow
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquAcquireProcessMessages(pSPGUIACQU_T pSPGuiAcqu);
/** 
 * @endcond INTERNAL
 */

/**
 * @brief Get the reference after a signature or reference acquiry.
 *
 * The returned reference may contain a single signature (in this case
 * a signature was captured), or multiple signatures (when a true
 * reference was captured). It is the responsability of the
 * application to convert the reference to a signature if the returned
 * object includes a single signature.
 *
 * This is a convenience function which behaves exactly like
 * @ref SPReferenceCreateFromGuiAcqu.
 *
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param ppReference [o]
 *      pointer to a variable that will be filled with a pointer to
 *      an SPReference object containing the reference.  The caller is
 *      responsible for destroying the new object with @ref SPReferenceFree.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_MEMERR        out of memory
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPGuiAcquAcquireDone, SPGuiAcquGetSignature, SPReferenceCreateFromGuiAcqu, SPReferenceFree
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquGetReference(pSPGUIACQU_T pSPGuiAcqu, pSPREFERENCE_T *ppReference);

/**
 * @brief Get the signature during acquiry mode.
 *
 * The returned SPSignature object may not contain all vectors captured
 * so far. This function is provided to check for empty signatures
 * @em before accepting the signature (see @ref SPGuiAcquAcquireDone).
 * Modifying the SPSignature object won't have an effect on the
 * signature being captured.
 *
 * This is a convenience function which behaves exactly like
 * @ref SPSignatureCreateFromGuiAcqu.
 *
 * @note No signature object will be returned unless the SPGuiAcqu object
 *       is in acquiry mode.
 *
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param ppSignature [o]
 *      pointer to a variable that will be filled with a pointer to
 *      an SPSignature object containing the current signature.  The caller is
 *      responsible for destroying the new object with @ref SPSignatureFree.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_MEMERR        out of memory
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPGuiAcquAcquire, SPGuiAcquGetReference, SPSignatureCreateFromGuiAcqu, SPSignatureFree
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquGetSignature(pSPGUIACQU_T pSPGuiAcqu, pSPSIGNATURE_T *ppSignature);

/**
 * @brief Register a component in acquiry mode.
 *
 * Any registered components will be notified in acquiry mode when the
 * pen is pressed on a component.
 *
 * Supported window classes:
 *     - "button", notification is sent as a BM_CLICK message
 *     - other classes, notification is sent as a WM_USER message, the
 *       application may need to subclass the native window
 *     .
 *
 * It is not useful to register buttons if the connected tablet does
 * not send proximity vectors, as the cursor does not follow pen
 * movements, thus you cannot see the cursor position.  The
 * alternative is to draw the buttons on the tablet for the specific
 * application as a feedback to the user where the buttons are
 * located.
 *
 * @param pSPGuiAcqu [i]        pointer to an SPGuiAcqu object.
 * @param hwndComponent [i] the component to be registered.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPGuiAcquAcquire, SPTabletHasProximity
 * @ref gui_spGuiAcqu "SPGuiAcqu"
 *
 * @todo Implement for Linux
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquRegisterComponent(pSPGUIACQU_T pSPGuiAcqu, SPHWND hwndComponent);

/**
 * @brief Unregister a component in acquiry mode.
 * 
 * @param pSPGuiAcqu [i]        pointer to an SPGuiAcqu object.
 * @param hwndComponent [i] the component to be unregistered.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPGuiAcquAcquire, SPGuiAcquRegisterComponent, SPGuiAcquUnregisterAllComponents
 *
 * @todo Implement for Linux
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquUnregisterComponent(pSPGUIACQU_T pSPGuiAcqu, SPHWND hwndComponent);

/**
 * @brief Unregister all components in acquiry mode.
 *
 * @param pSPGuiAcqu [i] pointer to an SPGuiAcqu object.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPGuiAcquAcquire, SPGuiAcquRegisterComponent, SPGuiAcquUnregisterComponent
 *
 * @todo Implement for Linux
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquUnregisterAllComponents(pSPGUIACQU_T pSPGuiAcqu);

/**
 * @brief Register a virtual button or rectangle in acquiry mode.
 *
 *
 * This function is a simplified version of @ref SPGuiAcquRegisterRect2,
 * the call is actually dispatched to SPGuiAcquRegisterRect2 with a
 * properly formatted XML description string.
 *
 * Any registered virtual buttons will be notified in acquiry mode when
 * button is pressed with the pen.
 *
 * Registering a rectangle with an ID that has been already registered will
 * be interpreted as an update on the rectangle coordinates.
 *
 * You must assure that the rectangles will be updated whenever the
 * coordinates change, such as resizing or moving a component unless
 * you specify the flag @ref SP_TABLET_COORDINATE.
 *
 * Virtual buttons can only be drawn to an optional LCD screen on the
 * tablet if they are registered before the tablet enters acquiry mode.
 *
 * The SPGuiAcqu object should not be deleted within the registered
 * listener. You may, e.g., post a message and delete the object in
 * the windows procedure handling that message.
 *
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param pId [io]
 *      pointer to a variable containing the identifier for the rectangle
 *      to be registered or 0 to let this function create the ID.
 *      The variable will be filled with the created ID, see @ref SPGuiAcquRegisterRect2
 * @param rcl [i]
 *      pointer to the rectangle to be registered, all coordinates are
 *      absolute screen coordinates, ie, point 0, 0 is the upper left corner
 *      of the PC screen.
 * @param iFlags [i]
 *      drawing flags, a bitwise combination of the following:
 *      - SP_TABLET_COORDINATE  the rectangle is passed in ppt of the tablet size, or the
 *          entry window size when using a full-screen tablet
 *      - SP_DRAW_ON_EXT_LCD    the rectangle will be drawn on an external LCD
 *      - SP_DRAW_ON_SCREEN     draw the rectangle on the aquiry window
 *      - SP_ONLY_FOR_EXT_LCD   ignore this rectangle if the tablet does not have an LCD
 *      .
 * @param pszName [i]
 *      string that should be displayed if the draw flags cause the rectangle
 *      to be drawn.
 *      NULL and "" are legal values, the string length is limited to
 *      160 characters. The string is expected in UTF-8 encoding, use
 *      @ref SPUnicodeToUtf8 to convert from Unicode.
 * @param pVirtualButtonListener [i]
 *      callback function that will be called when the rectangle is 'clicked'. The global 
 *      virtual button listener (see @ref SPGuiAcquSetButtonListener) will be called if 
 *      this parameter is NULL.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_APPLERR       cannot register a virtual button in acquiry mode
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * 
 * @see SPGuiAcquAcquire, SPTabletHasProximity, SPTabletSetBoolProperty
 * @see SP_TABLET_COORDINATE, SP_DRAW_BACKGROUND_IMAGE, SP_DRAW_ON_EXT_LCD, SP_DRAW_ON_SCREEN, SP_ONLY_FOR_EXT_LCD
 * 
 * @ref gui_spGuiAcqu "SPGuiAcqu"
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquRegisterRect(pSPGUIACQU_T pSPGuiAcqu, SPUINT32 *pId, pSPRECT_T rcl, SPINT32 iFlags, const SPCHAR *pszName, pSPGUIACQURECTLISTENER_T pVirtualButtonListener);

/**
 * @brief Register a virtual button or rectangle in acquiry mode.
 *
 * Any registered virtual buttons will be notified in acquiry mode when
 * the virtual button is pressed by the pen.
 *
 * Rectangles can only be drawn to an optional LCD screen on the
 * tablet if they are registered before the tablet enters acquiry mode.
 *
 * TextFields will be positioned within the rectangle (centered,
 * excluding optional image space) if no valid coordinate is
 * specified.  Images will be positioned within the rectangle (left
 * aligned) if no valid coordinate is specified.
 *
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param pId [io] pointer to a variable theat will be filled with the identifier of the virtual button.
 *      The descriptor of the virtual button must include an id. The button will be updated if the id 
 *      in the descriptor alreaady exists, or created if it does not exist.
 *      <br> The Id is used to identify the virtuel button in virtual button callbacks.
 * @param pszVirtualButtonDescription [i]
 *      description of the rectangle position, size, text, font etc.
 *      Please see element SPSWVirtualButton in @ref sec_VirtualButtonDescriptionDTD for details.
 * @param pVirtualButtonListener [i]
 *      callback function that will be called when the rectangle is 'clicked'. The global 
 *      virtual button listener (see @ref SPGuiAcquSetButtonListener) will be called if 
 *      this parameter is NULL.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_APPLERR       cannot register a virtual button in acquiry mode
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * 
 * @see SPGuiAcquAcquire, SPGuiAcquSetButtonListener, SPTabletHasProximity, SPTabletSetBoolProperty
 * 
 * @ref gui_spGuiAcqu "SPGuiAcqu"
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquRegisterRect2(pSPGUIACQU_T pSPGuiAcqu, SPUINT32 *pId, const SPCHAR*pszVirtualButtonDescription, pSPGUIACQURECTLISTENER_T pVirtualButtonListener);

/**
 * @cond INTERNAL
 */
/**
 * This is an compatibility function that behaves exactly like SPGuiAcquRegisterRect2
 * 
 * @deprecated Use SPGuiAcquRegisterRect2 instead
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquRegisterRectOptions(pSPGUIACQU_T pSPGuiAcqu, SPUINT32 *pId, const SPCHAR*pszRectDescription, pSPGUIACQURECTLISTENER_T pRectListener);
/**
 * @endcond
 */

/**
 * @brief Unregister a virtual button in acquiry mode.
 *
 * @param pSPGuiAcqu [i] pointer to an SPGuiAcqu object.
 * @param uId [i]        identifier of the rectangle to be unregistered.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_APPLERR       cannot unregister a virtual button in acquiry mode
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPGuiAcquAcquire, SPGuiAcquRegisterRect2, SPGuiAcquUnregisterAllRects
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquUnregisterRect(pSPGUIACQU_T pSPGuiAcqu, SPUINT32 uId);

/**
 * @brief Unregister all virtual buttons in acquiry mode.
 *
 * @param pSPGuiAcqu [i] pointer to an SPGuiAcqu object.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_APPLERR       cannot unregister virtual buttons in acquiry mode
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPGuiAcquAcquire, SPGuiAcquRegisterRect2, SPGuiAcquUnregisterRect
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquUnregisterAllRects(pSPGUIACQU_T pSPGuiAcqu);

/**
 * @brief Set the optional user parameter of an SPGuiAcqu object.
 *
 * The optional user parameter is not used inside SignWare, you may
 * add one additional SPVPTR parameter for application purposes.
 *
 * @param pSPGuiAcqu [i] pointer to an SPGuiAcqu object.
 * @param lUser [i] application-specific parameter.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPGuiAcquGetUserLong
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquSetUserLong(pSPGUIACQU_T pSPGuiAcqu, SPVPTR lUser);

/**
 * @brief Get the optional user parameter of an SPGuiAcqu object.
 *
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param plUser [o]
 *      pointer to a variable that will be filled with the user parameter
 *      of the SPGuiAcqu object.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPGuiAcquSetUserLong
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquGetUserLong(pSPGUIACQU_T pSPGuiAcqu, SPVPTR *plUser);

/**
 * @brief Set the tablet button listener.
 *
 * This listener will be called when a real button (hardware button) on the tablet was
 * pressed, but not for virtual buttons.
 *
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param pRectListener [i]
 *      Callback function that will be called when a virtual button is pressed. If a 
 *      rectangle is pressed then the registered listener for the rectangle will be 
 *      called, see @ref SPGuiAcquRegisterRect, @ref SPGuiAcquRegisterRect2 or this 
 *      listener will be called if no listener was registered with the virtual button 
 *      (the listener is NULL).
 * @param pButtonListener [i]
 *      Callback function that will be called when a tablet button is pressed.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquSetButtonListener(pSPGUIACQU_T pSPGuiAcqu, pSPGUIACQURECTLISTENER_T pRectListener, pSPGUIACQUBUTTON_T pButtonListener);

/**
 * @brief Set the background image of a tablet that includes an LCD display.
 *
 * The tablet image is composed of all background images, text and rectangles 
 * (virtual buttons). The tablet image will be calculated before the tablet enters
 * acquiry mode, that is within the method SPGuiAcquAcquire.
 *
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param pbImage [i]
 *      pointer to the image data. Most standard image formats such as
 *      BMP, TIF, JPG, GIF, and CCITT4 are supported
 * @param iImageLen [i]
 *      size of the image data (in bytes) pointed to by @a pbImage.
 * @return @ref SP_NOERR on success, else error code:
 *      - @ref SP_UNSUPPORTEDERR     the tablet does not support images
 *      - @ref SP_PARAMERR           invalid parameter or the image could not be decoded
 *      - @ref SP_LINKLIBRARYERR     external modules could not be loaded
 *      - @ref SP_APPLERR            cannot change background in acquiry mode
 *      .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquSetBackgroundImage(pSPGUIACQU_T pSPGuiAcqu, const SPUCHAR *pbImage, SPINT32 iImageLen);

/**
 * @brief Get the background image as it is displayed on the tablet or
 *        the PC screen.
 *
 * The image will @em not contain any partial or fully entered
 * signature strokes.
 *
 * This function returns SP_NOERR and *@a ppImage = NULL if no background
 * image was passed.
 *
 * This function is provided for audit purposes. The resulting image
 * contains a gray-scale image with up to 256 gray levels or a color image.
 *
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param iSource [i]
 *      select the source of the image:
 *      - 1 PC screen
 *      - 2 Tablet LCD
 *      .
 * @param ppImage [o]
 *      pointer to a variable that will be filled with a pointer to an SPImage
 *      object. The caller is responsible for deallocating the new object
 *      by calling @ref SPImageFree.
 * @return @ref SP_NOERR on success, else error code:
 *      - @ref SP_UNSUPPORTEDERR     the tablet does not support images
 *      - @ref SP_PARAMERR           invalid parameter
 *      - @ref SP_LINKLIBRARYERR     external modules could not be loaded
 *      .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPImageFree
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquGetBackgroundImage(pSPGUIACQU_T pSPGuiAcqu, SPINT32 iSource, pSPIMAGE_T *ppImage);

/**
 * @brief Get the background text as it is displayed on the tablet.
 *
 * This function returns SP_NOERR and *@a ppText = NULL if no background
 * text was passed.
 *
 * This function is provided for audit purposes. The resulting text
 * contains all text elements that is diplayed on the tablet.
 *  
 * @note This function does not analyse images for text contexts. 
 *  
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param iSource [i]
 *      select the source of the image:
 *      - 2 Tablet LCD
 *      .
 * @param ppszText [o]
 *      pointer to a char pointer that will be filled with the displayed
 *      text.
 *      The caller is responsible for deallocating the new object
 *      by calling @ref SPFreeString.
 * @return @ref SP_NOERR on success, else error code:
 *      - @ref SP_UNSUPPORTEDERR     the tablet does not support images
 *      - @ref SP_PARAMERR           invalid parameter
 *      - @ref SP_LINKLIBRARYERR     external modules could not be loaded
 *      .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPFreeString
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquGetBackgroundText(pSPGUIACQU_T pSPGuiAcqu, SPINT32 iSource, SPCHAR **ppszText);

/**
 * @brief Pass a license ticket for the next signature capture(s).
 *
 * When using the ticket license model, you must pass the ticket
 * before you connect with the tablet.
 * This function copies the SPTicket object.
 *
 * The ticket must be charged for usage @ref SP_TICKET_CAPTURE.
 *
 * @deprecated Please use a license key.
 *
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @param pTicket [i]
 *      pointer to an SPTicket object.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @deprecated Replaced by @ref SPSignwareSetTicket.
 *
 * @see SP_TICKET_CAPTURE
 * @see SPSignwareSetTicket, SPTicketCharge
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquSetTicket(pSPGUIACQU_T pSPGuiAcqu, pSPTICKET_T pTicket);


/**
 * @brief Activate / deactivate the acquire window.
 *
 *
 * The acquire window is normally active until SPAcquireAcquireDone is called.
 * There are situations where the application might want to deactivate
 * acquire mode, e.g. in multi page dialogs.
 *
 * @param pSpGui [i]
 *      pointer to an SPGuiAcqu object.
 * @param bActive [i]
 *      non-zero to activate acquiry mode, zero to deactive acquiry mode.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32)
 *
 * @see SP_RELEASE_FOCUS, SPGuiAcquSetDrawFlags
 * 
 * @todo Implement for Linux
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquSetActive(pSPGUIACQU_T pSpGui, SPBOOL bActive);

/**
 * @brief Add some text to the tablet LCD screen or the acquiry window.
 *
 * The XML string is described in @ref sec_TextDescriptionDTD, element
 * SPSWTextFields must be used.
 *
 * The Objects will be displayed on an (optional) LCD screen when the application 
 * calls SPGuiAcquAcquire
 *
 * @param pSpGui [i]
 *      pointer to an SPGuiAcqu object.
 * @param pszXMLTextDescription [i]
 *      a description of the text, position and font to be included.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_APPLERR       cannot change background in acquiry mode
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPGuiAcquAddBackgroundObject, SPGuiAcquAddBackgroundImage, SPGuiAcquRemoveBackgroundObjects
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquAddBackgroundText(pSPGUIACQU_T pSpGui, const SPCHAR *pszXMLTextDescription);

/**
 * @brief Add images to the tablet LCD screen or the acquiry window.
 *
 * The XML string is described in @ref sec_ImageDescriptionDTD,
 * element SPSWImageFields must be used.
 *
 * The Objects will be displayed on an (optional) LCD screen when the application 
 * calls SPGuiAcquAcquire
 *
 * @param pSpGui [i]
 *      pointer to an SPGuiAcqu object.
 * @param pszXMLImageDescription [i]
 *      string containing the XML description of the images.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_APPLERR       cannot change background in acquiry mode
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPGuiAcquAddBackgroundObject, SPGuiAcquAddBackgroundText, SPGuiAcquRemoveBackgroundObjects
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquAddBackgroundImage(pSPGUIACQU_T pSpGui, const SPCHAR *pszXMLImageDescription);

/**
 * @brief Add documents to the tablet LCD screen or the acquiry window.
 *
 * The XML string is described in @ref sec_DocumentDescriptionDTD,
 * element SPSWDocumentFields must be used.
 *
 * The Objects will be displayed on an (optional) LCD screen when the application 
 * calls SPGuiAcquAcquire
 *
 * @param pSpGui [i]
 *      pointer to an SPGuiAcqu object.
 * @param pszXMLDocumentDescription [i]
 *      string containing the XML description of the documents.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_APPLERR       cannot change background in acquiry mode
 *     .
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPGuiAcquAddBackgroundObject, SPGuiAcquAddBackgroundImage, SPGuiAcquAddBackgroundText, SPGuiAcquRemoveBackgroundObjects
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquAddBackgroundDocument(pSPGUIACQU_T pSpGui, const SPCHAR *pszXMLDocumentDescription);

/**
 * @brief Set the content of a document
 * 
 * Use SPGuiAcquAddBackgroundDocument or SPGuiAcquAddBackgroundObject or SPGuiAcquSetBackgroundObjects
 * to create and layout of a document view. 
 * <br> Once the document is created you may: 
 *    - Dynamically assign the document content (see @ref SPGuiAcquSetDocumentContent)
 *    - Register a Document event listener (see @ref SPGuiAcquSetDocumentListener) to process virtual 
 *      button events that are assigned to a document.
 *    - Dynamically create virtual buttons in a document, see @ref SPGuiAcquRegisterDocumentRect
 *    .
 *  
 * @param pSpGui [i]
 *      pointer to an SPGuiAcqu object.
 * @param aId [i] 
 *      the unique identifyer of the document
 * @param pContent [i]
 *      pointer to the document contents, may be the document data, or a file name
 * @param iContent [i]
 *      the size of the document content in bytes
 * @param aFormat [i]
 *      format specifyer of the document content:
 *      - 1: local file, pContent is the UTF-8 encoded FQN of the document 
 *      - 2: document data is passed as an image, pContent is the document data in memory
 *      .
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_MEMERR        out of memory
 *     - @ref SP_APPLERR       cannot change background in acquiry mode
 *     .
 * 
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPGuiAcquAddBackgroundObject, SPGuiAcquAddBackgroundDocument, SPGuiAcquRemoveBackgroundObjects
 * @see sec_DocumentDescriptionDTD 
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquSetDocumentContent(pSPGUIACQU_T pSpGui, SPINT32 aId, const SPCHAR *pContent, SPINT32 iContent, SPINT32 aFormat);

/**
 * @brief Register a virtual button listener for buttons which are assigned to a specific document
 * 
 * @param pSpGui [i]
 *      pointer to an SPGuiAcqu object.
 * @param pListener [i] 
 *      pointer to the listener method, may be NULL to deregister a listener 
 * 
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 * @see SPGuiAcquSetDocumentContent, SPGuiAcquRegisterDocumentRect 
 * @see sec_DocumentDescriptionDTD 
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquSetDocumentListener(pSPGUIACQU_T pSpGui, pSPGUIACQUDOCRECTLISTENER_T pListener);

/**
 * @brief Register a virtual button in a document
 *  
 * @note The virtual button description includes an id which may not be 0. The button id should be a unique id for 
 * each button. Subsequent registrations of virtual buttons with the same id will modify the already registered 
 * virtual button, e. g. set an icon, or move the button. 
 *  
 * @param pSpGui [i]
 *      pointer to an SPGuiAcqu object.
 * @param aId [i] 
 *      the unique identifyer of the document
 * @param pszVirtualButtonDescription [i] 
 *      description of the rectangle position, size, text, font etc. Please see element SPSWVirtualButton
 *      in @ref sec_VirtualButtonDescriptionDTD for details  
 * 
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 *  
 * @see SPGuiAcquSetDocumentContent, SPGuiAcquSetDocumentListener
 * @see sec_DocumentDescriptionDTD
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquRegisterDocumentRect(pSPGUIACQU_T pSpGui, SPUINT32 aId, const SPCHAR *pszVirtualButtonDescription);

/**
 * @brief Add images, rectangles and text fields to the tablet LCD screen or the
 *        acquiry window.
 *
 * The XML string is described in @ref sec_ObjectDescriptionDTD.
 * Element SPSWObjects must be the root element, SPSWImageFileds, SPSWImage,
 * SPSWRect, SPSWRectFields, SPSWTextFields and SPSWText elements will be displayed.
 * @note SPSWRect and SPSWRectFields will be displayed but cannot be clicked, use 
 * SPGuiAcquRegisterRect or SPGuiAcquRegisterRect2 to define virtual buttons.
 * 
 * The Objects will be displayed on an (optional) LCD screen when the application 
 * calls SPGuiAcquAcquire
 *
 * @param pSpGui [i]
 *      pointer to an SPGuiAcqu object.
 * @param pszXMLDescription [i]
 *      string containing the XML description of the images and texts.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_APPLERR       cannot change background in acquiry mode
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPGuiAcquAddBackgroundText, SPGuiAcquAddBackgroundImage, SPGuiAcquRemoveBackgroundObjects
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquAddBackgroundObject(pSPGUIACQU_T pSpGui, const SPCHAR *pszXMLDescription);

/**
 * @brief Set images, text fields or rectangles to the tablet LCD screen or the
 *        acquiry window.
 * 
 * Use @ref SPBackgroundObjectsCreateFromFile or @ref SPBackgroundObjectsCreateFromXML to create 
 * the background objects container. The proper objects will be selected based on the created
 * tablet type, and all elements of the selected  objects will be copied to the background
 * 
 * @note This object must have a vald tablet object, see @ref SPGuiAcquCreateTablet, 
 * @ref SPGuiAcquConnect and must not be in aquiry state.
 * <br> All existing background objects will be deleted and the new objects will be added,
 * see @ref SPGuiAcquRemoveBackgroundObjects
 * 
 * @param pSpGui [i]
 *      pointer to an SPGuiAcqu object.
 * @param pSpBackgroundObjects [i]
 *      pointer to an SPBackgroundObjects object.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_APPLERR       cannot change background in acquiry mode or no tablet instantiated
 *     .
 * 
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquSetBackgroundObjects(pSPGUIACQU_T pSpGui, pSPBACKGROUNDOBJECTS_T pSpBackgroundObjects);

/**
 * @brief Remove images, text and rectangle fields from the tablet LCD screen or the
 *        acquiry window.
 *
 * The Background Objects will be updated on an (optional) LCD screen when the application 
 * calls SPGuiAcquAcquire
 *
 * @param pSpGui [i]
 *      pointer to an SPGuiAcqu object.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_APPLERR       cannot change background in acquiry mode
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPGuiAcquAddBackgroundText, SPGuiAcquAddBackgroundImage, SPGuiAcquAddBackgroundObject
 */
SPEXTERN SPINT32 SPLINK SPGuiAcquRemoveBackgroundObjects(pSPGUIACQU_T pSpGui);

#ifdef __cplusplus
}
#endif  /* __cplusplus */

#endif  /* SPGUIACQU_H__ */
