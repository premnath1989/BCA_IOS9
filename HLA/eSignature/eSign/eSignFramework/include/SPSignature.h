/*==============================================================*
 * SOFTPRO SignWare                                             *
 * ADSV developer Toolkit                                       *
 * Module: SPSignature.h                                        *
 * Created by: uko                                              *
 *                                                              *
 * @(#)SPSignature.h                           1.00 02/06/04    *
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
 * @file SPSignature.h
 * @author uko
 *
 * @brief SignWare Dynamic Development toolkit, signature object
 *
 * An SPSignature object contains a dynamic signature, ie, biometric data.
 * and information about the tablet used for capturing the signature.
 *
 * Use @ref SPSignatureCreate, @if INTERNAL @ref SPSignatureCreateFromBioData, @endif
 * @ref SPSignatureCreateFromFlatFile,
 * @ref SPSignatureCreateFromGuiAcqu, @ref SPSignatureCreateFromGuiDisp
 * @ref SPSignatureCreateFromReference, @ref SPSignatureCreateFromTablet,
 * @ref SPSignatureCreateFromTellerImage,
 * or @ref SPSignatureCreateFromTemplate
 * to create an SPSignature object.
 * 
 * If you intend to fill a signature object with data derived from
 * a customized tablet driver then please consider these rules:
 *     - Create an empty signature object (SPSignatureCreate)
 *     - Fill all device characteristics:
 *         - resolution: the capture resolution, you may resample down
 *           to 300 LPI if the device has a higher resolution
 *         - sample rate: pass the sample rate of the device, or 0 if
 *           the device does not sample at equidistant time intervals.
 *           You must pass timestamps for all vectors if the sample rate is 0
 *         - pressure levels: the number of pressure levels of the device
 *           (e. g. 2 if the device passes pen down / pen up)
 *         - Device id: a unique id of the device, Device IDs in the
 *           range from 10000 ... 11000 are for free use, however
 *           SPTabletGetDeviceStr will return "Unknown Device".
 *         .
 *     - Fill the timestamp of the signature capture process, may be the
 *       time of the first or the last stroke, the time is unix time stamp
 *       (seconds since 1.1.1970 UTC).
 *     - Optionally pass a serial id of the device
 *     - Add all vectors from the device to the signature.
 *       <br> Assure to add a zero pressure vector (to the first pen down
 *       coordinate) whenever the pen was liftet up.
 *       <br> vector data:
 *         - x the x-coordinate of the sample point, where x / res = physx [inch]
 *           from left border
 *         - y the y-coordinate of the sample point, where y / res = physy [inch]
 *           from top border
 *         - p the pressure level normalized to 1024 (p = pDevice * 1024 / PressureLevels)
 *         - t the time stamp of the vector, mseconds since start of signature capture,
 *           may be -1 if the device samples at equidistant time intervals
 *         .
 *     .
 * 
 * @note Creation of a signature object according to the above rules
 * does not necessarily imply good comparison results, the characteristics of
 * the device (resolution, sample rate, linearity, pressure levels) have
 * an important impact on the comparison quality.
 */

#ifndef SPSIGNATURE_H__
#define SPSIGNATURE_H__
#include "SPSignWare.h"

/*==============================================================*
 * Constant definitions                                         *
 *==============================================================*/
/**
 * @brief Check signature minimum width
 * @see SPSignatureCheck
 */
#define SP_SIGNATURE_MIN_WIDTH "SPSignatureMinWidth"
/**
 * @brief Check signature minimum height
 * @see SPSignatureCheck
 */
#define SP_SIGNATURE_MIN_HEIGHT "SPSignatureMinHeight"
/**
 * @brief Check signature minimum pressure levels
 * @see SPSignatureCheck
 */
#define SP_SIGNATURE_MIN_PRESSURE_LEVELS "SPSignatureMinPressureLevels"
/**
 * @brief Check signature minimum static quality
 * @see SPSignatureCheck
 */
#define SP_SIGNATURE_MIN_STATIC_QUALITY "SPSignatureMinStaticQuality"

/**
 * @brief Check the signature minimum number of vectors with pressure
 * @see SPSignatureCheck
 */
#define SP_SIGNATURE_MIN_VECTORS "SPSignatureMinVectors"
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
 * @brief Create a new SPSignature object.
 *
 * An SPSignature object created by this function does not contain
 * a signature.
 *
 * @param ppSignature [o]
 *      pointer to a variable that will be filled with a pointer to
 *      a new SPSignature object.  The caller is responsible for
 *      deallocating the new object by calling @ref SPSignatureFree.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   - @ref SP_MEMERR        out of memory
 *   .
 * @see SPSignatureCreateFromReference , SPSignatureCreateFromTablet
 * @see SPSignatureFree
 */
