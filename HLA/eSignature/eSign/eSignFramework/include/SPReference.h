/*==============================================================*
 * SOFTPRO SignWare                                             *
 * ADSV developer Toolkit                                       *
 * Module: SPReference.h                                        *
 * Created by: uko                                              *
 *                                                              *
 * @(#)SPReference.h                           1.00 02/06/04    *
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
 * @file SPReference.h
 * @author uko
 *
 * @brief SignWare Dynamic Development toolkit, reference object
 *
 * An SPReference object is a collection of signature objects forming
 * a signature reference.
 * SPReference objects can be used to create a flat file to save a signature or
 * reference to disk or to a database, or to compare a reference
 * against a signature, or to create a template object (compressed flat file
 * format optimized for smart cards).
 *
 * Use @ref SPReferenceCreate, @ref SPReferenceCreateFromFlatFile,
 * @ref SPReferenceCreateFromGuiAcqu, or @ref SPReferenceCreateFromTellerImage
 * to create an SPReference object.
 */

#ifndef SPREFERENCE_H__
#define SPREFERENCE_H__
#include "SPSignWare.h"

/*==============================================================*
 * Constant definitions                                         *
 *==============================================================*/
/**
 * @brief Minimum number of signatures contained in a reference
 * @see SPReferenceCheck
 */
#define SP_REFERENCE_MIN_SIGNATURES "SPReferenceMinSignatures"

/**
 * @brief Minimum dynamic quality of a reference
 * @see SPReferenceCheck
 */
#define SP_REFERENCE_MIN_DYNAMIC_QUALITY "SPReferenceMinDynamicQuality"
/**
 * @brief Variance of a reference
 * @see SPReferenceCheck
 */
#define SP_REFERENCE_MIN_MATCH "SPReferenceMinMatch"
/**
 * @brief Check all signatures included in a reference
 * @see SPReferenceCheck
 */
#define SP_REFERENCE_CHECK_SIGNATURES "SPReferenceCheckSignatures"

/**
 * @brief Maximum duration to enter all signatures within a reference
 * @see SPReferenceCheck
 */
#define SP_REFERENCE_MAX_DURATION "SPReferenceMaxDuration"
/*==============================================================*
 * Structures and type definitions                              *
 *==============================================================*/

/*==============================================================*
 * Function declarations                                        *
 *==============================================================*/
