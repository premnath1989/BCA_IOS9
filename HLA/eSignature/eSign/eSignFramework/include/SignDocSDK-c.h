/*==============================================================*
 * SignDocSDK                                                   *
 *                                                              *
 * Module: SignDocSDK-c.h                                       *
 *                                                              *
 * Copyright SOFTPRO GmbH,                                      *
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
 * @file SignDocSDK-c.h
 *
 * @brief SignDoc SDK C API
 */

#ifndef SP_SIGNDOCSDK_C_H__
#define SP_SIGNDOCSDK_C_H__

#include <stdio.h>
#include <wchar.h>

#ifdef __cplusplus
extern "C" {
#endif

#ifdef _MSC_VER
#define SDCAPI __stdcall
#else
#define SDCAPI
#endif

/* --------------------------------------------------------------------------*/

struct SIGNDOC_Color;
struct SPPDF_Document;

/* --------------------------------------------------------------------------*/

/**
 * @brief Boolean value: false.
 *
 * @see #SIGNDOC_TRUE, SIGNDOC_Boolean
 */
#define SIGNDOC_FALSE   0

/**
 * @brief Boolean value: true.
 *
 * @see #SIGNDOC_FALSE, SIGNDOC_Boolean
 */
#define SIGNDOC_TRUE    1

/**
 * @brief Exception class: std::bad_alloc.
 */
#define SIGNDOC_EXCEPTION_TYPE_BAD_ALLOC                1

/**
 * @brief Exception class: de::softpro::sppdf::Exception.
 */
#define SIGNDOC_EXCEPTION_TYPE_PDF                      2

/**
 * @brief Exception class: std::exception
 */
#define SIGNDOC_EXCEPTION_TYPE_STL                      3

/**
 * @brief Exception class: everything else.
 */
#define SIGNDOC_EXCEPTION_TYPE_GENERIC                  4

/**
 * @brief Exception class: de::softpro::spooc::Exception.
 */
#define SIGNDOC_EXCEPTION_TYPE_SPOOC_GENERIC            5

/**
 * @brief Exception class: de::softpro::spooc::EncodingError.
 */
#define SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR     6

/**
 * @brief Exception class: de::softpro::spooc::IOError
 */
#define SIGNDOC_EXCEPTION_TYPE_SPOOC_IO                 7

/**
 * @brief Annotation type: Unknown annotation type.
 *
 * Most annotation types are supported for PDF documents only.
 */
#define SIGNDOC_ANNOTATION_TYPE_UNKNOWN         0

/**
 * @brief Annotation type: Line annotation.
 *
 * Most annotation types are supported for PDF documents only.
 */
#define SIGNDOC_ANNOTATION_TYPE_LINE            1

/**
 * @brief Annotation type: Scribble annotation (freehand scribble).
 *
 * Most annotation types are supported for PDF documents only.
 */
#define SIGNDOC_ANNOTATION_TYPE_SCRIBBLE        2

/**
 * @brief Annotation type: FreeText annotation.
 *
 * Most annotation types are supported for PDF documents only.
 */
#define SIGNDOC_ANNOTATION_TYPE_FREETEXT        3

/**
 * @brief Line ending style: Unknown line ending style.
 */
#define SIGNDOC_ANNOTATION_LINEENDING_UNKNOWN   0

/**
 * @brief Line ending style: No line ending.
 */
#define SIGNDOC_ANNOTATION_LINEENDING_NONE      1

/**
 * @brief Line ending style: Two short lines forming an arrowhead.
 */
#define SIGNDOC_ANNOTATION_LINEENDING_ARROW     2

/**
 * @brief Horizontal alignment: left.
 *
 * Used for integer parameters "ImageVAlignment" and "TextVAlignment",
 * see SIGNDOC_SignatureParameters_setInteger().
 */
#define SIGNDOC_ANNOTATION_HALIGNMENT_LEFT      0

/**
 * @brief Horizontal alignment: center.
 *
 * Used for integer parameters "ImageVAlignment" and "TextVAlignment",
 * see SIGNDOC_SignatureParameters_setInteger().
 */
#define SIGNDOC_ANNOTATION_HALIGNMENT_CENTER    1

/**
 * @brief Horizontal alignment: right.
 *
 * Used for integer parameters "ImageVAlignment" and "TextVAlignment",
 * see SIGNDOC_SignatureParameters_setInteger().
 */
#define SIGNDOC_ANNOTATION_HALIGNMENT_RIGHT     2

/**
 * @brief Return code: Parameter set successfully.
 */
#define SIGNDOC_ANNOTATION_RETURNCODE_OK        0

/**
 * @brief Return code: Setting the parameter is not supported.
 */
#define SIGNDOC_ANNOTATION_RETURNCODE_NOT_SUPPORTED     1

/**
 * @brief Return code: The value for the parameter is invalid.
 */
#define SIGNDOC_ANNOTATION_RETURNCODE_INVALID_VALUE     2

/**
 * @brief Return code: The value is not available.
 */
#define SIGNDOC_ANNOTATION_RETURNCODE_NOT_AVAILABLE     3

/**
 * @brief Document type: For SIGNDOC_DocumentLoader_ping().
 */
#define SIGNDOC_DOCUMENT_DOCUMENTTYPE_UNKNOWN           0

/**
 * @brief Document type: PDF document.
 */
#define SIGNDOC_DOCUMENT_DOCUMENTTYPE_PDF               1

/**
 * @brief Document type: TIFF document.
 */
#define SIGNDOC_DOCUMENT_DOCUMENTTYPE_TIFF              2

/**
 * @brief Document type: Other document.
 */
#define SIGNDOC_DOCUMENT_DOCUMENTTYPE_OTHER             3

/**
 * @brief Document type: FDF document.
 */
#define SIGNDOC_DOCUMENT_DOCUMENTTYPE_FDF               4

/**
 * @brief Flags modifying the behavior of SIGNDOC_Document_saveToFile() and SIGNDOC_Document_saveToStream():
 *        Save incrementally (PDF).
 */
#define SIGNDOC_DOCUMENT_SAVEFLAGS_INCREMENTAL          0x01

/**
 * @brief Flags modifying the behavior of SIGNDOC_Document_saveToFile() and SIGNDOC_Document_saveToStream():
 *        Remove unused objects (PDF).
 *
 * This flag is ignored, unused objects are always removed.
 */
#define SIGNDOC_DOCUMENT_SAVEFLAGS_REMOVE_UNUSED        0x02

/**
 * @brief Flags modifying the behavior of SIGNDOC_Document_saveToFile() and SIGNDOC_Document_saveToStream():
 *        Linearize the document (PDF).
 *
 * This flag cannot be used with #SIGNDOC_DOCUMENT_SAVEFLAGS_INCREMENTAL.
 *
 * @note This flag is currently ignored, it will be supported again
 *       in a future version of SignDoc SDK.
 *
 * @todo implement SIGNDOC_DOCUMENT_SAVEFLAGS_LINEARIZED
 */
#define SIGNDOC_DOCUMENT_SAVEFLAGS_LINEARIZED           0x04

/**
 * @brief Flags modifying the behavior of SIGNDOC_Document_saveToFile() and SIGNDOC_Document_saveToStream():
 *        Do not use features introduced after PDF 1.4 for saving the document.
 *
 * This flag is assumed to be set for PDF 1.4 (and older) documents (PDF).
 */
#define SIGNDOC_DOCUMENT_SAVEFLAGS_PDF_1_4              0x08

/**
 * @brief Flags modifying the behavior of SIGNDOC_Document_saveToFile() and SIGNDOC_Document_saveToStream():
 *        Fix appearance streams of check boxes and radio buttons for PDF/A-1 documents.
 *
 * The appearance streams of a check box or radio button field added
 * by SIGNDOC_Document_addField() or modified by
 * SIGNDOC_Document_setField() or SIGNDOC_Document_applyFdf() are not
 * PDF/A-1-compliant.
 *
 * To make the appearance streams of check boxes and radio buttons
 * PDF/A-1-compliant, save the document with this flag set. The document
 * will be modified in memory and then saved.
 *
 * This flag is observed even if the document does not claim to be
 * PDF/A-1-compliant.
 *
 * @note After fixing appearance streams, check boxes and radio buttons
 *       can no longer be modified or operated as the button values 
 *       (ie, the set of possible values) is lost.
 *
 * @see #SIGNDOC_SIGNATUREPARAMETERS_PDFABUTTONS_AUTO, #SIGNDOC_SIGNATUREPARAMETERS_PDFABUTTONS_FREEZE
 */
#define SIGNDOC_DOCUMENT_SAVEFLAGS_PDFA_BUTTONS         0x10

/**
 * @brief Flag for SIGNDOC_Document_copyToStream(): Include unsaved changes.
 *
 * See SIGNDOC_Document_copyToStream() for details.
 *
 * @see SIGNDOC_Document_copyToStream()
 */
#define SIGNDOC_DOCUMENT_COPYTOSTREAMFLAGS_UNSAVED      0x01

/**
 * @brief Flags modifying the behavior of SIGNDOC_Document_setField(),
 *        SIGNDOC_Document_addField(), and SIGNDOC_Document_applyFdf():
 *        Fail if no suitable font is found.
 *
 * SIGNDOC_Document_setField(), SIGNDOC_Document_addField(), and
 * SIGNDOC_Document_applyFdf() won't modify/add the field and will
 * report error #SIGNDOC_DOCUMENT_RETURNCODE_FONT_NOT_FOUND if no font
 * covering all required characters is found.
 *
 * Exactly one of #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_FAIL,
 * #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_WARN, and
 * #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_IGNORE must be specified.
 *
 * @see #SIGNDOC_DOCUMENT_SETFIELDFLAGS_MOVE, #SIGNDOC_DOCUMENT_SETFIELDFLAGS_KEEP_AP, #SIGNDOC_DOCUMENT_SETFIELDFLAGS_UPDATE_AP
 */
#define SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_FAIL        0x01

/**
 * @brief Flags modifying the behavior of SIGNDOC_Document_setField(),
 *        SIGNDOC_Document_addField(), and SIGNDOC_Document_applyFdf():
 *        Warn if no suitable font is found.
 *
 * SIGNDOC_Document_setField(), SIGNDOC_Document_addField(), and
 * SIGNDOC_Document_applyFdf() will modify/add the field even if no
 * font covering all required characters is found, but they will
 * report error #SIGNDOC_DOCUMENT_RETURNCODE_FONT_NOT_FOUND. The
 * appearance of the field won't represent the contents in that case.
 *
 * Exactly one of #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_FAIL,
 * #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_WARN, and
 * #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_IGNORE must be specified.
 *
 * @see #SIGNDOC_DOCUMENT_SETFIELDFLAGS_MOVE, #SIGNDOC_DOCUMENT_SETFIELDFLAGS_KEEP_AP, #SIGNDOC_DOCUMENT_SETFIELDFLAGS_UPDATE_AP
 */
#define SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_WARN        0x02

/**
 * @brief Flags modifying the behavior of SIGNDOC_Document_setField(),
 *        SIGNDOC_Document_addField(), and SIGNDOC_Document_applyFdf():
 *        Ignore font problems.
 *
 * SIGNDOC_Document_setField(), SIGNDOC_Document_addField(), and
 * SIGNDOC_Document_applyFdf() will modify/add the field even if no
 * font covering all required characters is found, and they won't
 * report the problem to the caller. The appearance of the field won't
 * represent the contents in that case.
 *
 * Exactly one of #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_FAIL,
 * #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_WARN, and
 * #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_IGNORE must be specified.
 *
 * @see #SIGNDOC_DOCUMENT_SETFIELDFLAGS_MOVE, #SIGNDOC_DOCUMENT_SETFIELDFLAGS_KEEP_AP, #SIGNDOC_DOCUMENT_SETFIELDFLAGS_UPDATE_AP
 */
#define SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_IGNORE      0x04

/**
 * @brief Flags modifying the behavior of SIGNDOC_Document_setField():
 *        Move or resize field.
 *
 * SIGNDOC_Document_setField() does not update the coordinates of the
 * field unless this flag is set as moving a field may require
 * recomputing the appearance which can have unexpected results
 * (mostly due to shortcomings of SignDoc SDK). If this flag is not
 * set, SIGNDOC_Document_setField() ignores the coordinates set with
 * SIGNDOC_Field_setLeft(), SIGNDOC_Field_setBottom(),
 * SIGNDOC_Field_setRight(), and SIGNDOC_Field_setTop().
 * 
 * SIGNDOC_Document_addField() ignores this flag, it always uses the coordinates.
 * SIGNDOC_Document_applyFdf() ignores this flag, it never moves or resizes fields.
 *
 * @see #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_FAIL, #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_WARN, #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_IGNORE, #SIGNDOC_DOCUMENT_SETFIELDFLAGS_KEEP_AP, #SIGNDOC_DOCUMENT_SETFIELDFLAGS_UPDATE_AP
 */
#define SIGNDOC_DOCUMENT_SETFIELDFLAGS_MOVE             0x08

/**
 * @brief Flags modifying the behavior of SIGNDOC_Document_setField(),
 *        SIGNDOC_Document_addField(), and SIGNDOC_Document_applyFdf():
 *        Keep appearance streams.
 *
 * If this flag is set, SIGNDOC_Document_setField() and
 * SIGNDOC_Document_applyFdf() won't touch the existing (or
 * non-existing) appearance streams, SIGNDOC_Document_addField() won't
 * add any appearance streams.
 *
 * Recomputing the appearance can have unexpected results
 * (mostly due to shortcomings of SignDoc SDK), therefore
 * you might want to set this flag if you make changes
 * that shall not affect the appearance such as setting
 * the #SIGNDOC_FIELD_FLAG_READONLY flag.
 *
 * At most one of SIGNDOC_DOCUMENT_SETFIELDFLAGS_KEEP_AP and
 * #SIGNDOC_DOCUMENT_SETFIELDFLAGS_UPDATE_AP can be set.
 *
 * @see #SIGNDOC_DOCUMENT_SETFIELDFLAGS_UPDATE_AP, #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FIT_HEIGHT_ONLY
 */
#define SIGNDOC_DOCUMENT_SETFIELDFLAGS_KEEP_AP          0x10

/**
 * @brief Flags modifying the behavior of SIGNDOC_Document_setField(),
 *        SIGNDOC_Document_addField(), and SIGNDOC_Document_applyFdf():
 *        Update appearance streams.
 *
 * If this flag is set, SIGNDOC_Document_setField() and
 * SIGNDOC_Document_applyFdf() will always recompute the appearance
 * streams of the field. (SIGNDOC_Document_addField() always computes
 * the appearance stream unless
 * #SIGNDOC_DOCUMENT_SETFIELDFLAGS_KEEP_AP is set).
 *
 * You might want to use this flag after changing the document's
 * default text field attributes.
 *
 * At most one of #SIGNDOC_DOCUMENT_SETFIELDFLAGS_KEEP_AP and
 * SIGNDOC_DOCUMENT_SETFIELDFLAGS_UPDATE_AP can be set.
 *
 * If neither #SIGNDOC_DOCUMENT_SETFIELDFLAGS_KEEP_AP and
 * SIGNDOC_DOCUMENT_SETFIELDFLAGS_UPDATE_AP is set,
 * SIGNDOC_Document_setField() tries to update the appearance streams
 * only if necessary; the exact behavior depends on the version of
 * SignDoc SDK.
 *
 * @see #SIGNDOC_DOCUMENT_SETFIELDFLAGS_KEEP_AP, #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FIT_HEIGHT_ONLY, SIGNDOC_Document_setTextFieldAttributes()
 */
#define SIGNDOC_DOCUMENT_SETFIELDFLAGS_UPDATE_AP        0x20

/**
 * @brief Flags modifying the behavior of SIGNDOC_Document_setField(),
 *        SIGNDOC_Document_addField(), and SIGNDOC_Document_applyFdf():
 *        Compute the default font size such that the field
 *        contents fit the height of the field.
 *
 * If the font size for a text field, list box field, or combo box
 * field is zero (see SIGNDOC_TextFieldAttributes_setFontSize()),
 * the default font size will be used. This flag controls how the
 * default font size is used.
 *
 * If this flag is set, the font size will be computed such that the
 * field contents fit the height of the field. This is the behavior
 * required by the PDF specification. If the field contents are too
 * long, they will be truncated.
 *
 * If this flag is not set, the font size will be computed such that
 * the field contents fit both the height and the width of the
 * field. This is the behavior implemented in, for instance, Adobe
 * Acrobat.
 */
#define SIGNDOC_DOCUMENT_SETFIELDFLAGS_FIT_HEIGHT_ONLY  0x40

/**
 * @brief Flags modifying the behavior of SIGNDOC_Document_flattenFields():
 *        Include unsigned signature fields.
 */
#define SIGNDOC_DOCUMENT_FLATTENFIELDSFLAGS_INCLUDE_SIGNATURE_UNSIGNED  0x01

/**
 * @brief Flags modifying the behavior of SIGNDOC_Document_flattenFields():
 *        Include signed signature fields.
 */
#define SIGNDOC_DOCUMENT_FLATTENFIELDSFLAGS_INCLUDE_SIGNATURE_SIGNED    0x02

/**
 * @brief Flags modifying the behavior of SIGNDOC_Document_flattenFields():
 *        Include hidden and invisible widgets.
 */
#define SIGNDOC_DOCUMENT_FLATTENFIELDSFLAGS_INCLUDE_HIDDEN              0x04

/**
 * @brief Flags modifying the behavior of SIGNDOC_Document_flattenFields():
 *        Do not modify logical structure.
 *
 * Set this flag only if you don't care about the logical
 * structure of the document and fear problems due to errors in
 * the logical structure. For instance, you might want to use this
 * flag if flattening fields just for printing with a PDF
 * component that does not support annotations and then throw away
 * the document with the flattened fields.
 */
#define SIGNDOC_DOCUMENT_FLATTENFIELDSFLAGS_KEEP_STRUCTURE              0x08

/**
 * @brief Flags modifying the behavior of SIGNDOC_Document_findText(): Ignore horizontal whitespace (may be required).
 */
#define SIGNDOC_DOCUMENT_FINDTEXTFLAGS_IGNORE_HSPACE            0x0001

/**
 * @brief Flags modifying the behavior of SIGNDOC_Document_findText(): Ignore hyphenation (not yet implemented).
 */
#define SIGNDOC_DOCUMENT_FINDTEXTFLAGS_IGNORE_HYPHENATION       0x0002

/**
 * @brief Flags modifying the behavior of SIGNDOC_Document_findText():
 *        Use character positions instead of sequence (can be expensive, not yet implemented).
 */
#define SIGNDOC_DOCUMENT_FINDTEXTFLAGS_IGNORE_SEQUENCE          0x0004

/**
 * @brief Flags modifying the behavior of SIGNDOC_Document_exportFields() and SIGNDOC_Document_exportProperties():
 *        Include XML declaration and schema for top-level element.
 */
#define SIGNDOC_DOCUMENT_EXPORTFLAGS_TOP                0x01

/**
 * @brief Flags modifying the behavior of SIGNDOC_Document_importProperties(): Modify all properties from XML or none (on error).
 */
#define SIGNDOC_DOCUMENT_IMPORTFLAGS_ATOMIC             0x01

/**
 * @brief Flags modifying the behavior of SIGNDOC_Document_addImageFromBlob(),
 *        SIGNDOC_Document_addImageFromFile(), SIGNDOC_Document_importPageFromImageBlob(), and
 *        SIGNDOC_Document_importPageFromImageFile():
 *        Keep aspect ratio of image, center image on white background.
 */
#define SIGNDOC_DOCUMENT_IMPORTIMAGEFLAGS_KEEP_ASPECT_RATIO     0x01

/**
 * @brief Flags modifying the behavior of SIGNDOC_Document_addImageFromBlob(),
 *        SIGNDOC_Document_addImageFromFile(), SIGNDOC_Document_importPageFromImageBlob(), and
 *        SIGNDOC_Document_importPageFromImageFile():
 *        Make the brightest color transparent.
 *
 * This flag may be specified for SIGNDOC_Document_addImageFromBlob()
 * and SIGNDOC_Document_addImageFromFile()
 * only. SIGNDOC_Document_importPageFromImageBlob() and
 * SIGNDOC_Document_importPageFromImageFile() always make the image
 * opaque.
 *
 * The rest of this description applies to
 * SIGNDOC_Document_addImageFromBlob() and
 * SIGNDOC_Document_addImageFromFile() only.
 *
 * If the image has an alpha channel (or if its palette contains a
 * transparent color), this flag will be ignored and the image's
 * transparency will be used.
 *
 * Transparency is not supported for JPEG images and JPEG-compressed
 * TIFF images.
 *
 * If this flag is not set, the image will be opaque unless the
 * image has an alpha channel or transparent colors in its
 * palette.
 *
 * If this flag is set (and the image doesn't have an alpha
 * channel and doesn't have transparent colors in its palette),
 * white will be made transparent for truecolor images and the
 * brightest color in the palette will be made transparent for
 * indexed images (including grayscale images).
 */
#define SIGNDOC_DOCUMENT_IMPORTIMAGEFLAGS_BRIGHTEST_TRANSPARENT 0x02

/**
 * @brief Tell SIGNDOC_Document_removePages() to keep or to remove the specified pages:
 *        Keep the specified pages, remove all other pages.
 */
#define SIGNDOC_DOCUMENT_KEEPORREMOVE_KEEP              0

/**
 * @brief Tell SIGNDOC_Document_removePages() to keep or to remove the specified pages:
 *        Remove the specified pages, keep all other pages.
 */
#define SIGNDOC_DOCUMENT_KEEPORREMOVE_REMOVE            1

/**
 * @brief Return code: No error.
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_OK                  0

/**
 * @brief Return code: Invalid argument.
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_INVALID_ARGUMENT    1

/**
 * @brief Return code: Field not found (or not a signature field).
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_FIELD_NOT_FOUND     2

/**
 * @brief Return code: Profile unknown or not applicable.
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_INVALID_PROFILE     3

/**
 * @brief Return code: Invalid image (e.g., unsupported format).
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_INVALID_IMAGE       4

/**
 * @brief Return code: Field type or property type mismatch.
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_TYPE_MISMATCH       5

/**
 * @brief Return code: The requested font could not be found or does not contain all required characters.
 *
 * See also see also SIGNDOC_Document_setShootInFoot().
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_FONT_NOT_FOUND      6

/**
 * @brief Return code: No datablock found (obsolete).
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_NO_DATABLOCK        7

/**
 * @brief Return code: Operation not supported.
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_NOT_SUPPORTED       8

/**
 * @brief Return code: I/O error.
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_IO_ERROR            9

/**
 * @brief Return code: (used by SignDocVerificationResult)
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_NOT_VERIFIED        10

/**
 * @brief Return code: Property not found.
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_PROPERTY_NOT_FOUND  11

/**
 * @brief Return code: Page not found (invalid page number).
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_PAGE_NOT_FOUND      12

/**
 * @brief Return code: Property accessed via wrong collection.
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_WRONG_COLLECTION    13

/**
 * @brief Return code: Field already exists.
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_FIELD_EXISTS        14

/**
 * @brief Return code: License initialization failed or license check failed.
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_LICENSE_ERROR       15

/**
 * @brief Return code: Unexpected error.
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_UNEXPECTED_ERROR    16

/**
 * @brief Return code: Certificate dialog cancelled by user.
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_CANCELLED           17

/**
 * @brief Return code: (used by SignDocVerificationResult)
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_NO_BIOMETRIC_DATA   18

/**
 * @brief Return code: (Java only)
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_PARAMETER_NOT_SET   19

/**
 * @brief Return code: Field not signed, for SIGNDOC_Document_copyAsSignedToStream().
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_FIELD_NOT_SIGNED    20

/**
 * @brief Return code: Signature is not valid, for SIGNDOC_Document_copyAsSignedToStream().
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_INVALID_SIGNATURE   21

/**
 * @brief Return code: Annotation not found, for SIGNDOC_Document_getAnnotation().
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_ANNOTATION_NOT_FOUND        22

/**
 * @brief Return code: Attachment not found.
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_ATTACHMENT_NOT_FOUND        23

/**
 * @brief Return code: Attachment already exists.
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_ATTACHMENT_EXISTS   24

/**
 * @brief Return code: No (matching) certificate found and
 *        #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_CREATE_SELF_SIGNED
 *        is not specified.
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_NO_CERTIFICATE      25

/**
 * @brief Return code: More than one matching certificate found and
 *        #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_NEVER_ASK
 *        is specified.
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_AMBIGUOUS_CERTIFICATE       26

/**
 * @brief Return code: Operation not allowed due to document being signed
 *        or conforming to PDF/A.
 *
 * @see SIGNDOC_Document_setShootInFoot()
 */
#define SIGNDOC_DOCUMENT_RETURNCODE_NOT_ALLOWED                 27

/**
 * @brief Result of SIGNDOC_Document_checkAttachment():
 *        The attachment matches its checksum.
 */
#define SIGNDOC_DOCUMENT_CHECKATTACHMENTRESULT_MATCH            0

/**
 * @brief Result of SIGNDOC_Document_checkAttachment():
 *        The attachment does not have a checksum.
 */
#define SIGNDOC_DOCUMENT_CHECKATTACHMENTRESULT_NO_CHECKSUM      1

/**
 * @brief Result of SIGNDOC_Document_checkAttachment():
 *        The attachment does not match its checksum.
 */
#define SIGNDOC_DOCUMENT_CHECKATTACHMENTRESULT_MISMATCH         2

/**
 * @brief Horizontal alignment for SIGNDOC_Document_addTextRect(): left.
 */
#define SIGNDOC_DOCUMENT_HALIGNMENT_LEFT        0

/**
 * @brief Horizontal alignment for SIGNDOC_Document_addTextRect(): center.
 */
#define SIGNDOC_DOCUMENT_HALIGNMENT_CENTER      1

/**
 * @brief Horizontal alignment for SIGNDOC_Document_addTextRect(): right.
 */
#define SIGNDOC_DOCUMENT_HALIGNMENT_RIGHT       2

/**
 * @brief Vertical alignment for SIGNDOC_Document_addTextRect(): top.
 */
#define SIGNDOC_DOCUMENT_VALIGNMENT_TOP         0

/**
 * @brief Vertical alignment for SIGNDOC_Document_addTextRect(): center.
 */
#define SIGNDOC_DOCUMENT_VALIGNMENT_CENTER      1

/**
 * @brief Vertical alignment for SIGNDOC_Document_addTextRect(): bottom.
 */
#define SIGNDOC_DOCUMENT_VALIGNMENT_BOTTOM      2

/**
 * @brief Flag for SIGNDOC_Document_setShootInFoot():
 *        Allow operations to break existing signatures in signature fields.
 *
 * This flag is available for PDF documents only.
 *
 * @see #SIGNDOC_DOCUMENT_SHOOTINFOOTFLAGS_ALLOW_BREAKING_PERMISSIONS, #SIGNDOC_DOCUMENT_SHOOTINFOOTFLAGS_ALLOW_INVALID_CERTIFICATE
 */
#define SIGNDOC_DOCUMENT_SHOOTINFOOTFLAGS_ALLOW_BREAKING_SIGNATURES     0x01

/**
 * @brief Flag for SIGNDOC_Document_setShootInFoot():
 *        Allow operations to break signatures which grant permissions.
 *
 * This flag is available for PDF documents only.
 *
 * @see #SIGNDOC_DOCUMENT_SHOOTINFOOTFLAGS_ALLOW_BREAKING_SIGNATURES, #SIGNDOC_DOCUMENT_SHOOTINFOOTFLAGS_ALLOW_INVALID_CERTIFICATE
 */
#define SIGNDOC_DOCUMENT_SHOOTINFOOTFLAGS_ALLOW_BREAKING_PERMISSIONS    0x02

/**
 * @brief Flag for SIGNDOC_Document_setShootInFoot():
 *        Allow signing with a certificate that is not yet valid
 *        or no longer valid or which is not qualified for
 *        digital signatures.
 *
 * @see #SIGNDOC_DOCUMENT_SHOOTINFOOTFLAGS_ALLOW_BREAKING_SIGNATURES, #SIGNDOC_DOCUMENT_SHOOTINFOOTFLAGS_ALLOW_BREAKING_SIGNATURES
 */
#define SIGNDOC_DOCUMENT_SHOOTINFOOTFLAGS_ALLOW_INVALID_CERTIFICATE     0x04

/**
 * @brief Flag for SIGNDOC_Document_setShootInFoot():
 *        Allow non-standard usage of external (non-embedded)
 *        TrueType fonts.
 *
 * If this flag is not set, TrueType fonts must be embedded; when
 * trying to use a TrueType font that is not embededded, error
 * SIGNDOC_DOCUMENT_RETURNCODE_FONT_NOT_FOUND will be reported.
 *
 * If this flag is set, external TrueType fonts are allowed.
 * However, the document will violate Table 117, section 9.7.4.2
 * and section 9.7.5.2 of ISO 32000-1:2008.
 */
#define SIGNDOC_DOCUMENT_SHOOTINFOOTFLAGS_ALLOW_NON_STANDARD_EXTERNAL_FONTS  0x08

/**
 * @brief Flag for SIGNDOC_Document_setShootInFoot():
 *        Assume that appearance dictionaries and appearance streams
 *        are not shared.
 *
 * If this flag is set and that assumption doesn't hold, changing one
 * field may change the appearances of other fields.
 *
 * At most one of
 * SIGNDOC_DOCUMENT_SHOOTINFOOTFLAGS_ASSUME_AP_NOT_SHARED and
 * #SIGNDOC_DOCUMENT_SHOOTINFOOTFLAGS_ASSUME_AP_SHARED can be set. If
 * neither flag is set, SIGNDOC_Document_setField() and
 * SIGNDOC_Document_addSignature() look for shared objects. This can
 * be expensive in terms of time and memory.
 */
#define SIGNDOC_DOCUMENT_SHOOTINFOOTFLAGS_ASSUME_AP_NOT_SHARED          0x10

/**
 * @brief Flag for SIGNDOC_Document_setShootInFoot():
 *        Always assume that appearance dictionaries and appearance
 *        streams are shared.
 *
 * Setting this flag partially simulates the behavior of SignDoc SDK
 * 3.x and older and causes a minor violation of section 12.7.3.3 of
 * ISO 32000-1:2008 by SIGNDOC_Document_setField().
 *
 * At most one of
 * #SIGNDOC_DOCUMENT_SHOOTINFOOTFLAGS_ASSUME_AP_NOT_SHARED and
 * SIGNDOC_DOCUMENT_SHOOTINFOOTFLAGS_ASSUME_AP_SHARED can be set. If
 * neither flag is set, SIGNDOC_Document_setField() and
 * SIGNDOC_Document_addSignature() look for shared objects. This can
 * be expensive in terms of time and memory.
 */
#define SIGNDOC_DOCUMENT_SHOOTINFOOTFLAGS_ASSUME_AP_SHARED              0x20

/**
 * @brief Specify which expiry date shall be used by SIGNDOC_DocumentLoader_getRemainingDays():
 *        Use the expiry date for the product.
 */
#define SIGNDOC_DOCUMENTLOADER_REMAININGDAYS_PRODUCT    0

/**
 * @brief Specify which expiry date shall be used by SIGNDOC_DocumentLoader_getRemainingDays():
 *        Use the expiry date for signing documents.
 */
#define SIGNDOC_DOCUMENTLOADER_REMAININGDAYS_SIGNING    1

/**
 * @brief Field types: Unknown type.
 *
 * Most field types are supported for PDF documents only.
 */
#define SIGNDOC_FIELD_TYPE_UNKNOWN      0

/**
 * @brief Field types: Pushbutton (PDF).
 *
 * Most field types are supported for PDF documents only.
 */
#define SIGNDOC_FIELD_TYPE_PUSHBUTTON   1

/**
 * @brief Field types: Check box field (PDF).
 *
 * Most field types are supported for PDF documents only.
 */
#define SIGNDOC_FIELD_TYPE_CHECK_BOX    2

/**
 * @brief Field types: Radio button (radio button group) (PDF).
 *
 * Most field types are supported for PDF documents only.
 */
#define SIGNDOC_FIELD_TYPE_RADIO_BUTTON 3

/**
 * @brief Field types: Text field (PDF).
 *
 * Most field types are supported for PDF documents only.
 */
#define SIGNDOC_FIELD_TYPE_TEXT         4

/**
 * @brief Field types: List box (PDF).
 *
 * Most field types are supported for PDF documents only.
 */
#define SIGNDOC_FIELD_TYPE_LIST_BOX     5

/**
 * @brief Field types: Digital signature field (Adobe DigSig in PDF, SOFTPRO signature in TIFF).
 *
 * Most field types are supported for PDF documents only.
 */
#define SIGNDOC_FIELD_TYPE_SIGNATURE_DIGSIG 6

/**
 * @brief Field types: Digital signature field (traditional SignDoc, no longer supported) (PDF).
 *
 * Most field types are supported for PDF documents only.
 */
#define SIGNDOC_FIELD_TYPE_SIGNATURE_SIGNDOC 7

/**
 * @brief Field types: Combo box (drop-down box) (PDF).
 *
 * Most field types are supported for PDF documents only.
 */
#define SIGNDOC_FIELD_TYPE_COMBO_BOX    8

/**
 * @brief Field flags: ReadOnly.
 *
 * See the PDF Reference for the meaning of these flags.
 * Most field flags are supported for PDF documents only.
 *
 * @see SIGNDOC_Field_getFlags(), SIGNDOC_Field_setFlags(), SIGNDOC_Document_clearSignature()
 */
#define SIGNDOC_FIELD_FLAG_READONLY     (1 << 0)

/**
 * @brief Field flags: Required.
 *
 * See the PDF Reference for the meaning of these flags.
 * Most field flags are supported for PDF documents only.
 *
 * @see SIGNDOC_Field_getFlags(), SIGNDOC_Field_setFlags(), SIGNDOC_Document_clearSignature()
 */
#define SIGNDOC_FIELD_FLAG_REQUIRED     (1 << 1)

/**
 * @brief Field flags: NoExport.
 *
 * See the PDF Reference for the meaning of these flags.
 * Most field flags are supported for PDF documents only.
 *
 * @see SIGNDOC_Field_getFlags(), SIGNDOC_Field_setFlags(), SIGNDOC_Document_clearSignature()
 */
#define SIGNDOC_FIELD_FLAG_NOEXPORT     (1 << 2)

/**
 * @brief Field flags: NoToggleToOff.
 *
 * See the PDF Reference for the meaning of these flags.
 * Most field flags are supported for PDF documents only.
 *
 * The #SIGNDOC_FIELD_FLAG_NOTOGGLETOOFF should be set for all radio button groups.
 * Adobe products seem to ignore this flag being not set.
 *
 * @see SIGNDOC_Field_getFlags(), SIGNDOC_Field_setFlags(), SIGNDOC_Document_clearSignature()
 */
#define SIGNDOC_FIELD_FLAG_NOTOGGLETOOFF (1 << 3)

/**
 * @brief Field flags: Radio.
 *
 * See the PDF Reference for the meaning of these flags.
 * Most field flags are supported for PDF documents only.
 *
 * @see SIGNDOC_Field_getFlags(), SIGNDOC_Field_setFlags(), SIGNDOC_Document_clearSignature()
 */
#define SIGNDOC_FIELD_FLAG_RADIO        (1 << 4)

/**
 * @brief Field flags: Pushbutton.
 *
 * See the PDF Reference for the meaning of these flags.
 * Most field flags are supported for PDF documents only.
 *
 * @see SIGNDOC_Field_getFlags(), SIGNDOC_Field_setFlags(), SIGNDOC_Document_clearSignature()
 */
#define SIGNDOC_FIELD_FLAG_PUSHBUTTON   (1 << 5)

/**
 * @brief Field flags: RadiosInUnison.
 *
 * See the PDF Reference for the meaning of these flags.
 * Most field flags are supported for PDF documents only.
 *
 * @see SIGNDOC_Field_getFlags(), SIGNDOC_Field_setFlags(), SIGNDOC_Document_clearSignature()
 */
#define SIGNDOC_FIELD_FLAG_RADIOSINUNISON (1 << 6)

/**
 * @brief Field flags: Multiline (for text fields).
 *
 * See the PDF Reference for the meaning of these flags.
 * Most field flags are supported for PDF documents only.
 *
 * @see SIGNDOC_Field_getFlags(), SIGNDOC_Field_setFlags(), SIGNDOC_Document_clearSignature()
 */
#define SIGNDOC_FIELD_FLAG_MULTILINE    (1 << 7)

/**
 * @brief Field flags: Password.
 *
 * See the PDF Reference for the meaning of these flags.
 * Most field flags are supported for PDF documents only.
 *
 * @see SIGNDOC_Field_getFlags(), SIGNDOC_Field_setFlags(), SIGNDOC_Document_clearSignature()
 */
#define SIGNDOC_FIELD_FLAG_PASSWORD     (1 << 8)

/**
 * @brief Field flags: FileSelect.
 *
 * See the PDF Reference for the meaning of these flags.
 * Most field flags are supported for PDF documents only.
 *
 * @see SIGNDOC_Field_getFlags(), SIGNDOC_Field_setFlags(), SIGNDOC_Document_clearSignature()
 */
#define SIGNDOC_FIELD_FLAG_FILESELECT   (1 << 9)

/**
 * @brief Field flags: DoNotSpellCheck.
 *
 * See the PDF Reference for the meaning of these flags.
 * Most field flags are supported for PDF documents only.
 *
 * @see SIGNDOC_Field_getFlags(), SIGNDOC_Field_setFlags(), SIGNDOC_Document_clearSignature()
 */
#define SIGNDOC_FIELD_FLAG_DONOTSPELLCHECK      (1 << 10)

/**
 * @brief Field flags: DoNotScroll.
 *
 * See the PDF Reference for the meaning of these flags.
 * Most field flags are supported for PDF documents only.
 *
 * @see SIGNDOC_Field_getFlags(), SIGNDOC_Field_setFlags(), SIGNDOC_Document_clearSignature()
 */
#define SIGNDOC_FIELD_FLAG_DONOTSCROLL  (1 << 11)

/**
 * @brief Field flags: Comb.
 *
 * See the PDF Reference for the meaning of these flags.
 * Most field flags are supported for PDF documents only.
 *
 * @see SIGNDOC_Field_getFlags(), SIGNDOC_Field_setFlags(), SIGNDOC_Document_clearSignature()
 */
#define SIGNDOC_FIELD_FLAG_COMB         (1 << 12)

/**
 * @brief Field flags: RichText.
 *
 * See the PDF Reference for the meaning of these flags.
 * Most field flags are supported for PDF documents only.
 *
 * @see SIGNDOC_Field_getFlags(), SIGNDOC_Field_setFlags(), SIGNDOC_Document_clearSignature()
 */
#define SIGNDOC_FIELD_FLAG_RICHTEXT     (1 << 13)

/**
 * @brief Field flags: Combo (always set for combo boxes).
 *
 * See the PDF Reference for the meaning of these flags.
 * Most field flags are supported for PDF documents only.
 *
 * @see SIGNDOC_Field_getFlags(), SIGNDOC_Field_setFlags(), SIGNDOC_Document_clearSignature()
 */
#define SIGNDOC_FIELD_FLAG_COMBO        (1 << 14)

/**
 * @brief Field flags: Edit (for combo boxes): If this flag is set, the user can enter an arbitrary value.
 *
 * See the PDF Reference for the meaning of these flags.
 * Most field flags are supported for PDF documents only.
 *
 * @see SIGNDOC_Field_getFlags(), SIGNDOC_Field_setFlags(), SIGNDOC_Document_clearSignature()
 */
#define SIGNDOC_FIELD_FLAG_EDIT         (1 << 15)

/**
 * @brief Field flags: Sort (for list boxes and combo boxes).
 *
 * See the PDF Reference for the meaning of these flags.
 * Most field flags are supported for PDF documents only.
 *
 * @see SIGNDOC_Field_getFlags(), SIGNDOC_Field_setFlags(), SIGNDOC_Document_clearSignature()
 */
#define SIGNDOC_FIELD_FLAG_SORT         (1 << 16)

/**
 * @brief Field flags: MultiSelect (for list boxes).
 *
 * See the PDF Reference for the meaning of these flags.
 * Most field flags are supported for PDF documents only.
 *
 * @see SIGNDOC_Field_getFlags(), SIGNDOC_Field_setFlags(), SIGNDOC_Document_clearSignature()
 */
#define SIGNDOC_FIELD_FLAG_MULTISELECT  (1 << 17)

/**
 * @brief Field flags: CommitOnSelChange (for list boxes and combo boxes).
 *
 * See the PDF Reference for the meaning of these flags.
 * Most field flags are supported for PDF documents only.
 *
 * @see SIGNDOC_Field_getFlags(), SIGNDOC_Field_setFlags(), SIGNDOC_Document_clearSignature()
 */
#define SIGNDOC_FIELD_FLAG_COMMITONSELCHANGE    (1 << 18)

/**
 * @brief Field flags: Signature applies to the containing page only (TIFF only).
 *
 * The #SIGNDOC_FIELD_FLAG_INVISIBLE, #SIGNDOC_FIELD_FLAG_ENABLEADDAFTERSIGNING,
 * and #SIGNDOC_FIELD_FLAG_SINGLEPAGE flags cannot be modified.
 *
 * By default, signing a signature field signs the complete
 * document, that is, modifications to any page are detected.  For
 * TIFF documents, this behavior can be changed for signature fields
 * that have the #SIGNDOC_FIELD_FLAG_ENABLEADDAFTERSIGNING flag set: If the
 * #SIGNDOC_FIELD_FLAG_SINGLEPAGE flag is set, the signature applies only to the page
 * containing the signature field, modifications to other pages
 * won't be detected.  This flag can be used for speeding up
 * verification of signatures.
 *
 * @see SIGNDOC_Field_getFlags(), SIGNDOC_Field_setFlags(), SIGNDOC_Document_clearSignature()
 */
#define SIGNDOC_FIELD_FLAG_SINGLEPAGE   (1 << 28)

/**
 * @brief Field flags: Signature fields can be inserted after signing this field (TIFF only).
 *
 * The #SIGNDOC_FIELD_FLAG_INVISIBLE, #SIGNDOC_FIELD_FLAG_ENABLEADDAFTERSIGNING,
 * and #SIGNDOC_FIELD_FLAG_SINGLEPAGE flags cannot be modified.
 *
 * By default, no fields can be inserted into a TIFF document
 * after a signature field has been signed.  The #SIGNDOC_FIELD_FLAG_ENABLEADDAFTERSIGNING
 * flag changes this behavior.  (#SIGNDOC_FIELD_FLAG_ENABLEADDAFTERSIGNING is ignored
 * for PDF documents.)
 *
 * If the #SIGNDOC_FIELD_FLAG_ENABLEADDAFTERSIGNING flag is set, document size
 * increases more during signing this field than when this flaq is
 * not set. Each signature will increase the document size by the
 * initial size of the document (before the first signature was
 * applied), approximately.  That is, the first signature will
 * approximately double the size of the document.
 *
 * Inserting a signature field fails if there already are any
 * signed signature fields that don't have this flag set.
 *
 * A signature field for which #SIGNDOC_FIELD_FLAG_ENABLEADDAFTERSIGNING is not set
 * (in a TIFF document) can only be cleared if no other signature
 * fields that don't have #SIGNDOC_FIELD_FLAG_ENABLEADDAFTERSIGNING have been signed
 * after the signature field to be cleared.  Signature fields
 * having #SIGNDOC_FIELD_FLAG_ENABLEADDAFTERSIGNING set can always be cleared.
 *
 * @see SIGNDOC_Field_getFlags(), SIGNDOC_Field_setFlags(), SIGNDOC_Document_clearSignature()
 */
#define SIGNDOC_FIELD_FLAG_ENABLEADDAFTERSIGNING        (1 << 29)

/**
 * @brief Field flags: Invisible (TIFF only).
 *
 * The #SIGNDOC_FIELD_FLAG_INVISIBLE, #SIGNDOC_FIELD_FLAG_ENABLEADDAFTERSIGNING,
 * and #SIGNDOC_FIELD_FLAG_SINGLEPAGE flags cannot be modified.
 *
 * Invisible signature fields (#SIGNDOC_FIELD_FLAG_INVISIBLE) are invisible (ie, they
 * look as if not inserted) until signed. Warning: signing an invisible
 * signature field in a TIFF file may increase the size of the file
 * substantially.
 *
 * @see SIGNDOC_Field_getFlags(), SIGNDOC_Field_setFlags(), SIGNDOC_Document_clearSignature()
 */
#define SIGNDOC_FIELD_FLAG_INVISIBLE    (1 << 30)

/**
 * @brief Annotation flags of a widget: do not display non-standard annotation
 *
 * See the PDF Reference for the meaning of these flags.  All these
 * flags are supported for PDF documents only, they are ignored for
 * TIFF documents.
 *
 * @see SIGNDOC_Field_getWidgetFlags(), SIGNDOC_Field_setWidgetFlags()
 */
#define SIGNDOC_FIELD_WIDGETFLAG_INVISIBLE      (1 << (1 - 1))

/**
 * @brief Annotation flags of a widget: do not display or print or interact
 *
 * See the PDF Reference for the meaning of these flags.  All these
 * flags are supported for PDF documents only, they are ignored for
 * TIFF documents.
 */
#define SIGNDOC_FIELD_WIDGETFLAG_HIDDEN         (1 << (2 - 1))

/**
 * @brief Annotation flags of a widget: print the annotation
 *
 * See the PDF Reference for the meaning of these flags.  All these
 * flags are supported for PDF documents only, they are ignored for
 * TIFF documents.
 */
#define SIGNDOC_FIELD_WIDGETFLAG_PRINT          (1 << (3 - 1))

/**
 * @brief Annotation flags of a widget: do not scale to match magnification
 *
 * See the PDF Reference for the meaning of these flags.  All these
 * flags are supported for PDF documents only, they are ignored for
 * TIFF documents.
 */
#define SIGNDOC_FIELD_WIDGETFLAG_NOZOOM         (1 << (4 - 1))

/**
 * @brief Annotation flags of a widget: do not rotate to match page's rotation
 *
 * See the PDF Reference for the meaning of these flags.  All these
 * flags are supported for PDF documents only, they are ignored for
 * TIFF documents.
 */
#define SIGNDOC_FIELD_WIDGETFLAG_NOROTATE       (1 << (5 - 1))

/**
 * @brief Annotation flags of a widget: do not display or interact
 *
 * See the PDF Reference for the meaning of these flags.  All these
 * flags are supported for PDF documents only, they are ignored for
 * TIFF documents.
 */
#define SIGNDOC_FIELD_WIDGETFLAG_NOVIEW         (1 << (6 - 1))

/**
 * @brief Annotation flags of a widget: do not interact
 *
 * See the PDF Reference for the meaning of these flags.  All these
 * flags are supported for PDF documents only, they are ignored for
 * TIFF documents.
 */
#define SIGNDOC_FIELD_WIDGETFLAG_READONLY       (1 << (7 - 1))

/**
 * @brief Annotation flags of a widget: annotation cannot be deleted or modified, but its value can be changed
 *
 * See the PDF Reference for the meaning of these flags.  All these
 * flags are supported for PDF documents only, they are ignored for
 * TIFF documents.
 */
#define SIGNDOC_FIELD_WIDGETFLAG_LOCKED         (1 << (8 - 1))

/**
 * @brief Annotation flags of a widget: toggle #SIGNDOC_FIELD_WIDGETFLAG_NOVIEW for certain events
 *
 * See the PDF Reference for the meaning of these flags.  All these
 * flags are supported for PDF documents only, they are ignored for
 * TIFF documents.
 */
#define SIGNDOC_FIELD_WIDGETFLAG_TOGGLENOVIEW   (1 << (9 - 1))

/**
 * @brief Annotation flags of a widget: value cannot be changed
 *
 * See the PDF Reference for the meaning of these flags.  All these
 * flags are supported for PDF documents only, they are ignored for
 * TIFF documents.
 */
#define SIGNDOC_FIELD_WIDGETFLAG_LOCKEDCONTENTS ( 1 << 9)

/**
 * @brief Text field justification: Non-text field (justification does not apply).
 *
 * @see SIGNDOC_Field_getJustification(), SIGNDOC_Field_setJustification()
 */
#define SIGNDOC_FIELD_JUSTIFICATION_NONE        0

/**
 * @brief Text field justification: Left-justified.
 *
 * @see SIGNDOC_Field_getJustification(), SIGNDOC_Field_setJustification()
 */
#define SIGNDOC_FIELD_JUSTIFICATION_LEFT        1

/**
 * @brief Text field justification: Centered.
 *
 * @see SIGNDOC_Field_getJustification(), SIGNDOC_Field_setJustification()
 */
#define SIGNDOC_FIELD_JUSTIFICATION_CENTER      2

/**
 * @brief Text field justification: Right-justified.
 *
 * @see SIGNDOC_Field_getJustification(), SIGNDOC_Field_setJustification()
 */
#define SIGNDOC_FIELD_JUSTIFICATION_RIGHT       3

/**
 * @brief Fields to be locked when signing this signature field:
 *        Not a signature field.
 *
 * @see SIGNDOC_Field_getLockType(), SIGNDOC_Field_setLockType()
   */
#define SIGNDOC_FIELD_LOCKTYPE_NA       0

/**
 * @brief Fields to be locked when signing this signature field: Don't lock any fields.
 *
 * @see SIGNDOC_Field_getLockType(), SIGNDOC_Field_setLockType()
 */
#define SIGNDOC_FIELD_LOCKTYPE_NONE     1

/**
 * @brief Fields to be locked when signing this signature field:
 *        Lock all fields in the document.
 *
 * @see SIGNDOC_Field_getLockType(), SIGNDOC_Field_setLockType()
 */
#define SIGNDOC_FIELD_LOCKTYPE_ALL      2

/**
 * @brief Fields to be locked when signing this signature field:
 *        Lock all lock fields specified by SIGNDOC_Field_addLockField() etc.
 *
 * @see SIGNDOC_Field_getLockType(), SIGNDOC_Field_setLockType()
 */
#define SIGNDOC_FIELD_LOCKTYPE_INCLUDE  3

/**
 * @brief Fields to be locked when signing this signature field:
 *        Lock all fields except the lock fields specified by SIGNDOC_Field_addLockField() etc.
 *
 * @see SIGNDOC_Field_getLockType(), SIGNDOC_Field_setLockType()
 */
#define SIGNDOC_FIELD_LOCKTYPE_EXCLUDE  4

/**
 * @brief Bit masks for SIGNDOC_Field_getCertSeedValueFlags() and SIGNDOC_Field_setCertSeedValueFlags():
 *        SubjectCert.
 */
#define SIGNDOC_FIELD_CERTSEEDVALUEFLAG_SUBJECTCERT     0x01

/**
 * @brief Bit masks for SIGNDOC_Field_getCertSeedValueFlags() and SIGNDOC_Field_setCertSeedValueFlags():
 *        IssuerCert.
 */
#define SIGNDOC_FIELD_CERTSEEDVALUEFLAG_ISSUERCERT      0x02

/**
 * @brief Bit masks for SIGNDOC_Field_getCertSeedValueFlags() and SIGNDOC_Field_setCertSeedValueFlags():
 *        Policy.
 */
#define SIGNDOC_FIELD_CERTSEEDVALUEFLAG_POLICY          0x04

/**
 * @brief Bit masks for SIGNDOC_Field_getCertSeedValueFlags() and SIGNDOC_Field_setCertSeedValueFlags():
 *        SubjectDN.
 */
#define SIGNDOC_FIELD_CERTSEEDVALUEFLAG_SUBJECTDN       0x08

/**
 * @brief Bit masks for SIGNDOC_Field_getCertSeedValueFlags() and SIGNDOC_Field_setCertSeedValueFlags():
 *        KeyUsage.
 */
#define SIGNDOC_FIELD_CERTSEEDVALUEFLAG_KEYUSAGE        0x20

/**
 * @brief Bit masks for SIGNDOC_Field_getCertSeedValueFlags() and SIGNDOC_Field_setCertSeedValueFlags():
 *        URL.
 */
#define SIGNDOC_FIELD_CERTSEEDVALUEFLAG_URL             0x40

/**
 * @brief Property types: string.
 */
#define SIGNDOC_PROPERTY_TYPE_STRING    0

/**
 * @brief Property types: integer.
 */
#define SIGNDOC_PROPERTY_TYPE_INTEGER   1

/**
 * @brief Property types: boolean.
 */
#define SIGNDOC_PROPERTY_TYPE_BOOLEAN   2

/**
 * @brief Interlacing methods for SIGNDOC_RenderParameters_setInterlacing():
 *        No interlacing.
 */
#define SIGNDOC_RENDERPARAMETERS_INTERLACING_OFF        0

/**
 * @brief Interlacing methods for SIGNDOC_RenderParameters_setInterlacing():
 *        Enable Interlacing.
 *
 * A suitable interlacing method for the chosen image format will be used.
 */
#define SIGNDOC_RENDERPARAMETERS_INTERLACING_ON         1

/**
 * @brief Quality of the rendered image: Low quality, fast.
 */
#define SIGNDOC_RENDERPARAMETERS_QUALITY_LOW            0

/**
 * @brief Quality of the rendered image: High quality, slow.
 */
#define SIGNDOC_RENDERPARAMETERS_QUALITY_HIGH           1

/**
 * @brief Pixel format for the rendered image:
 *        RGB for PDF documents, same as document for TIFF documents.
 */
#define SIGNDOC_RENDERPARAMETERS_PIXELFORMAT_DEFAULT    0

/**
 * @brief Pixel format for the rendered image:
 *        Black and white (1 bit per pixel).
 */
#define SIGNDOC_RENDERPARAMETERS_PIXELFORMAT_BW         1

/**
 * @brief Compression for the rendered image:
 *        no compression for PDF documents, same as document for TIFF documents.
 *
 * Not all compressions are available for all formats.
 * In fact, all these compressions are available for TIFF only.
 */
#define SIGNDOC_RENDERPARAMETERS_COMPRESSION_DEFAULT    0

/**
 * @brief Compression for the rendered image:
 *        no compression
 *
 * Not all compressions are available for all formats.
 * In fact, all these compressions are available for TIFF only.
 */
#define SIGNDOC_RENDERPARAMETERS_COMPRESSION_NONE       1

/**
 * @brief Compression for the rendered image:
 *        CCITT Group 4.
 *
 * Not all compressions are available for all formats.
 * In fact, all these compressions are available for TIFF only.
 */
#define SIGNDOC_RENDERPARAMETERS_COMPRESSION_GROUP4     2

/**
 * @brief Compression for the rendered image:
 *        LZW.
 *
 * Not all compressions are available for all formats.
 * In fact, all these compressions are available for TIFF only.
 */
#define SIGNDOC_RENDERPARAMETERS_COMPRESSION_LZW        3

/**
 * @brief Compression for the rendered image:
 *        RLE.
 *
 * Not all compressions are available for all formats.
 * In fact, all these compressions are available for TIFF only.
 */
#define SIGNDOC_RENDERPARAMETERS_COMPRESSION_RLE        4

/**
 * @brief Compression for the rendered image:
 *        ZIP.
 *
 * Not all compressions are available for all formats.
 * In fact, all these compressions are available for TIFF only.
 */
#define SIGNDOC_RENDERPARAMETERS_COMPRESSION_ZIP        5

/**
 * @brief Policy for verification of the certificate chain:
 *        Don't verify certificate chain.
 *
 * Always pretend that the certificate chain is OK.
 *
 * @see SIGNDOC_RenderParameters_setCertificateChainVerificationPolicy()
 */
#define SIGNDOC_RENDERPARAMETERS_CERTIFICATECHAINVERIFICATIONPOLICY_DONT_VERIFY 0

/**
 * @brief Policy for verification of the certificate chain:
 *        Accept self-signed certificates.
 *
 * If the signing certificate is not self-signed, it must chain up
 * to a trusted root certificate.
 *
 * @see SIGNDOC_RenderParameters_setCertificateChainVerificationPolicy()
 */
#define SIGNDOC_RENDERPARAMETERS_CERTIFICATECHAINVERIFICATIONPOLICY_ACCEPT_SELF_SIGNED 1

/**
 * @brief Policy for verification of the certificate chain:
 *        Accept self-signed certificates if biometric data is present.
 *
 * If the signing certificate is not self-signed or if there is no
 * biometric data, the certificate must chain up to a trusted root
 * certificate.
 *
 * @see SIGNDOC_RenderParameters_setCertificateChainVerificationPolicy()
 */
#define SIGNDOC_RENDERPARAMETERS_CERTIFICATECHAINVERIFICATIONPOLICY_ACCEPT_SELF_SIGNED_WITH_BIO 2

/**
 * @brief Policy for verification of the certificate chain:
 *        Accept self-signed certificates if asymmetrically encrypted biometric data is present.
 *
 * If the signing certificate is not self-signed or if there is no
 * biometric data or if the biometric data is not encrypted with
 * RSA, the certificate must chain up to a trusted root
 * certificate.
 *
 * @see SIGNDOC_RenderParameters_setCertificateChainVerificationPolicy()
 */
#define SIGNDOC_RENDERPARAMETERS_CERTIFICATECHAINVERIFICATIONPOLICY_ACCEPT_SELF_SIGNED_WITH_RSA_BIO 3

/**
 * @brief Policy for verification of the certificate chain:
 *        Require a trusted root certificate.
 *
 * The signing certificate must chain up to a trusted root
 * certificate.
 *
 * @see SIGNDOC_RenderParameters_setCertificateChainVerificationPolicy()
 */
#define SIGNDOC_RENDERPARAMETERS_CERTIFICATECHAINVERIFICATIONPOLICY_REQUIRE_TRUSTED_ROOT 4

/**
 * @brief Policy for verification of certificate revocation:
 *        Don't verify revocation of certificates.
 *
 * @see SIGNDOC_RenderParameters_setCertificateRevocationVerificationPolicy()
 */
#define SIGNDOC_RENDERPARAMETERS_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_DONT_CHECK 0

/**
 * @brief Policy for verification of certificate revocation:
 *        Check revocation, assume that certificates are not revoked if the revocation server is offline.
 *
 * Always pretend that certificates have not been revoked.
 *
 * @see SIGNDOC_RenderParameters_setCertificateRevocationVerificationPolicy()
 */
#define SIGNDOC_RENDERPARAMETERS_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_OFFLINE 1

/**
 * @brief Policy for verification of certificate revocation:
 *        Check revocation, assume that certificates are revoked if the revocation server is offline.
 *
 * @see SIGNDOC_RenderParameters_setCertificateRevocationVerificationPolicy()
 */
#define SIGNDOC_RENDERPARAMETERS_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_ONLINE 2

/**
 * @brief Certificate verification model:
 *        Whatever the Windows Crypto API or OpenSSL implements.
 *
 * @see SIGNDOC_RenderParameters_setVerificationModel()
 */
#define SIGNDOC_RENDERPARAMETERS_VERIFICATIONMODEL_DEFAULT      0

/**
 * @brief Certificate verification model:
 *        As specfified by German law.
 *
 * @see SIGNDOC_RenderParameters_setVerificationModel()
 *
 * @todo implement this
 * @todo name that law
 */
#define SIGNDOC_RENDERPARAMETERS_VERIFICATIONMODEL_GERMAN_SIG_LAW       1

/**
 * @brief Signing methods: This value is no longer used.
 *
 * Used for integer parameter "Method".
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_METHOD_UNUSED_0     0

/**
 * @brief Signing methods: PDF DigSig PKCS #1.
 *
 * Used for integer parameter "Method".
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS1 1

/**
 * @brief Signing methods: PDF DigSig detached PKCS #7.
 *
 * Used for integer parameter "Method".
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED 2

/**
 * @brief Signing methods: PDF DigSig PKCS #7 with SHA-1.
 *
 * Used for integer parameter "Method".
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_SHA1 3

/**
 * @brief Signing methods: The signature is just a hash.
 *
 * Used for integer parameter "Method".
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_METHOD_HASH 4

/**
 * @brief Hash Algorithm to be used for a detached signature:
 *        Best supported hash algorithm.
 *
 * Used for integer parameter "DetachedHashAlgorithm".
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_DETACHEDHASHALGORITHM_DEFAULT       0

/**
 * @brief Hash Algorithm to be used for a detached signature:
 *        SHA-1.
 *
 * Used for integer parameter "DetachedHashAlgorithm".
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_DETACHEDHASHALGORITHM_SHA1          1

/**
 * @brief Hash Algorithm to be used for a detached signature:
 *        SHA-256.
 *
 * Used for integer parameter "DetachedHashAlgorithm".
 *
 * #SIGNDOC_SIGNATUREPARAMETERS_DETACHEDHASHALGORITHM_SHA256 is supported
 * under Linux, iOS, Android, OS X, and under Windows XP SP3 and later.
 * If #SIGNDOC_SIGNATUREPARAMETERS_DETACHEDHASHALGORITHM_SHA256 is selected
 * but not supported, SIGNDOC_Document_addSignature() will fall back to
 * #SIGNDOC_SIGNATUREPARAMETERS_TIMESTAMPHASHALGORITHM_SHA1.
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_DETACHEDHASHALGORITHM_SHA256        2

/**
 * @brief Hash Algorithm to be used for RFC 3161 timestamps:
 *        Currently SHA-1, may change in future.
 *
 * Used for integer parameter "TimeStampHashAlgorithm".
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_TIMESTAMPHASHALGORITHM_DEFAULT      0

/**
 * @brief Hash Algorithm to be used for RFC 3161 timestamps: SHA-1.
 *
 * Used for integer parameter "TimeStampHashAlgorithm".
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_TIMESTAMPHASHALGORITHM_SHA1         1

/**
 * @brief Hash Algorithm to be used for RFC 3161 timestamps: SHA-256.
 *
 * Used for integer parameter "TimeStampHashAlgorithm".
 *
 * #SIGNDOC_SIGNATUREPARAMETERS_TIMESTAMPHASHALGORITHM_SHA256 is supported
 * under Linux, iOS, Android, OS X, and under Windows XP SP3 and later.
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_TIMESTAMPHASHALGORITHM_SHA256       2

/**
 * @brief Optimization of document before signing:
 *        Optimize document before signing for the first time.
 *
 * Used for integer parameter "Optimize".
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_OPTIMIZE_OPTIMIZE           0

/**
 * @brief Optimization of document before signing:
 *        Don't optimize document.
 *
 * Used for integer parameter "Optimize".
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_OPTIMIZE_DONT_OPTIMIZE      1

/**
 * @brief Fix appearance streams of check boxes and radio buttons
 *        for PDF/A documents: Freeze (fix) appearances.
 *
 * Used for integer parameter "PDFAButtons".
 *
 * Using #SIGNDOC_SIGNATUREPARAMETERS_PDFABUTTONS_FREEZE (or
 * #SIGNDOC_SIGNATUREPARAMETERS_PDFABUTTONS_AUTO, if the document
 * claims to be PDF/A-1-compliant and has no signed signature fields)
 * is equivalent to saving the document with
 * #SIGNDOC_DOCUMENT_SAVEFLAGS_PDFA_BUTTONS before signing.
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_PDFABUTTONS_FREEZE          0

/**
 * @brief Fix appearance streams of check boxes and radio buttons
 *        for PDF/A documents: Don't freeze (fix) appearances.
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_PDFABUTTONS_DONT_FREEZE     1

/**
 * @brief Fix appearance streams of check boxes and radio buttons
 *        for PDF/A documents: Freeze (fix) appearances if appropriate.
 *
 * Used for integer parameter "PDFAButtons".
 *
 * Using #SIGNDOC_SIGNATUREPARAMETERS_PDFABUTTONS_FREEZE (or
 * #SIGNDOC_SIGNATUREPARAMETERS_PDFABUTTONS_AUTO, if the document
 * claims to be PDF/A-1-compliant and has no signed signature fields)
 * is equivalent to saving the document with
 * #SIGNDOC_DOCUMENT_SAVEFLAGS_PDFA_BUTTONS before signing.
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_PDFABUTTONS_AUTO    2

/**
 * @brief Signing algorithms for self-signed certificates: SHA1 with RSA.
 *
 * Used for integer parameter "CertificateSigningAlgorithm".
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESIGNINGALGORITHM_SHA1_RSA 0

/**
 * @brief Signing algorithms for self-signed certificates: MD5 with RSA.
 *
 * Used for integer parameter "CertificateSigningAlgorithm".
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESIGNINGALGORITHM_MD5_RSA 1

/**
 * @brief Select how to encrypt the biometric data:
 *        Random session key encrypted with public RSA key.
 *
 * Used for integer parameter "BiometricEncryption".
 * The biometric data to be encrypted is specified by blob parameter
 * "BiometricData".
 *
 * Either blob parameter "BiometricKey" (see SIGNDOC_SignatureParameters_setBlob())
 * or string parameter "BiometricKeyPath" (see SIGNDOC_SignatureParameters_setString()) must be set.
 *
 * @see SIGNDOC_SignatureParameters_setInteger(), SIGNDOC_SignatureParameters_setBlob(), @ref signdocshared_biometric_encryption
 */
#define SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_RSA 0

/**
 * @brief Select how to encrypt the biometric data:
 *        Fixed key (no security).
 *
 * Used for integer parameter "BiometricEncryption".
 * The biometric data to be encrypted is specified by blob parameter
 * "BiometricData".
 *
 * @see SIGNDOC_SignatureParameters_setInteger(), SIGNDOC_SignatureParameters_setBlob()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_FIXED 1

/**
 * @brief Select how to encrypt the biometric data:
 *        Binary 256-bit key.
 *
 * Used for integer parameter "BiometricEncryption".
 * The biometric data to be encrypted is specified by blob parameter
 * "BiometricData".
 *
 * Blob parameter "BiometricKey" (see SIGNDOC_SignatureParameters_setBlob()) must be set.
 *
 * @see SIGNDOC_SignatureParameters_setInteger(), SIGNDOC_SignatureParameters_setBlob()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_BINARY 2

/**
 * @brief Select how to encrypt the biometric data:
 *        Passphrase that will be hashed to a 256-bit key.
 *
 * Used for integer parameter "BiometricEncryption".
 * The biometric data to be encrypted is specified by blob parameter
 * "BiometricData".
 *
 * String parameter "BiometricPassphrase" (see #SIGNDOC_SignatureParameters_setString()) must be set.
 *
 * @see SIGNDOC_SignatureParameters_setInteger(), SIGNDOC_SignatureParameters_setBlob()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_PASSPHRASE 3

/**
 * @brief Select how to encrypt the biometric data:
 *        The biometric data won't be stored in the document.
 *
 * Used for integer parameter "BiometricEncryption".
 *
 * Use this value if you want to use the biometric data for
 * generating the signature image only.  Note that using an
 * automatically generated self-signed certificate is secure only
 * if biometric data is stored in the document using asymmetric
 * encryption.
 *
 * @see SIGNDOC_SignatureParameters_setInteger(), SIGNDOC_SignatureParameters_setBlob()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_DONT_STORE 4

/**
 * @brief Horizontal alignment: left.
 *
 * Used for integer parameters "ImageHAlignment" and "TextHAlignment"
 * (see SIGNDOC_SignatureParameters_setInteger()).
 */
#define SIGNDOC_SIGNATUREPARAMETERS_HALIGNMENT_LEFT 0

/**
 * @brief Horizontal alignment: center.
 *
 * Used for integer parameters "ImageHAlignment" and "TextHAlignment"
 * (see SIGNDOC_SignatureParameters_setInteger()).
 */
#define SIGNDOC_SIGNATUREPARAMETERS_HALIGNMENT_CENTER 1

/**
 * @brief Horizontal alignment: right.
 *
 * Used for integer parameter "ImageHAlignment" and "TextHAlignment"
 * (see SIGNDOC_SignatureParameters_setInteger()).
 */
#define SIGNDOC_SIGNATUREPARAMETERS_HALIGNMENT_RIGHT 2

/**
 * @brief Horizontal alignment: justify.
 *
 * Used for integer parameter "TextHAlignment"
 * (see SIGNDOC_SignatureParameters_setInteger()).
 */
#define SIGNDOC_SIGNATUREPARAMETERS_HALIGNMENT_JUSTIFY 3

/**
 * @brief Vertical alignment: top.
 *
 * Used for integer parameters "ImageVAlignment" and "TextVAlignment"
 * (see SIGNDOC_SignatureParameters_setInteger()).
 */
#define SIGNDOC_SIGNATUREPARAMETERS_VALIGNMENT_TOP 0

/**
 * @brief Vertical alignment: center.
 *
 * Used for integer parameters "ImageVAlignment" and "TextVAlignment"
 * (see SIGNDOC_SignatureParameters_setInteger()).
 */
#define SIGNDOC_SIGNATUREPARAMETERS_VALIGNMENT_CENTER 1

/**
 * @brief Vertical alignment: bottom.
 *
 * Used for integer parameters "ImageVAlignment" and "TextVAlignment"
 * (see SIGNDOC_SignatureParameters_setInteger()).
 */
#define SIGNDOC_SIGNATUREPARAMETERS_VALIGNMENT_BOTTOM 2

/**
 * @brief Position of the text block w.r.t. to the image:
 *        Text and image are independent and overlap (text painted on image).
 *
 * Used for integer parameter "TextPosition" (see
 * SIGNDOC_SignatureParameters_setInteger()).
 */
#define SIGNDOC_SIGNATUREPARAMETERS_TEXTPOSITION_OVERLAY 0

/**
 * @brief Position of the text block w.r.t. to the image:
 *        Text is put below the image, the image is scaled to fit.
 *
 * Used for integer parameter "TextPosition" (see
 * SIGNDOC_SignatureParameters_setInteger()).
 */
#define SIGNDOC_SIGNATUREPARAMETERS_TEXTPOSITION_BELOW 1

/**
 * @brief Position of the text block w.r.t. to the image:
 *        Text and image are independent and overlap (image painted on text).
 *
 * Used for integer parameter "TextPosition" (see
 * SIGNDOC_SignatureParameters_setInteger()).
 */
#define SIGNDOC_SIGNATUREPARAMETERS_TEXTPOSITION_UNDERLAY 2

/**
 * @brief Indicate how measurements are specified:
 *        @a aValue is the value to be used (units of document coordinates).
 *
 * @see SIGNDOC_SignatureParameters_setLength()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_VALUETYPE_ABS 0

/**
 * @brief Indicate how measurements are specified:
 *        Multiply @a aValue by the field height.
 *
 * @see SIGNDOC_SignatureParameters_setLength()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_VALUETYPE_FIELD_HEIGHT 1

/**
 * @brief Indicate how measurements are specified:
 *        Multiply @a aValue by the field width.
 *
 * @see SIGNDOC_SignatureParameters_setLength()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_VALUETYPE_FIELD_WIDTH 2

/**
 * @brief Select a string for the appearance stream of PDF documents:
 *        String parameter "Signer".
 *
 * @see SIGNDOC_SignatureParameters_addTextItem(), SIGNDOC_SignatureParameters_setString()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_TEXTITEM_SIGNER 0

/**
 * @brief Select a string for the appearance stream of PDF documents:
 *        String parameter "SignTime".
 *
 * @see SIGNDOC_SignatureParameters_addTextItem(), SIGNDOC_SignatureParameters_setString()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_TEXTITEM_SIGN_TIME 1

/**
 * @brief Select a string for the appearance stream of PDF documents:
 *        String parameter "Comment".
 *
 * @see SIGNDOC_SignatureParameters_addTextItem(), SIGNDOC_SignatureParameters_setString()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_TEXTITEM_COMMENT 2

/**
 * @brief Select a string for the appearance stream of PDF documents:
 *        String parameter "Adviser".
 *
 * @see SIGNDOC_SignatureParameters_addTextItem(), SIGNDOC_SignatureParameters_setString()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_TEXTITEM_ADVISER 3

/**
 * @brief Select a string for the appearance stream of PDF documents:
 *        String parameter "ContactInfo".
 *
 * @see SIGNDOC_SignatureParameters_addTextItem(), SIGNDOC_SignatureParameters_setString()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_TEXTITEM_CONTACT_INFO 4

/**
 * @brief Select a string for the appearance stream of PDF documents:
 *        String parameter "Location".
 *
 * @see SIGNDOC_SignatureParameters_addTextItem(), SIGNDOC_SignatureParameters_setString()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_TEXTITEM_LOCATION 5

/**
 * @brief Select a string for the appearance stream of PDF documents:
 *        String parameter "Reason".
 *
 * @see SIGNDOC_SignatureParameters_addTextItem(), SIGNDOC_SignatureParameters_setString()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_TEXTITEM_REASON 6

/**
 * @brief Text groups: Master group.
 *
 * One font size is used per group and is chosen such that the text
 * fits horizontally.  The maximum font size is specified by
 * length parameter "FontSize".
 * The font size of the slave group cannot be greater
 * than then font size of the master group, that is, long text in
 * the slave group won't reduce the font size of the master group.
 *
 * @see SIGNDOC_SignatureParameters_addTextItem(), SIGNDOC_SignatureParameters_setLength()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_TEXTGROUP_MASTER 0

/**
 * @brief Text groups: Slave group.
 *
 * @see #SIGNDOC_SIGNATUREPARAMETERS_TEXTGROUP_MASTER
 */
#define SIGNDOC_SIGNATUREPARAMETERS_TEXTGROUP_SLAVE 1

/**
 * @brief Flags for selecting certificates:
 *        include software-based certificates
 *
 * Used for integer parameter "SelectCertificate".
 *
 * If neither
 * #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_ASK_IF_AMBIGUOUS
 * nor #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_NEVER_ASK
 * is included, the certificate selection dialog will be displayed.
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_SOFTWARE  0x01

/**
 * @brief Flags for selecting certificates:
 *        include hardware-based certificates
 *
 * Used for integer parameter "SelectCertificate".
 *
 * If neither
 * #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_ASK_IF_AMBIGUOUS
 * nor #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_NEVER_ASK
 * is included, the certificate selection dialog will be displayed.
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_HARDWARE  0x02

/**
 * @brief Flags for selecting certificates:
 *        include only certificates allowed by the PDF document's certificate seed value dictionary
 *
 * Used for integer parameter "SelectCertificate".
 *
 * If neither
 * #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_ASK_IF_AMBIGUOUS
 * nor #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_NEVER_ASK
 * is included, the certificate selection dialog will be displayed.
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_USE_CERTIFICATE_SEED_VALUES       0x10

/**
 * @brief Flags for selecting certificates:
 *        ask the user to select a certificate if there is more than one matching certificate
 *
 * Used for integer parameter "SelectCertificate".
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_ASK_IF_AMBIGUOUS  0x20

/**
 * @brief Flags for selecting certificates:
 *        never ask the user to select a certificate; exactly one certificate must match
 *
 * Used for integer parameter "SelectCertificate".
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_NEVER_ASK         0x40

/**
 * @brief Flags for selecting certificates:
 *        offer to create a self-signed certificate (cannot be used with #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_NEVER_ASK and #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_ASK_IF_AMBIGUOUS)
 *
 * Used for integer parameter "SelectCertificate".
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_CREATE_SELF_SIGNED        0x80

/**
 * @brief Flags for rendering the signature:
 *        black and white
 *
 * Used for integer parameter "RenderSignature".
 *
 * #SIGNDOC_SIGNATUREPARAMETERS_RENDERSIGNATUREFLAGS_BW,
 * #SIGNDOC_SIGNATUREPARAMETERS_RENDERSIGNATUREFLAGS_GRAY, and
 * #SIGNDOC_SIGNATUREPARAMETERS_RENDERSIGNATUREFLAGS_ANTIALIAS are
 * mutually exclusive.
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_RENDERSIGNATUREFLAGS_BW     0x01

/**
 * @brief Flags for rendering the signature:
 *        use gray levels computed from pressure
 *
 * Used for integer parameter "RenderSignature".
 *
 * #SIGNDOC_SIGNATUREPARAMETERS_RENDERSIGNATUREFLAGS_BW,
 * #SIGNDOC_SIGNATUREPARAMETERS_RENDERSIGNATUREFLAGS_GRAY, and
 * #SIGNDOC_SIGNATUREPARAMETERS_RENDERSIGNATUREFLAGS_ANTIALIAS are
 * mutually exclusive.
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_RENDERSIGNATUREFLAGS_GRAY   0x02

/**
 * @brief Flags for rendering the signature:
 *        use gray levels for antialiasing
 *
 * Used for integer parameter "RenderSignature".
 *
 * #SIGNDOC_SIGNATUREPARAMETERS_RENDERSIGNATUREFLAGS_BW,
 * #SIGNDOC_SIGNATUREPARAMETERS_RENDERSIGNATUREFLAGS_GRAY, and
 * #SIGNDOC_SIGNATUREPARAMETERS_RENDERSIGNATUREFLAGS_ANTIALIAS are
 * mutually exclusive.
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_RENDERSIGNATUREFLAGS_ANTIALIAS      0x04

/**
 * @brief Transparency of signature image:
 *        Make signature image opaque.
 *
 * Used for integer parameter "ImageTransparency".
 *
 * The signature image will be opaque unless the image has an
 * alpha channel or transparent colors in its palette.
 *
 * If the image has an alpha channel (or if its palette contains a
 * transparent color), the image's transparency will be used no matter
 * what value is set for "ImageTransparency".
 *
 * Transparency is not supported for JPEG images and JPEG-compressed
 * TIFF images.
 * Signature images created from biometric data (according to the
 * "RenderSignature" integer parameter) don't have an alpha channel.
 *
 * @see SIGNDOC_SignatureParameters_setInteger()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_IMAGETRANSPARENCY_OPAQUE    0

/**
 * @brief Transparency of signature image:
 *        Make the brightest color transparent.
 *
 * If the image has an alpha channel (or if its palette contains a
 * transparent color), the image's transparency will be used.
 * Otherwise, white will be made transparent for truecolor images
 * and the brightest color in the palette will be made transparent
 * for indexed images (including grayscale images).
 *
 * @see #SIGNDOC_SIGNATUREPARAMETERS_IMAGETRANSPARENCY_OPAQUE
 */
#define SIGNDOC_SIGNATUREPARAMETERS_IMAGETRANSPARENCY_BRIGHTEST 1

/**
 * @brief Return codes: Parameter set successfully.
 */
#define SIGNDOC_SIGNATUREPARAMETERS_RETURNCODE_OK       0

/**
 * @brief Return codes: Unknown parameter.
 */
#define SIGNDOC_SIGNATUREPARAMETERS_RETURNCODE_UNKNOWN  1

/**
 * @brief Return codes: Setting the parameter is not supported.
 */
#define SIGNDOC_SIGNATUREPARAMETERS_RETURNCODE_NOT_SUPPORTED 2

/**
 * @brief Return codes: The value for the parameter is invalid.
 */
#define SIGNDOC_SIGNATUREPARAMETERS_RETURNCODE_INVALID_VALUE 3

/**
 * @brief Parameter has been set (most parameters have a default value
 *        such as the empty string which may be treated as "set" or
 *        "not set" depending on the implementation's fancy).
 *
 *
 * Don't make your code depend on the difference between
 * #SIGNDOC_SIGNATUREPARAMETERS_PARAMETERSTATE_SET and
 * #SIGNDOC_SIGNATUREPARAMETERS_PARAMETERSTATE_SUPPORTED.
 *
 * @see SIGNDOC_SignatureParameters_getState()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_PARAMETERSTATE_SET          0

/**
 * @brief Status of a parameter: Parameter must be set but is not set.
 *
 * @see SIGNDOC_SignatureParameters_getState()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_PARAMETERSTATE_MISSING      1

/**
 * @brief Status of a parameter: Parameter is supported and optional,
 *        but has not been set or is set to the default value.
 *
 * Don't make your code depend on the difference between
 * #SIGNDOC_SIGNATUREPARAMETERS_PARAMETERSTATE_SET and
 * #SIGNDOC_SIGNATUREPARAMETERS_PARAMETERSTATE_SUPPORTED.
 *
 * @see SIGNDOC_SignatureParameters_getState()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_PARAMETERSTATE_SUPPORTED    2

/**
 * @brief Status of a parameter: Parameter can be (or is) set but will
 *        be ignored.
 *
 * @see SIGNDOC_SignatureParameters_getState()
 *
 * @todo implement #SIGNDOC_SIGNATUREPARAMETERS_PARAMETERSTATE_IGNORED
 */
#define SIGNDOC_SIGNATUREPARAMETERS_PARAMETERSTATE_IGNORED      3

/**
 * @brief Status of a parameter: Parameter is not supported for this field.
 *
 * @see SIGNDOC_SignatureParameters_getState()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_PARAMETERSTATE_NOT_SUPPORTED 4

/**
 * @brief Status of a parameter: Unknown parameter.
 *
 * @see SIGNDOC_SignatureParameters_getState()
 */
#define SIGNDOC_SIGNATUREPARAMETERS_PARAMETERSTATE_UNKNOWN      5

/**
 * @brief Return codes: No error.
 */
#define SIGNDOC_VERIFICATIONRESULT_RETURNCODE_OK        SIGNDOC_DOCUMENT_RETURNCODE_OK

/**
 * @brief Return codes: Invalid argument.
 */
#define SIGNDOC_VERIFICATIONRESULT_RETURNCODE_INVALID_ARGUMENT  SIGNDOC_DOCUMENT_RETURNCODE_INVALID_ARGUMENT

/**
 * @brief Return codes: Operation not supported.
 */
#define SIGNDOC_VERIFICATIONRESULT_RETURNCODE_NOT_SUPPORTED     SIGNDOC_DOCUMENT_RETURNCODE_NOT_SUPPORTED

/**
 * @brief Return codes: SIGNDOC_Document_verifySignature() has not been called.
 */
#define SIGNDOC_VERIFICATIONRESULT_RETURNCODE_NOT_VERIFIED      SIGNDOC_DOCUMENT_RETURNCODE_NOT_VERIFIED

/**
 * @brief Return codes: No biometric data (or hash) available.
 */
#define SIGNDOC_VERIFICATIONRESULT_RETURNCODE_NO_BIOMETRIC_DATA SIGNDOC_DOCUMENT_RETURNCODE_NO_BIOMETRIC_DATA

/**
 * @brief Return codes: Unexpected error.
 */
#define SIGNDOC_VERIFICATIONRESULT_RETURNCODE_UNEXPECTED_ERROR  SIGNDOC_DOCUMENT_RETURNCODE_UNEXPECTED_ERROR

/**
 * @brief State of a signature:
 *        No error, signature and document verified.
 *
 * @see SIGNDOC_VerificationResult_getState()
 */
#define SIGNDOC_VERIFICATIONRESULT_SIGNATURESTATE_UNMODIFIED 0

/**
 * @brief State of a signature:
 *        No error, signature and document verified, document modified by
 *        adding data to the signed document.
 *
 * @see SIGNDOC_VerificationResult_getState()
 */
#define SIGNDOC_VERIFICATIONRESULT_SIGNATURESTATE_DOCUMENT_EXTENDED 1

/**
 * @brief State of a signature:
 *        Document modified (possibly forged).
 *
 * @see SIGNDOC_VerificationResult_getState()
 */
#define SIGNDOC_VERIFICATIONRESULT_SIGNATURESTATE_DOCUMENT_MODIFIED 2

/**
 * @brief State of a signature:
 *        Unsupported signature method.
 *
 * @see SIGNDOC_VerificationResult_getState()
 */
#define SIGNDOC_VERIFICATIONRESULT_SIGNATURESTATE_UNSUPPORTED_SIGNATURE 3

/**
 * @brief State of a signature:
 *        Invalid certificate.
 *
 * @see SIGNDOC_VerificationResult_getState()
 */
#define SIGNDOC_VERIFICATIONRESULT_SIGNATURESTATE_INVALID_CERTIFICATE 4

/**
 * @brief State of a signature:
 *        Signature field without signature.
 *
 * @see SIGNDOC_VerificationResult_getState()
 */
#define SIGNDOC_VERIFICATIONRESULT_SIGNATURESTATE_EMPTY 5

/**
 * @brief State of the RFC 3161 time stamp:
 *        No error, an RFC 3161 time stamp is present and valid
 *        (but you have to check the certificate chain and revocation).
 *
 * @see SIGNDOC_VerificationResult_getTimeStampState()
 */
#define SIGNDOC_VERIFICATIONRESULT_TIMESTAMPSTATE_VALID 0

/**
 * @brief State of the RFC 3161 time stamp:
 *        There is no RFC 3161 time stamp.
 *
 * @see SIGNDOC_VerificationResult_getTimeStampState()
 */
#define SIGNDOC_VERIFICATIONRESULT_TIMESTAMPSTATE_MISSING 1

/**
 * @brief State of the RFC 3161 time stamp:
 *        An RFC 3161 time stamp is present but invalid.
 *
 * @see SIGNDOC_VerificationResult_getTimeStampState()
 */
#define SIGNDOC_VERIFICATIONRESULT_TIMESTAMPSTATE_INVALID 2

/**
 * @brief Policy for verification of the certificate chain:
 *        Don't verify the certificate chain.
 *
 * Always pretend that the certificate chain is OK.
 *
 * @see SIGNDOC_VerificationResult_verifyCertificateSimplified(), SIGNDOC_VerificationResult_verifyTimeStampCertificateSimplified()
 */
#define SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINVERIFICATIONPOLICY_DONT_VERIFY 0

/**
 * @brief Policy for verification of the certificate chain:
 *        Accept self-signed certificates.
 *
 * If the signing certificate is not self-signed, it must chain up
 * to a trusted root certificate.
 *
 * @see SIGNDOC_VerificationResult_verifyCertificateSimplified(), SIGNDOC_VerificationResult_verifyTimeStampCertificateSimplified()
 */
#define SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINVERIFICATIONPOLICY_ACCEPT_SELF_SIGNED 1

/**
 * @brief Policy for verification of the certificate chain:
 *        Accept self-signed certificates if biometric data is present.
 *
 * If the signing certificate is not self-signed or if there is no
 * biometric data, the certificate must chain up to a trusted root
 * certificate.
 *
 * @see SIGNDOC_VerificationResult_verifyCertificateSimplified(), SIGNDOC_VerificationResult_verifyTimeStampCertificateSimplified()
 */
#define SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINVERIFICATIONPOLICY_ACCEPT_SELF_SIGNED_WITH_BIO 2

/**
 * @brief Policy for verification of the certificate chain:
 *        Accept self-signed certificates if asymmetrically encrypted biometric data is present.
 *
 * If the signing certificate is not self-signed or if there is no
 * biometric data or if the biometric data is not encrypted with
 * RSA, the certificate must chain up to a trusted root
 * certificate.
 *
 * @see SIGNDOC_VerificationResult_verifyCertificateSimplified(), SIGNDOC_VerificationResult_verifyTimeStampCertificateSimplified()
 */
#define SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINVERIFICATIONPOLICY_ACCEPT_SELF_SIGNED_WITH_RSA_BIO 3

/**
 * @brief Policy for verification of the certificate chain:
 *        Require a trusted root certificate.
 *
 * The signing certificate must chain up to a trusted root
 * certificate.
 *
 * @see SIGNDOC_VerificationResult_verifyCertificateSimplified(), SIGNDOC_VerificationResult_verifyTimeStampCertificateSimplified()
 */
#define SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINVERIFICATIONPOLICY_REQUIRE_TRUSTED_ROOT 4

/**
 * @brief Policy for verification of certificate revocation:
 *        Don't verify revocation of certificates.
 *
 * Always pretend that certificates have not been revoked.
 *
 * @see SIGNDOC_VerificationResult_verifyCertificateSimplified(), SIGNDOC_VerificationResult_verifyTimeStampCertificateSimplified()
 */
#define SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_DONT_CHECK 0

/**
 * @brief Policy for verification of certificate revocation:
 *        Check revocation, assume that certificates are not revoked if the revocation server is offline.
 *
 * @see SIGNDOC_VerificationResult_verifyCertificateSimplified(), SIGNDOC_VerificationResult_verifyTimeStampCertificateSimplified()
 */
#define SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_OFFLINE 1

/**
 * @brief Policy for verification of certificate revocation:
 *        Check revocation, assume that certificates are revoked if the revocation server is offline.
 *
 * @see SIGNDOC_VerificationResult_verifyCertificateSimplified(), SIGNDOC_VerificationResult_verifyTimeStampCertificateSimplified()
 */
#define SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_ONLINE 2

/**
 * @brief Certificate verification model:
 *        Whatever the Windows Crypto API or OpenSSL implements.
 *
 * @see SIGNDOC_VerificationResult_verifyCertificateRevocation(), SIGNDOC_VerificationResult_verifyCertificateSimplified(), SIGNDOC_VerificationResult_verifyTimeStampCertificateChain(), SIGNDOC_VerificationResult_verifyTimeStampCertificateRevocation(), SIGNDOC_VerificationResult_verifyTimeStampCertificateSimplified()
 */
#define SIGNDOC_VERIFICATIONRESULT_VERIFICATIONMODEL_DEFAULT 0

/**
 * @brief Certificate verification model:
 *        As specfified by German law.
 *
 * @see SIGNDOC_VerificationResult_verifyCertificateRevocation(), SIGNDOC_VerificationResult_verifyCertificateSimplified(), SIGNDOC_VerificationResult_verifyTimeStampCertificateChain(), SIGNDOC_VerificationResult_verifyTimeStampCertificateRevocation(), SIGNDOC_VerificationResult_verifyTimeStampCertificateSimplified()
 *
 * @todo implement this
 * @todo name that law
 */
#define SIGNDOC_VERIFICATIONRESULT_VERIFICATIONMODEL_GERMAN_SIG_LAW 1

/**
 * @brief Certificate chain state for SIGNDOC_VerificationResult_verifyCertificateChain()
 *        and SIGNDOC_VerificationResult_verifyTimeStampCertificateChain():
 *        Chain OK.
 */
#define SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_OK 0

/**
 * @brief Certificate chain state for SIGNDOC_VerificationResult_verifyCertificateChain()
 *        and SIGNDOC_VerificationResult_verifyTimeStampCertificateChain():
 *        Chain broken.
 */
#define SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_BROKEN_CHAIN 1

/**
 * @brief Certificate chain state for SIGNDOC_VerificationResult_verifyCertificateChain()
 *        and SIGNDOC_VerificationResult_verifyTimeStampCertificateChain():
 *        Untrusted root certificate.
 */
#define SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_UNTRUSTED_ROOT 2

/**
 * @brief Certificate chain state for SIGNDOC_VerificationResult_verifyCertificateChain()
 *        and SIGNDOC_VerificationResult_verifyTimeStampCertificateChain():
 *        A certificate has an unknown critical extension.
 */
#define SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_CRITICAL_EXTENSION 3

/**
 * @brief Certificate chain state for SIGNDOC_VerificationResult_verifyCertificateChain()
 *        and SIGNDOC_VerificationResult_verifyTimeStampCertificateChain():
 *        A certificate is not yet valid or is expired.
 */
#define SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_NOT_TIME_VALID 4

/**
 * @brief Certificate chain state for SIGNDOC_VerificationResult_verifyCertificateChain()
 *        and SIGNDOC_VerificationResult_verifyTimeStampCertificateChain():
 *        Path length constraint not satisfied.
 */
#define SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_PATH_LENGTH 5

/**
 * @brief Certificate chain state for SIGNDOC_VerificationResult_verifyCertificateChain()
 *        and SIGNDOC_VerificationResult_verifyTimeStampCertificateChain():
 *        Invalid certificate or chain.
 */
#define SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_INVALID 6

/**
 * @brief Certificate chain state for SIGNDOC_VerificationResult_verifyCertificateChain()
 *        and SIGNDOC_VerificationResult_verifyTimeStampCertificateChain():
 *        Other error.
 */
#define SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_ERROR 7

/**
 * @brief Certificate revocation state for SIGNDOC_VerificationResult_verifyCertificateRevocation()
 *        and SIGNDOC_VerificationResult_verifyTimeStampCertificateRevocation():
 *        No certificate revoked.
 */
#define SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONSTATE_OK 0

/**
 * @brief Certificate revocation state for SIGNDOC_VerificationResult_verifyCertificateRevocation()
 *        and SIGNDOC_VerificationResult_verifyTimeStampCertificateRevocation():
 *        Revocation not checked.
 */
#define SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONSTATE_NOT_CHECKED 1

/**
 * @brief Certificate revocation state for SIGNDOC_VerificationResult_verifyCertificateRevocation()
 *        and SIGNDOC_VerificationResult_verifyTimeStampCertificateRevocation():
 *        Revocation server is offline.
 */
#define SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONSTATE_OFFLINE 2

/**
 * @brief Certificate revocation state for SIGNDOC_VerificationResult_verifyCertificateRevocation()
 *        and SIGNDOC_VerificationResult_verifyTimeStampCertificateRevocation():
 *        At least one certificate has been revoked.
 */
#define SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONSTATE_REVOKED 3

/**
 * @brief Certificate revocation state for SIGNDOC_VerificationResult_verifyCertificateRevocation()
 *        and SIGNDOC_VerificationResult_verifyTimeStampCertificateRevocation():
 *        Error.
 */
#define SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONSTATE_ERROR 4

/**
 * @brief Justification of  multi-line text: left.
 */
#define SIGNDOC_WATERMARK_JUSTIFICATION_LEFT 0

/**
 * @brief Justification of  multi-line text: center.
 */
#define SIGNDOC_WATERMARK_JUSTIFICATION_CENTER 1

/**
 * @brief Justification of  multi-line text: right.
 */
#define SIGNDOC_WATERMARK_JUSTIFICATION_RIGHT 2

/**
 * @brief Location of watermark: Watermark appears on top of page.
 */
#define SIGNDOC_WATERMARK_LOCATION_OVERLAY 0

/**
 * @brief Location of watermark: Watermark appears behind page.
 */
#define SIGNDOC_WATERMARK_LOCATION_UNDERLAY 1

/**
 * @brief Horizontal alignment: left.
 */
#define SIGNDOC_WATERMARK_HALIGNMENT_LEFT 0

/**
 * @brief Horizontal alignment: center.
 */
#define SIGNDOC_WATERMARK_HALIGNMENT_CENTER 1

/**
 * @brief Horizontal alignment: right.
 */
#define SIGNDOC_WATERMARK_HALIGNMENT_RIGHT 2

/**
 * @brief Vertical alignment: top.
 */
#define SIGNDOC_WATERMARK_VALIGNMENT_TOP 0

/**
 * @brief Vertical alignment: center.
 */
#define SIGNDOC_WATERMARK_VALIGNMENT_CENTER 1

/**
 * @brief Vertical alignment: bottom.
 */
#define SIGNDOC_WATERMARK_VALIGNMENT_BOTTOM 2

/**
 * @brief Encoding of strings: Windows "ANSI" for Windows, LC_CTYPE for Linux,
*         file system representation for iOS.
 */
#define SIGNDOC_ENCODING_NATIVE 0

/**
 * @brief Encoding of strings: UTF-8.
 */
#define SIGNDOC_ENCODING_UTF_8 1

/**
 * @brief Encoding of strings: ISO 8859-1.
 */
#define SIGNDOC_ENCODING_LATIN_1 2

/* --------------------------------------------------------------------------*/

/**
 * @brief Type for boolean values.
 *
 * @see #SIGNDOC_FALSE, #SIGNDOC_TRUE
 */
typedef int SIGNDOC_Boolean;

/* --------------------------------------------------------------------------*/

/**
 * @brief Array of strings.
 * @class SIGNDOC_StringArray
 */
struct SIGNDOC_StringArray;

/**
 * @brief Array of bytes.
 * @class SIGNDOC_ByteArray
 */
struct SIGNDOC_ByteArray;

/**
 * @brief Array of arrays of bytes.
 * @class SIGNDOC_ByteArrayArray
 */
struct SIGNDOC_ByteArrayArray;

/**
 * @brief Array of fields.
 * @class SIGNDOC_FieldArray
 */
struct SIGNDOC_FieldArray;

/**
 * @brief A point (page coordinates or canvas coordinates).
 *
 * @class SIGNDOC_Point
 */
struct SIGNDOC_Point
{
  /**
   * @brief The X coordinate.
   */
  double mX;

  /**
   * @brief The Y coordinate.
   */
  double mY;
};

/**
 * @brief A rectangle (page coordinates).
 *
 * If coordinates are given in pixels (this is true for TIFF documents),
 * the right and top coordinates are exclusive.
 *
 * @class SIGNDOC_Rect
 */
struct SIGNDOC_Rect
{
  /**
   * @brief The first X coordinate.
   */
  double mX1;

  /**
   * @brief The first Y coordinate.
   */
  double mY1;

  /**
   * @brief The second X coordinate.
   */
  double mX2;

  /**
   * @brief The second Y coordinate.
   */
  double mY2;
};

/**
 * @brief Position of a character.
 *
 * This class uses document coordinates, see @ref signdocshared_coordinates.
 *
 * @class SIGNDOC_CharacterPosition
 */
struct SIGNDOC_CharacterPosition
{
  /**
   * @brief 1-based page number.
   */
  int mPage;

  /**
   * @brief Reference point.
   */
  struct SIGNDOC_Point mRef;

  /**
   * @brief Bounding box (all four values are zero if not available).
   */
  struct SIGNDOC_Rect mBox;
};

/**
 * @brief Text position.
 *
 * Position of a hit returned by SIGNDOC_Document_findText().
 *
 * @class SIGNDOC_FindTextPosition
 */
struct SIGNDOC_FindTextPosition
{
  /**
   * @brief First character.
   */
  struct SIGNDOC_CharacterPosition mFirst;

  /**
   * @brief Last character.
   */
  struct SIGNDOC_CharacterPosition mLast;
};

/**
 * @brief Array of text positions.
 *
 * @class SIGNDOC_FindTextPositionArray
 */
struct SIGNDOC_FindTextPositionArray;

/**
 * @brief Array of properties.
 *
 * @class SIGNDOC_PropertyArray
 */
struct SIGNDOC_PropertyArray;

/**
 * @brief Information about an exception.
 *
 * Functions which can throw exceptions take a
 * @code
 * struct SignDocException **aEx
 * @endcode
 * argument. You must pass a pointer to a variable of type
 * @code
 * struct SignDocException *
 * @endcode
 * On entry, functions will check if the pointer is non-NULL. If it's
 * NULL, abort() will be called. Otherwise, NULL will be stored to
 * the object pointed to by that pointer.
 *
 * When an exception occurs, an object of type SIGNDOC_Exception is created
 * and a pointer to that exception is stored in the object pointed to
 * by the @a aEx argument.
 *
 * There are two ways to handle exceptions:
 * - check the pointer after each function calls that can throw an
 *   exception. To continue after the exception, you should call
 *   SIGNDOC_Exception_delete() to destroy the SIGNDOC_Exception object.
 *   This method is preferred when wrapping the C API in another
 *   programming language.
 * - install a global exception handler with SIGNDOC_Exception_setHandler().
 *   The exception handler will be called when an exception occurs.
 *   This method might be preferred if your application won't continue
 *   after an exception is thrown.
 * .
 *
 * The most common exceptions are
 * - SIGNDOC_EXCEPTION_TYPE_BAD_ALLOC (out of memory)
 * - SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR (argument not encoded
 *   correctly or the output of a function cannot be encoded according to
 *   the specified encoding). Example: using SIGNDOC_ENCODING_NATIVE
 *   with SIGNDOC_Field_getValue() for printing the value of a field
 *   on the console will throw an exception if the field's value cannot
 *   be represented by the console's character set. You might want to
 *   use SIGNDOC_ENCODING_UTF_8 instead and then convert the value
 *   with SIGNDOC_recodeStringRelaxed() to native encoding.
 * .
 *
 * Out of memory situations are always reported via an exception.
 * Some but not all functions check for encoding errors and report any
 * problems via return values.
 *
 * @class SIGNDOC_Exception
 */
struct SIGNDOC_Exception;

/**
 * @brief SignDoc document handler for PDF documents.
 *
 * @class SIGNDOC_PdfDocumentHandler
 */
struct SIGNDOC_PdfDocumentHandler;

/**
 * @brief SignDoc document handler for TIFF documents.
 *
 * @class SIGNDOC_TiffDocumentHandler
 */
struct SIGNDOC_TiffDocumentHandler;

/**
 * @brief Interface for an input stream, inspired by Java's java.io.InputStream.
 *
 * @class SIGNDOC_InputStream
 */
struct SIGNDOC_InputStream;

/**
 * @brief Interface for an output stream, inspired by Java's java.io.OutputStream.
 *
 * @class SIGNDOC_OutputStream
 */
struct SIGNDOC_OutputStream;

/**
 * @brief An annotation.
 *
 * Currently, annotations are supported for PDF documents only.
 *
 * @see SIGNDOC_Document_createLineAnnotation(), SIGNDOC_Document_createScribbleAnnotation(), SIGNDOC_Document_createFreeTextAnnotation(), SIGNDOC_Document_getAnnotation()
 *
 * @class SIGNDOC_Annotation
 */
struct SIGNDOC_Annotation;

/**
 * @brief Output of SIGNDOC_Document_getAttachment().
 *
 * @class SIGNDOC_Attachment
 */
struct SIGNDOC_Attachment;

/**
 * @brief An interface for SignDoc documents.
 *
 * An object of this class represents one document.
 * Use SIGNDOC_DocumentLoader_loadFromMemory(),
 * SIGNDOC_DocumentLoader_loadFromFile(), or
 * SIGNDOC_DocumentLoader_createPDF() to create objects.
 *
 * If the document is loaded from a file, the file may remain in
 * use until this object is destroyed or the document is saved
 * to a different file with SIGNDOC_Document_saveToFile().
 * Please do not change the file while there is a SIGNDOC_Document
 * object for it.
 *
 * @class SIGNDOC_Document
 *
 * @todo add SIGNDOC_Document_fixFields()
 */
struct SIGNDOC_Document;

/**
 * @brief Handler for one document type (internal interface).
 *
 * @class SIGNDOC_DocumentHandler
 */
struct SIGNDOC_DocumentHandler;

/**
 * @brief Create SIGNDOC_Document objects.
 *
 * As the error message is stored in this object, each thread should
 * have its own instance of SIGNDOC_DocumentLoader or synchronization
 * should be used.
 *
 * Unless you need differently configured SIGNDOC_DocumentLoader
 * objects, you should have only one SIGNDOC_DocumentLoader object per
 * process (but see above). Loading font configuration files can be
 * expensive, in particular if many fonts have to be scanned.

 * To be able to load documents, you have to register at least one
 * document handler by passing a pointer to a SIGNDOC_DocumentHandler
 * object to SIGNDOC_DocumentLoader_registerDocumentHandler().
 *
 * @class SIGNDOC_DocumentLoader
 */
struct SIGNDOC_DocumentLoader;

/**
 * @brief One field of a document.
 *
 * Calling member function of this class does not modify the document,
 * use SIGNDOC_Document_setField() to apply your changes to the
 * document or SIGNDOC_Document_addField() to add the field to the
 * document.
 *
 * In PDF documents, a field may have multiple visible "widgets". For
 * instance, a radio button group (radio button field) usually has
 * multiple visible buttons, ie, widgets.
 *
 * A SIGNDOC_Field object represents the logical field (containing the
 * type, name, value, etc) as well as all its widgets. Each widget has
 * a page number, a coordinate rectangle, and, for some field types,
 * text field attributes.
 *
 * Only one widget of the field is accessible at a time in a
 * SIGNDOC_Field object; use SIGNDOC_Field_selectWidget() to select
 * the widget to be operated on.
 *
 * For radio button fields and check box fields, each widget also has
 * a "button value". The button value should remain constant after the
 * document has been created (but it can be changed if needed). The
 * field proper has a value which is either "Off" or one of the button
 * values of its widgets.
 *
 * Each widget of a radio button field or a check box field is either
 * off or on. If all widgets of a radio button field or a check box
 * are off, the field's value is "Off". If at least one widget is on,
 * the field's value is that widget's "button value". As the value of
 * a field must be different for the on and off states of the field,
 * the button values must not be "Off".

 * Check box fields usually have exactly one widget. If that widget's
 * button value is, say, "On", the field's value is either "Off" (for
 * the off state) or "On" (for the on state).
 *
 * Check box fields can have multiple widgets. If all widgets have the
 * same button value, say, "yes", the field's value is either "Off"
 * (for the off state) or "yes" (for the on state). Clicking one
 * widget of the check box field will toggle all widgets of that
 * check box field.
 *
 * Check box fields can have multiple widgets having different button
 * values. If a check box field has two widgets with button values,
 * say, "1" and "2", the field's value is either "Off" (for the off
 * state), "1" (if the first widget is on) or "2" (if the second
 * widget is on).  The two widgets cannot be on at the same time.
 *
 * If a check box field has three widgets with button values, say,
 * "one, "two", and "two", respectively, the field's value is either
 * "Off" (for the off state), "one" (if the first widget is on) or
 * "two" (if the second and third widgets are on). The second and
 * third widgets will always have the same state and that state will
 * never be the same as the state of the first widget.
 *
 * A radio button field usually has at least two widgets, having
 * different button values. If a radio button field has two widgets
 * with button values, say, "a" and "b", the field's value is either
 * "Off" (for the off state), "a" (if the first widget is on), or "b"
 * (if the second widget is on). Clicking the first widget puts the
 * first widget into the on state and the second one into the off
 * state (and vice versa).
 *
 * Different widgets of a radio button field can have the same
 * button value. The behavior for clicking a widget with non-unique
 * button value depends on the #SIGNDOC_FIELD_FLAG_RADIOSINUNISON field flag. If that
 * flag is set (it usually is), widgets having the same button value
 * always have the same on/off state. Clicking one of them will turn
 * all of them on. If the #SIGNDOC_FIELD_FLAG_RADIOSINUNISON is not set, clicking one
 * widget will put all others (of the same radio button field) into
 * the off state. See SIGNDOC_Field_getValueIndex() for details.
 *
 * Signature fields have exactly one widget. Fields of other
 * types must have at least one widget.
 *
 * Other fields such as text fields (except for signature fields) also
 * can have multiple widgets, but all of them display the same value.
 *
 * @class SIGNDOC_Field
 */
struct SIGNDOC_Field;

/**
 * @brief Position of a hit returned by SIGNDOC_Document_findText().
 *
 * @class SIGNDOC_FindTextPosition
 */
struct SIGNDOC_FindTextPosition;

/**
 * @brief One property, without value.
 *
 * Use SIGNDOC_Document_getBooleanProperty(),
 * SIGNDOC_Document_getIntegerProperty(), or
 * SIGNDOC_Document_getStringProperty() to get the value of a
 * property.
 *
 * @class SIGNDOC_Property
 */
struct SIGNDOC_Property;

/**
 * @brief Output of SIGNDOC_Document_renderPageAsImage().
 *
 * If multiple pages are selected (see SIGNDOC_RenderParameters_setPages()),
 * the maximum width and maximum height of all selected pages will be used.
 *
 * @class SIGNDOC_RenderOutput
 */
struct SIGNDOC_RenderOutput
{
  /**
   * @brief The width of the rendered page in pixels.
   */
  int mWidth;

  /**
   * @brief The height of the rendered page in pixels.
   */
  int mHeight;
};

/**
 * @brief Parameters for SIGNDOC_Document_renderPageAsImage().
 *
 * @class SIGNDOC_RenderParameters
 */
struct SIGNDOC_RenderParameters;

/* --------------------------------------------------------------------------*/

/**
 * @brief Data source.
 *
 * Interface for getting byte ranges from a document.
 */
struct SIGNDOC_Source;

/**
 * @brief Fetch data from a SIGNDOC_Source.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj       A pointer to the SIGNDOC_Source object.
 * @param[out] aPtr      A pointer to the first byte will be stored here.
 * @param[in] aMaxSize   Fetch up to this many bytes. Must be positive.
 *
 * @return 0 if no more data is available, otherwise the number of bytes
 *         pointed to by the pointer returned in @a aPtr. The return value
 *         is always less than or equal to @a aMaxSize.
 */
int SDCAPI
SIGNDOC_Source_fetch (struct SIGNDOC_Exception **aEx,
                      struct SIGNDOC_Source *aObj,
                      const void **aPtr, int aMaxSize);

/* --------------------------------------------------------------------------*/

/**
 * @brief Return value of SIGNDOC_TimeStamper_stamp():
 *        Success.
 */
#define SIGNDOC_TIMESTAMPER_STAMPRESULT_OK                      0

/**
 * @brief Return value of SIGNDOC_TimeStamper_stamp():
 *        Invalid argument or invalid time-stamp request.
 */
#define SIGNDOC_TIMESTAMPER_STAMPRESULT_INVALID_INPUT           1

/**
 * @brief Return value of SIGNDOC_TimeStamper_stamp():
 *        Timeout.
 */
#define SIGNDOC_TIMESTAMPER_STAMPRESULT_TIMEOUT                 2

/**
 * @brief Return value of SIGNDOC_TimeStamper_stamp():
 *        Transaction interrupted by SIGNDOC_TimeStamper_stop().
 */
#define SIGNDOC_TIMESTAMPER_STAMPRESULT_STOPPED                 3

/**
 * @brief Return value of SIGNDOC_TimeStamper_stamp():
 *        Some failure at the TCP/IP layer.
 */
#define SIGNDOC_TIMESTAMPER_STAMPRESULT_TCP_ERROR               4

/**
 * @brief Return value of SIGNDOC_TimeStamper_stamp():
 *        Some failure at the SSL layer.
 */
#define SIGNDOC_TIMESTAMPER_STAMPRESULT_SSL_ERROR               5

/**
 * @brief Return value of SIGNDOC_TimeStamper_stamp():
 *        Some failure at the HTTP layer.
 */
#define SIGNDOC_TIMESTAMPER_STAMPRESULT_HTTP_ERROR              6

/**
 * @brief Return value of SIGNDOC_TimeStamper_stamp():
 *        The server failed to create the time stamp (according to PKIStatus).
 */
#define SIGNDOC_TIMESTAMPER_STAMPRESULT_SERVER_ERROR            7

/**
 * @brief Return value of SIGNDOC_TimeStamper_stamp():
 *        The response from the server is invalid.
 */
#define SIGNDOC_TIMESTAMPER_STAMPRESULT_INVALID_RESPONSE        8

/**
 * @brief Interface for creating an RFC 3161 timestamp.
 *
 * @class SIGNDOC_TimeStamper
 */
struct SIGNDOC_TimeStamper;

/**
 * @brief Get the object ID of the message digest algorithm.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_TimeStamper object.
 *
 * @return A pointer to the object ID of the message digest algorithm
 *         as string, e.g., "1.3.14.3.2.26" for SHA-1.
 *
 * @memberof SIGNDOC_TimeStamper
 *
 * @todo document lifetime
 */
const char * SDCAPI
SIGNDOC_TimeStamper_getHashAlgorithm (const struct SIGNDOC_TimeStamper *aObj);

/**
 * @brief Create a time-stamp request, send the request to the configured
 *        time stamping authority, and evaluate the response.
 *
 * The signature in the returned time-stamp token is not verified
 * by this function.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_TimeStamper object.
 * @param[in] aHashPtr   A pointer to the first octet of the
 *                       message digest to be signed.
 * @param[in] aHashSize  The size (in octets) of the message digest
 *                       pointed to by @a aHashPtr).
 *                       This function does not check if
 *                       the size is correct for the selected message
 *                       digest algorithm (available via getHashAlgorithm()).
 * @param[in] aRandomNonceSize  The size (in octets, 1 through 256)
 *                       of the random nonce in the time-stamp request.
 * @param[out] aOutput   The time-stamp token sent by the server will be
 *                       stored here as blob if this function returns sr_ok.
 *                       Otherwise, @a aOutput will be empty.
 * @param[out] aStatus  The PKIStatus value of the response from the server
 *                      will be stored here. 0 if no response from the
 *                      server is available.
 * @param[out] aFailureInfo  The PKIFailureInfo value of the response
 *                           from the server will be stored here.
 *                           0 if no response from the server is available.
 *
 * @return Return code:
 *         #SIGNDOC_TIMESTAMPER_STAMPRESULT_OK,
 *         #SIGNDOC_TIMESTAMPER_STAMPRESULT_INVALID_INPUT,
 *         #SIGNDOC_TIMESTAMPER_STAMPRESULT_TIMEOUT,
 *         #SIGNDOC_TIMESTAMPER_STAMPRESULT_STOPPED,
 *         #SIGNDOC_TIMESTAMPER_STAMPRESULT_TCP_ERROR,
 *         #SIGNDOC_TIMESTAMPER_STAMPRESULT_SSL_ERROR,
 *         #SIGNDOC_TIMESTAMPER_STAMPRESULT_HTTP_ERROR,
 *         #SIGNDOC_TIMESTAMPER_STAMPRESULT_SERVER_ERROR, or
 *         #SIGNDOC_TIMESTAMPER_STAMPRESULT_INVALID_RESPONSE.
 *         Use SIGNDOC_TimeStamper_getErrorMessage() to get an error message.
 *
 * @memberof SIGNDOC_TimeStamper
 */
int SDCAPI
SIGNDOC_TimeStamper_stamp (struct SIGNDOC_Exception **aEx,
                           struct SIGNDOC_TimeStamper *aObj,
                           const unsigned char *aHashPtr, size_t aHashSize,
                           unsigned aRandomNonceSize,
                           struct SIGNDOC_ByteArray *aOutput,
                           int *aStatus, unsigned *aFailureInfo);

/**
 * @brief Interrupt a SIGNDOC_TimeStamper_stamp() call from another thread.
 *
 * If this function is called while SIGNDOC_TimeStamper_stamp() is
 * waiting for the response from the server,
 * SIGNDOC_TimeStamper_stamp() will return
 * SIGNDOC_TIMESTAMPER_STAMPRESULT_STOPPED.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_TimeStamper object.
 *
 * @memberof SIGNDOC_TimeStamper
 */
void SDCAPI
SIGNDOC_TimeStamper_stop (struct SIGNDOC_TimeStamper *aObj);

/**
 * @brief Get an error message for the last SIGNDOC_TimeStamper_stamp() call.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_TimeStamper object.
 *
 * @return A pointer to a string describing the reason for the failure
 *         of the last SIGNDOC_TimeStamper_stamp() call. The string is
 *         empty if the last call succeeded. The pointer is valid
 *         until this object is destroyed or
 *         SIGNDOC_TimeStamper_stamp() is called again.  The string is
 *         ASCII encoded, the error message is in English.
 *
 * @memberof SIGNDOC_TimeStamper
 */
const char * SDCAPI
SIGNDOC_TimeStamper_getErrorMessage (const struct SIGNDOC_TimeStamper *aObj);

/* --------------------------------------------------------------------------*/

/**
 * @brief Hash Algorithm to be used for detached signature: not detached.
 */
#define SIGNDOC_SIGNPKCS7_DETACHEDALGORITHM_NOT_DETACHED        0

/**
 * @brief Hash Algorithm to be used for detached signature: MD5.
 */
#define SIGNDOC_SIGNPKCS7_DETACHEDALGORITHM_MD5                 1

/**
 * @brief Hash Algorithm to be used for detached signature: SHA-1.
 */
#define SIGNDOC_SIGNPKCS7_DETACHEDALGORITHM_SHA1                2

/**
 * @brief Hash Algorithm to be used for detached signature: SHA-256.
 */
#define SIGNDOC_SIGNPKCS7_DETACHEDALGORITHM_SHA256              3

/**
 * @brief Interface for creating a PKCS #7 signature.
 *
 * Selection of the certificate is up to the implementation.
 *
 * @class SIGNDOC_SignPKCS7
 */
struct SIGNDOC_SignPKCS7;

/**
 * @brief Callback: Sign a hash, producing a PKCS #7 signature.
 *
 * @param[in] aClosure   A pointer to user-defined object.
 * @param[in] aHashPtr   Pointer to the first octet of the hash.
 * @param[in] aHashSize  Size of the hash (number of octets
 *                       pointed to by @a aHashPtr).
 * @param[in] aTimeStamper  Non-NULL to use a time-stamp server.
 * @param[out] aOutput   The ASN.1-encoded PKCS #7 signature will be
 *                       stored here.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @memberof SIGNDOC_SignPKCS7
 */
typedef SIGNDOC_Boolean (SDCAPI * SIGNDOC_SignPKCS7_signHash)(void *aClosure,
                                                              const unsigned char *aHashPtr,
                                                              size_t aHashSize,
                                                              struct SIGNDOC_TimeStamper *aTimeStamper,
                                                              struct SIGNDOC_ByteArray *aOutput);

/**
 * @brief Callback: Sign data, producing a detached PKCS #7 signature.
 *
 * @param[in] aClosure   A pointer to user-defined object.
 * @param[in] aSource     An object providing data to be hashed.
 * @param[in] aAlgorithm  Hash algorithm to be used for detached signature:
 *                        #SIGNDOC_SIGNPKCS7_DETACHEDALGORITHM_MD5,
 *                        #SIGNDOC_SIGNPKCS7_DETACHEDALGORITHM_SHA1, or
 *                        #SIGNDOC_SIGNPKCS7_DETACHEDALGORITHM_SHA256.
 * @param[in] aTimeStamper  Non-NULL to use a time-stamp server
 *                              (not yet available for C API).
 * @param[out] aOutput  The ASN.1-encoded PKCS #7 signature will be
 *                      stored here.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @memberof SIGNDOC_SignPKCS7
 */
typedef SIGNDOC_Boolean (SDCAPI * SIGNDOC_SignPKCS7_signDetached) (void *aClosure,
                                                                   struct SIGNDOC_Source *aSource,
                                                                   int aAlgorithm,
                                                                   struct SIGNDOC_TimeStamper *aTimeStamper,
                                                                   struct SIGNDOC_ByteArray *aOutput);

/**
 * @brief Callback: Compute the size of the signature produced by
 *        SIGNDOC_SignPKCS7_SignHash().
 *
 * @param[in] aClosure   A pointer to user-defined object.
 * @param[in] aHashSize   Size of the hash (number of octets).
 * @param[in] aTimeStamp  #SIGNDOC_TRUE to include RFC 3161 time stamp.
 *
 * @return A positive number which is an upper limit to the number
 *         of octets required for the ASN.1-encoded signature,
 *         zero on error.
 *
 * @memberof SIGNDOC_SignPKCS7
 */
typedef size_t (SDCAPI * SIGNDOC_SignPKCS7_getSignHashSize)(void *aClosure,
                                                            size_t aHashSize,
                                                            SIGNDOC_Boolean aTimeStamp);

/**
 * @brief Callback: Compute the size of the signature produced by
 *        SIGNDOC_SignPKCS7_signDetached().
 *
 * @param[in] aClosure   A pointer to user-defined object.
 * @param[in] aAlgorithm   Hash algorithm to be used for detached signature:
 *                         #SIGNDOC_SIGNPKCS7_DETACHEDALGORITHM_MD5,
 *                         #SIGNDOC_SIGNPKCS7_DETACHEDALGORITHM_SHA1, or
 *                         #SIGNDOC_SIGNPKCS7_DETACHEDALGORITHM_SHA256.
 * @param[in] aTimeStamp   #SIGNDOC_TRUE to include RFC 3161 time stamp.
 *
 * @return A positive number which is an upper limit to the number
 *         of octets required for the ASN.1-encoded signature,
 *         zero on error.
 *
 * @memberof SIGNDOC_SignPKCS7
 */
typedef size_t (SDCAPI * SIGNDOC_SignPKCS7_getSignDetachedSize)(void *aClosure,
                                                                int aAlgorithm,
                                                                SIGNDOC_Boolean aTimeStamp);

/**
 * @brief Callback: Get the common name (CN) of the certificate's subject.
 *
 * @param[in] aClosure   A pointer to user-defined object.
 * @param[out] aOutput     A pointer to the common name will be stored
 *                         here (UTF-8).
 *                         The string must be freed with SIGNDOC_free()
 *                         (that is, this function must allocate it
 *                         with SIGNDOC_alloc() or SIGNDOC_strdup()).
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @memberof SIGNDOC_SignPKCS7
 */
typedef SIGNDOC_Boolean (SDCAPI * SIGNDOC_SignPKCS7_getSubjectCommonName)(void *aClosure,
                                                                          char **aOutput);

/**
 * @brief Callback: Get an error message for the last operation.
 *
 * After any function pointer of @a aObj has been called, you can
 * retrieve an error message by calling this function.
 *
 * @param[in] aClosure   A pointer to user-defined object.
 *
 * @return  A pointer to the error message.  The pointer will become
 *          invalid as soon as any function pointer of @a aObj is called
 *          or @a Obj is destroyed.
 *
 * @memberof SIGNDOC_SignPKCS7
 */
typedef const char * (SDCAPI * SIGNDOC_SignPKCS7_getErrorMessage)(void *aClosure);

/**
 * @brief SIGNDOC_SignPKCS7 constructor.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aClosure A pointer to user-defined object that will be passed
 *                     to the callbacks.
 * @param[in] aSignHash              Pointer to function implementing
 *                                   signHash().
 * @param[in] aSignDetached          Pointer to function implementing
 *                                   signDetached().
 * @param[in] aGetSignHashSize       Pointer to function implementing
 *                                   getSignHashSize().
 * @param[in] aGetSignDetachedSize   Pointer to function implementing
 *                                   getSignDetachedSize().
 * @param[in] aGetSubjectCommonName  Pointer to function implementing
 *                                   getSubjectCommonName().
 * @param[in] aGetErrorMessage       Pointer to function implementing
 *                                   getErrorMessage().
 *
 * @return A pointer to a new SIGNDOC_SignPKCS7 object.
 *
 * @see SIGNDOC_SignPKCS7_delete()
 *
 * @memberof SIGNDOC_SignPKCS7
 */
struct SIGNDOC_SignPKCS7 * SDCAPI
SIGNDOC_SignPKCS7_new (struct SIGNDOC_Exception **aEx,
                       void *aClosure,
                       SIGNDOC_SignPKCS7_signHash aSignHash,
                       SIGNDOC_SignPKCS7_signDetached aSignDetached,
                       SIGNDOC_SignPKCS7_getSignHashSize aGetSignHashSize,
                       SIGNDOC_SignPKCS7_getSignDetachedSize aGetSignDetachedSize,
                       SIGNDOC_SignPKCS7_getSubjectCommonName aGetSubjectCommonName,
                       SIGNDOC_SignPKCS7_getErrorMessage aGetErrorMessage);

/**
 * @brief SIGNDOC_SignPKCS7 destructor.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_SignPKCS7 object.
 *
 * @memberof SIGNDOC_SignPKCS7
 */
void SDCAPI
SIGNDOC_SignPKCS7_delete (struct SIGNDOC_SignPKCS7 *aObj);

/* --------------------------------------------------------------------------*/

/**
 * @brief Parameters for signing a document.
 *
 * The available parameters depend both on the document type and on
 * the signature field for which the SIGNDOC_SignatureParameters object
 * has been created.
 *
 * SIGNDOC_Document_addSignature() may fail due to invalid parameters
 * even if all setters reported success as the setters do not check if
 * there are conflicts between parameters.
 *
 * Which certificates are acceptable may be restricted by the
 * application (by using
 * #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_SOFTWARE and
 * #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_HARDWARE of integer
 * parameter "SelectCertificate", blob parameters
 * "FilterCertificatesByIssuerCertificate" and
 * "FilterCertificatesBySubjectCertificate", and string parameters
 * "FilterCertificatesByPolicy" and
 * "FilterCertificatesBySubjectDN") and by the PDF document
 * (certificate seed value dictionary, not yet implemented). If no
 * matching certificate is available (for instance, because integer
 * parameter "SelectCertificate" is zero),
 * SIGNDOC_Document_addSignature() will fail with
 * #SIGNDOC_DOCUMENT_RETURNCODE_NO_CERTIFICATE.
 * If more than one matching certificate is available but
 * #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_NEVER_ASK is
 * specified in integer parameter
 * "SelectCertificate"), SIGNDOC_Document_addSignature() will fail
 * with #SIGNDOC_DOCUMENT_RETURNCODE_AMBIGUOUS_CERTIFICATE.
 *
 * The interaction between some parameters is quite complex; the following
 * section tries to summarize the signing methods for PDF documents.
 * <dl>
 * <dt>(1a)
 * <dd>PKCS #1, private key and self-signed certificate created on the fly:
 *     - Method: #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS1
 *     - CommonName: signer's name
 *     - GenerateKeyPair: 1024-4096
 *     .
 * <dt>(1b)
 * <dd>PKCS #1, private key provided, self-signed certificate created on
 *     the fly:
 *     - Method: #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS1
 *     - CommonName: signer's name
 *     - CertificatePrivateKey: private key for self-signed certificate
 *     .
 * <dt>(1c)
 * <dd>PKCS #1, private key provided, self-signed certificate provided:
 *     - Method: #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS1
 *     - Certificate: self-signed certificate
 *     - CertificatePrivateKey: private key for self-signed certificate
 *     - Signer: Signer's name (not yet extracted from certificate)
 *     .
 * <dt>(2a)
 * <dd>PKCS #7 via SIGNDOC_SignPKCS7 interface:
 *     - Method: #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED
 *               or #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_SHA1
 *     .
 *     See SIGNDOC_SignatureParameters_setPKCS7() for details.
 * <dt>(2b)
 * <dd>PKCS #7, user must select certificate:
 *     - Method: #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED
 *               or #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_SHA1
 *     - DetachedHashAlgorithm: hash algorithm for
 *               #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED
 *     - SelectCertificate:
 *          #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_SOFTWARE
 *          and/or
 *          #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_HARDWARE
 *     .
 * <dt>(2c)
 * <dd>PKCS #7, user may select certificate or choose to create
 *     a self-signed certificate, the private key of which will be generated:
 *     - Method: #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED or
 *               #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_SHA1
 *     - DetachedHashAlgorithm: hash algorithm for
 *               #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED
 *     - SelectCertificate:
 *          #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_SOFTWARE
 *          and/or
 *          #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_HARDWARE
 *     - CommonName: signer's name (for self-signed certificate)
 *     - GenerateKeyPair: 1024-4096
 *     .
 *     PKCS #1 will be used if the user chooses to create a self-signed
 *     certificate.
 * <dt>(2d)
 * <dd>PKCS #7, user may select certificate or choose to create
 *     a self-signed certificate, the private key of which is provided:
 *     - Method: #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED or
 *               #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_SHA1
 *     - DetachedHashAlgorithm: hash algorithm for
 *               #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED
 *     - SelectCertificate:
 *          #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_SOFTWARE
 *          and/or
 *          #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_HARDWARE
 *     - CommonName: signer's name (for self-signed certificate)
 *     - CertificatePrivateKey: private key for self-signed certificate
 *     .
 *     PKCS #1 will be used if the user chooses to create a self-signed
 *     certificate.
 * <dt>(2e)
 * <dd>PKCS #7, user may select certificate or choose to "create"
 *     a self-signed certificate, the certificate and its key are
 *     provided separately:
 *     - Method: #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED or
 *               #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_SHA1
 *     - DetachedHashAlgorithm: hash algorithm for
 *               #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED
 *     - SelectCertificate:
 *          #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_SOFTWARE
 *          and/or
 *          #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_HARDWARE,
 *          #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_CREATE_SELF_SIGNED
 *     - Certificate: self-signed certificate
 *     - CertificatePrivateKey: private key for self-signed certificate
 *     - Signer: Signer's name (not yet extracted from certificate)
 *     .
 *     PKCS #1 will be used if the user chooses to create a self-signed
 *     certificate.
 * <dt>(2f)
 * <dd>PKCS #7, user may select certificate or choose to "create"
 *     a self-signed certificate, the certificate and its key are
 *     provided as PKCS #12 blob:
 *     - Method: #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED or
 *               #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_SHA1
 *     - DetachedHashAlgorithm: hash algorithm for
 *               #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED
 *     - SelectCertificate:
 *          #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_SOFTWARE
 *          and/or
 *          #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_HARDWARE,
 *          #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_CREATE_SELF_SIGNED
 *     - Certificate: PKCS #12 blob containing certificate (need not be
 *       self-signed) and its private key
 *     - PKCS#12Password: password for private key in the PKCS #12 blob
 *     .
 * <dt>(2g)
 * <dd>PKCS #7, the certificate and its key are provided as PKCS #12 blob:
 *     - Method: #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED or
 *               #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_SHA1
 *     - DetachedHashAlgorithm: hash algorithm for
 *               #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED
 *     - Certificate: PKCS #12 blob containing certificate (need not be
 *               self-signed) and its private key
 *     - PKCS#12Password: password for private key in the PKCS #12 blob
 *     .
 * <dt>(2h)
 * <dd>PKCS #7, the certificate is selected programmatically or by the PDF
 *     document without user interaction:
 *     - Method: #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED or
 *               #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_SHA1
 *     - DetachedHashAlgorithm: hash algorithm for
 *               #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED
 *     - SelectCertificate:
 *          #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_SOFTWARE
 *          and/or
 *          #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_HARDWARE,
 *          #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_NEVER_ASK
 *     - FilterCertificatesByPolicy: accept certificates having all of these
 *          certificate policies
 *     - FilterCertificatesByIssuerCertificate: the acceptable issuer
 *          certificates (optional)
 *     - FilterCertificatesBySubjectCertificate: the acceptable certificates
 *          (optional)
 *     - FilterCertificatesBySubjectDN: accept certificates issued for these
 *          subjects (optional)
 *     .
 * <dt>(2i)
 * <dd>PKCS #7, private key and self-signed certificate created on the fly:
 *     - Method: #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED
 *               or #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_SHA1
 *     - DetachedHashAlgorithm: hash algorithm for
 *               #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED
 *     - CommonName: signer's name
 *     - GenerateKeyPair: 1024-4096
 *     .
 * <dt>(2j)
 * <dd>PKCS #7, private key provided, self-signed certificate created on
 *     the fly:
 *     - Method: #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED or
 *               #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_SHA1
 *     - DetachedHashAlgorithm: hash algorithm for
 *               #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED
 *     - CommonName: signer's name
 *     - CertificatePrivateKey: private key for self-signed certificate
 *     .
 * <dt>(2k)
 * <dd>PKCS #7, private key provided, self-signed certificate provided:
 *     - Method: #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED or
 *               #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_SHA1
 *     - DetachedHashAlgorithm: hash algorithm for
 *               #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED
 *     - Certificate: self-signed certificate
 *     - CertificatePrivateKey: private key for self-signed certificate
 *     - Signer: Signer's name (not yet extracted from certificate)
 *     .
 * </dl>
 *
 * Additionally:
 * - Set integer parameter "Optimize" to
 *   #SIGNDOC_SIGNATUREPARAMETERS_OPTIMIZE_OPTIMIZE unless
 *   SIGNDOC_Document_getRequiredSaveToFileFlags()
 *   indicates that #SIGNDOC_DOCUMENT_SAVEFLAGS_INCREMENTAL must be used.
 *   Note that #SIGNDOC_SIGNATUREPARAMETERS_OPTIMIZE_OPTIMIZE requires
 *   string parameter "OutputPath".
 * .
 *
 * For TIFF documents, an additional, simplified signing method is available:
 * <dl>
 * <dt>(3)
 * <dd>just a hash:
 *     - Method: #SIGNDOC_SIGNATUREPARAMETERS_METHOD_HASH
 *     - CommonName: signer's name
 *     .
 * </dl>
 *
 * @class SIGNDOC_SignatureParameters
 */
struct SIGNDOC_SignatureParameters;

/**
 * @brief Attributes of a text field, list box field or combo box
 *        field used for the construction of the appearance (PDF
 *        documents only).
 *
 * This class represents a PDF default appearance string.
 *
 * Modifying an object of this type does not modify the underlying
 * field or document.  Use SIGNDOC_Document_setTextFieldAttributes()
 * or SIGNDOC_Field_setTextFieldAttributes() to update the text attributes
 * of a field or of the document.
 *
 * @see SIGNDOC_Document_getTextFieldAttributes(), SIGNDOC_Document_setTextFieldAttributes(), SIGNDOC_Field_getTextFieldAttributes(), SIGNDOC_Field_setTextFieldAttributes()
 *
 * @class SIGNDOC_TextFieldAttributes
 */
struct SIGNDOC_TextFieldAttributes;

/**
 * @brief Information about a signature field returned by
 *        SIGNDOC_Document_verifySignature().
 *
 * @class SIGNDOC_VerificationResult
 */
struct SIGNDOC_VerificationResult;

/**
 * @brief Parameters for a watermark.
 *
 * @see SIGNDOC_Document_addWatermark()
 *
 * @class SIGNDOC_Watermark
 *
 * @todo fromFile(): PDF/image, page number, absolute scale
 * @todo setUnderline()
 */
struct SIGNDOC_Watermark;

/* --------------------------------------------------------------------------*/

/**
 * @brief Free a block of  memory.
 *
 * @param[in] aPtr A pointer to the block of memory to be freed.
 *
 * @see SIGNDOC_alloc(), SIGNDOC_strdup()
 *
 * @todo list functions returning suitable pointers
 */
void SDCAPI
SIGNDOC_free (void *aPtr);

/**
 * @brief Allocate a block of  memory.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in]  aSize   The size in octets.
 *
 * @return A pointer to the block of memory.
 *         The block of memory must be freed with SIGNDOC_free().
 *
 * @see SIGNDOC_free()
 */
void * SDCAPI
SIGNDOC_alloc (struct SIGNDOC_Exception **aEx, size_t aSize);

/**
 * @brief Allocate a block of  memory initialized with a null-terminated
 *        string.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in]  aStr    A pointer to the null-terminated string to be copied.
 *
 * @return A pointer to the copied string.
 *         The string must be freed with SIGNDOC_free().
 *
 * @see SIGNDOC_free(), SIGNDOC_recodeStringRelaxed(), SIGNDOC_recodeStringStrict()
 */
char * SDCAPI
SIGNDOC_strdup (struct SIGNDOC_Exception **aEx, const char *aStr);

/**
 * @brief Convert a string from one encoding to another encoding.
 *
 * An exception will be thrown if the input string is not correctly
 * encoded or if any character of the string cannot be encoded
 * according to @a aOujtputEncoding.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aInputEncoding  The encoding of @a aInput
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aInput   A pointer to the null-terminated string to be
 *                     converted.
 * @param[in] aOutputEncoding  The encoding to be used for the return value
 *                        (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                        or #SIGNDOC_ENCODING_LATIN_1).
 *
 * @return A pointer to the converted string.
 *         The string must be freed with SIGNDOC_free().
 *
 * @see SIGNDOC_free(), SIGNDOC_recodeStringRelaxed()
 */
char * SDCAPI
SIGNDOC_recodeStringStrict (struct SIGNDOC_Exception **aEx,
                            int aInputEncoding, const char *aInput,
                            int aOutputEncoding);

/**
 * @brief Convert a string from one encoding to another encoding.
 *
 * An exception will be thrown if the input string is not correctly
 * encoded. Any character that cannot be respresented by @a aOutputEncoding
 * will be converted to '?'.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aInputEncoding  The encoding of @a aInput
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aInput   A pointer to the null-terminated string to be
 *                     converted.
 * @param[in] aOutputEncoding  The encoding to be used for the return value
 *                        (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                        or #SIGNDOC_ENCODING_LATIN_1).
 *
 * @return A pointer to the converted string.
 *         The string must be freed with SIGNDOC_free().
 *
 * @see SIGNDOC_free(), SIGNDOC_recodeStringStrict()
 */
char * SDCAPI
SIGNDOC_recodeStringRelaxed (struct SIGNDOC_Exception **aEx,
                             int aInputEncoding, const char *aInput,
                             int aOutputEncoding);

/* --------------------------------------------------------------------------*/

/**
 * @brief Create a new array of strings.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 *
 * @return A pointer to a new array of strings.
 *
 * @see SIGNDOC_StringArray_delete()
 *
 * @memberof SIGNDOC_StringArray
 */
struct SIGNDOC_StringArray * SDCAPI
SIGNDOC_StringArray_new (struct SIGNDOC_Exception **aEx);

/**
 * @brief Free an array of strings and all its elements.
 *
 * @param[in] aArray  A pointer to an array of strings created by
 *                    SIGNDOC_StringArray_new().
 *
 * @memberof SIGNDOC_StringArray
 */
void SDCAPI
SIGNDOC_StringArray_delete (struct SIGNDOC_StringArray *aArray);

/**
 * @brief Get the number of elements in an array of strings.
 *
 * @param[in] aArray  A pointer to an array of strings created by
 *                    SIGNDOC_StringArray_new().
 *
 * @return The number of elements in the array.
 *
 * @memberof SIGNDOC_StringArray
 */
unsigned SDCAPI
SIGNDOC_StringArray_count (const struct SIGNDOC_StringArray *aArray);

/**
 * @brief Get a particular string of an array of strings.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[in] aArray  A pointer to an array of strings created by
 *                    SIGNDOC_StringArray_new().
 * @param[in] aIdx    The 0-based array index.
 *
 * @return A pointer to the string at index @a aIdx.
 *
 * @memberof SIGNDOC_StringArray
 */
const char * SDCAPI
SIGNDOC_StringArray_at (struct SIGNDOC_StringArray *aArray, unsigned aIdx);

/* --------------------------------------------------------------------------*/

/**
 * @brief Create a new array of fields (SIGNDOC_Field objects).
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 *
 * @return A pointer to a new array of fields.
 *
 * @see SIGNDOC_FieldArray_delete()
 *
 * @memberof SIGNDOC_FieldArray
 */
struct SIGNDOC_FieldArray * SDCAPI
SIGNDOC_FieldArray_new (struct SIGNDOC_Exception **aEx);

/**
 * @brief Free an array of fields and all its elements.
 *
 * @param[in] aArray  A pointer to an array of fields created by
 *                    SIGNDOC_FieldArray_new().

 * @memberof SIGNDOC_FieldArray
 */
void SDCAPI
SIGNDOC_FieldArray_delete (struct SIGNDOC_FieldArray *aArray);

/**
 * @brief Get the number of elements in an array of fields.
 *
 * @param[in] aArray  A pointer to an array of fields created by
 *                    SIGNDOC_FieldArray_new().
 *
 * @return The number of elements in the array.
 *
 * @memberof SIGNDOC_FieldArray
 */
unsigned SDCAPI
SIGNDOC_FieldArray_count (const struct SIGNDOC_FieldArray *aArray);

/**
 * @brief Get a particular field from an array of fields.
 *
 * @param[in] aArray  A pointer to an array of fields created by
 *                    SIGNDOC_FieldArray_new().
 * @param[in] aIdx    The 0-based array index.
 *
 * @return A pointer to the field at position @a aIdx.
 *
 * @memberof SIGNDOC_FieldArray
 */
struct SIGNDOC_Field * SDCAPI
SIGNDOC_FieldArray_at (struct SIGNDOC_FieldArray *aArray, unsigned aIdx);

/* --------------------------------------------------------------------------*/

/**
 * @brief Create a new array of SIGNDOC_FindTextPosition objects.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 *
 * @return A pointer to a new array of SIGNDOC_FiendTextPosition objects.
 *
 * @see SIGNDOC_FindTextPositionArray_delete()
 *
 * @memberof SIGNDOC_FindTextPositionArray
 */
struct SIGNDOC_FindTextPositionArray * SDCAPI
SIGNDOC_FindTextPositionArray_new (struct SIGNDOC_Exception **aEx);

/**
 * @brief Free an array of SIGNDOC_FindTextPosition objects and all
 *        its elements.
 *
 * @param[in] aArray  A pointer to an array created by
 *                    SIGNDOC_FindTextPositionArray_new().
 *
 * @memberof SIGNDOC_FindTextPositionArray
 */
void SDCAPI
SIGNDOC_FindTextPositionArray_delete (struct SIGNDOC_FindTextPositionArray *aArray);

/**
 * @brief Get the number of elements in an array of
 *        SIGNDOC_FindTextPosition objects.
 *
 * @param[in] aArray  A pointer to an array created by
 *                    SIGNDOC_FindTextPositionArray_new().
 *
 * @return The number of elements in the array.
 *
 * @memberof SIGNDOC_FindTextPositionArray
 */
unsigned SDCAPI
SIGNDOC_FindTextPositionArray_count (const struct SIGNDOC_FindTextPositionArray *aArray);

/**
 * @brief Get a particular SIGNDOC_FindTextPosition object from an array.
 *
 * @param[in] aArray  A pointer to an array created by
 *                    SIGNDOC_FindTextPositionArray_new().
 * @param[in] aIdx    The 0-based array index.
 *
 * @return A pointer to the SIGNDOC_FindTextPosition object at position
 *         @a aIdx.
 *
 * @memberof SIGNDOC_FindTextPositionArray
 */
struct SIGNDOC_FindTextPosition * SDCAPI
SIGNDOC_FindTextPositionArray_at (struct SIGNDOC_FindTextPositionArray *aArray,
                                  unsigned aIdx);

/* --------------------------------------------------------------------------*/

/**
 * @brief Create a new array of bytes (blob).
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 *
 * @return A pointer to a new array of bytes.
 *
 * @see SIGNDOC_ByteArray_delete()
 *
 * @memberof SIGNDOC_ByteArray
 */
struct SIGNDOC_ByteArray * SDCAPI
SIGNDOC_ByteArray_new (struct SIGNDOC_Exception **aEx);

/**
 * @brief Free an array of bytes.
 *
 * @param[in] aArray  A pointer to an array of bytes created by
 *                    SIGNDOC_ByteArray_new(), must not be a
 *                    pointer returned by SIGNDOC_ByteArrayArray_at().
 *
 * @memberof SIGNDOC_ByteArray
 */
void SDCAPI
SIGNDOC_ByteArray_delete (struct SIGNDOC_ByteArray *aArray);

/**
 * @brief Get the number of elements in an array of bytes.
 *
 * @param[in] aArray  A pointer to an array of bytes created by
 *                    SIGNDOC_ByteArray_new().
 *
 * @return The number of elements (bytes).
 *
 * @memberof SIGNDOC_ByteArray
 */
unsigned SDCAPI
SIGNDOC_ByteArray_count (const struct SIGNDOC_ByteArray *aArray);

/**
 * @brief Get a particular byte of an array of bytes.
 *
 * @param[in] aArray  A pointer to an array of bytes created by
 *                    SIGNDOC_ByteArray_new().
 * @param[in] aIdx    The 0-based array index.
 *
 * @return The byte at index @a aIdx.
 *
 * @memberof SIGNDOC_ByteArray
 */
unsigned char SDCAPI
SIGNDOC_ByteArray_at (struct SIGNDOC_ByteArray *aArray, unsigned aIdx);

/**
 * @brief Get a pointer to the data in an array of bytes.
 *
 * @param[in] aArray  A pointer to an array of bytes created by
 *                    SIGNDOC_ByteArray_new().
 *
 * @return A pointer to the first byte or NULL if the array is empty.
 *
 * @see SIGNDOC_ByteArray_at(), SIGNDOC_ByteArray_count()
 *
 * @memberof SIGNDOC_ByteArray
 */
unsigned char * SDCAPI
SIGNDOC_ByteArray_data (struct SIGNDOC_ByteArray *aArray);

/**
 * @brief Clear a SIGNDOC_ByteArray object.
 *
 * SIGNDOC_ByteArray_count() will return 0.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_UserOutputStream object.
 *
 * @memberof SIGNDOC_ByteArray
 */
void SDCAPI
SIGNDOC_ByteArray_clear (struct SIGNDOC_ByteArray *aObj);

/**
 * @brief Replace all the data in a SIGNDOC_ByteArray object.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_UserOutputStream object.
 * @param[in] aPtr     A pointer to the first octet.
 * @param[in] aSize    Number of octets pointed to by @a aPtr.
 *
 * @memberof SIGNDOC_ByteArray
 */
void SDCAPI
SIGNDOC_ByteArray_set (struct SIGNDOC_Exception **aEx,
                       struct SIGNDOC_ByteArray *aObj,
                       const unsigned char *aPtr, size_t aSize);

/* --------------------------------------------------------------------------*/

/**
 * @brief Create a new array of properties (SIGNDOC_Property objects).
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 *
 * @return A pointer to a new array of properties.
 *
 * @see SIGNDOC_PropertyArray_delete()
 *
 * @memberof SIGNDOC_PropertyArray
 */
struct SIGNDOC_PropertyArray * SDCAPI
SIGNDOC_PropertyArray_new (struct SIGNDOC_Exception **aEx);

/**
 * @brief Free an array of properties and all its elements.
 *
 * @param[in] aArray  A pointer to an array of properties created by
 *                    SIGNDOC_PropertyArray_new().

 * @memberof SIGNDOC_PropertyArray
 */
void SDCAPI
SIGNDOC_PropertyArray_delete (struct SIGNDOC_PropertyArray *aArray);

/**
 * @brief Get the number of elements in an array of properties.
 *
 * @param[in] aArray  A pointer to an array of properties created by
 *                    SIGNDOC_PropertyArray_new().
 *
 * @return The number of elements in the array.
 *
 * @memberof SIGNDOC_PropertyArray
 */
unsigned SDCAPI
SIGNDOC_PropertyArray_count (const struct SIGNDOC_PropertyArray *aArray);

/**
 * @brief Get a particular property from an array of properties.
 *
 * @param[in] aArray  A pointer to an array of properties created by
 *                    SIGNDOC_PropertyArray_new().
 * @param[in] aIdx    The 0-based array index.
 *
 * @return A pointer to the property at position @a aIdx.
 *
 * @memberof SIGNDOC_PropertyArray
 */
struct SIGNDOC_Property * SDCAPI
SIGNDOC_PropertyArray_at (struct SIGNDOC_PropertyArray *aArray, unsigned aIdx);

/* --------------------------------------------------------------------------*/

/**
 * @brief Creates a new array of SIGNDOC_ByteArray objects.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 *
 * @return A pointer to a new array of SIGNDOC_ByteArray objects.
 *
 * @see SIGNDOC_ByteArrayArray_delete()
 *
 * @memberof SIGNDOC_ByteArrayArray
 */
struct SIGNDOC_ByteArrayArray * SDCAPI
SIGNDOC_ByteArrayArray_new (struct SIGNDOC_Exception **aEx);

/**
 * @brief Free an array of SIGNDOC_ByteArray objects and all its elements.
 *
 * @param[in] aArray  A pointer to an array created by
 *                    SIGNDOC_ByteArrayArray_new().
 *
 * @memberof SIGNDOC_ByteArrayArray
 */
void SDCAPI
SIGNDOC_ByteArrayArray_delete (struct SIGNDOC_ByteArrayArray *aArray);

/**
 * @brief Get the number of elements in an array of SIGNDOC_ByteArray objects.
 *
 * @param[in] aArray  A pointer to an array created by
 *                    SIGNDOC_ByteArrayArray_new().
 *
 * @return The number of elements (blobs).
 *
 * @memberof SIGNDOC_ByteArrayArray
 */
unsigned SDCAPI
SIGNDOC_ByteArrayArray_count (const struct SIGNDOC_ByteArrayArray *aArray);

/**
 * @brief Get a particular element of an array of SIGNDOC_ByteArray objects.
 *
 * @param[in] aArray  A pointer to an array created by
 *                    SIGNDOC_ByteArrayArray_new().
 * @param[in] aIdx    The 0-based array index.
 *
 * @return A pointer to SIGNDOC_ByteArray object at position @a aIdx.
 *
 * @memberof SIGNDOC_ByteArrayArray
 */
struct SIGNDOC_ByteArray * SDCAPI
SIGNDOC_ByteArrayArray_at (struct SIGNDOC_ByteArrayArray *aArray,
                           unsigned aIdx);

/* --------------------------------------------------------------------------*/

/**
 * @brief Exception handler
 *
 * The exception handler passed to SIGNDOC_Exception_setHandler().
 *
 * @param[in] aEx  The @a aEx argument of the SignDoc SDK function
 *                 which reports the exception. The pointer to the
 *                 SIGNDOC_Exception object has already been stored
 *                 to *@a aEx. If you call SIGNDOC_Exception_delete(*aEx),
 *                 you must set *@a aEx to NULL.
 *
 * @memberof SIGNDOC_Exception
 */
typedef void (SDCAPI *SIGNDOC_ExceptionHandler) (struct SIGNDOC_Exception **aEx);

/**
 * @brief Sets an exception handler that is called when an exception
 *        occurs.
 *
 * Usage of this function is discouraged, check the object passed as
 * @a aEx after each function call instead. The handler is global to
 * the process.
 *
 * @param[in] aHandler   Exception handler function, NULL to disable.
 *
 * @memberof SIGNDOC_Exception
 */
void SDCAPI
SIGNDOC_Exception_setHandler (SIGNDOC_ExceptionHandler aHandler);


/**
 * @brief Create a new SIGNDOC_Exception object.
 *
 * This function is needed only for throwing exceptions from
 * callback functions such as SIGNDOC_UserInputStream_read().
 *
 * @param[in] aType   The type of the message:
 *                    - #SIGNDOC_EXCEPTION_TYPE_BAD_ALLOC
 *                    - #SIGNDOC_EXCEPTION_TYPE_PDF
 *                    - #SIGNDOC_EXCEPTION_TYPE_STL
 *                    - #SIGNDOC_EXCEPTION_TYPE_GENERIC
 *                    - #SIGNDOC_EXCEPTION_TYPE_SPOOC_GENERIC
 *                    - #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR
 *                    - #SIGNDOC_EXCEPTION_TYPE_SPOOC_IO
 *                    .
 * @param[in] aMessage  A pointer to the message or NULL. The string
 *                      will be copied.
 *
 * If creating the object or copying @a aMessage fails (due to
 * lack of memory), this function will return a pointer to a special,
 * statically SIGNDOC_Exception object which has type
 * #SIGNDOC_EXCEPTION_TYPE_BAD_ALLOC and a suitable message.
 *
 * @return A pointer to a new SIGNDOC_Exception object
 *         or to a statically allocated SIGNDOC_Exception_object
 *         with type #SIGNDOC_EXCEPTION_TYPE_BAD_ALLOC.
 *
 * @see SIGNDOC_Exception_delete()
 *
 * @memberof SIGNDOC_Exception
 */
struct SIGNDOC_Exception * SDCAPI
SIGNDOC_Exception_new (unsigned aType, const char *aMessage);

/**
 * @brief Destroy a SIGNDOC_Exception object.
 *
 * If @a aEx points to the statically allocated object returned by
 * SIGNDOC_Exception_new() in an out-of-memory situation, this function
 * will do nothing.
 *
 * @param[in] aEx  A pointer to a SIGNDOC_Exception object, can be NULL.
 *
 * @memberof SIGNDOC_Exception
 */
void SDCAPI
SIGNDOC_Exception_delete (struct SIGNDOC_Exception *aEx);

/**
 * @brief Get the message text of an SIGNDOC_Exception object.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[in] aEx  A pointer to a SIGNDOC_Exception object.
 *
 * @return A pointer to the message string or NULL.
 *
 * @see SIGNDOC_Exception_getType()
 *
 * @memberof SIGNDOC_Exception
 */
const char * SDCAPI
SIGNDOC_Exception_getText (const struct SIGNDOC_Exception *aEx);

/**
 * @brief Get the type of the exception.
 *
 * @param[in] aEx  A pointer to a SIGNDOC_Exception object.
 *
 * @return The type of the exception:
 *         - #SIGNDOC_EXCEPTION_TYPE_BAD_ALLOC
 *         - #SIGNDOC_EXCEPTION_TYPE_PDF
 *         - #SIGNDOC_EXCEPTION_TYPE_STL
 *         - #SIGNDOC_EXCEPTION_TYPE_GENERIC
 *         - #SIGNDOC_EXCEPTION_TYPE_SPOOC_GENERIC
 *         - #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR
 *         - #SIGNDOC_EXCEPTION_TYPE_SPOOC_IO
 *         .
 *
 * @see SIGNDOC_Exception_getText()
 *
 * @memberof SIGNDOC_Exception
 */
unsigned SDCAPI
SIGNDOC_Exception_getType (const struct SIGNDOC_Exception *aEx);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_FileInputStream constructor: Read from a C stream.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aFile  The C stream to be wrapped.
 *
 * @return A pointer to a new SIGNDOC_InputStream object
 *         or NULL on error.
 *
 * @memberof SIGNDOC_InputStream
 */
struct SIGNDOC_InputStream * SDCAPI
SIGNDOC_FileInputStream_newWithFile (struct SIGNDOC_Exception **aEx,
                                     FILE *aFile);

/**
 * @brief SIGNDOC_FileInputStream constructor: Read from a C stream.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aFile  The C stream to be wrapped.
 * @param[in] aPath  The pathname (native encoding), used in exceptions,
 *                   can be NULL.
 *                   See @ref winrt_store for restrictions on pathnames
 *                   in Windows Store apps.
 *
 * @return A pointer to a new SIGNDOC_InputStream object
 *         or NULL on error.
 *
 * @memberof SIGNDOC_InputStream
 */
struct SIGNDOC_InputStream * SDCAPI
SIGNDOC_FileInputStream_newWithFileAndPath (struct SIGNDOC_Exception **aEx,
                                            FILE *aFile, const char *aPath);

/**
 * @brief SIGNDOC_FileInputStream constructor: Open a file in binary mode.
 *
 * Throws an exception of type #SIGNDOC_EXCEPTION_TYPE_SPOOC_IO on error.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aPath  The name of the file to be opened (native encoding).
 *                   See @ref winrt_store for restrictions on pathnames
 *                   in Windows Store apps.
 *
 * @return A pointer to a new SIGNDOC_InputStream object
 *         or NULL on error.
 *
 * @memberof SIGNDOC_InputStream
 */
struct SIGNDOC_InputStream * SDCAPI
SIGNDOC_FileInputStream_newWithPath (struct SIGNDOC_Exception **aEx,
                                     const char *aPath);

/**
 * @brief SIGNDOC_FileInputStream constructor: Open a file in binary mode.
 *
 * Throws an exception of type #SIGNDOC_EXCEPTION_TYPE_SPOOC_IO on error.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aPath  The name of the file to be opened.
 *
 * @return A pointer to a new SIGNDOC_InputStream object
 *         or NULL on error.
 *
 * @memberof SIGNDOC_InputStream
 */
struct SIGNDOC_InputStream * SDCAPI
SIGNDOC_FileInputStream_newWithPathW (struct SIGNDOC_Exception **aEx,
                                       const wchar_t *aPath);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_FileOutputStream constructor: Write to a C stream.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aFile  The C stream to be wrapped.
 *
 * @return A pointer to a new SIGNDOC_FileOutputStream object
 *         or NULL on error.
 *
 * @memberof SIGNDOC_OutputStream
 */
struct SIGNDOC_OutputStream * SDCAPI
SIGNDOC_FileOutputStream_newWithFile (struct SIGNDOC_Exception **aEx,
                                      FILE *aFile);

/**
 * @brief SIGNDOC_FileOutputStream constructor: Write to a C stream.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aFile  The C stream to be wrapped.
 * @param[in] aPath  The pathname (native encoding), used in exceptions,
 *                   can be NULL.
 *
 * @return A pointer to a new SIGNDOC_FileOutputStream object
 *         or NULL on error.
 *
 * @memberof SIGNDOC_OutputStream
 */
struct SIGNDOC_OutputStream * SDCAPI
SIGNDOC_FileOutputStream_newWithFileAndPath (struct SIGNDOC_Exception **aEx,
                                             FILE *aFile, const char *aPath);

/**
 * @brief SIGNDOC_FileOutputStream constructor: Open a file in binary mode.
 *
 * If the named file already exists, it will be truncated.
 *
 * Throws an exception of type #SIGNDOC_EXCEPTION_TYPE_SPOOC_IO on error.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aPath  The name of the file to be opened (native encoding).
 *                   See @ref winrt_store for restrictions on pathnames
 *                   in Windows Store apps.
 *
 * @return A pointer to a new SIGNDOC_FileOutputStream object
 *         or NULL on error.
 *
 * @memberof SIGNDOC_OutputStream
 */
struct SIGNDOC_OutputStream * SDCAPI
SIGNDOC_FileOutputStream_newWithPath (struct SIGNDOC_Exception **aEx,
                                      const char *aPath);

/**
 * @brief SIGNDOC_FileOutputStream constructor: Open a file in binary mode.
 *
 * If the named file already exists, it will be truncated.
 *
 * Throws an exception of type #SIGNDOC_EXCEPTION_TYPE_SPOOC_IO on error.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aPath  The name of the file to be opened.
 *
 * @return A pointer to a new SIGNDOC_FileOutputStream object
 *         or NULL on error.
 *
 * @memberof SIGNDOC_OutputStream
 */
struct SIGNDOC_OutputStream * SDCAPI
SIGNDOC_FileOutputStream_newWithPathW (struct SIGNDOC_Exception **aEx,
                                       const wchar_t *aPath);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_UserInputStream callback implementing close().
 */
typedef void (SDCAPI *SIGNDOC_UserInputStream_close)(struct SIGNDOC_Exception **aEx,
                                                     void *aClosure);

/**
 * @brief SIGNDOC_UserInputStream callback implementing read().
 */
typedef int (SDCAPI *SIGNDOC_UserInputStream_read)(struct SIGNDOC_Exception **aEx,
                                                   void *aClosure,
                                                   void *aDst, int aLen);

/**
 * @brief SIGNDOC_UserInputStream callback implementing seek().
 */
typedef void (SDCAPI *SIGNDOC_UserInputStream_seek)(struct SIGNDOC_Exception **aEx,
                                                    void *aClosure,
                                                    int aPos);

/**
 * @brief SIGNDOC_UserInputStream callback implementing tell().
 */
typedef int (SDCAPI *SIGNDOC_UserInputStream_tell)(struct SIGNDOC_Exception **aEx,
                                                   const void *aClosure);

/**
 * @brief SIGNDOC_UserInputStream callback implementing getAvailable().
 */
typedef int (SDCAPI *SIGNDOC_UserInputStream_getAvailable)(struct SIGNDOC_Exception **aEx,
                                                           void *aClosure);

/**
 * @brief SIGNDOC_UserInputStream constructor.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aClosure A pointer to user-defined object that will be passed
 *                     to the callbacks.
 * @param[in] aClose   Pointer to function implementing close().
 * @param[in] aRead    Pointer to function implementing read().
 * @param[in] aSeek    Pointer to function implementing seek().
 * @param[in] aTell    Pointer to function implementing tell().
 * @param[in] aGetAvailable    Pointer to function implementing getAvailable().
 *
 * @return A pointer to a new SIGNDOC_InputStream object
 *         or NULL on error.
 *
 * @memberof SIGNDOC_InputStream
 */
struct SIGNDOC_InputStream * SDCAPI
SIGNDOC_UserInputStream_new (struct SIGNDOC_Exception **aEx,
                             void *aClosure,
                             SIGNDOC_UserInputStream_close aClose,
                             SIGNDOC_UserInputStream_read aRead,
                             SIGNDOC_UserInputStream_seek aSeek,
                             SIGNDOC_UserInputStream_tell aTell,
                             SIGNDOC_UserInputStream_getAvailable aGetAvailable);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_UserOutputStream callback implementing close().
 */
typedef void (SDCAPI *SIGNDOC_UserOutputStream_close)(struct SIGNDOC_Exception **aEx,
                                                      void *aClosure);

/**
 * @brief SIGNDOC_UserOutputStream callback implementing flush().
 */
typedef void (SDCAPI *SIGNDOC_UserOutputStream_flush)(struct SIGNDOC_Exception **aEx,
                                                      void *aClosure);

/**
 * @brief SIGNDOC_UserOutputStream callback implementing write().
 */
typedef void (SDCAPI *SIGNDOC_UserOutputStream_write)(struct SIGNDOC_Exception **aEx,
                                                      void *aClosure,
                                                      const void *aSrc, int aLen);

/**
 * @brief SIGNDOC_UserOutputStream callback implementing seek().
 */
typedef void (SDCAPI *SIGNDOC_UserOutputStream_seek)(struct SIGNDOC_Exception **aEx,
                                                     void *aClosure,
                                                     int aPos);

/**
 * @brief SIGNDOC_UserOutputStream callback implementing tell().
 */
typedef int (SDCAPI *SIGNDOC_UserOutputStream_tell)(struct SIGNDOC_Exception **aEx,
                                                    const void *aClosure);

/**
 * @brief SIGNDOC_UserOutputStream constructor.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aClosure A pointer to user-defined object that will be passed
 *                     to the callbacks.
 * @param[in] aClose   Pointer to function implementing close().
 * @param[in] aFlush   Pointer to function implementing flush().
 * @param[in] aWrite   Pointer to function implementing write().
 * @param[in] aSeek    Pointer to function implementing seek().
 * @param[in] aTell    Pointer to function implementing tell().
 *
 * @return A pointer to a new SIGNDOC_OutputStream object
 *         or NULL on error.
 *
 * @memberof SIGNDOC_OutputStream
 */
struct SIGNDOC_OutputStream * SDCAPI
SIGNDOC_UserOutputStream_new (struct SIGNDOC_Exception **aEx,
                              void *aClosure,
                              SIGNDOC_UserOutputStream_close aClose,
                              SIGNDOC_UserOutputStream_flush aFlush,
                              SIGNDOC_UserOutputStream_write aWrite,
                              SIGNDOC_UserOutputStream_seek aSeek,
                              SIGNDOC_UserOutputStream_tell aTell);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_InputStream destructor.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_InputStream object.
 *
 * @memberof SIGNDOC_InputStream
 *
 * @todo list functions creating a SIGNDOC_InputStream
 */
void SDCAPI
SIGNDOC_InputStream_delete (struct SIGNDOC_InputStream *aObj);

/**
 * @brief Read octets from a SIGNDOC_InputStream.
 *
 * May throw an exception of type #SIGNDOC_EXCEPTION_TYPE_SPOOC.
 *
 * Once this function has returned a value smaller than
 * @a aLen, end of input has been reached and further calls
 * should return 0.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_InputStream object.
 * @param[out] aDst    Pointer to buffer to be filled.
 * @param[in] aLen     Number of octets to read.
 *
 * @return The number of octets read.
 *
 * @memberof SIGNDOC_InputStream
 */
int SDCAPI
SIGNDOC_InputStream_read (struct SIGNDOC_Exception **aEx,
                          struct SIGNDOC_InputStream *aObj,
                          void *aDst, int aLen);

/**
 * @brief Close a SIGNDOC_InputStream.
 *
 * Does not destroy the SIGNDOC_InputStream object.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_InputStream object.
 *
 * @memberof SIGNDOC_InputStream
 */
void SDCAPI
SIGNDOC_InputStream_close (struct SIGNDOC_Exception **aEx,
                           struct SIGNDOC_InputStream *aObj);

/**
 * @brief Seek to the specified position in a SIGNDOC_InputStream.
 *
 * Throws an exception (type #SIGNDOC_EXCEPTION_TYPE_SPOOC) if the position
 * is invalid or if seeking is not supported.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_InputStream object.
 * @param[in] aPos     The position (zero being the first octet).
 *
 * @memberof SIGNDOC_InputStream
 */
void SDCAPI
SIGNDOC_InputStream_seek (struct SIGNDOC_Exception **aEx,
                          struct SIGNDOC_InputStream *aObj,
                          int aPos);

/**
 * @brief Retrieve the current position of a SIGNDOC_InputStream.
 *
 * Throws an exception (type #SIGNDOC_EXCEPTION_TYPE_SPOOC) if seeking is
 * not supported or if the position cannot be represented as non-negative
 * int.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_InputStream object.
 *
 * @return The current position (zero being the first octet)
 *
 * @memberof SIGNDOC_InputStream
 */
int SDCAPI
SIGNDOC_InputStream_tell (struct SIGNDOC_Exception **aEx,
                          struct SIGNDOC_InputStream *aObj);

/**
 * @brief Get an estimate of the number of octets available for reading
 *        from a SIGNDOC_InputStream.
 *
 * Throws an exception (type #SIGNDOC_EXCEPTION_TYPE_SPOOC) if this function
 * is not supported.
 *
 * @note There may be more octets available than reported by this
 *       function, but never less.  If there is at least one octet
 *       available for reading, the return value must be at least one.
 *       (That is, always returning zero is not possible.)
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_InputStream object.
 *
 * @return The minimum number of octets available for reading.
 *
 * @memberof SIGNDOC_InputStream
 */
int SDCAPI
SIGNDOC_InputStream_getAvailable (struct SIGNDOC_Exception **aEx,
                                  struct SIGNDOC_InputStream *aObj);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_MemoryInputStream constructor.
 *
 * Read from the buffer pointed to by @a aSrc. Note that the buffer contents
 * won't be copied, therefore the buffer must remain valid throughout
 * the use of this object.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aSrc  Points to the stream contents.
 * @param[in] aLen  Size of the stream contents.
 *
 * @return A pointer to a new SIGNDOC_InputStream object
 *         or NULL on error.
 *
 * @memberof SIGNDOC_InputStream
 */
struct SIGNDOC_InputStream * SDCAPI
SIGNDOC_MemoryInputStream_new (struct SIGNDOC_Exception **aEx,
                               const unsigned char *aSrc, size_t aLen);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_MemoryOutputStream constructor.
 *
 * Create a new SIGNDOC_OutputStream object which writes to memory,
 * allocating memory as needed.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 *
 * @return A pointer to a new SIGNDOC_OutputStream object
 *         or NULL on error.
 *
 * @memberof SIGNDOC_OutputStream
 */
struct SIGNDOC_OutputStream * SDCAPI
SIGNDOC_MemoryOutputStream_new (struct SIGNDOC_Exception **aEx);

/**
 * @brief Retrieve a pointer to the contents of a SIGNDOC_MemoryOutputStream.
 *
 * Note that the returned pointer is only valid up to the next
 * output to the stream.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_OutputStream object.
 *
 * @return Pointer to the first octet of the stream contents.
 *
 * @memberof SIGNDOC_OutputStream
 */
const unsigned char * SDCAPI
SIGNDOC_MemoryOutputStream_data (struct SIGNDOC_Exception **aEx,
                                 struct SIGNDOC_OutputStream *aObj);

/**
 * @brief Retrieve the length of the contents of a SIGNDOC_MemoryOutputStream.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_OutputStream object.
 *
 * @return Number of octets.
 *
 * @memberof SIGNDOC_OutputStream
 */
size_t  SDCAPI
SIGNDOC_MemoryOutputStream_length (struct SIGNDOC_Exception **aEx,
                                   struct SIGNDOC_OutputStream *aObj);

/**
 * @brief Clear the buffered data of a SIGNDOC_MemoryOutputStream.
 *
 * The buffer will be empty and the current position will be zero.
 *
 * The buffer may or may not be deallocated.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_OutputStream object.
 *
 * @memberof SIGNDOC_OutputStream
 */
void SDCAPI
SIGNDOC_MemoryOutputStream_clear (struct SIGNDOC_Exception **aEx,
                                  struct SIGNDOC_OutputStream *aObj);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_OutputStream destructor.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_OutputStream object.
 *
 * @memberof SIGNDOC_OutputStream
 *
 * @todo list functions creating a SIGNDOC_OutputStream
 */
void SDCAPI
SIGNDOC_OutputStream_delete (struct SIGNDOC_OutputStream *aObj);

/**
 * @brief Close a SIGNDOC_OutputStream.
 *
 * Does not destroy the SIGNDOC_OutputStream object.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_OutputStream object.
 *
 * @memberof SIGNDOC_OutputStream
 */
void SDCAPI
SIGNDOC_OutputStream_close (struct SIGNDOC_Exception **aEx,
                            struct SIGNDOC_OutputStream *aObj);

/**
 * @brief Flush a SIGNDOC_OutputStream.
 *
 * This function forces any buffered data to be written.
 *
 * Throws an exception of type #SIGNDOC_EXCEPTION_TYPE_SPOOC_IO on error.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_OutputStream object.
 *
 * @memberof SIGNDOC_OutputStream
 */
void SDCAPI
SIGNDOC_OutputStream_flush (struct SIGNDOC_Exception **aEx,
                            struct SIGNDOC_OutputStream *aObj);

/**
 * @brief Seek to the specified position in a SIGNDOC_OutputStream.
 *
 * Throws an exception (type #SIGNDOC_EXCEPTION_TYPE_SPOOC) if the position
 * is invalid or if seeking is not supported.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_OutputStream object.
 * @param[in] aPos     The position (zero being the first octet).
 *
 * @memberof SIGNDOC_OutputStream
 */
void SDCAPI
SIGNDOC_OutputStream_seek (struct SIGNDOC_Exception **aEx,
                           struct SIGNDOC_OutputStream *aObj,
                           int aPos);

/**
 * @brief Retrieve the current position of a SIGNDOC_OutputStream.
 *
 * Throws an exception (type #SIGNDOC_EXCEPTION_TYPE_SPOOC) if seeking is
 * not supported or if the position cannot be represented as non-negative
 * int.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_OutputStream object.
 *
 * @return The current position (zero being the first octet)
 *
 * @memberof SIGNDOC_OutputStream
 */
int SDCAPI
SIGNDOC_OutputStream_tell (struct SIGNDOC_Exception **aEx,
                           struct SIGNDOC_OutputStream *aObj);

/**
 * @brief Write octets to a SIGNDOC_OutputStream.
 *
 * Throws an exception of type #SIGNDOC_EXCEPTION_TYPE_SPOOC_IO on error.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_OutputStream object.
 * @param[in] aSrc  Pointer to buffer to be written.
 * @param[in] aLen  Number of octets to write.
 *
 * @memberof SIGNDOC_OutputStream
 */
void SDCAPI
SIGNDOC_OutputStream_write (struct SIGNDOC_Exception **aEx,
                            struct SIGNDOC_OutputStream *aObj,
                            const void *aSrc, int aLen);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_Point constructor.
 *
 * All coordinates will be 0.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 *
 * @return A pointer to the new SIGNDOC_Point object.
 * @memberof SIGNDOC_Point
 */
struct SIGNDOC_Point * SDCAPI
SIGNDOC_Point_new (struct SIGNDOC_Exception **aEx);

/**
 * @brief SIGNDOC_Point constructor.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aX  The X coordinate.
 * @param[in] aY  The Y coordinate.
 *
 * @return A pointer to the new SIGNDOC_Point object.
 *
 * @memberof SIGNDOC_Point
 */
struct SIGNDOC_Point * SDCAPI
SIGNDOC_Point_newXY (struct SIGNDOC_Exception **aEx,
                     double aX, double aY);

/**
 * @brief Clone a SIGNDOC_Point object.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Point object.
 *
 * @return A pointer to the new SIGNDOC_Point object.
 *
 * @memberof SIGNDOC_Point
 */
struct SIGNDOC_Point * SDCAPI
SIGNDOC_Point_clone (struct SIGNDOC_Exception **aEx,
                     const struct SIGNDOC_Point *aObj);

/**
 * @brief SIGNDOC_Point destructor.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Point object.
 *
 * @memberof SIGNDOC_Point
 */
void SDCAPI
SIGNDOC_Point_delete (struct SIGNDOC_Point *aObj);

/**
 * @brief SIGNDOC_Point assignment operator.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Point object.
 * @param[in] aRHS     A pointer to the source SIGNDOC_Point object.
 *
 * @memberof SIGNDOC_Point
 */
void SDCAPI
SIGNDOC_Point_assign (struct SIGNDOC_Point *aObj,
                      const struct SIGNDOC_Point *aRHS);

/**
 * @brief Set the coordinates of a SIGNDOC_Point object.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Point object.
 * @param[in] aX  The X coordinate.
 * @param[in] aY  The Y coordinate.
 *
 * @memberof SIGNDOC_Point
 */
void SDCAPI
SIGNDOC_Point_setXY (struct SIGNDOC_Point *aObj,
                     double aX, double aY);

/**
 * @brief Get the X coordinate of a SIGNDOC_Point object.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Point object.
 *
 * @return The X coordinate.
 *
 * @memberof SIGNDOC_Point
 */
double SDCAPI
SIGNDOC_Point_getX (const struct SIGNDOC_Point *aObj);

/**
 * @brief Set the X coordinate of a SIGNDOC_Point object.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Point object.
 * @param[in] aX       The X coordinate.
 *
 * @memberof SIGNDOC_Point
 */
void SDCAPI
SIGNDOC_Point_setX (struct SIGNDOC_Point *aObj,
                    double aX);

/**
 * @brief Get the Y coordinate of a SIGNDOC_Point object.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Point object.
 *
 * @return The Y coordinate.
 *
 * @memberof SIGNDOC_Point
 */
double SDCAPI
SIGNDOC_Point_getY (const struct SIGNDOC_Point *aObj);

/**
 * @brief Set the Y coordinate of a SIGNDOC_Point object.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Point object.
 * @param[in] aY       The Y coordinate.
 *
 * @memberof SIGNDOC_Point
 */
void SDCAPI
SIGNDOC_Point_setY (struct SIGNDOC_Point *aObj,
                    double aY);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_Rect constructor.
 *
 * All coordinates will be 0.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 *
 * @return A pointer to the new SIGNDOC_Rect object.
 *
 * @memberof SIGNDOC_Rect
 */
struct SIGNDOC_Rect * SDCAPI
SIGNDOC_Rect_new (struct SIGNDOC_Exception **aEx);

/**
 * @brief SIGNDOC_Rect constructor.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aX1  The first X coordinate.
 * @param[in] aY1  The first Y coordinate.
 * @param[in] aX2  The second X coordinate.
 * @param[in] aY2  The second Y coordinate.
 *
 * @return A pointer to the new SIGNDOC_Rect object.
 *
 * @memberof SIGNDOC_Rect
 */
struct SIGNDOC_Rect * SDCAPI
SIGNDOC_Rect_newXY (struct SIGNDOC_Exception **aEx,
                    double aX1, double aY1, double aX2, double aY2);

/**
 * @brief Clone a SIGNDOC_Rect object.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Rect object.
 *
 * @return A pointer to the new SIGNDOC_Rect object.
 *
 * @memberof SIGNDOC_Rect
 */
struct SIGNDOC_Rect * SDCAPI
SIGNDOC_Rect_clone (struct SIGNDOC_Exception **aEx,
                    const struct SIGNDOC_Rect *aObj);

/**
 * @brief SIGNDOC_Rect destructor.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Rect object.
 *
 * @memberof SIGNDOC_Rect
 */
void SDCAPI
SIGNDOC_Rect_delete (struct SIGNDOC_Rect *aObj);

/**
 * @brief Get the four coordinate of a SIGNDOC_Rect object.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Rect object.
 * @param[out] aX1     A pointer to an object that will receive the first
 *                     X coordinate.
 * @param[out] aY1     A pointer to an object that will receive the first
 *                     Y coordinate.
 * @param[out] aX2     A pointer to an object that will receive the second
 *                     X coordinate.
 * @param[out] aY2     A pointer to an object that will receive the second
 *                     Y coordinate.
 *
 * @memberof SIGNDOC_Rect
 */
void SDCAPI
SIGNDOC_Rect_get (const struct SIGNDOC_Rect *aObj,
                  double *aX1, double *aY1, double *aX2, double *aY2);

/**
 * @brief SIGNDOC_Rect assignment operator.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Rect object.
 * @param[in] aSource  A pointer to the source SIGNDOC_Rect object.
 *
 * @memberof SIGNDOC_Rect
 */
void SDCAPI
SIGNDOC_Rect_assign (struct SIGNDOC_Rect *aObj,
                     const struct SIGNDOC_Rect *aSource);

/**
 * @brief Set the coordinates of a SIGNDOC_Rect object.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Rect object.
 * @param[in] aX1  The first X coordinate.
 * @param[in] aY1  The first Y coordinate.
 * @param[in] aX2  The second X coordinate.
 * @param[in] aY2  The second Y coordinate.
 *
 * @memberof SIGNDOC_Rect
 */
void SDCAPI
SIGNDOC_Rect_setXY (struct SIGNDOC_Rect *aObj,
                    double aX1, double aY1, double aX2, double aY2);

/**
 * @brief Get the first X coordinate of a SIGNDOC_Rect object.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Rect object.
 *
 * @return The first X coordinate.
 *
 * @memberof SIGNDOC_Rect
 */
double SDCAPI
SIGNDOC_Rect_getX1 (const struct SIGNDOC_Rect *aObj);

/**
 * @brief Get the first Y coordinate of a SIGNDOC_Rect object.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Rect object.
 *
 * @return The first Y coordinate.
 *
 * @memberof SIGNDOC_Rect
 */
double SDCAPI
SIGNDOC_Rect_getY1 (const struct SIGNDOC_Rect *aObj);

/**
 * @brief Get the second X coordinate of a SIGNDOC_Rect object.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Rect object.
 *
 * @return The second X coordinate.
 *
 * @memberof SIGNDOC_Rect
 */
double SDCAPI
SIGNDOC_Rect_getX2 (const struct SIGNDOC_Rect *aObj);

/**
 * @brief Get the second Y coordinate of a SIGNDOC_Rect object.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Rect object.
 *
 * @return The second Y coordinate.
 *
 * @memberof SIGNDOC_Rect
 */
double SDCAPI
SIGNDOC_Rect_getY2 (const struct SIGNDOC_Rect *aObj);

/**
 * @brief Get the width of the rectangle.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Rect object.
 *
 * @return The width of the rectangle.
 *
 * @memberof SIGNDOC_Rect
 */
double SDCAPI
SIGNDOC_Rect_getWidth (const struct SIGNDOC_Rect *aObj);

/**
 * @brief Get the height of the rectangle.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Rect object.
 *
 * @return The height of the rectangle.
 *
 * @memberof SIGNDOC_Rect
 */
double SDCAPI
SIGNDOC_Rect_getHeight (const struct SIGNDOC_Rect *aObj);

/**
 * @brief Normalizes the rectangle.
 *
 * Normalizes the rectangle to the one with lower-left and
 * upper-right corners assuming that the origin is in the
 * lower-left corner of the page.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Rect object.
 *
 * @memberof SIGNDOC_Rect
 */
void SDCAPI
SIGNDOC_Rect_normalize (struct SIGNDOC_Rect *aObj);

/**
 * @brief Scale the rectangle.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Rect object.
 * @param[in] aFactor  The factor by which the rectangle is to be scaled.
 *
 * @memberof SIGNDOC_Rect
 */
void SDCAPI
SIGNDOC_Rect_scale (struct SIGNDOC_Rect *aObj,
                    double aFactor);

/**
 * @brief Scale the rectangle.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Rect object.
 * @param[in] aFactorX   The factor by which the rectangle is to be scaled
 *                       horizontally.
 * @param[in] aFactorY   The factor by which the rectangle is to be scaled
 *                       vertically.
 *
 * @memberof SIGNDOC_Rect
 */
void SDCAPI
SIGNDOC_Rect_scaleXY (struct SIGNDOC_Rect *aObj,
                      double aFactorX, double aFactorY);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_Annotation destructor.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Annotation object.
 *
 * @memberof SIGNDOC_Annotation
 *
 * @todo list functions returning a pointer to a SIGNDOC_Annotation object
 */
void SDCAPI
SIGNDOC_Annotation_delete (struct SIGNDOC_Annotation *aObj);

/**
 * @brief Get the type of the annotation.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Annotation object.
 *
 * @return The type of the annotation:
 *         - #SIGNDOC_ANNOTATION_TYPE_UNKNOWN
 *         - #SIGNDOC_ANNOTATION_TYPE_LINE
 *         - #SIGNDOC_ANNOTATION_TYPE_SCRIBBLE
 *         - #SIGNDOC_ANNOTATION_TYPE_FREETEXT
 *         .
 *
 * @memberof SIGNDOC_Annotation
 */
int SDCAPI
SIGNDOC_Annotation_getType (struct SIGNDOC_Exception **aEx,
                            const struct SIGNDOC_Annotation *aObj);

/**
 * @brief Get the name of the annotation.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Annotation object.
 * @param[in]  aEncoding  The encoding to be used for the return value
 *                        (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                        or #SIGNDOC_ENCODING_LATIN_1).
 *
 * @return The name of the annotation or an empty string if the name is
 *         not available. The string must be freed with SIGNDOC_free().
 *
 * @see SIGNDOC_free()
 *
 * @memberof SIGNDOC_Annotation
 */
char * SDCAPI
SIGNDOC_Annotation_getName (struct SIGNDOC_Exception **aEx,
                            const struct SIGNDOC_Annotation *aObj,
                            int aEncoding);

/**
 * @brief Get the page number of the annotation.
 *
 * The page number is available for objects returned by
 * SIGNDOC_Document_getAnnotation() only.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Annotation object.
 *
 * @return the 1-based page number of the annotation or 0 if the page
 *         number is not available.
 *
 * @memberof SIGNDOC_Annotation
 */
int SDCAPI
SIGNDOC_Annotation_getPage (struct SIGNDOC_Exception **aEx,
                            const struct SIGNDOC_Annotation *aObj);

/**
 * @brief Get the bounding box of the annotation.
 *
 * The bounding box is available for objects returned by
 * SIGNDOC_Document_getAnnotation() only.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Annotation object.
 * @param[out] aOutput  The bounding box (using document coordinates, see
 *                      @ref signdocshared_coordinates) will be stored here.
 *
 * @return #SIGNDOC_ANNOTATION_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_Annotation
 */
int SDCAPI
SIGNDOC_Annotation_getBoundingBox (struct SIGNDOC_Exception **aEx,
                                   const struct SIGNDOC_Annotation *aObj,
                                   struct SIGNDOC_Rect *aOutput);

/**
 * @brief Set the name of the annotation.
 *
 * In PDF documents, an annotation can have a name.  The names of
 * annotations must be unique within a page.  By default, annotations
 * are unnamed.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Annotation object.
 * @param[in] aEncoding  The encoding of @a aName
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aName  The name of the annotation.
 *
 * @return #SIGNDOC_ANNOTATION_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_Annotation
 */
int SDCAPI
SIGNDOC_Annotation_setName (struct SIGNDOC_Exception **aEx,
                            struct SIGNDOC_Annotation *aObj,
                            int aEncoding, const char *aName);

/**
 * @brief Set the name of the annotation.
 *
 * In PDF documents, an annotation can have a name.  The names of
 * annotations must be unique within a page.  By default, annotations
 * are unnamed.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Annotation object.
 * @param[in] aName  The name of the annotation.
 *
 * @return #SIGNDOC_ANNOTATION_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_Annotation
 */
int SDCAPI
SIGNDOC_Annotation_setNameW (struct SIGNDOC_Exception **aEx,
                             struct SIGNDOC_Annotation *aObj,
                             const wchar_t *aName);

/**
 * @brief Set line ending styles.
 *
 * This function can be used for annotations of type
 * #SIGNDOC_ANNOTATION_TYPE_LINE.
 * The default line ending style is #SIGNDOC_ANNOTATION_LINEENDING_NONE.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Annotation object.
 * @param[in] aStart  Line ending style for start point
 *                    (#SIGNDOC_ANNOTATION_LINEENDING_NONE or
 *                    #SIGNDOC_ANNOTATION_LINEENDING_ARROW).
 * @param[in] aEnd    Line ending style for end point
 *                    (#SIGNDOC_ANNOTATION_LINEENDING_NONE or
 *                    #SIGNDOC_ANNOTATION_LINEENDING_ARROW).
 *
 * @return #SIGNDOC_ANNOTATION_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_Annotation
 */
int SDCAPI
SIGNDOC_Annotation_setLineEnding (struct SIGNDOC_Exception **aEx,
                                  struct SIGNDOC_Annotation *aObj,
                                  int aStart, int aEnd);

/**
 * @brief Set the foreground color of the annotation.
 *
 * This function can be used for annotations of types
 * #SIGNDOC_ANNOTATION_TYPE_LINE, #SIGNDOC_ANNOTATION_TYPE_SCRIBBLE, and
 * #SIGNDOC_ANNOTATION_TYPE_FREETEXT.
 *
 * The default foreground color is black.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Annotation object.
 * @param[in] aColor  The foreground color of the annotation.
 *
 * @return #SIGNDOC_ANNOTATION_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_Annotation
 */
int SDCAPI
SIGNDOC_Annotation_setColor (struct SIGNDOC_Exception **aEx,
                             struct SIGNDOC_Annotation *aObj,
                             const struct SIGNDOC_Color *aColor);

/**
 * @brief Set the background color of the annotation.
 *
 * This function can be used for annotations of type
 * #SIGNDOC_ANNOTATION_TYPE_FREETEXT.
 *
 * The default background color is white.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Annotation object.
 * @param[in] aColor  The background color of the annotation.
 *
 * @return #SIGNDOC_ANNOTATION_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_Annotation
 */
int SDCAPI
SIGNDOC_Annotation_setBackgroundColor (struct SIGNDOC_Exception **aEx,
                                       struct SIGNDOC_Annotation *aObj,
                                       const struct SIGNDOC_Color *aColor);

/**
 * @brief Set the border color of the annotation.
 *
 * This function can be used for annotations of type
 * #SIGNDOC_ANNOTATION_TYPE_FREETEXT.
 *
 * The default border color is black.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Annotation object.
 * @param[in] aColor  The border color of the annotation.
 *
 * @return #SIGNDOC_ANNOTATION_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Annotation_setBorderLineWidthInPoints()
 *
 * @memberof SIGNDOC_Annotation
 */
int SDCAPI
SIGNDOC_Annotation_setBorderColor (struct SIGNDOC_Exception **aEx,
                                   struct SIGNDOC_Annotation *aObj,
                                   const struct SIGNDOC_Color *aColor);

/**
 * @brief Set the opacity of the annotation.
 *
 * This function can be used for annotations of types
 * #SIGNDOC_ANNOTATION_TYPE_LINE, #SIGNDOC_ANNOTATION_TYPE_SCRIBBLE, and
 * #SIGNDOC_ANNOTATION_TYPE_FREETEXT.
 *
 * The default opacity is 1.0. Documents conforming to PDF/A must
 * use an opacity of 1.0.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Annotation object.
 * @param[in] aOpacity  The opacity, 0.0 (transparent) through 1.0 (opaque).
 *
 * @return #SIGNDOC_ANNOTATION_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_Annotation
 */
int SDCAPI
SIGNDOC_Annotation_setOpacity (struct SIGNDOC_Exception **aEx,
                               struct SIGNDOC_Annotation *aObj,
                               double aOpacity);

/**
 * @brief Set line width in points.
 *
 * This function can be used for annotations of types
 * #SIGNDOC_ANNOTATION_TYPE_LINE and #SIGNDOC_ANNOTATION_TYPE_SCRIBBLE.
 * The default line width for PDF documents is 1 point.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Annotation object.
 * @param[in] aWidth   The line width in points (1/72 inch).
 *
 * @return #SIGNDOC_ANNOTATION_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_Annotation
 */
int SDCAPI
SIGNDOC_Annotation_setLineWidthInPoints (struct SIGNDOC_Exception **aEx,
                                         struct SIGNDOC_Annotation *aObj,
                                         double aWidth);

/**
 * @brief Set border line width in points.
 *
 * This function can be used for annotations of type
 * #SIGNDOC_ANNOTATION_TYPE_FREETEXT.
 * The default border line width for PDF documents is 1 point.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Annotation object.
 * @param[in] aWidth  The border line width in points (1/72 inch).  If this
 *                    value is negative, no border lines will be drawn.
 *
 * @return #SIGNDOC_ANNOTATION_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Annotation_setBorderColor()
 *
 * @memberof SIGNDOC_Annotation
 */
int SDCAPI
SIGNDOC_Annotation_setBorderLineWidthInPoints (struct SIGNDOC_Exception **aEx,
                                               struct SIGNDOC_Annotation *aObj,
                                               double aWidth);

/**
 * @brief Start a new stroke in a scribble annotation.
 *
 * This function can be used for annotations of type
 * #SIGNDOC_ANNOTATION_TYPE_SCRIBBLE.
 * Each stroke must contain at least two points.  This function need
 * not be called for the first stroke of a scribble annotation.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Annotation object.
 *
 * @return #SIGNDOC_ANNOTATION_RETURNCODE_OK if successful.
 *
 * @see SGINDOC_Annotation_addPoint()
 *
 * @memberof SIGNDOC_Annotation
 */
int SDCAPI
SIGNDOC_Annotation_newStroke (struct SIGNDOC_Exception **aEx,
                              struct SIGNDOC_Annotation *aObj);

/**
 * @brief Add a point to the current stroke of a scribble annotation.
 *
 * This function can be used for annotations of type
 * #SIGNDOC_ANNOTATION_TYPE_SCRIBBLE.
 * Each stroke must contain at least two points.
 * This function uses document (page) coordinates,
 * see @ref signdocshared_coordinates.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Annotation object.
 * @param[in] aPoint  The point to be added.
 *
 * @return #SIGNDOC_ANNOTATION_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Annotation_newStroke()
 *
 * @memberof SIGNDOC_Annotation
 */
int SDCAPI
SIGNDOC_Annotation_addPoint (struct SIGNDOC_Exception **aEx,
                             struct SIGNDOC_Annotation *aObj,
                             const struct SIGNDOC_Point *aPoint);

/**
 * @brief Add a point to the current stroke of a scribble annotation.
 *
 * This function can be used for annotations of type
 * #SIGNDOC_ANNOTATION_TYPE_SCRIBBLE.
 * Each stroke must contain at least two points.
 * This function uses document (page) coordinates,
 * see @ref signdocshared_coordinates.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Annotation object.
 * @param[in] aX  The X coordinate of the point.
 * @param[in] aY  The Y coordinate of the point.
 *
 * @return #SIGNDOC_ANNOTATION_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Annotation_newStroke()
 *
 * @memberof SIGNDOC_Annotation
 */
int SDCAPI
SIGNDOC_Annotation_addPointXY (struct SIGNDOC_Exception **aEx,
                               struct SIGNDOC_Annotation *aObj,
                               double aX, double aY);

/**
 * @brief Set the text of a text annotation.
 *
 * This function can be used for annotations of type
 * #SIGNDOC_ANNOTATION_TYPE_FREETEXT.
 *
 * Any sequence of CR and LF characters in the text starts a new
 * paragraph (ie, text following such a sequence will be placed at
 * the beginning of the next output line). In consequence, empty
 * lines in the input do not produce empty lines in the output. To
 * get an empty line in the output, you have to add a paragraph
 * containing a non-breaking space (0xa0) only:
 * @code
 * "Line before empty line\n\xa0\nLine after empty line"
 * @endcode
 *
 * @note This function does not yet support complex scripts.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Annotation object.
 * @param[in] aEncoding    The encoding of @a aText and @a aFont
 *                         (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                         or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aText        The text.  Allowed control characters are
 *                         CR and LF. Any sequence of CR and LF characters
 *                         starts a new paragraph.
 * @param[in] aFont        The name of the font to be used.  The font
 *                         substitition rules of the loaded font
 *                         configuration files will be used. The resulting
 *                         font must be a standard PDF font or a font
 *                         for which a file is specified in the font
 *                         configuration files.
 * @param[in] aFontSize    The font size in user space units.
 * @param[in] aHAlignment  Horizontal alignment of the text
 *                         (#SIGNDOC_ANNOTATION_HALIGNMENT_LEFT,
 *                         #SIGNDOC_ANNOTATION_HALIGNMENT_CENTER, or
 *                         #SIGNDOC_ANNOTATION_HALIGNMENT_RIGHT).
 *
 * @see SIGNDOC_Annotation_getFont(), SIGNDOC_Annotation_getPlainText(), SIGNDOC_DocumentLoader_loadFontConfigFile(), SIGNDOC_DocumentLoader_loadFontConfigEnvironment(), SIGNDOC_DocumentLoader_loadFontConfigStream()
 *
 * @memberof SIGNDOC_Annotation
 */
int SDCAPI
SIGNDOC_Annotation_setPlainText (struct SIGNDOC_Exception **aEx,
                                 struct SIGNDOC_Annotation *aObj,
                                 int aEncoding, const char *aText,
                                 const char *aFont, double aFontSize,
                                 int aHAlignment);

/**
 * @brief Get the text of a text annotation.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Annotation object.
 * @param[in] aEncoding    The encoding to be used for the text returned
 *                         in @a aText
 *                         (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                         or #SIGNDOC_ENCODING_LATIN_1).
 * @param[out] aText       A pointer to the text will be stored here.
 *                         The start of
 *                         a new paragraph (except for the first one)
 *                         is represented by CR and/or LF characters.
 *                         The string must be freed with SIGNDOC_free().
 *
 * @return #SIGNDOC_ANNOTATION_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Annotation_getFont(), SIGNDOC_Annotation_setPlainText(), SIGNDOC_free()
 *
 * @memberof SIGNDOC_Annotation
 *
 * @todo embedded NUL
 */
int SDCAPI
SIGNDOC_Annotation_getPlainText (struct SIGNDOC_Exception **aEx,
                                 struct SIGNDOC_Annotation *aObj,
                                 int aEncoding, char **aText);

/**
 * @brief Get the font of a text annotation.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Annotation object.
 * @param[in] aEncoding    The encoding to be used for the font name returned
 *                         in @a aFont
 *                         (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                         or #SIGNDOC_ENCODING_LATIN_1).
 *
 * @param[out] aFont       A pointer to the font name will be stored here.
 *                         The string must be freed with SIGNDOC_free().
 * @param[out] aFontSize   The font size in user space units will be stored
 *                         here.
 *
 * @return #SIGNDOC_ANNOTATION_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Annotation_getPlainText(), SIGNDOC_Annotation_setPlainText(), SIGNDOC_free
 *
 * @memberof SIGNDOC_Annotation
 *
 * @todo define behavior if there are multiple fonts
 */
int SDCAPI
SIGNDOC_Annotation_getFont (struct SIGNDOC_Exception **aEx,
                            struct SIGNDOC_Annotation *aObj,
                            int aEncoding, char **aFont, double *aFontSize);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_Attachment constructor.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 *
 * @return A pointer to the new SIGNDOC_Attachment object.
 *
 * @memberof SIGNDOC_Attachment
 */
struct SIGNDOC_Attachment * SDCAPI
SIGNDOC_Attachment_new (struct SIGNDOC_Exception **aEx);

/**
 * @brief Clone a SIGNDOC_Attachment object.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aSource  A pointer to the SIGNDOC_Attachment object.
 *
 * @return A pointer to the new SIGNDOC_Attachment object.
 *
 * @memberof SIGNDOC_Attachment
 */
struct SIGNDOC_Attachment * SDCAPI
SIGNDOC_Attachment_clone (struct SIGNDOC_Exception **aEx,
                          const struct SIGNDOC_Attachment *aSource);

/**
 * @brief SIGNDOC_Attachment destructor.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Attachment object.
 *
 * @memberof SIGNDOC_Attachment
 */
void SDCAPI
SIGNDOC_Attachment_delete (struct SIGNDOC_Attachment *aObj);

/**
 * @brief SIGNDOC_Attachment assignment operator
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Attachment object.
 * @param[in] aSource  A pointer to the source SIGNDOC_Attachment object.
 *
 * @memberof SIGNDOC_Attachment
 */
void SDCAPI
SIGNDOC_Attachment_assign (struct SIGNDOC_Exception **aEx,
                           struct SIGNDOC_Attachment *aObj,
                        const struct SIGNDOC_Attachment *aSource);

/**
 * @brief Get the name of the attachment.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the name cannot be
 * represented using the specified encoding.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Attachment object.
 * @param[in] aEncoding  The encoding to be used for the return value.
 *                        (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                        or #SIGNDOC_ENCODING_LATIN_1).
 *
 * @return The name of the attachment.
 *         The string must be freed with SIGNDOC_free().
 *
 * @see SIGNDOC_Attachment_getNameUTF8()
 *
 * @memberof SIGNDOC_Attachment
 */
char * SDCAPI
SIGNDOC_Attachment_getName (struct SIGNDOC_Exception **aEx,
                            const struct SIGNDOC_Attachment *aObj,
                            int aEncoding);

/**
 * @brief Get the name of the attachment as UTF-8-encoded C string.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Attachment object.
 *
 * @return The name of the attachment.  This pointer will become invalid
 *         when @a aObj is destroyed.
 *
 * @see SIGNDOC_Attachment_getName()
 *
 * @memberof SIGNDOC_Attachment
 */
const char * SDCAPI
SIGNDOC_Attachment_getNameUTF8 (struct SIGNDOC_Exception **aEx,
                                const struct SIGNDOC_Attachment *aObj);

/**
 * @brief Get the file name of the attachment.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the file name cannot be
 * represented using the specified encoding.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Attachment object.
 * @param[in] aEncoding  The encoding to be used for the return value
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 *
 * @return The file name of the attachment.
 *         The string must be freed with SIGNDOC_free().
 *
 * @see SIGNDOC_Attachment_getFileNameUTF8()
 *
 * @memberof SIGNDOC_Attachment
 */
char * SDCAPI
SIGNDOC_Attachment_getFileName (struct SIGNDOC_Exception **aEx,
                                const struct SIGNDOC_Attachment *aObj,
                                int aEncoding);

/**
 * @brief Get the file name of the attachment as UTF-8-encoded C string.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Attachment object.
 *
 * @return The file name of the attachment.  This pointer will become invalid
 *         when @a aObj is destroyed.
 *
 * @see SIGNDOC_Attachment_getFileName()
 *
 * @memberof SIGNDOC_Attachment
 */
const char * SDCAPI
SIGNDOC_Attachment_getFileNameUTF8 (struct SIGNDOC_Exception **aEx,
                                    const struct SIGNDOC_Attachment *aObj);

/**
 * @brief Get the description of the attachment.
 *
 * The returned string will be empty if the description is missing.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the description cannot be
 * represented using the specified encoding.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Attachment object.
 * @param[in] aEncoding  The encoding to be used for the return value
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 *
 * @return The description of the attachment.
 *         The string must be freed with SIGNDOC_free().
 *
 * @see SIGNDOC_Attachment_getDescriptionUTF8()
 *
 * @memberof SIGNDOC_Attachment
 */
char * SDCAPI
SIGNDOC_Attachment_getDescription (struct SIGNDOC_Exception **aEx,
                                   const struct SIGNDOC_Attachment *aObj,
                                   int aEncoding);

/**
 * @brief Get the description of the attachment as UTF-8-encoded C string.
 *
 * The returned string will be empty if the description is missing.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Attachment object.
 *
 * @return The description of the attachment.  This pointer will become invalid
 *         when @a aObj is destroyed.
 *
 * @see SIGNDOC_Attachment_getDescription()
 *
 * @memberof SIGNDOC_Attachment
 */
const char * SDCAPI
SIGNDOC_Attachment_getDescriptionUTF8 (struct SIGNDOC_Exception **aEx,
                                       const struct SIGNDOC_Attachment *aObj);

/**
 * @brief Get the size (in octets) of the attachment.
 *
 * The return value is -1 if the size of the attachment is not readily
 * available.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Attachment object.
 *
 * @return The size (in octets) of the attachment or -1.
 *
 * @see SIGNDOC_Attachment_getCompressedSize()
 *
 * @memberof SIGNDOC_Attachment
 */
int SDCAPI
SIGNDOC_Attachment_getSize (struct SIGNDOC_Exception **aEx,
                            const struct SIGNDOC_Attachment *aObj);

/**
 * @brief Get the compressed size (in octets) of the attachment.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Attachment object.
 *
 * @return The compressed size (in octets) of the attachment.
 *
 * @see SIGNDOC_Attachment_getSize()
 *
 * @memberof SIGNDOC_Attachment
 */
int SDCAPI
SIGNDOC_Attachment_getCompressedSize (struct SIGNDOC_Exception **aEx,
                                      const struct SIGNDOC_Attachment *aObj);

/**
 * @brief Get the MIME type of the attachment.
 *
 * The return string will be empty if the MIME type is missing.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Attachment object.
 *
 * @return The MIME type of the attachment.  This pointer will become invalid
 *         when @a aObj is destroyed.
 *
 * @memberof SIGNDOC_Attachment
 */
const char * SDCAPI
SIGNDOC_Attachment_getType (struct SIGNDOC_Exception **aEx,
                            const struct SIGNDOC_Attachment *aObj);

/**
 * @brief Get the creation time and date of the attachment.
 *
 * The returned string will be empty if the creation time and date
 * are missing.
 *
 * ISO 8601 format is used: yyyy-mm-ddThh:mm:ss, optionally followed by
 * a timezone: Z, +hh:mm, or -hh:mm.
 *
 * The PDF reference is ambiguous; apparently, the creation time is
 * supposed to be the time and date at which the attachment was the
 * PDF document. Changing the description does not update the
 * modification date/time.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Attachment object.
 *
 * @return The creation time and date of the attachment.
 *         This pointer will become invalid when @a aObj is destroyed.
 *
 * @see SIGNDOC_Attachment_getModificationTime()
 *
 * @memberof SIGNDOC_Attachment
 */
const char * SDCAPI
SIGNDOC_Attachment_getCreationTime (struct SIGNDOC_Exception **aEx,
                                    const struct SIGNDOC_Attachment *aObj);

/**
 * @brief Get the time and date of the last modification of the
 *        attachment.
 *
 * Setting the time and date of the last modification of the attachment is
 * optional.
 * The returned string will be empty if the modification time and date
 * are missing.
 *
 * ISO 8601 format is used: yyyy-mm-ddThh:mm:ss, optionally followed by
 * a timezone: Z, +hh:mm, or -hh:mm.
 *
 * The PDF reference is ambiguous; apparently, the modification time
 * is supposed to be the time and date of the last modification of
 * the file at the time it was attached. Changing the description
 * does not update the modification date/time.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Attachment object.
 *
 * @return The time and date of the last modification of the attachment.
 *         This pointer will become invalid when @a aObj is destroyed.
 *
 * @memberof SIGNDOC_Attachment
 */
const char * SDCAPI
SIGNDOC_Attachment_getModificationTime (struct SIGNDOC_Exception **aEx,
                                        const struct SIGNDOC_Attachment *aObj);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_CharacterPosition constructor.
 *
 * The page number and all coordinates will be 0.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 *
 * @return A pointer to the new SIGNDOC_CharacterPosition object.
 *
 * @memberof SIGNDOC_CharacterPosition
 */
struct SIGNDOC_CharacterPosition * SDCAPI
SIGNDOC_CharacterPosition_new (struct SIGNDOC_Exception **aEx);

/**
 * @brief SIGNDOC_CharacterPosition destructor.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_CharacterPosition object,
 *                     must have been returned by
 *                     SIGNDOC_CharacterPosition_new().
 *
 * @memberof SIGNDOC_CharacterPosition
 */
void SDCAPI
SIGNDOC_CharacterPosition_delete (struct SIGNDOC_CharacterPosition *aObj);

/**
 * @brief Get the page number of a SIGNDOC_CharacterPosition object.
 *
 * @deprecated Please use mPage directly.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_CharacterPosition object.
 *
 * @return The 1-based page number.
 *
 * @memberof SIGNDOC_CharacterPosition
 */
int SDCAPI
SIGNDOC_CharacterPosition_getPage (const struct SIGNDOC_CharacterPosition *aObj);

/**
 * @brief Set the page number of a SIGNDOC_CharacterPosition object.
 *
 * @deprecated Please use mPage directly.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_CharacterPosition object.
 * @param[in] aPage   The 1-based page number.
 *
 * @memberof SIGNDOC_CharacterPosition
 */
void SDCAPI
SIGNDOC_CharacterPosition_setPage (struct SIGNDOC_CharacterPosition *aObj,
                                   int aPage);

/**
 * @brief Get the reference point of a SIGNDOC_CharacterPosition object.
 *
 * @deprecated Please use mRef directly.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_CharacterPosition object.
 *
 * @return A pointer to the mRef member of the objct pointed to by
 *         @a aObj. The SIGNDOC_Point object is not cloned.
 *
 * @memberof SIGNDOC_CharacterPosition
 */
struct SIGNDOC_Point * SDCAPI
SIGNDOC_CharacterPosition_getRef (struct SIGNDOC_CharacterPosition *aObj);

/**
 * @brief Set the reference point of a SIGNDOC_CharacterPosition object.
 *
 * @deprecated Please use mRef directly.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_CharacterPosition object.
 * @param[in] aRef     A pointer to the reference point. The coordinates
 *                     stored in that object will be copied.
 *
 * @memberof SIGNDOC_CharacterPosition
 */
void SDCAPI
SIGNDOC_CharacterPosition_setRef (struct SIGNDOC_CharacterPosition *aObj,
                                  const struct SIGNDOC_Point *aRef);

/**
 * @brief Get the bounding box of a SIGNDOC_CharacterPosition object.
 *
 * @deprecated Please use mBox directly.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_CharacterPosition object.
 *
 * @return A pointer to the mBox member of the objct pointed to by
 *         @a aObj. The SIGNDOC_Rect object is not cloned.
 *
 * @memberof SIGNDOC_CharacterPosition
 */
struct SIGNDOC_Rect * SDCAPI
SIGNDOC_CharacterPosition_getBox (struct SIGNDOC_CharacterPosition *aObj);

/**
 * @brief Set the bounding box of a SIGNDOC_CharacterPosition object.
 *
 * @deprecated Please use mBox directly.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_CharacterPosition object.
 * @param[in] aBox     A pointer to the boundig box. The coordinates
 *                     stored in that object will be copied.
 *
 * @memberof SIGNDOC_CharacterPosition
 */
void SDCAPI
SIGNDOC_CharacterPosition_setBox (struct SIGNDOC_CharacterPosition *aObj,
                                  const struct SIGNDOC_Rect *aBox);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_Document destructor.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 *
 * @see SIGNDOC_Document_getSPPDFDocument()
 *
 * @memberof SIGNDOC_Document
 */
void SDCAPI
SIGNDOC_Document_delete (struct SIGNDOC_Document *aObj);

/**
 * @brief Get the type of the document.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 *
 * @return The document type: #SIGNDOC_DOCUMENT_DOCUMENTTYPE_PDF
 *         or #SIGNDOC_DOCUMENT_DOCUMENTTYPE_TIFF.
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getType (struct SIGNDOC_Exception **aEx,
                          const struct SIGNDOC_Document *aObj);

/**
 * @brief Get the number of pages.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 *
 * @return The number of pages.
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getPageCount (struct SIGNDOC_Exception **aEx,
                               const struct SIGNDOC_Document *aObj);

/**
 * @brief Create a SIGNDOC_SignatureParameters object for signing a
 *        signature field.
 *
 * The caller is responsible for destroying the object.
 *
 * Any SIGNDOC_SignatureParameters object should be used for at most
 * one signature.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in] aEncoding  The encoding of @a aFieldName
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aFieldName   The name of the signature field, encoded according
 *                         to @a aEncoding.
 * @param[in] aProfile     The profile name (ASCII). Some document types and
 *                         signature fields support different sets of default
 *                         parameters. For instance, DigSig fields of
 *                         PDF documents have a "FinanzIT" profile. The
 *                         default profile, "", is supported for all
 *                         signature fields.
 * @param[out] aOutput     A pointer to the new parameters object will be
 *                         stored here. The caller is responsible for
 *                         destroying the object.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_addSignature(), SIGNDOC_Document_createSignatureParametersW(), SIGNDOC_Document_getProfiles()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_createSignatureParameters (struct SIGNDOC_Exception **aEx,
                                            struct SIGNDOC_Document *aObj,
                                            int aEncoding,
                                            const char *aFieldName,
                                            const char *aProfile,
                                            struct SIGNDOC_SignatureParameters **aOutput);

/**
 * @brief Create a SIGNDOC_SignatureParameters object for signing a
 *        signature field.
 *
 * The caller is responsible for destroying the object.
 *
 * Any SIGNDOC_SignatureParameters object should be used for at most
 * one signature.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in] aFieldName   The name of the signature field, encoded according
 *                         to @a aEncoding.
 * @param[in] aProfile     The profile name (ASCII). Some document types and
 *                         signature fields support different sets of default
 *                         parameters. For instance, DigSig fields of
 *                         PDF documents have a "FinanzIT" profile. The
 *                         default profile, "", is supported for all
 *                         signature fields.
 * @param[out] aOutput     A pointer to the new parameters object will be
 *                         stored here. The caller is responsible for
 *                         destroying the object.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_addSignature(), SIGNDOC_Document_createSignatureParameters(), SIGNDOC_Document_getProfiles()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_createSignatureParametersW (struct SIGNDOC_Exception **aEx,
                                             struct SIGNDOC_Document *aObj,
                                             const wchar_t *aFieldName,
                                             const wchar_t *aProfile,
                                             struct SIGNDOC_SignatureParameters **aOutput);

/**
 * @brief Get a list of profiles for a signature field.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding    The encoding of @a aFieldName
 *                          (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                          or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aFieldName   The name of the signature field encoded according
 *                          to @a aEncoding.
 * @param[out] aOutput      The names (ASCII) of all profiles supported by
 *                          the signature field will be stored here,
 *                          excluding the default profile "" which is
 *                          always available.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_createSignatureParameters(), SIGNDOC_Document_createSignatureParametersW()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getProfiles (struct SIGNDOC_Exception **aEx,
                              struct SIGNDOC_Document *aObj,
                              int aEncoding, const char *aFieldName,
                              struct SIGNDOC_StringArray *aOutput);

/**
 * @brief Sign the document.
 *
 * This function stores changed properties in the document before
 * signing.  If string parameter "OutputPath" is set, the signed
 * document will be stored in a new file specified by that parameter
 * and the original file won't be modified. If "OutputPath" is not
 * set, the document will be written to the file from which it was
 * loaded or to which it was most recently saved.
 *
 * If the PDF document is backed by memory (most recently loaded
 * from memory or saved to a stream) and "OutputPath" is empty,
 * the signed document will not be saved. Use
 * @code
 * SIGNDOC_Document_copyToStream (&ex, doc, stream, 0);
 * @endcode
 * to save the signed document in that case.
 *
 * If string parameter "OutputPath" is set to the special value
 * "<memory>" for a PDF document, it will be saved to memory and
 * signed in memory. You'll have to save the document as described
 * in the preceding paragraph.
 *
 * Some document types may allow adding signatures only if all signatures
 * of the documents are valid.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in] aParameters    The signing parameters.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_copyToStream(), SIGNDOC_Document_createSignatureParameters(), SIGNDOC_Document_createSignatureParametersW(), SIGNDOC_Document_getPathname(), SIGNDOC_Document_setStringProperty()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_addSignature (struct SIGNDOC_Exception **aEx,
                               struct SIGNDOC_Document *aObj,
                               const struct SIGNDOC_SignatureParameters *aParameters);

/**
 * @brief Get the timestamp used by the last successful call of
 *        SIGNDOC_Document_addSignature().
 *
 * This function may return a timestamp even if the last call of
 * SIGNDOC_Document_addSignature() was not successful.
 * See also string parameters
 * "Timestamp" and "TimeStampServerURL" of SIGNDOC_SignatureParameters.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[out] aTime  The timestamp in ISO 8601 format (yyyy-mm-ddThh:mm:ss
 *                    without milliseconds, with optional timezone
 *                    (or an empty string if there is no timestamp available)
 *                    will be stored here.
 *                    The string must be freed with SIGNDOC_free().
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_addSignature(), SIGNDOC_Document_getSignatureString(), SIGNDOC_SignatureParameters_setString()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getLastTimestamp (struct SIGNDOC_Exception **aEx,
                                   struct SIGNDOC_Document *aObj,
                                   char **aTime);

/**
 * @brief Get the current pathname of the document.
 *
 * The pathname will be empty if the document is stored in memory
 * (ie, if it has been loaded from memory or saved to a stream).
 *
 * If a FDF document has been opened, this function will return
 * the pathname of the referenced PDF file.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding  The encoding to be used for @a aPath
 *                        (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                        or #SIGNDOC_ENCODING_LATIN_1).
 * @param[out] aPath  The pathname will be stored here.
 *                    The string must be freed with SIGNDOC_free().
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getPathname (struct SIGNDOC_Exception **aEx,
                              struct SIGNDOC_Document *aObj,
                              int aEncoding, char **aPath);

/**
 * @brief Get a bitset indicating which signing methods are available
 *        for this document.
 *
 * This document's signature fields offer a subset of the signing methods
 * returned by this function.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 *
 * @return 1&lt;&lt;#SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS1 etc.
 *
 * @see SIGNDOC_SignatureParameters_getAvailableMethods()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getAvailableMethods (struct SIGNDOC_Exception **aEx,
                                      struct SIGNDOC_Document *aObj);

/**
 * @brief Verify a signature of the document.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding   The encoding of @a aFieldName
 *                         (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                         or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aFieldName  The name of the signature field encoded according
 *                         to @a aEncoding.
 * @param[out] aOutput     A pointer to a new SignDocVerificationResult
 *                         object or NULL will be stored here. The caller
 *                         is responsible for destroying that object.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_verifySignatureW(), SIGNDOC_Field_isSigned()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_verifySignature (struct SIGNDOC_Exception **aEx,
                                  struct SIGNDOC_Document *aObj,
                                  int aEncoding, const char *aFieldName,
                                  struct SIGNDOC_VerificationResult **aOutput);
/**
 * @brief Verify a signature of the document.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aFieldName  The name of the signature field.
 * @param[out] aOutput     A pointer to a new SignDocVerificationResult
 *                         object or NULL will be stored here. The caller
 *                         is responsible for destroying that object.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_verifySignature(), SIGNDOC_Field_isSigned()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_verifySignatureW (struct SIGNDOC_Exception **aEx,
                                   struct SIGNDOC_Document *aObj,
                                   const wchar_t *aFieldName,
                                   struct SIGNDOC_VerificationResult **aOutput);

/**
 * @brief Remove a signature of the document.
 *
 * For some document formats (TIFF), signatures may only be cleared in
 * the reverse order of signing (LIFO).
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding   The encoding of @a aFieldName
 *                         (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                         or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aFieldName  The name of the signature field encoded according
 *                         to @a aEncoding.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_clearAllSignatures(), SIGNDOC_Document_getFields(), SIGNDOC_Field_isCurrentlyClearable()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_clearSignature (struct SIGNDOC_Exception **aEx,
                                 struct SIGNDOC_Document *aObj,
                                 int aEncoding, const char *aFieldName);

/**
 * @brief Remove all signature of the document.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_clearSignature()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_clearAllSignatures (struct SIGNDOC_Exception **aEx,
                                     struct SIGNDOC_Document *aObj);

/**
 * @brief Save the document to a stream.
 *
 * This function may have side effects on the document such as
 * marking it as not modified which may render #SIGNDOC_DOCUMENT_SAVEFLAGS_INCREMENTAL
 * useless for the next SIGNDOC_Document_saveToFile() call unless
 * the document is
 * changed between those two calls.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aStream  The document will be saved to this stream.
 * @param[in]  aFlags   Set of flags modifying the behavior of this function
 *                      (#SIGNDOC_DOCUMENT_SAVEFLAGS_REMOVE_UNUSED,
 *                      #SIGNDOC_DOCUMENT_SAVEFLAGS_LINEARIZED,
 *                      #SIGNDOC_DOCUMENT_SAVEFLAGS_PDF_1_4,
 *                      #SIGNDOC_DOCUMENT_SAVEFLAGS_PDFA_BUTTONS,
 *                      combined with `|'.)
 *                      Pass 0 for no flags.
 *                      Which flags are available depends on the document
 *                      type.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_copyToStream(), SIGNDOC_Document_getSaveToStreamFlags(), SIGNDOC_Document_saveToFile(), SIGNDOC_DocumentLoader_loadFromFile(), SIGNDOC_DocumentLoader_loadFromMemory()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_saveToStream (struct SIGNDOC_Exception **aEx,
                               struct SIGNDOC_Document *aObj,
                               struct SIGNDOC_OutputStream *aStream, int aFlags);

/**
 * @brief Save the document to a file.
 *
 * After a successful call to this function, the document behaves as
 * if it had been loaded from the specified file.
 *
 * Saving a signed PDF document without #SIGNDOC_DOCUMENT_SAVEFLAGS_INCREMENTAL will fail,
 * see SIGNDOC_Document_getRequiredSaveToFileFlags().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in] aEncoding  The encoding of the string pointed to by @a aPath
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aPath  The pathname of the file to be created or overwritten.
 *                    Pass NULL to save to the file from which the document
 *                    was loaded or most recently saved (which will
 *                    fail if the documment was loaded from memory
 *                    or saved to a stream).
 *                    See @ref winrt_store for restrictions on pathnames
 *                    in Windows Store apps.
 * @param[in]  aFlags   Set of flags modifying the behavior of this function
 *                      (#SIGNDOC_DOCUMENT_SAVEFLAGS_INCREMENTAL,
 *                      #SIGNDOC_DOCUMENT_SAVEFLAGS_REMOVE_UNUSED,
 *                      #SIGNDOC_DOCUMENT_SAVEFLAGS_LINEARIZED,
 *                      #SIGNDOC_DOCUMENT_SAVEFLAGS_PDF_1_4,
 *                      #SIGNDOC_DOCUMENT_SAVEFLAGS_PDFA_BUTTONS,
 *                      combined with `|'.)
 *                      Which flags are available depends on the document
 *                      type.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_copyToStream(), SIGNDOC_Document_getRequiredSaveToFileFlags(), SIGNDOC_Document_getSaveToFileFlags(), SIGNDOC_Document_saveToStream(), SIGNDOC_DocumentLoader_loadFromFile(), SIGNDOC_DocumentLoader_loadFromMemory()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_saveToFile (struct SIGNDOC_Exception **aEx,
                             struct SIGNDOC_Document *aObj,
                             int aEncoding, const char *aPath, int aFlags);

/**
 * @brief Save the document to a file.
 *
 * After a successful call to this function, the document behaves as
 * if it had been loaded from the specified file.
 *
 * Saving a signed PDF document without
 * #SIGNDOC_DOCUMENT_SAVEFLAGS_INCREMENTAL will fail,
 * see SIGNDOC_Document_getRequiredSaveToFileFlags().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aPath  The pathname of the file to be created or overwritten.
 *                    Pass NULL to save to the file from which the document
 *                    was loaded or most recently saved (which will
 *                    fail if the documment was loaded from memory
 *                    or saved to a stream).
 * @param[in]  aFlags   Set of flags modifying the behavior of this function
 *                      (#SIGNDOC_DOCUMENT_SAVEFLAGS_INCREMENTAL,
 *                      #SIGNDOC_DOCUMENT_SAVEFLAGS_REMOVE_UNUSED,
 *                      #SIGNDOC_DOCUMENT_SAVEFLAGS_LINEARIZED,
 *                      #SIGNDOC_DOCUMENT_SAVEFLAGS_PDF_1_4,
 *                      #SIGNDOC_DOCUMENT_SAVEFLAGS_PDFA_BUTTONS,
 *                      combined with `|'.)
 *                      Pass 0 for no flags.
 *                      Which flags are available depends on the document
 *                      type.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_copyToStream(), SIGNDOC_Document_getSaveToFileFlags(), SIGNDOC_Document_saveToStream(), SIGNDOC_DocumentLoader_loadFromFile(), SIGNDOC_DocumentLoader_loadFromMemory()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_saveToFileW (struct SIGNDOC_Exception **aEx,
                              struct SIGNDOC_Document *aObj,
                              const wchar_t *aPath, int aFlags);

/**
 * @brief Copy the document's current status or backing file or backing blob
 *        to a stream.
 *
 * If #SIGNDOC_DOCUMENT_COPYTOSTREAMFLAGS_UNSAVED is not set in @a aFlags,
 * this function will copy to a stream the
 * file or blob from which the document was loaded or to which the
 * document was most recently saved. Changes made to the in-memory
 * copy of the document since it was loaded or saved will not be
 * reflected in the copy written to the stream.
 *
 * If #SIGNDOC_DOCUMENT_COPYTOSTREAMFLAGS_UNSAVED is set in @a aFlags,
 * unsaved changes made to the in-memory
 * copy of the document will be included (as incremental update for
 * PDF documents) in the stream.
 *
 * This function does not have side effects on the in-memory copy of
 * the document, that is, unsaved changes remain unsaved (except for
 * being saved to the stream if #SIGNDOC_DOCUMENT_COPYTOSTREAMFLAGS_UNSAVED
 * is set in @a aFlags).
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in] aStream  The file will be copied to this stream.
 * @param[in] aFlags   Flags modifying the behavior of this function,
 *                     see #SIGNDOC_DOCUMENT_COPYTOSTREAMFLAGS_UNSAVED.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_copyAsSignedToStream(), SIGNDOC_Document_saveToFile(), SIGNDOC_Document_saveToStream(), SIGNDOC_DocumentLoader_loadFromFile(), SIGNDOC_DocumentLoader_loadFromMemory()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_copyToStream (struct SIGNDOC_Exception **aEx,
                               struct SIGNDOC_Document *aObj,
                               struct SIGNDOC_OutputStream *aStream,
                               unsigned aFlags);

/**
 * @brief Copy the document to a stream for viewing the document "as signed".
 *
 * This function copies to a stream the document as it was when the specified
 * signature field was signed.  If the specified signature field contains
 * the last signature applied to the document, this function is equivalent
 * to SIGNDOC_Document_copyToStream(). However, for some document formats,
 * this function
 * may require signatures to be valid.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding    The encoding of @a aFieldName
 *                          (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                          or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aFieldName   The name of the signature field encoded according
 *                          to @a aEncoding.
 * @param[in]  aStream      The file will be copied to this stream.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_copyToStream(), SIGNDOC_DocumentLoader_loadFromMemory()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_copyAsSignedToStream (struct SIGNDOC_Exception **aEx,
                                       struct SIGNDOC_Document *aObj,
                                       int aEncoding, const char *aFieldName,
                                       struct SIGNDOC_OutputStream *aStream);

/**
 * @brief Get all flags currently valid for SIGNDOC_Document_saveToStream().
 *
 * Note that #SIGNDOC_DOCUMENT_SAVEFLAGS_INCREMENTAL cannot be used
 * together with #SIGNDOC_DOCUMENT_SAVEFLAGS_LINEARIZED even if all
 * these flags are returned by this function.
 * #SIGNDOC_DOCUMENT_SAVEFLAGS_PDFA_BUTTONS is returned only if the document claims to be
 * PDF/A-1-compliant.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[out]  aOutput  The flags will be stored here.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_getSaveToFileFlags(), SIGNDOC_Document_saveToStream()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getSaveToStreamFlags (struct SIGNDOC_Exception **aEx,
                                       struct SIGNDOC_Document *aObj,
                                       int *aOutput);

/**
 * @brief Get all flags currently valid for SIGNDOC_Document_saveToFile().
 *
 * Note that #SIGNDOC_DOCUMENT_SAVEFLAGS_INCREMENTAL cannot be used
 * together with #SIGNDOC_DOCUMENT_SAVEFLAGS_LINEARIZED even if all these flags are returned by
 * this function. #SIGNDOC_DOCUMENT_SAVEFLAGS_PDFA_BUTTONS is returned
 * only if the document claims to be PDF/A-1-compliant.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[out]  aOutput  The flags will be stored here.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_getRequiredSaveToFileFlags(), SIGNDOC_Document_getSaveToStreamFlags(), SIGNDOC_Document_saveToFile()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getSaveToFileFlags (struct SIGNDOC_Exception **aEx,
                                     struct SIGNDOC_Document *aObj,
                                     int *aOutput);

/**
 * @brief Get all flags currently required for SIGNDOC_Document_saveToFile().
 *
 * This function currently stores ##SIGNDOC_DOCUMENT_SAVEFLAGS_INCREMENTAL
 * (saving the document
 * non-incrementally would destroy existing signatures) or 0 (the
 * document may be saved non-incrementally) to @a aOutput.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[out]  aOutput  The flags will be stored here.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_getSaveToFileFlags(), SIGNDOC_Document_getSaveToStreamFlags(), SIGNDOC_Document_saveToFile()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getRequiredSaveToFileFlags (struct SIGNDOC_Exception **aEx,
                                             struct SIGNDOC_Document *aObj,
                                             int *aOutput);

/**
 * @brief Get all interactive fields of the specified types.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aTypes   0 to get fields of all types.  Otherwise, a bitset
 *                      selecting the field types to be included. To include
 *                      a field of type t, add 1&lt;&lt;t, where t is
 *                      #SIGNDOC_FIELD_TYPE_PUSHBUTTON,
 *                      #SIGNDOC_FIELD_TYPE_CHECK_BOX,
 *                      #SIGNDOC_FIELD_TYPE_RADIO_BUTTON,
 *                      #SIGNDOC_FIELD_TYPE_TEXT,
 *                      #SIGNDOC_FIELD_TYPE_LIST_BOX,
 *                      #SIGNDOC_FIELD_TYPE_SIGNATURE_DIGSIG,
 *                      #SIGNDOC_FIELD_TYPE_SIGNATURE_SIGNDOC,
 *                      or #SIGNDOC_FIELD_TYPE_COMBO_BOX.
 * @param[out] aOutput  The fields will be stored here.  They appear
 *                      in the order in which they have been defined.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_exportFields(), SIGNDOC_Document_getField(), SIGNDOC_Document_getFieldsOfPage()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getFields (struct SIGNDOC_Exception **aEx,
                            struct SIGNDOC_Document *aObj,
                            int aTypes, struct SIGNDOC_FieldArray *aOutput);

/**
 * @brief Get all interactive fields of the specified page, in tab order.
 *
 * If the document does not specify a tab order, the fields will be
 * returned in widget order.
 *
 * @note Structure order (S) is not yet supported.  If the page specifies
 *       structure order, the fields will be returned in widget order.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aPage    The 1-based page number.
 * @param[in]  aTypes   0 to get fields of all types.  Otherwise, a bitset
 *                      selecting the field types to be included. To include
 *                      a field of type t, add 1&lt;&lt;t, where t is
 *                      #SIGNDOC_FIELD_TYPE_PUSHBUTTON,
 *                      #SIGNDOC_FIELD_TYPE_CHECK_BOX,
 *                      #SIGNDOC_FIELD_TYPE_RADIO_BUTTON,
 *                      #SIGNDOC_FIELD_TYPE_TEXT,
 *                      #SIGNDOC_FIELD_TYPE_LIST_BOX,
 *                      #SIGNDOC_FIELD_TYPE_SIGNATURE_DIGSIG,
 *                      #SIGNDOC_FIELD_TYPE_SIGNATURE_SIGNDOC,
 *                      or #SIGNDOC_FIELD_TYPE_COMBO_BOX.
 * @param[out] aOutput  The fields will be stored here in tab order.
 *                      There will be one element per widget (rather than
 *                      per field); use SIGNDOC_Field_getWidget() to find
 *                      out which widget of the field is referenced.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_exportFields(), SIGNDOC_Document_getField(), SIGNDOC_Document_getFields()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getFieldsOfPage (struct SIGNDOC_Exception **aEx,
                                  struct SIGNDOC_Document *aObj,
                                  int aPage, int aTypes,
                                  struct SIGNDOC_FieldArray *aOutput);

/**
 * @brief Get an interactive field by name.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding  The encoding of @a aName
 *                        (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                        or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aName    The fully-qualified name of the field.
 * @param[out] aOutput  The field will be stored here.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_getFields(), SIGNDOC_Document_setField()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getField (struct SIGNDOC_Exception **aEx,
                           struct SIGNDOC_Document *aObj,
                           int aEncoding, const char *aName,
                           struct SIGNDOC_Field *aOutput);

/**
 * @brief Change a field.
 *
 * This function changes a field in the document using attributes
 * from a SIGNDOC_Field object. Everything except for the name and
 * the type of the field can be changed. See the member functions of
 * SIGNDOC_Field for details.
 *
 * Always get a SIGNDOC_Field object for a field by calling
 * SIGNDOC_Document_getField(), SIGNDOC_Document_getFields(), or
 * SIGNDOC_Document_getFields(), then apply your modifications to that
 * object, then call SIGNDOC_Document_setField().
 *
 * The coordinates of the field are not changed unless
 * #SIGNDOC_DOCUMENT_SETFIELDFLAGS_MOVE is set in @a aFlags.
 *
 * Do not try to build a SIGNDOC_Field object from scratch for
 * changing a field as future versions of the SIGNDOC_Field class may
 * have additional attributes.
 *
 * This function is implemented for PDF documents only.
 *
 * This function always fails for PDF documents that have signed
 * signature fields.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in,out]  aField    The field to be changed.  The font resource
 *                           name of the default text field attributes
 *                           may be modified. The value index and the
 *                           value may be modified
 *                           for radio button fields and check box fields.
 * @param[in]      aFlags    Flags modifying the behavior of this function, see
 *                           #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_FAIL,
 *                           #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_WARN,
 *                           #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_IGNORE.
 *                           #SIGNDOC_DOCUMENT_SETFIELDFLAGS_MOVE,
 *                           #SIGNDOC_DOCUMENT_SETFIELDFLAGS_KEEP_AP,
 *                           #SIGNDOC_DOCUMENT_SETFIELDFLAGS_UPDATE_AP, and
 *                           #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FIT_HEIGHT_ONLY.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_addField(), SIGNDOC_Document_getFields(), SIGNDOC_Document_removeField()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_setField (struct SIGNDOC_Exception **aEx,
                           struct SIGNDOC_Document *aObj,
                           struct SIGNDOC_Field *aField, unsigned aFlags);

/**
 * @brief Add a field.
 *
 * See the members of SIGNDOC_Field for details.
 *
 * This function can add check boxes, radio button groups,
 * text fields, and signature fields to PDF documents.
 *
 * When adding a radio button group or a check box
 * field, a value must be set, see SIGNDOC_Field_setValue() and
 * SIGNDOC_Field_setValueIndex().
 *
 * The #SIGNDOC_FIELD_FLAG_NOTOGGLETOOFF flag should be set for all
 * radio button groups.  Adobe products seem to ignore this flag
 * being not set.
 *
 * When adding a text field, the justification must be set with
 * SIGNDOC_Field_setJustification().
 *
 * Currently, you don't have control over the appearance of the
 * field being inserted except for the text field attributes.
 *
 * Adding a field to a PDF document that doesn't contain any fields
 * will set the document's default text field attributes to font
 * Helvetica, font size 0, text color black.
 *
 * Only signature fields can be added to PDF documents having signed
 * signature fields.
 *
 * TIFF documents support signature fields only and all signature
 * fields must be inserted before the first signature is added to
 * the document (you may want to use invisible fields) unless all
 * existing signature fields have flag
 * #SIGNDOC_FIELD_FLAG_ENABLEADDAFTERSIGNING set.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in,out]  aField    The new field.  The font resource
 *                           name of the default text field attributes
 *                           may be modified. The value index and the
 *                           value may be modified
 *                           for radio button fields and check box fields.
 * @param[in]  aFlags        Flags modifying the behavior of this function, see
 *                           #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_FAIL,
 *                           #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_WARN,
 *                           #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_IGNORE,
 *                           #SIGNDOC_DOCUMENT_SETFIELDFLAGS_KEEP_AP,
 *                           #SIGNDOC_DOCUMENT_SETFIELDFLAGS_UPDATE_AP, and
 *                           #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FIT_HEIGHT_ONLY.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_getField(), SIGNDOC_Document_removeField(), SIGNDOC_Document_setField(), SIGNDOC_Document_setTextFieldAttributes()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_addField (struct SIGNDOC_Exception **aEx,
                           struct SIGNDOC_Document *aObj,
                           struct SIGNDOC_Field *aField, unsigned aFlags);

/**
 * @brief Remove a field.
 *
 * Removing a field of a TIFF document will invalidate all signatures.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding    The encoding of @a aName
 *                         (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                         or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aName    The fully-qualified name of the field.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_addField(), SIGNDOC_Document_flattenField(), SIGNDOC_Document_getFields()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_removeField (struct SIGNDOC_Exception **aEx,
                              struct SIGNDOC_Document *aObj,
                              int aEncoding, const char *aName);

/**
 * @brief Flatten a field.
 *
 * Flattening a field of a PDF document makes its appearance part of
 * the page and removes the selected widget or all widgets; the field
 * will be removed when all its widgets have been flattened.
 *
 * Flattening unsigned signature fields does not work correctly.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding    The encoding of @a aName
 *                          (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                          or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aName        The fully-qualified name of the field.
 * @param[in]  aWidget      The widget index to flatten only one widget
 *                          or -1 to flatten all widgets.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_flattenFields(), SIGNDOC_Document_removeField()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_flattenField (struct SIGNDOC_Exception **aEx,
                               struct SIGNDOC_Document *aObj,
                               int aEncoding, const char *aName, int aWidget);

/**
 * @brief Flatten all fields of the document or of a range of pages.
 *
 * Flattening a field of a PDF document makes its appearance part of
 * the page and removes the selected widget or all widgets; the field
 * will be removed when all its widgets have been flattened.
 * This function selects all widgets on the specified pages.
 *
 * Flattening unsigned signature fields does not work correctly.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in] aFirstPage  1-based number of first page.
 * @param[in] aLastPage   1-based number of last page or 0 to process
 *                        all pages to the end of the document.
 * @param[in] aFlags      Flags modifying the behavior of this function, see
 *                        #SIGNDOC_DOCUMENT_FLATTENFIELDSFLAGS_INCLUDE_SIGNATURE_UNSIGNED,
 *                        #SIGNDOC_DOCUMENT_FLATTENFIELDSFLAGS_INCLUDE_SIGNATURE_SIGNED,
 *                        #SIGNDOC_DOCUMENT_FLATTENFIELDSFLAGS_INCLUDE_HIDDEN, and
 *                        #SIGNDOC_DOCUMENT_FLATTENFIELDSFLAGS_KEEP_STRUCTURE.
 *                        If this value is 0, signature fields and
 *                        hidden/invisible widgets will not be flattened.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_flattenField(), SIGNDOC_Document_removeField()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_flattenFields (struct SIGNDOC_Exception **aEx,
                                struct SIGNDOC_Document *aObj,
                                int aFirstPage, int aLastPage, unsigned aFlags);

/**
 * @brief Export all fields as XML.
 *
 * This function always uses UTF-8 encoding.  The output conforms
 * to schema PdfFields.xsd.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aStream  The fields will be saved to this stream.
 * @param[in]  aFlags   Flags modifying the behavior of this function, see
 *                      #SIGNDOC_DOCUMENT_EXPORTFLAGS_TOP.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_getFields(), SIGNDOC_Document_setField()
 *
 * @memberof SIGNDOC_Document
 *
 * @todo implement for TIFF
 */
int SDCAPI
SIGNDOC_Document_exportFields (struct SIGNDOC_Exception **aEx,
                               struct SIGNDOC_Document *aObj,
                               struct SIGNDOC_OutputStream *aStream,
                               int aFlags);

/**
 * @brief Apply an FDF document to a PDF document.
 *
 * FDF documents can be applied to PDF documents only.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in] aEncoding  The encoding of the string pointed to by @a aPath
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aPath      The pathname of the FDF document.
 *                       See @ref winrt_store for restrictions on pathnames
 *                       in Windows Store apps.
 * @param[in] aFlags     Flags modifying the behavior of this function,
 *                       #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_FAIL,
 *                       #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_WARN,
 *                       #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_IGNORE,
 *                       #SIGNDOC_DOCUMENT_SETFIELDFLAGS_KEEP_AP,
 *                       #SIGNDOC_DOCUMENT_SETFIELDFLAGS_UPDATE_AP, and
 *                       #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FIT_HEIGHT_ONLY.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_applyFdfW()

 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_applyFdf (struct SIGNDOC_Exception **aEx,
                           struct SIGNDOC_Document *aObj,
                           int aEncoding, const char *aPath, unsigned aFlags);

/**
 * @brief Apply an FDF document to a PDF document.
 *
 * FDF documents can be applied to PDF documents only.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in] aPath      The pathname of the FDF document.
 * @param[in] aFlags     Flags modifying the behavior of this function, see
 *                       #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_FAIL,
 *                       #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_WARN,
 *                       #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FONT_IGNORE,
 *                       #SIGNDOC_DOCUMENT_SETFIELDFLAGS_KEEP_AP,
 *                       #SIGNDOC_DOCUMENT_SETFIELDFLAGS_UPDATE_AP, and
 *                       #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FIT_HEIGHT_ONLY.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_applyFdf()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_applyFdfW (struct SIGNDOC_Exception **aEx,
                            struct SIGNDOC_Document *aObj,
                            const wchar_t *aPath, unsigned aFlags);

/**
 * @brief Get the document's default text field attributes.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in,out] aOutput  This object will be updated.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_getField(), SIGNDOC_Document_setTextFieldAttributes(), SIGNDOC_Field_getTextFieldAttributes()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getTextFieldAttributes (struct SIGNDOC_Exception **aEx,
                                         struct SIGNDOC_Document *aObj,
                                         struct SIGNDOC_TextFieldAttributes *aOutput);

/**
 * @brief Set the document's default text field attributes.
 *
 * Font name, font size, and text color must be specified.
 * This function fails if @a aData has any but not all attributes set
 * or if any of the attributes are invalid.
 *
 * This function fails for signed PDF document.
 *
 * This function always fails for TIFF documents.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in,out] aData  The new default text field attributes.
 *                       The font resource name will be updated.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK iff successful.
 *
 * @see SIGNDOC_Document_addField(), SIGNDOC_Document_getTextFieldAttributes(), SIGNDOC_Field_setTextFieldAttributes()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_setTextFieldAttributes (struct SIGNDOC_Exception **aEx,
                                         struct SIGNDOC_Document *aObj,
                                         struct SIGNDOC_TextFieldAttributes *aData);

/**
 * @brief Get the names and types of all SignDoc properties of a
 *        certain collection of properties of the document.
 *
 * Use SIGNDOC_Document_getBooleanProperty(),
 * SIGNDOC_Document_getIntegerProperty(), or
 * SIGNDOC_Document_getStringProperty() to get the values of the
 * properties.
 *
 * There are three collections of SignDoc document properties:
 * - "encrypted"   Encrypted properties. Names and values are symmetrically
 *                 encrypted.
 * - "public"      Public properties. Document viewer applications may
 *                 be able to display or let the user modify these
 *                 properties.
 * - "pdfa"        PDF/A properties (PDF documents only):
 *                 - part (PDF/A version identifier: 1, 2, or 3)
 *                 - amd (optional PDF/A amendment identifier)
 *                 - conformance (PDF/A conformance level: A, B, or U)
 *                 .
 *                 All properties in this collection have string values,
 *                 the property names are case-sensitive.
 *                 If the "part" property is present, the document claims
 *                 to be conforming to PDF/A. Your application may change
 *                 its behavior when dealing with PDF/A documents. For
 *                 instance, it might want to avoid transparency.
 * .
 *
 * Using the same property name in the "encrypted" and "public"
 * collections is not possible. Attempts to get, set, or remove a
 * property in the wrong collection will fail with error code
 * #SIGNDOC_DOCUMENT_RETURNCODE_WRONG_COLLECTION.
 * To move a property from one collection to
 * another collection, first remove it from the source collection,
 * then add it to the target collection.
 *
 * The "pdfa" collection is read-only and a property name existing
 * in that collection does not prevent that property name from
 * appearing in one of the other collections.
 *
 * The syntax of property names depends on the document type and the
 * collection containing the property.
 *
 * "public" properties of PDF documents are stored according to XMP in
 * namespace "http://www.softpro.de/pdfa/signdoc/public/", therefore
 * property names must be valid unqualified XML names, see the syntax
 * of "Name" in the XML 1.1 specification at
 * http://www.w3.org/TR/2004/REC-xml11-20040204/#sec-common-syn
 * (section 2.3 Common Syntactic Constructs).
 *
 * For "encrypted" properties and any properties in TIFF documents,
 * property names can contain arbitrary Unicode characters except for
 * NUL.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in] aCollection   The name of the collection, see above.
 * @param[out] aOutput  The properties will be stored here.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_removeProperty(), SIGNDOC_Document_getStringProperty()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getProperties (struct SIGNDOC_Exception **aEx,
                                struct SIGNDOC_Document *aObj,
                                const char *aCollection,
                                struct SIGNDOC_PropertyArray *aOutput);

/**
 * @brief Get the value of a SignDoc property (integer).
 *
 * In the "public" and "encrypted" collections, property names are
 * compared under Unicode simple case folding, that is, lower case
 * and upper case is not distinguished.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding   The encoding of @a aName
 *                         (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                         or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aCollection   The name of the collection, see
 *                           SIGNDOC_Document_getProperties().
 * @param[in]  aName   The name of the property.
 * @param[out] aValue  The value will be stored here.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_getBooleanProperty(), SIGNDOC_Document_getProperties(), SIGNDOC_Document_getStringProperty()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getIntegerProperty (struct SIGNDOC_Exception **aEx,
                                     struct SIGNDOC_Document *aObj,
                                     int aEncoding, const char *aCollection,
                                     const char *aName, long *aValue);

/**
 * @brief Get the value of a SignDoc property (string).
 *
 * In the "public" and "encrypted" collections, property names are
 * compared under Unicode simple case folding, that is, lower case
 * and upper case is not distinguished.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding   The encoding of @a aName and for @a aValue
 *                         (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                         or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aCollection   The name of the collection, see
 *                           SIGNDOC_Document_getProperties().
 * @param[in]  aName   The name of the property.
 * @param[out] aValue  The value will be stored here, encoded according to
 *                     @a aEncoding.
 *                     The string must be freed with SIGNDOC_free().
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_getBooleanPropery(), SIGNDOC_Document_getIntegerProperty(), SIGNDOC_Document_getProperties()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getStringProperty (struct SIGNDOC_Exception **aEx,
                                    struct SIGNDOC_Document *aObj,
                                    int aEncoding, const char *aCollection,
                                    const char *aName, char **aValue);

/**
 * @brief Get the value of a SignDoc property (boolean).
 *
 * In the "public" and "encrypted" collections, property names are
 * compared under Unicode simple case folding, that is, lower case
 * and upper case is not distinguished.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding   The encoding of @a aName
 *                         (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                         or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aCollection   The name of the collection, see
 *                           SIGNDOC_Document_getProperties().
 * @param[in]  aName   The name of the property.
 * @param[out] aValue  The value will be stored here.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_getIntegerProperty(), SIGNDOC_Document_getProperties(), SIGNDOC_Document_getStringProperty()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getBooleanProperty (struct SIGNDOC_Exception **aEx,
                                     struct SIGNDOC_Document *aObj,
                                     int aEncoding, const char *aCollection,
                                     const char *aName,
                                     SIGNDOC_Boolean *aValue);

/**
 * @brief Set the value of a SignDoc property (integer).
 *
 * In the "public" and "encrypted" collections, property names are
 * compared under Unicode simple case folding, that is, lower case
 * and upper case is not distinguished.
 *
 * It's not possible to change the type of a property.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding   The encoding of @a aName
 *                         (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                         or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aCollection   The name of the collection, see
 *                           SIGNDOC_Document_getProperties().
 * @param[in]  aName   The name of the property.
 * @param[in]  aValue  The new value of the property.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see getProperties(), SIGNDOC_Document_removeProperty(), SIGNDOC_Document_setBooleanProperty(), SIGNDOC_Document_setStringProperty(), SIGNDOC_Document_addSignature()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_setIntegerProperty (struct SIGNDOC_Exception **aEx,
                                     struct SIGNDOC_Document *aObj,
                                     int aEncoding, const char *aCollection,
                                     const char *aName, long aValue);

/**
 * @brief Set the value of a SignDoc property (string).
 *
 * In the "public" and "encrypted" collections, property names are
 * compared under Unicode simple case folding, that is, lower case
 * and upper case is not distinguished.
 *
 * It's not possible to change the type of a property.
 * Embedded NUL characters are not supported.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding   The encoding of @a aName and @a aValue
 *                         (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                         or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aCollection   The name of the collection, see
 *                           SIGNDOC_Document_getProperties().
 * @param[in]  aName   The name of the property.
 * @param[in]  aValue  The new value of the property.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see getProperties(), SIGNDOC_Document_removeProperty(), SIGNDOC_Document_setBooleanProperty(), SIGNDOC_Document_setIntegerProperty(), SIGNDOC_Document_addSignature()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_setStringProperty (struct SIGNDOC_Exception **aEx,
                                    struct SIGNDOC_Document *aObj,
                                    int aEncoding, const char *aCollection,
                                    const char *aName, const char *aValue);

/**
 * @brief Set the value of a SignDoc property (boolean).
 *
 * In the "public" and "encrypted" collections, property names are
 * compared under Unicode simple case folding, that is, lower case
 * and upper case is not distinguished.
 *
 * It's not possible to change the type of a property.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding   The encoding of @a aName
 *                         (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                         or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aCollection   The name of the collection, see
 *                           SIGNDOC_Document_getProperties().
 * @param[in]  aName   The name of the property.
 * @param[in]  aValue  The new value of the property.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see getProperties(), SIGNDOC_Document_removeProperty(), SIGNDOC_Document_setIntegerProperty(), SIGNDOC_Document_setStringProperty(), SIGNDOC_Document_addSignature()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_setBooleanProperty (struct SIGNDOC_Exception **aEx,
                                     struct SIGNDOC_Document *aObj,
                                     int aEncoding, const char *aCollection,
                                     const char *aName, SIGNDOC_Boolean aValue);

/**
 * @brief Remove a SignDoc property.
 *
 * In the "public" and "encrypted" collections, property names are
 * compared under Unicode simple case folding, that is, lower case
 * and upper case is not distinguished.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding   The encoding of @a aName
 *                         (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                         or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aCollection   The name of the collection, see
 *                           SIGNDOC_Document_getProperties().
 * @param[in]  aName   The name of the property.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_getProperties(), SIGNDOC_Document_setStringProperty()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_removeProperty (struct SIGNDOC_Exception **aEx,
                                 struct SIGNDOC_Document *aObj,
                                 int aEncoding, const char *aCollection, const char *aName);

/**
 * @brief Export properties as XML.
 *
 * This function always uses UTF-8 encoding.
 * The output conforms to schema AllSignDocProperties.xsd
 * (if @a aCollection is empty) or SignDocProperties.xsd
 * (if @a aCollection is non-empty).
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aCollection   The name of the collection, see
 *                           SIGNDOC_Document_getProperties().
 *                           If the string is empty, all properties of the
 *                           "public" and "encrypted" collections
 *                           will be exported.
 * @param[in]  aStream  The properties will be saved to this stream.
 * @param[in]  aFlags   Flags modifying the behavior of this function,
 *                      See #SIGNDOC_DOCUMENT_EXPORTFLAGS_TOP.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_importProperties()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_exportProperties (struct SIGNDOC_Exception **aEx,
                                   struct SIGNDOC_Document *aObj,
                                   const char *aCollection, struct SIGNDOC_OutputStream *aStream, int aFlags);

/**
 * @brief Import properties from XML.
 *
 * The input must conform to schema AllSignDocProperties.xsd
 * (if @a aCollection is empty) or SignDocProperties.xsd
 * (if @a aCollection is non-empty).
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aCollection   The name of the collection, see
 *                           SIGNDOC_Document_getProperties().
 *                           If the string is empty, properties will be
 *                           imported into all collections, otherwise
 *                           properties will be imported into the specified
 *                           collection.
 * @param[in]  aStream  The properties will be read from this stream.
 *                      This function reads the input completely, it doesn't
 *                      stop at the end tag.
 * @param[in]  aFlags   Flags modifying the behavior of this function,
 *                      see #SIGNDOC_DOCUMENT_IMPORTFLAGS_ATOMIC.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_exportProperties()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_importProperties (struct SIGNDOC_Exception **aEx,
                                   struct SIGNDOC_Document *aObj,
                                   const char *aCollection,
                                   struct SIGNDOC_InputStream *aStream,
                                   int aFlags);

/**
 * @brief Get the SignDoc data block of the document.
 *
 * @note This function is no longer supported; it always returns
 *       #SIGNDOC_ANNOTATION_RETURNCODE_NOT_SUPPORTED.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[out]  aOutput  Not used.
 *
 * @return #SIGNDOC_ANNOTATION_RETURNCODE_NOT_SUPPORTED.
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getDataBlock (struct SIGNDOC_Exception **aEx,
                               struct SIGNDOC_Document *aObj,
                               struct SIGNDOC_ByteArray *aOutput);

/**
 * @brief Replace the SignDoc data block of the document.
 *
 * @note This function is no longer supported; it always returns
 *       #SIGNDOC_ANNOTATION_RETURNCODE_NOT_SUPPORTED.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in] aData  Not used.
 * @param[in] aSize  Not used.
 *
 * @return #SIGNDOC_ANNOTATION_RETURNCODE_NOT_SUPPORTED.
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_setDataBlock (struct SIGNDOC_Exception **aEx,
                               struct SIGNDOC_Document *aObj,
                               const unsigned char *aData, size_t aSize);

/**
 * @brief Get the resolution of a page.
 *
 * Different pages of the document may have different resolutions.
 * Use SIGNDOC_Document_getConversionFactors() to get factors for
 * converting document coordinates to real world coordinates.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aPage    The page number (1 for the first page).
 * @param[out] aResX    The horizontal resolution in DPI will be stored here.
 *                      The value will be 0.0 if the resolution is not
 *                      available.
 * @param[out] aResY    The vertical resolution in DPI will be stored here.
 *                      The value will be 0.0 if the resolution is not
 *                      available.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_getConversionFactors()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getResolution (struct SIGNDOC_Exception **aEx,
                                struct SIGNDOC_Document *aObj,
                                int aPage, double *aResX, double *aResY);

/**
 * @brief Get the conversion factors for a page.
 *
 * Different pages of the document may have different conversion factors.
 * For TIFF documents, this function yields the same values as
 * SIGNDOC_Document_getResolution().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aPage    The page number (1 for the first page).
 * @param[out] aFactorX    Divide horizontal coordinates by this number
 *                         to convert document coordinates to inches.
 *                         The value will be 0.0 if the conversion factor
 *                         is not available.
 * @param[out] aFactorY    Divide vertical coordinates by this number
 *                         to convert document coordinates to inches.
 *                         The value will be 0.0 if the conversion factor
 *                         is not available.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_getPageSize(), SIGNDOC_Document_getResolution()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getConversionFactors (struct SIGNDOC_Exception **aEx,
                                       struct SIGNDOC_Document *aObj,
                                       int aPage, double *aFactorX, double *aFactorY);

/**
 * @brief Get the size of a page.
 *
 * Different pages of the document may have different sizes.  Use
 * SIGNDOC_Document_getConversionFactors() to get factors for
 * converting the page size from document coordinates to real world
 * dimensions.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aPage    The page number (1 for the first page).
 * @param[out] aWidth   The width of the page (in document coordinates)
 *                      will be stored here.
 * @param[out] aHeight  The height of the page (in document coordinates)
 *                      will be stored here.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_getConversionFactors()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getPageSize (struct SIGNDOC_Exception **aEx,
                              struct SIGNDOC_Document *aObj,
                              int aPage, double *aWidth, double *aHeight);

/**
 * @brief Get the number of bits per pixel (TIFF only).
 *
 * Different pages of the document may have different numbers of bits
 * per pixel.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aPage    The page number (1 for the first page).
 * @param[out] aBPP     The number of bits per pixel of the page
 *                      (1, 8, 24, or 32) or 0 (for PDF documents)
 *                      will be stored here.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful,
 *         #SIGNDOC_DOCUMENT_RETURNCODE_INVALID_ARGUMENT if @a aPage is
 *         out of range.
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getBitsPerPixel (struct SIGNDOC_Exception **aEx,
                                  struct SIGNDOC_Document *aObj,
                                  int aPage, int *aBPP);

/**
 * @brief Compute the zoom factor used for rendering.
 *
 * If SIGNDOC_RenderParameters_fitWidth(),
 * SIGNDOC_RenderParameters_fitHeight(), or
 * SIGNDOC_RenderParameters_fitRect() has been called, the actual factor
 * depends on the document's page size.
 * If multiple pages are selected (see SIGNDOC_RenderParameters_setPages()),
 * the maximum width and maximum height of all selected pages will be used.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[out] aOutput  The zoom factor will be stored here.
 * @param[in]  aParams  The parameters such as the page number and the
 *                      zoom factor.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_getRenderedSize(), SIGNDOC_Document_renderPageAsImage(), SIGNDOC_RenderParameters_fitHeight(), SIGNDOC_RenderParameters_fitRect(), SIGNDOC_RenderParameters_fitWidth(), SIGNDOC_RenderParameters_setPages(), SIGNDOC_RenderParameters_setZoom()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_computeZoom (struct SIGNDOC_Exception **aEx,
                              struct SIGNDOC_Document *aObj,
                              double *aOutput,
                              const struct SIGNDOC_RenderParameters *aParams);

/**
 * @brief Convert a point expressed in canvas (image) coordinates to
 *        a point expressed in document coordinate system of the
 *        current page.
 *
 * The origin is in the bottom left corner of the page.
 * The origin is in the upper left corner of the image.
 * See @ref signdocshared_coordinates.
 * If multiple pages are selected (see SIGNDOC_RenderParameters_setPages()),
 * the first page of the range will be used.
 *
 * Suppose the current page of a PDF document has height PH and the
 * rendered image has height IH.  Then, point (0,0) will be
 * converted to (0,PH) and point (0,IH) will be converted to (0,0).
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in,out] aPoint   The point to be converted.
 * @param[in]     aParams  The parameters such as the page number and the
 *                         zoom factor.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_convCanvasPointToPagePoint (struct SIGNDOC_Exception **aEx,
                                             struct SIGNDOC_Document *aObj,
                                             struct SIGNDOC_Point *aPoint,
                                             const struct SIGNDOC_RenderParameters *aParams);

/**
 * @brief Convert a point expressed in document coordinate system of the
 *        current page to a point expressed in canvas (image) coordinates.
 *
 * The origin is in the bottom left corner of the page.
 * The origin is in the upper left corner of the image.
 * See @ref signdocshared_coordinates.
 * If multiple pages are selected (see SIGNDOC_RenderParameters_setPages()),
 * the first page of the range will be used.
 *
 * Suppose the current page page of a PDF document has height PH and
 * the rendered image has height IH.  Then, point (0,0) will be
 * converted to (0,IH) and point (0,PH) will be converted to (0,0).
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in,out] aPoint   The point to be converted.
 * @param[in]     aParams  The parameters such as the page number and the
 *                         zoom factor.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_convPagePointToCanvasPoint (struct SIGNDOC_Exception **aEx,
                                             struct SIGNDOC_Document *aObj,
                                             struct SIGNDOC_Point *aPoint,
                                             const struct SIGNDOC_RenderParameters *aParams);

/**
 * @brief Render the selected page (or pages) as image.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[out] aImage  The image will be stored here as a blob.
 * @param[out] aOutput The image size will be stored here.
 * @param[in]  aParams    Parameters such as the page number.
 * @param[in]  aClipRect  The rectangle to be rendered (using document
 *                        coordinates, see @ref signdocshared_coordinates)
 *                        or NULL to render the complete page.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_computeZoom(), SIGNDOC_Document_getRenderedSize()
 *
 * @memberof SIGNDOC_Document
 *
 * @todo add another function which specifies the target rectangle
 *       (in addition than the source rectangle) to be rendered.
 */
int SDCAPI
SIGNDOC_Document_renderPageAsImage (struct SIGNDOC_Exception **aEx,
                                    struct SIGNDOC_Document *aObj,
                                    struct SIGNDOC_ByteArray *aImage,
                                    struct SIGNDOC_RenderOutput *aOutput,
                                    const struct SIGNDOC_RenderParameters *aParams,
                                    const struct SIGNDOC_Rect *aClipRect);

/**
 * @brief Get the size of the rendered page in pixels (without actually
 *        rendering it).
 *
 * The returned values may be approximations for some document formats.
 * If multiple pages are selected (see SIGNDOC_RenderParameters_setPages()),
 * the maximum width and maximum height of all selected pages will be used.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[out] aOutput   The width and height of the image that would be
 *                       computed by SIGNDOC_Document_renderPageAsImage()
 *                       with @a aClipRect
 *                       being NULL will be stored here.
 * @param[in]  aParams   Parameters such as the page number.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_renderPageAsImage()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getRenderedSize (struct SIGNDOC_Exception **aEx,
                                  struct SIGNDOC_Document *aObj,
                                  struct SIGNDOC_RenderOutput *aOutput,
                                  const struct SIGNDOC_RenderParameters *aParams);

/**
 * @brief Create a line annotation.
 *
 * See SIGNDOC_Annotation for details.
 *
 * This function uses document (page) coordinates,
 * see @ref signdocshared_coordinates.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aStart    Start point.
 * @param[in]  aEnd      End point.
 *
 * @return The new annotation object. The caller is responsible for
 *         destroying the object after use.
 *
 * @see SIGNDOC_Document_addAnnotation()
 *
 * @memberof SIGNDOC_Document
 */
struct SIGNDOC_Annotation * SDCAPI
SIGNDOC_Document_createLineAnnotation (struct SIGNDOC_Exception **aEx,
                                       struct SIGNDOC_Document *aObj,
                                       const struct SIGNDOC_Point *aStart,
                                       const struct SIGNDOC_Point *aEnd);

/**
 * @brief Create a line annotation.
 *
 * See SIGNDOC_Annotation for details.
 * This function uses document (page) coordinates,
 * see @ref signdocshared_coordinates.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aStartX   X coordinate of start point.
 * @param[in]  aStartY   Y coordinate of start point.
 * @param[in]  aEndX     X coordinate of end point.
 * @param[in]  aEndY     Y coordinate of end point.
 *
 * @return The new annotation object. The caller is responsible for
 *         destroying the object after use.
 *
 * @see SIGNDOC_Document_addAnnotation()
 *
 * @memberof SIGNDOC_Document
 */
struct SIGNDOC_Annotation * SDCAPI
SIGNDOC_Document_createLineAnnotationXY (struct SIGNDOC_Exception **aEx,
                                         struct SIGNDOC_Document *aObj,
                                         double aStartX, double aStartY,
                                         double aEndX, double aEndY);

/**
 * @brief Create a scribble annotation.
 *
 * See SIGNDOC_Annotation for details.
 * This function uses document (page) coordinates,
 * see @ref signdocshared_coordinates.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 *
 * @return The new annotation object. The caller is responsible for
 *         destroying the object after use.
 *
 * @see SIGNDOC_Document_addAnnotation(), SIGNDOC_Annotation_addPoint(), SIGNDOC_Annotation_newStroke()
 *
 * @memberof SIGNDOC_Document
 */
struct SIGNDOC_Annotation * SDCAPI
SIGNDOC_Document_createScribbleAnnotation (struct SIGNDOC_Exception **aEx,
                                           struct SIGNDOC_Document *aObj);

/**
 * @brief Create a text annotation.
 *
 * See SIGNDOC_Annotation for details.
 * This function uses document (page) coordinates,
 * see @ref signdocshared_coordinates.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aLowerLeft  coordinates of lower left corner.
 * @param[in]  aUpperRight coordinates of upper right corner.
 *
 * @return The new annotation object. The caller is responsible for
 *         destroying the object after use.
 *
 * @see SIGNDOC_Document_addAnnotation()
 *
 * @memberof SIGNDOC_Document
 */
struct SIGNDOC_Annotation * SDCAPI
SIGNDOC_Document_createFreeTextAnnotation (struct SIGNDOC_Exception **aEx,
                                           struct SIGNDOC_Document *aObj,
                                           const struct SIGNDOC_Point *aLowerLeft,
                                           const struct SIGNDOC_Point *aUpperRight);

/**
 * @brief Create a text annotation.
 *
 * See SIGNDOC_Annotation for details.
 * This function uses document (page) coordinates,
 * see @ref signdocshared_coordinates.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aX0       X coordinate of lower left corner.
 * @param[in]  aY0       Y coordinate of lower left corner.
 * @param[in]  aX1       X coordinate of upper right corner.
 * @param[in]  aY1       Y coordinate of upper right corner.
 *
 * @return The new annotation object. The caller is responsible for
 *         destroying the object after use.
 *
 * @see SIGNDOC_Document_addAnnotation()
 *
 * @memberof SIGNDOC_Document
 */
struct SIGNDOC_Annotation * SDCAPI
SIGNDOC_Document_createFreeTextAnnotationXY (struct SIGNDOC_Exception **aEx,
                                             struct SIGNDOC_Document *aObj,
                                             double aX0, double aY0, double aX1, double aY1);

/**
 * @brief Add an annotation to a page.
 *
 * See SIGNDOC_Annotation for details.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aPage     The page number (1 for the first page).
 * @param[in]  aAnnot    Pointer to the new annotation.  Ownership remains
 *                       at the caller.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_createLineAnnotation(), SIGNDOC_Document_createScribbleAnnotation(), SIGNDOC_Document_createFreeTextAnnotation()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_addAnnotation (struct SIGNDOC_Exception **aEx,
                                struct SIGNDOC_Document *aObj,
                                int aPage,
                                const struct SIGNDOC_Annotation *aAnnot);

/**
 * @brief Get a list of all named annotations of a page.
 *
 * Unnamed annotations are ignored by this function.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding  The encoding to be used for the names of the
 *                        annotations returned in @a aOutput
 *                        (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                        or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aPage     The page number (1 for the first page).
 * @param[out] aOutput   The names of the annotations will be stored here.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_addAnnotation(), SIGNDOC_Document_getAnnotation(), SIGNDOC_Document_removeAnnotation(), SIGNDOC_Annotation_setName()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getAnnotations (struct SIGNDOC_Exception **aEx,
                                 struct SIGNDOC_Document *aObj,
                                 int aEncoding, int aPage,
                                 struct SIGNDOC_StringArray *aOutput);

/**
 * @brief Get a named annotation of a page.
 *
 * All setters will fail for the returned object.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding   The encoding of @a aName
 *                         (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                         or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aPage     The page number (1 for the first page).
 * @param[in]  aName     The name of the annotation.
 * @param[out] aOutput   A pointer to a new SIGNDOC_Annotation object or
 *                       NULL will be stored here. The caller is responsible
 *                       for destroying that object.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_getAnnotations()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getAnnotation (struct SIGNDOC_Exception **aEx,
                                struct SIGNDOC_Document *aObj,
                                int aEncoding, int aPage, const char *aName,
                                struct SIGNDOC_Annotation **aOutput);

/**
 * @brief Remove an annotation identified by name.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding   The encoding of @a aName
 *                         (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                         or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aPage     The page number (1 for the first page).
 * @param[in]  aName     The name of the annotation, must not be
 *                       empty.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_addAnnotation(), SIGNDOC_Document_getAnnotations(), SIGNDOC_Annotation_setName()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_removeAnnotation (struct SIGNDOC_Exception **aEx,
                                   struct SIGNDOC_Document *aObj,
                                   int aEncoding, int aPage,
                                   const char *aName);

/**
 * @brief Add text to a page.
 *
 * Multiple lines are not supported, the text must not contain CR
 * and LF characters.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in] aEncoding   The encoding of @a aText and @a aFontName
 *                        (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                        or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aText       The text. Complex scripts are supported,
 *                        see @ref signdocshared_complex_scripts.
 * @param[in] aPage       The 1-based page number of the page.
 * @param[in] aX          The X coordinate of the reference point of
 *                        the first character in document coordinates.
 * @param[in] aY          The Y coordinate of the reference point of
 *                        the first character in document coordinates.
 * @param[in] aFontName   The font name.
 *                        This can be the name of a standard font,
 *                        the name of an already embedded font, or
 *                        the name of a font defined by a font
 *                        configuration file.
 * @param[in] aFontSize   The font size (in user space units).
 * @param[in] aTextColor  The text color.
 * @param[in] aOpacity    The opacity, 0.0 (transparent) through 1.0 (opaque).
 *                        Documents conforming to PDF/A must use an opacity
 *                        of 1.0.
 * @param[in] aFlags      Must be 0.
 *
 * @see SIGNDOC_Document_addTextRect(), SIGNDOC_Document_addWatermark(), SIGNDOC_DocumentLoader_loadFontConfigFile(), SIGNDOC_DocumentLoader_loadFontConfigEnvironment(), SIGNDOC_DocumentLoader_loadFontConfigStream()
 *
 * @memberof SIGNDOC_Document
 *
 * @todo implement for TIFF documents
 */
int SDCAPI
SIGNDOC_Document_addText (struct SIGNDOC_Exception **aEx,
                          struct SIGNDOC_Document *aObj,
                          int aEncoding, const char *aText, int aPage,
                          double aX, double aY, const char *aFontName,
                          double aFontSize,
                          const struct SIGNDOC_Color *aTextColor,
                          double aOpacity, int aFlags);

/**
 * @brief Add text in a rectangle of a page (with line breaking).
 *
 * Any sequence of CR and LF characters in the text starts a new
 * paragraph (ie, text following such a sequence will be placed at
 * the beginning of the next output line). In consequence, empty
 * lines in the input do not produce empty lines in the output. To
 * get an empty line in the output, you have to add a paragraph
 * containing a non-breaking space (0xa0) only:
 * @code
 * "Line before empty line\n\xa0\nLine after empty line"
 * @endcode
 *
 * @note This function does not yet support complex scripts.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in] aEncoding   The encoding of @a aText and @a aFontName
 *                        (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                        or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aText       The text. Allowed control characters are
 *                        CR and LF. Any sequence of CR and LF characters
 *                        starts a new paragraph.
 * @param[in] aPage       The 1-based page number of the page.
 * @param[in] aX0         X coordinate of lower left corner.
 * @param[in] aY0         Y coordinate of lower left corner.
 * @param[in] aX1         X coordinate of upper right corner.
 * @param[in] aY1         Y coordinate of upper right corner.
 * @param[in] aFontName   The font name.
 *                        This can be the name of a standard font,
 *                        the name of an already embedded font, or
 *                        the name of a font defined by a font
 *                        configuration file.
 * @param[in] aFontSize   The font size (in user space units).
 * @param[in] aLineSkip   The vertical distance between the baselines of
 *                        successive lines (usually 1.2 * @a aFontSize).
 * @param[in] aTextColor  The text color.
 * @param[in] aOpacity    The opacity, 0.0 (transparent) through 1.0 (opaque).
 *                        Documents conforming to PDF/A must use an opacity
 *                        of 1.0.
 * @param[in] aHAlignment Horizontal alignment of the text.
 * @param[in] aVAlignment Vertical alignment of the text.
 * @param[in] aFlags      Must be 0.
 *
 * @see SIGNDOC_Document_addText(), SIGNDOC_Document_addWatermark(), SIGNDOC_DocumentLoader_loadFontConfigFile(), SIGNDOC_DocumentLoader_loadFontConfigEnvironment(), SIGNDOC_DocumentLoader_loadFontConfigStream()
 *
 * @memberof SIGNDOC_Document
 *
 * @todo implement for TIFF documents
 */
int SDCAPI
SIGNDOC_Document_addTextRect (struct SIGNDOC_Exception **aEx,
                              struct SIGNDOC_Document *aObj,
                              int aEncoding, const char *aText, int aPage,
                              double aX0, double aY0, double aX1, double aY1,
                              const char *aFontName, double aFontSize,
                              double aLineSkip,
                              const struct SIGNDOC_Color *aTextColor,
                              double aOpacity, int aHAlignment,
                              int aVAlignment, int aFlags);

/**
 * @brief Add a watermark.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in] aInput   An object describing the watermark.
 *
 * @see SIGNDOC_Document_addText(), SIGNDOC_Document_addTextRect(), SIGNDOC_DocumentLoader_loadFontConfigFile(), SIGNDOC_DocumentLoader_loadFontConfigEnvironment(), SIGNDOC_DocumentLoader_loadFontConfigStream()
 *
 * @memberof SIGNDOC_Document
 *
 * @todo implement for TIFF documents
 */
int SDCAPI
SIGNDOC_Document_addWatermark (struct SIGNDOC_Exception **aEx,
                               struct SIGNDOC_Document *aObj,
                               const struct SIGNDOC_Watermark *aInput);

/**
 * @brief Find text.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in] aEncoding   The encoding of @a aText
 *                        (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                        or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aFirstPage  1-based number of first page to be searched.
 * @param[in] aLastPage   1-based number of last page to be searched or
 *                        0 to search to the end of the document.
 * @param[in] aText       Text to be searched for.
 *                        Multiple successive spaces are treated as
 *                        single space (and may be ignored subject to
 *                        @a aFlags).
 * @param[in] aFlags      Flags modifying the behavior of this function, see
 *                        #SIGNDOC_DOCUMENT_FINDTEXTFLAGS_IGNORE_HSPACE,
 *                        #SIGNDOC_DOCUMENT_FINDTEXTFLAGS_IGNORE_HYPHENATION,
 *                        and #SIGNDOC_DOCUMENT_FINDTEXTFLAGS_IGNORE_SEQUENCE.
 * @param[out] aOutput    The positions where @a aText was found.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK on success (even if the text
 *         was not found).
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_findText (struct SIGNDOC_Exception **aEx,
                           struct SIGNDOC_Document *aObj,
                           int aEncoding, int aFirstPage, int aLastPage,
                           const char *aText, int aFlags,
                           struct SIGNDOC_FindTextPositionArray *aOutput);

/**
 * @brief Add an attachment to the document.
 *
 * Attachments are supported for PDF documents only.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding       The encoding of @a aName and @a aDescription
 *                             (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                             or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aName           The name of the attachment. Will also be
 *                             used as filename of the attachment and must
 *                             not contain slashes, backslashes, and colons.
 * @param[in]  aDescription    The description of the attachment (can be
 *                             empty).
 * @param[in]  aType           The MIME type of the attachment (can be
 *                             empty, seems to be ignored by Adobe Reader).
 * @param[in]  aModificationTime    The time and date of the last
 *                             modification of the file being attached
 *                             to the document (can be empty).  Must be
 *                             in ISO 8601 extended calendar date format
 *                             with optional timezone.
 * @param[in]  aPtr            Pointer to the first octet of the attachment.
 * @param[in]  aSize           The size (in octets) of the attachment.
 * @param[in]  aFlags          Must be zero.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_addAttachmentFile(), SIGNDOC_Document_getAttachments(), SIGNDOC_Document_removeAttachment()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_addAttachmentBlob (struct SIGNDOC_Exception **aEx,
                                    struct SIGNDOC_Document *aObj,
                                    int aEncoding, const char *aName,
                                    const char *aDescription,
                                    const char *aType,
                                    const char *aModificationTime,
                                    const void *aPtr, size_t aSize,
                                    int aFlags);

/**
 * @brief Add an attachment (read from a file) to the document.
 *
 * Attachments are supported for PDF documents only.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding1      The encoding of @a aName and @a aDescription
 *                             (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                             or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aName           The name of the attachment. Will also be
 *                             used as filename of the attachment and must
 *                             not contain slashes, backslashes, and colons.
 * @param[in]  aDescription    The description of the attachment (can be
 *                             empty).
 * @param[in]  aType           The MIME type of the attachment (can be
 *                             empty, seems to be ignored by Adobe Reader).
 * @param[in]  aEncoding2      The encoding of @a aPath
 *                             (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                             or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aPath           The pathname of the file to be attached.
 *                             See @ref winrt_store for restrictions
 *                             on pathnames in Windows Store apps.
 * @param[in]  aFlags          Must be zero.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_addAttachmentBlob(), SIGNDOC_Document_getAttachments(), SIGNDOC_Document_removeAttachment()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_addAttachmentFile (struct SIGNDOC_Exception **aEx,
                                    struct SIGNDOC_Document *aObj,
                                    int aEncoding1, const char *aName,
                                    const char *aDescription,
                                    const char *aType,
                                    int aEncoding2, const char *aPath,
                                    int aFlags);

/**
 * @brief Remove an attachment from the document.
 *
 * Attachments are supported for PDF documents only.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding       The encoding of @a aName
 *                             (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                             or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aName           The name of the attachment.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_addAttachmentBlob(), SIGNDOC_Document_addAttachmentFile(), SIGNDOC_Document_getAttachments()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_removeAttachment (struct SIGNDOC_Exception **aEx,
                                   struct SIGNDOC_Document *aObj,
                                   int aEncoding, const char *aName);

/**
 * @brief Change the description of an attachment of the document.
 *
 * Attachments are supported for PDF documents only.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding       The encoding of @a aName and @a aDescription
 *                             (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                             or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aName           The name of the attachment.
 * @param[in]  aDescription    The new description of the attachment.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_addAttachmentBlob(), SIGNDOC_Document_addAttachmentFile(), SIGNDOC_Document_getAttachments(), SIGNDOC_Document_removeAttachment()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_changeAttachmentDescription (struct SIGNDOC_Exception **aEx,
                                              struct SIGNDOC_Document *aObj,
                                              int aEncoding, const char *aName,
                                              const char *aDescription);

/**
 * @brief Get a list of all attachments of the document.
 *
 * Attachments are supported for PDF documents only.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding  The encoding to be used for the names returned
 *                        in @a aOutput
 *                        (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                        or #SIGNDOC_ENCODING_LATIN_1).
 * @param[out] aOutput    The names of the document's attachments
 *                        will be stored here.  Use
 *                        SIGNDOC_Document_getAttachment()
 *                        to get information for a single attachment.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_checkAttachment(), SIGNDOC_Document_getAttachment(), SIGNDOC_Document_getAttachmentBlob(), SIGNDOC_Document_getAttachmentStream()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getAttachments (struct SIGNDOC_Exception **aEx,
                                 struct SIGNDOC_Document *aObj,
                                 int aEncoding,
                                 struct SIGNDOC_StringArray *aOutput);

/**
 * @brief Get information about an attachment.
 *
 * Attachments are supported for PDF documents only.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding  The encoding of @a aName
 *                        (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                        or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aName      The name of the attachment.
 * @param[out] aOutput    Information about the attachment will be stored
 *                        here.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_checkAttachment(), SIGNDOC_Document_getAttachments(), SIGNDOC_Document_getAttachmentBlob(), SIGNDOC_Document_getAttachmentStream()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getAttachment (struct SIGNDOC_Exception **aEx,
                                struct SIGNDOC_Document *aObj,
                                int aEncoding, const char *aName,
                                struct SIGNDOC_Attachment *aOutput);

/**
 * @brief Check the checksum of an attachment.
 *
 * Attachments are supported for PDF documents only.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding  The encoding of @a aName
 *                        (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                        or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aName      The name of the attachment.
 * @param[out] aOutput    The result of the check will be stored here:
 *                        #SIGNDOC_DOCUMENT_CHECKATTACHMENTRESULT_MATCH,
 *                        #SIGNDOC_DOCUMENT_CHECKATTACHMENTRESULT_NO_CHECKSUM,
 *                        o0r #SIGNDOC_DOCUMENT_CHECKATTACHMENTRESULT_MISMATCH.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_getAttachment(), SIGNDOC_Document_getAttachments(), SIGNDOC_Document_getAttachmentBlob(), SIGNDOC_Document_getAttachmentStream()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_checkAttachment (struct SIGNDOC_Exception **aEx,
                                  struct SIGNDOC_Document *aObj,
                                  int aEncoding, const char *aName,
                                  int *aOutput);

/**
 * @brief Get an attachment as blob.
 *
 * Attachments are supported for PDF documents only.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding  The encoding of @a aName
 *                        (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                        or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aName      The name of the attachment.
 * @param[out] aOutput    The attachment will be stored here.
 *                        The blob must be freed with SIGNDOC_free().
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_checkAttachment(), SIGNDOC_Document_getAttachments(), SIGNDOC_Document_getAttachmentStream()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getAttachmentBlob (struct SIGNDOC_Exception **aEx,
                                    struct SIGNDOC_Document *aObj,
                                    int aEncoding, const char *aName,
                                    struct SIGNDOC_ByteArray *aOutput);

/**
 * @brief Get an InputStream for an attachment.
 *
 * Attachments are supported for PDF documents only.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aEncoding  The encoding of @a aName
 *                        (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                        or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aName      The name of the attachment.
 * @param[out] aOutput    A pointer to a new SIGNDOC_InputStream object will be
 *                        stored here; the caller is responsible for
 *                        deleting that object after use. The
 *                        SIGNDOC_InputStream object
 *                        does not support SIGNDOC_InputStream_seek(),
 *                        SIGNDOC_InputStream_tell(), and
 *                        SIGNDOC_InputStream_avail().
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_checkAttachment(), SIGNDOC_Document_getAttachments(), SIGNDOC_Document_getAttachmentBlob()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_getAttachmentStream (struct SIGNDOC_Exception **aEx,
                                      struct SIGNDOC_Document *aObj,
                                      int aEncoding, const char *aName,
                                      struct SIGNDOC_InputStream **aOutput);

/**
 * @brief Add an empty page to the document.
 *
 * This function is currently implemented for PDF documents only.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aTargetPage  The 1-based number of the page before which
 *                          to insert the new page.  The page will
 *                          be appended if this value is 0.
 * @param[in]  aWidth       The width of the page (in 1/72 inches
 *                          for PDF documents).
 * @param[in]  aHeight      The height of the page (in 1/72 inches
 *                          for PDF documents).
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_addPage (struct SIGNDOC_Exception **aEx,
                          struct SIGNDOC_Document *aObj,
                          int aTargetPage, double aWidth, double aHeight);

/**
 * @brief Import pages from another document.
 *
 * This function is currently implemented for PDF documents only.
 * The pages to be imported must not contain any interactive fields
 * having names that are already used for intercative fields in the
 * target document.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aTargetPage  The 1-based number of the page before which
 *                          to insert the copied pages.  The pages will
 *                          be appended if this value is 0.
 * @param[in]  aSource      The document from which to copy the pages.
 *                          @a aSource can be this.
 * @param[in]  aSourcePage  The 1-based number of the first page (in the
 *                          source document) to be copied.
 * @param[in]  aPageCount   The number of pages to be copied.  All pages
 *                          of @a aSource starting with @a aSourcePage
 *                          will be copied if this value is 0.
 * @param[in]  aFlags       Must be zero.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_importPages (struct SIGNDOC_Exception **aEx,
                              struct SIGNDOC_Document *aObj,
                              int aTargetPage,
                              struct SIGNDOC_Document *aSource,
                              int aSourcePage, int aPageCount, int aFlags);

/**
 * @brief Import a page from a blob containing an image.
 *
 * This function is currently implemented for PDF documents only.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aTargetPage  The 1-based number of the page.
 * @param[in]  aPtr         Pointer to the first octet of the blob containing
 *                          the image.
 *                          Supported formats for inserting into PDF
 *                          documents are: JPEG, PNG, GIF, TIFF, and BMP.
 * @param[in]  aSize        Size (in octets) of the blob pointed to by
 *                          @a aPtr.
 * @param[in]  aZoom        Zoom factor or zero.  If this argument is
 *                          non-zero, @a aWidth and @a aHeight must be
 *                          zero.  The size of the page is computed from
 *                          the image size and resolution, multiplied by
 *                          @a aZoom.
 * @param[in]  aWidth       Image width (document coordinates) or zero.
 *                          If this argument is non-zero, @a aHeight must
 *                          also be non-zero and @a aZoom must be zero.
 *                          The image will be scaled to this width.
 * @param[in]  aHeight      Page height (document coordinates) or zero.
 *                          If this argument is non-zero, @a aWidth must
 *                          also be non-zero and @a aZoom must be zero.
 *                          The image will be scaled to this height.
 * @param[in]  aFlags       Flags modifying the behavior of this function, see
 *                          #SIGNDOC_DOCUMENT_IMPORTIMAGEFLAGS_KEEP_ASPECT_RATIO
 *                          and #SIGNDOC_DOCUMENT_IMPORTIMAGEFLAGS_BRIGHTEST_TRANSPARENT.
 *                          Flag
 *                          #SIGNDOC_DOCUMENT_IMPORTIMAGEFLAGS_KEEP_ASPECT_RATIO
 *                          is not needed if @a aZoom is non-zero.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_addImageFromBlob(), SIGNDOC_Document_importPageFromImageFile()
 *
 * @memberof SIGNDOC_Document
 *
 * @todo multi-page TIFF
 */
int SDCAPI
SIGNDOC_Document_importPageFromImageBlob (struct SIGNDOC_Exception **aEx,
                                          struct SIGNDOC_Document *aObj,
                                          int aTargetPage,
                                          const unsigned char *aPtr,
                                          size_t aSize, double aZoom,
                                          double aWidth, double aHeight,
                                          int aFlags);

/**
 * @brief Import a page from a file containing an image.
 *
 * This function is currently implemented for PDF documents only.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aTargetPage  The 1-based number of the page.
 * @param[in]  aEncoding    The encoding of @a aPath
 *                          (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                          or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aPath        The pathname of the file containing the image.
 *                          Supported formats for inserting into PDF
 *                          documents are: JPEG, PNG, GIF, TIFF, and BMP.
 *                          See @ref winrt_store for restrictions on pathnames
 *                          in Windows Store apps.
 * @param[in]  aZoom        Zoom factor or zero.  If this argument is
 *                          non-zero, @a aWidth and @a aHeight must be
 *                          zero.  The size of the page is computed from
 *                          the image size and resolution, multiplied by
 *                          @a aZoom.
 * @param[in]  aWidth       Image width (document coordinates) or zero.
 *                          If this argument is non-zero, @a aHeight must
 *                          also be non-zero and @a aZoom must be zero.
 *                          The image will be scaled to this width.
 * @param[in]  aHeight      Page height (document coordinates) or zero.
 *                          If this argument is non-zero, @a aWidth must
 *                          also be non-zero and @a aZoom must be zero.
 *                          The image will be scaled to this height.
 * @param[in]  aFlags       Flags modifying the behavior of this function, see
 *                          #SIGNDOC_DOCUMENT_IMPORTIMAGEFLAGS_KEEP_ASPECT_RATIO
 *                          and #SIGNDOC_DOCUMENT_IMPORTIMAGEFLAGS_BRIGHTEST_TRANSPARENT.
 *                          Flag
 *                          #SIGNDOC_DOCUMENT_IMPORTIMAGEFLAGS_KEEP_ASPECT_RATIO
 *                          is not needed if @a aZoom is non-zero.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_importPageFromImageBlob()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_importPageFromImageFile (struct SIGNDOC_Exception **aEx,
                                          struct SIGNDOC_Document *aObj,
                                          int aTargetPage, int aEncoding,
                                          const char *aPath, double aZoom,
                                          double aWidth, double aHeight,
                                          int aFlags);

/**
 * @brief Add an image (from a blob) to a page.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aTargetPage  The 1-based number of the page.
 * @param[in]  aPtr         Pointer to the first octet of the blob containing
 *                          the image.
 *                          Supported formats for inserting into PDF
 *                          documents are: JPEG, PNG, GIF, TIFF, and BMP.
 * @param[in]  aSize        Size (in octets) of the blob pointed to by
 *                          @a aPtr.
 * @param[in]  aZoom        Zoom factor or zero.  If this argument is
 *                          non-zero, @a aWidth and @a aHeight must be
 *                          zero.  The size of the page is computed from
 *                          the image size and resolution, multiplied by
 *                          @a aZoom.
 * @param[in]  aX           The X coordinate of the point at which the
 *                          lower left corner of the image shall be placed.
 * @param[in]  aY           The Y coordinate of the point at which the
 *                          lower left corner of the image shall be placed.
 * @param[in]  aWidth       Image width (document coordinates) or zero.
 *                          The image will be scaled to this width.
 *                          If this argument is non-zero, @a aZoom must
 *                          be zero and either @a aHeight must
 *                          be non-zero or #SIGNDOC_DOCUMENT_IMPORTIMAGEFLAGS_KEEP_ASPECT_RATIO must
 *                          be set in @a aFlags.
 * @param[in]  aHeight      Page height (document coordinates) or zero.
 *                          The image will be scaled to this height.
 *                          If this argument is non-zero, @a aZoom must
 *                          be zero and either @a aWidth must
 *                          be non-zero or #SIGNDOC_DOCUMENT_IMPORTIMAGEFLAGS_KEEP_ASPECT_RATIO must
 *                          be set in @a aFlags.
 * @param[in]  aFlags       Flags modifying the behavior of this function, see
 *                          #SIGNDOC_DOCUMENT_IMPORTIMAGEFLAGS_KEEP_ASPECT_RATIO
 *                          and #SIGNDOC_DOCUMENT_IMPORTIMAGEFLAGS_BRIGHTEST_TRANSPARENT.
 *                          Flag
 *                          #SIGNDOC_DOCUMENT_IMPORTIMAGEFLAGS_KEEP_ASPECT_RATIO
 *                          is not needed if @a aZoom is non-zero.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_importPageFromImageBlob(), SIGNDOC_Document_addImageFromFile()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_addImageFromBlob (struct SIGNDOC_Exception **aEx,
                                   struct SIGNDOC_Document *aObj,
                                   int aTargetPage, const unsigned char *aPtr,
                                   size_t aSize, double aZoom, double aX,
                                   double aY, double aWidth, double aHeight,
                                   int aFlags);

/**
 * @brief Add an image (from a file) to a page.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in]  aTargetPage  The 1-based number of the page.
 * @param[in]  aEncoding    The encoding of @a aPath
 *                          (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                          or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aPath        The pathname of the file containing the image.
 *                          Supported formats for inserting into PDF
 *                          documents are: JPEG, PNG, GIF, TIFF, and BMP.
 *                          See @ref winrt_store for restrictions on pathnames
 *                          in Windows Store apps.
 * @param[in]  aZoom        Zoom factor or zero.  If this argument is
 *                          non-zero, @a aWidth and @a aHeight must be
 *                          zero.  The size of the page is computed from
 *                          the image size and resolution, multiplied by
 *                          @a aZoom.
 * @param[in]  aX           The X coordinate of the point at which the
 *                          lower left corner of the image shall be placed.
 * @param[in]  aY           The Y coordinate of the point at which the
 *                          lower left corner of the image shall be placed.
 * @param[in]  aWidth       Image width (document coordinates) or zero.
 *                          The image will be scaled to this width.
 *                          If this argument is non-zero, @a aZoom must
 *                          be zero and either @a aHeight must
 *                          be non-zero or #SIGNDOC_DOCUMENT_IMPORTIMAGEFLAGS_KEEP_ASPECT_RATIO must
 *                          be set in @a aFlags.
 * @param[in]  aHeight      Page height (document coordinates) or zero.
 *                          The image will be scaled to this height.
 *                          If this argument is non-zero, @a aZoom must
 *                          be zero and either @a aWidth must
 *                          be non-zero or #SIGNDOC_DOCUMENT_IMPORTIMAGEFLAGS_KEEP_ASPECT_RATIO must
 *                          be set in @a aFlags.
 * @param[in]  aFlags       Flags modifying the behavior of this function, see
 *                          #SIGNDOC_DOCUMENT_IMPORTIMAGEFLAGS_KEEP_ASPECT_RATIO
 *                          and #SIGNDOC_DOCUMENT_IMPORTIMAGEFLAGS_BRIGHTEST_TRANSPARENT.
 *                          Flag
 *                          #SIGNDOC_DOCUMENT_IMPORTIMAGEFLAGS_KEEP_ASPECT_RATIO
 *                          is not needed if @a aZoom is non-zero.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_Document_importPageFromImageBlob()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_addImageFromFile (struct SIGNDOC_Exception **aEx,
                                   struct SIGNDOC_Document *aObj,
                                   int aTargetPage, int aEncoding,
                                   const char *aPath, double aZoom,
                                   double aX, double aY,
                                   double aWidth, double aHeight,
                                   int aFlags);

/**
 * @brief Remove pages from the document.
 *
 * A document must have at least page. This function will fail if
 * you attempt to remove all pages.
 *
 * Fields will be removed if all their widgets are on removed pages.
 *
 * Only signatures in signature fields having the #SIGNDOC_FIELD_FLAG_SINGLEPAGE
 * flag set can survive removal of pages.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in] aPagesPtr    Pointer to an array of one-based page numbers.
 *                         The order does not matter, neither does the
 *                         number of occurences of a page number.
 * @param[in] aPagesCount  Number of page numbers pointed to by @a aPagesPtr.
 * @param[in] aMode        Tell this function whether to keep
 *                         (#SIGNDOC_DOCUMENT_KEEPORREMOVE_KEEP) or to
 *                         remove (#SIGNDOC_DOCUMENT_KEEPORREMOVE_REMOVE)
 *                         the pages specified by @a aPagesPtr.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_removePages (struct SIGNDOC_Exception **aEx,
                              struct SIGNDOC_Document *aObj,
                              const int *aPagesPtr, int aPagesCount,
                              int aMode);

/**
 * @brief Request to not make changes to the document which are
 *        incompatible with an older version of this class.
 *
 * No features introduced after @a aMajor.@a aMinor will be used.
 *
 * Passing a version number before 1.11 or after the current version
 * will fail.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in] aMajor  Major version number.
 * @param[in] aMinor  Minor version number.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_setCompatibility (struct SIGNDOC_Exception **aEx,
                                   struct SIGNDOC_Document *aObj,
                                   int aMajor, int aMinor);

/**
 * @brief Check if the document has unsaved changes.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[out] aModified   Will be set to #SIGNDOC_TRUE if the document has
 *                         unsaved changes, will be set to #SIGNDOC_FALSE if
 *                         the document does not have unsaved changes.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_isModified (struct SIGNDOC_Exception **aEx,
                             const struct SIGNDOC_Document *aObj,
                             SIGNDOC_Boolean *aModified);

/**
 * @brief Remove signatures that grant permissions.
 *
 * If you want to modify (beyond adding signature fields, signing
 * signature fields, and filling in form fields) a PDF document that
 * has permissions granted to Adobe Reader by digital signatures,
 * you have to remove those signatures first by calling this
 * function.  That action will remove the permissions for Adobe
 * Reader but enable modifying the document without breaking those
 * signatures.
 *
 * Permissions granted via encryption are not altered by this
 * function.
 *
 * This function is available for PDF documents only.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in] aFlags    Must be 0.
 *
 * @see SIGNDOC_Document_removePDFA(), SIGNDOC_Document_setShootInFoot()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_removePermissions (struct SIGNDOC_Exception **aEx,
                                    struct SIGNDOC_Document *aObj,
                                    unsigned aFlags);

/**
 * @brief Remove PDF/A conformance.
 *
 * Some operations on PDF documents (such as using standard fonts)
 * are not allowed in PDF/A documents. This function turns a PDF/A
 * document into a plain document, enabling those operations.
 *
 * This function is available for PDF documents only.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in] aFlags    Must be 0.
 *
 * @see SIGNDOC_Document_removePermissions()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_removePDFA (struct SIGNDOC_Exception **aEx,
                             struct SIGNDOC_Document *aObj,
                             unsigned aFlags);

/**
 * @brief Disable safety checks.
 *
 * The default value, 0, makes operations fail which would
 * invalidate existing signatures (signature fields) or signatures
 * granting permissions.
 *
 * @note If you set any flags you risk shooting yourself in the foot.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in] aFlags   A set of flags, see
 *                     #SIGNDOC_DOCUMENT_SHOOTINFOOTFLAGS_ALLOW_BREAKING_SIGNATURES,
 *                     #SIGNDOC_DOCUMENT_SHOOTINFOOTFLAGS_ALLOW_BREAKING_PERMISSIONS,
 *                     #SIGNDOC_DOCUMENT_SHOOTINFOOTFLAGS_ALLOW_INVALID_CERTIFICATE,
 *                     #SIGNDOC_DOCUMENT_SHOOTINFOOTFLAGS_ALLOW_NON_STANDARD_EXTERNAL_FONTS.
 *                     #SIGNDOC_DOCUMENT_SHOOTINFOOTFLAGS_ASSUME_AP_NOT_SHARED, and
 *                     #SIGNDOC_DOCUMENT_SHOOTINFOOTFLAGS_ASSUME_AP_SHARED.
 *
 * @see SIGNDOC_Document_removePermissions()
 *
 * @memberof SIGNDOC_Document
 */
int SDCAPI
SIGNDOC_Document_setShootInFoot (struct SIGNDOC_Exception **aEx,
                                 struct SIGNDOC_Document *aObj,
                                 unsigned aFlags);

/**
 * @brief Get an error message for the last function call.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in] aEncoding  The encoding to be used for the error message
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 *
 * @return A pointer to a string describing the reason for the
 *         failure of the last function call. The string is empty
 *         if the last call succeeded. The pointer is valid until
 *         @a aObj is destroyed or a member function of @a aObj
 *         is called.
 *
 * @see SIGNDOC_Document_getErrorMessageW()
 *
 * @memberof SIGNDOC_Document
 */
const char * SDCAPI
SIGNDOC_Document_getErrorMessage (struct SIGNDOC_Exception **aEx,
                                  const struct SIGNDOC_Document *aObj,
                                  int aEncoding);

/**
 * @brief Get an error message for the last function call.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 *
 * @return A pointer to a string describing the reason for the
 *         failure of the last function call. The string is empty
 *         if the last call succeeded. The pointer is valid until
 *         @a aObj is destroyed or a member function of @a aObj
 *         is called.
 *
 * @see SIGNDOC_Document_getErrorMessage()
 *
 * @memberof SIGNDOC_Document
 */
const wchar_t * SDCAPI
SIGNDOC_Document_getErrorMessageW (struct SIGNDOC_Exception **aEx,
                                   const struct SIGNDOC_Document *aObj);

/**
 * @brief Get the underlying SPPDF_Document object.
 *
 * @note Please be careful to not interfere with SignDoc SDK operation.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Document object.
 * @param[in] aDestroy  SIGNDOC_FALSE to let the SIGNDOC_Document object
 *                      pointed to by @a aObj live, SIGNDOC_TRUE to destroy
 *                      the SIGNDOC_Document pointed to by @a aObj.
 *
 * @return A pointer to the underlying SPPDF_Document object or
 *         NULL if the document is not a PDF document.
 *         If @a aDestroy is SIGNDOC_FALSE, do not destroy the
 *         SPPDF_Document object; the SPPDF_Document object is valid until the
 *         SIGNDOC_Document object pointed to by @a aObj is destroyed.
 *         If @a aDestroy is SIGNDOC_TRUE and the return value is not NULL,
 *         you must no longer use the SIGNDOC_Document object pointed to
 *         by @a aObj and you must destroy the SPPDF_Document object
 *         after use.
 *
 *
 * @see SIGNDOC_Document_delete()

 * @memberof SIGNDOC_Document
 */
struct SPPDF_Document * SDCAPI
SIGNDOC_Document_getSPPDFDocument (struct SIGNDOC_Exception **aEx,
                                   struct SIGNDOC_Document *aObj,
                                   SIGNDOC_Boolean aDestroy);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_DocumentLoader constructor.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 *
 * @return A pointer to the new SIGNDOC_DocumentLoader object.
 *
 * @memberof SIGNDOC_DocumentLoader
 */
struct SIGNDOC_DocumentLoader * SDCAPI
SIGNDOC_DocumentLoader_new (struct SIGNDOC_Exception **aEx);

/**
 * @brief SIGNDOC_DocumentLoader destructor.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_DocumentLoader object.
 *
 * @memberof SIGNDOC_DocumentLoader
 */
void SDCAPI
SIGNDOC_DocumentLoader_delete (struct SIGNDOC_DocumentLoader *aObj);

/**
 * @brief Load a document from memory.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_DocumentLoader object.
 * @param[in] aData  Pointer to the first octet of the document.
 *                   This array of octets must live at least as long
 *                   as the returned object unless @a aCopy is SIGNDOC_TRUE.
 * @param[in] aCopy  SIGNDOC_TRUE to make a copy of the array of octets
 *                   pointed to by @a aData.
 * @param[in] aSize  Size of the document (number of octets).
 *
 * @return A pointer to a new SignDocDocument object representing the
 *         document, NULL if the document could not be loaded.
 *         The caller is responsible for destroying the object.
 *
 * @see SIGNDOC_DocumentLoader_getErrorMessage(), SIGNDOC_DocumentLoader_loadFromFile()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
struct SIGNDOC_Document * SDCAPI
SIGNDOC_DocumentLoader_loadFromMemory (struct SIGNDOC_Exception **aEx,
                                       struct SIGNDOC_DocumentLoader *aObj,
                                       const unsigned char *aData, size_t aSize,
                                       SIGNDOC_Boolean aCopy);

/**
 * @brief Load a document from a file.
 *
 * Signing the document will overwrite the document, but see
 * integer parameter "Optimize" of SIGNDOC_SignatureParameters.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_DocumentLoader object.
 * @param[in] aEncoding  The encoding of the string pointed to by @a aPath
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aPath       Pathname of the document file.
 *                        See @ref winrt_store for restrictions on pathnames
 *                        in Windows Store apps.
 * @param[in]  aWritable  Open for writing (used for signing TIFF
 *                        documents in place, ignored for PDF documents).
 *
 * @return A pointer to a new SignDocDocument object representing the
 *         document, NULL if the document could not be loaded.
 *         The caller is responsible for destroying the object.
 *
 * @see SIGNDOC_DocumentLoader_getErrorMessage(), SIGNDOC_DocumentLoader_loadFromMemory(), SIGNDOC_SignatureParameters_setInteger()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
struct SIGNDOC_Document * SDCAPI
SIGNDOC_DocumentLoader_loadFromFile (struct SIGNDOC_Exception **aEx,
                                     struct SIGNDOC_DocumentLoader *aObj,
                                     int aEncoding, const char *aPath,
                                     SIGNDOC_Boolean aWritable);

/**
 * @brief Load a document from a file.
 *
 * Signing the document will overwrite the document, but see
 * integer parameter "Optimize" of SIGNDOC_SignatureParameters.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_DocumentLoader object.
 * @param[in] aPath       Pathname of the document file.
 * @param[in]  aWritable  Open for writing (used for signing TIFF
 *                        documents in place, ignored for PDF documents).
 *
 * @return A pointer to a new SignDocDocument object representing the
 *         document, NULL if the document could not be loaded.
 *         The caller is responsible for destroying the object.
 *
 * @see SIGNDOC_DocumentLoader_getErrorMessage(), SIGNDOC_DocumentLoader_loadFromMemory(), SIGNDOC_SignatureParameters_setInteger()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
struct SIGNDOC_Document * SDCAPI
SIGNDOC_DocumentLoader_loadFromFileW (struct SIGNDOC_Exception **aEx,
                                      struct SIGNDOC_DocumentLoader *aObj,
                                      const wchar_t *aPath,
                                      SIGNDOC_Boolean aWritable);

/**
 * @brief Create an empty PDF document.
 *
 * The PDF document is invalid until you add at least one page.
 * SIGNDOC_Document_addSignature() cannot be used until the document
 * has been saved.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_DocumentLoader object.
 * @param[in] aMajor   Major PDF version, must be 1.
 * @param[in] aMinor   Minor PDF version, must be 0 through 7.
 *
 * @return A pointer to a new SignDocDocument object representing the
 *         document, NULL if the document could not be created.
 *         The caller is responsible for destroying the object.
 *
 * @see SIGNDOC_DocumentLoader_getErrorMessage()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
struct SIGNDOC_Document * SDCAPI
SIGNDOC_DocumentLoader_createPDF (struct SIGNDOC_Exception **aEx,
                                  struct SIGNDOC_DocumentLoader *aObj,
                                  int aMajor, int aMinor);

/**
 * @brief Determine the type of a document.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_DocumentLoader object.
 * @param[in] aStream  A seekable stream for the document.
 *
 * @return The type of the document (#SIGNDOC_DOCUMENT_DOCUMENTTYPE_PDF,
 *         #SIGNDOC_DOCUMENT_DOCUMENTTYPE_TIFF,
 *         #SIGNDOC_DOCUMENT_DOCUMENTTYPE_OTHER,
 *         #SIGNDOC_DOCUMENT_DOCUMENTTYPE_FDF) or
 *         #SIGNDOC_DOCUMENT_DOCUMENTTYPE_UNKNOWN on error.
 *
 * @see SIGNDOC_DocumentLoader_getErrorMessage()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
int SDCAPI
SIGNDOC_DocumentLoader_ping (struct SIGNDOC_Exception **aEx,
                             struct SIGNDOC_DocumentLoader *aObj,
                             struct SIGNDOC_InputStream *aStream);

/**
 * @brief Load font configuration from a file.
 *
 * Suitable fonts are required for putting text containing characters
 * that cannot be encoded using WinAnsiEncoding into text fields,
 * FreeText annotations, DigSig appearances, watermarks, and pages
 * of PDF documents.
 * See section @ref signdocshared_fontconfig.
 *
 * The font configuration applies to all SignDocDocument objects created
 * by @a aObj.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_DocumentLoader object.
 * @param[in] aEncoding  The encoding of the string pointed to by @a aPath.
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aPath  The pathname of the file.
 *                   See @ref winrt_store for restrictions on pathnames
 *                   in Windows Store apps.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @see SIGNDOC_DocumentLoader_getFailedFontFiles(), SIGNDOC_DocumentLoader_loadFontConfigEnvironment(), SIGNDOC_DocumentLoader_loadFontConfigStream()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_DocumentLoader_loadFontConfigFile (struct SIGNDOC_Exception **aEx,
                                           struct SIGNDOC_DocumentLoader *aObj,
                                           int aEncoding, const char *aPath);

/**
 * @brief Load font configuration from a file.
 *
 * Suitable fonts are required for putting text containing characters
 * that cannot be encoded using WinAnsiEncoding into text fields,
 * FreeText annotations, DigSig appearances, watermarks, and pages
 * of PDF documents.
 * See section @ref signdocshared_fontconfig.
 *
 * The font configuration applies to all SignDocDocument objects created
 * by @a aObj.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_DocumentLoader object.
 * @param[in] aPath  The pathname of the file.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @see SIGNDOC_DocumentLoader_getFailedFontFiles(), SIGNDOC_DocumentLoader_loadFontConfigEnvironment(), SIGNDOC_DocumentLoader_loadFontConfigStream()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_DocumentLoader_loadFontConfigFileW (struct SIGNDOC_Exception **aEx,
                                            struct SIGNDOC_DocumentLoader *aObj,
                                            const wchar_t *aPath);

/**
 * @brief Load font configuration from files specified by an environment variable.
 *
 * Suitable fonts are required for putting text containing characters
 * that cannot be encoded using WinAnsiEncoding into text fields,
 * FreeText annotations, DigSig appearances, watermarks, and pages
 * of PDF documents.
 * See section @ref signdocshared_fontconfig.
 *
 * Under Windows, directories are separated by semicolons. Under Unix,
 * directories are separated by colons.
 *
 * The font configuration applies to all SignDocDocument objects created
 * by @a aObj.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_DocumentLoader object.
 * @param[in] aName  The name of the environment variable.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @see SIGNDOC_DocumentLoader_getFailedFontFiles(), SIGNDOC_DocumentLoader_loadFontConfigFile(), SIGNDOC_DocumentLoader_loadFontConfigStream()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_DocumentLoader_loadFontConfigEnvironment (struct SIGNDOC_Exception **aEx,
                                                  struct SIGNDOC_DocumentLoader *aObj,
                                                  const char *aName);

/**
 * @brief Load font configuration from a stream.
 *
 * Suitable fonts are required for putting text containing characters
 * that cannot be encoded using WinAnsiEncoding into text fields,
 * FreeText annotations, DigSig appearances, watermarks, and pages
 * of PDF documents.
 * See section @ref signdocshared_fontconfig.
 *
 * The font configuration applies to all SignDocDocument objects created
 * by @a aObj.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_DocumentLoader object.
 * @param[in] aStream    The font configuration will be read from this stream.
 *                       This function reads the input completely, it doesn't
 *                       stop at the end tag.
 * @param[in] aEncoding  The encoding of the string pointed to
 *                       by @a aDirectory
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aDirectory  If non-NULL, relative font pathnames will be
 *                        relative to this directory. The directory must
 *                        exist and must be readable. If NULL, relative
 *                        font pathnames will make this function fail.
 *                        See @ref winrt_store for restrictions on pathnames
 *                        in Windows Store apps.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @see SIGNDOC_DocumentLoader_getFailedFontFiles(), SIGNDOC_DocumentLoader_loadFontConfigEnvironment(), SIGNDOC_DocumentLoader_loadFontConfigFile()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_DocumentLoader_loadFontConfigStream (struct SIGNDOC_Exception **aEx,
                                             struct SIGNDOC_DocumentLoader *aObj,
                                             struct SIGNDOC_InputStream *aStream, int aEncoding, const char *aDirectory);

/**
 * @brief Load font configuration from a stream.
 *
 * Suitable fonts are required for putting text containing characters
 * that cannot be encoded using WinAnsiEncoding into text fields,
 * FreeText annotations, DigSig appearances, watermarks, and pages
 * of PDF documents.
 * See section @ref signdocshared_fontconfig.
 *
 * The font configuration applies to all SignDocDocument objects created
 * by @a aObj.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_DocumentLoader object.
 * @param[in] aStream  The font configuration will be read from this stream.
 *                     This function reads the input completely, it doesn't
 *                     stop at the end tag.
 * @param[in] aDirectory  If non-NULL, relative font pathnames will be
 *                        relative to this directory. The directory must
 *                        exist and must be readable. If NULL, relative
 *                        font pathnames will make this function fail.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @see SIGNDOC_DocumentLoader_getFailedFontFiles(), SIGNDOC_DocumentLoader_loadFontConfigEnvironment(), SIGNDOC_DocumentLoader_loadFontConfigFile()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_DocumentLoader_loadFontConfigStreamW (struct SIGNDOC_Exception **aEx,
                                              struct SIGNDOC_DocumentLoader *aObj,
                                              struct SIGNDOC_InputStream *aStream, const wchar_t *aDirectory);

/**
 * @brief Load font configuration for PDF documents from a file.
 *
 * Additional fonts may be required for rendering PDF documents.
 * The font configuration for PDF documents contains mappings
 * from font names to font files.
 * See section @ref signdocshared_fontconfig.
 * The "embed" attribute is ignored, substitutions with type="forced"
 * are applied before those with type="fallback".
 *
 * The font configuration for PDF documents is global, ie, it
 * affects all PDF documents, no matter by which
 * SIGNDOC_DocumentLoader object they have been created.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_DocumentLoader object.
 * @param[in] aEncoding  The encoding of the string pointed to by @a aPath
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aPath  The pathname of the file.
 *                   See @ref winrt_store for restrictions on pathnames
 *                   in Windows Store apps.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @see SIGNDOC_DocumentLoader_getFailedFontFiles(), SIGNDOC_DocumentLoader_loadPdfFontConfigEnvironment(), SIGNDOC_DocumentLoader_loadPdfFontConfigStream()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_DocumentLoader_loadPdfFontConfigFile (struct SIGNDOC_Exception **aEx,
                                              struct SIGNDOC_DocumentLoader *aObj,
                                              int aEncoding, const char *aPath);

/**
 * @brief Load font configuration for PDF documents from a file.
 *
 * Additional fonts may be required for rendering PDF documents.
 * The font configuration for PDF documents contains mappings
 * from font names to font files.
 * See section @ref signdocshared_fontconfig.
 * The "embed" attribute is ignored, substitutions with type="forced"
 * are applied before those with type="fallback".
 *
 * The font configuration for PDF documents is global, ie, it
 * affects all PDF documents, no matter by which
 * SIGNDOC_DocumentLoader object they have been created.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_DocumentLoader object.
 * @param[in] aPath  The pathname of the file.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @see getFailedFontFiles(), loadPdfFontConfigEnvironment(), loadPdfFontConfigStream()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_DocumentLoader_loadPdfFontConfigFileW (struct SIGNDOC_Exception **aEx,
                                               struct SIGNDOC_DocumentLoader *aObj,
                                               const wchar_t *aPath);

/**
 * @brief Load font configuration for PDF documents from files
 *        specified by an environment variable.
 *
 * Additional fonts may be required for rendering PDF documents.
 * The font configuration for PDF documents contains mappings
 * from font names to font files.
 * See section @ref signdocshared_fontconfig.
 * The "embed" attribute is ignored, substitutions with type="forced"
 * are applied before those with type="fallback".
 *
 * The font configuration for PDF documents is global, ie, it
 * affects all PDF documents, no matter by which
 * SIGNDOC_DocumentLoader object they have been created.
 *
 * Under Windows, directories are separated by semicolons. Under Unix,
 * directories are separated by colons.
 *
 * See section @ref signdocshared_fontconfig.
 * The "embed" attribute is ignored, substitutions with type="forced"
 * are applied before those with type="fallback".
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_DocumentLoader object.
 * @param[in] aName  The name of the environment variable.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @see SIGNDOC_DocumentLoader_getFailedFontFiles(), SIGNDOC_DocumentLoader_loadPdfFontConfigFile(), SIGNDOC_DocumentLoader_loadPdfFontConfigStream()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_DocumentLoader_loadPdfFontConfigEnvironment (struct SIGNDOC_Exception **aEx,
                                                     struct SIGNDOC_DocumentLoader *aObj,
                                                     const char *aName);

/**
 * @brief Load font configuration for PDF documents from a stream.
 *
 * Additional fonts may be required for rendering PDF documents.
 * The font configuration for PDF documents contains mappings
 * from font names to font files.
 * See section @ref signdocshared_fontconfig.
 * The "embed" attribute is ignored, substitutions with type="forced"
 * are applied before those with type="fallback".
 *
 * The font configuration for PDF documents is global, ie, it
 * affects all PDF documents, no matter by which
 * SIGNDOC_DocumentLoader object they have been created.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_DocumentLoader object.
 * @param[in] aStream    The font configuration will be read from this stream.
 *                       This function reads the input completely, it doesn't
 *                       stop at the end tag.
 * @param[in] aEncoding  The encoding of the string pointed to
 *                       by @a aDirectory
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aDirectory  If non-NULL, relative font pathnames will be
 *                        relative to this directory. The directory must
 *                        exist and must be readable. If NULL, relative
 *                        font pathnames will make this function fail.
 *                        See @ref winrt_store for restrictions on pathnames
 *                        in Windows Store apps.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @see SIGNDOC_DocumentLoader_getFailedFontFiles(), SIGNDOC_DocumentLoader_loadPdfFontConfigEnvironment(), SIGNDOC_DocumentLoader_loadPdfFontConfigFile()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_DocumentLoader_loadPdfFontConfigStream (struct SIGNDOC_Exception **aEx,
                                                struct SIGNDOC_DocumentLoader *aObj,
                                                struct SIGNDOC_InputStream *aStream, int aEncoding, const char *aDirectory);

/**
 * @brief Load font configuration for PDF documents from a stream.
 *
 * Additional fonts may be required for rendering PDF documents.
 * The font configuration for PDF documents contains mappings
 * from font names to font files.
 * See section @ref signdocshared_fontconfig.
 * The "embed" attribute is ignored, substitutions with type="forced"
 * are applied before those with type="fallback".
 *
 * The font configuration for PDF documents is global, ie, it
 * affects all PDF documents, no matter by which
 * SIGNDOC_DocumentLoader object they have been created.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_DocumentLoader object.
 * @param[in] aStream  The font configuration will be read from this stream.
 *                     This function reads the input completely, it doesn't
 *                     stop at the end tag.
 * @param[in] aDirectory  If non-NULL, relative font pathnames will be
 *                        relative to this directory. The directory must
 *                        exist and must be readable. If NULL, relative
 *                        font pathnames will make this function fail.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @see SIGNDOC_DocumentLoader_getFailedFontFiles(), SIGNDOC_DocumentLoader_loadPdfFontConfigEnvironment(), SIGNDOC_DocumentLoader_loadPdfFontConfigFile()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_DocumentLoader_loadPdfFontConfigStreamW (struct SIGNDOC_Exception **aEx,
                                                 struct SIGNDOC_DocumentLoader *aObj,
                                                 struct SIGNDOC_InputStream *aStream, const wchar_t *aDirectory);

/**
 * @brief Get the pathnames of font files that failed to load for
 *        the most recent SIGNDOC_DocumentLoader_loadFontConfig*()
 *        or SIGNDOC_DocumentLoader_loadPdfFontConfig*() call.
 *
 * This includes files that could not be found and files that could
 * not be loaded. In the former case, the pathname may contain
 * wildcard characters.
 *
 * Note that SIGNDOC_DocumentLoader_loadFontConfig*() and
 * SIGNDOC_DocumentLoader_loadPdfFontConfig() no longer fail if a
 * specified font file cannot be found or loaded.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_DocumentLoader object.
 * @param[out] aOutput  The pathnames will be stored here.
 *
 * @see loadFontConfigEnvironment(), loadFontConfigFile(), loadFontConfigStream(), loadPdfFontConfigEnvironment(), loadPdfFontConfigFile(), loadPdfFontConfigStream()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
void SDCAPI
SIGNDOC_DocumentLoader_getFailedFontFiles (struct SIGNDOC_Exception **aEx,
                                           struct SIGNDOC_DocumentLoader *aObj,
                                           struct SIGNDOC_StringArray *aOutput);

/**
 * @brief Initialize logging.
 *
 * This function initializes logging for all threads of the current
 * process. This function takes a pointer to a SIGNDOC_Document object
 * to enable SIGNDOC_Document_getErrorMessage(); the logging
 * configuration is not restricted to the SIGNDOC_DocumentLoader
 * object.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_DocumentLoader object.
 * @param[in] aEncoding  The encoding of the string pointed to by @a aPathname
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aLevel     The logging level: "0" (log nothing) through
 *                       "5" (log everything), optionally followed by "T"
 *                       to log process and thread IDs.
 * @param[in] aPathname  The pathname of the log file.
 *                       See @ref winrt_store for restrictions on pathnames
 *                       in Windows Store apps.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on failure.
 *
 * @see SIGNDOC_DocumentLoader_getErrorMessage()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_DocumentLoader_initLogging (struct SIGNDOC_Exception **aEx,
                                    struct SIGNDOC_DocumentLoader *aObj,
                                    int aEncoding, const char *aLevel,
                                    const char *aPathname);

/**
 * @brief Get an error message for the last SIGNDOC_DocumentLoader_load*()
 *        or SIGNDOC_DocumentLoader_ping() call.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_DocumentLoader object.
 * @param[in] aEncoding  The encoding to be used for the error message
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 *
 * @return A pointer to a string describing the reason for the
 *         failure of the last call of SIGNDOC_DocumentLoader_load*() or
 *         SIGNDOC_DocumentLoader_ping(). The string is empty
 *         if the last call succeeded. The pointer is valid until
 *         @a aObj is destroyed or a member function of @a aObj
 *         is called.
 *
 * @see SIGNDOC_DocumentLoader_getErrorMessageW(), SIGNDOC_DocumentLoader_loadFontConfigEnvironment(), SIGNDOC_DocumentLoader_loadFontConfigFile(), SIGNDOC_DocumentLoader_loadFontConfigStream(), SIGNDOC_DocumentLoader_loadFontConfigStream(), SIGNDOC_DocumentLoader_loadFromFile(), SIGNDOC_DocumentLoader_loadFromMemory(), SIGNDOC_DocumentLoader_loadPdfFontConfigEnvironment(), SIGNDOC_DocumentLoader_loadPdfFontConfigFile(), SIGNDOC_DocumentLoader_loadPdfFontConfigStream(), SIGNDOC_DocumentLoader_ping()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
const char * SDCAPI
SIGNDOC_DocumentLoader_getErrorMessage (struct SIGNDOC_Exception **aEx,
                                        struct SIGNDOC_DocumentLoader *aObj,
                                        int aEncoding);

/**
 * @brief Get an error message for the last SIGNDOC_DocumentLoader_load*()
 *        or SIGNDOC_DocumentLoader_ping() call.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_DocumentLoader object.
 *
 * @return A pointer to a string describing the reason for the
 *         failure of the last call of SIGNDOC_DocumentLoader_load*()
 *         or SIGNDOC_DocumentLoader_ping(). The string is empty
 *         if the last call succeeded. The pointer is valid until
 *         @a aObj is destroyed or a member function of @a aObj
 *         is called.
 *
 * @see SIGNDOC_DocumentLoader_getErrorMessage(), SIGNDOC_DocumentLoader_load(), SIGNDOC_DocumentLoader_ping()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
const wchar_t * SDCAPI
SIGNDOC_DocumentLoader_getErrorMessageW (struct SIGNDOC_Exception **aEx,
                                         struct SIGNDOC_DocumentLoader *aObj);

/**
 * @brief Register a document handler.
 *
 * The behavior is undefined if multiple handlers for the same
 * document type are registered.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_DocumentLoader object.
 * @param[in] aHandler  An instance of a document handler. @a aObj
 *                      takes ownerswhip of the object, do not call
 *                      SIGNDOC_DocumentHandler_delete().
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @memberof SIGNDOC_DocumentLoader
 *
 * @see SIGNDOC_PdfDocumentHandler_new(), SIGNDOC_TiffDocumentHandler_new()
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_DocumentLoader_registerDocumentHandler (struct SIGNDOC_Exception **aEx,
                                                struct SIGNDOC_DocumentLoader *aObj,
                                                struct SIGNDOC_DocumentHandler *aHandler);

/**
 * @brief Initialize license management.
 *
 * License management must be initialized before the non-static
 * methods of SIGNDOC_DocumentLoader can be used.
 *
 * @deprecated Usage of license files is deprecated, please
 *             use a license key, see SIGNDOC_DocumentLoader_setLicenseKey().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aWho1   The first magic number for the product.
 * @param[in] aWho2   The second magic number for the product.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @see SIGNDOC_DocumentLoader_setLicenseKey()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_DocumentLoader_initLicenseManager (struct SIGNDOC_Exception **aEx,
                                           int aWho1, int aWho2);

/**
 * @brief Initialize license management with license key.
 *
 * License management must be initialized before the non-static
 * methods of SIGNDOC_DocumentLoader can be used.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aKeyPtr      Pointer to the first character of the license key.
 * @param[in] aKeySize     Size in octets of the license key, not including
 *                         any terminating NUL character.
 * @param[in] aProduct     Should be NULL.
 * @param[in] aVersion     Should be NULL.
 * @param[in] aTokenPtr    NULL or pointer to the first octet of the token.
 *                         Should be NULL.
 * @param[in] aTokenSize   Size in octets of the token. Should be 0.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @see SIGNDOC_DocumentLoader_generateLicenseToken(), SIGNDOC_DocumentLoader_initLicenseManager()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_DocumentLoader_setLicenseKey (struct SIGNDOC_Exception **aEx,
                                      const void *aKeyPtr, size_t aKeySize,
                                      const char *aProduct,
                                      const char *aVersion,
                                      const void *aTokenPtr,
                                      size_t aTokenSize);

/**
 * @brief Generate a license token for other SDKs also covered
 *        by the license key passed to SIGNDOC_DocumentLoader_setLicenseKey().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aProduct   The name of the product which shall be able to use
 *                       the license key without providing a product version.
 * @param[out] aOutput   The token will be stored here.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @see SIGNDOC_DocumentLoader_setLicenseKey()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_DocumentLoader_generateLicenseToken (struct SIGNDOC_Exception **aEx,
                                             const char *aProduct,
                                             struct SIGNDOC_ByteArray *aOutput);

/**
 * @brief Get the number of days until the license will expire.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in]  aWhat  Select which expiry date shall be used
 *                    (#SIGNDOC_DOCUMENTLOADER_REMAININGDAYS_PRODUCT
 *                    or #SIGNDOC_DOCUMENTLOADER_REMAININGDAYS_SIGNING).
 *
 * @return -1 if the license has already expired or is invalid,
 *         0 if the license will expire today,
 *         a positive value for the number of days the license is
 *         still valid. For licenses without expiry date, that
 *         will be several millions of days.
 *
 * @memberof SIGNDOC_DocumentLoader
 */
int SDCAPI
SIGNDOC_DocumentLoader_getRemainingDays (struct SIGNDOC_Exception **aEx,
                                         int aWhat);

/**
 * @brief Get the installation code needed for creating a license file.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[out] aCode  The installation code will be stored here.
 *                    Only ASCII characters are used.
 *                    The string must be freed with SIGNDOC_free().
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @memberof SIGNDOC_DocumentLoader
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_DocumentLoader_getInstallationCode (struct SIGNDOC_Exception **aEx,
                                            char **aCode);

/**
 * @brief Get the version number of SignDoc SDK.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[out] aVersion  The version number will be stored here.
 *                       It consists of 3 integers separated by
 *                       dots, .e.g.,  "1.16.7"
 *                       The string must be freed with SIGNDOC_free().
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @see SIGNDOC_DocumentLoader_getComponentVersionNumber()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_DocumentLoader_getVersionNumber (struct SIGNDOC_Exception **aEx,
                                         char **aVersion);

/**
 * @brief Get the version number of a SignDoc SDK component.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in]  aComponent  The component. Currently supported are
 *                         "sppdf", "splm2", and "spooc".
 * @param[out] aVersion  The version number will be stored here.
 *                       It consists of 3 or 4 integers separated by
 *                       dots, .e.g.,  "1.9.27.".
 *                       The string must be freed with SIGNDOC_free().
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @see SIGNDOC_DocumentLoader_getVersionNumber()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_DocumentLoader_getComponentVersionNumber (struct SIGNDOC_Exception **aEx,
                                                  const char *aComponent,
                                                  char **aVersion);

/**
 * @brief Get the number of license texts.
 *
 * SignDocSDK includes several Open Source components. You can retrieve
 * the license texts one by one.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 *
 * @return The number of license texts.
 *
 * @see SIGNDOC_DocumentLoader_getLicenseText()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
int SDCAPI
SIGNDOC_DocumentLoader_getLicenseTextCount (struct SIGNDOC_Exception **aEx);

/**
 * @brief Get a license text.
 *
 * SignDocSDK includes several Open Source components. You can retrieve
 * the license texts one by one.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aIndex  The zero-based index of the license text.
 *
 * @return A pointer to the null-terminated license text. Lines are
 *         terminated by LF characters.  If @a aIndex is invalid,
 *         NULL will be returned.
 *
 * @see SIGNDOC_DocumentLoader_getLicenseTextCount()
 *
 * @memberof SIGNDOC_DocumentLoader
 */
const char * SDCAPI
SIGNDOC_DocumentLoader_getLicenseText (struct SIGNDOC_Exception **aEx,
                                       int aIndex);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_Field constructor.
 *
 * The new SIGNDOC_Field object will have one widget.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 *
 * @memberof SIGNDOC_Field
 */
struct SIGNDOC_Field * SDCAPI
SIGNDOC_Field_new (struct SIGNDOC_Exception **aEx);

/**
 * @brief Clone a SIGNDOC_Field object.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aSource  The object to be copied.
 *
 * @memberof SIGNDOC_Field
 */
struct SIGNDOC_Field * SDCAPI
SIGNDOC_Field_clone (struct SIGNDOC_Exception **aEx,
                     const struct SIGNDOC_Field *aSource);

/**
 * @brief SIGNDOC_Field destructor.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Field object,
 *                     must not be a pointer returned by
 *                     SIGNDOC_FieldArray_at().
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_delete (struct SIGNDOC_Field *aObj);

/**
 * @brief SIGNDOC_Field assignment operator.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aSource  The source object.
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_assign (struct SIGNDOC_Exception **aEx,
                      struct SIGNDOC_Field *aObj,
                   const struct SIGNDOC_Field *aSource);

/**
 * @brief Get the name of the field.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the name cannot be
 * represented using the specified encoding.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding to be used for the return value
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 *
 * @return The name of the field.
 *         The string must be freed with SIGNDOC_free().
 *
 * @see SIGNDOC_Field_getAlternateName(), SIGNDOC_Field_getMappingName(), SIGNDOC_Field_getNameUTF8(), SIGNDOC_Field_setName(), SIGNDOC_Field_setNameW()
 *
 * @memberof SIGNDOC_Field
 */
char * SDCAPI
SIGNDOC_Field_getName (struct SIGNDOC_Exception **aEx,
                       struct SIGNDOC_Field *aObj,
                       int aEncoding);

/**
 * @brief Get the name of the field as UTF-8-encoded C string.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return The name of the field.  This pointer will become invalid
 *         when SIGNDOC_Field_setName() or SIGNDOC_Field_setNameW() is
 *         called or @a aObj is destroyed.
 *
 * @memberof SIGNDOC_Field
 */
const char * SDCAPI
SIGNDOC_Field_getNameUTF8 (struct SIGNDOC_Exception **aEx,
                           struct SIGNDOC_Field *aObj);

/**
 * @brief Set the name of the field.
 *
 * Different document types impose different
 * restrictions on field names. PDF fields have hierarchical field names
 * with components separated by dots.
 *
 * SIGNDOC_Document_setField() operates on the
 * field having a fully-qualified name which equals the name set by
 * this function. In consequence, SIGNDOC_Document_setField() cannot
 * change the name of a field.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the name is not correctly
 * encoded according to the specified encoding.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding of @a aName
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aName      The name of the field.
 *
 * @see SIGNDOC_Field_getName(), SIGNDOC_Field_getNameUTF8(), SIGNDOC_Field_setAlternateName(), SIGNDOC_Field_setMappingName(), SIGNDOC_Field_setNameW()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setName (struct SIGNDOC_Exception **aEx,
                       struct SIGNDOC_Field *aObj,
                       int aEncoding, const char *aName);

/**
 * @brief Set the name of the field.
 *
 * Different document types impose different
 * restrictions on field names. PDF fields have hierarchical field names
 * with components separated by dots.
 *
 * SIGNDOC_Document_setField() operates on the
 * field having a fully-qualified name which equals the name set by
 * this function. In consequence, SIGNDOC_Document_setField() cannot
 * change the name of a field.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aName    The name of the field.
 *
 * @see SIGNDOC_Field_getName(), SIGNDOC_Field_getNameUTF8(), SIGNDOC_Field_setAlternateName(), SIGNDOC_Field_setMappingName(), SIGNDOC_Field_setName()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setNameW (struct SIGNDOC_Exception **aEx,
                        struct SIGNDOC_Field *aObj,
                        const wchar_t *aName);

/**
 * @brief Get the alternate name of the field.
 *
 * The alternate name (if present) should be used for displaying the
 * field name in a user interface. Currently, only PDF documents
 * support alternate field names.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the name cannot be
 * represented using the specified encoding.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding to be used for the return value
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 *
 * @return The alternate name of the field, empty if the field
 *         does not have an alternate name.
 *         The string must be freed with SIGNDOC_free().
 *
 * @see SIGNDOC_Field_getMappingName(), SIGNDOC_Field_getName(), SIGNDOC_Field_setAlternateName()
 *
 * @memberof SIGNDOC_Field
 */
char * SDCAPI
SIGNDOC_Field_getAlternateName (struct SIGNDOC_Exception **aEx,
                                struct SIGNDOC_Field *aObj,
                                int aEncoding);

/**
 * @brief Set the alternate name of the field.
 *
 * The alternate name (if present) should be used for displaying the
 * field name in a user interface. Currently, only PDF documents
 * support alternate field names.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the name is not correctly
 * encoded according to the specified encoding.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding of @a aName
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aName      The alternate name of the field, empty to
 *                       remove any alternate field name.
 *
 * @see SIGNDOC_Field_getAlternateName(), SIGNDOC_Field_getName(), SIGNDOC_Field_setMappingName(), SIGNDOC_Field_setName(), SIGNDOC_Field_setNameW()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setAlternateName (struct SIGNDOC_Exception **aEx,
                                struct SIGNDOC_Field *aObj,
                                int aEncoding, const char *aName);

/**
 * @brief Get the mapping name of the field.
 *
 * The mapping name (if present) should be used for exporting field
 * data. Currently, only PDF documents support mapping field names.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the name cannot be
 * represented using the specified encoding.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding to be used for the return value
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 *
 * @return The mapping name of the field, empty if the field
 *         does not have an mapping name.
 *         The string must be freed with SIGNDOC_free().
 *
 * @see SIGNDOC_Field_getAlternateName(), SIGNDOC_Field_getName(), SIGNDOC_Field_setMappingName()
 *
 * @memberof SIGNDOC_Field
 */
char * SDCAPI
SIGNDOC_Field_getMappingName (struct SIGNDOC_Exception **aEx,
                              struct SIGNDOC_Field *aObj,
                              int aEncoding);

/**
 * @brief Set the mapping name of the field.
 *
 * The mapping name (if present) should be used for exporting field
 * data. Currently, only PDF documents support mapping field names.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the name is not correctly
 * encoded according to the specified encoding.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding of @a aName
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aName      The mapping name of the field, empty to
 *                       remove any mapping name.
 *
 * @see SIGNDOC_Field_getMappingName(), SIGNDOC_Field_getName(), SIGNDOC_Field_setAlternateName(), SIGNDOC_Field_setName(), SIGNDOC_Field_setNameW()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setMappingName (struct SIGNDOC_Exception **aEx,
                              struct SIGNDOC_Field *aObj,
                              int aEncoding, const char *aName);

/**
 * @brief Get the number of values of the field.
 *
 * Pushbutton fields and signature fields don't have a value, list
 * boxes can have multiple values selected if
 * #SIGNDOC_FIELD_FLAG_MULTISELECT is set.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return The number of values.
 *
 * @see SIGNDOC_Field_getChoiceCount(), SIGNDOC_Field_getValue()
 *
 * @memberof SIGNDOC_Field
 */
int SDCAPI
SIGNDOC_Field_getValueCount (struct SIGNDOC_Exception **aEx,
                             struct SIGNDOC_Field *aObj);

/**
 * @brief Get a value of the field.
 *
 * Pushbutton fields and signature fields don't have a value, list
 * boxes can have multiple values selected if
 * #SIGNDOC_FIELD_FLAG_MULTISELECT is set.
 *
 * Line breaks for multiline text fields (ie, text fields with flag
 * #SIGNDOC_FIELD_FLAG_MULTILINE set) are encoded as "\r", "\n", or "\r\n".
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the value cannot be
 * represented using the specified encoding.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding to be used for the return value
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aIndex     0-based index of the value.
 *
 * @return The selected value of the field or an empty string
 *         if the index is out of range.
 *         The string must be freed with SIGNDOC_free().
 *
 * @see SIGNDOC_Field_addValue(), SIGNDOC_Field_clearValues(), SIGNDOC_Field_getChoiceExport(), SIGNDOC_Field_getChoiceValue(), SIGNDOC_Field_getValueCount(), SIGNDOC_Field_getValueIndex(), SIGNDOC_Field_getValueUTF8(), SIGNDOC_Field_removeValue(), SIGNDOC_Field_setValue()
 *
 * @memberof SIGNDOC_Field
 */
char * SDCAPI
SIGNDOC_Field_getValue (struct SIGNDOC_Exception **aEx,
                        struct SIGNDOC_Field *aObj,
                        int aEncoding, int aIndex);

/**
 * @brief Get a value of the field.
 *
 * Pushbutton fields and signature fields don't have a value, list
 * boxes can have multiple values selected if
 * #SIGNDOC_FIELD_FLAG_MULTISELECT is set.
 *
 * Line breaks for multiline text fields (ie, text fields with flag
 * #SIGNDOC_FIELD_FLAG_MULTILINE set) are encoded as "\r", "\n", or "\r\n".
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex     0-based index of the value.
 *
 * @return The selected value of the field or an empty string
 *         if the index is out of range.  This pointer will become invalid
 *         when SIGNDOC_Field_addValue(), SIGNDOC_Field_clearValues(),
 *         SIGNDOC_Field_removeValue(), or SIGNDOC_Field_setValue()
 *         is called or @a aObj is destroyed.
 *
 * @see SIGNDOC_Field_addValue(), SIGNDOC_Field_clearValues(), SIGNDOC_Field_getValue(), SIGNDOC_Field_getValueCount(), SIGNDOC_Field_getValueIndex(), SIGNDOC_Field_setValue()
 *
 * @memberof SIGNDOC_Field
 */
const char * SDCAPI
SIGNDOC_Field_getValueUTF8 (struct SIGNDOC_Exception **aEx,
                            struct SIGNDOC_Field *aObj,
                            int aIndex);

/**
 * @brief Clear the values.
 *
 * After calling this function, SIGNDOC_Field_getValueCount() will return 0
 * and SIGNDOC_Field_getValueIndex() will return -1.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @see SIGNDOC_Field_addValue(), SIGNDOC_Field_getValueCount(), SIGNDOC_Field_getValueIndex(), SIGNDOC_Field_removeValue()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_clearValues (struct SIGNDOC_Exception **aEx,
                           struct SIGNDOC_Field *aObj);

/**
 * @brief Add a value to the field.
 *
 * Pushbutton fields and signature fields don't have a value, list
 * boxes can have multiple values selected if
 * #SIGNDOC_FIELD_FLAG_MULTISELECT is set.
 *
 * Line breaks for multiline text fields (ie, text fields with flag
 * #SIGNDOC_FIELD_FLAG_MULTILINE set) are encoded as "\r", "\n", or "\r\n".
 * The behavior for values containing line breaks is undefined if the
 * #SIGNDOC_FIELD_FLAG_MULTILINE flag is not set.
 *
 * After calling this function, SIGNDOC_Field_getValueIndex() will return -1.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the value is not correctly
 * encoded according to the specified encoding.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding of @a aValue
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aValue     The value to be added.
 *                       Complex scripts are supported,
 *                       see @ref signdocshared_complex_scripts.
 *
 * @see SIGNDOC_Field_clearValues(), SIGNDOC_Field_getValue(), SIGNDOC_Field_getValueIndex(), SIGNDOC_Field_getValueUTF8(), SIGNDOC_Field_setValue()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_addValue (struct SIGNDOC_Exception **aEx,
                        struct SIGNDOC_Field *aObj,
                        int aEncoding, const char *aValue);

/**
 * @brief Set a value of the field.
 *
 * Pushbutton fields and signature fields don't have a value, list
 * boxes can have multiple values selected if
 * #SIGNDOC_FIELD_FLAG_MULTISELECT is set.
 *
 * After calling this function, SIGNDOC_Field_getValueIndex() will return -1.
 *
 * Line breaks for multiline text fields (ie, text fields with flag
 * #SIGNDOC_FIELD_FLAG_MULTILINE set) are encoded as "\r", "\n", or "\r\n".
 * The behavior for values containing line breaks is undefined if the
 * #SIGNDOC_FIELD_FLAG_MULTILINE flag is not set.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the value is not correctly
 * encoded according to the specified encoding.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex     The 0-based index of the value to be set.
 *                       If @a aIndex equals the current number of
 *                       values, the value will be added.
 * @param[in] aEncoding  The encoding of @a aValue
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aValue     The value to be set. Complex scripts are supported,
 *                       see @ref signdocshared_complex_scripts.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if @a aIndex is out of range.
 *
 * @see SIGNDOC_Field_clearValues(), SIGNDOC_Field_clickButton(), SIGNDOC_Field_getValue(), SIGNDOC_Field_getValueIndex(), SIGNDOC_Field_getValueUTF8(), SIGNDOC_Field_setValueIndex()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_setValueByIndex (struct SIGNDOC_Exception **aEx,
                               struct SIGNDOC_Field *aObj,
                               int aIndex, int aEncoding, const char *aValue);

/**
 * @brief Set the value of the field.
 *
 * Pushbutton fields and signature fields don't have a value, list
 * boxes can have multiple values selected if
 * #SIGNDOC_FIELD_FLAG_MULTISELECT is set.
 *
 * Line breaks for multiline text fields (ie, text fields with flag
 * #SIGNDOC_FIELD_FLAG_MULTILINE set) are encoded as "\r", "\n", or "\r\n".
 * The behavior for values containing line breaks is undefined if the
 * #SIGNDOC_FIELD_FLAG_MULTILINE flag is not set.
 *
 * Calling this function is equivalent to calling
 * SIGNDOC_Field_clearValues() and SIGNDOC_Field_addValue(), but the
 * encoding of @a aValue is checked before modifying @a aObj.
 *
 * After calling this function, SIGNDOC_Field_getValueIndex() will return -1.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the value is not correctly
 * encoded according to the specified encoding.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding of @a aValue
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aValue     The value to be set. Complex scripts are supported,
 *                       see @ref signdocshared_complex_scripts.
 *
 * @see SIGNDOC_Field_clearValues(), SIGNDOC_Field_clickButton(), SIGNDOC_Field_getValue(), SIGNDOC_Field_getValueIndex(), SIGNDOC_Field_getValueUTF8(), SIGNDOC_Field_setValueIndex()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setValue (struct SIGNDOC_Exception **aEx,
                        struct SIGNDOC_Field *aObj,
                        int aEncoding, const char *aValue);

/**
 * @brief Remove a value from the field.
 *
 * After calling this function, SIGNDOC_Field_getValueIndex() will return -1.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex     The 0-based index of the value to be removed.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if @a aIndex is out of range.
 *
 * @see SIGNDOC_Field_clearValues(), SIGNDOC_Field_getValue(), SIGNDOC_Field_getValueIndex(), SIGNDOC_Field_getValueUTF8()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_removeValue (struct SIGNDOC_Exception **aEx,
                           struct SIGNDOC_Field *aObj,
                           int aIndex);

/**
 * @brief Get the current value index.
 *
 * Radio button groups and check box fields can have multiple
 * widgets having the same button value. For check box fields
 * and radio buttons without #SIGNDOC_FIELD_FLAG_RADIOSINUNISON set, specifying
 * the selected button by value string is not possible in that
 * case. A 0-based value index can be used to find out which
 * button is selected or to select a button.
 *
 * Radio button groups and check box fields need not use a value
 * index; in fact, they usually don't.
 *
 * SIGNDOC_Document_addField() and SIGNDOC_Document_setField()
 * update the value index if the value of a radio button group
 * or check box field is selected by string (ie, SIGNDOC_Document_setValue())
 * and the field has ambiguous button names.
 *
 * The "Off" value never has a value index.
 *
 * @note SIGNDOC_Document_addValue(), SIGNDOC_Document_clearValues(),
 *       and SIGNDOC_Document_setValue() make the value index unset
 *       (ie, SIGNDOC_Document_getValueIndex() will return -1).
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return the 0-based value index or -1 if the value index is not set.
 *
 * @see SIGNDOC_Field_clickButton(), SIGNDOC_Field_getValue(), SIGNDOC_Field_setValueIndex()
 *
 * @memberof SIGNDOC_Field
 */
int SDCAPI
SIGNDOC_Field_getValueIndex (struct SIGNDOC_Exception **aEx,
                             struct SIGNDOC_Field *aObj);

/**
 * @brief Set the value index.
 *
 * Radio button groups and check box fields can have multiple
 * widgets having the same button value. For check box fields
 * and radio buttons without #SIGNDOC_FIELD_FLAG_RADIOSINUNISON set, specifying
 * the selected button by value string is ambiguous in that
 * case. A 0-based value index can be used to find out which
 * button is selected or to select a button.
 *
 * Radio button groups and check box fields need not use a value
 * index; in fact, they usually don't. However, you can always
 * set a value index for radio button groups and check box fields.
 *
 * If the value index is non-negative, SIGNDOC_Document_addField()
 * and SIGNDOC_Document_setField() will use the value index instead
 * of the string value set by SIGNDOC_Field_setValue().
 *
 * Calling SIGNDOC_Field_setValueIndex() doesn't affect the return value of
 * SIGNDOC_Field_getValue() as the value index is used by
 * SIGNDOC_Document_addField() and SIGNDOC_Document_setField()
 * only. However, successful calls to SIGNDOC_Document_addField()
 * and SIGNDOC_Document_setField() will make SIGNDOC_Field_getValue() return the
 * selected value.
 *
 * For radio button groups with #SIGNDOC_FIELD_FLAG_RADIOSINUNISON set
 * and non-unique button values and for check box fields with
 * non-unique button values, for each button value, the lowest index
 * having that button value is the canonical one. After calling
 * SIGNDOC_Document_addField() or SIGNDOC_Document_setField(),
 * getValueIndex() will return the canonical value index.
 *
 * Don't forget to update the value index when adding or removing
 * widgets!
 *
 * SIGNDOC_Document_addField() and SIGNDOC_Document_setField() will
 * fail if the value index is non-negative for fields other than
 * radio button groups and check box fields.
 *
 * The "Off" value never has a value index.
 *
 * @note addValue(), clearValues(), and SIGNDOC_Field_setValue() make the value index
 *       unset (ie, getValueIndex() will return -1). Therefore, you
 *       don't have to call setValueIndex(-1) to make SIGNDOC_Field_setValue() take
 *       effect on SIGNDOC_Document_addField() and
 *       SIGNDOC_Document_setField().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex  the 0-based value index or -1 to make the value
 *                    index unset.
 *
 * @see SIGNDOC_Field_clickButton(), SIGNDOC_Field_getValue(), SIGNDOC_Field_getValueIndex(), SIGNDOC_Field_setValue()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setValueIndex (struct SIGNDOC_Exception **aEx,
                             struct SIGNDOC_Field *aObj,
                             int aIndex);

/**
 * @brief Click a check box or a radio button.
 *
 * This function updates both the value (see SIGNDOC_Field_setValue()) and the
 * value index (see SIGNDOC_Field_setValueIndex()) based on the current
 * (non-committed) state of the SIGNDOC_Field object (not looking at
 * the state of the field in the document). It does nothing for
 * other field types.
 *
 * Adobe products seem to ignore #SIGNDOC_FIELD_FLAG_NOTOGGLETOOFF flag
 * being not set, this function behaves the same way (ie, as if
 * #SIGNDOC_FIELD_FLAG_NOTOGGLETOOFF was set).
 *
 * @note A return value of #SIGNDOC_FALSE does not indicate an error!
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex  The 0-based index of the widget being clicked.
 *
 * @return #SIGNDOC_TRUE if anything has been changed, #SIGNDOC_FALSE if nothing
 *         has been changed (wrong field type, @a aIndex out of
 *         range, radio button already active).
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_clickButton (struct SIGNDOC_Exception **aEx,
                           struct SIGNDOC_Field *aObj,
                           int aIndex);

/**
 * @brief Get the number of available choices for a list box or combo box.
 *
 * List boxes and combo boxes can have multiple possible choices.
 * For other field types, this function returns 0.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return The number of available choices or 0 if not supported for
 *         the type of this field.
 *
 * @see SIGNDOC_Field_getButtonValue(), SIGNDOC_Field_getChoiceExport(), SIGNDOC_Field_getChoiceValue(), SIGNDOC_Field_getValueCount()
 *
 * @memberof SIGNDOC_Field
 */
int SDCAPI
SIGNDOC_Field_getChoiceCount (struct SIGNDOC_Exception **aEx,
                              struct SIGNDOC_Field *aObj);

/**
 * @brief Get an available choice of a list box or combo box.
 *
 * List boxes and combo boxes can have multiple possible
 * choices. Each choice has a value (which will be displayed) and an
 * export value (which is used for exporting the value of the
 * field). Usually, both values are identical. This function returns
 * one choice value, use SIGNDOC_Field_getChoiceExport() to get the
 * associated export value.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the value cannot be
 * represented using the specified encoding.
 *
 * @note SIGNDOC_Field_getValue() and SIGNDOC_Field_setValue() use the export value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding to be used for the return value
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aIndex     0-based index of the choice value.
 *
 * @return The selected choice value of the field or an empty string
 *         if the index is out of range.
 *         The string must be freed with SIGNDOC_free().
 *
 * @see SIGNDOC_Field_addChoice(), SIGNDOC_Field_clearChoices(), SIGNDOC_Field_getChoiceExport(), SIGNDOC_Field_getChoiceValueUTF8(), SIGNDOC_Field_getChoiceCount(), SIGNDOC_Field_getButtonValue(), SIGNDOC_Field_removeChoice(), SIGNDOC_Field_setChoice()
 *
 * @memberof SIGNDOC_Field
 */
char * SDCAPI
SIGNDOC_Field_getChoiceValue (struct SIGNDOC_Exception **aEx,
                              struct SIGNDOC_Field *aObj,
                              int aEncoding, int aIndex);

/**
 * @brief Get an available choice of a list box or combo box.
 *
 * List boxes and combo boxes can have multiple possible
 * choices. Each choice has a value (which will be displayed) and an
 * export value (which is used for exporting the value of the
 * field). Usually, both values are identical. This function returns
 * one choice value, use SIGNDOC_Field_getChoiceExportUTF8() to get
 * the associated export value.
 *
 * @note SIGNDOC_Field_getValue() and SIGNDOC_Field_setValue() use the
 *       export value.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex     0-based index of the choice value.
 *
 * @return The selected choice value of the field or an empty string
 *         if the index is out of range.  This pointer will become
 *         invalid when SIGNDOC_Field_addChoice(),
 *         SIGNDOC_Field_clearChoices(),
 *         SIGNDOC_Field_removeChoice(), or SIGNDOC_Field_setChoice()
 *         is called or @a aObj is destroyed.
 *
 * @see SIGNDOC_Field_addChoice(), SIGNDOC_Field_clearChoices(), SIGNDOC_Field_getChoiceCount(), SIGNDOC_Field_getChoiceExportUTF8(), SIGNDOC_Field_getChoiceValue(), SIGNDOC_Field_getButtonValueUTF8(), SIGNDOC_Field_setChoice()
 *
 * @memberof SIGNDOC_Field
 */
const char * SDCAPI
SIGNDOC_Field_getChoiceValueUTF8 (struct SIGNDOC_Exception **aEx,
                                  struct SIGNDOC_Field *aObj,
                                  int aIndex);

/**
 * @brief Get the export value for an available choice of a list box
 *        or combo box.
 *
 * List boxes and combo boxes can have multiple possible
 * choices. Each choice has a value (which will be displayed) and an
 * export value (which is used for exporting the value of the
 * field).  Usually, both values are identical. This function
 * returns one export value, use SIGNDOC_Field_getChoiceValue() to get the
 * associated choice value.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the value cannot be
 * represented using the specified encoding.
 *
 * @note SIGNDOC_Field_getValue() and SIGNDOC_Field_setValue() use the export value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding to be used for the return value
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aIndex     0-based index of the export value.
 *
 * @return The selected export value of the field or an empty string
 *         if the index is out of range.
 *         The string must be freed with SIGNDOC_free().
 *
 * @see SIGNDOC_Field_addChoice(), SIGNDOC_Field_clearChoices(), SIGNDOC_Field_getChoiceCount(), SIGNDOC_Field_getChoiceExportUTF8(), SIGNDOC_Field_getChoiceValue(), SIGNDOC_Field_getButtonValue(), SIGNDOC_Field_removeChoice(), SIGNDOC_Field_setChoice()
 *
 * @memberof SIGNDOC_Field
 */
char * SDCAPI
SIGNDOC_Field_getChoiceExport (struct SIGNDOC_Exception **aEx,
                               struct SIGNDOC_Field *aObj,
                               int aEncoding, int aIndex);

/**
 * @brief Get the export value for an available choice of a list box
 *        or combo box.
 *
 * List boxes and combo boxes can have multiple possible
 * choices. Each choice has a value (which will be displayed) and an
 * export value (which is used for exporting the value of the
 * field).  Usually, both values are identical. This function
 * returns one export value, use SIGNDOC_Field_getChoiceValue() to get the
 * associated choice value.
 *
 * @note SIGNDOC_Field_getValue() and SIGNDOC_Field_setValue() use the
 *       export value.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex     0-based index of the choice value.
 *
 * @return The selected export value of the field or an empty string
 *         if the index is out of range.  This pointer will become
 *         invalid when SIGNDOC_Field_addChoice(), SIGNDOC_Field_clearChoices(),
 *         SIGNDOC_Field_removeChoice(), or SIGNDOC_Field_setChoice() is
 *         called or @a aObj is destroyed.
 *
 * @see SIGNDOC_Field_addChoice(), SIGNDOC_Field_clearChoices(), SIGNDOC_Field_getChoiceCount(), SIGNDOC_Field_getChoiceExport(), SIGNDOC_Field_getChoiceValueUTF8(), SIGNDOC_Field_getButtonValueUTF8(), SIGNDOC_Field_setChoice()
 *
 * @memberof SIGNDOC_Field
 */
const char * SDCAPI
SIGNDOC_Field_getChoiceExportUTF8 (struct SIGNDOC_Exception **aEx,
                                   struct SIGNDOC_Field *aObj,
                                   int aIndex);

/**
 * @brief Clear the choices of a list box or combo box.
 *
 * After calling this function, SIGNDOC_Field_getChoiceCount() will return 0.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @see SIGNDOC_Field_addChoice(), SIGNDOC_Field_getChoiceCount(), SIGNDOC_Field_removeChoice(), SIGNDOC_Field_setButtonValue()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_clearChoices (struct SIGNDOC_Exception **aEx,
                            struct SIGNDOC_Field *aObj);

/**
 * @brief Add a choice to a list box or combo box.
 *
 * This function uses the choice value as export value.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the value is not correctly
 * encoded according to the specified encoding.
 *
 * @note SIGNDOC_Field_getValue() and SIGNDOC_Field_setValue() use the
 *       export value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding of @a aValue
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aValue     The choice value and export value to be added.
 *                       Complex scripts are supported,
 *                       see @ref signdocshared_complex_scripts.
 *
 * @see SIGNDOC_Field_clearChoices(), SIGNDOC_Field_getChoiceExport(), SIGNDOC_Field_getChoiceValue(), SIGNDOC_Field_setChoice(), SIGNDOC_Field_setButtonValue()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_addChoice (struct SIGNDOC_Exception **aEx,
                         struct SIGNDOC_Field *aObj,
                         int aEncoding, const char *aValue);

/**
 * @brief Add a choice to a list box or combo box.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the value is not correctly
 * encoded according to the specified encoding.
 *
 * @note SIGNDOC_Field_getValue() and SIGNDOC_Field_setValue() use the
 *       export value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding of @a aValue and @a aExport
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aValue     The choice value to be added.
 *                       Complex scripts are supported,
 *                       see @ref signdocshared_complex_scripts.
 * @param[in] aExport    The export value to be added.
 *
 * @see SIGNDOC_Field_clearChoices(), SIGNDOC_Field_getChoiceExport(), SIGNDOC_Field_getChoiceValue(), SIGNDOC_Field_setChoice(), SIGNDOC_Field_setButtonValue()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_addChoiceWithExport (struct SIGNDOC_Exception **aEx,
                                   struct SIGNDOC_Field *aObj,
                                   int aEncoding, const char *aValue, const char *aExport);

/**
 * @brief Set a choice value of a list box or combo box.
 *
 * This function uses the choice value as export value.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the value is not correctly
 * encoded according to the specified encoding.
 *
 * @note SIGNDOC_Field_getValue() and SIGNDOC_Field_setValue() use the
 *       export value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex     The 0-based index of the choice to be set.
 *                       If @a aIndex equals the current number of
 *                       choice, the value will be added.
 * @param[in] aEncoding  The encoding of @a aValue
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aValue     The choice value and export value to be set.
 *                       Complex scripts are supported,
 *                       see @ref signdocshared_complex_scripts.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if @a aIndex is out of range.
 *
 * @see SIGNDOC_Field_clearChoices(), SIGNDOC_Field_getChoiceExport(), SIGNDOC_Field_getChoiceValue(), SIGNDOC_Field_setButtonValue()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_setChoice (struct SIGNDOC_Exception **aEx,
                         struct SIGNDOC_Field *aObj,
                         int aIndex, int aEncoding, const char *aValue);

/**
 * @brief Set a choice value of a list box or combo box.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the value is not correctly
 * encoded according to the specified encoding.
 *
 * @note SIGNDOC_Field_getValue() and SIGNDOC_Field_setValue() use the
 *       export value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex     The 0-based index of the choice to be set.
 *                       If @a aIndex equals the current number of
 *                       choice, the value will be added.
 * @param[in] aEncoding  The encoding of @a aValue and @a aExport
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aValue     The choice value to be set.
 *                       Complex scripts are supported,
 *                       see @ref signdocshared_complex_scripts.
 * @param[in] aExport    The export value to be set.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if @a aIndex is out of range.
 *
 * @see SIGNDOC_Field_clearChoices(), SIGNDOC_Field_getChoiceExport(), SIGNDOC_Field_getChoiceValue(), SIGNDOC_Field_setButtonValue()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_setChoiceWithExport (struct SIGNDOC_Exception **aEx,
                                   struct SIGNDOC_Field *aObj,
                                   int aIndex, int aEncoding,
                                   const char *aValue, const char *aExport);

/**
 * @brief Remove a choice from a list box or combo box.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex     The 0-based index of the choice to be removed.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if @a aIndex is
 *         out of range.
 *
 * @see SIGNDOC_Field_addChoice(), SIGNDOC_Field_clearChoices()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_removeChoice (struct SIGNDOC_Exception **aEx,
                            struct SIGNDOC_Field *aObj,
                            int aIndex);

/**
 * @brief Get the type of the field.
 *
 * The default value is #SIGNDOC_FIELD_TYPE_UNKNOWN.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return The type of the field:
 *         #SIGNDOC_FIELD_TYPE_UNKNOWN, #SIGNDOC_FIELD_TYPE_PUSHBUTTON,
 *         #SIGNDOC_FIELD_TYPE_CHECK_BOX, #SIGNDOC_FIELD_TYPE_RADIO_BUTTON,
 *         #SIGNDOC_FIELD_TYPE_TEXT, #SIGNDOC_FIELD_TYPE_LIST_BOX,
 *         #SIGNDOC_FIELD_TYPE_SIGNATURE_DIGSIG,
 *         #SIGNDOC_FIELD_TYPE_SIGNATURE_SIGNDOC, or
 *         #SIGNDOC_FIELD_TYPE_COMBO_BOX.
 *
 * @see SIGNDOC_Field_setType()
 *
 * @memberof SIGNDOC_Field
 */
int SDCAPI
SIGNDOC_Field_getType (struct SIGNDOC_Exception **aEx,
                       struct SIGNDOC_Field *aObj);

/**
 * @brief Set the type of the field.
 *
 * The default value is #SIGNDOC_FIELD_TYPE_UNKNOWN.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aType    The type of the field:
 *                     #SIGNDOC_FIELD_TYPE_PUSHBUTTON,
 *                     #SIGNDOC_FIELD_TYPE_CHECK_BOX,
 *                     #SIGNDOC_FIELD_TYPE_RADIO_BUTTON,
 *                     #SIGNDOC_FIELD_TYPE_TEXT,
 *                     #SIGNDOC_FIELD_TYPE_LIST_BOX,
 *                     #SIGNDOC_FIELD_TYPE_SIGNATURE_DIGSIG,
 *                     #SIGNDOC_FIELD_TYPE_SIGNATURE_SIGNDOC, or
 *                     #SIGNDOC_FIELD_TYPE_COMBO_BOX.
 *
 * @see SIGNDOC_Field_getType()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setType (struct SIGNDOC_Exception **aEx,
                       struct SIGNDOC_Field *aObj,
                       int aType);

/**
 * @brief Get the flags of the field.
 *
 * The default value is 0.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return The flags of the field:
 *         #SIGNDOC_FIELD_FLAG_READONLY,
 *         #SIGNDOC_FIELD_FLAG_REQUIRED,
 *         #SIGNDOC_FIELD_FLAG_NOEXPORT,
 *         #SIGNDOC_FIELD_FLAG_NOTOGGLETOOFF,
 *         #SIGNDOC_FIELD_FLAG_RADIO,
 *         #SIGNDOC_FIELD_FLAG_PUSHBUTTON,
 *         #SIGNDOC_FIELD_FLAG_RADIOSINUNISON,
 *         #SIGNDOC_FIELD_FLAG_MULTILINE,
 *         #SIGNDOC_FIELD_FLAG_PASSWORD,
 *         #SIGNDOC_FIELD_FLAG_FILESELECT,
 *         #SIGNDOC_FIELD_FLAG_DONOTSPELLCHECK,
 *         #SIGNDOC_FIELD_FLAG_DONOTSCROLL,
 *         #SIGNDOC_FIELD_FLAG_COMB,
 *         #SIGNDOC_FIELD_FLAG_RICHTEXT,
 *         #SIGNDOC_FIELD_FLAG_COMBO,
 *         #SIGNDOC_FIELD_FLAG_EDIT,
 *         #SIGNDOC_FIELD_FLAG_SORT,
 *         #SIGNDOC_FIELD_FLAG_MULTISELECT,
 *         #SIGNDOC_FIELD_FLAG_COMMITONSELCHANGE,
 *         #SIGNDOC_FIELD_FLAG_SINGLEPAGE,
 *         #SIGNDOC_FIELD_FLAG_ENABLEADDAFTERSIGNING, and
 *         #SIGNDOC_FIELD_FLAG_INVISIBLE.
 *
 * @see SIGNDOC_Field_setFlags()
 *
 * @memberof SIGNDOC_Field
 */
int SDCAPI
SIGNDOC_Field_getFlags (struct SIGNDOC_Exception **aEx,
                        struct SIGNDOC_Field *aObj);

/**
 * @brief Set the flags of the field.
 *
 * The default value is 0.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aFlags   The flags of the field:
 *                     #SIGNDOC_FIELD_FLAG_READONLY,
 *                     #SIGNDOC_FIELD_FLAG_REQUIRED,
 *                     #SIGNDOC_FIELD_FLAG_NOEXPORT,
 *                     #SIGNDOC_FIELD_FLAG_NOTOGGLETOOFF,
 *                     #SIGNDOC_FIELD_FLAG_RADIO,
 *                     #SIGNDOC_FIELD_FLAG_PUSHBUTTON,
 *                     #SIGNDOC_FIELD_FLAG_RADIOSINUNISON,
 *                     #SIGNDOC_FIELD_FLAG_MULTILINE,
 *                     #SIGNDOC_FIELD_FLAG_PASSWORD,
 *                     #SIGNDOC_FIELD_FLAG_FILESELECT,
 *                     #SIGNDOC_FIELD_FLAG_DONOTSPELLCHECK,
 *                     #SIGNDOC_FIELD_FLAG_DONOTSCROLL,
 *                     #SIGNDOC_FIELD_FLAG_COMB,
 *                     #SIGNDOC_FIELD_FLAG_RICHTEXT,
 *                     #SIGNDOC_FIELD_FLAG_COMBO,
 *                     #SIGNDOC_FIELD_FLAG_EDIT,
 *                     #SIGNDOC_FIELD_FLAG_SORT,
 *                     #SIGNDOC_FIELD_FLAG_MULTISELECT,
 *                     #SIGNDOC_FIELD_FLAG_COMMITONSELCHANGE,
 *                     #SIGNDOC_FIELD_FLAG_SINGLEPAGE,
 *                     #SIGNDOC_FIELD_FLAG_ENABLEADDAFTERSIGNING, and
 *                     #SIGNDOC_FIELD_FLAG_INVISIBLE.
 *
 * @see SIGNDOC_Field_getFlags()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setFlags (struct SIGNDOC_Exception **aEx,
                        struct SIGNDOC_Field *aObj,
                        int aFlags);

/**
 * @brief Check if this field is a signed signature field.
 *
 * This function is much more efficient than
 * SIGNDOC_Document_verifySignature().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return #SIGNDOC_TRUE if this field is a signed signature field,
 *         #SIGNDOC_FALSE if this field is not a signature field or if this
 *         field is a signature field that is not signed.
 *
 * @see SIGNDOC_Document_verifySignature()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_isSigned (struct SIGNDOC_Exception **aEx,
                        const struct SIGNDOC_Field *aObj);

/**
 * @brief Check if this signature field is currently clearable.
 *
 * For some document formats (TIFF), signatures may only be cleared in
 * the reverse order of signing (LIFO).  Use this function to find out
 * whether the signature field is currently clearable (as determined
 * by SIGNDOC_Document_getField() or SIGNDOC_Document_getFields(),
 *
 * @note The value returned by this function does not change over
 * the lifetime of @a aObj and therefore may not reflect the
 * current state if signature fields have been signed or cleared
 * since @a aObj was created.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return #SIGNDOC_TRUE if this is a signature field that can be cleared now,
 *         #SIGNDOC_FALSE otherwise.
 *
 * @see SIGNDOC_Document_getField(), SIGNDOC_Document_getFields()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_isCurrentlyClearable (struct SIGNDOC_Exception **aEx,
                                    const struct SIGNDOC_Field *aObj);

/**
 * @brief Get maximum length of text field.
 *
 * The default value is -1.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return  The maximum length of text fields or -1 if the field is
 *          not a text field or if the text field does not have a
 *          maximum length.
 *
 * @see SIGNDOC_Field_setMaxLen()
 *
 * @memberof SIGNDOC_Field
 */
int SDCAPI
SIGNDOC_Field_getMaxLen (struct SIGNDOC_Exception **aEx,
                         struct SIGNDOC_Field *aObj);

/**
 * @brief Set maximum length of text fields.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aMaxLen  The maximum length (in characters) of the text field
 *                     or -1 for no maximum length.
 *
 * @see SIGNDOC_Field_getMaxLen()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setMaxLen (struct SIGNDOC_Exception **aEx,
                         struct SIGNDOC_Field *aObj,
                         int aMaxLen);

/**
 * @brief Get the index of the choice to be displayed in the first
 *        line of a list box.
 *
 * The default value is 0.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return The index of the choice to be displayed in the first line
 *         of a list box or 0 for other field types.
 *
 * @see SIGNDOC_Field_getChoiceValue(), SIGNDOC_Field_setTopIndex()
 *
 * @memberof SIGNDOC_Field
 */
int SDCAPI
SIGNDOC_Field_getTopIndex (struct SIGNDOC_Exception **aEx,
                           struct SIGNDOC_Field *aObj);

/**
 * @brief Set the index of the choice to be displayed in the first
 *        line of a list box.
 *
 * This value is ignored for other field types.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aTopIndex  The index of the choice to be displayed in the
 *                       first line of a list box.
 *
 * @see SIGNDOC_Field_getChoiceValue(), SIGNDOC_Field_getTopIndex()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setTopIndex (struct SIGNDOC_Exception **aEx,
                           struct SIGNDOC_Field *aObj,
                           int aTopIndex);

/**
 * @brief Get the index of the currently selected widget.
 *
 * Initially, the first widget is selected (ie, this function returns
 * 0). However, there is an exception to this rule: SIGNDOC_Field
 * objects created by SIGNDOC_Document_getFieldsOfPage() can have a
 * different widget selected initially for PDF documents.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return The 0-based index of the currently selected widget.
 *
 * @see SIGNDOC_Field_selectWidget()
 *
 * @memberof SIGNDOC_Field
 */
int SDCAPI
SIGNDOC_Field_getWidget (struct SIGNDOC_Exception **aEx,
                         struct SIGNDOC_Field *aObj);

/**
 * @brief Get the number of widgets.
 *
 * Signature fields always have exactly one widget.  Radio button
 * fields (radio button groups) usually have one widget per button (but can
 * have more widgets than buttons by having multiple widgets for some or
 * all buttons).
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return The number of widgets for this field.
 *
 * @memberof SIGNDOC_Field
 */
int SDCAPI
SIGNDOC_Field_getWidgetCount (struct SIGNDOC_Exception **aEx,
                              struct SIGNDOC_Field *aObj);

/**
 * @brief Select a widget.
 *
 * This function selects the widget to be used by
 * SIGNDOC_Field_getWidgetFlags(), SIGNDOC_Field_getPage(),
 * SIGNDOC_Field_getLeft(), SIGNDOC_Field_getBottom(),
 * SIGNDOC_Field_getRight(), SIGNDOC_Field_getTop(),
 * SIGNDOC_Field_getButtonValue(), SIGNDOC_Field_getJustification(),
 * SIGNDOC_Field_getRotation(),
 * SIGNDOC_Field_getTextFieldAttributes(),
 * SIGNDOC_Field_setWidgetFlags(), SIGNDOC_Field_setPage(),
 * SIGNDOC_Field_setLeft(), SIGNDOC_Field_setBottom(),
 * SIGNDOC_Field_setRight(), SIGNDOC_Field_setTop(),
 * SIGNDOC_Field_setButtonValue(), SIGNDOC_Field_setJustification(),
 * SIGNDOC_Field_setRotation(), and
 * SIGNDOC_Field_setTextFieldAttributes().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex  0-based index of the widget.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @see SIGNDOC_Field_clickButton(), SIGNDOC_Field_getWidgetCount()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_selectWidget (struct SIGNDOC_Exception **aEx,
                            struct SIGNDOC_Field *aObj,
                            int aIndex);

/**
 * @brief Add a widget to the field.
 *
 * The new widget will be added at the end, ie, calling
 * SIGNDOC_Field_getWidgetCount() <b>before</b> calling
 * SIGNDOC_Field_addWidget() yields the index of the widget that will
 * be added.
 *
 * After adding a widget, the new widget will be selected.  You must set
 * the page number and the coordinates in the new widget before calling
 * SIGNDOC_Document_addField() or SIGNDOC_Document_setField().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @see SIGNDOC_Field_addChoice(), SIGNDOC_Field_getWidget(), SIGNDOC_Field_getWidgetCount(), SIGNDOC_Field_insertWidget(), SIGNDOC_Field_removeWidget(), SIGNDOC_Field_selectWidget()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_addWidget (struct SIGNDOC_Exception **aEx,
                         struct SIGNDOC_Field *aObj);

/**
 * @brief Add a widget to the field in front of another widget.
 *
 * The new widget will be inserted at the specified index, ie, the
 * index of the new widget will be @a aIndex.
 *
 * After adding a widget, the new widget will be selected.  You must set
 * the page number and the coordinates in the new widget before calling
 * SIGNDOC_Document_addField() or SIGNDOC_Document_setField().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex  0-based index of the widget in front of which
 *                    the new widget shall be inserted. You can pass
 *                    the current number of widgets as returned by
 *                    SIGNDOC_Field_getWidgetCount() to add the new widget to the end
 *                    as SIGNDOC_Field_addWidget() does.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @see SIGNDOC_Field_addWidget(), SIGNDOC_Field_getWidget(), SIGNDOC_Field_getWidgetCount(), SIGNDOC_Field_removeWidget(), SIGNDOC_Field_selectWidget(), setValueIndex
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_insertWidget (struct SIGNDOC_Exception **aEx,
                            struct SIGNDOC_Field *aObj,
                            int aIndex);

/**
 * @brief Remove a widget from the field.
 *
 * This function fails when there is only one widget. That is, a field
 * always has at least one widget.
 *
 * If the currently selected widget is removed, the following rules apply:
 * - When removing the last widget (the one with index
 *   SIGNDOC_Field_getWidgetCount()-1),
 *   the predecessor of the removed widget will be selected.
 * - Otherwise, the index of the selected widget won't change, ie,
 *   the successor of the removed widget will be selected.
 * .
 *
 * If the widget to be removed is not selected, the currently selected
 * widget will remain selected.
 *
 * All widgets having an index greater than @a aIndex will have their
 * index decremented by one.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex  0-based index of the widget to remove.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @see SIGNDOC_Field_addWidget(), SIGNDOC_Field_getWidget(), SIGNDOC_Field_getWidgetCount(), SIGNDOC_Field_insertWidget(), SIGNDOC_Field_selectWidget(), setValueIndex
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_removeWidget (struct SIGNDOC_Exception **aEx,
                            struct SIGNDOC_Field *aObj,
                            int aIndex);

/**
 * @brief Get the annotation flags of the widget.
 *
 * The default value is #SIGNDOC_FIELD_WIDGETFLAG_PRINT.  The
 * annotation flags are used for PDF documents only.  Currently, the
 * semantics of the annotation flags are ignored by this software (ie,
 * the flags are stored in the document, but they don't have any
 * meaning to this software).
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return The annotation flags of the widget:
 *         #SIGNDOC_FIELD_WIDGETFLAG_INVISIBLE,
 *         #SIGNDOC_FIELD_WIDGETFLAG_HIDDEN,
 *         #SIGNDOC_FIELD_WIDGETFLAG_PRINT,
 *         #SIGNDOC_FIELD_WIDGETFLAG_NOZOOM,
 *         #SIGNDOC_FIELD_WIDGETFLAG_NOROTATE,
 *         #SIGNDOC_FIELD_WIDGETFLAG_NOVIEW,
 *         #SIGNDOC_FIELD_WIDGETFLAG_READONLY,
 *         #SIGNDOC_FIELD_WIDGETFLAG_LOCKED,
 *         #SIGNDOC_FIELD_WIDGETFLAG_TOGGLENOVIEW, and
 *         #SIGNDOC_FIELD_WIDGETFLAG_LOCKEDCONTENTS.
 *
 * @see SIGNDOC_Field_selectWidget(), SIGNDOC_Field_setWidgetFlags()
 *
 * @memberof SIGNDOC_Field
 */
int SDCAPI
SIGNDOC_Field_getWidgetFlags (struct SIGNDOC_Exception **aEx,
                              struct SIGNDOC_Field *aObj);

/**
 * @brief Set the annotation flags of the widget.
 *
 * The default value is #SIGNDOC_FIELD_WIDGETFLAG_PRINT.  The
 * annotation flags are used for PDF documents only.  Currently, the
 * semantics of the annotation flags are ignored by this software (ie,
 * the flags are stored in the document, but they don't have any
 * meaning to this software).
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aFlags   The annotation flags of the widget:
 *                     #SIGNDOC_FIELD_WIDGETFLAG_INVISIBLE,
 *                     #SIGNDOC_FIELD_WIDGETFLAG_HIDDEN,
 *                     #SIGNDOC_FIELD_WIDGETFLAG_PRINT,
 *                     #SIGNDOC_FIELD_WIDGETFLAG_NOZOOM,
 *                     #SIGNDOC_FIELD_WIDGETFLAG_NOROTATE,
 *                     #SIGNDOC_FIELD_WIDGETFLAG_NOVIEW,
 *                     #SIGNDOC_FIELD_WIDGETFLAG_READONLY,
 *                     #SIGNDOC_FIELD_WIDGETFLAG_LOCKED,
 *                     #SIGNDOC_FIELD_WIDGETFLAG_TOGGLENOVIEW, and
 *                     #SIGNDOC_FIELD_WIDGETFLAG_LOCKEDCONTENTS.
 *
 * @see SIGNDOC_Field_getWidgetFlags(), SIGNDOC_Field_selectWidget()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setWidgetFlags (struct SIGNDOC_Exception **aEx,
                              struct SIGNDOC_Field *aObj,
                              int aFlags);

/**
 * @brief Get the page number.
 *
 * This function returns the index of the page on which this field
 * occurs (1 for the first page), or 0 if the page number is
 * unknown.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return The 1-based page number or 0 if the page number is unknown.
 *
 * @see SIGNDOC_Field_selectWidget(), SIGNDOC_Field_setPage()
 *
 * @memberof SIGNDOC_Field
 */
int SDCAPI
SIGNDOC_Field_getPage (struct SIGNDOC_Exception **aEx,
                       struct SIGNDOC_Field *aObj);

/**
 * @brief Set the page number.
 *
 * This function sets the index of the page on which this field
 * occurs (1 for the first page).
 *
 * By calling SIGNDOC_Document_getField(), SIGNDOC_Field_setPage(), and
 * SIGNDOC_Document_setField(), you can move a field's widget to
 * another page but be careful because the two pages may have
 * different conversion factors, see
 * SIGNDOC_Document_getConversionFactors().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aPage  The 1-based page number of the field.
 *
 * @see SIGNDOC_Field_getPage(), SIGNDOC_Field_selectWidget()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setPage (struct SIGNDOC_Exception **aEx,
                       struct SIGNDOC_Field *aObj,
                       int aPage);

/**
 * @brief Get the left coordinate.
 *
 * The origin is in the bottom left corner of the page, see
 * @ref signdocshared_coordinates.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return The left coordinate.
 *
 * @see SIGNDOC_Field_getBottom(), SIGNDOC_Field_getRight(), SIGNDOC_Field_getTop(), SIGNDOC_Field_selectWidget(), SIGNDOC_Field_setLeft()
 *
 * @memberof SIGNDOC_Field
 */
double SDCAPI
SIGNDOC_Field_getLeft (struct SIGNDOC_Exception **aEx,
                       struct SIGNDOC_Field *aObj);

/**
 * @brief Set the left coordinate.
 *
 * The origin is in the bottom left corner of the page, see
 * @ref signdocshared_coordinates.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aLeft  The left coordinate.
 *
 * @see SIGNDOC_Field_getLeft(), SIGNDOC_Field_selectWidget(), SIGNDOC_Field_setBottom(), SIGNDOC_Field_setRight(), SIGNDOC_Field_setTop(), #SIGNDOC_DOCUMENT_SETFIELDFLAGS_MOVE
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setLeft (struct SIGNDOC_Exception **aEx,
                       struct SIGNDOC_Field *aObj,
                       double aLeft);

/**
 * @brief Get the bottom coordinate.
 *
 * The origin is in the bottom left corner of the page, see
 * @ref signdocshared_coordinates.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return The bottom coordinate.
 *
 * @see SIGNDOC_Field_getLeft(), SIGNDOC_Field_getRight(), SIGNDOC_Field_getTop(), SIGNDOC_Field_selectWidget(), SIGNDOC_Field_setBottom()
 *
 * @memberof SIGNDOC_Field
 */
double SDCAPI
SIGNDOC_Field_getBottom (struct SIGNDOC_Exception **aEx,
                         struct SIGNDOC_Field *aObj);

/**
 * @brief Set the bottom coordinate.
 *
 * The origin is in the bottom left corner of the page, see
 * @ref signdocshared_coordinates.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aBottom  The bottom coordinate.
 *
 * @see SIGNDOC_Field_getBottom(), SIGNDOC_Field_selectWidget(), SIGNDOC_Field_setLeft(), SIGNDOC_Field_setRight(), SIGNDOC_Field_setTop(), #SIGNDOC_DOCUMENT_SETFIELDFLAGS_MOVE
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setBottom (struct SIGNDOC_Exception **aEx,
                         struct SIGNDOC_Field *aObj,
                         double aBottom);

/**
 * @brief Get the right coordinate.
 *
 * The origin is in the bottom left corner of the page, see
 * @ref signdocshared_coordinates.
 * If coordinates are given in pixels (this is true for TIFF documents),
 * this coordinate is exclusive.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return The right coordinate.
 *
 * @see SIGNDOC_Field_getBottom(), SIGNDOC_Field_getLeft(), SIGNDOC_Field_getTop(), SIGNDOC_Field_selectWidget(), SIGNDOC_Field_setRight()
 *
 * @memberof SIGNDOC_Field
 */
double SDCAPI
SIGNDOC_Field_getRight (struct SIGNDOC_Exception **aEx,
                        struct SIGNDOC_Field *aObj);

/**
 * @brief Set the right coordinate.
 *
 * The origin is in the bottom left corner of the page, see
 * @ref signdocshared_coordinates.
 * If coordinates are given in pixels (this is true for TIFF documents),
 * this coordinate is exclusive.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aRight  The right coordinate.
 *
 * @see SIGNDOC_Field_getRight(), SIGNDOC_Field_selectWidget(), SIGNDOC_Field_setBottom(), SIGNDOC_Field_setLeft(), SIGNDOC_Field_setTop(), #SIGNDOC_DOCUMENT_SETFIELDFLAGS_MOVE
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setRight (struct SIGNDOC_Exception **aEx,
                        struct SIGNDOC_Field *aObj,
                        double aRight);

/**
 * @brief Get the top coordinate.
 *
 * The origin is in the bottom left corner of the page, see
 * @ref signdocshared_coordinates.
 * If coordinates are given in pixels (this is true for TIFF documents),
 * this coordinate is exclusive.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return The top coordinate.
 *
 * @see SIGNDOC_Field_getBottom(), SIGNDOC_Field_getLeft(), SIGNDOC_Field_getRight(), SIGNDOC_Field_selectWidget(), SIGNDOC_Field_setTop()
 *
 * @memberof SIGNDOC_Field
 */
double SDCAPI
SIGNDOC_Field_getTop (struct SIGNDOC_Exception **aEx,
                      struct SIGNDOC_Field *aObj);

/**
 * @brief Set the top coordinate.
 *
 * The origin is in the bottom left corner of the page, see
 * @ref signdocshared_coordinates.
 * If coordinates are given in pixels (this is true for TIFF documents),
 * this coordinate is exclusive.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aTop  The top coordinate.
 *
 * @see SIGNDOC_Field_getTop(), SIGNDOC_Field_selectWidget(), SIGNDOC_Field_setBottom(), SIGNDOC_Field_setLeft(), SIGNDOC_Field_setRight(), #SIGNDOC_DOCUMENT_SETFIELDFLAGS_MOVE
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setTop (struct SIGNDOC_Exception **aEx,
                      struct SIGNDOC_Field *aObj,
                      double aTop);

/**
 * @brief Get the button value of a widget of a radio button group or check box.
 *
 * Usually, different radio buttons (widgets) of a radio button group
 * (field) have different values. The radio button group has a value
 * (returned by SIGNDOC_Field_getValue()) which is either "Off" or one of those
 * values. The individual buttons (widgets) of a check box field can
 * also have different export values.
 *
 * Different radio buttons (widgets) of a radio button group (field)
 * can have the same value; in that case, the radio buttons are linked.
 * The individual buttons of a check box field also can have the same
 * value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding to be used for the return value
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 *
 * @return The button value  an empty string (for field types that
 *         don't use button values).
 *         The string must be freed with SIGNDOC_free().
 *
 * @see SIGNDOC_Field_getChoiceValue(), SIGNDOC_Field_getValue(), SIGNDOC_Field_selectWidget(), SIGNDOC_Field_setButtonValue()
 *
 * @memberof SIGNDOC_Field
 */
char * SDCAPI
SIGNDOC_Field_getButtonValue (struct SIGNDOC_Exception **aEx,
                              struct SIGNDOC_Field *aObj,
                              int aEncoding);

/**
 * @brief Get the button value of a widget of a radio button group or check box.
 *
 * See SIGNDOC_Field_getButtonValue() for details.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return The button value  an empty string (for field types that
 *         don't use button values).
 *         This pointer will become invalid when
 *         SIGNDOC_Field_addWidget(), SIGNDOC_Field_insertWidget(),
 *         SIGNDOC_Field_removeWidget(), or
 *         SIGNDOC_Field_setButtonValue() is called or @a aObj is
 *         destroyed.
 *
 * @see SIGNDOC_Field_getButtonValue(), SIGNDOC_Field_getChoiceValue(), SIGNDOC_Field_getValue(), SIGNDOC_Field_selectWidget(), SIGNDOC_Field_setButtonValue()
 *
 * @memberof SIGNDOC_Field
 */
const char * SDCAPI
SIGNDOC_Field_getButtonValueUTF8 (struct SIGNDOC_Exception **aEx,
                                  struct SIGNDOC_Field *aObj);

/**
 * Set the button value of a widget of a radio button group or a check box.
 *
 * Usually, different radio buttons (widgets) of a radio button group
 * (field) have different values. The radio button group has a value
 * (returned by SIGNDOC_Field_getValue()) which is either "Off" or one of those
 * values. The individual buttons (widgets) of a check box field can
 * also have different export values.
 *
 * Different radio buttons (widgets) of a radio button group (field)
 * can have the same value; in that case, the radio buttons are linked.
 * The individual buttons of a check box field also can have the same
 * value.
 *
 * SIGNDOC_Document_addField() and SIGNDOC_Document_setField()
 * ignore the value set by this function if the field is neither
 * a radio button group nor a check box field.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding of @a aValue
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aValue     The value to be set. Must not be empty, must
 *                       not be "Off".
 *
 * @see SIGNDOC_Field_getButtonValue(), SIGNDOC_Field_getChoiceValue(), SIGNDOC_Field_getValue(), SIGNDOC_Field_selectWidget()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setButtonValue (struct SIGNDOC_Exception **aEx,
                              struct SIGNDOC_Field *aObj,
                              int aEncoding, const char *aValue);

/**
 * @brief Get the justification of the widget.
 *
 * The default value is #SIGNDOC_FIELD_JUSTIFICATION_NONE.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return The justification of the widget
 *         (#SIGNDOC_FIELD_JUSTIFICATION_LEFT,
 *         #SIGNDOC_FIELD_JUSTIFICATION_CENTER, or
 *         #SIGNDOC_FIELD_JUSTIFICATION_RIGHT)
 *         or #SIGNDOC_FIELD_JUSTIFICATION_NONE for non-text fields.
 *
 * @see SIGNDOC_Field_selectWidget(), SIGNDOC_Field_setJustification()
 *
 * @memberof SIGNDOC_Field
 */
int SDCAPI
SIGNDOC_Field_getJustification (struct SIGNDOC_Exception **aEx,
                                struct SIGNDOC_Field *aObj);

/**
 * @brief Set the justification of the widget.
 *
 * The default value is #SIGNDOC_FIELD_JUSTIFICATION_NONE.
 *
 * The justification must be j_none for all field types except
 * for text fields and list boxes.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aJustification  The justification:
 *                            #SIGNDOC_FIELD_JUSTIFICATION_NONE,
 *                            #SIGNDOC_FIELD_JUSTIFICATION_LEFT,
 *                            #SIGNDOC_FIELD_JUSTIFICATION_CENTER, or
 *                            #SIGNDOC_FIELD_JUSTIFICATION_RIGHT.
 *
 *
 * @see SIGNDOC_Field_getJustification(), SIGNDOC_Field_selectWidget()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setJustification (struct SIGNDOC_Exception **aEx,
                                struct SIGNDOC_Field *aObj,
                                int aJustification);

/**
 * @brief Get the rotation of the widget contents.
 *
 * The rotation is specified in degrees (counter-clockwise).
 * The default value is 0.
 *
 * For instance, if the rotation is 270, left-to right
 * text will display top down.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return The rotation of the widget: 0, 90, 180, or 270.
 *
 * @see SIGNDOC_Field_selectWidget(), SIGNDOC_Field_setJustification()
 *
 * @memberof SIGNDOC_Field
 */
int SDCAPI
SIGNDOC_Field_getRotation (struct SIGNDOC_Exception **aEx,
                           struct SIGNDOC_Field *aObj);

/**
 * @brief Set the rotation of the widget contents.
 *
 * The rotation is specified in degrees (counter-clockwise).
 * The default value is 0.
 *
 * For instance, if the rotation is 270, left-to right
 * text will display top down.
 *
 * Currently, the rotation must always be 0 for TIFF documents.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aRotation  The rotation: 0, 90, 180, or 270.
 *
 * @see SIGNDOC_Field_getRotation(), SIGNDOC_Field_selectWidget()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setRotation (struct SIGNDOC_Exception **aEx,
                           struct SIGNDOC_Field *aObj,
                           int aRotation);

/**
 * @brief Get text field attributes.
 *
 * This function returns #SIGNDOC_FALSE if the field uses the document's
 * default font name for fields.
 *
 * Text fields, signature fields, list boxes, and combo boxes can
 * have text field attributes.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in,out] aOutput  This object will be updated.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @see SIGNDOC_Field_selectWidget(), SIGNDOC_Field_setTextFieldAttributes(), SIGNDOC_Document_getTextFieldAttributes()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_getTextFieldAttributes (struct SIGNDOC_Exception **aEx,
                                      struct SIGNDOC_Field *aObj,
                                      struct SIGNDOC_TextFieldAttributes *aOutput);

/**
 * @brief Set text field attributes.
 *
 * Font name and font size must be specified.  The text color is
 * optional. This function fails if any of the attributes of
 * @a aInput are invalid.
 *
 * Text field attributes can be specified for text fields, signature
 * fields, list boxes, and combo boxes.
 *
 * If SIGNDOC_TextFieldAttributes_isSet() returns #SIGNDOC_FALSE for @a
 * aInput, the text field attributes of the field will be removed
 * by SIGNDOC_Document_setField().
 *
 * The following rules apply if the field does not have text field
 * attributes:
 * - If the field inherits text field attributes from a
 *   ancestor field, those will be used by PDF processing software.
 * - Otherwise, if the document has specifies text field attributes (see
 *   SIGNDOC_Document_getTextFieldAttributes()), those will be used
 *   by PDF processing software.
 * - Otherwise, the field is not valid.
 * .
 *
 * To avoid having invalid fields, SIGNDOC_Document_addField() and
 * SIGNDOC_Document_setField() will use text field attributes
 * specifying Helvetica as the font and black for the text color if
 * the field does not inherit text field attributes from an ancestor
 * field or from the document.
 *
 * This function always fails for TIFF documents.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aInput   The new default text field attributes.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE on error.
 *
 * @see SIGNDOC_Field_getTextFieldAttributes(), SIGNDOC_Field_selectWidget()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_setTextFieldAttributes (struct SIGNDOC_Exception **aEx,
                                      struct SIGNDOC_Field *aObj,
                                      const struct SIGNDOC_TextFieldAttributes *aInput);

/**
 * @brief Get the lock type.
 *
 * The lock type defines the fields to be locked when signing this
 * signature field.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return The lock type:
 *         #SIGNDOC_FIELD_LOCKTYPE_NA,
 *         #SIGNDOC_FIELD_LOCKTYPE_NONE,
 *         #SIGNDOC_FIELD_LOCKTYPE_ALL,
 *         #SIGNDOC_FIELD_LOCKTYPE_INCLUDE, or
 *         #SIGNDOC_FIELD_LOCKTYPE_EXCLUDE.
 *
 * @see SIGNDOC_Field_getLockFields(), SIGNDOC_Field_setLockType()
 *
 * @memberof SIGNDOC_Field
 */
int SDCAPI
SIGNDOC_Field_getLockType (struct SIGNDOC_Exception **aEx,
                           struct SIGNDOC_Field *aObj);

/**
 * @brief Set the lock type.
 *
 * The lock type defines the fields to be locked when signing this
 * signature field.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aLockType The new lock type:
 *                      #SIGNDOC_FIELD_LOCKTYPE_NONE,
 *                      #SIGNDOC_FIELD_LOCKTYPE_ALL,
 *                      #SIGNDOC_FIELD_LOCKTYPE_INCLUDE, or
 *                      #SIGNDOC_FIELD_LOCKTYPE_EXCLUDE.
 *
 * @see SIGNDOC_Field_addLockField(), SIGNDOC_Field_getLockType()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setLockType (struct SIGNDOC_Exception **aEx,
                           struct SIGNDOC_Field *aObj,
                           int aLockType);

/**
 * @brief Get the number of field names for lt_include and lt_exclude.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return The number of field names.
 *
 * @see SIGNDOC_Field_addLockField(), SIGNDOC_Field_clearLockFields(), SIGNDOC_Field_getLockField(), SIGNDOC_Field_getLockFieldUTF8(), SIGNDOC_Field_removeLockField()
 *
 * @memberof SIGNDOC_Field
 */
int SDCAPI
SIGNDOC_Field_getLockFieldCount (struct SIGNDOC_Exception **aEx,
                                 struct SIGNDOC_Field *aObj);

/**
 * @brief Get the name of a lock field.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the name cannot be
 * represented using the specified encoding.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding to be used for the return value
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aIndex     0-based index of the lock field.
 *
 * @return The name of the selected lock field or an empty string
 *         if the index is out of range.
 *         The string must be freed with SIGNDOC_free().
 *
 * @see SIGNDOC_Field_addLockField(), SIGNDOC_Field_clearLockFields(), SIGNDOC_Field_getLockFieldCount(), SIGNDOC_Field_getLockFieldUTF8(), SIGNDOC_Field_removeLockField(), SIGNDOC_Field_setLockField()
 *
 * @memberof SIGNDOC_Field
 */
char * SDCAPI
SIGNDOC_Field_getLockField (struct SIGNDOC_Exception **aEx,
                            struct SIGNDOC_Field *aObj,
                            int aEncoding, int aIndex);

/**
 * @brief Get the name of a lock field.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex     0-based index of the lock field.
 *
 * @return The name of the selected lock field or an empty string
 *         if the index is out of range.  This pointer will become invalid
 *         when SIGNDOC_Field_addLockField(), SIGNDOC_Field_clearLockFields(),
 *         SIGNDOC_Field_removeLockField(), or SIGNDOC_Field_setLockField()
 *         is called or @a aObj is destroyed.
 *
 * @see SIGNDOC_Field_addLockField(), SIGNDOC_Field_clearLockFields(), SIGNDOC_Field_getLockFieldCount(), SIGNDOC_Field_getLockFieldUTF8(), SIGNDOC_Field_setLockField()
 *
 * @memberof SIGNDOC_Field
 */
const char * SDCAPI
SIGNDOC_Field_getLockFieldUTF8 (struct SIGNDOC_Exception **aEx,
                                struct SIGNDOC_Field *aObj,
                                int aIndex);

/**
 * @brief Clear the lock fields.
 *
 * After calling this function, SIGNDOC_Field_getLockFieldCount()
 * will return 0.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @see SIGNDOC_Field_addLockField(), SIGNDOC_Field_getLockFieldCount(), SIGNDOC_Field_removeLockField()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_clearLockFields (struct SIGNDOC_Exception **aEx,
                               struct SIGNDOC_Field *aObj);

/**
 * @brief Add a lock field to the field.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the name is not correctly
 * encoded according to the specified encoding.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding of @a aName
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aName      The name of the lock field to be added.
 *
 * @see SIGNDOC_Field_clearLockFields(), SIGNDOC_Field_getLockField(), SIGNDOC_Field_getLockFieldUTF8(), SIGNDOC_Field_setLockField()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_addLockField (struct SIGNDOC_Exception **aEx,
                            struct SIGNDOC_Field *aObj,
                            int aEncoding, const char *aName);

/**
 * @brief Set a lock field.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the name is not correctly
 * encoded according to the specified encoding.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex     The 0-based index of the value to be set.
 *                       If @a aIndex equals the current number of
 *                       values, the value will be added.
 * @param[in] aEncoding  The encoding of @a aName
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aName      The name of the lock field to be set.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if @a aIndex is
 *         out of range.
 *
 * @see SIGNDOC_Field_clearLockFields(), SIGNDOC_Field_getLockField(), SIGNDOC_Field_getLockFieldUTF8()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_setLockFieldByIndex (struct SIGNDOC_Exception **aEx,
                                   struct SIGNDOC_Field *aObj,
                                   int aIndex, int aEncoding, const char *aName);

/**
 * @brief Set a lock field.
 *
 * Calling this function is equivalent to calling
 * SIGNDOC_Field_clearLockFields() and SIGNDOC_Field_addLockField(),
 * but the encoding of @a aName is checked before modifying @a aObj.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the name is not correctly
 * encoded according to the specified encoding.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding of @a aName
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aName      The name of the lock field to be set.
 *
 * @see SIGNDOC_Field_clearLockFields(), SIGNDOC_Field_getLockField(), SIGNDOC_Field_getLockFieldUTF8()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setLockField (struct SIGNDOC_Exception **aEx,
                            struct SIGNDOC_Field *aObj,
                            int aEncoding, const char *aName);

/**
 * @brief Remove a lock field.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex     The 0-based index of the lock field to be removed.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if @a aIndex is
 *         out of range.
 *
 * @see SIGNDOC_Field_clearLockFields(), SIGNDOC_Field_getLockField(), SIGNDOC_Field_getLockFieldUTF8()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_removeLockField (struct SIGNDOC_Exception **aEx,
                               struct SIGNDOC_Field *aObj,
                               int aIndex);

/**
 * @brief Get the certificate seed value dictionary flags (/SV/Cert/Ff) of a
 *        signature field.
 *
 * The default value is 0.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return The certificate seed value dictionary flags of the field:
 *         #SIGNDOC_FIELD_CERTSEEDVALUEFLAG_SUBJECTCERT,
 *         #SIGNDOC_FIELD_CERTSEEDVALUEFLAG_ISSUERCERT,
 *         #SIGNDOC_FIELD_CERTSEEDVALUEFLAG_POLICY,
 *         #SIGNDOC_FIELD_CERTSEEDVALUEFLAG_SUBJECTDN,
 *         #SIGNDOC_FIELD_CERTSEEDVALUEFLAG_KEYUSAGE, and
 *         #SIGNDOC_FIELD_CERTSEEDVALUEFLAG_URL.
 *
 * @see SIGNDOC_Field_setCertSeedValueFlags()
 *
 * @memberof SIGNDOC_Field
 */
unsigned  SDCAPI
SIGNDOC_Field_getCertSeedValueFlags (struct SIGNDOC_Exception **aEx,
                                     struct SIGNDOC_Field *aObj);

/**
 * @brief Set the certificate seed value dictionary flags (/SV/Cert/Ff) of a
 *        signature field.
 *
 * The default value is 0.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aFlags  The certificate seed value dicitionary flags of
 *                    the field:
 *                    #SIGNDOC_FIELD_CERTSEEDVALUEFLAG_SUBJECTCERT,
 *                    #SIGNDOC_FIELD_CERTSEEDVALUEFLAG_ISSUERCERT,
 *                    #SIGNDOC_FIELD_CERTSEEDVALUEFLAG_POLICY,
 *                    #SIGNDOC_FIELD_CERTSEEDVALUEFLAG_SUBJECTDN,
 *                    #SIGNDOC_FIELD_CERTSEEDVALUEFLAG_KEYUSAGE, and
 *                    #SIGNDOC_FIELD_CERTSEEDVALUEFLAG_URL.
 *
 * @see SIGNDOC_Field_getCertSeedValueFlags()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setCertSeedValueFlags (struct SIGNDOC_Exception **aEx,
                                     struct SIGNDOC_Field *aObj,
                                     unsigned aFlags);

/**
 * @brief Get the number of subject distinguished names in the certificate
 *        seed value dictionary.
 *
 * See the PDF Reference for details.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @see SIGNDOC_Field_addCertSeedValueSubjectDN(), SIGNDOC_Field_clearCertSeedValueSubjectDNs(), SIGNDOC_Field_getCertSeedValueSubjectDN(), SIGNDOC_Field_getCertSeedValueSubjectDNUTF8(), SIGNDOC_Field_removeCertSeedValueSubjectDN()
 *
 * @memberof SIGNDOC_Field
 */
int SDCAPI
SIGNDOC_Field_getCertSeedValueSubjectDNCount (struct SIGNDOC_Exception **aEx,
                                              struct SIGNDOC_Field *aObj);

/**
 * @brief Get a subject distinguished name from the certificate
 *        seed value dictionary.
 *
 * See the PDF Reference for details.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the name cannot be
 * represented using the specified encoding.
 *
 * @note RFC 4514 requires UTF-8 encoding.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding to be used for the return value
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aIndex     0-based index of the subject distinguished name.
 *
 * @return The selected subject distinguished name (formatted according to
 *         RFC 4514) or an empty string if the index is out of range.
 *         The string must be freed with SIGNDOC_free().
 *
 * @see SIGNDOC_Field_addCertSeedValueSubjectDN(), SIGNDOC_Field_clearCertSeedValueSubjectDNs(), SIGNDOC_Field_getCertSeedValueSubjectDNCount(), SIGNDOC_Field_getCertSeedValueSubjectDNUTF8(), SIGNDOC_Field_removeCertSeedValueSubjectDN(), SIGNDOC_Field_setCertSeedValueSubjectDN()
 *
 * @memberof SIGNDOC_Field
 */
char * SDCAPI
SIGNDOC_Field_getCertSeedValueSubjectDN (struct SIGNDOC_Exception **aEx,
                                         struct SIGNDOC_Field *aObj,
                                         int aEncoding, int aIndex);

/**
 * @brief Get a subject distinguished name from the certificate
 *        seed value dictionary.
 *
 * See the PDF Reference for details.
 *
 * @note RFC 4514 requires UTF-8 encoding.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex     0-based index of the subject distinguished name.
 *
 * @return The selected subject distinguished name (formatted according to
 *         RFC 4514) or an empty string if the index is out of range.
 *         This pointer will become invalid when
 *         SIGNDOC_Field_addCertSeedValueSubjectDN(),
 *         SIGNDOC_Field_clearCertSeedValueSubjectDNs(),
 *         SIGNDOC_Field_removeCertSeedValueSubjectDN(), or
 *         SIGNDOC_Field_setCertSeedValueSubjectDN() is
 *         called or @a aObj is destroyed.
 *
 * @see SIGNDOC_Field_addCertSeedValueSubjectDN(), SIGNDOC_Field_clearCertSeedValueSubjectDNs(), SIGNDOC_Field_getCertSeedValueSubjectDNCount(), SIGNDOC_Field_getCertSeedValueSubjectDNUTF8(), SIGNDOC_Field_setCertSeedValueSubjectDN()
 *
 * @memberof SIGNDOC_Field
 */
const char * SDCAPI
SIGNDOC_Field_getCertSeedValueSubjectDNUTF8 (struct SIGNDOC_Exception **aEx,
                                             struct SIGNDOC_Field *aObj,
                                             int aIndex);

/**
 * @brief Remove all subject distinguished names from the certificate
 *        seed value dictionary.
 *
 * See the PDF Reference for details.
 *
 * After calling this function, SIGNDOC_Field_getCertSeedValueSubjectDNCount()
 * will return 0.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @see SIGNDOC_Field_addCertSeedValueSubjectDN(), SIGNDOC_Field_getCertSeedValueSubjectDNCount(), SIGNDOC_Field_removeCertSeedValueSubjectDN()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_clearCertSeedValueSubjectDNs (struct SIGNDOC_Exception **aEx,
                                            struct SIGNDOC_Field *aObj);

/**
 * @brief Add a subject distinguished name to the certificate
 *        seed value dictionary.
 *
 * See the PDF Reference for details.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the name is not correctly
 * encoded according to the specified encoding.
 *
 * @note RFC 4514 requires UTF-8 encoding.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding of @a aName
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aName      The subject distinguished name formatted according
 *                       to RFC 4514.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if @a aName cannot be parsed.
 *
 * @see SIGNDOC_Field_clearCertSeedValueSubjectDNs(), SIGNDOC_Field_getCertSeedValueSubjectDN(), SIGNDOC_Field_getCertSeedValueSubjectDNUTF8(), SIGNDOC_Field_setCertSeedValueSubjectDN()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_addCertSeedValueSubjectDN (struct SIGNDOC_Exception **aEx,
                                         struct SIGNDOC_Field *aObj,
                                         int aEncoding, const char *aName);

/**
 * @brief Set a subject distinguished name in the certificate
 *        seed value dictionary.
 *
 * See the PDF Reference for details.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the name is not correctly
 * encoded according to the specified encoding.
 *
 * @note RFC 4514 requires UTF-8 encoding.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex     The 0-based index of the value to be set.
 *                       If @a aIndex equals the current number of
 *                       values, the value will be added.
 * @param[in] aEncoding  The encoding of @a aName
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aName      The subject distinguished name formatted according
 *                       to RFC 4514.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if @a aIndex is
 *         out of range or if @a aName cannot be parsed.
 *
 * @see SIGNDOC_Field_clearCertSeedValueSubjectDNs(), SIGNDOC_Field_getCertSeedValueSubjectDN(), SIGNDOC_Field_getCertSeedValueSubjectDNUTF8()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_setCertSeedValueSubjectDNByIndex (struct SIGNDOC_Exception **aEx,
                                                struct SIGNDOC_Field *aObj,
                                                int aIndex, int aEncoding,
                                                const char *aName);

/**
 * @brief Set a subject distinguished name in the certificate
 *        seed value dictionary.
 *
 * See the PDF Reference for details.
 *
 * Calling this function is equivalent to calling
 * SIGNDOC_Field_clearCertSeedValueSubjectDNs() and
 * SIGNDOC_Field_addCertSeedValueSubjectDN(), but the
 * encoding of @a aName is checked before modifying @a aObj.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the name is not correctly
 * encoded according to the specified encoding.
 *
 * @note RFC 4514 requires UTF-8 encoding.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding of @a aName
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aName      The subject distinguished name formatted according
 *                       to RFC 4514.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if @a aName cannot be parsed.
 *
 * @see SIGNDOC_Field_clearCertSeedValueSubjectDNs(), SIGNDOC_Field_getCertSeedValueSubjectDN(), SIGNDOC_Field_getCertSeedValueSubjectDNUTF8()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_setCertSeedValueSubjectDN (struct SIGNDOC_Exception **aEx,
                                         struct SIGNDOC_Field *aObj,
                                         int aEncoding, const char *aName);

/**
 * @brief Remove a subject distinguished name from the certificate
 *        seed value dictionary.
 *
 * See the PDF Reference for details.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex     The 0-based index of the subject distinguished name to be removed.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if @a aIndex is
 *         out of range.
 *
 * @see SIGNDOC_Field_clearCertSeedValueSubjectDNs(), SIGNDOC_Field_getCertSeedValueSubjectDN(), SIGNDOC_Field_getCertSeedValueSubjectDNUTF8()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_removeCertSeedValueSubjectDN (struct SIGNDOC_Exception **aEx,
                                            struct SIGNDOC_Field *aObj,
                                            int aIndex);

/**
 * @brief Get the number of subject certificates in the certificate seed value
 *        dictionary.
 *
 * See the PDF Reference for details.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return The number of subject certificates.
 *
 * @see SIGNDOC_Field_addCertSeedValueSubjectCertificate(), SIGNDOC_Field_clearCertSeedValueSubjectCertificates(), SIGNDOC_Field_getCertSeedValueSubjectCertificate(), SIGNDOC_Field_getCertSeedValueSubjectCertificateUTF8(), SIGNDOC_Field_removeCertSeedValueSubjectCertificate()
 *
 * @memberof SIGNDOC_Field
 */
int SDCAPI
SIGNDOC_Field_getCertSeedValueSubjectCertificateCount (struct SIGNDOC_Exception **aEx,
                                                       struct SIGNDOC_Field *aObj);

/**
 * @brief Get a subject certificate of the certificate seed value dictionary.
 *
 * See the PDF Reference for details.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in]  aIndex    0-based index of the subject certificate.
 * @param[out] aOutput   The DER-encoded certificate will be stored here.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if @a aIndex is
 *         out of range.
 *
 * @see SIGNDOC_Field_addCertSeedValueSubjectCertificate(), SIGNDOC_Field_clearCertSeedValueSubjectCertificates(), SIGNDOC_Field_getCertSeedValueSubjectCertificateCount(), SIGNDOC_Field_getCertSeedValueSubjectCertificateUTF8(), SIGNDOC_Field_removeCertSeedValueSubjectCertificate(), SIGNDOC_Field_setCertSeedValueSubjectCertificate()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_getCertSeedValueSubjectCertificate (struct SIGNDOC_Exception **aEx,
                                                  struct SIGNDOC_Field *aObj,
                                                  int aIndex,
                                                  struct SIGNDOC_ByteArray *aOutput);

/**
 * @brief Remove all subject certificates from the certificate seed value
 *        dictionary.
 *
 * See the PDF Reference for details.
 *
 * After calling this function,
 * SIGNDOC_Field_getCertSeedValueSubjectCertificateCount() will return 0.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @see SIGNDOC_Field_addCertSeedValueSubjectCertificate(), SIGNDOC_Field_getCertSeedValueSubjectCertificateCount(), SIGNDOC_Field_removeCertSeedValueSubjectCertificate()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_clearCertSeedValueSubjectCertificates (struct SIGNDOC_Exception **aEx,
                                                     struct SIGNDOC_Field *aObj);

/**
 * @brief Add a subject certificate to the certificate seed value dictionary.
 *
 * See the PDF Reference for details.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aPtr       Pointer to the first octet of the DER-encoded
 *                       certificate.
 * @param[in] aSize      Size in octets of the DER-encoded certificate.
 *
 * @see SIGNDOC_Field_clearCertSeedValueSubjectCertificates(), SIGNDOC_Field_getCertSeedValueSubjectCertificate(), SIGNDOC_Field_getCertSeedValueSubjectCertificateUTF8(), SIGNDOC_Field_setCertSeedValueSubjectCertificate()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_addCertSeedValueSubjectCertificate (struct SIGNDOC_Exception **aEx,
                                                  struct SIGNDOC_Field *aObj,
                                                  const void *aPtr, size_t aSize);

/**
 * @brief Set a subject certificate in the certificate seed value dictionary.
 *
 * See the PDF Reference for details.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex     0-based index of the subject certificate to be set.
 *                       If @a aIndex equals the current number of
 *                       values, the certificate will be added.
 * @param[in] aPtr       Pointer to the first octet of the DER-encoded
 *                       certificate.
 * @param[in] aSize      Size in octets of the DER-encoded certificate.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if @a aIndex is
 *         out of range.
 *
 * @see SIGNDOC_Field_clearCertSeedValueSubjectCertificates(), SIGNDOC_Field_getCertSeedValueSubjectCertificate(), SIGNDOC_Field_getCertSeedValueSubjectCertificateUTF8()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_setCertSeedValueSubjectCertificateByIndex (struct SIGNDOC_Exception **aEx,
                                                         struct SIGNDOC_Field *aObj,
                                                         int aIndex,
                                                         const void *aPtr,
                                                         size_t aSize);

/**
 * @brief Set a subject certificate in the certificate seed value dictionary.
 *
 * See the PDF Reference for details.
 *
 * Calling this function is equivalent to calling
 * SIGNDOC_Field_clearCertSeedValueSubjectCertificates() and
 * SIGNDOC_Field_addCertSeedValueSubjectCertificate().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aPtr       Pointer to the first octet of the DER-encoded
 *                       certificate.
 * @param[in] aSize      Size in octets of the DER-encoded certificate.
 *
 * @see SIGNDOC_Field_clearCertSeedValueSubjectCertificates(), SIGNDOC_Field_getCertSeedValueSubjectCertificate(), SIGNDOC_Field_getCertSeedValueSubjectCertificateUTF8()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setCertSeedValueSubjectCertificate (struct SIGNDOC_Exception **aEx,
                                                  struct SIGNDOC_Field *aObj,
                                                  const void *aPtr, size_t aSize);

/**
 * @brief Remove a subject certificate from the certificate seed value
 *        dictionary.
 *
 * See the PDF Reference for details.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex     The 0-based index of the subject certificate to
 *                       be removed.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if @a aIndex is
 *         out of range.
 *
 * @see SIGNDOC_Field_clearCertSeedValueSubjectCertificates(), SIGNDOC_Field_getCertSeedValueSubjectCertificate(), SIGNDOC_Field_getCertSeedValueSubjectCertificateUTF8()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_removeCertSeedValueSubjectCertificate (struct SIGNDOC_Exception **aEx,
                                                     struct SIGNDOC_Field *aObj,
                                                     int aIndex);

/**
 * @brief Get the number of issuer certificates in the certificate seed value
 *        dictionary.
 *
 * See the PDF Reference for details.
 *
 * @return The number of issuer certificates.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @see SIGNDOC_Field_addCertSeedValueIssuerCertificate(), SIGNDOC_Field_clearCertSeedValueIssuerCertificates(), SIGNDOC_Field_getCertSeedValueIssuerCertificate(), SIGNDOC_Field_getCertSeedValueIssuerCertificateUTF8(), SIGNDOC_Field_removeCertSeedValueIssuerCertificate()
 *
 * @memberof SIGNDOC_Field
 */
int SDCAPI
SIGNDOC_Field_getCertSeedValueIssuerCertificateCount (struct SIGNDOC_Exception **aEx,
                                                      struct SIGNDOC_Field *aObj);

/**
 * @brief Get an issuer certificate of the certificate seed value dictionary.
 *
 * See the PDF Reference for details.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in]  aIndex    0-based index of the issuer certificate.
 * @param[out] aOutput   The DER-encoded certificate will be stored here.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if @a aIndex is
 *         out of range.
 *
 * @see SIGNDOC_Field_addCertSeedValueIssuerCertificate(), SIGNDOC_Field_clearCertSeedValueIssuerCertificates(), SIGNDOC_Field_getCertSeedValueIssuerCertificateCount(), SIGNDOC_Field_getCertSeedValueIssuerCertificateUTF8(), SIGNDOC_Field_removeCertSeedValueIssuerCertificate(), SIGNDOC_Field_setCertSeedValueIssuerCertificate()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_getCertSeedValueIssuerCertificate (struct SIGNDOC_Exception **aEx,
                                                 struct SIGNDOC_Field *aObj,
                                                 int aIndex, struct SIGNDOC_ByteArray *aOutput);

/**
 * @brief Remove all issuer certificates from the certificate seed value
 *        dictionary.
 *
 * See the PDF Reference for details.
 *
 * After calling this function,
 * SIGNDOC_Field_getCertSeedValueIssuerCertificateCount() will return 0.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @see SIGNDOC_Field_addCertSeedValueIssuerCertificate(), SIGNDOC_Field_getCertSeedValueIssuerCertificateCount(), SIGNDOC_Field_removeCertSeedValueIssuerCertificate()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_clearCertSeedValueIssuerCertificates (struct SIGNDOC_Exception **aEx,
                                                    struct SIGNDOC_Field *aObj);

/**
 * @brief Add an issuer certificate to the certificate seed value dictionary.
 *
 * See the PDF Reference for details.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aPtr       Pointer to the first octet of the DER-encoded
 *                       certificate.
 * @param[in] aSize      Size in octets of the DER-encoded certificate.
 *
 * @see SIGNDOC_Field_clearCertSeedValueIssuerCertificates(), SIGNDOC_Field_getCertSeedValueIssuerCertificate(), SIGNDOC_Field_getCertSeedValueIssuerCertificateUTF8(), SIGNDOC_Field_setCertSeedValueIssuerCertificate()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_addCertSeedValueIssuerCertificate (struct SIGNDOC_Exception **aEx,
                                                 struct SIGNDOC_Field *aObj,
                                                 const void *aPtr, size_t aSize);

/**
 * @brief Set an issuer certificate in the certificate seed value dictionary.
 *
 * See the PDF Reference for details.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex     0-based index of the issuer certificate to be set.
 *                       If @a aIndex equals the current number of
 *                       values, the certificate will be added.
 * @param[in] aPtr       Pointer to the first octet of the DER-encoded
 *                       certificate.
 * @param[in] aSize      Size in octets of the DER-encoded certificate.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if @a aIndex is out of range.
 *
 * @see SIGNDOC_Field_clearCertSeedValueIssuerCertificates(), SIGNDOC_Field_getCertSeedValueIssuerCertificate(), SIGNDOC_Field_getCertSeedValueIssuerCertificateUTF8()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_setCertSeedValueIssuerCertificateByIndex (struct SIGNDOC_Exception **aEx,
                                                        struct SIGNDOC_Field *aObj,
                                                        int aIndex,
                                                        const void *aPtr,
                                                        size_t aSize);

/**
 * @brief Set an issuer certificate in the certificate seed value dictionary.
 *
 * See the PDF Reference for details.
 *
 * Calling this function is equivalent to calling clearCertSeedValueIssuerCertificates() and
 * addCertSeedValueIssuerCertificate().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aPtr       Pointer to the first octet of the DER-encoded
 *                       certificate.
 * @param[in] aSize      Size in octets of the DER-encoded certificate.
 *
 * @see SIGNDOC_Field_clearCertSeedValueIssuerCertificates(), SIGNDOC_Field_getCertSeedValueIssuerCertificate(), SIGNDOC_Field_getCertSeedValueIssuerCertificateUTF8()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setCertSeedValueIssuerCertificate (struct SIGNDOC_Exception **aEx,
                                                 struct SIGNDOC_Field *aObj,
                                                 const void *aPtr, size_t aSize);

/**
 * @brief Remove an issuer certificate from the certificate seed value
 *        dictionary.
 *
 * See the PDF Reference for details.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex     The 0-based index of the issuer certificate to
 *                       be removed.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if @a aIndex is
 *         out of range.
 *
 * @see SIGNDOC_Field_clearCertSeedValueIssuerCertificates(), SIGNDOC_Field_getCertSeedValueIssuerCertificate(), SIGNDOC_Field_getCertSeedValueIssuerCertificateUTF8()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_removeCertSeedValueIssuerCertificate (struct SIGNDOC_Exception **aEx,
                                                    struct SIGNDOC_Field *aObj,
                                                    int aIndex);

/**
 * @brief Get the number of policy OIDs in the certificate seed value
 *        dictionary.
 *
 * See the PDF Reference for details.
 *
 * @return The number of policy OIDs.
 *
 * @see SIGNDOC_Field_addCertSeedValuePolicy(), SIGNDOC_Field_clearCertSeedValuePolicies(), SIGNDOC_Field_getCertSeedValuePolicy(), SIGNDOC_Field_getCertSeedValuePolicyUTF8(), SIGNDOC_Field_removeCertSeedValuePolicy()
 *
 * @memberof SIGNDOC_Field
 */
int SDCAPI
SIGNDOC_Field_getCertSeedValuePolicyCount (struct SIGNDOC_Exception **aEx,
                                           struct SIGNDOC_Field *aObj);

/**
 * @brief Get a policy OID from the certificate seed value dictionary.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the value cannot be
 * represented using the specified encoding.
 *
 * See the PDF Reference for details.
 *
 * @note OIDs should be ASCII strings.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding to be used for the return value
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aIndex     0-based index of the policy OID.
 *
 * @return The selected policy OID or an empty string if the index
 *         is out of range.
 *         The string must be freed with SIGNDOC_free().
 *
 * @see SIGNDOC_Field_addCertSeedValuePolicy(), SIGNDOC_Field_clearCertSeedValuePolicies(), SIGNDOC_Field_getCertSeedValuePolicyCount(), SIGNDOC_Field_getCertSeedValuePolicyUTF8(), SIGNDOC_Field_removeCertSeedValuePolicy(), SIGNDOC_Field_setCertSeedValuePolicy()
 *
 * @memberof SIGNDOC_Field
 */
char * SDCAPI
SIGNDOC_Field_getCertSeedValuePolicy (struct SIGNDOC_Exception **aEx,
                                      struct SIGNDOC_Field *aObj,
                                      int aEncoding, int aIndex);

/**
 * @brief Get a policy OID from the certificate seed value dictionary.
 *
 * See the PDF Reference for details.
 *
 * @note OIDs should be ASCII strings.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex     0-based index of the policy OID.
 *
 * @return The selected policy OID or an empty string if the index
 *         is out of range.  This pointer will become invalid when
 *         SIGNDOC_Field_addCertSeedValuePolicy(),
 *         SIGNDOC_Field_clearCertSeedValuePolicies(),
 *         SIGNDOC_Field_removeCertSeedValuePolicy(), or
 *         SIGNDOC_Field_setCertSeedValuePolicy() is
 *         called or @a aObj is destroyed.
 *
 * @see SIGNDOC_Field_addCertSeedValuePolicy(), SIGNDOC_Field_clearCertSeedValuePolicies(), SIGNDOC_Field_getCertSeedValuePolicyCount(), SIGNDOC_Field_getCertSeedValuePolicyUTF8(), SIGNDOC_Field_setCertSeedValuePolicy()
 *
 * @memberof SIGNDOC_Field
 */
const char * SDCAPI
SIGNDOC_Field_getCertSeedValuePolicyUTF8 (struct SIGNDOC_Exception **aEx,
                                          struct SIGNDOC_Field *aObj,
                                          int aIndex);

/**
 * @brief Remove all policy OIDs from the certificate seed value dictionary.
 *
 * See the PDF Reference for details.
 *
 * After calling this function,
 * SIGNDOC_Field_getCertSeedValuePolicyCount() will return 0.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @see SIGNDOC_Field_addCertSeedValuePolicy(), SIGNDOC_Field_getCertSeedValuePolicyCount(), SIGNDOC_Field_removeCertSeedValuePolicy()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_clearCertSeedValuePolicies (struct SIGNDOC_Exception **aEx,
                                          struct SIGNDOC_Field *aObj);

/**
 * @brief Add a policy OID to the certificate seed value dictionary.
 *
 * See the PDF Reference for details.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the value is not correctly
 * encoded according to the specified encoding.
 *
 * @note OIDs should be ASCII strings.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding of @a aOID
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aOID       The policy OID.
 *
 * @see SIGNDOC_Field_clearCertSeedValuePolicies(), SIGNDOC_Field_getCertSeedValuePolicy(), SIGNDOC_Field_getCertSeedValuePolicyUTF8(), SIGNDOC_Field_setCertSeedValuePolicy()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_addCertSeedValuePolicy (struct SIGNDOC_Exception **aEx,
                                      struct SIGNDOC_Field *aObj,
                                      int aEncoding, const char *aOID);

/**
 * @brief Set a policy OID in the certificate seed value dictionary.
 *
 * See the PDF Reference for details.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the value is not correctly
 * encoded according to the specified encoding.
 *
 * @note OIDs should be ASCII strings.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex     The 0-based index of the value to be set.
 *                       If @a aIndex equals the current number of
 *                       values, the value will be added.
 * @param[in] aEncoding  The encoding of @a aOID
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aOID       The policy OID.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if @a aIndex is
 *         out of range.
 *
 * @see SIGNDOC_Field_clearCertSeedValuePolicies(), SIGNDOC_Field_getCertSeedValuePolicy(), SIGNDOC_Field_getCertSeedValuePolicyUTF8()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_setCertSeedValuePolicyByIndex (struct SIGNDOC_Exception **aEx,
                                             struct SIGNDOC_Field *aObj,
                                             int aIndex, int aEncoding, const char *aOID);

/**
 * @brief Set a policy OID in the certificate seed value dictionary.
 *
 * See the PDF Reference for details.
 *
 * Calling this function is equivalent to calling
 * SIGNDOC_Field_clearCertSeedValuePolicies() and
 * SIGNDOC_Field_addCertSeedValuePolicy(), but the encoding of @a aOID
 * is checked before modifying @a aObj.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the value is not correctly
 * encoded according to the specified encoding.
 *
 * @note OIDs should be ASCII strings.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding of @a aOID
                         (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
                         or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aOID       The policy OID.
 *
 * @see SIGNDOC_Field_clearCertSeedValuePolicies(), SIGNDOC_Field_getCertSeedValuePolicy(), SIGNDOC_Field_getCertSeedValuePolicyUTF8()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setCertSeedValuePolicy (struct SIGNDOC_Exception **aEx,
                                      struct SIGNDOC_Field *aObj,
                                      int aEncoding, const char *aOID);

/**
 * @brief Remove a policy OID from the certificate seed value dictionary.
 *
 * See the PDF Reference for details.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aIndex     The 0-based index of the policy OID to be removed.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if @a aIndex is
 *         out of range.
 *
 * @see SIGNDOC_Field_clearCertSeedValuePolicies(), SIGNDOC_Field_getCertSeedValuePolicy(), SIGNDOC_Field_getCertSeedValuePolicyUTF8()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_removeCertSeedValuePolicy (struct SIGNDOC_Exception **aEx,
                                         struct SIGNDOC_Field *aObj,
                                         int aIndex);

/**
 * @brief Get the URL of the RFC 3161 time-stamp server from the
 *        signature field seed value dictionary.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the value cannot be
 * represented using the specified encoding.
 *
 * @note The URL should be an ASCII string.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding to be used for the return value
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 *
 * @return The URL of the time-stamp server or an empty string if
 *         no time-stamp server is defined.
 *         The string must be freed with SIGNDOC_free().
 *
 * @see SIGNDOC_Field_getSeedValueTimeStampRequired(), SIGNDOC_Field_setSeedValueTimeStamp()
 *
 * @memberof SIGNDOC_Field
 */
char * SDCAPI
SIGNDOC_Field_getSeedValueTimeStampServerURL (struct SIGNDOC_Exception **aEx,
                                              struct SIGNDOC_Field *aObj,
                                              int aEncoding);

/**
 * @brief This function gets a flag from the signature field seed value
 *        dictionary that indicates whether a time stamp is required or
 *        not for the signature.
 *
 * If this function returns #SIGNDOC_TRUE, the URL returned by
 * SIGNDOC_Field_getSeedValueTimeStampServerURL() will be used to add a time
 * stamp to the signature when signing.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return #SIGNDOC_FALSE if a time stamp is not required,
 *         #SIGNDOC_TRUE if a time stamp is required.
 *
 * @see SIGNDOC_Field_getSeedValueTimeStampServerURL()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_getSeedValueTimeStampRequired (struct SIGNDOC_Exception **aEx,
                                             struct SIGNDOC_Field *aObj);

/**
 * @brief Set the URL of an RFC 3161 time-stamp server in the
 *        signature field seed value dictionary.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the value is not correctly
 * encoded according to the specified encoding.
 *
 * @note URLs must be ASCII strings.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aEncoding  The encoding of @a aURL
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aURL       The URL (must be ASCII), empty for no time-stamp
 *                       server. Must be non-empty if @a aRequired is
 *                       #SIGNDOC_TRUE.
 *                       The scheme must be http or https.
 * @param[in] aRequired  #SIGNDOC_TRUE if a time stamp is required,
 *                       #SIGNDOC_FALSE if a time stamp is not required.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if @a aURL is invalid.
 *
 * @see SIGNDOC_Field_getSeedValueTimeStampRequired(), SIGNDOC_Field_getSeedValueTimeStampServerURL()
 *
 * @memberof SIGNDOC_Field
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_Field_setSeedValueTimeStamp (struct SIGNDOC_Exception **aEx,
                                     struct SIGNDOC_Field *aObj,
                                     int aEncoding, const char *aURL,
                                     SIGNDOC_Boolean aRequired);

/**
 * @brief Get the color used for empty signature field in TIFF document.
 *
 * The default value is white.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 *
 * @return A pointer to a new SignDocColor object describing the color used
 *         for empty signature fields in a TIFF document. The caller is
 *         responsible for destroying the object with SIGNDOC_Color_delete().
 *         The return value is NULL for other types of documents.
 *
 * @see SIGNDOC_Field_setEmptyFieldColor()
 *
 * @memberof SIGNDOC_Field
 */
struct SIGNDOC_Color * SDCAPI
SIGNDOC_Field_getEmptyFieldColor (struct SIGNDOC_Exception **aEx,
                                  struct SIGNDOC_Field *aObj);

/**
 * @brief Set color used for empty signature field in TIFF document.
 *
 * The default value is white.  For non-TIFF documents, the value
 * set by this function is ignored.  The value is also ignored if
 * compatibility with version 1.12 and earlier is requested.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Field object.
 * @param[in] aColor   The new color.
 *
 * @see SIGNDOC_Field_getEmptyFieldColor(), SIGNDOC_Document_setCompatibility()
 *
 * @memberof SIGNDOC_Field
 */
void SDCAPI
SIGNDOC_Field_setEmptyFieldColor (struct SIGNDOC_Exception **aEx,
                                  struct SIGNDOC_Field *aObj,
                                  const struct SIGNDOC_Color *aColor);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_FindTextPosition constructor.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 *
 * @memberof SIGNDOC_FindTextPosition
 */
struct SIGNDOC_FindTextPosition * SDCAPI
SIGNDOC_FindTextPosition_new (struct SIGNDOC_Exception **aEx);

/**
 * @brief SIGNDOC_FindTextPosition destructor.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_FindTextPosition object,
 *                     must not be a pointer returned by
 *                     SIGNDOC_FindTextPositionArray_at().
 *
 * @memberof SIGNDOC_FindTextPosition
 */
void SDCAPI
SIGNDOC_FindTextPosition_delete (struct SIGNDOC_FindTextPosition *aObj);

/**
 * @brief Get the SIGNDOC_CharacterPosition object for the first character.
 *
 * @deprecated Please use mFirst directly.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_FindTextPosition object.
 *
 * @return A pointer to mFirst of @a aObj.
 *         The SIGNDOC_CharacterPosition object is not cloned.
 *
 * @memberof SIGNDOC_FindTextPosition
 */
struct SIGNDOC_CharacterPosition * SDCAPI
SIGNDOC_FindTextPosition_getFirst (struct SIGNDOC_FindTextPosition *aObj);

/**
 * @brief Set the SIGNDOC_CharacterPosition object for the first character.
 *
 * @deprecated Please use mFirst directly.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_FindTextPosition object.
 * @param[in] aFirst   A pointer to the SIGNDOC_CharacterPosition object.
 *
 * @memberof SIGNDOC_FindTextPosition
 */
void SDCAPI
SIGNDOC_FindTextPosition_setFirst (struct SIGNDOC_FindTextPosition *aObj,
                                   struct SIGNDOC_CharacterPosition *aFirst);

/**
 * @brief Get the SIGNDOC_CharacterPosition object for the last character.
 *
 * @deprecated Please use mLast directly.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_FindTextPosition object.
 *
 * @return A pointer to mLast of @a aObj.
 *         The SIGNDOC_CharacterPosition object is not cloned.
 *
 * @memberof SIGNDOC_FindTextPosition
 */
struct SIGNDOC_CharacterPosition * SDCAPI
SIGNDOC_FindTextPosition_getLast (struct SIGNDOC_FindTextPosition *aObj);

/**
 * @brief Set the SIGNDOC_CharacterPosition object for the last character.
 *
 * @deprecated Please use mLast directly.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_FindTextPosition object.
 * @param[in] aLast    A pointer to the SIGNDOC_CharacterPosition object.
 *
 * @memberof SIGNDOC_FindTextPosition
 */
void SDCAPI
SIGNDOC_FindTextPosition_setLast (struct SIGNDOC_FindTextPosition *aObj,
                                  struct SIGNDOC_CharacterPosition *aLast);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_Property constructor.
 *
 * The new SIGNDOC_Property object will have one widget.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 *
 * @memberof SIGNDOC_Property
 */
struct SIGNDOC_Property * SDCAPI
SIGNDOC_Property_new (struct SIGNDOC_Exception **aEx);

/**
 * @brief Clone a SIGNDOC_Property object.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aSource  The object to be copied.
 *
 * @memberof SIGNDOC_Property
 */
struct SIGNDOC_Property * SDCAPI
SIGNDOC_Property_clone (struct SIGNDOC_Exception **aEx,
                        const struct SIGNDOC_Property *aSource);

/**
 * @brief SIGNDOC_Property destructor.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Property object,
 *                     must not be a pointer returned by
 *                     SIGNDOC_PropertyArray_at().
 *
 * @memberof SIGNDOC_Property
 */
void SDCAPI
SIGNDOC_Property_delete (struct SIGNDOC_Property *aObj);

/**
 * @brief Get the name of the property.
 *
 * Property names are compared under Unicode simple case folding, that is,
 * lower case and upper case is not distinguished.
 *
 * This function throws an exception of type
 * #SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR if the name cannot be
 * represented using the specified encoding.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Property object.
 * @param[in] aEncoding  The encoding to be used for the return value
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 *
 * @return The name of the property.
 *         The string must be freed with SIGNDOC_free().
 *
 * @see SIGNDOC_Property_getNameUTF8()
 *
 * @memberof SIGNDOC_Property
 */
char * SDCAPI
SIGNDOC_Property_getName (struct SIGNDOC_Exception **aEx,
                          struct SIGNDOC_Property *aObj,
                          int aEncoding);

/**
 * @brief Get the name of the property as UTF-8-encoded C string.
 *
 * Property names are compared under Unicode simple case folding, that is,
 * lower case and upper case is not distinguished.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Property object.
 *
 * @return The name of the property.  This pointer will become invalid
 *         when @a aObj is destroyed.
 *
 * @see SIGNDOC_Property_getName()
 *
 * @memberof SIGNDOC_Property
 */
const char * SDCAPI
SIGNDOC_Property_getNameUTF8 (struct SIGNDOC_Exception **aEx,
                              struct SIGNDOC_Property *aObj);

/**
 * @brief Get the type of the property.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Property object.
 *
 * @return The type of the property:
 *         #SIGNDOC_PROPERTY_TYPE_STRING,
 *         #SIGNDOC_PROPERTY_TYPE_INTEGER, or
 *         #SIGNDOC_PROPERTY_TYPE_BOOLEAN.
 *
 * @memberof SIGNDOC_Property
 */
int SDCAPI
SIGNDOC_Property_getType (struct SIGNDOC_Exception **aEx,
                          struct SIGNDOC_Property *aObj);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_RenderOutput constructor.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 *
 * @memberof SIGNDOC_RenderOutput
 */
struct SIGNDOC_RenderOutput * SDCAPI
SIGNDOC_RenderOutput_new (struct SIGNDOC_Exception **aEx);

/**
 * @brief SIGNDOC_RenderOutput destructor.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_RenderOutput object.
 *
 * @memberof SIGNDOC_RenderOutput
 */
void SDCAPI
SIGNDOC_RenderOutput_delete (struct SIGNDOC_RenderOutput *aObj);

/**
 * @brief Get the width of the rendered page in pixels.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_RenderOutput object.
 *
 * @return The width of the rendered page in pixels.
 *
 * @memberof SIGNDOC_RenderOutput
 */
int SDCAPI
SIGNDOC_RenderOutput_getWidth (const struct SIGNDOC_RenderOutput *aObj);

/**
 * @brief Get the height of the rendered page in pixels.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_RenderOutput object.
 *
 * @return The height of the rendered page in pixels.
 *
 * @memberof SIGNDOC_RenderOutput
 */
int SDCAPI
SIGNDOC_RenderOutput_getHeight (const struct SIGNDOC_RenderOutput *aObj);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_RenderParameters constructor.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 *
 * @memberof SIGNDOC_RenderParameters
 */
struct SIGNDOC_RenderParameters * SDCAPI
SIGNDOC_RenderParameters_new (struct SIGNDOC_Exception **aEx);

/**
 * @brief Clone a SIGNDOC_RenderParameters object.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aSource  The object to be copied.
 *
 * @memberof SIGNDOC_RenderParameters
 */
struct SIGNDOC_RenderParameters * SDCAPI
SIGNDOC_RenderParameters_clone (struct SIGNDOC_Exception **aEx,
                                const struct SIGNDOC_RenderParameters *aSource);

/**
 * @brief SIGNDOC_RenderParameters destructor.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 *
 * @memberof SIGNDOC_RenderParameters
 */
void SDCAPI
SIGNDOC_RenderParameters_delete (struct SIGNDOC_RenderParameters *aObj);

/**
 * @brief SIGNDOC_RenderParameters assignment operator.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[in] aSource  The source object.
 *
 * @memberof SIGNDOC_RenderParameters
 */
void SDCAPI
SIGNDOC_RenderParameters_assign (struct SIGNDOC_Exception **aEx,
                                 struct SIGNDOC_RenderParameters *aObj,
                              const struct SIGNDOC_RenderParameters *aSource);

/**
 * @brief "Less than" operator for SIGNDOC_RenderParameters.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[in] aOther   The object to compare against.
 *
 * @return #SIGNDOC_TRUE if @a aObj compares less than @a aOther,
 *         #SIGNDOC_FALSE otherwise.
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_isLessThan (const struct SIGNDOC_RenderParameters *aObj,
                                     const struct SIGNDOC_RenderParameters *aOther);

/**
 * @brief Select the page to be rendered.
 *
 * There is no initial value, ie, either this function or
 * SIGNDOC_RenderParameters_setPages() must be called.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[in]  aPage  The page number (1 for the first page).
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if the page number
 *         is invalid.
 *
 * @see SIGNDOC_RenderParameters_getPage(), SIGNDOC_RenderParameters_setPages()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_setPage (struct SIGNDOC_Exception **aEx,
                                  struct SIGNDOC_RenderParameters *aObj,
                                  int aPage);

/**
 * @brief Get the number of the selected page.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[out]  aPage  The page number (1 for the first page) will be
 *                     stored here.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if
 *         SIGNDOC_RenderParameters_setPage() has not been called
 *         successfully or if multiple pages have been selected with
 *         SIGNDOC_RenderParameters_setPages()
 *
 * @see SIGNDOC_RenderParameters_getPages(), SIGNDOC_RenderParameters_setPage()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_getPage (struct SIGNDOC_Exception **aEx,
                                  struct SIGNDOC_RenderParameters *aObj,
                                  int *aPage);

/**
 * @brief Select a range of pages to be rendered.
 *
 * There is no initial value, ie, either this function or
 * SIGNDOC_RenderParameters_setPage() must be called.
 *
 * @note If multiple pages are selected, the image format must be "tiff"
 *       for SIGNDOC_Document_renderPageAsImage().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[in]  aFirst  The first page number of the range (1 for the
 *                     first page of the document).
 * @param[in]  aLast   The last page number of the range (1 for the
 *                     first page of the document).
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if the page numbers
 *         are invalid.
 *
 * @see SIGNDOC_RenderParameters_getPages(), SIGNDOC_RenderParameters_setFormat(), SIGNDOC_RenderParameters_setPage()
 *
 * @memberof SIGNDOC_RenderParameters
 *
 * @todo implement for TIFF documents
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_setPages (struct SIGNDOC_Exception **aEx,
                                   struct SIGNDOC_RenderParameters *aObj,
                                   int aFirst, int aLast);

/**
 * @brief Get the selected range of page numbers.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[out]  aFirst The first page number of the range (1 for the
 *                     first page of the document) will be
 *                     stored here.
 * @param[out]  aLast  The last page number of the range (1 for the
 *                     first page of the document) will be
 *                     stored here.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if
 *         SIGNDOC_RenderParameters_setPage() and
 *         SIGNDOC_RenderParameters_setPages() have
 *         not been called.
 *
 * @see SIGNDOC_RenderParameters_getPage(), SIGNDOC_RenderParameters_setPages()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_getPages (struct SIGNDOC_Exception **aEx,
                                   struct SIGNDOC_RenderParameters *aObj,
                                   int *aFirst, int *aLast);

/** @brief Set the resolution for rendering PDF documents.
 *
 * The values passed to this function will be ignored for TIFF
 * documents as the resolution is computed automatically from the
 * zoom factor and the document's resolution.
 *
 * If this function is not called, 96 DPI (subject to change) will
 * be used for rendering PDF documents.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[in] aResX  Horizontal resolution in DPI.
 * @param[in] aResY  Vertical resolution in DPI.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if the resolution
 *         is invalid.
 *
 * @see SIGNDOC_RenderParameters_getResolution(), SIGNDOC_RenderParameters_setZoom()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_setResolution (struct SIGNDOC_Exception **aEx,
                                        struct SIGNDOC_RenderParameters *aObj,
                                        double aResX, double aResY);

/** @brief Get the resolution set by SIGNDOC_RenderParameters_setResolution().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[out] aResX  Horizontal resolution in DPI.
 * @param[out] aResY  Vertical resolution in DPI.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if setResolution()
 *         has not been called successfully.
 *
 * @see SIGNDOC_RenderParameters_setResolution()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_getResolution (struct SIGNDOC_Exception **aEx,
                                        struct SIGNDOC_RenderParameters *aObj,
                                        double *aResX, double *aResY);

/**
 * @brief Set the zoom factor for rendering.
 *
 * There is no initial value, ie, this function or
 * SIGNDOC_RenderParameters_fitWidth() or
 * SIGNDOC_RenderParameters_fitHeight() or
 * SIGNDOC_RenderParameters_fitRect() must be called.  This function overrides
 * SIGNDOC_RenderParameters_fitWidth(),
 * SIGNDOC_RenderParameters_fitHeight(), and
 * SIGNDOC_RenderParameters_fitRect().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[in]  aZoom  The zoom factor.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if the zoom factor
 *         is invalid.
 *
 * @see SIGNDOC_RenderParameters_fitHeight(), SIGNDOC_RenderParameters_fitRect(), SIGNDOC_RenderParameters_fitWidth(), SIGNDOC_RenderParameters_getZoom()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_setZoom (struct SIGNDOC_Exception **aEx,
                                  struct SIGNDOC_RenderParameters *aObj,
                                  double aZoom);

/**
 * @brief Get the zoom factor set by SIGNDOC_RenderParameters_setZoom().
 *
 * This function does not retrieve the zoom factor to be computed for
 * SIGNDOC_RenderParameters_fitWidth(),
 * SIGNDOC_RenderParameters_fitHeight(), and
 * SIGNDOC_RenderParameters_fitRect(). Use
 * SIGNDOC_Document_computeZoom() for that.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[out]  aZoom  The zoom factor will be stored here.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if
 *         SIGNDOC_RenderParameters_setZoom() has not been
 *         called successfully or has been overridden.
 *
 * @see SIGNDOC_RenderParameters_fitHeight(), SIGNDOC_RenderParameters_fitRect(), SIGNDOC_RenderParameters_fitWidth(), SIGNDOC_RenderParameters_setZoom(), SIGNDOC_Document_computeZoom()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_getZoom (struct SIGNDOC_Exception **aEx,
                                  struct SIGNDOC_RenderParameters *aObj,
                                  double *aZoom);

/**
 * @brief Set the width for automatic computation of the zoom factor
 *        to make the rendered image fit the specified width.
 *
 * This function overrides the zoom factor set by
 * SIGNDOC_RenderParameters_fitHeight(),
 * SIGNDOC_RenderParameters_fitRect(), and
 * SIGNDOC_RenderParameters_setZoom().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[in]  aWidth  The desired width (in pixels) of the rendered image.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if the specified width
 *         is invalid.
 *
 * @see SIGNDOC_RenderParameters_fitHeight(), SIGNDOC_RenderParameters_fitRect(), SIGNDOC_RenderParameters_getFitWidth(), SIGNDOC_RenderParameters_setZoom(), SIGNDOC_Document_computeZoom()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_fitWidth (struct SIGNDOC_Exception **aEx,
                                   struct SIGNDOC_RenderParameters *aObj,
                                   int aWidth);

/**
 * @brief Get the width set by SIGNDOC_RenderParameters_fitWidth().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[out]  aWidth  The width will be stored here.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if
 *         SIGNDOC_RenderParameters_fitWidth() has not been called
 *         successfully or has been overridden.
 *
 * @see SIGNDOC_RenderParameters_fitWidth()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_getFitWidth (struct SIGNDOC_Exception **aEx,
                                      struct SIGNDOC_RenderParameters *aObj,
                                      int *aWidth);

/**
 * @brief Set the height for automatic computation of the zoom factor
 *        to make the rendered image fit the specified height.
 *
 * This function overrides the zoom factor set by
 * SIGNDOC_RenderParameters_fitWidth(),
 * SIGNDOC_RenderParameters_fitRect(), and
 * SIGNDOC_RenderParameters_setZoom().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[in]  aHeight  The desired height (in pixels) of the rendered image.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if the specified height
 *         is invalid.
 *
 * @see SIGNDOC_RenderParameters_fitRect(), SIGNDOC_RenderParameters_fitWidth(), SIGNDOC_RenderParameters_getFitHeight(), SIGNDOC_RenderParameters_setZoom(), SIGNDOC_Document_computeZoom()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_fitHeight (struct SIGNDOC_Exception **aEx,
                                    struct SIGNDOC_RenderParameters *aObj,
                                    int aHeight);

/**
 * @brief Get the height set by SIGNDOC_RenderParameters_fitHeight().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[out]  aHeight  The height will be stored here.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if
 *         SIGNDOC_RenderParameters_fitHeight() has not been called
 *         successfully or has been overridden.
 *
 * @see SIGNDOC_RenderParameters_fitHeight()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_getFitHeight (struct SIGNDOC_Exception **aEx,
                                       struct SIGNDOC_RenderParameters *aObj,
                                       int *aHeight);

/**
 * @brief Set the width and height for automatic computation of the zoom
 *        factor to make the rendered image fit the specified width and
 *        height.
 *
 * This function overrides the zoom factor set by
 * SIGNDOC_RenderParameters_fitWidth(),
 * SIGNDOC_RenderParameters_fitHeight(), and
 * SIGNDOC_RenderParameters_setZoom().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[in]  aWidth   The desired width (in pixels) of the rendered image.
 * @param[in]  aHeight  The desired height (in pixels) of the rendered image.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if the specified width
 *         or height is invalid.
 *
 * @see SIGNDOC_RenderParameters_fitHeight(), SIGNDOC_RenderParameters_fitWidth(), SIGNDOC_RenderParameters_getFitRect(), SIGNDOC_RenderParameters_setZoom(), SIGNDOC_Document_computeZoom()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_fitRect (struct SIGNDOC_Exception **aEx,
                                  struct SIGNDOC_RenderParameters *aObj,
                                  int aWidth, int aHeight);

/**
 * @brief Get the width and height set by SIGNDOC_RenderParameters_fitRect().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[out]  aWidth   The width will be stored here.
 * @param[out]  aHeight  The height will be stored here.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if
 *         SIGNDOC_RenderParameters_fitRect() has not been called
 *         successfully or has been overridden.
 *
 * @see SIGNDOC_RenderParameters_fitRect()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_getFitRect (struct SIGNDOC_Exception **aEx,
                                     struct SIGNDOC_RenderParameters *aObj,
                                     int *aWidth, int *aHeight);

/**
 * @brief Set the image format.
 *
 * There is no initial value, ie, this function must be called if
 * this object is to be used for SIGNDOC_Document_renderPageAsImage().
 *
 * Currently, this function does not check the image format.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[in]  aFormat  The desired format of the image ("jpg", "png",
 *                      "tiff", or "bmp").
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if the image format
 *         is invalid.
 *
 * @see SIGNDOC_RenderParameters_getFormat(), SIGNDOC_RenderParameters_setInterlacing()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_setFormat (struct SIGNDOC_Exception **aEx,
                                    struct SIGNDOC_RenderParameters *aObj,
                                    const char *aFormat);

/**
 * @brief Get the image format.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[out]  aFormat   The image format will be stored here.
 *                        The string must be freed with SIGNDOC_free().
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if
 *         SIGNDOC_RenderParameters_setFormat() has not been called
 *         successfully.
 *
 * @see SIGNDOC_RenderParameters_setFormat()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_getFormat (struct SIGNDOC_Exception **aEx,
                                    struct SIGNDOC_RenderParameters *aObj,
                                    char **aFormat);

/**
 * @brief Set the interlacing method.
 *
 * Interlacing is used for progressive encoding.
 * The initial value is #SIGNDOC_RENDERPARAMETERS_INTERLACING_OFF.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[in]  aInterlacing  The interlacing method:
 *                           #SIGNDOC_RENDERPARAMETERS_INTERLACING_OFF or
 *                           #SIGNDOC_RENDERPARAMETERS_INTERLACING_ON.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if the interlacing mode
 *         is invalid.
 *
 * @see SIGNDOC_RenderParameters_getInterlacing(), SIGNDOC_RenderParameters_setFormat()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_setInterlacing (struct SIGNDOC_Exception **aEx,
                                         struct SIGNDOC_RenderParameters *aObj,
                                         int aInterlacing);

/**
 * @brief Get the interlacing method.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[out]  aInterlacing   The interlacing mode will be
 *                             stored here.
 *
 * @return #SIGNDOC_TRUE if successful. This function never fails.
 *
 * @see SIGNDOC_RenderParameters_setInterlacing()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_getInterlacing (struct SIGNDOC_Exception **aEx,
                                         struct SIGNDOC_RenderParameters *aObj,
                                         int *aInterlacing);

/**
 * @brief Set the desired quality.
 *
 * This setting affects scaling of pages of TIFF documents.
 * The initial value is #SIGNDOC_RENDERPARAMETERS_QUALITY_LOW.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[in]  aQuality  The desired quality:
 *                       #SIGNDOC_RENDERPARAMETERS_QUALITY_LOW or
 *                       #SIGNDOC_RENDERPARAMETERS_QUALITY_HIGH.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if the argument
 *         is invalid.
 *
 * @see SIGNDOC_RenderParameters_getQuality()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_setQuality (struct SIGNDOC_Exception **aEx,
                                     struct SIGNDOC_RenderParameters *aObj,
                                     int aQuality);

/**
 * @brief Get the desired quality.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[out]  aQuality   The quality setting will be stored here.
 *
 * @return #SIGNDOC_TRUE if successful. This function never fails.
 *
 * @see SIGNDOC_RenderParameters_setQuality()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_getQuality (struct SIGNDOC_Exception **aEx,
                                     struct SIGNDOC_RenderParameters *aObj,
                                     int *aQuality);

/**
 * @brief Set the pixel format.
 *
 * The initial value is #SIGNDOC_RENDERPARAMETERS_PIXELFORMAT_DEFAULT.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[in]  aPixelFormat  The pixel format:
 *                           #SIGNDOC_RENDERPARAMETERS_PIXELFORMAT_DEFAULT or
 *                           #SIGNDOC_RENDERPARAMETERS_PIXELFORMAT_BW.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if the argument
 *         is invalid.
 *
 * @see SIGNDOC_RenderParameters_getPixelFormat()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_setPixelFormat (struct SIGNDOC_Exception **aEx,
                                         struct SIGNDOC_RenderParameters *aObj,
                                         int aPixelFormat);

/**
 * @brief Get the pixel format.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[out]  aPixelFormat   The pixel format will be stored here.
 *
 * @return #SIGNDOC_TRUE if successful. This function never fails.
 *
 * @see SIGNDOC_RenderParameters_setPixelFormat()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_getPixelFormat (struct SIGNDOC_Exception **aEx,
                                         struct SIGNDOC_RenderParameters *aObj,
                                         int *aPixelFormat);

/**
 * @brief Set the compression compression.
 *
 * The initial value is #SIGNDOC_RENDERPARAMETERS_COMPRESSION_DEFAULT.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[in]  aCompression  The compression method:
 *                           #SIGNDOC_RENDERPARAMETERS_COMPRESSION_DEFAULT,
 *                           #SIGNDOC_RENDERPARAMETERS_COMPRESSION_NONE,
 *                           #SIGNDOC_RENDERPARAMETERS_COMPRESSION_GROUP4,
 *                           #SIGNDOC_RENDERPARAMETERS_COMPRESSION_LZW,
 *                           #SIGNDOC_RENDERPARAMETERS_COMPRESSION_RLE or
 *                           #SIGNDOC_RENDERPARAMETERS_COMPRESSION_ZIP.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if the argument is invalid.
 *
 * @see SIGNDOC_RenderParameters_getCompression()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_setCompression (struct SIGNDOC_Exception **aEx,
                                         struct SIGNDOC_RenderParameters *aObj,
                                         int aCompression);

/**
 * @brief Get the compression method.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[out]  aCompression   The compression method will be stored here.
 *
 * @return #SIGNDOC_TRUE if successful. This function never fails.
 *
 * @see SIGNDOC_RenderParameters_setCompression()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_getCompression (struct SIGNDOC_Exception **aEx,
                                         struct SIGNDOC_RenderParameters *aObj,
                                         int *aCompression);

/**
 * @brief Set the certificate chain verification policy.
 *
 * The certificate chain verification policy is used by
 * SIGNDOC_Document_renderPageAsImage()
 * if SIGNDOC_RenderParameters_setDecorations(#SIGNDOC_TRUE) has been called
 *
 * The default value is
 * #SIGNDOC_RENDERPARAMETERS_CERTIFICATECHAINVERIFICATIONPOLICY_ACCEPT_SELF_SIGNED_WITH_RSA_BIO.
 * #SIGNDOC_RENDERPARAMETERS_CERTIFICATECHAINVERIFICATIONPOLICY_REQUIRE_TRUSTED_ROOT
 * is not implemented for PKCS #1 signatures.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[in] aPolicy  The certificate chain verification policy:
 *                     #SIGNDOC_RENDERPARAMETERS_CERTIFICATECHAINVERIFICATIONPOLICY_DONT_VERIFY,
 *                     #SIGNDOC_RENDERPARAMETERS_CERTIFICATECHAINVERIFICATIONPOLICY_ACCEPT_SELF_SIGNED,
 *                     #SIGNDOC_RENDERPARAMETERS_CERTIFICATECHAINVERIFICATIONPOLICY_ACCEPT_SELF_SIGNED_WITH_BIO,
 *                     #SIGNDOC_RENDERPARAMETERS_CERTIFICATECHAINVERIFICATIONPOLICY_ACCEPT_SELF_SIGNED_WITH_RSA_BIO or
 *                     #SIGNDOC_RENDERPARAMETERS_CERTIFICATECHAINVERIFICATIONPOLICY_REQUIRE_TRUSTED_ROOT.
 *
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if the argument
 *         is invalid.
 *
 * @see SIGNDOC_RenderParameters_getCertificateChainVerificationPolicy(), SIGNDOC_RenderParameters_setCertificateRevocationVerificationPolicy(), SIGNDOC_RenderParameters_setVerificationModel(), SIGNDOC_Document_renderPageAsImage()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_setCertificateChainVerificationPolicy (struct SIGNDOC_Exception **aEx,
                                                                struct SIGNDOC_RenderParameters *aObj,
                                                                int aPolicy);

/**
 * @brief Get the certificate chain verification policy.
 *
 * See SIGNDOC_RenderParameters_setCertificateChainVerificationPolicy()
 * for details.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[out] aPolicy  The certificate chain verification policy will
 *                      be stored here.
 *
 * @return #SIGNDOC_TRUE if successful. This function never fails.
 *
 * @see SIGNDOC_RenderParameters_getCertificateRevocationVerificationPolicy(), SIGNDOC_RenderParameters_getVerificationModel(), SIGNDOC_RenderParameters_setCertificateChainVerificationPolicy(), SIGNDOC_Document_renderPageAsImage()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_getCertificateChainVerificationPolicy (struct SIGNDOC_Exception **aEx,
                                                                struct SIGNDOC_RenderParameters *aObj,
                                                                int *aPolicy);

/**
 * @brief Set the certificate revocation verification policy.
 *
 * The certificate revocation verification policy is used by
 * SIGNDOC_Document_renderPageAsImage()
 * if SIGNDOC_RenderParameters_setDecorations(#SIGNDOC_TRUE) has been called
 *
 * The default value is #SIGNDOC_RENDERPARAMETERS_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_DONT_CHECK.
 * #SIGNDOC_RENDERPARAMETERS_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_ONLINE and
 * #SIGNDOC_RENDERPARAMETERS_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_OFFLINE
 * are not supported for PKCS #1 signatures.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[in] aPolicy  The certificate revocation verification policy:
 *                     #SIGNDOC_RENDERPARAMETERS_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_DONT_CHECK,
 *                      #SIGNDOC_RENDERPARAMETERS_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_OFFLINE or
 *                      #SIGNDOC_RENDERPARAMETERS_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_ONLINE.
 *
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if the argument
 *         is invalid.
 *
 * @see SIGNDOC_RenderParameters_getCertificateRevocationVerificationPolicy(), SIGNDOC_RenderParameters_setCertificateChainVerificationPolicy(), SIGNDOC_RenderParameters_setVerificationModel(), SIGNDOC_Document_renderPageAsImage()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_setCertificateRevocationVerificationPolicy (struct SIGNDOC_Exception **aEx,
                                                                     struct SIGNDOC_RenderParameters *aObj,
                                                                     int aPolicy);

/**
 * @brief Get the certificate revocation verification policy.
 *
 * See SIGNDOC_RenderParameters_setCertificateRevocationVerificationPolicy()
 * for details.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[out] aPolicy  The certificate revocation verification policy will
 *                      be stored here.
 *
 * @return #SIGNDOC_TRUE if successful. This function never fails.
 *
 * @see SIGNDOC_RenderParameters_getCertificateChainVerificationPolicy(), SIGNDOC_RenderParameters_getVerificationModel(), SIGNDOC_RenderParameters_setCertificateRevocationVerificationPolicy(), SIGNDOC_Document_renderPageAsImage()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_getCertificateRevocationVerificationPolicy (struct SIGNDOC_Exception **aEx,
                                                                     struct SIGNDOC_RenderParameters *aObj,
                                                                     int *aPolicy);

/**
 * @brief Set the certificate verification model.
 *
 * The certificate verification model is used by
 * SIGNDOC_Document_renderPageAsImage()
 * if SIGNDOC_RenderParameters_setDecorations(#SIGNDOC_TRUE) has been called
 *
 * The default value is #SIGNDOC_RENDERPARAMETERS_VERIFICATIONMODEL_DEFAULT.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[in] aModel   The certificate verification model:
 *                     #SIGNDOC_RENDERPARAMETERS_VERIFICATIONMODEL_DEFAULT or
 *                     #SIGNDOC_RENDERPARAMETERS_VERIFICATIONMODEL_GERMAN_SIG_LAW.
 *
 * @return #SIGNDOC_TRUE if successful, #SIGNDOC_FALSE if the argument is invalid.
 *
 * @see SIGNDOC_RenderParameters_getVerificationModel(), SIGNDOC_RenderParameters_setCertificateChainVerificationPolicy(), SIGNDOC_RenderParameters_setCertificateRevocationVerificationPolicy(), SIGNDOC_Document_renderPageAsImage()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_setVerificationModel (struct SIGNDOC_Exception **aEx,
                                               struct SIGNDOC_RenderParameters *aObj,
                                               int aModel);

/**
 * @brief Get the certificate verification model.
 *
 * See SIGNDOC_RenderParameters_setVerificationModel() for details.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[out] aModel  The certificate verification model will be stored
 *                     here.
 *
 * @return #SIGNDOC_TRUE if successful. This function never fails.
 *
 * @see SIGNDOC_RenderParameters_getCertificateChainVerificationPolicy(), SIGNDOC_RenderParameters_getCertificateRevocationVerificationPolicy(), SIGNDOC_RenderParameters_setVerificationModel(), SIGNDOC_Document_renderPageAsImage()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_getVerificationModel (struct SIGNDOC_Exception **aEx,
                                               struct SIGNDOC_RenderParameters *aObj,
                                               int *aModel);

/**
 * @brief Enable rendering of decorations.
 *
 * The default value is #SIGNDOC_FALSE.
 *
 * For PDF documents, pages may optionally be rendered with
 * decorations: An icon visualizing the signature status will be
 * added to each signature field:
 * - no icon (signature field not signed)
 * - green check mark (signature is OK)
 * - green check mark with yellow triangle (signature is OK but the
 *   certificate is not trusted or the document has been extended,
 *   ie, modified and saved incrementally after signing)
 * - red cross (signature broken)
 * .
 *
 * For TIFF documents, this value is ignored; a red cross will be
 * displayed in signature fields if the signature is broken.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[in]  aDecorations  #SIGNDOC_TRUE to render decorations.
 *
 * @return #SIGNDOC_TRUE if successful. This function never fails.
 *
 * @see SIGNDOC_RenderParameters_getDecorations(), SIGNDOC_RenderParameters_setPrint()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_setDecorations (struct SIGNDOC_Exception **aEx,
                                         struct SIGNDOC_RenderParameters *aObj,
                                         int aDecorations);

/**
 * @brief Get the value set by SIGNDOC_RenderParameters_setDecorations().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[out]  aDecorations  The flag will be stored here.
 *
 * @return #SIGNDOC_TRUE if successful. This function never fails.
 *
 * @see SIGNDOC_RenderParameters_getPrint(), SIGNDOC_RenderParameters_setDecorations()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_getDecorations (struct SIGNDOC_Exception **aEx,
                                         struct SIGNDOC_RenderParameters *aObj,
                                         int *aDecorations);

/**
 * @brief Enable rendering for printing.
 *
 * The default value is #SIGNDOC_FALSE (render for displaying).
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[in] aPrint   #SIGNDOC_TRUE to render for printing,
 *                     #SIGNDOC_FALSE to render for displaying.
 *
 * @return #SIGNDOC_TRUE if successful. This function never fails.
 *
 * @see SIGNDOC_RenderParameters_getPrint(), SIGNDOC_RenderParameters_setDecorations()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_setPrint (struct SIGNDOC_Exception **aEx,
                                   struct SIGNDOC_RenderParameters *aObj,
                                   int aPrint);

/**
 * @brief Get the value set by SIGNDOC_RenderParameters_setPrint().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[out]  aPrint  The flag will be stored here.
 *
 * @return #SIGNDOC_TRUE if successful. This function never fails.
 *
 * @see SIGNDOC_RenderParameters_getDecorations(), SIGNDOC_RenderParameters_setPrint()
 *
 * @memberof SIGNDOC_RenderParameters
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_RenderParameters_getPrint (struct SIGNDOC_Exception **aEx,
                                   struct SIGNDOC_RenderParameters *aObj,
                                   int *aPrint);

/**
 * @brief Compare against another SIGNDOC_RenderParameters object.
 *
 * The exact order of SIGNDOC_RenderParameters objects is unspecified but
 * consistent.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_RenderParameters object.
 * @param[in] aOther  The object to compare against.
 *
 * @return -1 if @a aObj compares smaller than @a aOther, 0 if @a aObj
 *         compares equal to @a aOther, 1 if @a aObj compares
 *         greater than @a aOther.
 *
 * @memberof SIGNDOC_RenderParameters
 */
int SDCAPI
SIGNDOC_RenderParameters_compare (struct SIGNDOC_Exception **aEx,
                                  struct SIGNDOC_RenderParameters *aObj,
                                  const struct SIGNDOC_RenderParameters *aOther);

/* --------------------------------------------------------------------------*/

/**
 * @brief Color type: Gray scale.
 */
#define SIGNDOC_COLOR_TYPE_GRAY         0

/**
 * @brief Color type: RGB color.
 */
#define SIGNDOC_COLOR_TYPE_RGB          1

/**
 * @brief A color.
 *
 * Use the static factory functions SIGNDOC_Color_createGray() and
 * SIGNDOC_Color_createRGB() to create SIGNDOC_Color objects.
 * Do not forget to destroy the objects after use.
 *
 * @class SIGNDOC_Color
 *
 * @todo color spaces (CalGray vs. DeviceGray etc.)
 */
struct SIGNDOC_Color;

/**
 * @brief Create a new gray-scale color object.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aIntensity The intensity (0 through 255, 0 is black).
 *
 * @return A pointer to the new color object. Do not forget to
 *         destroy the object after use.
 *
 * @memberof SIGNDOC_Color
 */
struct SIGNDOC_Color * SDCAPI
SIGNDOC_Color_createGray (struct SIGNDOC_Exception **aEx,
                         unsigned char aIntensity);

/**
 * @brief Create a new RGB color object.
 *
 * The values are in 0 through 255, 0 is black.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aRed   The value of the red channel.
 * @param[in] aGreen The value of the green channel.
 * @param[in] aBlue  The value of the blue channel.
 *
 * @return A pointer to the new color object. Do not forget to
 *         destroy the object after use.
 *
 * @memberof SIGNDOC_Color
 */
struct SIGNDOC_Color * SDCAPI
SIGNDOC_Color_createRGB (struct SIGNDOC_Exception **aEx,
                         unsigned char aRed, unsigned char aGreen,
                         unsigned char aBlue);

/**
 * @brief Create a copy of a SIGNDOC_Color object.
 *
 * Do not forget to destroy the copy after use.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Color object.
 *
 * @memberof SIGNDOC_Color
 */
struct SIGNDOC_Color * SDCAPI
SIGNDOC_Color_clone (struct SIGNDOC_Exception **aEx,
                     const struct SIGNDOC_Color *aObj);

/**
 * @brief SIGNDOC_Color destructor.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Color object.
 *
 * @memberof SIGNDOC_Color
 */
void SDCAPI
SIGNDOC_Color_delete (struct SIGNDOC_Color *aObj);

/**
 * @brief Get the color type of this object.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Color object.
 *
 * @return The color type:
 *         #SIGNDOC_COLOR_TYPE_GRAY or #SIGNDOC_COLOR_TYPE_RGB.
 *
 * @memberof SIGNDOC_Color
 */
int SDCAPI
SIGNDOC_Color_getType (const struct SIGNDOC_Color *aObj);

/**
 * @brief Get the number of color components (channels).
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Color object.
 *
 * @return 1 for gray scale, 3 for RGB.
 *
 * @memberof SIGNDOC_Color
 */
unsigned SDCAPI
SIGNDOC_Color_getNumberOfComponents (const struct SIGNDOC_Color *aObj);

/**
 * @brief Get one color component (channel).
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Color object.
 * @param[in] aIndex  The index of the color component (0 through 2).
 *                    The meaning depends on the color type.
 *
 * @return The value (0 through 255) of the color component
 *         @a aIndex or 0 if @a aIndex is out of range.
 *
 * @memberof SIGNDOC_Color
 */
unsigned char SDCAPI
SIGNDOC_Color_getComponent (const struct SIGNDOC_Color *aObj,
                            unsigned aIndex);

/**
 * @brief Get the intensity of a gray-scale color object.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Color object.
 *
 * @return The intensity (0 through 255, 0 is black) for a gray-scale
 *         color object, undefined for other color types.
 *
 * @memberof SIGNDOC_Color
 */
unsigned char SDCAPI
SIGNDOC_Color_getIntensity (const struct SIGNDOC_Color *aObj);

/**
 * @brief Get the red component of an RGB color object.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Color object.
 *
 * @return The red component (0 through 255, 0 is black) of an
 *         RGB color object, undefined for other color types.
 *
 * @memberof SIGNDOC_Color
 */
unsigned char SDCAPI
SIGNDOC_Color_getRed (const struct SIGNDOC_Color *aObj);

/**
 * @brief Get the green component of an RGB color object.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Color object.
 *
 * @return The green component (0 through 255, 0 is black) of an
 *         RGB color object, undefined for other color types.
 *
 * @memberof SIGNDOC_Color
 */
unsigned char SDCAPI
SIGNDOC_Color_getGreen (const struct SIGNDOC_Color *aObj);

/**
 * @brief Get the blue component of an RGB color object.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Color object.
 *
 * @return The blue component (0 through 255, 0 is black) of an
 *         RGB color object, undefined for other color types.
 *
 * @memberof SIGNDOC_Color
 */
unsigned char SDCAPI
SIGNDOC_Color_getBlue (const struct SIGNDOC_Color *aObj);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_SignatureParameters destructor.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_SignatureParameters object.
 *
 * @memberof SIGNDOC_SignatureParameters
 */
void SDCAPI
SIGNDOC_SignatureParameters_delete (struct SIGNDOC_SignatureParameters *aObj);

/**
 * @brief Get the status of a parameter.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_SignatureParameters object.
 * @param[in] aName   The name of the parameter (case-sensitive).
 *
 * @return The parameter state:
 *         #SIGNDOC_SIGNATUREPARAMETERS_PARAMETERSTATE_SET,
 *         #SIGNDOC_SIGNATUREPARAMETERS_PARAMETERSTATE_MISSING,
 *         #SIGNDOC_SIGNATUREPARAMETERS_PARAMETERSTATE_SUPPORTED,
 *         #SIGNDOC_SIGNATUREPARAMETERS_PARAMETERSTATE_IGNORED, or
 *         #SIGNDOC_SIGNATUREPARAMETERS_PARAMETERSTATE_NOT_SUPPORTED
 *
 *
 * @memberof SIGNDOC_SignatureParameters
 */
int SDCAPI
SIGNDOC_SignatureParameters_getState (struct SIGNDOC_Exception **aEx,
                                      struct SIGNDOC_SignatureParameters *aObj,
                                      const char *aName);

/**
 * @brief Set a string parameter.
 *
 * Available string parameters are:
 * - @b Adviser          The adviser.
 *                       For DigSig signature fields, the adviser may be used
 *                       for the appearance stream of PDF documents
 *                       (see #SIGNDOC_SIGNATUREPARAMETERS_TEXTITEM_ADVISER).
 *                       The default value is empty.
 *                       Complex scripts are supported,
 *                       see @ref signdocshared_complex_scripts.
 * - @b BiometricKeyPath   The pathname of a file containing the public key
 *                       in PKCS #1 or X.509 format for encrypting the
 *                       biometric data
 *                       with integer parameter "BiometricEncryption" set to
 *                       #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_RSA.
 *                       See also blob parameter "BiometricKey"
 *                       and @ref signdocshared_biometric_encryption.
 *                       See @ref winrt_store for restrictions on pathnames
 *                       in Windows Store apps.
 * - @b BiometricPassphrase  Passphrase to be used if integer parameter
 *                       "BiometricEncryption" is
 *                       #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_PASSPHRASE.
 *                       Should contain ASCII characters only.
 * - @b Comment          The comment.
 *                       For DigSig signature fields, the comment may be used
 *                       for the appearance stream of PDF documents
 *                       (see #SIGNDOC_SIGNATUREPARAMETERS_TEXTITEM_COMMENT).
 *                       The comment can contain multiple lines which are
 *                       separated by '\n'. The default value is empty.
 *                       Complex scripts are supported,
 *                       see @ref signdocshared_complex_scripts.
 * - @b CommonName       The common name for the self-signed certificate.
 *                       When a self-signed certificate is to be generated,
 *                       the common name (CN) must be set.
 *                       See also string parameter "Signer".
 * - @b ContactInfo      The contact information provided by the signer.
 *                       For DigSig signature fields, the contact
 *                       information will be stored in the digital
 *                       signature.
 *                       For DigSig signature fields, the contact
 *                       information may be used
 *                       for the appearance stream of PDF documents
 *                       (see #SIGNDOC_SIGNATUREPARAMETERS_TEXTITEM_CONTACT_INFO).
 *                       The default value is empty.
 *                       Complex scripts are supported,
 *                       see @ref signdocshared_complex_scripts.
 * - @b Country          The country name for the self-signed certificate.
 *                       When a self-signed certificate is to be generated,
 *                       the country name (C) should be set. Use ISO 3166
 *                       country codes.
 *                       The default value is empty.
 * - @b Filter           The name of the preferred filter.
 *                       For DigSig signature fields, the filter
 *                       name will be stored in the digital
 *                       signature.  The default value is "SOFTPRO
 *                       DigSig Security".
 *                       You might want to set the filter to "Adobe.PPKLite".
 * - @b FilterCertificatesByPolicy  A required certificate policy.
 *                       Setting this parameter adds the specified OID
 *                       to a list of required policy object identifiers.
 *                       All specified policies are required for a
 *                       certificate to be accepted.
 *                       Pass an empty value to clear the list.
 *                       The value must be a valid ASN.1 object identifier.
 *                       A PDF document may contain (in its certificate seed
 *                       value dictionaries) additional restrictions
 *                       for acceptable certificates.
 *                       SIGNDOC_Document_addSignature() will fail if no
 *                       matching certificate is available for signing.
 *                       Note that #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_SOFTWARE and/or #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_HARDWARE must
 *                       be included in integer parameter "SelectCertificate"
 *                       to make certificates available at all.
 * - @b FilterCertificatesBySubjectDN  An acceptable subject Distinguished
 *                       Name (DN).
 *                       Setting this parameter adds the specified
 *                       DN to a list of acceptable DNs.
 *                       Pass an empty value to clear the list.
 *                       The DN must be formatted according to RFC 4514,
 *                       using short names for the attribute types.
 *                       Multi-valued RDNs and multiple RDNs specifying
 *                       a value for the same attribute are not allowed.
 *                       A PDF document may contain (in its certificate seed
 *                       value dictionaries) additional restrictions
 *                       for acceptable certificates.
 *                       SIGNDOC_Document_addSignature() will fail if no
 *                       matching certificate is available for signing.
 *                       Note that #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_SOFTWARE and/or #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_HARDWARE must
 *                       be included in integer parameter "SelectCertificate"
 *                       to make certificates available at all.
 * - @b FontName         The name of the font to be used for text in
 *                       the appearance of a DigSig signature field in
 *                       a PDF document. The font name can be the name of
 *                       a standard font, the name of an already
 *                       embedded font, or the name of a font defined
 *                       by a font configuration file.
 *                       If the name is empty, the font
 *                       name will be taken from the field's text field
 *                       attributes. If the field doesn't have text field
 *                       attributes, the document's text field attributes
 *                       will be used. If this also fails, standard font
 *                       Helvetica will be used (which will break PDF/A
 *                       compliance).
 *                       The default value is empty.
 *                       See also length parameter "FontSize" and
 *                       color parameter "TextColor".
 * - @b Locality         The location name for the self-signed certificate.
 *                       When a self-signed certificate is to be generated,
 *                       the location name (L) should be set.
 *                       The default value is empty.
 *                       Do not confuse "Locality" and "Location"!
 * - @b Location         The host name or physical location of signing.
 *                       For DigSig signature fields, the location
 *                       will be stored in the digital signature.
 *                       For DigSig signature fields, the location may be used
 *                       for the appearance stream of PDF documents
 *                       (see #SIGNDOC_SIGNATUREPARAMETERS_TEXTITEM_LOCATION).
 *                       The default value is empty.
 *                       Complex scripts are supported,
 *                       see @ref signdocshared_complex_scripts.
 *                       Do not confuse "Location" and "Locality"!
 * - @b Organization     The organization name for the self-signed
 *                       certificate.
 *                       When a self-signed certificate is to be generated,
 *                       the organization name (O) should be set.
 *                       The default value is empty.
 * - @b OrganizationUnit  The organization unit name for the self-signed
 *                       certificate.
 *                       When a self-signed certificate is to be generated,
 *                       the organization unit name (OU) should be set.
 *                       The default value is empty.
 * - @b OutputPath       Specify the file to which the signed document
 *                       shall be saved. If this parameter is empty
 *                       and the document is backed by a file (ie, the
 *                       last load or save operation was from or to
 *                       a file, respectively), the signed document will
 *                       be written to that file.
 *                       The special value "<memory>" causes the document
 *                       to be saved to and signed in memory (available
 *                       for PDF documents only).
 *                       See also integer parameter "Optimize".
 *                       The default value is empty.
 *                       See @ref winrt_store for restrictions on pathnames
 *                       in Windows Store apps.
 * - @b PKCS#12Password   The password for extracting the private key from
 *                       the PKCS #12 blob set as blob parameter
 *                       "Certificate". The password must contain ASCII
 *                       characters only.
 * - @b Reason           The reason for the signing.
 *                       For DigSig signature fields, the reason
 *                       will be stored in the digital signature.
 *                       For DigSig signature fields, the reason may be used
 *                       for the appearance stream of PDF documents
 *                       (see #SIGNDOC_SIGNATUREPARAMETERS_TEXTITEM_REASON).
 *                       The default value is empty.
 *                       Complex scripts are supported,
 *                       see @ref signdocshared_complex_scripts.
 * - @b Signer           The signer name.
 *                       This is the signer name that will be stored in the
 *                       digital signature. If not set, the name will be
 *                       taken from the certificate.
 *                       For DigSig signature fields, the signer name may be
 *                       used for the appearance stream of PDF documents
 *                       (see #SIGNDOC_SIGNATUREPARAMETERS_TEXTITEM_SIGNER).
 *                       The default value is empty (meaning that the name
 *                       will be taken from the certificate).
 *                       See also string parameter "CommonName".
 *                       Complex scripts are supported,
 *                       see @ref signdocshared_complex_scripts.
 * - @b SignTime         The time of signing in free format.
 *                       For DigSig signature fields, the time of
 *                       signing may be used for the appearance
 *                       stream of PDF documents (see #SIGNDOC_SIGNATUREPARAMETERS_TEXTITEM_SIGN_TIME).
 *                       The default value is empty.
 *                       See also string parameter "Timestamp".
 * - @b Timestamp        The timestamp to be used in the digital signature
 *                       (instead of the current time).
 *                       ISO 8601 format must be used: "yyyy-mm-ddThh:mm:ss"
 *                       with optional timezone.
 *                       For DigSig signature fields, the timestamp
 *                       will be stored in the signature dictionary
 *                       (transformed suitably for the M entry).
 *                       If empty, the current time will be used.
 *                       The default value is empty.
 *                       If this parameter is set to a non-empty value,
 *                       no time stamp will be retrieved from an RFC 3161
 *                       time-stamp server, even if specified by the
 *                       signature field seed value dictionary.
 *                       Do not set this parameter if a self-signed
 *                       certificate is to be created.
 *                       See also string parameters "SignTime" and
 *                       "TimeStampServerURL".
 * - @b TimeStampClientCertificatePath  The pathname of a file containing
 *                       the certificate in PEM format for
 *                       authenticating to an RFC 3161 time-stamp server
 *                       over HTTPS.  If the is non-empty,
 *                       string parameter "TimeStampClientKeyPath"
 *                       must also be set.
 *                       If the value is empty, the client won't
 *                       authenticate itself.
 *                       The default value is empty.
 *                       See also string parameters "TimeStampServerURL",
 *                       "TimeStampClientKeyPath",
 *                       and "TimeStampServerTrustedCertificatesPath".
 *                       See @ref winrt_store for restrictions on pathnames
 *                       in Windows Store apps.
 * - @b TimeStampClientKeyPath  The pathname of a file containing
 *                       the private key in PEM format for
 *                       authenticating to an RFC 3161 time-stamp server
 *                       over HTTPS.  If the is non-empty,
 *                       string parameter "TimeStampClientCertificatePath"
 *                       must also be set.
 *                       If the value is empty, the client won't
 *                       authenticate itself.
 *                       The default value is empty.
 *                       See also string parameters "TimeStampServerURL",
 *                       "TimeStampClientKeyPath",
 *                       and "TimeStampServerTrustedCertificatesPath".
 *                       See @ref winrt_store for restrictions on pathnames
 *                       in Windows Store apps.
 * - @b TimeStampServerPassword  The password for Basic/Digest HTTP
 *                       authentication to the time-stamp server.
 *                       Non-ASCII values probably don't work.
 *                       If this parameter is set, string parameter
 *                       "TimeStampServerUser" must also be set.
 * - @b TimeStampServerTrustedCertificatesPath  The pathname of a file containing
 *                       trusted root certificates in PEM format for
 *                       authenticating RFC 3161 time-stamp servers
 *                       over HTTPS.
 *                       If the value is empty, time-stamp servers
 *                       won't be authenticated.
 *                       The default value is empty.
 *                       See also string parameters "TimeStampServerURL",
 *                       "TimeStampClientCertificatePath",
 *                       and "TimeStampClientKeyPath".
 *                       See @ref winrt_store for restrictions on pathnames
 *                       in Windows Store apps.
 * - @b TimeStampServerURL  The URL of an RFC 3161 time-stamp server.
 *                       If string parameter "Timestamp" is empty
 *                       and string parameter "TimeStampServerURL" is
 *                       non-empty, a time stamp will be obtained from
 *                       a time-stamp server. The scheme of the URL must
 *                       be either "http" or "https".
 *                       The time-stamp server URL specified by the
 *                       document's signature field seed value dictionary
 *                       overrides the "TimeStampServerURL" parameter.
 *                       An error will be
 *                       returned by SIGNDOC_Document_addSignature() if
 *                       a time-stamp server is to be used and integer
 *                       parameter "Method" is not #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED
 *                       or m_digsig_pkcs7_sha1.
 *                       See also integer parameters
 *                       ""TimeStampHashAlgorithm" and
 *                       "TimeStampServerTimeout"
 *                       and string parameters
 *                       "TimeStampClientCertificatePath",
 *                       "TimeStampClientKeyPath",
 *                       "TimeStampServerPassword",
 *                       "TimeStampServerTrustedCertificatesPath", and
 *                       "TimeStampServerUser".
 * - @b TimeStampServerUser  The user name for Basic/Digest HTTP
 *                       authentication to the time-stamp server.
 *                       Non-ASCII values probably don't work.
 *                       If this parameter is set, string parameter
 *                       "TimeStampServerPassword" must also be set.
 * .
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_SignatureParameters object.
 * @param[in] aEncoding  The encoding used for @a aValue
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aName   The name of the parameter (case-sensitive).
 * @param[in] aValue  The value of the parameter. The encoding is specified
 *                    by @a aEncoding.
 *
 *
 * @return #SIGNDOC_SIGNATUREPARAMETERS_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_SignatureParameters
 */
int SDCAPI
SIGNDOC_SignatureParameters_setString (struct SIGNDOC_Exception **aEx,
                                       struct SIGNDOC_SignatureParameters *aObj,
                                       int aEncoding, const char *aName, const char *aValue);

/**
 * @brief Set a string parameter.
 *
 * See SIGNDOC_SignatureParameters_setString() for a list of available
 * string parameters.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_SignatureParameters object.
 * @param[in] aName   The name of the parameter (case-sensitive).
 * @param[in] aValue  The value of the parameter.
 *
 * @return #SIGNDOC_SIGNATUREPARAMETERS_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_SignatureParameters
 */
int SDCAPI
SIGNDOC_SignatureParameters_setStringW (struct SIGNDOC_Exception **aEx,
                                        struct SIGNDOC_SignatureParameters *aObj,
                                        const char *aName,
                                        const wchar_t *aValue);

/**
 * @brief Set an integer parameter.
 *
 * Available integer parameters are:
 * - @b %BiometricEncryption   Specifies how biometric data is to be
 *                             encrypted:
 *                             #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_RSA,
 *                             #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_FIXED,
 *                             #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_BINARY,
 *                             #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_PASSPHRASE, or
 *                             #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_DONT_STORE.
 *
 *                       If not set, biometric data will not be embedded
 *                       in the signature.
 * - @b %CertificateSigningAlgorithm  The signing algorithm for the self-signed
 *                       certificate:
 *                       #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESIGNINGALGORITHM_SHA1_RSA or
 *                       #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESIGNINGALGORITHM_MD5_RSA.
 *
 *                       When a self-signed certificate is to be generated,
 *                       the signing algorithm can be set. If not set, a
 *                       suitable default value will be used.
 * - @b %DetachedHashAlgorithm  Hash algorithm to be used for a detached signature
 *                       (ie, if integer parameter "Method" is
 *                       #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED):
 *                       #SIGNDOC_SIGNATUREPARAMETERS_DETACHEDHASHALGORITHM_DEFAULT
 *                       #SIGNDOC_SIGNATUREPARAMETERS_DETACHEDHASHALGORITHM_SHA1, or
 *                       #SIGNDOC_SIGNATUREPARAMETERS_DETACHEDHASHALGORITHM_SHA256.
 *                       The default value is
 *                       #SIGNDOC_SIGNATUREPARAMETERS_DETACHEDHASHALGORITHM_DEFAULT.
 * - @b GenerateKeyPair  Start generation of a key pair for the self-signed
 *                       certificate.  The value is the number of bits
 *                       (1024 through 4096, multiple of 8).
 *                       When a self-signed certificate is to be generated,
 *                       the private key can be either be generated by
 *                       setting this parameter or set as blob parameter
 *                       "CertificatePrivateKey".
 * - @b ImageHAlignment  The horizontal alignment of the image:
 *                       #SIGNDOC_SIGNATUREPARAMETERS_HALIGNMENT_LEFT,
 *                       #SIGNDOC_SIGNATUREPARAMETERS_HALIGNMENT_CENTER, or
 *                       #SIGNDOC_SIGNATUREPARAMETERS_HALIGNMENT_RIGHT.
 *                       For DigSig signature fields, this parameter
 *                       defines the horizontal alignment of the image
 *                       in the appearance stream of PDF documents.
 *                       The default value depends on the profile
 *                       passed to
 *                       SIGNDOC_Document_createSignatureParameters() or
 *                       SIGNDOC_Document_createSignatureParametersW().
 * - @b ImageVAlignment  The vertical alignment of the image:
 *                       #SIGNDOC_SIGNATUREPARAMETERS_VALIGNMENT_TOP,
 *                       #SIGNDOC_SIGNATUREPARAMETERS_VALIGNMENT_CENTER, or
 *                       #SIGNDOC_SIGNATUREPARAMETERS_VALIGNMENT_BOTTOM.
 *                       For DigSig signature fields, this parameter
 *                       defines the vertical alignment of the image
 *                       in the appearance stream of PDF documents.
 *                       The default value depends on the profile
 *                       passed to
 *                       SIGNDOC_Document_createSignatureParameters() or
 *                       SIGNDOC_Document_createSignatureParametersW().
 * - @b ImageTransparency  Image transparency:
 *                         #SIGNDOC_SIGNATUREPARAMETERS_IMAGETRANSPARENCY_OPAQUE or
 *                         #SIGNDOC_SIGNATUREPARAMETERS_IMAGETRANSPARENCY_BRIGHTEST.
 *                       For DigSig signature fields, this parameter
 *                       defines how to handle transparency for signature
 *                       image (either the image passed in the "Image"
 *                       blob parameter or the image computed according
 *                       to the "RenderSignature" integer parameter).
 *                       The default value is
 *                       #SIGNDOC_SIGNATUREPARAMETERS_IMAGETRANSPARENCY_BRIGHTEST
 * - @b %Method          The signing method:
 *                       #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS1,
 *                       #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED,
 *                       #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_SHA1, or
 *                       #SIGNDOC_SIGNATUREPARAMETERS_METHOD_HASH.
 *                       If no signing method is set, a suitable
 *                       default method will be used.
 * - @b %Optimize        Set whether this is the first signature of the
 *                       document and the document shall be optimized or
 *                       whether the document shall not be optimized:
 *                       #SIGNDOC_SIGNATUREPARAMETERS_OPTIMIZE_OPTIMIZE or
 *                       #SIGNDOC_SIGNATUREPARAMETERS_OPTIMIZE_DONT_OPTIMIZE.
 *                       For PDF documents,
 *                       #SIGNDOC_SIGNATUREPARAMETERS_OPTIMIZE_OPTIMIZE
 *                       requires saving to
 *                       a new file, see string parameter "OutputPath".
 *                       The default value is
 *                       #SIGNDOC_SIGNATUREPARAMETERS_OPTIMIZE_DONT_OPTIMIZE.
 *                       If the return value of SIGNDOC_Document_getRequiredSaveToFileFlags()
 *                       includes #SIGNDOC_DOCUMENT_SAVEFLAGS_INCREMENTAL,
 *                       signing with this parameter
 *                       set to #SIGNDOC_SIGNATUREPARAMETERS_OPTIMIZE_OPTIMIZE
 *                       will fail.
 * - @b %PDFAButtons     Set whether appearance streams of check boxes
 *                       and radio buttons shall be frozen (fixed) for
 *                       PDF/A compliance before signing:
 *                       #SIGNDOC_SIGNATUREPARAMETERS_PDFABUTTONS_FREEZE,
 *                       #SIGNDOC_SIGNATUREPARAMETERS_PDFABUTTONS_DONT_FREEZE, or
 *                       #SIGNDOC_SIGNATUREPARAMETERS_PDFABUTTONS_AUTO.
 *                       The default value is
 *                       #SIGNDOC_SIGNATUREPARAMETERS_PDFABUTTONS_AUTO.
 * - @b PenWidth         Pen width for rendering the signature (see blob
 *                       parameter "BiometricData") for the signature image.
 *                       Ignored unless integer parameter "RenderSignature"
 *                       is non-zero.
 *                       The pen width is specified in micrometers, the
 *                       default value is 500 (0.5mm).
 * - @b RenderSignature  Specifies whether and how the signature (see blob
 *                       parameter "BiometricData") is to be
 *                       rendered for the signature image.  This parameter
 *                       contains a set of these flags:
 *                       #SIGNDOC_SIGNATUREPARAMETERS_RENDERSIGNATUREFLAGS_BW,
 *                       #SIGNDOC_SIGNATUREPARAMETERS_RENDERSIGNATUREFLAGS_GRAY, and
 *                       #SIGNDOC_SIGNATUREPARAMETERS_RENDERSIGNATUREFLAGS_ANTIALIAS.
 *                       If this value is 0, the signature won't be rendered.
 *                       If no image is rendered (or set, see blob parameter
 *                       "Image"), the signature field may or
 *                       may not show an image computed from the
 *                       biometric data, depending on the document
 *                       type and signature field type.
 *                       This parameter is ignored if blob parameter
 *                       "Image" is set.
 *                       The default value is 0.  See also integer parameters
 *                       "ImageTransparency", "PenWidth", and "RenderWidth"
 *                       and color parameter "SignatureColor".
 * - @b RenderWidth      Specifies the width (in pixels) for the signature
 *                       image rendered from biometric data for PDF
 *                       documents. This parameter is ignored for TIFF
 *                       documents. The default value is 600.
 *                       If the signature is higher than wide, this value
 *                       specified the height of the signature image.
 * - @b SelectCertificate   Let the user and/or the application select
 *                       the certificate for the signature.
 *                       The parameter contains a set of these flags:
 *                       #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_SOFTWARE,
 *                       #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_HARDWARE,
 *                       #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_USE_CERTIFICATE_SEED_VALUES,
 *                       #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_ASK_IF_AMBIGUOUS,
 *                       #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_NEVER_ASK, and
 *                       #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_CREATE_SELF_SIGNED
 *                       If this parameter is zero (which is the default
 *                       value), the user won't be asked and the certificate
 *                       will either be generated on the fly or be supplied
 *                       by the "Certificate" blob parameter and
 *                       SIGNDOC_Document_addSignature() will fail if the
 *                       PDF document restricts acceptable certificates by
 *                       means of a certificate seed value dictionary.
 *                       This parameter is not yet implemented under Linux,
 *                       iOS, Android, and OS X.
 * - @b TextHAlignment   The horizontal alignment of text lines:
 *                       #SIGNDOC_SIGNATUREPARAMETERS_HALIGNMENT_LEFT,
 *                       #SIGNDOC_SIGNATUREPARAMETERS_HALIGNMENT_CENTER,
 *                       #SIGNDOC_SIGNATUREPARAMETERS_HALIGNMENT_RIGHT, or
 *                       #SIGNDOC_SIGNATUREPARAMETERS_HALIGNMENT_JUSTIFY.
 *                       For DigSig signature fields, this parameter
 *                       defines the horizontal alignment of text lines
 *                       in the appearance stream of PDF documents.
 *                       The default value depends on the profile
 *                       passed to
 *                       SIGNDOC_Document_createSignatureParameters() or
 *                       SIGNDOC_Document_createSignatureParametersW().
 * - @b %TextPosition    The position of the text block w.r.t. the image:
 *                       #SIGNDOC_SIGNATUREPARAMETERS_TEXTPOSITION_OVERLAY,
 *                       #SIGNDOC_SIGNATUREPARAMETERS_TEXTPOSITION_BELOW, or
 *                       #SIGNDOC_SIGNATUREPARAMETERS_TEXTPOSITION_UNDERLAY.
 *                       For DigSig signature fields, this parameter
 *                       defines the position of the text block in the
 *                       appearance stream of PDF documents.  The
 *                       default value depends on the profile passed
 *                       to SIGNDOC_Document_createSignatureParameters() or
 *                       to SIGNDOC_Document_createSignatureParametersW().
 * - @b TextVAlignment   The vertical alignment of text lines:
 *                       #SIGNDOC_SIGNATUREPARAMETERS_VALIGNMENT_TOP,
 *                       #SIGNDOC_SIGNATUREPARAMETERS_VALIGNMENT_CENTER, or
 *                       #SIGNDOC_SIGNATUREPARAMETERS_VALIGNMENT_BOTTOM.
 *                       For DigSig signature fields, this parameter
 *                       defines the vertical alignment of text lines
 *                       in the appearance stream of PDF documents.
 *                       The default value depends on the profile
 *                       passed to
 *                       SIGNDOC_Document_createSignatureParameters() or
 *                       SIGNDOC_Document_createSignatureParametersW().
 * - @b %TimeStampHashAlgorithm  Hash algorithm for RFC 3161 time stamps:
 *                               #SIGNDOC_SIGNATUREPARAMETERS_TIMESTAMPHASHALGORITHM_DEFAULT,
 *                               #SIGNDOC_SIGNATUREPARAMETERS_TIMESTAMPHASHALGORITHM_SHA1, or
 *                               #SIGNDOC_SIGNATUREPARAMETERS_TIMESTAMPHASHALGORITHM_SHA256.
 *                               The default value is
 *                               #SIGNDOC_SIGNATUREPARAMETERS_TIMESTAMPHASHALGORITHM_DEFAULT.
 *                       See also string parameter "TimeStampServerURL".
 * - @b TimeStampServerTimeout  Time out in milliseconds for retrieving
 *                       a time stamp from an RFC 3161 time-stamp server.
 *                       The value must be positive. The default value
 *                       is 10000.
 *                       See also string parameter "TimeStampServerURL".
 * .
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_SignatureParameters object.
 * @param[in] aName   The name of the parameter (case-sensitive).
 * @param[in] aValue  The value of the parameter.
 *
 * @return #SIGNDOC_SIGNATUREPARAMETERS_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_SignatureParameters
 *
 * @todo document when "SelectCertificate" presents the dialog
 * @todo implement "SelectCertificate" for Linux
 */
int SDCAPI
SIGNDOC_SignatureParameters_setInteger (struct SIGNDOC_Exception **aEx,
                                        struct SIGNDOC_SignatureParameters *aObj,
                                        const char *aName, int aValue);

/**
 * @brief Set a blob parameter.
 *
 * Available blob parameters are:
 * - @b BiometricData    The biometric data must either be in
 *                       SignWare format (created by SignWare's
 *                       SPFlatFileCreateFromSignature()).
 *                       The biometric data is stored in the document
 *                       (see integer parameter "BiometricEncryption")
 *                       and will be used for rendering the signature image
 *                       if integer parameter "RenderSignature" is non-zero
 *                       (unless a signature image is specified by blob
 *                       parameter "Image").
 * - @b BiometricKey     The public key (#SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_RSA)
 *                       or the AES key (#SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_BINARY)
 *                       for encrypting the biometric data. See also
 *                       string parameter "BiometricKeyPath" and
 *                       @ref signdocshared_biometric_encryption.
 * - @b Certificate      The certificate for the signature.
 *                       The blob must contain
 *                       a serialized X.509 certificate (DER format) and
 *                       blob parameter "CertificatePrivateKey" must contain
 *                       the private key for that certificate.
 *                       Alternatively, for PKCS #7 signatures, the blob
 *                       may contain the
 *                       certificate and its private key in PKCS #12 format;
 *                       string parameter "PKCS#12Password" contains the
 *                       password for extracting the private key.
 * - @b CertificatePrivateKey  The private key for the (self-signed) certificate
 *                       in PKCS #1 format.
 *                       If a certificate is passed
 *                       in blob parameter "Certificate", this parameter
 *                       must contain the private key for that certificate.
 *                       If a self-signed certificate is to be generated,
 *                       the private key can be either set with this parameter
 *                       or generated with integer parameter
 *                       "GenerateKeyPair".
 * - @b FilterCertificatesByIssuerCertificate   Acceptable issuer certificates.
 *                       Setting this parameter adds the specified
 *                       DER-encoded certificate to a list of acceptable
 *                       issuer certificates.
 *                       Pass 0 for @a aSize to clear the list.
 *                       A PDF document may contain (in its certificate seed
 *                       value dictionaries) additional restrictions
 *                       for acceptable issuer certificates.
 *                       A signer certificate is acceptable for the rule
 *                       defined by this parameter if it chains up to any
 *                       of the certificates in the list of acceptable
 *                       issuer certificates.
 *                       SIGNDOC_Document_addSignature() will fail if no
 *                       matching certificate is available for signing.
 *                       Note that #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_SOFTWARE and/or
 *                       #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_HARDWARE must
 *                       be included in integer parameter "SelectCertificate"
 *                       to make certificates available at all.
 * - @b FilterCertificatesBySubjectCertificate   Acceptable certificates.
 *                       Setting this parameter adds the specified
 *                       DER-encoded certificate to a list of acceptable
 *                       certificates.
 *                       Pass 0 for @a aSize to clear the list.
 *                       A PDF document may contain (in its certificate seed
 *                       value dictionaries) additional restrictions
 *                       for acceptable certificates.
 *                       SIGNDOC_Document_addSignature() will fail if no
 *                       matching certificate is available for signing.
 *                       Note that #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_SOFTWARE
 *                       and/or #SIGNDOC_SIGNATUREPARAMETERS_CERTIFICATESELECTIONFLAGS_HARDWARE must
 *                       be included in integer parameter "SelectCertificate"
 *                       to make certificates available at all.
 * - @b Image            The signature image.
 *                       The image can be in BMP, JPEG, PNG, or TIFF format.
 *                       If no image is set (or rendered, see integer
 *                       parameter "RenderSignature"), the signature field
 *                       may or may not show an image computed from the
 *                       biometric data, depending on the document
 *                       type and signature field type.
 *                       This parameter overrides integer parameter
 *                       "RenderSignature".
 *                       See also integer parameter "ImageTransparency".
 * .
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_SignatureParameters object.
 * @param[in] aName   The name of the parameter (case-sensitive).
 * @param[in] aData   A pointer to the first octet of the value.
 * @param[in] aSize   Size of the blob (number of octets).
 *
 * @return #SIGNDOC_SIGNATUREPARAMETERS_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_SignatureParameters
 *
 * @todo support PKCS #7 for "Certificate"
 */
int SDCAPI
SIGNDOC_SignatureParameters_setBlob (struct SIGNDOC_Exception **aEx,
                                     struct SIGNDOC_SignatureParameters *aObj,
                                     const char *aName,
                                     const unsigned char *aData, size_t aSize);

/**
 * @brief Set a length parameter.
 *
 * Available length parameters are:
 * - @b FontSize         The maximum font size.
 *                       For DigSig signature fields, this parameter
 *                       defines the maximum font size for the
 *                       appearance stream of PDF documents.  The
 *                       font size will be reduced to make all text
 *                       lines fit horizontally into the signature
 *                       field.  The default value depends on the
 *                       profile passed to
 *                       SIGNDOC_Document_createSignatureParameters() or
 *                       SIGNDOC_Document_createSignatureParametersW().
 *                       See also string parameter "FontName" and
 *                       color parameter "TextColor".
 * - @b ImageMargin      The margin to add around the image.
 *                       For DigSig signature fields, this parameter
 *                       defines the margin to be added around the
 *                       image in the appearance stream of PDF
 *                       documents.  This margin is added at all
 *                       four edges of the image.  The default value
 *                       depends on the profile passed to
 *                       SIGNDOC_Document_createSignatureParameters() or
 *                       SIGNDOC_Document_createSignatureParametersW().
 * - @b TextHMargin      The horizontal margin for text.
 *                       For DigSig signature fields, this parameter
 *                       defines the horizontal margin of text in the
 *                       appearance stream of PDF documents.
 *                       If the text is justified, @a aValue/2 will be used
 *                       for the two margins.
 *                       If the text is centered, this value will be ignored.
 *                       The default value depends on the profile passed to
 *                       SIGNDOC_Document_createSignatureParameters() or
 *                       SIGNDOC_Document_createSignatureParametersW().
 * .
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_SignatureParameters object.
 * @param[in] aName   The name of the parameter (case-sensitive).
 * @param[in] aType   Define how the length is specified:
 *                    #SIGNDOC_SIGNATUREPARAMETERS_VALUETYPE_ABS,
 *                    #SIGNDOC_SIGNATUREPARAMETERS_VALUETYPE_FIELD_HEIGHT, or
 *                    #SIGNDOC_SIGNATUREPARAMETERS_VALUETYPE_FIELD_WIDTH.
 * @param[in] aValue  The value of the parameter.
 *
 * @return #SIGNDOC_SIGNATUREPARAMETERS_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_SignatureParameters
 */
int SDCAPI
SIGNDOC_SignatureParameters_setLength (struct SIGNDOC_Exception **aEx,
                                       struct SIGNDOC_SignatureParameters *aObj,
                                       const char *aName, int aType,
                                       double aValue);

/**
 * @brief Set a color parameter.
 *
 * Available color parameters are:
 * - @b SignatureColor   The foreground color for the rendered signature
 *                       (see integer parameter "RenderSignature").
 *                       The default color is black.
 * - @b TextColor        The color to be used for text in
 *                       the appearance of a DigSig signature field in
 *                       a PDF document. If this parameter is not set,
 *                       the color will be taken from the field's text field
 *                       attributes. If the field doesn't have text field
 *                       attributes, the document's text field attributes
 *                       will be used. If this also fails, the text will
 *                       be black.
 *                       See also string parameter "FontName" and
 *                       length parameter "FontSize".
 * .
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_SignatureParameters object.
 * @param[in] aName   The name of the parameter (case-sensitive).
 * @param[in] aValue  The value of the parameter (will be copied).
 *
 * @return #SIGNDOC_SIGNATUREPARAMETERS_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_SignatureParameters
 */
int SDCAPI
SIGNDOC_SignatureParameters_setColor (struct SIGNDOC_Exception **aEx,
                                      struct SIGNDOC_SignatureParameters *aObj,
                                      const char *aName, const struct SIGNDOC_Color *aValue);

/**
 * @brief Add another string to be displayed, top down.
 *
 * For DigSig signature fields, this function adds another string to
 * the appearance stream of PDF documents.
 * The first call clears any default strings.
 * The default values depend on the profile passed to
 * SIGNDOC_Document_createSignatureParameters() or
 * SIGNDOC_Document_createSignatureParametersW().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_SignatureParameters object.
 * @param[in] aItem   Select the string to be added:
 *                    #SIGNDOC_SIGNATUREPARAMETERS_TEXTITEM_SIGNER,
 *                    #SIGNDOC_SIGNATUREPARAMETERS_TEXTITEM_SIGN_TIME,
 *                    #SIGNDOC_SIGNATUREPARAMETERS_TEXTITEM_COMMENT,
 *                    #SIGNDOC_SIGNATUREPARAMETERS_TEXTITEM_ADVISER,
 *                    #SIGNDOC_SIGNATUREPARAMETERS_TEXTITEM_CONTACT_INFO,
 *                    #SIGNDOC_SIGNATUREPARAMETERS_TEXTITEM_LOCATION, or
 *                    #SIGNDOC_SIGNATUREPARAMETERS_TEXTITEM_REASON.
 * @param[in] aGroup  The string's group for font size computation:
 *                    #SIGNDOC_SIGNATUREPARAMETERS_TEXTGROUP_MASTER or
 *                    #SIGNDOC_SIGNATUREPARAMETERS_TEXTGROUP_SLAVE.
 *
 * @return #SIGNDOC_SIGNATUREPARAMETERS_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_SignatureParameters_clearTextItems()
 *
 * @memberof SIGNDOC_SignatureParameters
 */
int SDCAPI
SIGNDOC_SignatureParameters_addTextItem (struct SIGNDOC_Exception **aEx,
                                         struct SIGNDOC_SignatureParameters *aObj,
                                         int aItem, int aGroup);

/**
 * @brief Remove all strings that were to be displayed.
 *
 * SIGNDOC_SignatureParameters_addTextItem() cannot remove the default
 * strings without adding a new string. This function does.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_SignatureParameters object.
 *
 * @return #SIGNDOC_SIGNATUREPARAMETERS_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_SignatureParameters_addTextItem()
 *
 * @memberof SIGNDOC_SignatureParameters
 */
int SDCAPI
SIGNDOC_SignatureParameters_clearTextItems (struct SIGNDOC_Exception **aEx,
                                            struct SIGNDOC_SignatureParameters *aObj);

/**
 * @brief Set an object which will create a PKCS #7 signature.
 *
 * By default, PKCS #7 signatures are handled internally which means
 * that the private key must be available on this machine.
 *
 * Requirements for string parameters:
 * - CommonName         must not be set
 * - Country            must not be set
 * - Locality           must not be set
 * - Organization       must not be set
 * - OrganizationUnit   must not be set
 * .
 *
 * Requirements for integer parameters:
 * - GenerateKeyPair    must not be set
 * - Method             must be #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED
 *                      or #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_SHA1
 * - SelectCertificate  must be zero (which is the default value)
 * .
 *
 * Requirements for blob parameters:
 * - Certificate        must not be set
 * - CertificatePrivateKey   must not be set
 * .
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_SignatureParameters object.
 * @param[in] aPKCS7   The object that will create the PKCS #7 signature.
 *                     This function does not take ownership of that object.
 *
 * @return #SIGNDOC_SIGNATUREPARAMETERS_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_SignatureParameters
 *
 * @todo implement, document
 */
int SDCAPI
SIGNDOC_SignatureParameters_setPKCS7 (struct SIGNDOC_Exception **aEx,
                                      struct SIGNDOC_SignatureParameters *aObj,
                                      struct SIGNDOC_SignPKCS7 *aPKCS7);

/**
 * @brief Get a bitset indicating which signing methods are available
 *        for this signature field.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_SignatureParameters object.
 *
 * @return 1&lt;&lt;#SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS1 etc.
 *
 * @see SIGNDOC_Document_getAvailableMethods()
 *
 * @memberof SIGNDOC_SignatureParameters
 */
int SDCAPI
SIGNDOC_SignatureParameters_getAvailableMethods (struct SIGNDOC_Exception **aEx,
                                                 struct SIGNDOC_SignatureParameters *aObj);

/**
 * @brief Get an error message for the last function call.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_SignatureParameters object.
 * @param[in] aEncoding  The encoding to be used for the error message
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 *
 * @return A pointer to a string describing the reason for the
 *         failure of the last function call. The string is empty
 *         if the last call succeeded. The pointer is valid until
 *         this object is destroyed or a member function of @a aObj
 *         is called.
 *
 * @see SIGNDOC_SignatureParameters_getErrorMessageW()
 *
 * @memberof SIGNDOC_SignatureParameters
 */
const char * SDCAPI
SIGNDOC_SignatureParameters_getErrorMessage (struct SIGNDOC_Exception **aEx,
                                             struct SIGNDOC_SignatureParameters *aObj,
                                             int aEncoding);

/**
 * @brief Get an error message for the last function call.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_SignatureParameters object.
 *
 * @return A pointer to a string describing the reason for the
 *         failure of the last function call. The string is empty
 *         if the last call succeeded. The pointer is valid until
 *         this object is destroyed or a member function of @a aObj
 *         is called.
 *
 * @see SIGNDOC_SignatureParameters_getErrorMessage()
 *
 * @memberof SIGNDOC_SignatureParameters
 */
const wchar_t * SDCAPI
SIGNDOC_SignatureParameters_getErrorMessageW (struct SIGNDOC_Exception **aEx,
                                              struct SIGNDOC_SignatureParameters *aObj);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_TextFieldAttributes constructor.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 *
 * @memberof SIGNDOC_TextFieldAttributes
 */
struct SIGNDOC_TextFieldAttributes * SDCAPI
SIGNDOC_TextFieldAttributes_new (struct SIGNDOC_Exception **aEx);

/**
 * @brief Clone a SIGNDOC_TextFieldAttributes object.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aSource  The object to be copied.
 *
 * @memberof SIGNDOC_TextFieldAttributes
 */
struct SIGNDOC_TextFieldAttributes * SDCAPI
SIGNDOC_TextFieldAttributes_clone (struct SIGNDOC_Exception **aEx,
                                   const struct SIGNDOC_TextFieldAttributes *aSource);

/**
 * @brief SIGNDOC_TextFieldAttributes destructor.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_TextFieldAttributes object.
 *
 * @memberof SIGNDOC_TextFieldAttributes
 */
void SDCAPI
SIGNDOC_TextFieldAttributes_delete (struct SIGNDOC_TextFieldAttributes *aObj);

/**
 * @brief SIGNDOC_TextFieldAttributes assignment operator.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_TextFieldAttributes object.
 * @param[in] aSource  The source object.
 *
 * @memberof SIGNDOC_TextFieldAttributes
 */
void SDCAPI
SIGNDOC_TextFieldAttributes_assign (struct SIGNDOC_Exception **aEx,
                                    struct SIGNDOC_TextFieldAttributes *aObj,
                                 const struct SIGNDOC_TextFieldAttributes *aSource);

/**
 * @brief Check if text field attributes are set or not.
 *
 * If this function returns #SIGNDOC_FALSE for a SignDocTextFieldAttributes
 * object retrieved from a text field, the document's default
 * text field attributes will be used (if present).
 *
 * This function returns #SIGNDOC_FALSE for all SignDocTextFieldAttributes
 * objects retrieved from TIFF documents (but you can set the
 * attributes anyway, making SIGNDOC_TextFieldAttributes_isSet()
 * return #SIGNDOC_TRUE).
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_TextFieldAttributes object.
 *
 * @return #SIGNDOC_TRUE if any attribute is set,
 *         #SIGNDOC_FALSE if no attributes are set.
 *
 * @see SIGNDOC_TextFieldAttributes_isValid()
 *
 * @memberof SIGNDOC_TextFieldAttributes
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_TextFieldAttributes_isSet (struct SIGNDOC_Exception **aEx,
                                   const struct SIGNDOC_TextFieldAttributes *aObj);

/**
 * @brief Check if the text field attributes are valid.
 *
 * This function does not check if the font name refers to a valid font.
 * This function does not check the string set by
 * SIGNDOC_TextFieldAttributes_setRest().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_TextFieldAttributes object.
 *
 * @return #SIGNDOC_TRUE if SIGNDOC_TextFieldAttributes_isSet()
 *         would return #SIGNDOC_FALSE or
 *         if all attributes are set and are valid, #SIGNDOC_FALSE otherwise.
 *
 * @see SIGNDOC_TextFieldAttributes_isSet(), SIGNDOC_TextFieldAttributes_setRest()
 *
 * @memberof SIGNDOC_TextFieldAttributes
 */
SIGNDOC_Boolean SDCAPI
SIGNDOC_TextFieldAttributes_isValid (struct SIGNDOC_Exception **aEx,
                                     const struct SIGNDOC_TextFieldAttributes *aObj);

/**
 * @brief Unset all attributes.
 *
 * SIGNDOC_TextFieldAttributes_isSet() will return #SIGNDOC_FALSE.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_TextFieldAttributes object.
 *
 * @memberof SIGNDOC_TextFieldAttributes
 */
void SDCAPI
SIGNDOC_TextFieldAttributes_clear (struct SIGNDOC_Exception **aEx,
                                   struct SIGNDOC_TextFieldAttributes *aObj);

/**
 * @brief Get the name of the font.
 *
 * This function returns an empty string if
 * SIGNDOC_TextFieldAttributes_isSet() would return #SIGNDOC_FALSE.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_TextFieldAttributes object.
 * @param[in] aEncoding  The encoding to be used for the return value
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 *
 * @return The name of the font.
 *         The string must be freed with SIGNDOC_free().
 *
 * @see SIGNDOC_TextFieldAttributes_getFontResourceName(), SIGNDOC_TextFieldAttributes_getFontSize(), SIGNDOC_TextFieldAttributes_setFontName()
 *
 * @memberof SIGNDOC_TextFieldAttributes
 */
char * SDCAPI
SIGNDOC_TextFieldAttributes_getFontName (struct SIGNDOC_Exception **aEx,
                                         const struct SIGNDOC_TextFieldAttributes *aObj,
                                         int aEncoding);

/**
 * @brief Set the name of the font.
 *
 * The font name can be the name of a standard font, the name of an
 * already embedded font, or the name of a font defined by a font
 * configuration file.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_TextFieldAttributes object.
 * @param[in] aEncoding  The encoding of @a aFontName
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aFontName  The new font name.
 *
 * @see SIGNDOC_TextFieldAttributes_getFontName(), SIGNDOC_TextFieldAttributes_setFontSize(), SIGNDOC_TextFieldAttributes_setTextColor(), SIGNDOC_DocumentLoader_loadFontConfigFile(), SIGNDOC_DocumentLoader_loadFontConfigEnvironment(), SIGNDOC_DocumentLoader_loadFontConfigStream()
 *
 * @memberof SIGNDOC_TextFieldAttributes
 */
void SDCAPI
SIGNDOC_TextFieldAttributes_setFontName (struct SIGNDOC_Exception **aEx,
                                         struct SIGNDOC_TextFieldAttributes *aObj,
                                         int aEncoding, const char *aFontName);

/**
 * @brief Get the resource name of the font.
 *
 * This function returns an empty string if
 * SIGNDOC_TextFieldAttributes_isSet() would return #SIGNDOC_FALSE.
 *
 * Note that setting the resource name is not possible.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_TextFieldAttributes object.
 * @param[in] aEncoding  The encoding to be used for the return value
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 *
 * @return The resource name of the font.
 *         The string must be freed with SIGNDOC_free().
 *
 * @see SIGNDOC_TextFieldAttributes_getFontName()
 *
 * @memberof SIGNDOC_TextFieldAttributes
 */
char * SDCAPI
SIGNDOC_TextFieldAttributes_getFontResourceName (struct SIGNDOC_Exception **aEx,
                                                 const struct SIGNDOC_TextFieldAttributes *aObj,
                                                 int aEncoding);

/**
 * @brief Get the font size.
 *
 * This function returns 0 if SIGNDOC_TextFieldAttributes_isSet()
 * would return #SIGNDOC_FALSE.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_TextFieldAttributes object.
 *
 * @return The font size (in user space units).  If the font size is 0,
 *         the default font size (which depends on the field size)
 *         will be used.
 *
 * @see SIGNDOC_TextFieldAttributes_getFontName(), SIGNDOC_TextFieldAttributes_setFontSize()
 *
 * @memberof SIGNDOC_TextFieldAttributes
 */
double SDCAPI
SIGNDOC_TextFieldAttributes_getFontSize (struct SIGNDOC_Exception **aEx,
                                         const struct SIGNDOC_TextFieldAttributes *aObj);

/**
 * @brief Set the font size.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_TextFieldAttributes object.
 * @param[in] aFontSize  The font size (in user space units).
 *                       If the font size is 0, the default font size
 *                       (which depends on the field size) will be used.
 *
 * @see SIGNDOC_TextFieldAttributes_getFontSize(), SIGNDOC_TextFieldAttributes_setFontName(), #SIGNDOC_DOCUMENT_SETFIELDFLAGS_FIT_HEIGHT_ONLY
 *
 * @memberof SIGNDOC_TextFieldAttributes
 */
void SDCAPI
SIGNDOC_TextFieldAttributes_setFontSize (struct SIGNDOC_Exception **aEx,
                                         struct SIGNDOC_TextFieldAttributes *aObj,
                                         double aFontSize);

/**
 * @brief Get the text color.
 *
 * This function returns NULL if SIGNDOC_TextFieldAttributes_isSet()
 * would return #SIGNDOC_FALSE.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_TextFieldAttributes object.
 *
 * @return A pointer to an object describing the text color or NULL if
 *         the text color is not available. The caller is
 *         responsible for destroying the object.
 *
 * @see SIGNDOC_TextFieldAttributes_setTextColor()
 *
 * @memberof SIGNDOC_TextFieldAttributes
 */
struct SIGNDOC_Color * SDCAPI
SIGNDOC_TextFieldAttributes_getTextColor (struct SIGNDOC_Exception **aEx,
                                          const struct SIGNDOC_TextFieldAttributes *aObj);

/**
 * @brief Set the text color.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_TextFieldAttributes object.
 * @param[in] aTextColor  The text color.
 *
 * @memberof SIGNDOC_TextFieldAttributes
 */
void SDCAPI
SIGNDOC_TextFieldAttributes_setTextColor (struct SIGNDOC_Exception **aEx,
                                          struct SIGNDOC_TextFieldAttributes *aObj,
                                          const struct SIGNDOC_Color *aTextColor);

/**
 * @brief Get unparsed parts of default appearance string.
 *
 * If this function returns a non-empty string, there are unsupported
 * operators in the default appearance string.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_TextFieldAttributes object.
 * @param[in] aEncoding  The encoding to be used for the return value
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 *
 * @return Concatenated unparsed parts of the default appearance string, ie,
 *         the default appearance string sans font name, font size, and
 *         text color.  If this function returns a non-empty string, it
 *         will start with a space character.
 *         The string must be freed with SIGNDOC_free().
 *
 * @see SIGNDOC_TextFieldAttributes_setRest()
 *
 * @memberof SIGNDOC_TextFieldAttributes
 */
char * SDCAPI
SIGNDOC_TextFieldAttributes_getRest (struct SIGNDOC_Exception **aEx,
                                     const struct SIGNDOC_TextFieldAttributes *aObj,
                                     int aEncoding);

/**
 * @brief Set unparsed parts of default appearance string.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_TextFieldAttributes object.
 * @param[in] aEncoding  The encoding of @a aInput
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aInput     The new string of unparsed operators.
 *                       If this string is non-empty and does not start
 *                       with a space character, a space character will
 *                       be prepended automatically.
 *
 * @memberof SIGNDOC_TextFieldAttributes
 */
void SDCAPI
SIGNDOC_TextFieldAttributes_setRest (struct SIGNDOC_Exception **aEx,
                                     struct SIGNDOC_TextFieldAttributes *aObj,
                                     int aEncoding, const char *aInput);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_VerificationResult destructor.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_VerificationResult object.
 *
 * @memberof SIGNDOC_VerificationResult
 */
void SDCAPI
SIGNDOC_VerificationResult_delete (struct SIGNDOC_VerificationResult *aObj);

/**
 * @brief Get the signature state.
 *
 * If the state #SIGNDOC_VERIFICATIONRESULT_SIGNATURESTATE_UNSUPPORTED_SIGNATURE
 * or #SIGNDOC_VERIFICATIONRESULT_SIGNATURESTATE_INVALID_CERTIFICATE,
 * SIGNDOC_VerificationResult_getErrorMessage() will provide additional
 * information.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_VerificationResult object.
 * @param[out]  aOutput  The signature state:
 *                       #SIGNDOC_VERIFICATIONRESULT_SIGNATURESTATE_UNMODIFIED,
 *                       #SIGNDOC_VERIFICATIONRESULT_SIGNATURESTATE_DOCUMENT_EXTENDED,
 *                       #SIGNDOC_VERIFICATIONRESULT_SIGNATURESTATE_DOCUMENT_MODIFIED,
 *                       #SIGNDOC_VERIFICATIONRESULT_SIGNATURESTATE_UNSUPPORTED_SIGNATURE,
 *                       #SIGNDOC_VERIFICATIONRESULT_SIGNATURESTATE_INVALID_CERTIFICATE, o
 *                       #SIGNDOC_VERIFICATIONRESULT_SIGNATURESTATE_EMPTY.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_VerificationResult_getErrorMessage(), SIGNDOC_Document_verifySignature()
 *
 * @memberof SIGNDOC_VerificationResult
 */
int SDCAPI
SIGNDOC_VerificationResult_getState (struct SIGNDOC_Exception **aEx,
                                     struct SIGNDOC_VerificationResult *aObj,
                                     int *aOutput);

/**
 * @brief Get the signing method.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_VerificationResult object.
 * @param[out]  aOutput  The signing method:
 *                       #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS1,
 *                       #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_DETACHED,
 *                       #SIGNDOC_SIGNATUREPARAMETERS_METHOD_DIGSIG_PKCS7_SHA1, or
 *                       #SIGNDOC_SIGNATUREPARAMETERS_METHOD_HASH.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful,
 * #SIGNDOC_DOCUMENT_RETURNCODE_NOT_VERIFIED if verification has failed.
 *
 * @memberof SIGNDOC_VerificationResult
 */
int SDCAPI
SIGNDOC_VerificationResult_getMethod (struct SIGNDOC_Exception **aEx,
                                      struct SIGNDOC_VerificationResult *aObj,
                                      int *aOutput);

/**
 * @brief Get the message digest algorithm of the signature.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_VerificationResult object.
 * @param[out]  aOutput  The message digest algorithm (such as "SHA-1")
 *                       will be stored here.  If the message digest
 *                       algorithm is unsupported, an empty string will
 *                       be stored.
 *                       The string must be freed with SIGNDOC_free().
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful,
 *         #SIGNDOC_DOCUMENT_RETURNCODE_NOT_VERIFIED if verification has failed.
 *
 * @memberof SIGNDOC_VerificationResult
 */
int SDCAPI
SIGNDOC_VerificationResult_getDigestAlgorithm (struct SIGNDOC_Exception **aEx,
                                               struct SIGNDOC_VerificationResult *aObj,
                                               char **aOutput);

/**
 * @brief Get the certificates of the signature.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_VerificationResult object.
 * @param[out]  aOutput  The ASN.1-encoded X.509 certificates will be
 *                       stored here.  If there are multiple certificates,
 *                       the first one (at index 0) is the signing
 *                       certificate.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful, #SIGNDOC_DOCUMENT_RETURNCODE_NOT_VERIFIED if verification has failed.
 *
 * @memberof SIGNDOC_VerificationResult
 */
int SDCAPI
SIGNDOC_VerificationResult_getCertificates (struct SIGNDOC_Exception **aEx,
                                            struct SIGNDOC_VerificationResult *aObj,
                                            struct SIGNDOC_ByteArrayArray *aOutput);

/**
 * @brief Verify the certificate chain of the signature's certificate.
 *
 * Currently, this function supports PKCS #7 signatures only.
 * SIGNDOC_VerificationResult_getErrorMessage() will return an error message
 * if this function fails (return value not #SIGNDOC_DOCUMENT_RETURNCODE_OK)
 * or the verification result returned
 * in @a aOutput is not #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_OK.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_VerificationResult object.
 * @param[in]   aModel   Model to be used for verification:
 *                       #SIGNDOC_VERIFICATIONRESULT_VERIFICATIONMODEL_DEFAULT or
 *                       #SIGNDOC_VERIFICATIONRESULT_VERIFICATIONMODEL_GERMAN_SIG_LAW.
 * @param[out]  aOutput  The result of the certificate chain verification:
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_OK,
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_BROKEN_CHAIN,
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_UNTRUSTED_ROOT,
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_CRITICAL_EXTENSION,
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_NOT_TIME_VALID,
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_PATH_LENGTH,
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_INVALID, or
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_ERROR.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful, #SIGNDOC_DOCUMENT_RETURNCODE_NOT_VERIFIED if verification has failed.
 *
 * @see SIGNDOC_VerificationResult_getCertificateChainLength(), SIGNDOC_VerificationResult_verifyCertificateRevocation(), SIGNDOC_VerificationResult_verifyCertificateSimplified()
 *
 * @memberof SIGNDOC_VerificationResult
 *
 * @todo support #SIGNDOC_VERIFICATIONRESULT_VERIFICATIONMODEL_GERMAN_SIG_LAW for @a aModel
 */
int SDCAPI
SIGNDOC_VerificationResult_verifyCertificateChain (struct SIGNDOC_Exception **aEx,
                                                   struct SIGNDOC_VerificationResult *aObj,
                                                   int aModel, int *aOutput);

/**
 * @brief Check the revocation status of the certificate chain of the
 *        signature's certificate.
 *
 * SIGNDOC_VerificationResult_verifyCertificateChain() or
 * SIGNDOC_VerificationResult_verifyCertificateSimplified() must
 * have been called successfully.
 *
 * Currently, this function supports PKCS #7 signatures only.
 * SIGNDOC_VerificationResult_getErrorMessage() will return an
 * error message if this function
 * fails (return value not #SIGNDOC_DOCUMENT_RETURNCODE_OK) or
 * the verification result returned
 * in @a aOutput is not #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONSTATE_OK.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_VerificationResult object.
 * @param[in]   aModel   Model to be used for verification:
 *                       #SIGNDOC_VERIFICATIONRESULT_VERIFICATIONMODEL_DEFAULT or
 *                       #SIGNDOC_VERIFICATIONRESULT_VERIFICATIONMODEL_GERMAN_SIG_LAW.
 * @param[out]  aOutput  The result of the certificate revocation check:
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONSTATE_OK,
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONSTATE_NOT_CHECKED,
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONSTATE_OFFLINE,
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONSTATE_REVOKED, or
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONSTATE_ERROR.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful,
 *         #SIGNDOC_DOCUMENT_RETURNCODE_NOT_VERIFIED if verification has failed.
 *
 * @see SIGNDOC_VerificationResult_getCertificateChainLength(), SIGNDOC_VerificationResult_verifyCertificateChain(), SIGNDOC_VerificationResult_verifyCertificateSimplified()
 *
 * @memberof SIGNDOC_VerificationResult
 *
 * @todo support #SIGNDOC_VERIFICATIONRESULT_VERIFICATIONMODEL_GERMAN_SIG_LAW for @a aModel
 */
int SDCAPI
SIGNDOC_VerificationResult_verifyCertificateRevocation (struct SIGNDOC_Exception **aEx,
                                                        struct SIGNDOC_VerificationResult *aObj,
                                                        int aModel,
                                                        int *aOutput);

/**
 * @brief Simplified verification of the certificate chain and revocation
 *        status of the signature's certificate.
 *
 * This function just returns a good / not good value according to
 * policies defined by the arguments. It does not tell the caller
 * what exactly is wrong. However,
 * SIGNDOC_VerificationResult_getErrorMessage() will return an
 * error message if this function fails. Do not attempt to base
 * decisions on that error message, please use
 * SIGNDOC_VerificationResult_verifyCertificateChain()
 * and SIGNDOC_VerificationResult_verifyCertificateRevocation()
 * instead of this function if
 * you need details about the failure.
 *
 * If @a aChainPolicy is
 * #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINVERIFICATIONPOLICY_DONT_VERIFY,
 * @a aRevocationPolicy must be
 * #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_DONT_CHECK,
 * otherwise this function will return #SIGNDOC_VERIFICATIONRESULT_RETURNCODE_INVALID_ARGUMENT.
 *
 * Currently, only self-signed certificates are supported for PKCS #1,
 * therefore
 * #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINVERIFICATIONPOLICY_REQUIRE_TRUSTED_ROOT
 * always makes this
 * function fail for PKCS #1 signatures.
 * #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_ONLINE
 * and #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_OFFLINE
 * also make this function fail for PKCS #1 signatures.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_VerificationResult object.
 * @param[in] aChainPolicy       Policy for verification of the certificate
 *                               chain:
 *                               #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_DONT_CHECK,
 *                               #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_OFFLINE, or
 *                               #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_ONLINE.
 * @param[in] aRevocationPolicy  Policy for verification of the revocation
 *                               status of the certificates:
 *                               #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_DONT_CHECK,
 *                               #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_OFFLINE, or
 *                               #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_ONLINE.
 * @param[in] aModel             Model to be used for verification:
 *                       #SIGNDOC_VERIFICATIONRESULT_VERIFICATIONMODEL_DEFAULT or
 *                       #SIGNDOC_VERIFICATIONRESULT_VERIFICATIONMODEL_GERMAN_SIG_LAW.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful,
 *         #SIGNDOC_DOCUMENT_RETURNCODE_NOT_VERIFIED if verification has failed,
 *         #SIGNDOC_VERIFICATIONRESULT_RETURNCODE_INVALID_ARGUMENT if the
 *         arguments are invalid.
 *
 * @see SIGNDOC_VerificationResult_getCertificateChainLength(), SIGNDOC_VerificationResult_verifyCertificateChain(), SIGNDOC_VerificationResult_verifyCertificateRevocation()
 *
 * @memberof SIGNDOC_VerificationResult
 *
 * @todo support #SIGNDOC_VERIFICATIONRESULT_VERIFICATIONMODEL_GERMAN_SIG_LAW for @a aModel
 */
int SDCAPI
SIGNDOC_VerificationResult_verifyCertificateSimplified (struct SIGNDOC_Exception **aEx,
                                                        struct SIGNDOC_VerificationResult *aObj,
                                                        int aChainPolicy,
                                                        int aRevocationPolicy,
                                                        int aModel);

/**
 * @brief Get the certificate chain length.
 *
 * SIGNDOC_VerificationResult_verifyCertificateChain() or
 * SIGNDOC_VerificationResult_verifyCertificateSimplified() must have
 * been called successfully.
 *
 * Currently, this function supports PKCS #7 signatures only.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_VerificationResult object.
 * @param[out]  aOutput  The chain length will be stored here if this
 *                       function is is successful.  If the signature was
 *                       performed with a self-signed certificate, the
 *                       chain length will be 1.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful,
 *          #SIGNDOC_DOCUMENT_RETURNCODE_NOT_VERIFIED if verification has failed.
 *
 * @see SIGNDOC_VerificationResult_verifyCertificateChain(), SIGNDOC_VerificationResult_verifyCertificateSimplified()
 *
 * @memberof SIGNDOC_VerificationResult
 */
int SDCAPI
SIGNDOC_VerificationResult_getCertificateChainLength (struct SIGNDOC_Exception **aEx,
                                                      struct SIGNDOC_VerificationResult *aObj,
                                                      int *aOutput);

/**
 * @brief Get a string parameter from the signature field.
 *
 * Available string parameters are:
 * - ContactInfo         The contact information provided by the signer.
 * - Filter              The name of the preferred filter.
 * - Location            The host name or physical location of signing.
 * - Reason              The reason for the signing.
 * - Signer              The signer.
 * - Timestamp           The timestamp of the signature in ISO 8601 format:
 *                       "yyyy-mm-ddThh:mm:ss" with optional timezone.
 *                       Note that the timestamp can alternatively
 *                       be stored in the PKCS #7 message, see
 *                       SIGNDOC_VerificationResult_getTimeStamp().
 * .
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_VerificationResult object.
 * @param[in]   aEncoding   The encoding to be used for @a aOutput
 *                          (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                          or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]   aName    The name of the parameter.
 * @param[out]  aOutput  The string retrieved from the signature field.
 *                       The string must be freed with SIGNDOC_free().
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful,
 *         #SIGNDOC_DOCUMENT_RETURNCODE_NOT_VERIFIED if verification has failed.
 *
 * @see SIGNDOC_VerificationResult_getTimeStamp(), SIGNDOC_VerificationResult_SIGNDOC_Document_getLastTimestamp(), SIGNDOC_SignatureParameters_setString()
 *
 * @memberof SIGNDOC_VerificationResult
 *
 * @todo document which parameters are available for which methods
 */
int SDCAPI
SIGNDOC_VerificationResult_getSignatureString (struct SIGNDOC_Exception **aEx,
                                               struct SIGNDOC_VerificationResult *aObj,
                                               int aEncoding, const char *aName,
                                               char **aOutput);

/**
 * @brief Get the biometric data of the field.
 *
 * Use SIGNDOC_VerificationResult_getBiometricEncryption()
 * to find out what parameters need to be passed:
 * - #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_RSA
 *                 Either @a aKeyPtr or @a aKeyPath must be non-NULL,
 *                 @a aPassphrase is required if the key file is encrypted
 * - #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_FIXED
 *                 @a aKeyPtr, @a aKeyPath, and @a aPassphrase must be NULL
 * - #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_BINARY
 *                 @a aKeyPtr must be non-NULL, @a aKeySize must be 32,
 *                 @a aPassphrase must be NULL
 * - #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_PASSPHRASE
 *                 @a aKeyPtr must point to the passphrase (which should
 *                 contain ASCII characters only), @a aPassphrase
 *                 must be NULL
 * .
 * @note Don't forget to overwrite the biometric data in memory after use!
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_VerificationResult object.
 * @param[in]  aEncoding    The encoding of the string pointed to
 *                          by @a aKeyPath
 *                          (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                          or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in]  aKeyPtr      Pointer to the first octet of the key (must
 *                          be NULL if @a aKeyPath is not NULL).
 * @param[in]  aKeySize     Size of the key pointed to by @a aKeyPtr (must
 *                          be 0 if @a aKeyPath is not NULL).
 * @param[in]  aKeyPath     Pathname of the file containing the key (must
 *                          be NULL if @a aKeyPtr is not NULL).
 *                          See @ref winrt_store for restrictions on pathnames
 *                          in Windows Store apps.
 * @param[in]  aPassphrase  Passphrase for decrypting the key contained in
 *                          the file named by @a aKeyPath.  If this argument
 *                          is NULL or points to the empty string, it will
 *                          be assumed that the key file is not protected
 *                          by a passphrase.  @a aPassphrase is used only
 *                          when reading the key from a file for
 *                          #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_RSA.
 *                          The passphrase must contain ASCII characters
 *                          only.
 * @param[out] aOutput      The decrypted biometric data will be stored here.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful,
 *         #SIGNDOC_VERIFICATIONRESULT_RETURNCODE_NO_BIOMETRIC_DATA
 *         if no biometric data is availabable.
 *
 * @see SIGNDOC_VerificationResult_checkBiometricHash(), SIGNDOC_VerificationResult_getBiometricEncryption(), SIGNDOC_VerificationResult_getEncryptedBiometricData()
 *
 * @memberof SIGNDOC_VerificationResult
 */
int SDCAPI
SIGNDOC_VerificationResult_getBiometricData (struct SIGNDOC_Exception **aEx,
                                             struct SIGNDOC_VerificationResult *aObj,
                                             int aEncoding,
                                             const unsigned char *aKeyPtr,
                                             size_t aKeySize,
                                             const char *aKeyPath,
                                             const char *aPassphrase,
                                             struct SIGNDOC_ByteArray *aOutput);

/**
 * @brief Get the biometric data of the field.
 *
 * Use SIGNDOC_VerificationResult_getBiometricEncryption()
 * to find out what parameters need to be passed:
 * - #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_RSA
 *                 Either @a aKeyPtr or @a aKeyPath must be non-NULL,
 *                 @a aPassphrase is required if the key file is encrypted
 * - #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_FIXED
 *                 @a aKeyPtr, @a aKeyPath, and @a aPassphrase must be NULL
 * - #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_BINARY
 *                 @a aKeyPtr must be non-NULL, @a aKeySize must be 32,
 *                 @a aPassphrase must be NULL
 * - #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_PASSPHRASE
 *                 @a aKeyPtr must point to the passphrase (which should
 *                 contain ASCII characters only), @a aPassphrase
 *                 must be NULL
 * .
 * @note Don't forget to overwrite the biometric data in memory after use!
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_VerificationResult object.
 * @param[in]  aKeyPtr      Pointer to the first octet of the key (must
 *                          be NULL if @a aKeyPath is not NULL).
 * @param[in]  aKeySize     Size of the key pointed to by @a aKeyPtr (must
 *                          be 0 if @a aKeyPath is not NULL).
 * @param[in]  aKeyPath     Pathname of the file containing the key (must
 *                          be NULL if @a aKeyPtr is not NULL).
 *                          See @ref winrt_store for restrictions on pathnames
 *                          in Windows Store apps.
 * @param[in]  aPassphrase  Passphrase for decrypting the key contained in
 *                          the file named by @a aKeyPath.  If this argument
 *                          is NULL or points to the empty string, it will
 *                          be assumed that the key file is not protected
 *                          by a passphrase.  @a aPassphrase is used only
 *                          when reading the key from a file for
 *                          #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_RSA.
 *                          The passphrase must contain ASCII characters
 *                          only.
 * @param[out] aOutput      The decrypted biometric data will be stored here.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful,
 *          #SIGNDOC_VERIFICATIONRESULT_RETURNCODE_NO_BIOMETRIC_DATA
 *          if no biometric data is availabable.
 *
 * @see SIGNDOC_VerificationResult_checkBiometricHash(), SIGNDOC_VerificationResult_getBiometricEncryption(), SIGNDOC_VerificationResult_getEncryptedBiometricData()
 *
 * @memberof SIGNDOC_VerificationResult
 */
int SDCAPI
SIGNDOC_VerificationResult_getBiometricDataW (struct SIGNDOC_Exception **aEx,
                                              struct SIGNDOC_VerificationResult *aObj,
                                              const unsigned char *aKeyPtr,
                                              size_t aKeySize,
                                              const wchar_t *aKeyPath,
                                              const char *aPassphrase,
                                              struct SIGNDOC_ByteArray *aOutput);

/**
 * @brief Get the encrypted biometric data of the field.
 *
 * Use this function if you cannot use
 * SIGNDOC_VerificationResult_getBiometricData() for decrypting the
 * biometric data (for instance, because the private key is stored in
 * an HSM).
 *
 * In the following description of the format of the encrypted data
 * retrieved by this function, all numbers are stored in little-endian
 * format (however, RSA uses big-endian format):
 *
 * - 4 octets: version number
 * - 4 octets: number of following octets (hash and body)
 * - 32 octets: SHA-256 hash of body (ie, of the octets which follow)
 * - body (format depends on version number)
 * .
 *
 * If the version number is 1, the encryption method is
 * #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_RSA with
 * a 2048-bit key and the body has this format:
 *
 * - 32 octets: SHA-256 hash of unencrypted biometric data
 * - 256 octets: AES-256 session key encrypted with 2048-bit RSA 2.0 (OAEP)
 *               with SHA-256
 * - rest: biometric data encrypted with AES-256 in CBC mode using
 *         padding as described in RFC 2246. The IV is zero (not a
 *         problem as the session key is random).
 * .
 * 
 * If the version number is 2, the body has this format:
 *
 * - 4 octets: method (#SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_FIXED,
 *   #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_BINARY, or
 *   #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_PASSPHRASE)
 * - 32 octets: IV (only the first 16 bytes are used, please ignore the rest)
 * - 32 octets: SHA-256 hash of unencrypted biometric data
 * - rest: biometric data encrypted with AES-256 in CBC mode using
 *         padding as described in RFC 2246.
 * .
 *
 * If the version number is 3, the encryption method is
 * #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_RSA with
 * a key longer than 2048 bits and the body has this format:
 *
 * - 4 octets: size n of encrypted AES key in octets
 * - n octets: AES-256 session key encrypted with RSA 2.0 (OAEP)
 *             with SHA-256
 * - 32 octets: IV (only the first 16 bytes are used, please ignore the rest)
 * - 32 octets: SHA-256 hash of unencrypted biometric data
 * - rest: biometric data encrypted with AES-256 in CBC mode using
 *         padding as described in RFC 2246.
 * .
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_VerificationResult object.
 * @param[out] aOutput      The decrypted biometric data will be stored here.
 *                          See above for the format.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful, #SIGNDOC_VERIFICATIONRESULT_RETURNCODE_NO_BIOMETRIC_DATA if no biometric
 *         data is availabable.
 *
 * @see SIGNDOC_VerificationResult_checkBiometricHash(), SIGNDOC_VerificationResult_getBiometricData(), SIGNDOC_VerificationResult_getBiometricEncryption()
 *
 * @memberof SIGNDOC_VerificationResult
 */
int SDCAPI
SIGNDOC_VerificationResult_getEncryptedBiometricData (struct SIGNDOC_Exception **aEx,
                                                      struct SIGNDOC_VerificationResult *aObj,
                                                      struct SIGNDOC_ByteArray *aOutput);

/**
 * @brief Get the encryption method used for biometric data of the signature
 *        field.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_VerificationResult object.
 * @param[out] aOutput     The encryption method:
 *                         #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_RSA,
 *                         #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_FIXED,
 *                         #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_BINARY, or
 *                         #SIGNDOC_SIGNATUREPARAMETERS_BIOMETRICENCRYPTION_PASSPHRASE.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful,
 *         #SIGNDOC_VERIFICATIONRESULT_RETURNCODE_NO_BIOMETRIC_DATA
 *        if no biometric data is availabable.
 *
 * @see SIGNDOC_VerificationResult_getBiometricData(), SIGNDOC_VerificationResult_getEncryptedBiometricData()
 *
 * @memberof SIGNDOC_VerificationResult
 */
int SDCAPI
SIGNDOC_VerificationResult_getBiometricEncryption (struct SIGNDOC_Exception **aEx,
                                                   struct SIGNDOC_VerificationResult *aObj,
                                                   int *aOutput);

/**
 * @brief Check the hash of the biometric data.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_VerificationResult object.
 * @param[in]  aBioPtr        Pointer to unencrypted biometric data,
 *                            typically retrieved by getBiometricData().
 * @param[in]  aBioSize       Size of unencrypted biometric data in octets.
 * @param[out] aOutput        Result of the operation: #SIGNDOC_TRUE if
 *                            the hash is OK, #SIGNDOC_FALSE if the hash
 *                            doesn't match (the document has been
 *                            tampered with).
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_VerificationResult_getBiometricData(), SIGNDOC_VerificationResult_getEncryptedBiometricData()
 *
 * @memberof SIGNDOC_VerificationResult
 */
int SDCAPI
SIGNDOC_VerificationResult_checkBiometricHash (struct SIGNDOC_Exception **aEx,
                                               struct SIGNDOC_VerificationResult *aObj,
                                               const unsigned char *aBioPtr,
                                               size_t aBioSize,
                                               SIGNDOC_Boolean *aOutput);

/**
 * @brief Get the state of the RFC 3161 time stamp.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_VerificationResult object.
 * @param[out]  aOutput  The state of the RFC 3161 time stamp:
 *                       #SIGNDOC_VERIFICATIONRESULT_TIMESTAMPSTATE_VALID,
 *                       #SIGNDOC_VERIFICATIONRESULT_TIMESTAMPSTATE_MISSING, or
 *                       #SIGNDOC_VERIFICATIONRESULT_TIMESTAMPSTATE_INVALID.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @memberof SIGNDOC_VerificationResult
 */
int SDCAPI
SIGNDOC_VerificationResult_getTimeStampState (struct SIGNDOC_Exception **aEx,
                                              struct SIGNDOC_VerificationResult *aObj,
                                              int *aOutput);

/**
 * @brief Verify the certificate chain of the RFC 3161 time stamp.
 *
 * SIGNDOC_VerificationResult_getErrorMessage() will return an
 * error message if this function fails (return value not
 * #SIGNDOC_DOCUMENT_RETURNCODE_OK) or the verification result returned
 * in @a aOutput is not #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_OK.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_VerificationResult object.
 * @param[in]   aModel   Model to be used for verification:
 *                       #SIGNDOC_VERIFICATIONRESULT_VERIFICATIONMODEL_DEFAULT or
 *                       #SIGNDOC_VERIFICATIONRESULT_VERIFICATIONMODEL_GERMAN_SIG_LAW.
 * @param[out]  aOutput  The result of the certificate chain verification:
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_OK,
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_BROKEN_CHAIN,
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_UNTRUSTED_ROOT,
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_CRITICAL_EXTENSION,
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_NOT_TIME_VALID,
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_PATH_LENGTH,
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_INVALID, or
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINSTATE_ERROR.
 *
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful,
 *         #SIGNDOC_DOCUMENT_RETURNCODE_NOT_VERIFIED if verification has failed.
 *
 * @see SIGNDOC_VerificationResult_verifyTimeStampCertificateRevocation(), SIGNDOC_VerificationResult_verifyTimeStampCertificateSimplified()
 *
 * @memberof SIGNDOC_VerificationResult
 *
 * @todo support #SIGNDOC_VERIFICATIONRESULT_VERIFICATIONMODEL_GERMAN_SIG_LAW for @a aModel
 */
int SDCAPI
SIGNDOC_VerificationResult_verifyTimeStampCertificateChain (struct SIGNDOC_Exception **aEx,
                                                            struct SIGNDOC_VerificationResult *aObj,
                                                            int aModel,
                                                            int *aOutput);

/**
 * @brief Check the revocation status of the certificate chain of the
 *        RFC 3161 time stamp.
 *
 * SIGNDOC_VerificationResult_getErrorMessage() will return an
 * error message if this function fails (return value not
 * #SIGNDOC_DOCUMENT_RETURNCODE_OK) or the verification result returned
 * in @a aOutput is not
 * #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONSTATE_OK.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_VerificationResult object.
 * @param[in]   aModel   Model to be used for verification:
 *                       #SIGNDOC_VERIFICATIONRESULT_VERIFICATIONMODEL_DEFAULT or
 *                       #SIGNDOC_VERIFICATIONRESULT_VERIFICATIONMODEL_GERMAN_SIG_LAW.
 * @param[out]  aOutput  The result of the certificate revocation check:
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONSTATE_OK,
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONSTATE_NOT_CHECKED,
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONSTATE_OFFLINE,
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONSTATE_REVOKED, or
 *                       #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONSTATE_ERROR.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful, #SIGNDOC_DOCUMENT_RETURNCODE_NOT_VERIFIED if verification has failed.
 *
 * @see SIGNDOC_VerificationResult_verifyTimeStampCertificateChain(), SIGNDOC_VerificationResult_verifyTimeStampCertificateSimplified()
 *
 * @memberof SIGNDOC_VerificationResult
 *
 * @todo support #SIGNDOC_VERIFICATIONRESULT_VERIFICATIONMODEL_GERMAN_SIG_LAW for @a aModel
 */
int SDCAPI
SIGNDOC_VerificationResult_verifyTimeStampCertificateRevocation (struct SIGNDOC_Exception **aEx,
                                                                 struct SIGNDOC_VerificationResult *aObj,
                                                                 int aModel,
                                                                 int *aOutput);

/**
 * @brief Simplified verification of the certificate chain and revocation
 *        status of the RFC 3161 time stamp.
 *
 * This function just returns a good / not good value according to
 * policies defined by the arguments. It does not tell the caller
 * what exactly is wrong. However,
 * SIGNDOC_VerificationResult_getErrorMessage() will return an
 * error message if this function fails. Do not attempt to base
 * decisions on that error message, please use
 * SIGNDOC_VerificationResult_verifyTimeStampCertificateChain() and
 * SIGNDOC_VerificationResult_verifyTimeStampCertificateRevocation()
 * instead of this function
 * if you need details about the failure.
 *
 * If @a aChainPolicy is
 * #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINVERIFICATIONPOLICY_DONT_VERIFY,
 * @a aRevocationPolicy must
 * be #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_DONT_CHECK,
 * otherwise this function will return
 * #SIGNDOC_VERIFICATIONRESULT_RETURNCODE_INVALID_ARGUMENT.
 *
 * @a #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINVERIFICATIONPOLICY_ACCEPT_SELF_SIGNED_WITH_BIO and
 * @a #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINVERIFICATIONPOLICY_ACCEPT_SELF_SIGNED_WITH_RSA_BIO
 * are treated like
 * #SIGNDOC_VERIFICATIONRESULT_CERTIFICATECHAINVERIFICATIONPOLICY_CCEPT_SELF_SIGNED.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_VerificationResult object.
 * @param[in] aChainPolicy       Policy for verification of the certificate
 *                               chain:
 *                               #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_DONT_CHECK,
 *                               #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_OFFLINE, or
 *                               #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_ONLINE.
 * @param[in] aRevocationPolicy  Policy for verification of the revocation
 *                               status of the certificates:
 *                               #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_DONT_CHECK,
 *                               #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_OFFLINE, or
 *                               #SIGNDOC_VERIFICATIONRESULT_CERTIFICATEREVOCATIONVERIFICATIONPOLICY_ONLINE.
 * @param[in] aModel             Model to be used for verification:
 *                       #SIGNDOC_VERIFICATIONRESULT_VERIFICATIONMODEL_DEFAULT or
 *                       #SIGNDOC_VERIFICATIONRESULT_VERIFICATIONMODEL_GERMAN_SIG_LAW.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful,
 *         #SIGNDOC_DOCUMENT_RETURNCODE_NOT_VERIFIED if verification has failed,
 *         #SIGNDOC_VERIFICATIONRESULT_RETURNCODE_INVALID_ARGUMENT if the
 *         arguments are invalid,
 *         #SIGNDOC_VERIFICATIONRESULT_RETURNCODE_NOT_SUPPORTED if there
 *         is no RFC 3161 time stamp.
 *
 * @see SIGNDOC_VerificationResult_verifyTimeStampCertificateChain(), SIGNDOC_VerificationResult_verifyTimeStampCertificateRevocation()
 *
 * @memberof SIGNDOC_VerificationResult
 *
 * @todo support #SIGNDOC_VERIFICATIONRESULT_VERIFICATIONMODEL_GERMAN_SIG_LAW for @a aModel
 */
int SDCAPI
SIGNDOC_VerificationResult_verifyTimeStampCertificateSimplified (struct SIGNDOC_Exception **aEx,
                                                                 struct SIGNDOC_VerificationResult *aObj,
                                                                 int aChainPolicy,
                                                                 int aRevocationPolicy,
                                                                 int aModel);

/**
 * @brief Get the value of the RFC 3161 time stamp.
 *
 * You must call
 * SIGNDOC_VerificationResult_verifyTimeStampCertificateChain() and
 * SIGNDOC_VerificationResult_verifyTimeStampCertificateRevocation()
 * to find out whether the time stamp can be trusted.  If either of
 * these functions report a problem, the time stamp should not be
 * displayed.
 *
 * A signature has either an RFC 3161 time stamp (returned by this
 * function) or a time stamp stored as string parameter (returned by
 * SIGNDOC_VerificationResult_getSignatureString().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_VerificationResult object.
 * @param[out]  aOutput  The RFC 3161 time stamp in ISO 8601
 *                       format: "yyyy-mm-ddThh:mm:ssZ"
 *                       (without milliseconds).
 *                       The string must be freed with SIGNDOC_free().
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful.
 *
 * @see SIGNDOC_VerificationResult_getSignatureString(), SIGNDOC_VerificationResult_verifyTimeStampCertificateChain(), SIGNDOC_VerificationResult_verifyTimeStampCertificateRevocation()
 *
 * @memberof SIGNDOC_VerificationResult
 */
int SDCAPI
SIGNDOC_VerificationResult_getTimeStamp (struct SIGNDOC_Exception **aEx,
                                         struct SIGNDOC_VerificationResult *aObj,
                                         char **aOutput);

/**
 * @brief Get the certificates of the RFC 3161 time stamp.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_VerificationResult object.
 * @param[out]  aOutput  The ASN.1-encoded X.509 certificates will be
 *                       stored here.  If there are multiple certificates,
 *                       the first one (at index 0) is the signing
 *                       certificate.
 *
 * @return #SIGNDOC_DOCUMENT_RETURNCODE_OK if successful,
 *         #SIGNDOC_DOCUMENT_RETURNCODE_NOT_VERIFIED if verification has failed.
 *
 * @memberof SIGNDOC_VerificationResult
 */
int SDCAPI
SIGNDOC_VerificationResult_getTimeStampCertificates (struct SIGNDOC_Exception **aEx,
                                                     struct SIGNDOC_VerificationResult *aObj,
                                                     struct SIGNDOC_ByteArrayArray *aOutput);

/**
 * @brief Get an error message for the last function call.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_VerificationResult object.
 * @param[in] aEncoding  The encoding to be used for the error message
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 *
 * @return A pointer to a string describing the reason for the
 *         failure of the last function call. The string is empty
 *         if the last call succeeded. The pointer is valid until
 *         this object is destroyed or a member function of @a aObj
 *         is called.
 *
 * @see SIGNDOC_VerificationResult_getErrorMessage()
 *
 * @memberof SIGNDOC_VerificationResult
 */
const char * SDCAPI
SIGNDOC_VerificationResult_getErrorMessage (struct SIGNDOC_Exception **aEx,
                                            struct SIGNDOC_VerificationResult *aObj,
                                            int aEncoding);

/**
 * @brief Get an error message for the last function call.
 *
 * @note Do <b>not</b> call SIGNDOC_free() on the return value.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_VerificationResult object.
 *
 * @return A pointer to a string describing the reason for the
 *         failure of the last function call. The string is empty
 *         if the last call succeeded. The pointer is valid until
 *         this object is destroyed or a member function of @a aObj
 *         is called.
 *
 * @see SIGNDOC_VerificationResult_getErrorMessage()
 *
 * @memberof SIGNDOC_VerificationResult
 */
const wchar_t * SDCAPI
SIGNDOC_VerificationResult_getErrorMessageW (struct SIGNDOC_Exception **aEx,
                                             struct SIGNDOC_VerificationResult *aObj);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_Watermark constructor.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 *
 * @memberof SIGNDOC_Watermark
 */
struct SIGNDOC_Watermark * SDCAPI
SIGNDOC_Watermark_new (struct SIGNDOC_Exception **aEx);

/**
 * @brief clone a SIGNDOC_Watermark object.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aSource  The object to be copied.
 *
 * @memberof SIGNDOC_Watermark
 */
struct SIGNDOC_Watermark * SDCAPI
SIGNDOC_Watermark_clone (struct SIGNDOC_Exception **aEx,
                         const struct SIGNDOC_Watermark *aSource);

/**
 * @brief SIGNDOC_Watermark destructor.
 *
 * @param[in] aObj     A pointer to the SIGNDOC_Watermark object.
 *
 * @memberof SIGNDOC_Watermark
 */
void SDCAPI
SIGNDOC_Watermark_delete (struct SIGNDOC_Watermark *aObj);

/**
 * @brief SIGNDOC_Watermark assignment operator.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Watermark object.
 * @param[in] aSource  The source object.
 *
 * @memberof SIGNDOC_Watermark
 */
void SDCAPI
SIGNDOC_Watermark_assign (struct SIGNDOC_Exception **aEx,
                          struct SIGNDOC_Watermark *aObj,
                          const struct SIGNDOC_Watermark *aSource);

/**
 * @brief Reset all parameters to their default values.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Watermark object.
 *
 * @memberof SIGNDOC_Watermark
 */
void SDCAPI
SIGNDOC_Watermark_clear (struct SIGNDOC_Exception **aEx,
                         struct SIGNDOC_Watermark *aObj);

/**
 * @brief Set the text to be used for the watermark.
 *
 * The default value is empty.
 *
 * The text can contain multiple lines, the newline character is
 * used to separate lines.  If there are multiple lines, their
 * relative position is specified by SIGNDOC_Watermark_setJustification().
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Watermark object.
 * @param[in] aEncoding   The encoding of @a aText
 *                        (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                        or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aText       The text. Complex scripts are supported,
 *                        see @ref signdocshared_complex_scripts.
 *
 * @see SIGNDOC_Watermark_setFontName(), SIGNDOC_Watermark_setFontSize(), SIGNDOC_Watermark_setJustification(), SIGNDOC_Watermark_setTextColor()
 *
 * @memberof SIGNDOC_Watermark
 */
void SDCAPI
SIGNDOC_Watermark_setText (struct SIGNDOC_Exception **aEx,
                           struct SIGNDOC_Watermark *aObj,
                           int aEncoding, const char *aText);

/**
 * @brief Set the name of the font.
 *
 * The font name can be the name of a standard font, the name of an
 * already embedded font, or the name of a font defined by a font
 * configuration file.
 *
 * The default value is "Helvetica".
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Watermark object.
 * @param[in] aEncoding  The encoding of @a aFontName
 *                       (#SIGNDOC_ENCODING_NATIVE, #SIGNDOC_ENCODING_UTF_8,
 *                       or #SIGNDOC_ENCODING_LATIN_1).
 * @param[in] aFontName  The new font name.
 *
 * @see SIGNDOC_Watermark_setFontSize(), SIGNDOC_Watermark_setTextColor(), SIGNDOC_DocumentLoader_loadFontConfigFile(), SIGNDOC_DocumentLoader_loadFontConfigEnvironment(), SIGNDOC_DocumentLoader_loadFontConfigStream()
 *
 * @memberof SIGNDOC_Watermark
 */
void SDCAPI
SIGNDOC_Watermark_setFontName (struct SIGNDOC_Exception **aEx,
                               struct SIGNDOC_Watermark *aObj,
                               int aEncoding, const char *aFontName);

/**
 * @brief Set the font size.
 *
 * The default value is 24.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Watermark object.
 * @param[in] aFontSize  The font size (in user space units).
 *
 * @see SIGNDOC_Watermark_setFontName(), SIGNDOC_Watermark_setScale()
 *
 * @memberof SIGNDOC_Watermark
 */
void SDCAPI
SIGNDOC_Watermark_setFontSize (struct SIGNDOC_Exception **aEx,
                               struct SIGNDOC_Watermark *aObj,
                               double aFontSize);

/**
 * @brief Set the text color.
 *
 * The default value is black (gray scale).
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Watermark object.
 * @param[in] aTextColor  The text color. The value will be copied.
 *
 * @memberof SIGNDOC_Watermark
 */
void SDCAPI
SIGNDOC_Watermark_setTextColor (struct SIGNDOC_Exception **aEx,
                                struct SIGNDOC_Watermark *aObj,
                                const struct SIGNDOC_Color *aTextColor);

/**
 * @brief Set the justification for multi-line text.
 *
 * The default value is #SIGNDOC_WATERMARK_JUSTIFICATION_LEFT.
 *
 * If the text (see SIGNDOC_Watermark_setText()) contains only one
 * line (ie, no newline characters), this parameter will be ignored.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Watermark object.
 * @param[in] aJustification  The justification:
 *                            #SIGNDOC_WATERMARK_JUSTIFICATION_LEFT,
 *                            #SIGNDOC_WATERMARK_JUSTIFICATION_CENTER,
 *                            #SIGNDOC_WATERMARK_JUSTIFICATION_RIGHT.
 *
 * @see SIGNDOC_Watermark_setText()
 *
 * @memberof SIGNDOC_Watermark
 */
void SDCAPI
SIGNDOC_Watermark_setJustification (struct SIGNDOC_Exception **aEx,
                                    struct SIGNDOC_Watermark *aObj,
                                    int aJustification);

/**
 * @brief Set the rotation.
 *
 * The default value is 0.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Watermark object.
 * @param[in] aRotation  The rotation in degrees (-180 through 180),
 *                       0 is horizontal (left to right),
 *                       45 is bottom left to upper right.
 *
 * @memberof SIGNDOC_Watermark
 */
void SDCAPI
SIGNDOC_Watermark_setRotation (struct SIGNDOC_Exception **aEx,
                               struct SIGNDOC_Watermark *aObj,
                               double aRotation);

/**
 * @brief Set the opacity.
 *
 * The default value is 1.0. Documents conforming to PDF/A must
 * use an opacity of 1.0.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Watermark object.
 * @param[in] aOpacity  The opacity, 0.0 (transparent) through 1.0 (opaque).
 *
 * @see SIGNDOC_Watermark_setLocation()
 *
 * @memberof SIGNDOC_Watermark
 */
void SDCAPI
SIGNDOC_Watermark_setOpacity (struct SIGNDOC_Exception **aEx,
                              struct SIGNDOC_Watermark *aObj,
                              double aOpacity);

/**
 * @brief Disable scaling or set scaling relative to page.
 *
 * The default value is 0.5.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Watermark object.
 * @param[in] aScale  0 to disable scaling (use the font size set by
 *                    SIGNDOC_Watermark_setFontSize()) or 0.01
 *                    through 64.0 to scale
 *                    relative to the page size.
 *
 * @memberof SIGNDOC_Watermark
 */
void SDCAPI
SIGNDOC_Watermark_setScale (struct SIGNDOC_Exception **aEx,
                            struct SIGNDOC_Watermark *aObj,
                            double aScale);

/**
 * @brief Set whether the watermark will appear behind the page or
 *        on top of the page.
 *
 * The default value is l_overlay.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Watermark object.
 * @param[in] aLocation   Where to put the overlay:
 *                        #SIGNDOC_WATERMARK_LOCATION_OVERLAY or
 *                        #SIGNDOC_WATERMARK_LOCATION_UNDERLAY.
 *
 * @see SIGNDOC_Watermark_setOpacity()
 *
 * @memberof SIGNDOC_Watermark
 */
void SDCAPI
SIGNDOC_Watermark_setLocation (struct SIGNDOC_Exception **aEx,
                               struct SIGNDOC_Watermark *aObj,
                               int aLocation);

/**
 * @brief Set the horizontal position of the watermark.
 *
 * The default values are #SIGNDOC_WATERMARK_HALIGNMENT_CENTER and 0.
 *
 * The distance is measured from the left edge of the page to the
 * left edge of the watermark (#SIGNDOC_WATERMARK_HALIGNMENT_LEFT),
 * from the center of the page
 * to the center of the watermark (#SIGNDOC_WATERMARK_HALIGNMENT_CENTER),
 * or from the right
 * edge of the page to the right edge of the watermark
 * #SIGNDOC_WATERMARK_HALIGNMENT_RIGHT).
 *
 * For #SIGNDOC_WATERMARK_HALIGNMENT_LEFT and
 * #SIGNDOC_WATERMARK_HALIGNMENT_CENTER, positive values push the watermark to
 * the right, for #SIGNDOC_WATERMARK_HALIGNMENT_RIGHT, positive values
 * push the watermark to the left.

 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Watermark object.
 * @param[in] aAlignment  Measure distance from here:
 *                        #SIGNDOC_WATERMARK_HALIGNMENT_LEFT,
 *                        #SIGNDOC_WATERMARK_HALIGNMENT_CENTER, or
 *                        #SIGNDOC_WATERMARK_HALIGNMENT_RIGHT.
 * @param[in] aDistance   The distance in user space units.
 *
 * @see SIGNDOC_Watermark_setScale(), SIGNDOC_Watermark_setVerticalPosition()
 *
 * @memberof SIGNDOC_Watermark
 */
void SDCAPI
SIGNDOC_Watermark_setHorizontalPosition (struct SIGNDOC_Exception **aEx,
                                         struct SIGNDOC_Watermark *aObj,
                                         int aAlignment, double aDistance);

/**
 * @brief Set the vertical position of the watermark.
 *
 * The default values are #SIGNDOC_WATERMARK_VALIGNMENT_CENTER and 0.
 *
 * The distance is measured from the top edge of the page to the top
 * edge of the watermark (#SIGNDOC_WATERMARK_VALIGNMENT_TOP), from the
 * center of the page to the center of the watermark
 * (#SIGNDOC_WATERMARK_VALIGNMENT_CENTER), or from the bottom edge of
 * the page to the bottom edge of the watermark
 * (#SIGNDOC_WATERMARK_VALIGNMENT_BOTTOM).
 *
 * For #SIGNDOC_WATERMARK_VALIGNMENT_BOTTOM and
 * #SIGNDOC_WATERMARK_VALIGNMENT_CENTER, positive values push the
 * watermark up, for #SIGNDOC_WATERMARK_VALIGNMENT_TOP, positive values
 * push the watermark down.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Watermark object.
 * @param[in] aAlignment  Measure distance from here:
 *                        #SIGNDOC_WATERMARK_VALIGNMENT_TOP,
 *                        #SIGNDOC_WATERMARK_VALIGNMENT_CENTER, or
 *                        #SIGNDOC_WATERMARK_VALIGNMENT_BOTTOM.
 * @param[in] aDistance   The distance in user space units.
 *
 * @see SIGNDOC_Watermark_setHorizontalPosition(), SIGNDOC_Watermark_setScale()
 *
 * @memberof SIGNDOC_Watermark
 */
void SDCAPI
SIGNDOC_Watermark_setVerticalPosition (struct SIGNDOC_Exception **aEx,
                                       struct SIGNDOC_Watermark *aObj,
                                       int aAlignment, double aDistance);

/**
 * @brief Set the first page number.
 *
 * The default value is 1.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Watermark object.
 * @param[in] aPage  The 1-based page number of the first page.
 *
 * @see SIGNDOC_Watermark_setLastPage(), SIGNDOC_Watermark_setPageIncrement()
 *
 * @memberof SIGNDOC_Watermark
 */
void SDCAPI
SIGNDOC_Watermark_setFirstPage (struct SIGNDOC_Exception **aEx,
                                struct SIGNDOC_Watermark *aObj,
                                int aPage);

/**
 * @brief Set the last page number.
 *
 * The default value is 0.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Watermark object.
 * @param[in] aPage  The 1-based page number of the last page or
 *                   0 for the last page of the document.
 *
 * @see SIGNDOC_Watermark_setFirstPage(), SIGNDOC_Watermark_setPageIncrement()
 *
 * @memberof SIGNDOC_Watermark
 */
void SDCAPI
SIGNDOC_Watermark_setLastPage (struct SIGNDOC_Exception **aEx,
                               struct SIGNDOC_Watermark *aObj,
                               int aPage);

/**
 * @brief Set the page number increment.
 *
 * The default value is 1 (add watermark to all pages between
 * the first page and the last page)
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 * @param[in] aObj     A pointer to the SIGNDOC_Watermark object.
 * @param[in] aIncr  Add this number to the page number when iterating
 *                   over pages adding watermarks.  Must be positive.
 *
 * @see SIGNDOC_Watermark_setFirstPage(), SIGNDOC_Watermark_setLastPage()
 *
 * @memberof SIGNDOC_Watermark
 */
void SDCAPI
SIGNDOC_Watermark_setPageIncrement (struct SIGNDOC_Exception **aEx,
                                    struct SIGNDOC_Watermark *aObj,
                                    int aIncr);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_DocumentHandler destructor.
 *
 * @note Do not call this function for handlers passed to
 *       SIGNDOC_DocumentLoader_registerDocumentHandler().
 *
 * @param[in] aObj     A pointer to the SIGNDOC_DocumentHandler object.
 *
 * @memberof SIGNDOC_DocumentHandler
 */
void SDCAPI
SIGNDOC_DocumentHandler_delete (struct SIGNDOC_DocumentHandler *aObj);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_PdfDocumentHandler constructor.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 *
 * @memberof SIGNDOC_PdfDocumentHandler
 */
struct SIGNDOC_DocumentHandler * SDCAPI
SIGNDOC_PdfDocumentHandler_new (struct SIGNDOC_Exception **aEx);

/* --------------------------------------------------------------------------*/

/**
 * @brief SIGNDOC_TiffDocumentHandler constructor.
 *
 * @param[out] aEx     Any exception will be returned in the object pointed to
 *                     by this parameter.
 *
 * @memberof SIGNDOC_TiffDocumentHandler
 */
struct SIGNDOC_DocumentHandler * SDCAPI
SIGNDOC_TiffDocumentHandler_new (struct SIGNDOC_Exception **aEx);

/* --------------------------------------------------------------------------*/

#ifdef __cplusplus
} // extern "C"
#endif

#endif /* SP_SIGNDOCSDK_C_H__ */