SPEXTERN SPINT32 SPLINK SPSignatureCreate(pSPSIGNATURE_T *ppSignature);

/**
 * @brief Create a copy of an SPSignature object.
 *
 * @param pSignature [i]
 *      pointer to the SPSignature object to be copied.
 * @param ppSignature [o]
 *      pointer to a variable that will be filled with a pointer to
 *      a new SPSignature object.  The caller is responsible for
 *      deallocating the new object by calling @ref SPSignatureFree.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   - @ref SP_MEMERR        out of memory
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureCreate, SPSignatureFree
 */
SPEXTERN SPINT32 SPLINK SPSignatureClone(pSPSIGNATURE_T pSignature, pSPSIGNATURE_T *ppSignature);

/**
 * @brief Create a new SPSignature object using device parameters of
 *        an SPTablet object.
 *
 * These device-specific parameters of the SPSignature object will be
 * initialized with properties of the tablet:
 *   - device ID
 *   - resolution
 *   - sample rate
 *   - maximum pressure value
 *   - timestamp
 *   .
 * However, the SPSignature object won't contain a signature.
 *
 * @param ppSignature [o]
 *      pointer to a variable that will be filled with a pointer to
 *      a new SPSignature object.  The caller is responsible for
 *      deallocating the new object by calling @ref SPSignatureFree.
 * @param pTablet [i]
 *      pointer to an SPTablet object.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   - @ref SP_MEMERR        out of memory
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPSignatureCreate, SPSignatureFree
 */
SPEXTERN SPINT32 SPLINK SPSignatureCreateFromTablet(pSPSIGNATURE_T *ppSignature, pSPTABLET_T pTablet);

/**
 * @brief Create a new SPSignature object from a signature of
 *        an SPReference object.
 *
 * @param ppSignature [o]
 *      pointer to a variable that will be filled with a pointer to
 *      a new SPSignature object.  The caller is responsible for
 *      deallocating the new object by calling @ref SPSignatureFree.
 * @param pReference [i]
 *      pointer to an SPReference object.
 * @param iIndex [i]
 *      zero-based index of the signature within the reference.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   - @ref SP_MEMERR        out of memory
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureCreate, SPSignatureFree, SPReferenceAddSignature
 */
SPEXTERN SPINT32 SPLINK SPSignatureCreateFromReference(pSPSIGNATURE_T *ppSignature, pSPREFERENCE_T pReference, SPINT32 iIndex);

/**
 * @brief Create a new SPSignature object from a an SPTemplate object.
 *
 * @param ppSignature [o]
 *      pointer to a variable that will be filled with a pointer to
 *      a new SPSignature object.  The caller is responsible for
 *      deallocating the new object by calling @ref SPSignatureFree.
 * @param pTemplate [i]
 *      pointer to an SPTemplate object.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   - @ref SP_MEMERR        out of memory
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureCreate, SPSignatureFree, SPTemplateCreateFromReference, SPTemplateGetSignature
 */
SPEXTERN SPINT32 SPLINK SPSignatureCreateFromTemplate(pSPSIGNATURE_T *ppSignature, pSPTEMPLATE_T pTemplate);

/**
 * @brief Create a new SPSignature object from a flat file object.
 *
 * This function deserializes an SPSignature object serialized by
 * @ref SPFlatFileCreateFromSignature.
 *
 * @param ppSignature [o]
 *      pointer to a variable that will be filled with a pointer to
 *      a new SPSignature object.  The caller is responsible for
 *      deallocating the new object by calling @ref SPSignatureFree.
 * @param pbFlatFile [i]
 *      pointer to an array of bytes containing a serialized SPSignature
 *      object.
 * @param iFlatFileLength [i]
 *      length (in bytes) of the serialized data pointed to by @a pbFlatFile.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   - @ref SP_MEMERR        out of memory
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureCreate, SPSignatureFree, SPFlatFileCreateFromSignature
 */
SPEXTERN SPINT32 SPLINK SPSignatureCreateFromFlatFile(pSPSIGNATURE_T *ppSignature, const SPUCHAR *pbFlatFile, SPINT32 iFlatFileLength);