#ifdef __cplusplus
extern "C" {
#endif  /* __cplusplus */

/**
 * @brief Create a new SPReference object.
 *
 * Typically, @ref SPReferenceAddSignature is used after calling this
 * function to add signatures to the new SPReference object.
 *
 * @param ppReference [o]
 *      pointer to a variable that will be filled with a pointer to
 *      a new SPReference object.  The caller is responsible for
 *      deallocating the new object by calling @ref SPReferenceFree.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   - @ref SP_MEMERR        out of memory
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPReferenceAddSignature, SPReferenceCreateFromFlatFile, SPReferenceCreateFromGuiAcqu, SPReferenceCreateFromTellerImage, SPReferenceFree
 */
SPEXTERN SPINT32 SPLINK SPReferenceCreate(pSPREFERENCE_T *ppReference);

/**
 * @brief Create a new SPReference object from a flat file object.
 *
 * This function deserializes an SPReference object serialized by
 * @ref SPFlatFileCreateFromReference.
 *
 * @param ppReference [o]
 *      pointer to a variable that will be filled with a pointer to
 *      a new SPReference object.  The caller is responsible for
 *      deallocating the new object by calling @ref SPReferenceFree.
 * @param pbFlatFile [i]
 *      pointer to an array of bytes containing a serialized SPReference
 *      object.
 * @param iFlatFileLength [i]
 *      length (in bytes) of the serialized data pointed to by @a pbFlatFile.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   - @ref SP_MEMERR        out of memory
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPReferenceCreate, SPReferenceCreateFromGuiAcqu, SPReferenceCreateFromTellerImage, SPReferenceFree, SPFlatFileCreateFromReference
 */
SPEXTERN SPINT32 SPLINK SPReferenceCreateFromFlatFile(pSPREFERENCE_T *ppReference, const SPUCHAR *pbFlatFile, SPINT32 iFlatFileLength);

/**
 * @brief Create an SPReference object from the result of a signature acquiry.
 *
 * The returned reference may contain a single signature (in this case
 * a signature was captured), or multiple signatures (when a true
 * reference was captured). It is the responsability of the
 * application to convert the reference to a signature if the returned
 * object includes a single signature.
 *
 * @param ppReference [o]
 *      pointer to a variable that will be filled with a pointer to
 *      a new SPReference object.  The caller is responsible for
 *      deallocating the new object by calling @ref SPReferenceFree.
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPReferenceCreate, SPReferenceCreateFromTellerImage, SPReferenceFree, SPGuiAcquGetReference
 */
SPEXTERN SPINT32 SPLINK SPReferenceCreateFromGuiAcqu(pSPREFERENCE_T *ppReference, pSPGUIACQU_T pSPGuiAcqu);

/**
 * @brief Create an SPReference object from the result of a signature acquiry.
 *
 * The returned reference may contain a single signature (in this case
 * a signature was captured), or multiple signatures (when a true
 * reference was captured). It is the responsability of the
 * application to convert the reference to a signature if the returned
 * object includes a single signature.
 *
 * @param ppReference [o]
 *      pointer to a variable that will be filled with a pointer to
 *      a new SPReference object.  The caller is responsible for
 *      deallocating the new object by calling @ref SPReferenceFree.
 * @param pSPAcquire [i]
 *      pointer to an SPAcquire object.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     .
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPReferenceCreate, SPReferenceCreateFromTellerImage, SPReferenceFree, SPGuiAcquGetReference
 */
SPEXTERN SPINT32 SPLINK SPReferenceCreateFromAcquire(pSPREFERENCE_T *ppReference, pSPACQUIRE_T pSPAcquire);

/**
 * @brief Create an SPReference object from an SPTellerImage object.
 *
 * @param ppReference [o]
 *      pointer to a variable that will be filled with a pointer to
 *      a new SPReference object.  The caller is responsible for
 *      deallocating the new object by calling @ref SPReferenceFree.
 * @param pTellerImage [i]
 *      pointer to an SPTellerImage object.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_MEMERR        out of memory
 *     .
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPReferenceCreate, SPReferenceCreateFromFlatFile, SPReferenceCreateFromGuiAcqu, SPReferenceFree, SPTellerImageCreateFromReference
 */
SPEXTERN SPINT32 SPLINK SPReferenceCreateFromTellerImage(pSPREFERENCE_T *ppReference, pSPTELLERIMAGE_T pTellerImage);

/**
 * @brief Create a copy of an SPReference object.
 *
 * @param pReference [i]
 *      pointer to the SPReference object to be copied.
 * @param ppReference [o]
 *      pointer to a variable that will be filled with a pointer to
 *      a new SPReference object.  The caller is responsible for deallocating
 *      the new object by calling @ref SPReferenceFree.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   - @ref SP_MEMERR        out of memory
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPReferenceCreate, SPReferenceFree
 */
SPEXTERN SPINT32 SPLINK SPReferenceClone(pSPREFERENCE_T pReference, pSPREFERENCE_T *ppReference);

/**
 * @brief Deallocate an SPReference object.
 *
 * The SPReference object must have been created by
 * @ref SPReferenceCreate, @ref SPReferenceCreateFromFlatFile,
 * @ref SPReferenceCreateFromGuiAcqu,
 * @ref SPReferenceCreateFromTellerImage, @ref SPReferenceClone,
 * or @ref SPGuiAcquGetReference.
 *
 * @param ppReference [io]
 *      pointer to a variable containing a pointer to an SPReference
 *      object.
 *      The variable will be set to NULL if this function succeeds.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPReferenceCreate, SPReferenceCreateFromFlatFile, SPReferenceCreateFromGuiAcqu, SPGuiAcquGetReference
 */
SPEXTERN SPINT32 SPLINK SPReferenceFree(pSPREFERENCE_T *ppReference);

/**
 * @brief Add a signature to an SPReference object.
 *
 * @note The SPReference object may move in memory. If you have multiple
 *       pointers to the SPReference object, you have to update all
 *       of them.
 *
 * @param ppReference [io]
 *      pointer to variable containing a pointer to an SPReference object.
 *      The SPReference object may move in memory, therefore the variable
 *      may be updated by this function.
 * @param pSignature [i]
 *      pointer to an SPSignature object.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   - @ref SP_MEMERR        out of memory
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPReferenceCreate, SPReferenceGetSignatureCount, SPSignatureCreateFromReference
 */
SPEXTERN SPINT32 SPLINK SPReferenceAddSignature(pSPREFERENCE_T *ppReference, pSPSIGNATURE_T pSignature);

/**
 * @brief Get the number of signatures contained in an SPReference object.
 *
 * @param pReference [i]
 *      pointer to an SPReference object.
 * @param piNrSignatures [o]
 *      pointer to a variable that will be filled with the number of
 *      signatures contained in the SPReference object.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPReferenceCreate, SPReferenceAddSignature, SPSignatureCreateFromReference
 */
SPEXTERN SPINT32 SPLINK SPReferenceGetSignatureCount(pSPREFERENCE_T pReference, SPINT32 *piNrSignatures);

/**
 * @brief Get the quality of the static features of a signature contained
 *        in an SPReference object.

 * @param pReference [i]
 *      pointer to an SPReference object.
 * @param iIndex [i]
 *      Zero-based index of the signature to test.
 * @param piResult [o]
 *      pointer to a variable that will be filled with the quality
        (in percent) of the static features of the signature.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   - @ref SP_LINKLIBRARYERR cannot access static engine
 *   - @ref SP_MEMERR        out of memory
 *   - @ref SP_STATICERR     error during processing by the static engine
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a)
 * @see SPReferenceGetDynamicQuality, SPReferenceGetSignatureCount
 */
SPEXTERN SPINT32 SPLINK SPReferenceGetStaticQuality(pSPREFERENCE_T pReference, SPINT32 iIndex, SPINT32 *piResult);

/**
 * @brief Get the quality of the dynamic features of the signatures
 *        contained in an SPReference object.
 *
 * @param pReference [i]
 *      pointer to an SPReference object.
 * @param piResult [o]
 *      pointer to a variable that will be filled with the quality
 *      (in percent) of the dynamic features of the signatures.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   - @ref SP_LINKLIBRARYERR cannot access dynamic engine
 *   - @ref SP_MEMERR        out of memory
 *   - @ref SP_DYNAMICERR    error during processing by the dynamic engine
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a)
 * @see SPReferenceGetStaticQuality
 */
SPEXTERN SPINT32 SPLINK SPReferenceGetDynamicQuality(pSPREFERENCE_T pReference, SPINT32 *piResult);

/**
 * @brief Check the variance of the signatures contained in an SPReference
 *        object.
 *
 * This function is equivalent to @ref SPReferenceGetVarianceEx with
 * 80 being passed for @a iQuality.
 *
 * @param pReference [i]
 *      pointer to an SPReference object.
 * @param piVariance [o]
 *      pointer to a variable that will be filled with the value 1 (variance
 *      of the signatures is acceptable) or 0 (the variance of the
 *      signatures is too big).
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   - @ref SP_LINKLIBRARYERR cannot access static or dynamic engine
 *   - @ref SP_MEMERR        out of memory
 *   - @ref SP_DYNAMICERR    error during processing by the dynamic engine
 *   - @ref SP_STATICERR     error during processing by the static engine
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a)
 * @see SPReferenceGetVarianceEx
 */
SPEXTERN SPINT32 SPLINK SPReferenceGetVariance(pSPREFERENCE_T pReference, SPINT32 *piVariance);

/**
 * @brief Check the variance of the signatures contained in an SPReference
 *        object.
 *
 * SPReferenceGetVarianceEx calculates the variance based on a static compare of all
 * embedded signatures against each other (the match rate of each single signature 
 * comparison must exceed iQuality)
 * 
 * @param pReference [i]
 *      pointer to an SPReference object.
 * @param iQuality [i]
 *      variance quality level, 0 through 100, typically 80.
 * @param piVariance [o]
 *      pointer to a variable that will be filled with the value 1 (variance
 *      of the signatures is acceptable) or 0 (the variance of the
 *      signatures is too big).
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   - @ref SP_LINKLIBRARYERR cannot access static or dynamic engine
 *   - @ref SP_MEMERR        out of memory
 *   - @ref SP_DYNAMICERR    error during processing by the dynamic engine
 *   - @ref SP_STATICERR     error during processing by the static engine
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a)
 * @see SPReferenceGetVariance
 */
SPEXTERN SPINT32 SPLINK SPReferenceGetVarianceEx(pSPREFERENCE_T pReference, SPINT32 iQuality, SPINT32 *piVariance);

/**
 * @brief Create a bitmap from a signature stored in an SPReference object.
 *
 * @param pReference [i]
 *      pointer to an SPReference object.
 * @param dZoom [i]
 *      the zoom factor (must be positive).
 * @param iImageFormat [i]
 *      desired format of the bitmap:
 *      - @ref SP_IMAGE_GIF
 *      - @ref SP_IMAGE_CCITT4
 *      - @ref SP_IMAGE_TIFF
 *      - @ref SP_IMAGE_BMP_WIN
 *      .
 *      Flags that can be added with the `|' operator:
 *      - @ref SP_IMAGE_BLACKWHITE
 *      - @ref SP_IMAGE_BLACKWHITE_1BPP
 *      - @ref SP_IMAGE_CROSSED
 *      - @ref SP_DONT_RENDER_METAFONT
 *      - @ref SP_DONT_RENDER_DIRECT
 *      .
 * @param iIndex [i]
 *      zero-based index of the signature within the reference.
 * @param ppbImage [o]
 *      pointer to a variable that will be filled with a pointer to an array of
 *      bytes containing the bitmap. The caller is responsible for deallocating
 *      that array of bytes by calling @ref SPReferenceFreeImage.
 * @param piImageLength [o]
 *      pointer to a variable that will be filled with the length (in bytes) of
 *      the bitmap returned via @a ppbImage.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   - @ref SP_MEMERR        out of memory
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPReferenceGetImage2, SPReferenceFreeImage, SPSignatureGetImage, SPTemplateGetImage
 */
SPEXTERN SPINT32 SPLINK SPReferenceGetImage(pSPREFERENCE_T pReference, SPDOUBLE dZoom, SPINT32 iImageFormat, SPINT32 iIndex, SPUCHAR **ppbImage, SPINT32 *piImageLength);

/**
 * @brief Create a bitmap from a signature stored in an SPReference object.
 *
 * @param pReference [i]
 *      pointer to an SPReference object.
 * @param dZoom [i]
 *      the zoom factor (must not exceed 1.0).
 * @param iImageFormat [i]
 *      desired format of the bitmap:
 *      - @ref SP_IMAGE_GIF
 *      - @ref SP_IMAGE_CCITT4
 *      - @ref SP_IMAGE_TIFF
 *      - @ref SP_IMAGE_BMP_WIN
 *      .
 *      Flags that can be added with the `|' operator:
 *      - @ref SP_IMAGE_BLACKWHITE
 *      - @ref SP_IMAGE_BLACKWHITE_1BPP
 *      - @ref SP_IMAGE_CROSSED
 *      - @ref SP_DONT_RENDER_METAFONT
 *      - @ref SP_DONT_RENDER_DIRECT
 *      .
 * @param iIndex [i]
 *      zero-based index of the signature within the reference.
 * @param pTicket [i]
 *      pointer to an SPTicket object. The ticket must have been
 *      charged for usage @ref SP_TICKET_RENDER.  You can pass NULL
 *      if no ticket is to be used.
 * @param ppbImage [o]
 *      pointer to a variable that will be filled with a pointer to an array of
 *      bytes containing the bitmap. The caller is responsible for deallocating
 *      that array of bytes by calling @ref SPReferenceFreeImage.
 * @param piImageLength [o]
 *      pointer to a variable that will be filled with the length (in bytes) of
 *      the bitmap returned via @a ppbImage.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   - @ref SP_MEMERR        out of memory
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPReferenceGetImage, SPReferenceFreeImage, SPSignatureGetImage, SPTemplateGetImage, SPTicketCharge
 * @see SP_TICKET_RENDER
 */
SPEXTERN SPINT32 SPLINK SPReferenceGetImage2(pSPREFERENCE_T pReference, SPDOUBLE dZoom, SPINT32 iImageFormat, SPINT32 iIndex, pSPTICKET_T pTicket, SPUCHAR **ppbImage, SPINT32 *piImageLength);

/**
 * @brief Deallocate a bitmap created by @ref SPReferenceGetImage or
 *        @ref SPReferenceGetImage2.
 * @param ppbImage [io]
 *      pointer to a variable containing a pointer to a bitmap.
 *      The bitmap must have been created by
 *      @ref SPReferenceGetImage or @ref SPReferenceGetImage2.
 *      The variable will be set to NULL if this function succeeds.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPReferenceGetImage, SPReferenceGetImage2
 */
SPEXTERN SPINT32 SPLINK SPReferenceFreeImage(SPUCHAR** ppbImage);

/**
 * @brief Get the size of an image for a signature of an SPReference object.
 *
 * The actual image might be slightly bigger than predicted by this function.
 *
 * @param pReference [i]
 *      pointer to an SPReference object.
 * @param iIndex [i]
 *      zero-based index of the signature within the reference.
 * @param piWidth [o]
 *      pointer to a variable that will be filled with the width (in pixels)
 *      of the image.
 * @param piHeight [o]
 *      pointer to a variable that will be filled with the height (in pixels)
 *      of the image.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPReferenceGetImage, SPReferenceGetImage2
 * @todo Compute the exact size of the image.
 */
SPEXTERN SPINT32 SPLINK SPReferenceGetImageSize(pSPREFERENCE_T pReference, SPINT32 iIndex, SPINT32 *piWidth, SPINT32 *piHeight);

/**
 * @brief Check a reference
 *
 * Reference plausibility check. A reference should have a min static and dynamic quality
 * and a max variance.
 *
 * @param pReference [i] pointer to an SPReferrence object.
 * @param pParams [i] Parameters, may be NULL
 *      - @ref SP_REFERENCE_MIN_SIGNATURES minimum number of signatures in reference, int, set to 0 to skip the test, default @ref SP_NUMBER_OF_SIGNATURES_FOR_REFERENCE
 *      - @ref SP_REFERENCE_MIN_DYNAMIC_QUALITY minimum dynamic quality, range 0 ... 100, int, set to 0 to skip the test, default @ref SP_MIN_REF_QUALITY_DYNAMIC
 *      - @ref SP_REFERENCE_MIN_MATCH minimum signature match, range 0 ... 100, int, set to 0 to skip the test, default @ref SP_VARIANCE_LIMIT
 *      - @ref SP_REFERENCE_MAX_DURATION maximum reference entry duration [seconds], int, set to 0 to skip the test, default 600 seconds [10 minutes]
 *      - @ref SP_REFERENCE_CHECK_SIGNATURES check all included signatures, range 0 or 1, int, set to 0 to skip the test, default 0
 *      .
 * @return int result, SP_NOERR on success, SP_INVALIDERR if check failed, else error code
 *      -  SP_PARAMERR an invalid parameter was passed
 *      .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a)
 * @see SPSignatureCheck
 */
SPEXTERN SPINT32 SPLINK SPReferenceCheck(pSPREFERENCE_T pReference, pSPPROPERTYMAP_T pParams);

#ifdef __cplusplus
};
#endif  /* __cplusplus */

#endif  /* SPREFERENCE_H__ */