/**
 * @brief Get the signature during acquiry mode.
 *
 * The returned SPSignature object may not contain all vectors captured
 * so far. This function is provided to check for empty signatures
 * @em before accepting the signature (see @ref SPGuiAcquAcquireDone).
 * Modifying the SPSignature object won't have an effect on the
 * signature being captured.
 *
 * This function behaves exactly like @ref SPGuiAcquGetSignature.
 *
 * @param ppSignature [o]
 *      pointer to a variable that will be filled with a pointer to
 *      a new SPSignature object.  The caller is responsible for
 *      deallocating the new object by calling @ref SPSignatureFree.
 * @param pSPGuiAcqu [i]
 *      pointer to an SPGuiAcqu object.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_MEMERR        out of memory
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPSignatureCreate, SPSignatureFree, SPGuiAcquGetSignature
 */
SPEXTERN SPINT32 SPLINK SPSignatureCreateFromGuiAcqu(pSPSIGNATURE_T *ppSignature, pSPGUIACQU_T pSPGuiAcqu);

/**
 * @brief Get the signature during acquiry mode.
 *
 * The returned SPSignature object may not contain all vectors captured
 * so far. This function is provided to check for empty signatures
 * @em before accepting the signature (see @ref SPGuiAcquAcquireDone).
 * Modifying the SPSignature object won't have an effect on the
 * signature being captured.
 *
 * This function behaves exactly like @ref SPGuiAcquGetSignature.
 *
 * @param ppSignature [o]
 *      pointer to a variable that will be filled with a pointer to
 *      a new SPSignature object.  The caller is responsible for
 *      deallocating the new object by calling @ref SPSignatureFree.
 * @param pSPAcquire [i]
 *      pointer to an SPAcquire object.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_MEMERR        out of memory
 *     .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM)
 * @see SPSignatureCreate, SPSignatureFree, SPAcquireGetSignature
 */
SPEXTERN SPINT32 SPLINK SPSignatureCreateFromAcquire(pSPSIGNATURE_T *ppSignature, pSPACQUIRE_T pSPAcquire);

/**
 * @brief Create a new SPSignature object from an SPGuiDisp object.
 *
 * @param ppSignature [o]
 *      pointer to a variable that will be filled with a pointer to
 *      a new SPSignature object.  The caller is responsible for
 *      deallocating the new object by calling @ref SPSignatureFree.
 * @param pSPGuiDisp [i]
 *      pointer to an SPGuiDisp object.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_UNSUPPORTEDERR  the SPGuiDisp object does not contain a signature
 *     .
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPSignatureCreate, SPSignatureFree, SPGuiDispGetSignature
 */
SPEXTERN SPINT32 SPLINK SPSignatureCreateFromGuiDisp(pSPSIGNATURE_T *ppSignature, pSPGUIDISP_T pSPGuiDisp);

/**
 * @brief Create an SPSignature object from an SPTellerImage object.
 *
 * @param ppSignature [o]
 *      pointer to a variable that will be filled with a pointer to
 *      a new SPSignature object.  The caller is responsible for
 *      deallocating the new object by calling @ref SPSignatureFree.
 * @param pTellerImage [i]
 *      pointer to an SPTellerImage object.
 * @return @ref SP_NOERR on success, else error code:
 *     - @ref SP_PARAMERR      invalid parameter
 *     - @ref SP_MEMERR        out of memory
 *     .
 * @par Operating Systems:
 *      Windows (Win32)
 * @see SPSignatureCreate, SPSignatureFree, SPTellerImageCreateFromSignature
 */
SPEXTERN SPINT32 SPLINK SPSignatureCreateFromTellerImage(pSPSIGNATURE_T *ppSignature, pSPTELLERIMAGE_T pTellerImage);

/**
 * @brief Deallocate an SPSignature object.
 *
 * The SPSignature object must have been created by @ref SPSignatureClone,
 * @ref SPSignatureCreate, @if INTERNAL @ref SPSignatureCreateFromBioData, @endif
 * @ref SPSignatureCreateFromFlatFile,
 * @ref SPSignatureCreateFromGuiAcqu, @ref SPSignatureCreateFromGuiDisp
 * @ref SPSignatureCreateFromReference, @ref SPSignatureCreateFromTablet,
 * @ref SPSignatureCreateFromTellerImage, @ref SPSignatureCreateFromTemplate,
 * or @ref SPGuiDispGetSignature.
 *
 * @param ppSignature [io]
 *      pointer to a variable containing a pointer to an SPSignature
 *      object.
 *      The variable will be set to NULL if this function succeeds.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureClone, SPSignatureCreate
 */
SPEXTERN SPINT32 SPLINK SPSignatureFree(pSPSIGNATURE_T *ppSignature);

/**
 * @brief Get the tablet device ID from an SPSignature object.
 *
 * @param pSignature [i]
 *      pointer to an SPSignature object.
 * @param piDevice [o]
 *      pointer to a variable that will be filled with the device ID
 *      from the SPSignature object.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureCreateFromTablet, SPSignatureSetDevice
 */
SPEXTERN SPINT32 SPLINK SPSignatureGetDevice(pSPSIGNATURE_T pSignature, SPINT32 *piDevice);

/**
 * @brief Set the tablet device ID of an SPSignature object.
 *
 * You should not overwrite the device ID unless you know what you
 * are doing.
 *
 * @param pSignature [i] pointer to an SPSignature object.
 * @param iDevice [i]    new tablet device ID.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureCreateFromTablet, SPSignatureGetDevice
 */
SPEXTERN SPINT32 SPLINK SPSignatureSetDevice(pSPSIGNATURE_T pSignature, SPINT32 iDevice);

/**
 * @brief Get the resolution of an SPSignature object.
 *
 * @param pSignature [i]
 *      pointer to an SPSignature object.
 * @param piResolution [o]
 *      pointer to a variable that will be filled with the
 *      resolution (in DPI) of the signature contained in the
 *      SPSignature object.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureCreateFromTablet, SPSignatureSetResolution
 */
SPEXTERN SPINT32 SPLINK SPSignatureGetResolution(pSPSIGNATURE_T pSignature, SPINT32 *piResolution);

/**
 * @brief Set the resolution of an SPIgnature object.
 *
 * This function just changes the resolution attribut of the signature,
 * the signature will not be resampled to the new resolution.
 *
 * You should not overwrite the resolution unless you know what
 * you are doing.
 *
 * @param pSignature [i]  pointer to an SPSignature object.
 * @param iResolution [i] new resolution (in DPI).
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureCreateFromTablet, SPSignatureGetResolution
 */
SPEXTERN SPINT32 SPLINK SPSignatureSetResolution(pSPSIGNATURE_T pSignature, SPINT32 iResolution);

/**
 * @brief Get the sample rate of an SPSignature object.
 *
 * @param pSignature [i]
 *      pointer to an SPSignature object.
 * @param piSampleRate [o]
 *      pointer to a variable that will be filled with the
 *      sample rate (in samples per second) of the signature contained
 *      in the SPSignature object.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureCreateFromTablet, SPSignatureSetResolution
 */
SPEXTERN SPINT32 SPLINK SPSignatureGetSampleRate(pSPSIGNATURE_T pSignature, SPINT32 *piSampleRate);

/**
 * @brief Set the sample rate of an SPSignature object.
 *
 * This function just changes the sample rate attribut of the signature,
 * the signature will not be resampled to the new sample rate.
 *
 * This function is provided to overwrite the sample rate when using Wacom
 * tablets.
 * Wacom tablets always return a sample rate of 100 Hz though the real
 * sample rate may differ. @ref SPTabletAcquireDone attempts to
 * compute the real sample rate; you should set the sample rate of
 * the captured signature to the computed sample rate
 * (see @ref SPTabletGetSampleRate). @ref SPGuiAcquAcquireDone does
 * this automatically.
 *
 * @param pSignature [i]  pointer to an SPSignature object.
 * @param iSampleRate [i] new sample rate (in samples per second).
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureCreateFromTablet, SPSignatureGetSampleRate, SPTabletGetSampleRate, SPTabletAcquireDone
 */
SPEXTERN SPINT32 SPLINK SPSignatureSetSampleRate(pSPSIGNATURE_T pSignature, SPINT32 iSampleRate);

/**
 * @brief Get the pressure range of an SPSignature object.
 *
 * The maximum pressure is read from the capabilities of the tablet used
 * for capturing the signature. The pressure values of the signature data
 * are normalized to the range 0 through 1023.
 *
 * @param pSignature [i]
 *      pointer to an SPSignature object.
 * @param piMaxPressure [o]
 *      pointer to a variable that will be filled with the maximum
 *      pressure value of the tablet used for capturing the signature
 *      stored in the SPSignature object.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureCreateFromTablet, SPSignatureSetMaxPressure
 */
SPEXTERN SPINT32 SPLINK SPSignatureGetMaxPressure(pSPSIGNATURE_T pSignature, SPINT32 *piMaxPressure);

/**
 * @brief Set the pressure range of an SPSignature object.
 *
 * You should not overwrite the maximum pressure unless you know what
 * you are doing.
 *
 * @param pSignature [i]   pointer to an SPSignature object.
 * @param iMaxPressure [i] new maximum pressure value.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureCreateFromTablet, SPSignatureGetMaxPressure
 */
SPEXTERN SPINT32 SPLINK SPSignatureSetMaxPressure(pSPSIGNATURE_T pSignature, SPINT32 iMaxPressure);

/**
 * @brief Get the timestamp of an SPSignature object.
 *
 * @param pSignature [i]
 *      pointer to an SPSignature object.
 * @param puTimeStamp [o]
 *      pointer to a variable that will be filled with the timestamp
 *      (seconds since 1970-01-01 00:00:00 UTC)
 *      of the signature contained in the SPSignature object.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureCreateFromTablet, SPSignatureSetTimeStamp, SPSignwareGetCurrentTime
 */
SPEXTERN SPINT32 SPLINK SPSignatureGetTimeStamp(pSPSIGNATURE_T pSignature, SPUINT32 *puTimeStamp);

/**
 * @brief Set the timestamp of an SPSignature object.
 *
 * This function is provided to add a timestamp to a signature.
 *
 * @param pSignature [i]
 *      pointer to an SPSignature object.
 * @param uTimeStamp [i]
 *      new timestamp (seconds since 1970-01-01 00:00:00 UTC) for the
 *      signature.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureCreateFromTablet, SPTabletGetTimeStamp, SPSignwareGetCurrentTime
 */
SPEXTERN SPINT32 SPLINK SPSignatureSetTimeStamp(pSPSIGNATURE_T pSignature, SPUINT32 uTimeStamp);

/**
 * @brief Get the tablet serial ID of an SPSignature object.
 *
 * This function is provided for future use, currently no tablets
 * support tablet serial ID's.
 *
 * The size of a tablet serial ID is limited to 20 bytes.
 *
 * @param pSignature [i]
 *      pointer to an SPSignature object.
 * @param pbPadSerial [o]
 *      pointer to an array of bytes that will be filled with the serial
 *      ID of the tablet used to capture the signature contained in the
 *      SPSignature object.
 * @param piPadSerialLength [io]
 *      pointer to a variable that contains the size (in bytes) of the
 *      buffer pointed to by @a pbPadSerial. That variable will be filled
 *      with the number of bytes written to the buffer.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureCreateFromTablet, SPTabletGetPadSerial
 */
SPEXTERN SPINT32 SPLINK SPSignatureGetPadSerial(pSPSIGNATURE_T pSignature, SPUCHAR *pbPadSerial, SPINT32 *piPadSerialLength);

/**
 * @brief Set the tablet serial ID of an SPSignature object.
 *
 * This function is provided for future use, currently no tablets
 * support tablet serial ID's.
 *
 * The size of a tablet serial ID is limited to 20 bytes.
 *
 * @param pSignature [i]
 *      pointer to an SPSignature object.
 * @param pbPadSerial [i]
 *      pointer to an array of bytes that contains the tablet serial ID.
 * @param iPadSerialLength [i]
 *      the size (in bytes) of the tablet serial ID pointed to by
 *      @a pbPadSerial.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureSetPadSerial, SPTabletGetPadSerial
 */
SPEXTERN SPINT32 SPLINK SPSignatureSetPadSerial(pSPSIGNATURE_T pSignature, const SPUCHAR *pbPadSerial, SPINT32 iPadSerialLength);

/**
 * @brief Add a tablet vector (sample) to an SPSignature object.
 *
 * @param pSignature [i]
 *      pointer to an SPSignature object.
 * @param iX [i]
 *      X value (in tablet coordinates) of the sample.
 * @param iY [i]
 *      Y value (in tablet coordinates) of the sample.
 * @param iPress [i]
 *      pressure value of the sample, normalized to the range 0 through 1023,
 *      independent of the maximum pressure value of the tablet used to
 *      capture the signature.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   - @ref SP_MEMERR        out of memory
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureGetVector, SPSignatureGetNrVectors
 */
SPEXTERN SPINT32 SPLINK SPSignatureAddVector(pSPSIGNATURE_T pSignature, SPINT32 iX, SPINT32 iY, SPINT32 iPress);

/**
 * @brief Add a tablet vector (sample) to an SPSignature object.
 *
 * @param pSignature [i]
 *      pointer to an SPSignature object.
 * @param iX [i]
 *      X value (in tablet coordinates) of the sample.
 * @param iY [i]
 *      Y value (in tablet coordinates) of the sample.
 * @param iPress [i]
 *      pressure value of the sample, normalized to the range 0 through 1023,
 *      independent of the maximum pressure value of the tablet used to
 *      capture the signature.
 * @param iTime [i]
 *      Time stamp of the vector in milli seconds since start capturing the signature.
 *      <br> may be -1 to indicate that timestamps are not supported for this device
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   - @ref SP_MEMERR        out of memory
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureGetVector, SPSignatureGetNrVectors
 */
SPEXTERN SPINT32 SPLINK SPSignatureAddVector2(pSPSIGNATURE_T pSignature, SPINT32 iX, SPINT32 iY, SPINT32 iPress, SPINT32 iTime);

/**
 * @brief Get the number of tablet vectors (samples) contained in an
 *        SPSignature object.
 *
 * @param pSignature [i]
 *      pointer to an SPSignature object.
 * @param piNrVectors [o]
 *      pointer to a variable that will be filled with the number of
 *      tablet vectors (samples) in the signature contained in the
 *      SPSignature object.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureAddVector, SPSignatureAddVector2, SPSignatureGetVector, SPSignatureGetVector2
 */
SPEXTERN SPINT32 SPLINK SPSignatureGetNrVectors(pSPSIGNATURE_T pSignature, SPINT32 *piNrVectors);

/**
 * @brief Get the values of a tablet vector (sample) contained in
 *        an SPSignature object.
 *
 * @param pSignature [i]
 *      pointer to an SPSignature object.
 * @param iIndex [i]
 *      Zero-based index of the requested tablet vector (sample).
 * @param piX [o]
 *      pointer to a variable that will be filled with the X value
 *      (in tablet coordinates) of the specified sample.
 * @param piY [o]
 *      pointer to a variable that will be filled with the Y value
 *      (in tablet coordinates) of the specified sample.
 * @param piPress [o]
 *      pointer to a variable that will be filled with the pressure value
 *      (normalized to 0 through 1023) of the specified sample.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureAddVector, SPSignatureGetNrVectors
 */
SPEXTERN SPINT32 SPLINK SPSignatureGetVector(pSPSIGNATURE_T pSignature, SPINT32 iIndex, SPINT32 *piX, SPINT32 *piY, SPINT32 *piPress);

/**
 * @brief Get the values of a tablet vector (sample) contained in
 *        an SPSignature object.
 *
 * @param pSignature [i]
 *      pointer to an SPSignature object.
 * @param iIndex [i]
 *      Zero-based index of the requested tablet vector (sample).
 * @param piX [o]
 *      pointer to a variable that will be filled with the X value
 *      (in tablet coordinates) of the specified sample.
 * @param piY [o]
 *      pointer to a variable that will be filled with the Y value
 *      (in tablet coordinates) of the specified sample.
 * @param piPress [o]
 *      pointer to a variable that will be filled with the pressure value
 *      (normalized to 0 through 1023) of the specified sample.
 * @param piTime [o]
 *      pointer to a variable that will be filled with the relative time of the 
 *      vector in milliseconds since signature capture start, may be -1 if
 *      the capture device did not support time stamps, or timestamps were not saved
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureAddVector2, SPSignatureGetNrVectors
 */
SPEXTERN SPINT32 SPLINK SPSignatureGetVector2(pSPSIGNATURE_T pSignature, SPINT32 iIndex, SPINT32 *piX, SPINT32 *piY, SPINT32 *piPress, SPINT32 *piTime);

/**
 * @brief Remove all tablet vectors (samples) from an SPSignature object.
 *
 * @param pSignature [i] pointer to an SPSignature object.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 */
SPEXTERN SPINT32 SPLINK SPSignatureClearVectors(pSPSIGNATURE_T pSignature);

/**
 * @brief Get the complexity of an SPSignature object.
 *
 * @param pSignature [i]
 *      pointer to an SPSignature object.
 * @param piComplexity [o]
 *      pointer to a variable that will be filled with the calculated
 *      complexity of the signature
 *      The complexity has a range of 0 .. 100, where 0 equals a most simple
 *      signature.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a)
 *
 * @since Version 3.2.2
 */
SPEXTERN SPINT32 SPLINK SPSignatureGetComplexity(pSPSIGNATURE_T pSignature, SPINT32 *piComplexity);

/**
 * @brief Create a bitmap from the signature contained in an SPSignature
 *        object.
 *
 * There is no inverse function for SPSignatureGetImage because the
 * created image represents a static signature and does not contain
 * dynamic (biometric) features.
 *
 * @note This is a license-restricted function. Please pass a charged ticket
 *       when using a ticket license model, see @ref SPSignwareSetTicket
 *       and @ref SPSignatureSetTicket.
 *       The ticket must be charged for action @ref SP_TICKET_RENDER.
 *  
 * @note The created image is a BW or gray image. Please use 
 *       SPImageSetSignature and SPImageSetBitsPerPixel2 to
 *       convert the image to a color image.
 *
 * @warning the resolution of the resulting image is limited to 300 DPI. If
 *				a higher resolution than 300 DPI is required, use
 *				@ref SPSignatureGetImageWithDPI
 *  
 * @param pSignature [i]
 *      pointer to an SPSignature object.
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
 * @param ppbImage [o]
 *      pointer to a variable that will be filled with a pointer to an array of
 *      bytes containing the bitmap. The caller is responsible for deallocating
 *      that array of bytes by calling @ref SPSignatureFreeImage.
 * @param piImageLength [o]
 *      pointer to a variable that will be filled with the length (in bytes) of
 *      the bitmap returned via @a ppbImage.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   - @ref SP_MEMERR        out of memory
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureFreeImage, SPSignatureGetImageSize, SPSignatureSetStaticPenWidth, 
 *      SPSignatureSetStaticGrayAlias 
 */
SPEXTERN SPINT32 SPLINK SPSignatureGetImage(pSPSIGNATURE_T pSignature, SPDOUBLE dZoom, SPINT32 iImageFormat, SPUCHAR** ppbImage, SPINT32 *piImageLength);

/**
 * @brief Create a bitmap from the signature contained in an SPSignature
 *        object with a certain resolution.
 *
 * There is no inverse function for SPSignatureGetImage because the
 * created image represents a static signature and does not contain
 * dynamic (biometric) features.
 *
 * @note This is a license-restricted function. Please pass a charged ticket
 *       when using a ticket license model, see @ref SPSignwareSetTicket
 *       and @ref SPSignatureSetTicket.
 *       The ticket must be charged for action @ref SP_TICKET_RENDER.
 *
 * @note The created image is a BW or gray image. Please use
 *       SPImageSetSignature and SPImageSetBitsPerPixel2 to
 *       convert the image to a color image.
 *
 * @note The result image may have a slightly different resolution
 *
 * @param pSignature [i]
 *      pointer to an SPSignature object.
 * @param dDPI [i]
 *      resolution in DPI (must be positive).
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
 * @param ppbImage [o]
 *      pointer to a variable that will be filled with a pointer to an array of
 *      bytes containing the bitmap. The caller is responsible for deallocating
 *      that array of bytes by calling @ref SPSignatureFreeImage.
 * @param piImageLength [o]
 *      pointer to a variable that will be filled with the length (in bytes) of
 *      the bitmap returned via @a ppbImage.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   - @ref SP_MEMERR        out of memory
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureGetImage, SPSignatureFreeImage, SPSignatureGetImageSize, SPSignatureSetStaticPenWidth,
 *      SPSignatureSetStaticGrayAlias
 */
SPEXTERN SPINT32 SPLINK SPSignatureGetImageWithDPI(pSPSIGNATURE_T pSignature, SPDOUBLE dDPI, SPINT32 iImageFormat, SPUCHAR** ppbImage, SPINT32 *piImageLength);

/**
 * @brief Deallocate a bitmap created by @ref SPSignatureGetImage.
 *
 * @param ppImage [io]
 *      pointer to a variable containing a pointer to a bitmap.
 *      The bitmap must have been created by @ref SPSignatureGetImage.
 *      The variable will be set to NULL if this function succeeds.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureGetImage
 */
SPEXTERN SPINT32 SPLINK SPSignatureFreeImage(SPUCHAR** ppImage);

/**
 * @brief Pass a license ticket to an SPSignature object to enable rendering.
 *
 * When using a ticket license, you must pass at least one ticket
 * charged for action @ref SP_TICKET_RENDER if you want to convert
 * a dynamic signature to a static image.
 * This function copies the SPTicket object.
 *
 * @deprecated Please use a license key.
 *
 * @param pSignature [i]
 *      pointer to an SPSignature object.
 * @param pTicket [i]
 *      pointer to an SPTicket object.  The ticket must have been charged
 *      for action @ref SP_TICKET_RENDER.
 * @return @ref SP_NOERR on success, else error code.
 * @deprecated Replaced by @ref SPSignwareSetTicket.
 *
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a)
 * @see SPSignatureGetImage, SPSignwareSetTicket, SP_TICKET_RENDER
 */
SPEXTERN SPINT32 SPLINK SPSignatureSetTicket(pSPSIGNATURE_T pSignature, pSPTICKET_T pTicket);

/**
 * @brief Get the size of an image for the signature contained in
 *        an SPReference object.
 *
 * The actual image might be slightly bigger than predicted by this function.
 *
 * @param pSignature [i]
 *      pointer to an SPSignature object.
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
 * @see SPSignatureGetImage
 * @todo Compute the exact size of the image.
 */
SPEXTERN SPINT32 SPLINK SPSignatureGetImageSize(pSPSIGNATURE_T pSignature, SPINT32 *piWidth, SPINT32 *piHeight);

/**
 * @brief Set the width of the pen used by an SPSignature object.
 *
 * The pen is used for creating a static image from the signature contained
 * in the SPSignature object.
 *
 * By default, the width of the pen is 0.5mm.
 *
 * @param pSignature [i] pointer to an SPSignature object.
 * @param dWidth [i]     pen width in mm
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureGetImage
 */
SPEXTERN SPINT32 SPLINK SPSignatureSetStaticPenWidth(pSPSIGNATURE_T pSignature, SPDOUBLE dWidth);

/**
 * @brief Calculate gray levels in a static signature either from pressure 
 * levels of the vectors or from aliasing.
 *
 * By default, the gray level is based on the pressure level of a vector.
 *
 * @param pSignature [i] pointer to an SPSignature object.
 * @param bGrayAlias [i] SPTRUE: calculate the gray level from aliasing, else 
 *                       calculate the gray level from the pressure. 
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a), Darwin (x86_64)
 * @see SPSignatureGetImage
 *  
 * @since Version 3.0 
 */
SPEXTERN SPINT32 SPLINK SPSignatureSetStaticGrayAlias(pSPSIGNATURE_T pSignature, SPBOOL bGrayAlias);

/**
 * @brief Check a signature
 *
 * Signature plausibility check. A signature should exceed a certain size and contain
 * a pressure level range.
 *
 * @param pSignature [i] pointer to an SPSignature object.
 * @param pParams [i] Parameters, may be NULL
 *      - @ref SP_SIGNATURE_MIN_WIDTH minimum width [in mm], set to 0 to skip the test, int, default 10 [mm]
 *      - @ref SP_SIGNATURE_MIN_HEIGHT minimum height [in mm], set to 0 to skip the test, int, default 5 [mm]
 *      - @ref SP_SIGNATURE_MIN_PRESSURE_LEVELS minimum number of pressure levels in the signature, range 0 ... 100 [%], int, set to 0 to skip the test, default 5 %
 *      - @ref SP_SIGNATURE_MIN_STATIC_QUALITY minimum static quality, range 0 ... 100, int, set to 0 to skip the test, default @ref SP_MIN_REF_QUALITY_STATIC
 *      - @ref SP_SIGNATURE_MIN_VECTORS minimum number of vectors (with pressure > 0), set to 0 to skip the test, int, default 10
 * @return int result, SP_NOERR on success, SP_INVALIDERR if check failed, else error code
 *      -  SP_PARAMERR an invalid parameter was passed
 *      .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a)
 * @see SPReferenceCheck
 *
 */
SPEXTERN SPINT32 SPLINK SPSignatureCheck(pSPSIGNATURE_T pSignature, pSPPROPERTYMAP_T pParams);

/** @cond INTERNAL */
/**
 * @brief Create an SPSignature object from biometric data.
 *
 * @param ppSignature [o]
 *      pointer to a variable that will be filled with a pointer to
 *      a new SPSignature object.  The caller is responsible for
 *      deallocating the new object by calling @ref SPSignatureFree.
 * @param pbBioData [i]
 *      pointer to an array of bytes containing biometric data.
 * @param iBioDataLength [i]
 *      length (in bytes) of array of bytes pointed to by @a pbBioData.
 * @return @ref SP_NOERR on success, else error code:
 *   - @ref SP_PARAMERR      invalid parameter
 *   - @ref SP_MEMERR        Out of memory
 *   .
 * @par Operating Systems:
 *      Windows (Win32), Linux (i386), Linux (x86_64), Linux (ARM), Android (ARMv7a)
 * @see SPSignatureFree
 */
SPEXTERN SPINT32 SPLINK SPSignatureCreateFromBioData(pSPSIGNATURE_T *ppSignature, const SPUCHAR *pbBioData, SPINT32 iBioDataLength);
/** @endcond */

#ifdef __cplusplus
};
#endif  /* __cplusplus */

#endif  /* SPSIGNATURE_H__ */
