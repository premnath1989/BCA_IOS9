/*=============================================== -*- C++ -*- ==*
 * SOFTPRO SignDoc                                              *
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
 * @file SignDocSDK-cpp.h
 * @author ema
 *
 * @brief Class SignDocDocument and friends.
 *
 * This header contains the definition of class SignDocDocument and
 * related classes.
 */

#ifndef SP_SIGNDOCSDK_CPP_H__
#define SP_SIGNDOCSDK_CPP_H__

#include <stddef.h>
#include <memory>
#include <string>
#include <vector>
#include <stdexcept>
#include "SignDocSDK-c.h"

#ifndef SIGNDOC_PTR
/**
 * @brief The smart pointer type used by SignDoc SDK.
 *
 * If you are using C++11 or later, you can redefine this macro to
 * std::unique_ptr or std::shared_ptr before including
 * SignDocSDK-cpp.h.
 */
#define SIGNDOC_PTR std::auto_ptr
#endif

struct SPPDF_Document;

namespace de { namespace softpro { namespace doc {

class SignDocVerificationResult;
class SignPKCS7;
class SPFontCache;

#ifdef _MSC_VER
#pragma warning(push)
// C4800: forcing value to bool 'true' or 'false' (performance warning)
#pragma warning(disable:4800)
#endif

/**
 * @brief Internal function.
 * @internal
 */
inline void
SignDoc_throw (SIGNDOC_Exception *aEx)
{
  int type = SIGNDOC_Exception_getType (aEx);
  if (type == SIGNDOC_EXCEPTION_TYPE_BAD_ALLOC)
    throw (std::bad_alloc ());
  std::string msg;
  const char *text = SIGNDOC_Exception_getText (aEx);
  if (text != NULL)
    msg = text;
  SIGNDOC_Exception_delete (aEx);
#if defined (SPOOC_EXCEPTION_H__)
  switch (type)
    {
    case SIGNDOC_EXCEPTION_TYPE_SPOOC_IO:
      throw de::softpro::spooc::IOError (msg);
    case SIGNDOC_EXCEPTION_TYPE_SPOOC_ENCODING_ERROR:
      throw de::softpro::spooc::EncodingError (msg);
    case SIGNDOC_EXCEPTION_TYPE_SPOOC_GENERIC:
      throw de::softpro::spooc::Exception (msg);
    default:
      throw std::runtime_error (msg);
    }
#else
  throw std::runtime_error (msg);
#endif
}

/**
 * @brief Internal function.
 * @internal
 */
inline void
SIGNDOC_catch (SIGNDOC_Exception **aEx, std::exception &aInput)
{
  *aEx = SIGNDOC_Exception_new (SIGNDOC_EXCEPTION_TYPE_GENERIC,
                                aInput.what ());
}

/**
 * @brief Internal function.
 * @internal
 */
inline SignDocVerificationResult *
makeSignDocVerificationResult (SIGNDOC_VerificationResult *aP);

inline void assignArray (std::vector<unsigned char> &aDst,
                         SIGNDOC_ByteArray *aSrc)
{
  unsigned n = 0;
  if (aSrc != NULL)
    n = SIGNDOC_ByteArray_count (aSrc);
  if (n == 0)
    aDst.clear ();
  else
    {
      const unsigned char *p = SIGNDOC_ByteArray_data (aSrc);
      aDst.assign (p, p + n);
    }
}

/**
 * @brief Internal function.
 * @internal
 */
inline void assignArray (std::vector<std::vector<unsigned char> > &aDst,
                         SIGNDOC_ByteArrayArray *aSrc)
{
  unsigned n = SIGNDOC_ByteArrayArray_count (aSrc);
  aDst.resize (n);
  for (unsigned i = 0; i < n; ++i)
    assignArray (aDst[i], SIGNDOC_ByteArrayArray_at (aSrc, i));
}

/**
 * @brief Internal function.
 * @internal
 */
inline void assignArray (std::vector<std::string> &aDst,
                         SIGNDOC_StringArray *aSrc)
{
  unsigned n = SIGNDOC_StringArray_count (aSrc);
  aDst.resize (n);
  for (unsigned i = 0; i < n; ++i)
    aDst[i] = SIGNDOC_StringArray_at (aSrc, i);
}

//----------------------------------------------------------------------------

/**
 * @brief Interface for an input stream, inspired by Java's
 *        java.io.InputStream.
 *
 * If you want to implement your own InputStream implementation,
 * derive your class from UserInputStream.
 */
class InputStream
{
public:
  /**
   * @brief Constructor.
   *
   * @param[in] aImpl   A pointer to the C structure.
   */
  InputStream (SIGNDOC_InputStream *aImpl) : p (aImpl) { }

  /**
   * @brief Destructor.
   */
  virtual ~InputStream ()
  {
    SIGNDOC_InputStream_delete (p);
  }

  /**
   * @brief Read octets from source.
   *
   * Implementations of this class may define exceptions thrown
   * by this function.
   *
   * Once this function has returned a value smaller than
   * @a aLen, end of input has been reached and further calls
   * should return 0.
   *
   * @param[out] aDst  Pointer to buffer to be filled.
   * @param[in] aLen   Number of octets to read.
   *
   * @return The number of octets read.
   */
  virtual int read (void *aDst, int aLen) = 0;

  /**
   * @brief Close the stream.
   *
   * Implementations of this class may define exceptions thrown
   * by this function.
   */
  virtual void close () = 0;

  /**
   * @brief Seek to the specified position (int).
   *
   * Throws an exception if the position is invalid or if seeking is
   * not supported.
   *
   * @param[in] aPos  The position (zero being the first octet).
   */
  virtual void seek (int aPos) = 0;

  /**
   * @brief Retrieve the current position (int).
   *
   * Throws an exception if the position cannot represented as
   * non-negative int or if seeking is not supported.
   *
   * @return The current position (zero being the first octet)
   */
  virtual int tell () const = 0;

  /**
   * @brief Get an estimate of the number of octets available for reading.
   *
   * Throws an exception if this function is not supported.
   *
   * @note There may be more octets available than reported by this
   *       function, but never less.  If there is at least one octet
   *       available for reading, the return value must be at least one.
   *       (That is, always returning zero is not possible.)
   *
   * @return The minimum number of octets available for reading.
   */
  virtual int getAvailable () = 0;

  /**
   * @brief Internal.
   * @internal
   */
  SIGNDOC_InputStream *getImpl () { return p; }

protected:
  /**
   * @brief Pointer to C structure.
   */
  SIGNDOC_InputStream *p;

private:
  /**
   * @brief Copy constructor (unavailable).
   */
  InputStream (const InputStream &);

  /**
   * @brief Assignment operator (unavailable).
   */
  InputStream &operator= (const InputStream &);
};

/**
 * @brief Base class for InputStream implementations by user code.
 *
 * Any exception object thrown must be derived from std::exception.
 */
class UserInputStream : public InputStream
{
public:
  /**
   * @brief Default constructor.
   */
  UserInputStream ()
    : InputStream (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_UserInputStream_new (&ex, this,
                                     closeC, readC, seekC, tellC,
                                     getAvailableC);
    if (ex != NULL) SignDoc_throw (ex);
  }

private:
  /**
   * @brief Internal helper function: static function called from C code.
   */
  static void SDCAPI closeC (SIGNDOC_Exception **aEx,
                             void *aClosure)
  {
    *aEx = NULL;
    try
      {
        reinterpret_cast<UserInputStream*>(aClosure)->close ();
      }
    catch (std::exception &e)
      {
        SIGNDOC_catch (aEx, e);
      }
  }

  /**
   * @brief Internal helper function: static function called from C code.
   */
  static int SDCAPI readC (SIGNDOC_Exception **aEx,
                           void *aClosure,
                           void *aDst, int aLen)
  {
    *aEx = NULL;
    try
      {
        return reinterpret_cast<UserInputStream*>(aClosure)->read (aDst, aLen);
      }
    catch (std::exception &e)
      {
        SIGNDOC_catch (aEx, e);
        return 0;
      }
  }

  /**
   * @brief Internal helper function: static function called from C code.
   */
  static void SDCAPI seekC (SIGNDOC_Exception **aEx,
                            void *aClosure,
                            int aPos)
  {
    *aEx = NULL;
    try
      {
        return reinterpret_cast<UserInputStream*>(aClosure)->seek (aPos);
      }
    catch (std::exception &e)
      {
        SIGNDOC_catch (aEx, e);
      }
  }

  /**
   * @brief Internal helper function: static function called from C code.
   */
  static int SDCAPI tellC (SIGNDOC_Exception **aEx,
                           const void *aClosure)
  {
    *aEx = NULL;
    try
      {
        return reinterpret_cast<const UserInputStream*>(aClosure)->tell ();
      }
    catch (std::exception &e)
      {
        SIGNDOC_catch (aEx, e);
        return 0;
      }
  }

  /**
   * @brief Internal helper function: static function called from C code.
   */
  static int SDCAPI getAvailableC (SIGNDOC_Exception **aEx,
                                   void *aClosure)
  {
    *aEx = NULL;
    try
      {
        return reinterpret_cast<UserInputStream*>(aClosure)->getAvailable ();
      }
    catch (std::exception &e)
      {
        SIGNDOC_catch (aEx, e);
        return 0;
      }
  }
};

/**
 * @brief Base class for InputStream implementations in SignDoc SDK.
 */
class LibraryInputStream : public InputStream
{
public:
  /**
   * @brief Constructor.
   *
   * @param[in] aImpl   A pointer to the C structure.
   */
  LibraryInputStream (SIGNDOC_InputStream *aImpl)
    : InputStream (aImpl) { }

  virtual int read (void *aDst, int aLen)
  {
    SIGNDOC_Exception *ex = NULL;
    int r = SIGNDOC_InputStream_read (&ex, p, aDst, aLen);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  virtual void close ()
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_InputStream_close (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
  }

  virtual void seek (int aPos)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_InputStream_seek (&ex, p, aPos);
    if (ex != NULL) SignDoc_throw (ex);
  }

  virtual int tell () const
  {
    SIGNDOC_Exception *ex = NULL;
    int r = SIGNDOC_InputStream_tell (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  virtual int getAvailable ()
  {
    SIGNDOC_Exception *ex = NULL;
    int r = SIGNDOC_InputStream_getAvailable (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }
};

#if defined (SPOOC_INPUTSTREAM_H__)

class Spooc1InputStream : public de::softpro::spooc::InputStream
{
public:
  Spooc1InputStream (de::softpro::doc::InputStream &aStream)
     : mStream (aStream) { }
  virtual int read (void *aDst, int aLen) { return mStream.read (aDst, aLen); }
  virtual void close () { mStream.close (); }
  virtual void seek (int aPos) { mStream.seek (aPos); }
  virtual int tell () const { return mStream.tell (); }
  virtual int avail () { return mStream.getAvailable (); }
private:
  de::softpro::doc::InputStream &mStream;
};

class Spooc2InputStream : public UserInputStream
{
public:
  Spooc2InputStream (de::softpro::spooc::InputStream &aStream)
     : mStream (aStream) { }
  virtual int read (void *aDst, int aLen) { return mStream.read (aDst, aLen); }
  virtual void close () { mStream.close (); }
  virtual void seek (int aPos) { mStream.seek (aPos); }
  virtual int tell () const { return mStream.tell (); }
  virtual int getAvailable () { return mStream.avail (); }
private:
  de::softpro::spooc::InputStream &mStream;
};

#endif

//----------------------------------------------------------------------------

/**
 * @brief Class implementing an InputStream reading from a file.
 *
 * If possible, any exception thrown by member functions of this class
 * contain the pathname. Note that the pathname will be UTF-8 encoded.
 */
class FileInputStream : public LibraryInputStream
{
public:
  /**
   * @brief Constructor: Read from a C stream.
   *
   * @param[in] aFile  The C stream to be wrapped.
   */
  FileInputStream (FILE *aFile)
    : LibraryInputStream (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_FileInputStream_newWithFile (&ex, aFile);
    if (ex != NULL) SignDoc_throw (ex);
  };

  /**
   * @brief Constructor: Read from a C stream.
   *
   * @param[in] aFile  The C stream to be wrapped.
   * @param[in] aPath  The pathname (native encoding), used in exceptions,
   *                   can be NULL.
   */
  FileInputStream (FILE *aFile, const char *aPath)
    : LibraryInputStream (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_FileInputStream_newWithFileAndPath (&ex, aFile, aPath);
    if (ex != NULL) SignDoc_throw (ex);
  };

  /**
   * @brief Constructor: Open a file in binary mode.
   *
   * Throws an exception on error.
   *
   * @param[in] aPath  The pathname of the file to be opened (native encoding).
   */
  FileInputStream (const char *aPath)
    : LibraryInputStream (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_FileInputStream_newWithPath (&ex, aPath);
    if (ex != NULL) SignDoc_throw (ex);
  };

  /**
   * @brief Constructor: Open a file in binary mode.
   *
   * Throws an exception on error.
   *
   * @param[in] aPath  The pathname of the file to be opened.
   */
  FileInputStream (const wchar_t *aPath)
    : LibraryInputStream (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_FileInputStream_newWithPathW (&ex, aPath);
    if (ex != NULL) SignDoc_throw (ex);
  };
};

//----------------------------------------------------------------------------

/**
 * @brief Class implementing an InputStream reading from memory.
 */
class MemoryInputStream : public LibraryInputStream
{
public:
  /**
   * @brief Constructor.
   *
   * Read from the buffer pointed to by @a aSrc. Note that the buffer contents
   * won't be copied, therefore the buffer must remain valid throughout
   * the use of this object.
   *
   * @param[in] aSrc  Points to the stream contents.
   * @param[in] aLen  Size of the stream contents.
   */
  MemoryInputStream (const unsigned char *aSrc, size_t aLen)
    : LibraryInputStream (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_MemoryInputStream_new (&ex, aSrc, aLen);
    if (ex != NULL) SignDoc_throw (ex);
  };
};

//----------------------------------------------------------------------------

/**
 * @brief Interface for an output stream, inspired by Java's
 *        java.io.OutputStream.
 *
 * If you want to implement your own OutputStream implementation,
 * derive your class from UserOutputStream.
 */
class OutputStream
{
public:
  /**
   * @brief Constructor.
   *
   * @param[in] aImpl   A pointer to the C structure.
   */
  OutputStream (SIGNDOC_OutputStream *aImpl) : p (aImpl) { }

  /**
   * @brief Destructor.
   */
  virtual ~OutputStream ()
  {
    SIGNDOC_OutputStream_delete (p);
  }

  /**
   * @brief Close the stream.
   *
   * This function forces any buffered data to be written and
   * closes the stream.
   *
   * You should not write to the stream after calling this function.
   *
   * Implementations of this class may define exceptions thrown
   * by this function.
   */
  virtual void close () = 0;

  /**
   * @brief Flush the stream.
   *
   * This function forces any buffered data to be written.
   *
   * Implementations of this class may define exceptions thrown
   * by this function.
   */
  virtual void flush () = 0;

  /**
   * @brief Seek to the specified position.
   *
   * Throws an exception if the position is invalid or if seeking is
   * not supported.
   *
   * @param[in] aPos  The position (the first octet is at position zero).
   */
  virtual void seek (int aPos) = 0;

  /**
   * @brief Retrieve the current position.
   *
   * Throws an exception if the position cannot represented as
   * non-negative int or if seeking is not supported.
   *
   * @return The current position (the first octet is at position zero)
   */
  virtual int tell () const = 0;

  /**
   * @brief Write octets to the stream.
   *
   * Throws an exception on error.
   *
   * @param[in] aSrc  Pointer to buffer to be written.
   * @param[in] aLen  Number of octets to write.
   */
  virtual void write (const void *aSrc, int aLen) = 0;

  /**
   * @brief Internal.
   * @internal
   */
  SIGNDOC_OutputStream *getImpl () { return p; }

protected:
  /**
   * @brief Pointer to C structure.
   */
  SIGNDOC_OutputStream *p;

private:
  /**
   * @brief Copy constructor (unavailable).
   */
  OutputStream (const OutputStream &);

  /**
   * @brief Assignment operator (unavailable).
   */
  OutputStream &operator= (const OutputStream &);
};

/**
 * @brief Base class for OutputStream implementations by user code.
 *
 * Any exception object thrown must be derived from std::exception.
 */
class UserOutputStream : public OutputStream
{
public:
  /**
   * @brief Default constructor.
   */
  UserOutputStream ()
    : OutputStream (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_UserOutputStream_new (&ex, this,
                                      closeC, flushC, writeC, seekC,
                                      tellC);
    if (ex != NULL) SignDoc_throw (ex);
  }

private:
  /**
   * @brief Internal helper function: static function called from C code.
   */
  static void SDCAPI closeC (SIGNDOC_Exception **aEx,
                             void *aClosure)
  {
    *aEx = NULL;
    try
      {
        reinterpret_cast<UserOutputStream*>(aClosure)->close ();
      }
    catch (std::exception &e)
      {
        SIGNDOC_catch (aEx, e);
      }
  }

  /**
   * @brief Internal helper function: static function called from C code.
   */
  static void SDCAPI flushC (SIGNDOC_Exception **aEx,
                             void *aClosure)
  {
    *aEx = NULL;
    try
      {
        reinterpret_cast<UserOutputStream*>(aClosure)->flush ();
      }
    catch (std::exception &e)
      {
        SIGNDOC_catch (aEx, e);
      }
  }

  /**
   * @brief Internal helper function: static function called from C code.
   */
  static void SDCAPI writeC (SIGNDOC_Exception **aEx,
                             void *aClosure,
                             const void *aSrc, int aLen)
  {
    *aEx = NULL;
    try
      {
        reinterpret_cast<UserOutputStream*>(aClosure)->write (aSrc, aLen);
      }
    catch (std::exception &e)
      {
        SIGNDOC_catch (aEx, e);
      }
  }

  /**
   * @brief Internal helper function: static function called from C code.
   */
  static void SDCAPI seekC (SIGNDOC_Exception **aEx,
                            void *aClosure,
                            int aPos)
  {
    *aEx = NULL;
    try
      {
        return reinterpret_cast<UserOutputStream*>(aClosure)->seek (aPos);
      }
    catch (std::exception &e)
      {
        SIGNDOC_catch (aEx, e);
      }
  }

  /**
   * @brief Internal helper function: static function called from C code.
   */
  static int SDCAPI tellC (SIGNDOC_Exception **aEx,
                           const void *aClosure)
  {
    *aEx = NULL;
    try
      {
        return reinterpret_cast<const UserOutputStream*>(aClosure)->tell ();
      }
    catch (std::exception &e)
      {
        SIGNDOC_catch (aEx, e);
        return 0;
      }
  }
};

/**
 * @brief Base class for OutputStream implementations in SignDoc SDK.
 */
class LibraryOutputStream : public OutputStream
{
public:
  /**
   * @brief Constructor.
   *
   * @param[in] aImpl   A pointer to the C structure.
   */
  LibraryOutputStream (SIGNDOC_OutputStream *aImpl)
    : OutputStream (aImpl) { }

  virtual void close ()
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_OutputStream_close (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
  }

  virtual void flush ()
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_OutputStream_flush (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
  }

  virtual void write (const void *aSrc, int aLen)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_OutputStream_write (&ex, p, aSrc, aLen);
    if (ex != NULL) SignDoc_throw (ex);
  }

  virtual void seek (int aPos)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_OutputStream_seek (&ex, p, aPos);
    if (ex != NULL) SignDoc_throw (ex);
  }

  virtual int tell () const
  {
    SIGNDOC_Exception *ex = NULL;
    int r = SIGNDOC_OutputStream_tell (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }
};

#if defined (SPOOC_OUTPUTSTREAM_H__)

class Spooc1OutputStream : public de::softpro::spooc::OutputStream
{
public:
  Spooc1OutputStream (de::softpro::doc::OutputStream &aStream)
    : mStream (aStream) { }
  virtual void close () { mStream.close (); }
  virtual void flush () { mStream.flush (); }
  virtual void write (const void *aSrc, int aLen) { mStream.write (aSrc, aLen); }
  virtual void seek (int aPos) { mStream.seek (aPos); }
  virtual int tell () const { return mStream.tell (); }
private:
  de::softpro::doc::OutputStream &mStream;
};

class Spooc2OutputStream : public UserOutputStream
{
public:
  Spooc2OutputStream (de::softpro::spooc::OutputStream &aStream)
    : mStream (aStream) { }
  ~Spooc2OutputStream () { }
  virtual void close () { mStream.close (); }
  virtual void flush () { mStream.flush (); }
  virtual void write (const void *aSrc, int aLen) { mStream.write (aSrc, aLen); }
  virtual void seek (int aPos) { mStream.seek (aPos); }
  virtual int tell () const { return mStream.tell (); }
private:
  de::softpro::spooc::OutputStream &mStream;
};

#endif

//----------------------------------------------------------------------------

/**
 * @brief Class implementing an OutputStream writing to a file.
 *
 * If possible, any exception thrown by member functions of this class
 * contain the pathname. Note that the pathname will be UTF-8 encoded.
 */
class FileOutputStream : public LibraryOutputStream
{
public:
  /**
   * @brief Constructor: Write to a C stream.
   *
   * @param[in] aFile  The C stream to be wrapped.
   */
  FileOutputStream (FILE *aFile)
    : LibraryOutputStream (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_FileOutputStream_newWithFile (&ex, aFile);
    if (ex != NULL) SignDoc_throw (ex);
  };

  /**
   * @brief Constructor: Write to a C stream.
   *
   * @param[in] aFile  The C stream to be wrapped.
   * @param[in] aPath  The pathname (native encoding), used in exceptions,
   *                   can be NULL.
   */
  FileOutputStream (FILE *aFile, const char *aPath)
    : LibraryOutputStream (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_FileOutputStream_newWithFileAndPath (&ex, aFile, aPath);
    if (ex != NULL) SignDoc_throw (ex);
  };

  /**
   * @brief Constructor: Open a file in binary mode.
   *
   * If the named file already exists, it will be truncated.
   * Throws an exception on error.
   *
   * @param[in] aPath  The pathname of the file to be opened (native encoding).
   */
  FileOutputStream (const char *aPath)
    : LibraryOutputStream (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_FileOutputStream_newWithPath (&ex, aPath);
    if (ex != NULL) SignDoc_throw (ex);
  };

  /**
   * @brief Constructor: Open a file in binary mode.
   *
   * If the named file already exists, it will be truncated.
   * Throws an exception on error.
   *
   * @param[in] aPath  The pathname of the file to be opened.
   */
  FileOutputStream (const wchar_t *aPath)
    : LibraryOutputStream (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_FileOutputStream_newWithPathW (&ex, aPath);
    if (ex != NULL) SignDoc_throw (ex);
  };
};

//----------------------------------------------------------------------------

/**
 * @brief Class implementing an OutputStream writing to memory
 *        and allocating memory as needed.
 */
class MemoryOutputStream : public LibraryOutputStream
{
public:
  /**
   * @brief Constructor.
   */
  MemoryOutputStream ()
    : LibraryOutputStream (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_MemoryOutputStream_new (&ex);
    if (ex != NULL) SignDoc_throw (ex);
  };

  /**
   * @brief Retrieve a pointer to the contents of this MemoryOutputStream.
   *
   * Note that the returned pointer is only valid up to the next
   * output to the stream.
   *
   * @return Pointer to the first octet of the stream contents.
   */
  const unsigned char *data ()
  {
    SIGNDOC_Exception *ex = NULL;
    const unsigned char *r = SIGNDOC_MemoryOutputStream_data (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Retrieve the length of the contents of this MemoryOutputStream.
   */
  size_t length ()
  {
    SIGNDOC_Exception *ex = NULL;
    size_t r = SIGNDOC_MemoryOutputStream_length (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Clear the buffered data of this MemoryOutputStream.
   *
   * The buffer will be empty and the current position will be zero.
   *
   * The buffer may or may not be deallocated.
   */
  void clear ()
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_MemoryOutputStream_clear (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
  }
};
/**
 * @brief Encoding of strings.
 */
enum Encoding
{
  enc_native,      ///< Windows "ANSI" for Windows, LC_CTYPE for Linux, file system representation for iOS
  enc_utf_8,       ///< UTF-8
  enc_latin_1      ///< ISO 8859-1
};

/**
 * @brief A point (page coordinates or canvas coordinates).
 */
class Point 
{
public:
  /**
   * @brief Constructor.
   *
   * All coordinates will be 0.
   */
  Point ()
    : mX (0), mY (0)
  {
  }

  /**
   * @brief Constructor.
   *
   * @param[in] aX  The X coordinate.
   * @param[in] aY  The Y coordinate.
   */
  Point (double aX, double aY)
    : mX (aX), mY (aY)
  {
  }

  /**
   * @brief Copy constructor.
   *
   * @param[in] aSrc The object to be copied.
   */
  Point (const Point &aSrc)
    : mX (aSrc.mX), mY (aSrc.mY)
  {
  }

  /**
   * @brief Destructor.
   */
  ~Point ()
  {
  }

  /**
   * @brief Set the coordinates of the point.
   *
   * @param[in] aX  The X coordinate.
   * @param[in] aY  The Y coordinate.
   */
  void set (double aX, double aY)
  {
    SIGNDOC_Point_setXY ((SIGNDOC_Point*)this, aX, aY);
  }

public:
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
 */
class Rect 
{
public:
  /**
   * @brief Constructor.
   *
   * All coordinates will be 0.
   */
  Rect ()
    : mX1 (0), mY1 (0), mX2 (0), mY2 (0)
  {
  }

  /**
   * @brief Constructor.
   *
   * @param[in] aX1  The first X coordinate.
   * @param[in] aY1  The first Y coordinate.
   * @param[in] aX2  The second X coordinate.
   * @param[in] aY2  The second Y coordinate.
   */
  Rect (double aX1, double aY1, double aX2, double aY2)
    : mX1 (aX1), mY1 (aY1), mX2 (aX2), mY2 (aY2)
  {
  }

  /**
   * @brief Copy constructor.
   *
   * @param[in] aSrc The object to be copied.
   */
  Rect (const Rect &aSrc)
    : mX1 (aSrc.mX1), mY1 (aSrc.mY1), mX2 (aSrc.mX2), mY2 (aSrc.mY2)
  {
  }

  /**
   * @brief Destructor.
   */
  ~Rect ()
  {
  }

  /**
   * @brief Get the coordinates of the rectangle.
   *
   * @param[out] aX1  The first X coordinate.
   * @param[out] aY1  The first Y coordinate.
   * @param[out] aX2  The second X coordinate.
   * @param[out] aY2  The second Y coordinate.
   */
  void get (double &aX1, double &aY1, double &aX2, double &aY2) const
  {
    SIGNDOC_Rect_get ((const SIGNDOC_Rect*)this, &aX1, &aY1, &aX2, &aY2);
  }

  /**
   * @brief Set the coordinates of the rectangle.
   *
   * @param[in] aX1  The first X coordinate.
   * @param[in] aY1  The first Y coordinate.
   * @param[in] aX2  The second X coordinate.
   * @param[in] aY2  The second Y coordinate.
   */
  void set (double aX1, double aY1, double aX2, double aY2)
  {
    SIGNDOC_Rect_setXY ((SIGNDOC_Rect*)this, aX1, aY1, aX2, aY2);
  }

  /**
   * @brief Get the width of the rectangle.
   *
   * @return The width of the rectangle.
   */
  double getWidth () const
  {
    return SIGNDOC_Rect_getWidth ((const SIGNDOC_Rect*)this);
  }

  /**
   * @brief Get the height of the rectangle.
   *
   * @return The height of the rectangle.
   */
  double getHeight () const
  {
    return SIGNDOC_Rect_getHeight ((const SIGNDOC_Rect*)this);
  }

  /**
   * @brief Normalizes the rectangle.
   *
   * Normalizes the rectangle to the one with lower-left and
   * upper-right corners assuming that the origin is in the
   * lower-left corner of the page.
   */
  void normalize ()
  {
    SIGNDOC_Rect_normalize ((SIGNDOC_Rect*)this);
  }

  /**
   * @brief Scale the rectangle.
   *
   * @param[in] aFactor   The factor by which the rectangle is to be scaled.
   */
  void scale (double aFactor)
  {
    SIGNDOC_Rect_scale ((SIGNDOC_Rect*)this, aFactor);
  }

  /**
   * @brief Scale the rectangle.
   *
   * @param[in] aFactorX   The factor by which the rectangle is to be scaled
   *                       horizontally.
   * @param[in] aFactorY   The factor by which the rectangle is to be scaled
   *                       vertically.
   */
  void scale (double aFactorX, double aFactorY)
  {
    SIGNDOC_Rect_scaleXY ((SIGNDOC_Rect*)this, aFactorX, aFactorY);
  }

  /**
   * @brief Get the first X coordinate.
   * @internal
   *
   * @return The first X coordinate
   */
  double getX1 () const
  {
    return mX1;
  }

  /**
   * @brief Get the first Y coordinate.
   * @internal
   *
   * @return The first Y coordinate.
   */
  double getY1 () const
  {
    return mY1;
  }

  /**
   * @brief Get the second X coordinate.
   * @internal
   *
   * @return The second X coordinate.
   */
  double getX2 () const
  {
    return mX2;
  }

  /**
   * @brief Get the second Y coordinate.
   * @internal
   *
   * @return The second Y coordinate.
   */
  double getY2 () const
  {
    return mY2;
  }

public:
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
 * @brief Interface for creating an RFC 3161 timestamp.
 */
class TimeStamper 
{
public:
  /**
   * @brief Return value of stamp().
   */
  enum StampResult
  {
    /**
     * @brief Success.
     */
    sr_ok,

    /**
     * @brief Invalid argument or invalid time-stamp request.
     */
    sr_invalid_input,

    /**
     * @brief Timeout.
     */
    sr_timeout,

    /**
     * @brief Transaction interrupted by stop().
     */
    sr_stopped,

    /**
     * @brief Some failure at the TCP/IP layer.
     */
    sr_tcp_error,

    /**
     * @brief Some failure at the SSL layer.
     */
    sr_ssl_error,

    /**
     * @brief Some failure at the HTTP layer.
     */
    sr_http_error,

    /**
     * @brief The server failed to create the time stamp
     *        (according to PKIStatus).
     */
    sr_server_error,

    /**
     * @brief The response from the server is invalid.
     */
    sr_invalid_response
  };

public:
  /**
   * @brief Get the object ID of the message digest algorithm.
   *
   * @return A pointer to the object ID of the message digest algorithm
   *         as string, e.g., "1.3.14.3.2.26" for SHA-1.
   */
  const char *getHashAlgorithm () const
  {
    return SIGNDOC_TimeStamper_getHashAlgorithm (p);
  }

  /**
   * @brief Create a time-stamp request, send the request to the configured
   *        time stamping authority, and evaluate the response.
   *
   * The signature in the returned time-stamp token is not verified
   * by this function.
   *
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
   * @return sr_ok if successful. Use getErrorMessage() to get an
   *         error message.
   *
   * @see getErrorMessage(), getHashAlgorithm(), stop()
   *
   * @todo return PKIStatus (in aOutput?)
   */
  StampResult stamp (const unsigned char *aHashPtr, size_t aHashSize,
                     unsigned aRandomNonceSize,
                     std::vector<unsigned char> &aOutput, int &aStatus,
                     unsigned &aFailureInfo)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_ByteArray *tempOutput = NULL;
    StampResult r;
    try
      {
        tempOutput = SIGNDOC_ByteArray_new (&ex);
        if (ex != NULL) SignDoc_throw (ex);
        r = (StampResult)SIGNDOC_TimeStamper_stamp (&ex, p, aHashPtr, aHashSize, aRandomNonceSize, tempOutput, &aStatus, &aFailureInfo);
        assignArray (aOutput, tempOutput);
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_ByteArray_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_ByteArray_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Interrupt a stamp() call from another thread.
   *
   * If this function is called while stamp() is waiting for the
   * response from the server, stamp() will return sr_stopped.
   */
  void stop ()
  {
    SIGNDOC_TimeStamper_stop (p);
  }

  /**
   * @brief Get an error message for the last stamp() call.
   *
   * @return A pointer to a string describing the reason for the
   *         failure of the last stamp() call. The string is empty
   *         if the last call succeeded. The pointer is valid until
   *         this object is destroyed or stamp() is called again.
   *         The string is ASCII encoded, the error message is
   *         in English.
   */
  const char *getErrorMessage () const
  {
    return SIGNDOC_TimeStamper_getErrorMessage (p);
  }

protected:
public:
  /**
   * @brief Destructor.
   */
  ~TimeStamper ()
  {
  }
  /**
   * @brief Internal function.
   * @internal
   */
  TimeStamper (SIGNDOC_TimeStamper *aP) : p (aP) { }

  /**
   * @brief Internal function.
   * @internal
   */
  SIGNDOC_TimeStamper *getImpl () { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  const SIGNDOC_TimeStamper *getImpl () const { return p; }

private:
  SIGNDOC_TimeStamper *p;
};

/**
 * @brief Data source.
 *
 * Interface for getting byte ranges from a document.
 */
class Source
{
public:
  /**
   * @brief Constructor.
   *
   * @param[in] aImpl   A pointer to the C structure.
   */
  Source (struct SIGNDOC_Source *aImpl)
    : p (aImpl) { }

  /**
   * @brief Destructor.
   */
  virtual ~Source () { }

  /**
   * @brief Fetch data from the document.
   *
   * @param[out] aPtr      A pointer to the first byte will be stored here.
   * @param[in] aMaxSize   Fetch up to this many bytes. Must be positive.
   *
   * @return 0 if no more data is available, otherwise the number of bytes
   *         pointed to by the pointer returned in @a aPtr. The return value
   *         is always less than or equal to @a aMaxSize.
   */
  int fetch (const void *&aPtr, int aMaxSize)
  {
    struct SIGNDOC_Exception *ex = NULL;
    int r = SIGNDOC_Source_fetch (&ex, p, &aPtr, aMaxSize);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

private:
  SIGNDOC_Source *p;
};

/**
 * @brief Interface for creating a PKCS #7 signature.
 *
 * Selection of the certificate is up to the implementation.
 */
class SignPKCS7
{
public:
  /**
   * @brief Hash Algorithm to be used for detached signature.
   *
   * @see DigSigDoc::DetachedAlgorithm
   */
  enum DetachedAlgorithm
  {
    da_not_detached,            ///< Signature is not detached
    da_md5,                     ///< MD5
    da_sha1,                    ///< SHA-1
    da_sha256                   ///< SHA-256
  };

  /**
   * @brief Constructor.
   */
  SignPKCS7 ()
    : p (NULL), mBadAlloc (false)
  {
    struct SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_SignPKCS7_new (&ex, this, signHashC, signDetachedC,
                               getSignHashSizeC, getSignDetachedSizeC,
                               getSubjectCommonNameC, getErrorMessageC);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Destructor.
   *
   * Should release the crypto provider context if one was acquired.
   */
  virtual ~SignPKCS7 ()
  {
    SIGNDOC_SignPKCS7_delete (p);
  }

  /**
   * @brief Sign a hash, producing a PKCS #7 signature.
   *
   * This function must not throw any exception except for std::bad_alloc.
   *
   * @param[in] aHashPtr   Pointer to the first octet of the hash.
   * @param[in] aHashSize  Size of the hash (number of octets
   *                       pointed to by @a aHashPtr).
   * @param[in] aTimeStamper  Non-NULL to use a time-stamp server.
   * @param[out] aOutput   The ASN.1-encoded PKCS #7 signature will be
   *                       stored here.
   *
   * @return true iff successful.
   */
  virtual bool signHash (const unsigned char *aHashPtr, size_t aHashSize,
                         TimeStamper *aTimeStamper,
                         std::vector<unsigned char> &aOutput) = 0;

  /**
   * @brief Sign data, producing a detached PKCS #7 signature.
   *
   * This function must not throw any exception except for std::bad_alloc.
   *
   * @param[in] aSource     An object providing data to be hashed.
   * @param[in] aAlgorithm  Hash algorithm to be used for detached signature.
   *                        Must not be da_not_detached.
   * @param[in] aTimeStamper  Non-NULL to use a time-stamp server.
   * @param[out] aOutput  The ASN.1-encoded PKCS #7 signature will be
   *                      stored here.
   *
   * @return true iff successful.
   */
  virtual bool signDetached (Source &aSource,
                             DetachedAlgorithm aAlgorithm,
                             TimeStamper *aTimeStamper,
                             std::vector<unsigned char> &aOutput) = 0;

  /**
   * @brief Compute the size of the signature produced by signHash().
   *
   * This function must not throw any exception except for std::bad_alloc.
   *
   * @param[in] aHashSize   Size of the hash (number of octets).
   * @param[in] aTimeStamp  true to include RFC 3161 time stamp.
   *
   * @return A positive number which is an upper limit to the number
   *         of octets required for the ASN.1-encoded signature,
   *         zero on error.
   */
  virtual size_t getSignHashSize (size_t aHashSize, bool aTimeStamp) = 0;

  /**
   * @brief Compute the size of the signature produced by signDetached().
   *
   * This function must not throw any exception except for std::bad_alloc.
   *
   * @param[in] aAlgorithm   Hash algorithm to be used for detached signature.
   *                         Must not be da_not_detached.
   * @param[in] aTimeStamp   true to include RFC 3161 time stamp.
   *
   * @return A positive number which is an upper limit to the number
   *         of octets required for the ASN.1-encoded signature,
   *         zero on error.
   */
  virtual size_t getSignDetachedSize (DetachedAlgorithm aAlgorithm,
                                      bool aTimeStamp) = 0;

  /**
   * @brief Get the common name (CN) of the certificate's subject.
   *
   * This function must not throw any exception except for std::bad_alloc.
   *
   * @param[out] aOutput    The common name will be stored here (UTF-8).
   *
   * @return true iff successful.
   */
  virtual bool getSubjectCommonName (std::string &aOutput) const = 0;

  /**
   * @brief Get an error message for the last operation.
   *
   * This function must not throw any exception except for std::bad_alloc.
   *
   * After any member function of this object has been called, you can
   * retrieve an error message by calling this function.
   *
   * @return  A pointer to the error message.  The pointer will become
   *          invalid as soon as any member function of this object is called
   *          or this object is destroyed.
   */
  virtual const char *getErrorMessage () const = 0;

  /**
   * @brief Internal.
   * @internal
   */
  SIGNDOC_SignPKCS7 *getImpl () { return p; }

private:
  static SIGNDOC_Boolean SDCAPI
  signHashC (void *aClosure, const unsigned char *aHashPtr,
             size_t aHashSize,
             struct SIGNDOC_TimeStamper *aTimeStamper,
             struct SIGNDOC_ByteArray *aOutput)
  {
    SignPKCS7 *s = static_cast<SignPKCS7*>(aClosure);
    s->mBadAlloc = false;
    try
      {
        std::vector<unsigned char> output;
        TimeStamper ts (aTimeStamper);
        bool ok = s->signHash (aHashPtr, aHashSize,
                               (aTimeStamper != NULL) ? &ts : NULL,
                               output);
        if (ok)
          assignByteArray (aOutput, output);
        return ok;
      }
    catch (std::bad_alloc &)
      {
        s->mBadAlloc = true;
        return SIGNDOC_FALSE;
      }
  }

  static SIGNDOC_Boolean SDCAPI
  signDetachedC (void *aClosure,
                 struct SIGNDOC_Source *aSource,
                 int aAlgorithm,
                 struct SIGNDOC_TimeStamper *aTimeStamper,
                 struct SIGNDOC_ByteArray *aOutput)
  {
    SignPKCS7 *s = static_cast<SignPKCS7*>(aClosure);
    s->mBadAlloc = false;
    try
      {
        SIGNDOC_ByteArray_clear (aOutput);
        std::vector<unsigned char> output;
        Source src (aSource);
        TimeStamper ts (aTimeStamper);
        bool ok = s->signDetached (src, (DetachedAlgorithm)aAlgorithm,
                                   (aTimeStamper != NULL) ? &ts : NULL,
                                   output);
        if (ok)
          assignByteArray (aOutput, output);
        return ok;
      }
    catch (std::bad_alloc &)
      {
        s->mBadAlloc = true;
        return SIGNDOC_FALSE;
      }
  }

  static size_t SDCAPI
  getSignHashSizeC (void *aClosure, size_t aHashSize,
                    SIGNDOC_Boolean aTimeStamp)
  {
    SignPKCS7 *s = static_cast<SignPKCS7*>(aClosure);
    s->mBadAlloc = false;
    try
      {
        return s->getSignHashSize (aHashSize, (bool)aTimeStamp);
      }
    catch (std::bad_alloc &)
      {
        s->mBadAlloc = true;
        return 0;
      }
  }

  static size_t SDCAPI
  getSignDetachedSizeC (void *aClosure, int aAlgorithm,
                        SIGNDOC_Boolean aTimeStamp)
  {
    SignPKCS7 *s = static_cast<SignPKCS7*>(aClosure);
    s->mBadAlloc = false;
    try
      {
        return s->getSignDetachedSize ((DetachedAlgorithm)aAlgorithm,
                                       (bool)aTimeStamp);
      }
    catch (std::bad_alloc &)
      {
        s->mBadAlloc = true;
        return 0;
      }
  }

  static SIGNDOC_Boolean SDCAPI
  getSubjectCommonNameC (void *aClosure, char **aOutput)
  {
    SignPKCS7 *s = static_cast<SignPKCS7*>(aClosure);
    s->mBadAlloc = false;
    try
      {
        *aOutput = NULL;
        std::string output;
        bool ok = s->getSubjectCommonName (output);
        if (ok)
          assignString (aOutput, output);
        return ok;
      }
    catch (std::bad_alloc &)
      {
        s->mBadAlloc = true;
        return SIGNDOC_FALSE;
      }
  }

  static const char * SDCAPI
  getErrorMessageC (void *aClosure)
  {
    SignPKCS7 *s = static_cast<SignPKCS7*>(aClosure);
    if (s->mBadAlloc)
      return "out of memory";
    try
      {
        return s->getErrorMessage ();
      }
    catch (std::bad_alloc &)
      {
        s->mBadAlloc = true;
        return "out of memory";
      }
  }

  static void assignByteArray (SIGNDOC_ByteArray *aOutput,
                               const std::vector<unsigned char> &aInput)
  {
    if (aInput.empty ())
      SIGNDOC_ByteArray_clear (aOutput);
    else
      {
        struct SIGNDOC_Exception *ex = NULL;
        SIGNDOC_ByteArray_set (&ex, aOutput,
                               &aInput[0], aInput.size ());
        if (ex != NULL) SignDoc_throw (ex);
      }
  }

  static void assignString (char **aOutput, const std::string &aInput)
  {
    struct SIGNDOC_Exception *ex = NULL;
    *aOutput = SIGNDOC_strdup (&ex, aInput.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
  }

private:
  SIGNDOC_SignPKCS7 *p;
  bool mBadAlloc;
};

/**
 * @brief A color.
 *
 * Use the static factory functions to create SignDocColor objects.
 * Do not forget to destroy the objects after use.
 *
 * @todo color spaces (CalGray vs. DeviceGray etc.)
 */
class SignDocColor 
{
public:
  enum Type
  {
    /**
     * @brief Gray scale.
     */
    t_gray,

    /**
     * @brief RGB color.
     */
    t_rgb
  };

public:
  /**
   * @brief Destructor.
   */
  ~SignDocColor ()
  {
    SIGNDOC_Color_delete (p);
  }

  /**
   * @brief Create a copy of this object.
   *
   * Do not forget to destroy the copy after use.
   */
  SignDocColor *clone () const
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Color *r;
    r = SIGNDOC_Color_clone (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    if (r == NULL)
      return NULL;
    try
      {
        return new SignDocColor (r);
      }
    catch (...)
      {
        SIGNDOC_Color_delete (r);
        throw;
      }
  }

  /**
   * @brief Get the color type of this object.
   *
   * @return The color type.
   */
  Type getType () const
  {
    return (Type)SIGNDOC_Color_getType (p);
  }

  /**
   * @brief Get the number of color components (channels).
   *
   * @return 1 for gray scale, 3 for RGB.
   */
  unsigned getNumberOfComponents () const
  {
    return SIGNDOC_Color_getNumberOfComponents (p);
  }

  /**
   * @brief Get one color component (channel).
   *
   * @param[in] aIndex  The index of the color component (0 through 2).
   *                    The meaning depends on the color type.
   *
   * @return The value (0 through 255) of the color component
   *         @a aIndex or 0 if @a aIndex is out of range.
   */
  unsigned char getComponent (unsigned aIndex) const
  {
    return SIGNDOC_Color_getComponent (p, aIndex);
  }

  /**
   * @brief Get the intensity of a gray-scale color object.
   *
   * @return The intensity (0 through 255, 0 is black) for a gray-scale
   *         color object, undefined for other color types.
   */
  unsigned char getIntensity () const
  {
    return SIGNDOC_Color_getIntensity (p);
  }

  /**
   * @brief Get the red component of an RGB color object.
   *
   * @return The red component (0 through 255, 0 is black) of an
   *         RGB color object, undefined for other color types.
   */
  unsigned char getRed () const
  {
    return SIGNDOC_Color_getRed (p);
  }

  /**
   * @brief Get the green component of an RGB color object.
   *
   * @return The green component (0 through 255, 0 is black) of an
   *         RGB color object, undefined for other color types.
   */
  unsigned char getGreen () const
  {
    return SIGNDOC_Color_getGreen (p);
  }

  /**
   * @brief Get the blue component of an RGB color object.
   *
   * @return The blue component (0 through 255, 0 is black) of an
   *         RGB color object, undefined for other color types.
   */
  unsigned char getBlue () const
  {
    return SIGNDOC_Color_getBlue (p);
  }

  /**
   * @brief Create a new gray-scale color object.
   *
   * @param[in] aIntensity The intensity (0 through 255, 0 is black).
   *
   * @return A pointer to the new color object. Do not forget to
   *         destroy the object after use.
   */
  static SignDocColor *createGray (unsigned char aIntensity)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Color *r;
    r = SIGNDOC_Color_createGray (&ex, aIntensity);
    if (ex != NULL) SignDoc_throw (ex);
    if (r == NULL)
      return NULL;
    try
      {
        return new SignDocColor (r);
      }
    catch (...)
      {
        SIGNDOC_Color_delete (r);
        throw;
      }
  }

  /**
   * @brief Create a new RGB color object.
   *
   * The values are in 0 through 255, 0 is black.
   *
   * @param[in] aRed   The value of the red channel.
   * @param[in] aGreen The value of the green channel.
   * @param[in] aBlue  The value of the blue channel.
   *
   * @return A pointer to the new color object. Do not forget to
   *         destroy the object after use.
   */
  static SignDocColor *createRGB (unsigned char aRed, unsigned char aGreen,
                                  unsigned char aBlue)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Color *r;
    r = SIGNDOC_Color_createRGB (&ex, aRed, aGreen, aBlue);
    if (ex != NULL) SignDoc_throw (ex);
    if (r == NULL)
      return NULL;
    try
      {
        return new SignDocColor (r);
      }
    catch (...)
      {
        SIGNDOC_Color_delete (r);
        throw;
      }
  }

private:
  /**
   * @brief Constructor (unavailable).
   *
   * Use the static factory functions to create SignDocColor objects.
   */
  SignDocColor ();

  /**
   * @brief Copy Constructor (unavailable).
   *
   * Use clone().
   */
  SignDocColor (const SignDocColor &);

  /**
   * @brief Assignment operator (unavailable).
   *
   * Use clone().
   */
  SignDocColor &operator= (const SignDocColor &);

public:
  /**
   * @brief Internal function.
   * @internal
   */
  SignDocColor (SIGNDOC_Color *aP) : p (aP) { }

  /**
   * @brief Internal function.
   * @internal
   */
  SIGNDOC_Color *getImpl () { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  const SIGNDOC_Color *getImpl () const { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  void setImpl (SIGNDOC_Color *aP) { SIGNDOC_Color_delete (p); p  = aP; }

private:
  SIGNDOC_Color *p;
};

/**
 * @brief Attributes of a text field, list box field or combo box
 *        field used for the construction of the appearance (PDF
 *        documents only).
 *
 * This class represents a PDF default appearance string.
 *
 * Modifying an object of this type does not modify the underlying
 * field or document.  Use SignDocDocument::setTextFieldAttributes()
 * or SignDocField::setTextFieldAttributes() to update the text attributes
 * of a field or of the document.
 *
 * @see SignDocDocument::getTextFieldAttributes(), SignDocDocument::setTextFieldAttributes(), SignDocField::getTextFieldAttributes(), SignDocField::setTextFieldAttributes()
 */
class SignDocTextFieldAttributes 
{
public:

public:
  /**
   * @brief Constructor.
   */
  SignDocTextFieldAttributes ()
    : p (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_TextFieldAttributes_new (&ex);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Copy constructor.
   *
   * @param[in] aSource  The object to be copied.
   */
  SignDocTextFieldAttributes (const SignDocTextFieldAttributes &aSource)
    : p (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_TextFieldAttributes_clone (&ex, aSource.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Destructor.
   */
  ~SignDocTextFieldAttributes ()
  {
    SIGNDOC_TextFieldAttributes_delete (p);
  }

  /**
   * @brief Assignment operator.
   *
   * @param[in] aSource  The source object.
   */
  SignDocTextFieldAttributes &operator= (const SignDocTextFieldAttributes &aSource)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_TextFieldAttributes_assign (&ex, p, aSource.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return *this;
  }

  /**
   * @brief Efficiently swap this object with another one.
   *
   * @param[in] aOther  The other object.
   */
  void swap (SignDocTextFieldAttributes &aOther)
  {
    std::swap (p, aOther.p);
  }

  /**
   * @brief Check if text field attributes are set or not.
   *
   * If this function returns false for a SignDocTextFieldAttributes
   * object retrieved from a text field, the document's default
   * text field attributes will be used (if present).
   *
   * This function returns false for all SignDocTextFieldAttributes
   * objects retrieved from TIFF documents (but you can set the
   * attributes anyway, making isSet() return true).
   *
   * @return true if any attribute is set, false if no attributes are set.
   *
   * @see isValid()
   */
  bool isSet () const
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_TextFieldAttributes_isSet (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Check if the text field attributes are valid.
   *
   * This function does not check if the font name refers to a valid font.
   * This function does not check the string set by setRest().
   *
   * @return true if isSet() would return false or
   *         if all attributes are set and are valid, false otherwise.
   *
   * @see isSet(), setRest()
   */
  bool isValid () const
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_TextFieldAttributes_isValid (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Unset all attributes.
   *
   * isSet() will return false.
   */
  void clear ()
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_TextFieldAttributes_clear (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Get the name of the font.
   *
   * This function returns an empty string if isSet() would return false.
   *
   * @param[in] aEncoding  The encoding to be used for the return value.
   *
   * @return The name of the font.
   *
   * @see getFontResourceName(), getFontSize(), setFontName()
   */
  std::string getFontName (Encoding aEncoding) const
  {
    SIGNDOC_Exception *ex = NULL;
    std::string r;
    char *s = SIGNDOC_TextFieldAttributes_getFontName (&ex, p, aEncoding);
    if (ex != NULL) SignDoc_throw (ex);
    try
      {
        r = s;
      }
    catch (...)
      {
        SIGNDOC_free (s);
        throw;
      }
    SIGNDOC_free (s);
    return r;
  }

  /**
   * @brief Set the name of the font.
   *
   * The font name can be the name of a standard font, the name of an
   * already embedded font, or the name of a font defined by a font
   * configuration file.
   *
   * @param[in] aEncoding  The encoding of @a aFontName.
   * @param[in] aFontName  The new font name.
   *
   * @see getFontName(), setFontSize(), setTextColor(), SignDocDocumentLoader::loadFontConfigFile(), SignDocDocumentLoader::loadFontConfigEnvironment(), SignDocDocumentLoader::loadFontConfigStream()
   */
  void setFontName (Encoding aEncoding, const std::string &aFontName)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_TextFieldAttributes_setFontName (&ex, p, aEncoding, aFontName.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Get the resource name of the font.
   *
   * This function returns an empty string if isSet() would return false.
   *
   * Note that setting the resource name is not possible.
   *
   * @param[in] aEncoding  The encoding to be used for the return value.
   *
   * @return The resource name of the font.
   *
   * @see getFontName()
   */
  std::string getFontResourceName (Encoding aEncoding) const
  {
    SIGNDOC_Exception *ex = NULL;
    std::string r;
    char *s = SIGNDOC_TextFieldAttributes_getFontResourceName (&ex, p, aEncoding);
    if (ex != NULL) SignDoc_throw (ex);
    try
      {
        r = s;
      }
    catch (...)
      {
        SIGNDOC_free (s);
        throw;
      }
    SIGNDOC_free (s);
    return r;
  }

  /**
   * @brief Get the font size.
   *
   * This function returns 0 if isSet() would return false.
   *
   * @return The font size (in user space units).  If the font size is 0,
   *         the default font size (which depends on the field size)
   *         will be used.
   *
   * @see getFontName(), setFontSize()
   */
  double getFontSize () const
  {
    SIGNDOC_Exception *ex = NULL;
    double r;
    r = SIGNDOC_TextFieldAttributes_getFontSize (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the font size.
   *
   * @param[in] aFontSize  The font size (in user space units).
   *                       If the font size is 0, the default font size
   *                       (which depends on the field size) will be used.
   *
   * @see getFontSize(), setFontName(), SignDocDocument::sff_fit_height_only
   */
  void setFontSize (double aFontSize)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_TextFieldAttributes_setFontSize (&ex, p, aFontSize);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Get the text color.
   *
   * This function returns NULL if isSet() would return false.
   *
   * @return A pointer to an object describing the text color or NULL if
   *         the text color is not available. The caller is
   *         responsible for destroying the object.
   *
   * @see setTextColor()
   */
  SignDocColor *getTextColor () const
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Color *r;
    r = SIGNDOC_TextFieldAttributes_getTextColor (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    if (r == NULL)
      return NULL;
    try
      {
        return new SignDocColor (r);
      }
    catch (...)
      {
        SIGNDOC_Color_delete (r);
        throw;
      }
  }

  /**
   * @brief Set the text color.
   *
   * @param[in] aTextColor  The text color.
   */
  void setTextColor (const SignDocColor &aTextColor)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_TextFieldAttributes_setTextColor (&ex, p, aTextColor.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Get unparsed parts of default appearance string.
   *
   * If this function returns a non-empty string, there are unsupported
   * operators in the default appearance string.
   *
   * @param[in] aEncoding  The encoding to be used for the return value.
   *
   * @return Concatenated unparsed parts of the default appearance string, ie,
   *         the default appearance string sans font name, font size, and
   *         text color.  If this function returns a non-empty string, it
   *         will start with a space character.
   *
   * @see setRest()
   */
  std::string getRest (Encoding aEncoding) const
  {
    SIGNDOC_Exception *ex = NULL;
    std::string r;
    char *s = SIGNDOC_TextFieldAttributes_getRest (&ex, p, aEncoding);
    if (ex != NULL) SignDoc_throw (ex);
    try
      {
        r = s;
      }
    catch (...)
      {
        SIGNDOC_free (s);
        throw;
      }
    SIGNDOC_free (s);
    return r;
  }

  /**
   * @brief Set unparsed parts of default appearance string.
   *
   * @param[in] aEncoding  The encoding of @a aInput.
   * @param[in] aInput     The new string of unparsed operators.
   *                       If this string is non-empty and does not start
   *                       with a space character, a space character will
   *                       be prepended automatically.
   */
  void setRest (Encoding aEncoding, const std::string &aInput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_TextFieldAttributes_setRest (&ex, p, aEncoding, aInput.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
  }

private:
public:
  /**
   * @brief Internal function.
   * @internal
   */
  SignDocTextFieldAttributes (SIGNDOC_TextFieldAttributes *aP) : p (aP) { }

  /**
   * @brief Internal function.
   * @internal
   */
  SIGNDOC_TextFieldAttributes *getImpl () { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  const SIGNDOC_TextFieldAttributes *getImpl () const { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  void setImpl (SIGNDOC_TextFieldAttributes *aP) { SIGNDOC_TextFieldAttributes_delete (p); p  = aP; }

private:
  SIGNDOC_TextFieldAttributes *p;
};

/**
 * @brief One field of a document.
 *
 * Calling member function of this class does not modify the document,
 * use SignDocDocument::setField() to apply your changes to the
 * document or SignDocDocument::addField() to add the field to the
 * document.
 *
 * In PDF documents, a field may have multiple visible "widgets". For
 * instance, a radio button group (radio button field) usually has
 * multiple visible buttons, ie, widgets.
 *
 * A SignDocField object represents the logical field (containing the
 * type, name, value, etc) as well as all its widgets. Each widget has
 * a page number, a coordinate rectangle, and, for some field types,
 * text field attributes.
 *
 * Only one widget of the field is accessible at a time in a
 * SignDocField object; use selectWidget() to select the widget to be
 * operated on.
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
 * button value depends on the f_RadiosInUnison field flag. If that
 * flag is set (it usually is), widgets having the same button value
 * always have the same on/off state. Clicking one of them will turn
 * all of them on. If the f_RadiosInUnison is not set, clicking one
 * widget will put all others (of the same radio button field) into
 * the off state. See getValueIndex() for details.
 *
 * Signature fields have exactly one widget. Fields of other
 * types must have at least one widget.
 *
 * Other fields such as text fields (except for signature fields) also
 * can have multiple widgets, but all of them display the same value.
 */
class SignDocField 
{
public:

public:
  /**
   * @brief Field types.
   *
   * Most field types are supported for PDF documents only.
   */
  enum Type
  {
    t_unknown,              ///< Unknown type.
    t_pushbutton,           ///< Pushbutton (PDF).
    t_check_box,            ///< Check box field (PDF).
    t_radio_button,         ///< Radio button (radio button group) (PDF).
    t_text,                 ///< Text field (PDF).
    t_list_box,             ///< List box (PDF).
    t_signature_digsig,     ///< Digital signature field (Adobe DigSig in PDF, SOFTPRO signature in TIFF).
    t_signature_signdoc,    ///< Digital signature field (traditional SignDoc, no longer supported) (PDF)
    t_combo_box             ///< Combo box (drop-down box) (PDF).
  };

  /**
   * @brief Field flags.
   *
   * See the PDF Reference for the meaning of these flags.
   * Most field flags are supported for PDF documents only.
   *
   * The f_NoToggleToOff flag should be set for all radio button groups.
   * Adobe products seem to ignore this flag being not set.
   *
   * The f_Invisible, f_EnableAddAfterSigning, and f_SinglePage flags
   * cannot be modified.
   *
   * Invisible signature fields (f_Invisible) are invisible (ie, they
   * look as if not inserted) until signed. Warning: signing an invisible
   * signature field in a TIFF file may increase the size of the file
   * substantially.
   *
   * By default, no fields can be inserted into a TIFF document
   * after a signature field has been signed.  The f_EnableAddAfterSigning
   * flag changes this behavior.  (f_EnableAddAfterSigning is ignored
   * for PDF documents.)
   *
   * If the f_EnableAddAfterSigning flag is set, document size
   * increases more during signing this field than when this flaq is
   * not set. Each signature will increase the document size by the
   * initial size of the document (before the first signature was
   * applied), approximately.  That is, the first signature will
   * approximately double the size of the document.
   *
   * Inserting a signature field fails if there already are any
   * signed signature fields that don't have this flag set.
   *
   * By default, signing a signature field signs the complete
   * document, that is, modifications to any page are detected.  For
   * TIFF documents, this behavior can be changed for signature fields
   * that have the f_EnableAddAfterSigning flag set: If the
   * f_SinglePage flag is set, the signature applies only to the page
   * containing the signature field, modifications to other pages
   * won't be detected.  This flag can be used for speeding up
   * verification of signatures.
   *
   * A signature field for which f_EnableAddAfterSigning is not set
   * (in a TIFF document) can only be cleared if no other signature
   * fields that don't have f_EnableAddAfterSigning have been signed
   * after the signature field to be cleared.  Signature fields
   * having f_EnableAddAfterSigning set can always be cleared.
   *
   * @see getFlags(), setFlags(), SignDocDocument::clearSignature()
   */
  enum Flag
  {
    f_ReadOnly          = 1 << 0,  ///< ReadOnly
    f_Required          = 1 << 1,  ///< Required
    f_NoExport          = 1 << 2,  ///< NoExport
    f_NoToggleToOff     = 1 << 3,  ///< NoToggleToOff
    f_Radio             = 1 << 4,  ///< Radio
    f_Pushbutton        = 1 << 5,  ///< Pushbutton
    f_RadiosInUnison    = 1 << 6,  ///< RadiosInUnison

    /**
     * @brief Multiline (for text fields).
     *
     * The value of a text field that has this flag set may contain
     * line breaks encoded as "\r", "\n", or "\r\n".
     *
     * The contents of the text field are top-aligned if this flag is
     * set and vertically centered if this flag is not set.
     */
    f_MultiLine         = 1 << 7,

    f_Password          = 1 << 8,  ///< Password
    f_FileSelect        = 1 << 9,  ///< FileSelect
    f_DoNotSpellCheck   = 1 << 10, ///< DoNotSpellCheck
    f_DoNotScroll       = 1 << 11, ///< DoNotScroll
    f_Comb              = 1 << 12, ///< Comb
    f_RichText          = 1 << 13, ///< RichText
    f_Combo             = 1 << 14, ///< Combo (always set for combo boxes)
    f_Edit              = 1 << 15, ///< Edit (for combo boxes): If this flag is set, the user can enter an arbitrary value.
    f_Sort              = 1 << 16, ///< Sort (for list boxes and combo boxes)
    f_MultiSelect       = 1 << 17, ///< MultiSelect (for list boxes)
    f_CommitOnSelChange = 1 << 18, ///< CommitOnSelChange (for list boxes and combo boxes)
    f_SinglePage        = 1 << 28, ///< Signature applies to the containing page only (TIFF only)
    f_EnableAddAfterSigning = 1 << 29, ///< Signature fields can be inserted after signing this field (TIFF only)
    f_Invisible         = 1 << 30  ///< Invisible (TIFF only)
  };

  /**
   * @brief Annotation flags of a widget.
   *
   * See the PDF Reference for the meaning of these flags.  All these
   * flags are supported for PDF documents only, they are ignored for
   * TIFF documents.
   *
   * @see getWidgetFlags(), setWidgetFlags()
   */
  enum WidgetFlag
  {
    wf_Invisible      = 1 << (1 - 1), ///< do not display non-standard annotation
    wf_Hidden         = 1 << (2 - 1), ///< do not display or print or interact
    wf_Print          = 1 << (3 - 1), ///< print the annotation
    wf_NoZoom         = 1 << (4 - 1), ///< do not scale to match magnification
    wf_NoRotate       = 1 << (5 - 1), ///< do not rotate to match page's rotation
    wf_NoView         = 1 << (6 - 1), ///< do not display or interact
    wf_ReadOnly       = 1 << (7 - 1), ///< do not interact
    wf_Locked         = 1 << (8 - 1), ///< annotation cannot be deleted or modified, but its value can be changed
    wf_ToggleNoView   = 1 << (9 - 1), ///< toggle wf_no_view for certain events
    wf_LockedContents = 1 << (10 - 1) ///< value cannot be changed
  };

  /**
   * @brief Text field justification.
   *
   * @see getJustification(), setJustification()
   */
  enum Justification
  {
    j_none,             ///< Non-text field (justification does not apply).
    j_left,             ///< Left-justified.
    j_center,           ///< Centered.
    j_right             ///< Right-justified.
  };

  /**
   * @brief Fields to be locked when signing this signature field.
   *
   * @see getLockType(), setLockType()
   */
  enum LockType
  {
    lt_na,              ///< Not a signature field.
    lt_none,            ///< Don't lock any fields.
    lt_all,             ///< Lock all fields in the document.
    lt_include,         ///< Lock all lock fields specified by addLockField() etc.
    lt_exclude          ///< Lock all fields except the lock fields specified by addLockField() etc.
  };

  /**
   * @brief Bit masks for getCertSeedValueFlags() and setCertSeedValueFlags().
   */
  enum CertSeedValueFlag
  {
    csvf_SubjectCert = 0x01,    // Adobe bit 1
    csvf_IssuerCert  = 0x02,    // Adobe bit 2
    csvf_Policy      = 0x04,    // Adobe bit 3
    csvf_SubjectDN   = 0x08,    // Adobe bit 4
    csvf_KeyUsage    = 0x20,    // Adobe bit 6
    csvf_URL         = 0x40     // Adobe bit 7
  };

public:
  /**
   * @brief Constructor.
   *
   * The new SignDocField object will have one widget.
   */
  SignDocField ()
    : p (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_Field_new (&ex);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Copy constructor.
   *
   * @param[in] aSource  The object to be copied.
   */
  SignDocField (const SignDocField &aSource)
    : p (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_Field_clone (&ex, aSource.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Destructor.
   */
  ~SignDocField ()
  {
    SIGNDOC_Field_delete (p);
  }

  /**
   * @brief Assignment operator.
   *
   * @param[in] aSource  The source object.
   */
  SignDocField &operator= (const SignDocField &aSource)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_assign (&ex, p, aSource.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return *this;
  }

  /**
   * @brief Efficiently swap this object with another one.
   *
   * @param[in] aOther  The other object.
   */
  void swap (SignDocField &aOther)
  {
    std::swap (p, aOther.p);
  }

  /**
   * @brief Get the name of the field.
   *
   * This function throws de::softpro::spooc::EncodingError if
   * the name cannot be represented using the specified encoding.
   *
   * @param[in] aEncoding  The encoding to be used for the return value.
   *
   * @return The name of the field.
   *
   * @see getAlternateName(), getMappingName(), getNameUTF8(), setName()
   */
  std::string getName (Encoding aEncoding) const
  {
    SIGNDOC_Exception *ex = NULL;
    std::string r;
    char *s = SIGNDOC_Field_getName (&ex, p, aEncoding);
    if (ex != NULL) SignDoc_throw (ex);
    try
      {
        r = s;
      }
    catch (...)
      {
        SIGNDOC_free (s);
        throw;
      }
    SIGNDOC_free (s);
    return r;
  }

  /**
   * @brief Get the name of the field as UTF-8-encoded C string.
   *
   * @return The name of the field.  This pointer will become invalid
   *         when setName() is called or this object is destroyed.
   */
  const char *getNameUTF8 () const
  {
    SIGNDOC_Exception *ex = NULL;
    const char *r;
    r = SIGNDOC_Field_getNameUTF8 (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the name of the field.
   *
   * Different document types impose different
   * restrictions on field names. PDF fields have hierarchical field names
   * with components separated by dots.
   *
   * SignDocDocument::setField() operates on the
   * field having a fully-qualified name which equals the name set by
   * this function. In consequence, SignDocDocument::setField() cannot
   * change the name of a field.
   *
   * This function throws de::softpro::spooc::EncodingError if the
   * name is not correctly encoded according to the specified
   * encoding.
   *
   * @param[in] aEncoding  The encoding of @a aName.
   * @param[in] aName      The name of the field.
   *
   * @see getName(), getNameUTF8(), setAlternateName(), setMappingName()
   */
  void setName (Encoding aEncoding, const std::string &aName)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setName (&ex, p, aEncoding, aName.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Set the name of the field.
   *
   * Different document types impose different
   * restrictions on field names. PDF fields have hierarchical field names
   * with components separated by dots.
   *
   * SignDocDocument::setField() operates on the
   * field having a fully-qualified name which equals the name set by
   * this function. In consequence, SignDocDocument::setField() cannot
   * change the name of a field.
   *
   * @param[in] aName      The name of the field.
   *
   * @see getName(), getNameUTF8(), setAlternateName(), setMappingName()
   */
  void setName (const wchar_t *aName)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setNameW (&ex, p, aName);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Get the alternate name of the field.
   *
   * The alternate name (if present) should be used for displaying the
   * field name in a user interface. Currently, only PDF documents
   * support alternate field names.
   * 
   * This function throws de::softpro::spooc::EncodingError if
   * the name cannot be represented using the specified encoding.
   *
   * @param[in] aEncoding  The encoding to be used for the return value.
   *
   * @return The alternate name of the field, empty if the field
   *         does not have an alternate name.
   *
   * @see getMappingName(), getName(), setAlternateName()
   */
  std::string getAlternateName (Encoding aEncoding) const
  {
    SIGNDOC_Exception *ex = NULL;
    std::string r;
    char *s = SIGNDOC_Field_getAlternateName (&ex, p, aEncoding);
    if (ex != NULL) SignDoc_throw (ex);
    try
      {
        r = s;
      }
    catch (...)
      {
        SIGNDOC_free (s);
        throw;
      }
    SIGNDOC_free (s);
    return r;
  }

  /**
   * @brief Set the alternate name of the field.
   *
   * The alternate name (if present) should be used for displaying the
   * field name in a user interface. Currently, only PDF documents
   * support alternate field names.
   *
   * This function throws de::softpro::spooc::EncodingError if the
   * name is not correctly encoded according to the specified
   * encoding.
   *
   * @param[in] aEncoding  The encoding of @a aName.
   * @param[in] aName      The alternate name of the field, empty to
   *                       remove any alternate field name.
   *
   * @see getAlternateName(), getName(), setMappingName(), setName()
   */
  void setAlternateName (Encoding aEncoding, const std::string &aName)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setAlternateName (&ex, p, aEncoding, aName.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Get the mapping name of the field.
   *
   * The mapping name (if present) should be used for exporting field
   * data. Currently, only PDF documents support mapping field names.
   * 
   * This function throws de::softpro::spooc::EncodingError if
   * the name cannot be represented using the specified encoding.
   *
   * @param[in] aEncoding  The encoding to be used for the return value.
   *
   * @return The mapping name of the field, empty if the field
   *         does not have an mapping name.
   *
   * @see getAlternateName(), getName(), setMappingName()
   */
  std::string getMappingName (Encoding aEncoding) const
  {
    SIGNDOC_Exception *ex = NULL;
    std::string r;
    char *s = SIGNDOC_Field_getMappingName (&ex, p, aEncoding);
    if (ex != NULL) SignDoc_throw (ex);
    try
      {
        r = s;
      }
    catch (...)
      {
        SIGNDOC_free (s);
        throw;
      }
    SIGNDOC_free (s);
    return r;
  }

  /**
   * @brief Set the mapping name of the field.
   *
   * The mapping name (if present) should be used for exporting field
   * data. Currently, only PDF documents support mapping field names.
   *
   * This function throws de::softpro::spooc::EncodingError if the
   * name is not correctly encoded according to the specified
   * encoding.
   *
   * @param[in] aEncoding  The encoding of @a aName.
   * @param[in] aName      The mapping name of the field, empty to
   *                       remove any mapping name.
   *
   * @see getMappingName(), getName(), setAlternateName(), setName()
   */
  void setMappingName (Encoding aEncoding, const std::string &aName)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setMappingName (&ex, p, aEncoding, aName.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Get the number of values of the field.
   *
   * Pushbutton fields and signature fields don't have a value,
   * list boxes can have multiple values selected if f_MultiSelect
   * is set.
   *
   * @return The number of values.
   *
   * @see getChoiceCount(), getValue()
   */
  int getValueCount () const
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_Field_getValueCount (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get a value of the field.
   *
   * Pushbutton fields and signature fields don't have a value, list
   * boxes can have multiple values selected if f_MultiSelect is set.
   *
   * Line breaks for multiline text fields (ie, text fields with flag
   * f_MultiLine set) are encoded as "\r", "\n", or "\r\n".
   *
   * This function throws de::softpro::spooc::EncodingError if
   * the value cannot be represented using the specified encoding.
   *
   * @param[in] aEncoding  The encoding to be used for the return value.
   * @param[in] aIndex     0-based index of the value.
   *
   * @return The selected value of the field or an empty string
   *         if the index is out of range.
   *
   * @see addValue(), clearValues(), getChoiceExport(), getChoiceValue(), getValueCount(), getValueIndex(), getValueUTF8(), removeValue(), setValue()
   */
  std::string getValue (Encoding aEncoding, int aIndex) const
  {
    SIGNDOC_Exception *ex = NULL;
    std::string r;
    char *s = SIGNDOC_Field_getValue (&ex, p, aEncoding, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    try
      {
        r = s;
      }
    catch (...)
      {
        SIGNDOC_free (s);
        throw;
      }
    SIGNDOC_free (s);
    return r;
  }

  /**
   * @brief Get a value of the field.
   *
   * Pushbutton fields and signature fields don't have a value, list
   * boxes can have multiple values selected if f_MultiSelect is set.
   *
   * Line breaks for multiline text fields (ie, text fields with flag
   * f_MultiLine set) are encoded as "\r", "\n", or "\r\n".
   *
   * @param[in] aIndex     0-based index of the value.
   *
   * @return The selected value of the field or an empty string
   *         if the index is out of range.  This pointer will become invalid
   *         when addValue(), clearValues(), removeValue(), or setValue()
   *         is called or this object is destroyed.
   *
   * @see addValue(), clearValues(), getValue(), getValueCount(), getValueIndex(), setValue()
   */
  const char *getValueUTF8 (int aIndex) const
  {
    SIGNDOC_Exception *ex = NULL;
    const char *r;
    r = SIGNDOC_Field_getValueUTF8 (&ex, p, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Clear the values.
   *
   * After calling this function, getValueCount() will return 0
   * and getValueIndex() will return -1.
   *
   * @see addValue(), getValueCount(), getValueIndex(), removeValue()
   */
  void clearValues ()
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_clearValues (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Add a value to the field.
   *
   * Pushbutton fields and signature fields don't have a value, list
   * boxes can have multiple values selected if f_MultiSelect is set.
   *
   * Line breaks for multiline text fields (ie, text fields with flag
   * f_MultiLine set) are encoded as "\r", "\n", or "\r\n". The behavior
   * for values containing line breaks is undefined if the f_MultiLine
   * flag is not set.
   *
   * After calling this function, getValueIndex() will return -1.
   *
   * This function throws de::softpro::spooc::EncodingError if the
   * value is not correctly encoded according to the specified
   * encoding.
   *
   * @param[in] aEncoding  The encoding of @a aValue.
   * @param[in] aValue     The value to be added.
   *                       Complex scripts are supported,
   *                       see @ref signdocshared_complex_scripts.
   *
   * @see clearValues(), getValue(), getValueIndex(), getValueUTF8(), setValue()
   */
  void addValue (Encoding aEncoding, const std::string &aValue)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_addValue (&ex, p, aEncoding, aValue.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Set a value of the field.
   *
   * Pushbutton fields and signature fields don't have a value, list
   * boxes can have multiple values selected if f_MultiSelect is set.
   *
   * After calling this function, getValueIndex() will return -1.
   *
   * Line breaks for multiline text fields (ie, text fields with flag
   * f_MultiLine set) are encoded as "\r", "\n", or "\r\n". The behavior
   * for values containing line breaks is undefined if the f_MultiLine
   * flag is not set.
   *
   * This function throws de::softpro::spooc::EncodingError if the
   * value is not correctly encoded according to the specified
   * encoding.
   *
   * @param[in] aIndex     The 0-based index of the value to be set.
   *                       If @a aIndex equals the current number of
   *                       values, the value will be added.
   * @param[in] aEncoding  The encoding of @a aValue.
   * @param[in] aValue     The value to be set. Complex scripts are supported,
   *                       see @ref signdocshared_complex_scripts.
   *
   * @return true if successful, false if @a aIndex is out of range.
   *
   * @see clearValues(), clickButton(), getValue(), getValueIndex(), getValueUTF8(), setValueIndex()
   */
  bool setValue (int aIndex, Encoding aEncoding, const std::string &aValue)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_setValueByIndex (&ex, p, aIndex, aEncoding, aValue.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the value of the field.
   *
   * Pushbutton fields and signature fields don't have a value, list
   * boxes can have multiple values selected if f_MultiSelect is set.
   *
   * Line breaks for multiline text fields (ie, text fields with flag
   * f_MultiLine set) are encoded as "\r", "\n", or "\r\n". The behavior
   * for values containing line breaks is undefined if the f_MultiLine
   * flag is not set.
   *
   * Calling this function is equivalent to calling clearValues() and
   * addValue(), but the encoding of @a aValue is checked before
   * modifying this object.
   *
   * After calling this function, getValueIndex() will return -1.
   *
   * This function throws de::softpro::spooc::EncodingError if the
   * value is not correctly encoded according to the specified
   * encoding.
   *
   * @param[in] aEncoding  The encoding of @a aValue.
   * @param[in] aValue     The value to be set. Complex scripts are supported,
   *                       see @ref signdocshared_complex_scripts.
   *
   * @see clearValues(), clickButton(), getValue(), getValueIndex(), getValueUTF8(), setValueIndex()
   */
  void setValue (Encoding aEncoding, const std::string &aValue)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setValue (&ex, p, aEncoding, aValue.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Remove a value from the field.
   *
   * After calling this function, getValueIndex() will return -1.
   *
   * @param[in] aIndex     The 0-based index of the value to be removed.
   *
   * @return true if successful, false if @a aIndex is out of range.
   *
   * @see clearValues(), getValue(), getValueIndex(), getValueUTF8()
   */
  bool removeValue (int aIndex)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_removeValue (&ex, p, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the current value index.
   *
   * Radio button groups and check box fields can have multiple
   * widgets having the same button value. For check box fields
   * and radio buttons without f_RadiosInUnison set, specifying
   * the selected button by value string is not possible in that
   * case. A 0-based value index can be used to find out which
   * button is selected or to select a button.
   *
   * Radio button groups and check box fields need not use a value
   * index; in fact, they usually don't.
   *
   * SignDocDocument::addField() and SignDocDocument::setField()
   * update the value index if the value of a radio button group
   * or check box field is selected by string (ie, setValue())
   * and the field has ambiguous button names.
   *
   * The "Off" value never has a value index.
   *
   * @note addValue(), clearValues(), and setValue() make the value index
   *       unset (ie, getValueIndex() will return -1).
   *
   * @return the 0-based value index or -1 if the value index is not set.
   *
   * @see clickButton(), getValue(), setValueIndex()
   */
  int getValueIndex () const
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_Field_getValueIndex (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the value index.
   *
   * Radio button groups and check box fields can have multiple
   * widgets having the same button value. For check box fields
   * and radio buttons without f_RadiosInUnison set, specifying
   * the selected button by value string is ambiguous in that
   * case. A 0-based value index can be used to find out which
   * button is selected or to select a button.
   *
   * Radio button groups and check box fields need not use a value
   * index; in fact, they usually don't. However, you can always
   * set a value index for radio button groups and check box fields.
   *
   * If the value index is non-negative, SignDocDocument::addField()
   * and SignDocDocument::setField() will use the value index instead
   * of the string value set by setValue().
   *
   * Calling setValueIndex() doesn't affect the return value of
   * getValue() as the value index is used by
   * SignDocDocument::addField() and SignDocDocument::setField()
   * only. However, successful calls to SignDocDocument::addField()
   * and SignDocDocument::setField() will make getValue() return the
   * selected value.
   *
   * For radio button groups with f_RadiosInUnison set and non-unique
   * button values and for check box fields with non-unique button
   * values, for each button value, the lowest index having that
   * button value is the canonical one. After calling
   * SignDocDocument::addField() or SignDocDocument::setField(),
   * getValueIndex() will return the canonical value index.
   *
   * Don't forget to update the value index when adding or removing
   * widgets!
   *
   * SignDocDocument::addField() and SignDocDocument::setField() will
   * fail if the value index is non-negative for fields other than
   * radio button groups and check box fields.
   *
   * The "Off" value never has a value index.
   *
   * @note addValue(), clearValues(), and setValue() make the value index
   *       unset (ie, getValueIndex() will return -1). Therefore, you
   *       don't have to call setValueIndex(-1) to make setValue() take
   *       effect on SignDocDocument::addField() and
   *       SignDocDocument::setField().
   *
   * @param[in] aIndex  the 0-based value index or -1 to make the value
   *                    index unset.
   *
   * @see clickButton(), getValue(), getValueIndex(), setValue()
   */
  void setValueIndex (int aIndex)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setValueIndex (&ex, p, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Click a check box or a radio button.
   *
   * This function updates both the value (see setValue()) and the
   * value index (see setValueIndex()) based on the current
   * (non-committed) state of the SignDocField object (not looking at
   * the state of the field in the document). It does nothing for
   * other field types.
   *
   * Adobe products seem to ignore f_NoToggleToOff flag being not set,
   * this function behaves the same way (ie, as if f_NoToggleToOff was
   * set).
   *
   * @note A return value of false does not indicate an error!
   *
   * @param[in] aIndex  The 0-based index of the widget being clicked.
   *
   * @return true if anything has been changed, false if nothing
   *         has been changed (wrong field type, @a aIndex out of
   *         range, radio button already active).
   */
  bool clickButton (int aIndex)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_clickButton (&ex, p, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the number of available choices for a list box or combo box.
   *
   * List boxes and combo boxes can have multiple possible choices.
   * For other field types, this function returns 0.
   *
   * @return The number of available choices or 0 if not supported for
   *         the type of this field.
   *
   * @see getButtonValue(), getChoiceExport(), getChoiceValue(), getValueCount()
   */
  int getChoiceCount () const
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_Field_getChoiceCount (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get an available choice of a list box or combo box.
   *
   * List boxes and combo boxes can have multiple possible
   * choices. Each choice has a value (which will be displayed) and an
   * export value (which is used for exporting the value of the
   * field). Usually, both values are identical. This function returns
   * one choice value, use getChoiceExport() to get the associated
   * export value.
   *
   * This function throws de::softpro::spooc::EncodingError if
   * the value cannot be represented using the specified encoding.
   *
   * @note getValue() and setValue() use the export value.
   *
   * @param[in] aEncoding  The encoding to be used for the return value.
   * @param[in] aIndex     0-based index of the choice value.
   *
   * @return The selected choice value of the field or an empty string
   *         if the index is out of range.
   *
   * @see addChoice(), clearChoices(), getChoiceExport(), getChoiceValueUTF8(), getChoiceCount(), getButtonValue(), removeChoice(), setChoice()
   */
  std::string getChoiceValue (Encoding aEncoding, int aIndex) const
  {
    SIGNDOC_Exception *ex = NULL;
    std::string r;
    char *s = SIGNDOC_Field_getChoiceValue (&ex, p, aEncoding, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    try
      {
        r = s;
      }
    catch (...)
      {
        SIGNDOC_free (s);
        throw;
      }
    SIGNDOC_free (s);
    return r;
  }

  /**
   * @brief Get an available choice of a list box or combo box.
   *
   * List boxes and combo boxes can have multiple possible
   * choices. Each choice has a value (which will be displayed) and an
   * export value (which is used for exporting the value of the
   * field). Usually, both values are identical. This function returns
   * one choice value, use getChoiceExportUTF8() to get the associated
   * export value.
   *
   * @note getValue() and setValue() use the export value.
   *
   * @param[in] aIndex     0-based index of the choice value.
   *
   * @return The selected choice value of the field or an empty string
   *         if the index is out of range.  This pointer will become
   *         invalid when addChoice(), clearChoices(),
   *         removeChoice(), or setChoice() is called or this
   *         object is destroyed.
   *
   * @see addChoice(), clearChoices(), getChoiceCount(), getChoiceExportUTF8(), getChoiceValue(), getButtonValueUTF8(), setChoice()
   */
  const char *getChoiceValueUTF8 (int aIndex) const
  {
    SIGNDOC_Exception *ex = NULL;
    const char *r;
    r = SIGNDOC_Field_getChoiceValueUTF8 (&ex, p, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the export value for an available choice of a list box or combo box.
   *
   * List boxes and combo boxes can have multiple possible
   * choices. Each choice has a value (which will be displayed) and an
   * export value (which is used for exporting the value of the
   * field).  Usually, both values are identical. This function
   * returns one export value, use getChoiceValue() to get the
   * associated choice value.
   *
   * This function throws de::softpro::spooc::EncodingError if
   * the value cannot be represented using the specified encoding.
   *
   * @note getValue() and setValue() use the export value.
   *
   * @param[in] aEncoding  The encoding to be used for the return value.
   * @param[in] aIndex     0-based index of the export value.
   *
   * @return The selected export value of the field or an empty string
   *         if the index is out of range.
   *
   * @see addChoice(), clearChoices(), getChoiceCount(), getChoiceExportUTF8(), getChoiceValue(), getButtonValue(), removeChoice(), setChoice()
   */
  std::string getChoiceExport (Encoding aEncoding, int aIndex) const
  {
    SIGNDOC_Exception *ex = NULL;
    std::string r;
    char *s = SIGNDOC_Field_getChoiceExport (&ex, p, aEncoding, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    try
      {
        r = s;
      }
    catch (...)
      {
        SIGNDOC_free (s);
        throw;
      }
    SIGNDOC_free (s);
    return r;
  }

  /**
   * @brief Get the export value for an available choice of a list box or combo box.
   *
   * List boxes and combo boxes can have multiple possible
   * choices. Each choice has a value (which will be displayed) and an
   * export value (which is used for exporting the value of the
   * field).  Usually, both values are identical. This function
   * returns one export value, use getChoiceValue() to get the
   * associated choice value.
   *
   * @note getValue() and setValue() use the export value.
   *
   * @param[in] aIndex     0-based index of the choice value.
   *
   * @return The selected export value of the field or an empty string
   *         if the index is out of range.  This pointer will become
   *         invalid when addChoice(), clearChoices(),
   *         removeChoice(), or setChoice() is called or this
   *         object is destroyed.
   *
   * @see addChoice(), clearChoices(), getChoiceCount(), getChoiceExport(), getChoiceValueUTF8(), getButtonValueUTF8(), setChoice()
   */
  const char *getChoiceExportUTF8 (int aIndex) const
  {
    SIGNDOC_Exception *ex = NULL;
    const char *r;
    r = SIGNDOC_Field_getChoiceExportUTF8 (&ex, p, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Clear the choices of a list box or combo box.
   *
   * After calling this function, getChoiceCount() will return 0.
   *
   * @see addChoice(), getChoiceCount(), removeChoice(), setButtonValue()
   */
  void clearChoices ()
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_clearChoices (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Add a choice to a list box or combo box.
   *
   * This function uses the choice value as export value.
   *
   * This function throws de::softpro::spooc::EncodingError if the
   * value is not correctly encoded according to the specified
   * encoding.
   *
   * @note getValue() and setValue() use the export value.
   *
   * @param[in] aEncoding  The encoding of @a aValue.
   * @param[in] aValue     The choice value and export value to be added.
   *                       Complex scripts are supported,
   *                       see @ref signdocshared_complex_scripts.
   *
   * @see clearChoices(), getChoiceExport(), getChoiceValue(), setChoice(), setButtonValue()
   */
  void addChoice (Encoding aEncoding, const std::string &aValue)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_addChoice (&ex, p, aEncoding, aValue.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Add a choice to a list box or combo box.
   *
   * This function throws de::softpro::spooc::EncodingError if the
   * value is not correctly encoded according to the specified
   * encoding.
   *
   * @note getValue() and setValue() use the export value.
   *
   * @param[in] aEncoding  The encoding of @a aValue and @a aExport.
   * @param[in] aValue     The choice value to be added.
   *                       Complex scripts are supported,
   *                       see @ref signdocshared_complex_scripts.
   * @param[in] aExport    The export value to be added.
   *
   * @see clearChoices(), getChoiceExport(), getChoiceValue(), setChoice(), setButtonValue()
   */
  void addChoice (Encoding aEncoding, const std::string &aValue,
                  const std::string &aExport)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_addChoiceWithExport (&ex, p, aEncoding, aValue.c_str (), aExport.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Set a choice value of a list box or combo box.
   *
   * This function uses the choice value as export value.
   *
   * This function throws de::softpro::spooc::EncodingError if the
   * value is not correctly encoded according to the specified
   * encoding.
   *
   * @note getValue() and setValue() use the export value.
   *
   * @param[in] aIndex     The 0-based index of the choice to be set.
   *                       If @a aIndex equals the current number of
   *                       choice, the value will be added.
   * @param[in] aEncoding  The encoding of @a aValue.
   * @param[in] aValue     The choice value and export value to be set.
   *                       Complex scripts are supported,
   *                       see @ref signdocshared_complex_scripts.
   *
   * @return true if successful, false if @a aIndex is out of range.
   *
   * @see clearChoices(), getChoiceExport(), getChoiceValue(), setButtonValue()
   */
  bool setChoice (int aIndex, Encoding aEncoding, const std::string &aValue)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_setChoice (&ex, p, aIndex, aEncoding, aValue.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set a choice value of a list box or combo box.
   *
   * This function throws de::softpro::spooc::EncodingError if the
   * value is not correctly encoded according to the specified
   * encoding.
   *
   * @note getValue() and setValue() use the export value.
   *
   * @param[in] aIndex     The 0-based index of the choice to be set.
   *                       If @a aIndex equals the current number of
   *                       choice, the value will be added.
   * @param[in] aEncoding  The encoding of @a aValue and @a aExport.
   * @param[in] aValue     The choice value to be set.
   *                       Complex scripts are supported,
   *                       see @ref signdocshared_complex_scripts.
   * @param[in] aExport    The export value to be set.
   *
   * @return true if successful, false if @a aIndex is out of range.
   *
   * @see clearChoices(), getChoiceExport(), getChoiceValue(), setButtonValue()
   */
  bool setChoice (int aIndex, Encoding aEncoding, const std::string &aValue,
                  const std::string &aExport)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_setChoiceWithExport (&ex, p, aIndex, aEncoding, aValue.c_str (), aExport.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Remove a choice from a list box or combo box.
   *
   * @param[in] aIndex     The 0-based index of the choice to be removed.
   *
   * @return true if successful, false if @a aIndex is out of range.
   *
   * @see addChoice(), clearChoices()
   */
  bool removeChoice (int aIndex)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_removeChoice (&ex, p, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the type of the field.
   *
   * The default value is #t_unknown.
   *
   * @return The type of the field.
   *
   * @see setType()
   */
  Type getType () const
  {
    SIGNDOC_Exception *ex = NULL;
    Type r;
    r = (Type)SIGNDOC_Field_getType (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the type of the field.
   *
   * The default value is #t_unknown.
   *
   * @param[in] aType  The type of the field.
   *
   * @see getType()
   */
  void setType (Type aType)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setType (&ex, p, aType);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Get the flags of the field, see enum #Flag.
   *
   * The default value is 0.
   *
   * @return The flags of the field.
   *
   * @see setFlags()
   */
  int getFlags () const
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_Field_getFlags (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the flags of the field, see enum #Flag.
   *
   * The default value is 0.
   *
   * @param[in] aFlags  The flags of the field.
   *
   * @see getFlags()
   */
  void setFlags (int aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setFlags (&ex, p, aFlags);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Check if this field is a signed signature field.
   *
   * This function is much more efficient than
   * SignDocDocument::verifySignature().
   *
   * @return true if this field is a signed signature field, false
   *         if this field is not a signature field or if this
   *         field is a signature field that is not signed.
   *
   * @see SignDocDocument::verifySignature()
   */
  bool isSigned () const
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_isSigned (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Check if this signature field is currently clearable.
   *
   * For some document formats (TIFF), signatures may only be cleared in
   * the reverse order of signing (LIFO).  Use this function to find out
   * whether the signature field is currently clearable (as determined
   * by SignDocDocument::getField() or SignDocDocument::getFields(),
   *
   * @note The value returned by this function does not change over
   * the lifetime of this object and therefore may not reflect the
   * current state if signature fields have been signed or cleared
   * since this object was created.
   *
   * @return true iff this is a signature field that can be cleared now.
   *
   * @see SignDocDocument::getField(), SignDocDocument::getFields()
   */
  bool isCurrentlyClearable () const
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_isCurrentlyClearable (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get maximum length of text field.
   *
   * The default value is -1.
   *
   * @return  The maximum length of text fields or -1 if the field is
   *          not a text field or if the text field does not have a
   *          maximum length.
   *
   * @see setMaxLen()
   */
  int getMaxLen () const
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_Field_getMaxLen (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set maximum length of text fields.
   *
   * @param[in] aMaxLen  The maximum length (in characters) of the text field
   *                     or -1 for no maximum length.
   *
   * @see getMaxLen()
   */
  void setMaxLen (int aMaxLen)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setMaxLen (&ex, p, aMaxLen);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Get the index of the choice to be displayed in the first
   *        line of a list box.
   *
   * The default value is 0.
   *
   * @return The index of the choice to be displayed in the first line
   *         of a list box or 0 for other field types.
   *
   * @see getChoiceValue(), setTopIndex()
   */
  int getTopIndex () const
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_Field_getTopIndex (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the index of the choice to be displayed in the first
   *        line of a list box.
   *
   * This value is ignored for other field types.
   *
   * @param[in] aTopIndex  The index of the choice to be displayed in the
   *                       first line of a list box.
   *
   * @see getChoiceValue(), getTopIndex()
   */
  void setTopIndex (int aTopIndex)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setTopIndex (&ex, p, aTopIndex);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Get the index of the currently selected widget.
   *
   * Initially, the first widget is selected (ie, this function returns
   * 0). However, there is an exception to this rule: SignDocField
   * objects created by SignDocDocument::getFieldsOfPage() can have a
   * different widget selected initially for PDF documents.
   *
   * @return The 0-based index of the currently selected widget.
   *
   * @see selectWidget()
   */
  int getWidget () const
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_Field_getWidget (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the number of widgets.
   *
   * Signature fields always have exactly one widget.  Radio button
   * fields (radio button groups) usually have one widget per button (but can
   * have more widgets than buttons by having multiple widgets for some or
   * all buttons).
   *
   * @return The number of widgets for this field.
   */
  int getWidgetCount () const
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_Field_getWidgetCount (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Select a widget.
   *
   * This function selects the widget to be used by getWidgetFlags(),
   * getPage(), getLeft(), getBottom(), getRight(), getTop(),
   * getButtonValue(), getJustification(), getRotation(),
   * getTextFieldAttributes(), setWidgetFlags(), setPage(), setLeft(),
   * setBottom(), setRight(), setTop(), setButtonValue(),
   * setJustification(), setRotation(), and setTextFieldAttributes().
   *
   * @param[in] aIndex  0-based index of the widget.
   *
   * @return true iff successful.
   *
   * @see clickButton(), getWidgetCount()
   */
  bool selectWidget (int aIndex)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_selectWidget (&ex, p, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Add a widget to the field.
   *
   * The new widget will be added at the end, ie, calling getWidgetCount()
   * <b>before</b> calling addWidget() yields the index of the widget that
   * will be added.
   *
   * After adding a widget, the new widget will be selected.  You must set
   * the page number and the coordinates in the new widget before calling
   * SignDocDocument::addField() or SignDocDocument::setField().
   *
   * @return true iff successful.
   *
   * @see addChoice(), getWidget(), getWidgetCount(), insertWidget(), removeWidget(), selectWidget()
   */
  bool addWidget ()
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_addWidget (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Add a widget to the field in front of another widget.
   *
   * The new widget will be inserted at the specified index, ie, the
   * index of the new widget will be @a aIndex.
   *
   * After adding a widget, the new widget will be selected.  You must set
   * the page number and the coordinates in the new widget before calling
   * SignDocDocument::addField() or SignDocDocument::setField().
   *
   * @param[in] aIndex  0-based index of the widget in front of which
   *                    the new widget shall be inserted. You can pass
   *                    the current number of widgets as returned by
   *                    getWidgetCount() to add the new widget to the end
   *                    as addWidget() does.
   *
   * @return true iff successful.
   *
   * @see addWidget(), getWidget(), getWidgetCount(), removeWidget(), selectWidget(), setValueIndex
   */
  bool insertWidget (int aIndex)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_insertWidget (&ex, p, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Remove a widget from the field.
   *
   * This function fails when there is only one widget. That is, a field
   * always has at least one widget.
   *
   * If the currently selected widget is removed, the following rules apply:
   * - When removing the last widget (the one with index getWidgetCount()-1),
   * the predecessor of the removed widget will be selected.
   * - Otherwise, the index of the selected widget won't change, ie,
   * the successor of the removed widget will be selected.
   * .
   *
   * If the widget to be removed is not selected, the currently selected
   * widget will remain selected.
   *
   * All widgets having an index greater than @a aIndex will have their
   * index decremented by one.
   *
   * @param[in] aIndex  0-based index of the widget to remove.
   *
   * @return true iff successful.
   *
   * @see addWidget(), getWidget(), getWidgetCount(), insertWidget(), selectWidget(), setValueIndex
   */
  bool removeWidget (int aIndex)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_removeWidget (&ex, p, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the annotation flags of the widget, see enum #WidgetFlag.
   *
   * The default value is wf_Print.  The annotation flags are used for
   * PDF documents only.  Currently, the semantics of the annotation
   * flags are ignored by this software (ie, the flags are stored in
   * the document, but they don't have any meaning to this software).
   *
   * @return The annotation flags of the widget.
   *
   * @see selectWidget(), setWidgetFlags()
   */
  int getWidgetFlags () const
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_Field_getWidgetFlags (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the annotation flags of the widget, see enum #WidgetFlag.
   *
   * The default value is wf_Print.  The annotation flags are used for
   * PDF documents only.  Currently, the semantics of the annotation
   * flags are ignored by this software (ie, the flags are stored in
   * the document, but they don't have any meaning to this software).
   *
   * @param[in] aFlags  The annotation flags of the widget.
   *
   * @see getWidgetFlags(), selectWidget()
   */
  void setWidgetFlags (int aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setWidgetFlags (&ex, p, aFlags);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Get the page number.
   *
   * This function returns the index of the page on which this field
   * occurs (1 for the first page), or 0 if the page number is
   * unknown.
   *
   * @return The 1-based page number or 0 if the page number is unknown.
   *
   * @see selectWidget(), setPage()
   */
  int getPage () const
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_Field_getPage (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the page number.
   *
   * This function sets the index of the page on which this field
   * occurs (1 for the first page).
   *
   * By calling SignDocDocument::getField(), setPage(), and
   * SignDocDocument::setField(), you can move a field's widget to
   * another page but be careful because the two pages may have
   * different conversion factors, see
   * SignDocDocument::getConversionFactors().
   *
   * @param[in] aPage  The 1-based page number of the field.
   *
   * @see getPage(), selectWidget()
   */
  void setPage (int aPage)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setPage (&ex, p, aPage);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Get the left coordinate.
   *
   * The origin is in the bottom left corner of the page, see
   * @ref signdocshared_coordinates.
   *
   * @return The left coordinate.
   *
   * @see getBottom(), getRight(), getTop(), selectWidget(), setLeft()
   */
  double getLeft () const
  {
    SIGNDOC_Exception *ex = NULL;
    double r;
    r = SIGNDOC_Field_getLeft (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the left coordinate.
   *
   * The origin is in the bottom left corner of the page, see
   * @ref signdocshared_coordinates.
   *
   * @param[in] aLeft  The left coordinate.
   *
   * @see getLeft(), selectWidget(), setBottom(), setRight(), setTop(), SignDocDocument::sff_move
   */
  void setLeft (double aLeft)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setLeft (&ex, p, aLeft);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Get the bottom coordinate.
   *
   * The origin is in the bottom left corner of the page, see
   * @ref signdocshared_coordinates.
   *
   * @return The bottom coordinate.
   *
   * @see getLeft(), getRight(), getTop(), selectWidget(), setBottom()
   */
  double getBottom () const
  {
    SIGNDOC_Exception *ex = NULL;
    double r;
    r = SIGNDOC_Field_getBottom (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the bottom coordinate.
   *
   * The origin is in the bottom left corner of the page, see
   * @ref signdocshared_coordinates.
   *
   * @param[in] aBottom  The bottom coordinate.
   *
   * @see getBottom(), selectWidget(), setLeft(), setRight(), setTop(), SignDocDocument::sff_move
   */
  void setBottom (double aBottom)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setBottom (&ex, p, aBottom);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Get the right coordinate.
   *
   * The origin is in the bottom left corner of the page, see
   * @ref signdocshared_coordinates.
   * If coordinates are given in pixels (this is true for TIFF documents),
   * this coordinate is exclusive.
   *
   * @return The right coordinate.
   *
   * @see getBottom(), getLeft(), getTop(), selectWidget(), setRight()
   */
  double getRight () const
  {
    SIGNDOC_Exception *ex = NULL;
    double r;
    r = SIGNDOC_Field_getRight (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the right coordinate.
   *
   * The origin is in the bottom left corner of the page, see
   * @ref signdocshared_coordinates.
   * If coordinates are given in pixels (this is true for TIFF documents),
   * this coordinate is exclusive.
   *
   * @param[in] aRight  The right coordinate.
   *
   * @see getRight(), selectWidget(), setBottom(), setLeft(), setTop(), SignDocDocument::sff_move
   */
  void setRight (double aRight)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setRight (&ex, p, aRight);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Get the top coordinate.
   *
   * The origin is in the bottom left corner of the page, see
   * @ref signdocshared_coordinates.
   * If coordinates are given in pixels (this is true for TIFF documents),
   * this coordinate is exclusive.
   *
   * @return The top coordinate.
   *
   * @see getBottom(), getLeft(), getRight(), selectWidget(), setTop()
   */
  double getTop () const
  {
    SIGNDOC_Exception *ex = NULL;
    double r;
    r = SIGNDOC_Field_getTop (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the top coordinate.
   *
   * The origin is in the bottom left corner of the page, see
   * @ref signdocshared_coordinates.
   * If coordinates are given in pixels (this is true for TIFF documents),
   * this coordinate is exclusive.
   *
   * @param[in] aTop  The top coordinate.
   *
   * @see getTop(), selectWidget(), setBottom(), setLeft(), setRight(), SignDocDocument::sff_move
   */
  void setTop (double aTop)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setTop (&ex, p, aTop);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Get the button value of a widget of a radio button group or check box.
   *
   * Usually, different radio buttons (widgets) of a radio button group
   * (field) have different values. The radio button group has a value
   * (returned by getValue()) which is either "Off" or one of those
   * values. The individual buttons (widgets) of a check box field can
   * also have different export values.
   *
   * Different radio buttons (widgets) of a radio button group (field)
   * can have the same value; in that case, the radio buttons are linked.
   * The individual buttons of a check box field also can have the same
   * value.
   *
   * @param[in] aEncoding  The encoding to be used for the return value.
   *
   * @return The button value  an empty string (for field types that
   *         don't use button values).
   *
   * @see getChoiceValue(), getValue(), selectWidget(), setButtonValue()
   */
  std::string getButtonValue (Encoding aEncoding) const
  {
    SIGNDOC_Exception *ex = NULL;
    std::string r;
    char *s = SIGNDOC_Field_getButtonValue (&ex, p, aEncoding);
    if (ex != NULL) SignDoc_throw (ex);
    try
      {
        r = s;
      }
    catch (...)
      {
        SIGNDOC_free (s);
        throw;
      }
    SIGNDOC_free (s);
    return r;
  }

  /**
   * @brief Get the button value of a widget of a radio button group or check box.
   *
   * See getButtonValue() for details.
   *
   * @return The button value  an empty string (for field types that
   *         don't use button values).
   *         This pointer will become invalid when addWidget(),
   *         insertWidget(), removeWidget(), or setButtonValue() is called
   *         or this object is destroyed.
   *
   * @see getButtonValue(), getChoiceValue(), getValue(), selectWidget(), setButtonValue()
   */
  const char *getButtonValueUTF8 () const
  {
    SIGNDOC_Exception *ex = NULL;
    const char *r;
    r = SIGNDOC_Field_getButtonValueUTF8 (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * Set the button value of a widget of a radio button group or a check box.
   *
   * Usually, different radio buttons (widgets) of a radio button group
   * (field) have different values. The radio button group has a value
   * (returned by getValue()) which is either "Off" or one of those
   * values. The individual buttons (widgets) of a check box field can
   * also have different export values.
   *
   * Different radio buttons (widgets) of a radio button group (field)
   * can have the same value; in that case, the radio buttons are linked.
   * The individual buttons of a check box field also can have the same
   * value.
   *
   * SignDocDocument::addField() and SignDocDocument::setField()
   * ignore the value set by this function if the field is neither
   * a radio button group nor a check box field.
   *
   * @param[in] aEncoding  The encoding of @a aValue.
   * @param[in] aValue     The value to be set. Must not be empty, must
   *                       not be "Off".
   *
   * @see getButtonValue(), getChoiceValue(), getValue(), selectWidget()
   */
  void setButtonValue (Encoding aEncoding, const std::string &aValue)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setButtonValue (&ex, p, aEncoding, aValue.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Get the justification of the widget.
   *
   * The default value is #j_none.
   *
   * @return The justification of the widget, #j_none for non-text fields.
   *
   * @see selectWidget(), setJustification()
   */
  Justification getJustification () const
  {
    SIGNDOC_Exception *ex = NULL;
    Justification r;
    r = (Justification)SIGNDOC_Field_getJustification (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the justification of the widget.
   *
   * The default value is #j_none.
   *
   * The justification must be j_none for all field types except
   * for text fields and list boxes.
   *
   * @param[in] aJustification  The justification.
   *
   * @see getJustification(), selectWidget()
   */
  void setJustification (Justification aJustification)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setJustification (&ex, p, aJustification);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Get the rotation of the widget contents.
   *
   * The rotation is specified in degrees (counter-clockwise).
   * The default value is 0.
   *
   * For instance, if the rotation is 270, left-to right
   * text will display top down.
   *
   * @return The rotation of the widget: 0, 90, 180, or 270.
   *
   * @see selectWidget(), setJustification()
   */
  int getRotation () const
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_Field_getRotation (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   * @param[in] aRotation  The rotation: 0, 90, 180, or 270.
   *
   * @see getRotation(), selectWidget()
   */
  void setRotation (int aRotation)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setRotation (&ex, p, aRotation);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Get text field attributes.
   *
   * This function returns false if the field uses the document's
   * default font name for fields.
   *
   * Text fields, signature fields, list boxes, and combo boxes can
   * have text field attributes.
   *
   * @param[in,out] aOutput  This object will be updated.
   *
   * @return true iff successful.
   *
   * @see selectWidget(), setTextFieldAttributes(), SignDocDocument::getTextFieldAttributes()
   */
  bool getTextFieldAttributes (SignDocTextFieldAttributes &aOutput) const
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_getTextFieldAttributes (&ex, p, aOutput.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   * If SignDocTextFieldAttributes::isSet() returns false for @a
   * aInput, the text field attributes of the field will be removed
   * by SignDocDocument::setField().
   *
   * The following rules apply if the field does not have text field
   * attributes:
   * - If the field inherits text field attributes from a
   *   ancestor field, those will be used by PDF processing software.
   * - Otherwise, if the document has specifies text field attributes (see
   *   SignDocDocument::getTextFieldAttributes()), those will be used
   *   by PDF processing software.
   * - Otherwise, the field is not valid.
   * .
   *
   * To avoid having invalid fields, SignDocDocument::addField() and
   * SignDocDocument::setField() will use text field attributes
   * specifying Helvetica as the font and black for the text color if
   * the field does not inherit text field attributes from an ancestor
   * field or from the document.
   *
   * This function always fails for TIFF documents.
   *
   * @param[in] aInput   The new default text field attributes.
   *
   * @return true iff successful.
   *
   * @see getTextFieldAttributes(), selectWidget()
   */
  bool setTextFieldAttributes (const SignDocTextFieldAttributes &aInput)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_setTextFieldAttributes (&ex, p, aInput.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the lock type.
   *
   * The lock type defines the fields to be locked when signing this
   * signature field.
   *
   * @return The lock type.
   *
   * @see getLockFields(), setLockType()
   */
  LockType getLockType () const
  {
    SIGNDOC_Exception *ex = NULL;
    LockType r;
    r = (LockType)SIGNDOC_Field_getLockType (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the lock type.
   *
   * The lock type defines the fields to be locked when signing this
   * signature field.
   *
   * @param[in] aLockType The new lock type.
   *
   * @see addLockField(), getLockType()
   */
  void setLockType (LockType aLockType)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setLockType (&ex, p, aLockType);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Get the number of field names for lt_include and lt_exclude.
   *
   * @return The number of field names.
   *
   * @see addLockField(), clearLockFields(), getLockField(), getLockFieldUTF8(), removeLockField()
   */
  int getLockFieldCount () const
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_Field_getLockFieldCount (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the name of a lock field.
   *
   * This function throws de::softpro::spooc::EncodingError if
   * the name cannot be represented using the specified encoding.
   *
   * @param[in] aEncoding  The encoding to be used for the return value.
   * @param[in] aIndex     0-based index of the lock field.
   *
   * @return The name of the selected lock field or an empty string
   *         if the index is out of range.
   *
   * @see addLockField(), clearLockFields(), getLockFieldCount(), getLockFieldUTF8(), removeLockField(), setLockField()
   */
  std::string getLockField (Encoding aEncoding, int aIndex) const
  {
    SIGNDOC_Exception *ex = NULL;
    std::string r;
    char *s = SIGNDOC_Field_getLockField (&ex, p, aEncoding, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    try
      {
        r = s;
      }
    catch (...)
      {
        SIGNDOC_free (s);
        throw;
      }
    SIGNDOC_free (s);
    return r;
  }

  /**
   * @brief Get the name of a lock field.
   *
   * @param[in] aIndex     0-based index of the lock field.
   *
   * @return The name of the selected lock field or an empty string
   *         if the index is out of range.  This pointer will become invalid
   *         when addLockField(), clearLockFields(), removeLockField(), or setLockField()
   *         is called or this object is destroyed.
   *
   * @see addLockField(), clearLockFields(), getLockFieldCount(), getLockFieldUTF8(), setLockField()
   */
  const char *getLockFieldUTF8 (int aIndex) const
  {
    SIGNDOC_Exception *ex = NULL;
    const char *r;
    r = SIGNDOC_Field_getLockFieldUTF8 (&ex, p, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Clear the lock fields.
   *
   * After calling this function, getLockFieldCount() will return 0.
   *
   * @see addLockField(), getLockFieldCount(), removeLockField()
   */
  void clearLockFields ()
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_clearLockFields (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Add a lock field to the field.
   *
   * This function throws de::softpro::spooc::EncodingError if the
   * name is not correctly encoded according to the specified
   * encoding.
   *
   * @param[in] aEncoding  The encoding of @a aName.
   * @param[in] aName      The name of the lock field to be added.
   *
   * @see clearLockFields(), getLockField(), getLockFieldUTF8(), setLockField()
   */
  void addLockField (Encoding aEncoding, const std::string &aName)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_addLockField (&ex, p, aEncoding, aName.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Set a lock field.
   *
   * This function throws de::softpro::spooc::EncodingError if the
   * name is not correctly encoded according to the specified
   * encoding.
   *
   * @param[in] aIndex     The 0-based index of the value to be set.
   *                       If @a aIndex equals the current number of
   *                       values, the value will be added.
   * @param[in] aEncoding  The encoding of @a aName.
   * @param[in] aName      The name of the lock field to be set.
   *
   * @return true if successful, false if @a aIndex is out of range.
   *
   * @see clearLockFields(), getLockField(), getLockFieldUTF8()
   */
  bool setLockField (int aIndex, Encoding aEncoding, const std::string &aName)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_setLockFieldByIndex (&ex, p, aIndex, aEncoding, aName.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set a lock field.
   *
   * Calling this function is equivalent to calling clearLockFields() and
   * addLockField(), but the encoding of @a aName is checked before
   * modifying this object.
   *
   * This function throws de::softpro::spooc::EncodingError if the
   * name is not correctly encoded according to the specified
   * encoding.
   *
   * @param[in] aEncoding  The encoding of @a aName.
   * @param[in] aName      The name of the lock field to be set.
   *
   * @see clearLockFields(), getLockField(), getLockFieldUTF8()
   */
  void setLockField (Encoding aEncoding, const std::string &aName)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setLockField (&ex, p, aEncoding, aName.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Remove a lock field.
   *
   * @param[in] aIndex     The 0-based index of the lock field to be removed.
   *
   * @return true if successful, false if @a aIndex is out of range.
   *
   * @see clearLockFields(), getLockField(), getLockFieldUTF8()
   */
  bool removeLockField (int aIndex)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_removeLockField (&ex, p, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the certificate seed value dictionary flags (/SV/Cert/Ff) of a
   *        signature field, see enum #CertSeedValueFlag.
   *
   * The default value is 0.
   *
   * @return The certificate seed value dictionary flags of the field.
   *
   * @see setCertSeedValueFlags()
   */
  unsigned getCertSeedValueFlags () const
  {
    SIGNDOC_Exception *ex = NULL;
    unsigned r;
    r = SIGNDOC_Field_getCertSeedValueFlags (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the certificate seed value dictionary flags (/SV/Cert/Ff) of a
   *        signature field, see enum #CertSeedValueFlag.
   *
   * The default value is 0.
   *
   * @param[in] aFlags  The certificate seed value dicitionary flags of
   *                    the field.
   *
   * @see getCertSeedValueFlags()
   */
  void setCertSeedValueFlags (unsigned aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setCertSeedValueFlags (&ex, p, aFlags);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Get the number of subject distinguished names in the certificate
   *        seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * @see addCertSeedValueSubjectDN(), clearCertSeedValueSubjectDNs(), getCertSeedValueSubjectDN(), getCertSeedValueSubjectDNUTF8(), removeCertSeedValueSubjectDN()
   */
  int getCertSeedValueSubjectDNCount () const
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_Field_getCertSeedValueSubjectDNCount (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get a subject distinguished name from the certificate
   *        seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * This function throws de::softpro::spooc::EncodingError if
   * the name cannot be represented using the specified encoding.
   *
   * @note RFC 4514 requires UTF-8 encoding.
   *
   * @param[in] aEncoding  The encoding to be used for the return value.
   * @param[in] aIndex     0-based index of the subject distinguished name.
   *
   * @return The selected subject distinguished name (formatted according to
   *         RFC 4514) or an empty string if the index is out of range.
   *
   * @see addCertSeedValueSubjectDN(), clearCertSeedValueSubjectDNs(), getCertSeedValueSubjectDNCount(), getCertSeedValueSubjectDNUTF8(), removeCertSeedValueSubjectDN(), setCertSeedValueSubjectDN()
   */
  std::string getCertSeedValueSubjectDN (Encoding aEncoding, int aIndex) const
  {
    SIGNDOC_Exception *ex = NULL;
    std::string r;
    char *s = SIGNDOC_Field_getCertSeedValueSubjectDN (&ex, p, aEncoding, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    try
      {
        r = s;
      }
    catch (...)
      {
        SIGNDOC_free (s);
        throw;
      }
    SIGNDOC_free (s);
    return r;
  }

  /**
   * @brief Get a subject distinguished name from the certificate
   *        seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * @note RFC 4514 requires UTF-8 encoding.
   *
   * @param[in] aIndex     0-based index of the subject distinguished name.
   *
   * @return The selected subject distinguished name (formatted according to
   *         RFC 4514) or an empty string if the index is out of range.
   *         This pointer will become invalid when
   *         addCertSeedValueSubjectDN(), clearCertSeedValueSubjectDNs(),
   *         removeCertSeedValueSubjectDN(), or setCertSeedValueSubjectDN() is
   *         called or this object is destroyed.
   *
   * @see addCertSeedValueSubjectDN(), clearCertSeedValueSubjectDNs(), getCertSeedValueSubjectDNCount(), getCertSeedValueSubjectDNUTF8(), setCertSeedValueSubjectDN()
   */
  const char *getCertSeedValueSubjectDNUTF8 (int aIndex) const
  {
    SIGNDOC_Exception *ex = NULL;
    const char *r;
    r = SIGNDOC_Field_getCertSeedValueSubjectDNUTF8 (&ex, p, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Remove all subject distinguished names from the certificate
   *        seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * After calling this function, getCertSeedValueSubjectDNCount() will return 0.
   *
   * @see addCertSeedValueSubjectDN(), getCertSeedValueSubjectDNCount(), removeCertSeedValueSubjectDN()
   */
  void clearCertSeedValueSubjectDNs ()
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_clearCertSeedValueSubjectDNs (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Add a subject distinguished name to the certificate
   *        seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * This function throws de::softpro::spooc::EncodingError if the
   * name is not correctly encoded according to the specified
   * encoding.
   *
   * @note RFC 4514 requires UTF-8 encoding.
   *
   * @param[in] aEncoding  The encoding of @a aName.
   * @param[in] aName      The subject distinguished name formatted according
   *                       to RFC 4514.
   *
   * @return true if successful, false if @a aName cannot be parsed.
   *
   * @see clearCertSeedValueSubjectDNs(), getCertSeedValueSubjectDN(), getCertSeedValueSubjectDNUTF8(), setCertSeedValueSubjectDN()
   */
  bool addCertSeedValueSubjectDN (Encoding aEncoding, const std::string &aName)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_addCertSeedValueSubjectDN (&ex, p, aEncoding, aName.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set a subject distinguished name in the certificate
   *        seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * This function throws de::softpro::spooc::EncodingError if the
   * name is not correctly encoded according to the specified
   * encoding.
   *
   * @note RFC 4514 requires UTF-8 encoding.
   *
   * @param[in] aIndex     The 0-based index of the value to be set.
   *                       If @a aIndex equals the current number of
   *                       values, the value will be added.
   * @param[in] aEncoding  The encoding of @a aName.
   * @param[in] aName      The subject distinguished name formatted according
   *                       to RFC 4514.
   *
   * @return true if successful, false if @a aIndex is out of range or
   *         if @a aName cannot be parsed.
   *
   * @see clearCertSeedValueSubjectDNs(), getCertSeedValueSubjectDN(), getCertSeedValueSubjectDNUTF8()
   */
  bool setCertSeedValueSubjectDN (int aIndex, Encoding aEncoding,
                                  const std::string &aName)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_setCertSeedValueSubjectDNByIndex (&ex, p, aIndex, aEncoding, aName.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set a subject distinguished name in the certificate
   *        seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * Calling this function is equivalent to calling
   * clearCertSeedValueSubjectDNs() and addCertSeedValueSubjectDN(), but the
   * encoding of @a aName is checked before modifying this object.
   *
   * This function throws de::softpro::spooc::EncodingError if the
   * name is not correctly encoded according to the specified
   * encoding.
   *
   * @note RFC 4514 requires UTF-8 encoding.
   *
   * @param[in] aEncoding  The encoding of @a aName.
   * @param[in] aName      The subject distinguished name formatted according
   *                       to RFC 4514.
   *
   * @return true if successful, false if @a aName cannot be parsed.
   *
   * @see clearCertSeedValueSubjectDNs(), getCertSeedValueSubjectDN(), getCertSeedValueSubjectDNUTF8()
   */
  bool setCertSeedValueSubjectDN (Encoding aEncoding, const std::string &aName)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_setCertSeedValueSubjectDN (&ex, p, aEncoding, aName.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Remove a subject distinguished name from the certificate
   *        seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * @param[in] aIndex     The 0-based index of the subject distinguished name to be removed.
   *
   * @return true if successful, false if @a aIndex is out of range.
   *
   * @see clearCertSeedValueSubjectDNs(), getCertSeedValueSubjectDN(), getCertSeedValueSubjectDNUTF8()
   */
  bool removeCertSeedValueSubjectDN (int aIndex)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_removeCertSeedValueSubjectDN (&ex, p, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the number of subject certificates in the certificate seed value
   *        dictionary.
   *
   * See the PDF Reference for details.
   *
   * @return The number of subject certificates.
   *
   * @see addCertSeedValueSubjectCertificate(), clearCertSeedValueSubjectCertificates(), getCertSeedValueSubjectCertificate(), getCertSeedValueSubjectCertificateUTF8(), removeCertSeedValueSubjectCertificate()
   */
  int getCertSeedValueSubjectCertificateCount () const
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_Field_getCertSeedValueSubjectCertificateCount (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get a subject certificate of the certificate seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * @param[in]  aIndex    0-based index of the subject certificate.
   * @param[out] aOutput   The DER-encoded certificate will be stored here.
   *
   * @return true if successful, false if @a aIndex is out of range.
   *
   * @see addCertSeedValueSubjectCertificate(), clearCertSeedValueSubjectCertificates(), getCertSeedValueSubjectCertificateCount(), getCertSeedValueSubjectCertificateUTF8(), removeCertSeedValueSubjectCertificate(), setCertSeedValueSubjectCertificate()
   */
  bool getCertSeedValueSubjectCertificate (int aIndex,
                                           std::vector<unsigned char> &aOutput) const
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_ByteArray *tempOutput = NULL;
    bool r;
    try
      {
        tempOutput = SIGNDOC_ByteArray_new (&ex);
        if (ex != NULL) SignDoc_throw (ex);
        r = (bool)SIGNDOC_Field_getCertSeedValueSubjectCertificate (&ex, p, aIndex, tempOutput);
        assignArray (aOutput, tempOutput);
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_ByteArray_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_ByteArray_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Remove all subject certificates from the certificate seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * After calling this function, getCertSeedValueSubjectCertificateCount() will return 0.
   *
   * @see addCertSeedValueSubjectCertificate(), getCertSeedValueSubjectCertificateCount(), removeCertSeedValueSubjectCertificate()
   */
  void clearCertSeedValueSubjectCertificates ()
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_clearCertSeedValueSubjectCertificates (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Add a subject certificate to the certificate seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * @param[in] aPtr       Pointer to the first octet of the DER-encoded
   *                       certificate.
   * @param[in] aSize      Size in octets of the DER-encoded certificate.
   *
   * @see clearCertSeedValueSubjectCertificates(), getCertSeedValueSubjectCertificate(), getCertSeedValueSubjectCertificateUTF8(), setCertSeedValueSubjectCertificate()
   */
  void addCertSeedValueSubjectCertificate (const void *aPtr, size_t aSize)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_addCertSeedValueSubjectCertificate (&ex, p, aPtr, aSize);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Set a subject certificate in the certificate seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * @param[in] aIndex     0-based index of the subject certificate to be set.
   *                       If @a aIndex equals the current number of
   *                       values, the certificate will be added.
   * @param[in] aPtr       Pointer to the first octet of the DER-encoded
   *                       certificate.
   * @param[in] aSize      Size in octets of the DER-encoded certificate.
   *
   * @return true if successful, false if @a aIndex is out of range.
   *
   * @see clearCertSeedValueSubjectCertificates(), getCertSeedValueSubjectCertificate(), getCertSeedValueSubjectCertificateUTF8()
   */
  bool setCertSeedValueSubjectCertificate (int aIndex, const void *aPtr,
                                           size_t aSize)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_setCertSeedValueSubjectCertificateByIndex (&ex, p, aIndex, aPtr, aSize);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set a subject certificate in the certificate seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * Calling this function is equivalent to calling clearCertSeedValueSubjectCertificates() and
   * addCertSeedValueSubjectCertificate().
   *
   * @param[in] aPtr       Pointer to the first octet of the DER-encoded
   *                       certificate.
   * @param[in] aSize      Size in octets of the DER-encoded certificate.
   *
   * @see clearCertSeedValueSubjectCertificates(), getCertSeedValueSubjectCertificate(), getCertSeedValueSubjectCertificateUTF8()
   */
  void setCertSeedValueSubjectCertificate (const void *aPtr, size_t aSize)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setCertSeedValueSubjectCertificate (&ex, p, aPtr, aSize);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Remove a subject certificate from the certificate seed value
   *        dictionary.
   *
   * See the PDF Reference for details.
   *
   * @param[in] aIndex     The 0-based index of the subject certificate to
   *                       be removed.
   *
   * @return true if successful, false if @a aIndex is out of range.
   *
   * @see clearCertSeedValueSubjectCertificates(), getCertSeedValueSubjectCertificate(), getCertSeedValueSubjectCertificateUTF8()
   */
  bool removeCertSeedValueSubjectCertificate (int aIndex)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_removeCertSeedValueSubjectCertificate (&ex, p, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the number of issuer certificates in the certificate seed value
   *        dictionary.
   *
   * See the PDF Reference for details.
   *
   * @return The number of issuer certificates.
   *
   * @see addCertSeedValueIssuerCertificate(), clearCertSeedValueIssuerCertificates(), getCertSeedValueIssuerCertificate(), getCertSeedValueIssuerCertificateUTF8(), removeCertSeedValueIssuerCertificate()
   */
  int getCertSeedValueIssuerCertificateCount () const
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_Field_getCertSeedValueIssuerCertificateCount (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get an issuer certificate of the certificate seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * @param[in]  aIndex    0-based index of the issuer certificate.
   * @param[out] aOutput   The DER-encoded certificate will be stored here.
   *
   * @return true if successful, false if @a aIndex is out of range.
   *
   * @see addCertSeedValueIssuerCertificate(), clearCertSeedValueIssuerCertificates(), getCertSeedValueIssuerCertificateCount(), getCertSeedValueIssuerCertificateUTF8(), removeCertSeedValueIssuerCertificate(), setCertSeedValueIssuerCertificate()
   */
  bool getCertSeedValueIssuerCertificate (int aIndex,
                                          std::vector<unsigned char> &aOutput) const
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_ByteArray *tempOutput = NULL;
    bool r;
    try
      {
        tempOutput = SIGNDOC_ByteArray_new (&ex);
        if (ex != NULL) SignDoc_throw (ex);
        r = (bool)SIGNDOC_Field_getCertSeedValueIssuerCertificate (&ex, p, aIndex, tempOutput);
        assignArray (aOutput, tempOutput);
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_ByteArray_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_ByteArray_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Remove all issuer certificates from the certificate seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * After calling this function, getCertSeedValueIssuerCertificateCount() will return 0.
   *
   * @see addCertSeedValueIssuerCertificate(), getCertSeedValueIssuerCertificateCount(), removeCertSeedValueIssuerCertificate()
   */
  void clearCertSeedValueIssuerCertificates ()
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_clearCertSeedValueIssuerCertificates (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Add an issuer certificate to the certificate seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * @param[in] aPtr       Pointer to the first octet of the DER-encoded
   *                       certificate.
   * @param[in] aSize      Size in octets of the DER-encoded certificate.
   *
   * @see clearCertSeedValueIssuerCertificates(), getCertSeedValueIssuerCertificate(), getCertSeedValueIssuerCertificateUTF8(), setCertSeedValueIssuerCertificate()
   */
  void addCertSeedValueIssuerCertificate (const void *aPtr, size_t aSize)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_addCertSeedValueIssuerCertificate (&ex, p, aPtr, aSize);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Set an issuer certificate in the certificate seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * @param[in] aIndex     0-based index of the issuer certificate to be set.
   *                       If @a aIndex equals the current number of
   *                       values, the certificate will be added.
   * @param[in] aPtr       Pointer to the first octet of the DER-encoded
   *                       certificate.
   * @param[in] aSize      Size in octets of the DER-encoded certificate.
   *
   * @return true if successful, false if @a aIndex is out of range.
   *
   * @see clearCertSeedValueIssuerCertificates(), getCertSeedValueIssuerCertificate(), getCertSeedValueIssuerCertificateUTF8()
   */
  bool setCertSeedValueIssuerCertificate (int aIndex, const void *aPtr,
                                          size_t aSize)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_setCertSeedValueIssuerCertificateByIndex (&ex, p, aIndex, aPtr, aSize);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set an issuer certificate in the certificate seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * Calling this function is equivalent to calling clearCertSeedValueIssuerCertificates() and
   * addCertSeedValueIssuerCertificate().
   *
   * @param[in] aPtr       Pointer to the first octet of the DER-encoded
   *                       certificate.
   * @param[in] aSize      Size in octets of the DER-encoded certificate.
   *
   * @see clearCertSeedValueIssuerCertificates(), getCertSeedValueIssuerCertificate(), getCertSeedValueIssuerCertificateUTF8()
   */
  void setCertSeedValueIssuerCertificate (const void *aPtr, size_t aSize)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setCertSeedValueIssuerCertificate (&ex, p, aPtr, aSize);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Remove an issuer certificate from the certificate seed value
   *        dictionary.
   *
   * See the PDF Reference for details.
   *
   * @param[in] aIndex     The 0-based index of the issuer certificate to
   *                       be removed.
   *
   * @return true if successful, false if @a aIndex is out of range.
   *
   * @see clearCertSeedValueIssuerCertificates(), getCertSeedValueIssuerCertificate(), getCertSeedValueIssuerCertificateUTF8()
   */
  bool removeCertSeedValueIssuerCertificate (int aIndex)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_removeCertSeedValueIssuerCertificate (&ex, p, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the number of policy OIDs in the certificate seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * @return The number of policy OIDs.
   *
   * @see addCertSeedValuePolicy(), clearCertSeedValuePolicies(), getCertSeedValuePolicy(), getCertSeedValuePolicyUTF8(), removeCertSeedValuePolicy()
   */
  int getCertSeedValuePolicyCount () const
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_Field_getCertSeedValuePolicyCount (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get a policy OID from the certificate seed value dictionary.
   *
   * This function throws de::softpro::spooc::EncodingError if
   * the value cannot be represented using the specified encoding.
   *
   * See the PDF Reference for details.
   *
   * @note OIDs should be ASCII strings.
   *
   * @param[in] aEncoding  The encoding to be used for the return value.
   * @param[in] aIndex     0-based index of the policy OID.
   *
   * @return The selected policy OID or an empty string if the index
   *         is out of range.
   *
   * @see addCertSeedValuePolicy(), clearCertSeedValuePolicies(), getCertSeedValuePolicyCount(), getCertSeedValuePolicyUTF8(), removeCertSeedValuePolicy(), setCertSeedValuePolicy()
   */
  std::string getCertSeedValuePolicy (Encoding aEncoding, int aIndex) const
  {
    SIGNDOC_Exception *ex = NULL;
    std::string r;
    char *s = SIGNDOC_Field_getCertSeedValuePolicy (&ex, p, aEncoding, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    try
      {
        r = s;
      }
    catch (...)
      {
        SIGNDOC_free (s);
        throw;
      }
    SIGNDOC_free (s);
    return r;
  }

  /**
   * @brief Get a policy OID from the certificate seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * @note OIDs should be ASCII strings.
   *
   * @param[in] aIndex     0-based index of the policy OID.
   *
   * @return The selected policy OID or an empty string if the index
   *         is out of range.  This pointer will become invalid when
   *         addCertSeedValuePolicy(), clearCertSeedValuePolicies(),
   *         removeCertSeedValuePolicy(), or setCertSeedValuePolicy() is
   *         called or this object is destroyed.
   *
   * @see addCertSeedValuePolicy(), clearCertSeedValuePolicies(), getCertSeedValuePolicyCount(), getCertSeedValuePolicyUTF8(), setCertSeedValuePolicy()
   */
  const char *getCertSeedValuePolicyUTF8 (int aIndex) const
  {
    SIGNDOC_Exception *ex = NULL;
    const char *r;
    r = SIGNDOC_Field_getCertSeedValuePolicyUTF8 (&ex, p, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Remove all policy OIDs from the certificate seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * After calling this function, getCertSeedValuePolicyCount() will return 0.
   *
   * @see addCertSeedValuePolicy(), getCertSeedValuePolicyCount(), removeCertSeedValuePolicy()
   */
  void clearCertSeedValuePolicies ()
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_clearCertSeedValuePolicies (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Add a policy OID to the certificate seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * This function throws de::softpro::spooc::EncodingError if the
   * value is not correctly encoded according to the specified
   * encoding.
   *
   * @note OIDs should be ASCII strings.
   *
   * @param[in] aEncoding  The encoding of @a aOID.
   * @param[in] aOID       The policy OID.
   *
   * @see clearCertSeedValuePolicies(), getCertSeedValuePolicy(), getCertSeedValuePolicyUTF8(), setCertSeedValuePolicy()
   */
  void addCertSeedValuePolicy (Encoding aEncoding, const std::string &aOID)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_addCertSeedValuePolicy (&ex, p, aEncoding, aOID.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Set a policy OID in the certificate seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * This function throws de::softpro::spooc::EncodingError if the
   * value is not correctly encoded according to the specified
   * encoding.
   *
   * @note OIDs should be ASCII strings.
   *
   * @param[in] aIndex     The 0-based index of the value to be set.
   *                       If @a aIndex equals the current number of
   *                       values, the value will be added.
   * @param[in] aEncoding  The encoding of @a aOID.
   * @param[in] aOID       The policy OID.
   *
   * @return true if successful, false if @a aIndex is out of range.
   *
   * @see clearCertSeedValuePolicies(), getCertSeedValuePolicy(), getCertSeedValuePolicyUTF8()
   */
  bool setCertSeedValuePolicy (int aIndex, Encoding aEncoding,
                               const std::string &aOID)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_setCertSeedValuePolicyByIndex (&ex, p, aIndex, aEncoding, aOID.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set a policy OID in the certificate seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * Calling this function is equivalent to calling clearCertSeedValuePolicies() and
   * addCertSeedValuePolicy(), but the encoding of @a aOID is checked before
   * modifying this object.
   *
   * This function throws de::softpro::spooc::EncodingError if the
   * value is not correctly encoded according to the specified
   * encoding.
   *
   * @note OIDs should be ASCII strings.
   *
   * @param[in] aEncoding  The encoding of @a aOID.
   * @param[in] aOID       The policy OID.
   *
   * @see clearCertSeedValuePolicies(), getCertSeedValuePolicy(), getCertSeedValuePolicyUTF8()
   */
  void setCertSeedValuePolicy (Encoding aEncoding, const std::string &aOID)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setCertSeedValuePolicy (&ex, p, aEncoding, aOID.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Remove a policy OID from the certificate seed value dictionary.
   *
   * See the PDF Reference for details.
   *
   * @param[in] aIndex     The 0-based index of the policy OID to be removed.
   *
   * @return true if successful, false if @a aIndex is out of range.
   *
   * @see clearCertSeedValuePolicies(), getCertSeedValuePolicy(), getCertSeedValuePolicyUTF8()
   */
  bool removeCertSeedValuePolicy (int aIndex)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_removeCertSeedValuePolicy (&ex, p, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the URL of the RFC 3161 time-stamp server from the
   *        signature field seed value dictionary.
   *
   * This function throws de::softpro::spooc::EncodingError if
   * the value cannot be represented using the specified encoding.
   *
   * @note The URL should be an ASCII string.
   *
   * @param[in] aEncoding  The encoding to be used for the return value.
   *
   * @return The URL of the time-stamp server or an empty string if
   *         no time-stamp server is defined.
   *
   * @see getSeedValueTimeStampRequired(), setSeedValueTimeStamp()
   */
  std::string getSeedValueTimeStampServerURL (Encoding aEncoding) const
  {
    SIGNDOC_Exception *ex = NULL;
    std::string r;
    char *s = SIGNDOC_Field_getSeedValueTimeStampServerURL (&ex, p, aEncoding);
    if (ex != NULL) SignDoc_throw (ex);
    try
      {
        r = s;
      }
    catch (...)
      {
        SIGNDOC_free (s);
        throw;
      }
    SIGNDOC_free (s);
    return r;
  }

  /**
   * @brief This function gets a flag from the signature field seed value
   *        dictionary that indicates whether a time stamp is required or
   *        not for the signature.
   *
   * If this function returns true, the URL returned by
   * getSeedValueTimeStampServerURL() will be used to add a time
   * stamp to the signature when signing.
   *
   * @return false if a time stamp is not required, true if a time stamp
   *         is required.
   *
   * @see getSeedValueTimeStampServerURL()
   */
  bool getSeedValueTimeStampRequired () const
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_getSeedValueTimeStampRequired (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the URL of an RFC 3161 time-stamp server in the
   *        signature field seed value dictionary.
   *
   * This function throws de::softpro::spooc::EncodingError if the
   * value is not correctly encoded according to the specified
   * encoding.
   *
   * @note URLs must be ASCII strings.
   *
   * @param[in] aEncoding  The encoding of @a aURL.
   * @param[in] aURL       The URL (must be ASCII), empty for no time-stamp
   *                       server. Must be non-empty if @a aRequired is true.
   *                       The scheme must be http or https.
   * @param[in] aRequired  true if a time stamp is required, false if a
   *                       time stamp is not required.
   *
   * @return true if successful, false if @a aURL is invalid.
   *
   * @see getSeedValueTimeStampRequired(), getSeedValueTimeStampServerURL()
   */
  bool setSeedValueTimeStamp (Encoding aEncoding, const std::string &aURL,
                              bool aRequired)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_Field_setSeedValueTimeStamp (&ex, p, aEncoding, aURL.c_str (), aRequired);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the color used for empty signature field in TIFF document.
   *
   * The default value is white.
   *
   * @return A pointer to a new SignDocColor object describing the color used
   *         for empty signature fields in a TIFF document. The caller is
   *         responsible for destroying the object.
   *         The return value is NULL for other types of documents.
   *
   * @see setEmptyFieldColor()
   */
  SignDocColor *getEmptyFieldColor () const
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Color *r;
    r = SIGNDOC_Field_getEmptyFieldColor (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    if (r == NULL)
      return NULL;
    try
      {
        return new SignDocColor (r);
      }
    catch (...)
      {
        SIGNDOC_Color_delete (r);
        throw;
      }
  }

  /**
   * @brief Set color used for empty signature field in TIFF document.
   *
   * The default value is white.  For non-TIFF documents, the value
   * set by this function is ignored.  The value is also ignored if
   * compatibility with version 1.12 and earlier is requested.
   *
   * @param[in] aColor   The new color.
   *
   * @see getEmptyFieldColor(), SignDocDocument::setCompatibility()
   */
  void setEmptyFieldColor (const SignDocColor &aColor)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Field_setEmptyFieldColor (&ex, p, aColor.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
  }

private:
public:
  /**
   * @brief Internal function.
   * @internal
   */
  SignDocField (SIGNDOC_Field *aP) : p (aP) { }

  /**
   * @brief Internal function.
   * @internal
   */
  SIGNDOC_Field *getImpl () { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  const SIGNDOC_Field *getImpl () const { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  void setImpl (SIGNDOC_Field *aP) { SIGNDOC_Field_delete (p); p  = aP; }

private:
  SIGNDOC_Field *p;
};

/**
 * @brief Internal function.
 * @internal
 */
inline void assignArray (std::vector<SignDocField> &aDst,
                         SIGNDOC_FieldArray *aSrc)
{
  aDst.clear ();
  unsigned n = SIGNDOC_FieldArray_count (aSrc);
  if (aSrc == NULL)
    return;
  aDst.resize (n);
  for (unsigned i = 0; i < n; ++i)
    {
      SIGNDOC_Exception *ex = NULL;
      SIGNDOC_Field *p = SIGNDOC_Field_clone (&ex, SIGNDOC_FieldArray_at (aSrc, i));
      if (ex != NULL) SignDoc_throw (ex);
      aDst[i].setImpl (p);
    }
}

/**
 * @brief Parameters for signing a document.
 *
 * The available parameters depend both on the document type and on
 * the signature field for which the SignDocSignatureParameters object
 * has been created.
 *
 * SignDocDocument::addSignature() may fail due to invalid parameters
 * even if all setters reported success as the setters do not check if
 * there are conflicts between parameters.
 *
 * Which certificates are acceptable may be restricted by the
 * application (by using csf_software and csf_hardware of integer
 * parameter "SelectCertificate", blob parameters
 * "FilterCertificatesByIssuerCertificate" and
 * "FilterCertificatesBySubjectCertificate", and string parameters
 * "FilterCertificatesByPolicy" and
 * "FilterCertificatesBySubjectDN") and by the PDF document
 * (certificate seed value dictionary, not yet implemented). If no
 * matching certificate is available (for instance, because integer
 * parameter "SelectCertificate" is zero),
 * SignDocDocument::addSignature() will fail with rc_no_certificate.
 * If more than one matching certificate is available but
 * csf_never_ask is specified in integer parameter
 * "SelectCertificate"), SignDocDocument::addSignature() will fail
 * with rc_ambiguous_certificate.
 *
 * The interaction between some parameters is quite complex; the following
 * section tries to summarize the signing methods for PDF documents.
 * <dl>
 * <dt>(1a)
 * <dd>PKCS #1, private key and self-signed certificate created on the fly:
 *     - Method: m_digsig_pkcs1
 *     - CommonName: signer's name
 *     - GenerateKeyPair: 1024-4096
 *     .
 * <dt>(1b)
 * <dd>PKCS #1, private key provided, self-signed certificate created on
 *     the fly:
 *     - Method: m_digsig_pkcs1
 *     - CommonName: signer's name
 *     - CertificatePrivateKey: private key for self-signed certificate
 *     .
 * <dt>(1c)
 * <dd>PKCS #1, private key provided, self-signed certificate provided:
 *     - Method: m_digsig_pkcs1
 *     - Certificate: self-signed certificate
 *     - CertificatePrivateKey: private key for self-signed certificate
 *     - Signer: Signer's name (not yet extracted from certificate)
 *     .
 * <dt>(2a)
 * <dd>PKCS #7 via SignPKCS7 interface:
 *     - Method: m_digsig_pkcs7_detached or m_digsig_pkcs7_sha1
 *     .
 *     See setPKCS7() for details.
 * <dt>(2b)
 * <dd>PKCS #7, user must select certificate:
 *     - Method: m_digsig_pkcs7_detached or m_digsig_pkcs7_sha1
 *     - DetachedHashAlgorithm: hash algorithm for m_digsig_pkcs7_detached
 *     - SelectCertificate: csf_software and/or csf_hardware
 *     .
 * <dt>(2c)
 * <dd>PKCS #7, user may select certificate or choose to create
 *     a self-signed certificate, the private key of which will be generated:
 *     - Method: m_digsig_pkcs7_detached or m_digsig_pkcs7_sha1
 *     - DetachedHashAlgorithm: hash algorithm for m_digsig_pkcs7_detached
 *     - SelectCertificate: csf_software and/or csf_hardware
 *     - CommonName: signer's name (for self-signed certificate)
 *     - GenerateKeyPair: 1024-4096
 *     .
 *     PKCS #1 will be used if the user chooses to create a self-signed
 *     certificate.
 * <dt>(2d)
 * <dd>PKCS #7, user may select certificate or choose to create
 *     a self-signed certificate, the private key of which is provided:
 *     - Method: m_digsig_pkcs7_detached or m_digsig_pkcs7_sha1
 *     - DetachedHashAlgorithm: hash algorithm for m_digsig_pkcs7_detached
 *     - SelectCertificate: csf_software and/or csf_hardware
 *     - CommonName: signer's name (for self-signed certificate)
 *     - CertificatePrivateKey: private key for self-signed certificate
 *     .
 *     PKCS #1 will be used if the user chooses to create a self-signed
 *     certificate.
 * <dt>(2e)
 * <dd>PKCS #7, user may select certificate or choose to "create"
 *     a self-signed certificate, the certificate and its key are
 *     provided separately:
 *     - Method: m_digsig_pkcs7_detached or m_digsig_pkcs7_sha1
 *     - DetachedHashAlgorithm: hash algorithm for m_digsig_pkcs7_detached
 *     - SelectCertificate: csf_software and/or csf_hardware, csf_create_self_signed
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
 *     - Method: m_digsig_pkcs7_detached or m_digsig_pkcs7_sha1
 *     - DetachedHashAlgorithm: hash algorithm for m_digsig_pkcs7_detached
 *     - SelectCertificate: csf_software and/or csf_hardware, csf_create_self_signed
 *     - Certificate: PKCS #12 blob containing certificate (need not be
 *       self-signed) and its private key
 *     - PKCS#12Password: password for private key in the PKCS #12 blob
 *     .
 * <dt>(2g)
 * <dd>PKCS #7, the certificate and its key are provided as PKCS #12 blob:
 *     - Method: m_digsig_pkcs7_detached or m_digsig_pkcs7_sha1
 *     - DetachedHashAlgorithm: hash algorithm for m_digsig_pkcs7_detached
 *     - Certificate: PKCS #12 blob containing certificate (need not be
 *       self-signed) and its private key
 *     - PKCS#12Password: password for private key in the PKCS #12 blob
 *     .
 * <dt>(2h)
 * <dd>PKCS #7, the certificate is selected programmatically or by the PDF
 *     document without user interaction:
 *     - Method: m_digsig_pkcs7_detached or m_digsig_pkcs7_sha1
 *     - DetachedHashAlgorithm: hash algorithm for m_digsig_pkcs7_detached
 *     - SelectCertificate: csf_software and/or csf_hardware, csf_never_ask
 *     - FilterCertificatesByPolicy: accept certificates having all of these certificate policies
 *     - FilterCertificatesByIssuerCertificate: the acceptable issuer certificates (optional)
 *     - FilterCertificatesBySubjectCertificate: the acceptable certificates (optional)
 *     - FilterCertificatesBySubjectDN: accept certificates issued for these subjects (optional)
 *     .
 * <dt>(2i)
 * <dd>PKCS #7, private key and self-signed certificate created on the fly:
 *     - Method: m_digsig_pkcs7_detached or m_digsig_pkcs7_sha1
 *     - DetachedHashAlgorithm: hash algorithm for m_digsig_pkcs7_detached
 *     - CommonName: signer's name
 *     - GenerateKeyPair: 1024-4096
 *     .
 * <dt>(2j)
 * <dd>PKCS #7, private key provided, self-signed certificate created on
 *     the fly:
 *     - Method: m_digsig_pkcs7_detached or m_digsig_pkcs7_sha1
 *     - DetachedHashAlgorithm: hash algorithm for m_digsig_pkcs7_detached
 *     - CommonName: signer's name
 *     - CertificatePrivateKey: private key for self-signed certificate
 *     .
 * <dt>(2k)
 * <dd>PKCS #7, private key provided, self-signed certificate provided:
 *     - Method: m_digsig_pkcs7_detached or m_digsig_pkcs7_sha1
 *     - DetachedHashAlgorithm: hash algorithm for m_digsig_pkcs7_detached
 *     - Certificate: self-signed certificate
 *     - CertificatePrivateKey: private key for self-signed certificate
 *     - Signer: Signer's name (not yet extracted from certificate)
 *     .
 * </dl>
 *
 * Additionally:
 * - Set integer parameter "Optimize" to o_optimize unless
 *   SignDocDocument::getRequiredSaveToFileFlags()
 *   indicates that SignDocDocument::sf_incremental must be used.
 *   Note that o_optimize requires string parameter "OutputPath".
 * .
 *
 * For TIFF documents, an additional, simplified signing method is available:
 * <dl>
 * <dt>(3)
 * <dd>just a hash:
 *     - Method: m_hash
 *     - CommonName: signer's name
 *     .
 * </dl>
 */
class SignDocSignatureParameters 
{
public:
  /**
   * @brief Signing methods.
   *
   * Used for integer parameter "Method".
   *
   * @see setInteger()
   */
  enum Method
  {
    m_unused_0,               ///< This value is no longer used.
    m_digsig_pkcs1,           ///< PDF DigSig PKCS #1.
    m_digsig_pkcs7_detached,  ///< PDF DigSig detached PKCS #7.
    m_digsig_pkcs7_sha1,      ///< PDF DigSig PKCS #7 with SHA-1.
    m_hash                    ///< The signature is just a hash.
  };

  /**
   * @brief Hash Algorithm to be used for a detached signature.
   *
   * Used for integer parameter "DetachedHashAlgorithm".
   *
   * dha_sha256 is supported under Linux, iOS, Android, OS X, and under
   * Windows XP SP3 and later.
   * If dha_sha256 is selected but not supported,
   * SignDocDocument::addSignature() will fall back to dha_sha1.
   *
   * @see setInteger()
   */
  enum DetachedHashAlgorithm
  {
    dha_default,               ///< Best supported hash algorithm
    dha_sha1,                  ///< SHA-1
    dha_sha256                 ///< SHA-256
  };

  /**
   * @brief Hash Algorithm to be used for RFC 3161 timestamps.
   *
   * Used for integer parameter "TimeStampHashAlgorithm".
   *
   * tsha_sha256 is supported under Linux, iOS, Android, OS X, and under
   * Windows XP SP3 and later.
   *
   * @see setInteger()
   */
  enum TimeStampHashAlgorithm
  {
    tsha_default,               ///< Currently SHA-1, may change in future
    tsha_sha1,                  ///< SHA-1
    tsha_sha256                 ///< SHA-256
  };

  /**
   * @brief Optimization of document before signing.
   *
   * Used for integer parameter "Optimize".
   *
   * @see setInteger()
   */
  enum Optimize
  {
    o_optimize,               ///< Optimize document before signing for the first time.
    o_dont_optimize           ///< Don't optimize document.
  };

  /**
   * @brief Fix appearance streams of check boxes and radio buttons
   *        for PDF/A documents.
   *
   * Used for integer parameter "PDFAButtons".
   *
   * Using pb_freeze (or pb_auto, if the document claims to be
   * PDF/A-1-compliant and has no signed signature fields) is equivalent
   * to saving the document with SignDocDocument::sf_pdfa_buttons
   * before signing.
   *
   * @see setInteger()
   */
  enum PDFAButtons
  {
    /**
     * @brief Freeze (fix) appearances.
     */
    pb_freeze,

    /**
     * @brief Don't freeze (fix) appearances.
     */
    pb_dont_freeze,

    /**
     * @brief Freeze (fix) appearances if appropriate.
     *
     * Freeze (fix) appearances if the document claims to be
     * PDF/A-1-compliant and if there are no signed signature fields.
     */
    pb_auto
  };

  /**
   * @brief Signing algorithms for self-signed certificates.
   *
   * Used for integer parameter "CertificateSigningAlgorithm".
   *
   * @see setInteger()
   */
  enum CertificateSigningAlgorithm
  {
    csa_sha1_rsa,               ///< SHA1 with RSA.
    csa_md5_rsa                 ///< MD5 with RSA.
  };

  /**
   * @brief Select how to encrypt the biometric data.
   *
   * Used for integer parameter "BiometricEncryption".
   * The biometric data to be encrypted is specified by blob parameter
   * "BiometricData".
   *
   * @see setInteger(), setBlob()
   */
  enum BiometricEncryption
  {
    /**
     * @brief Random session key encrypted with public RSA key.
     *
     * Either blob parameter "BiometricKey" (see #setBlob())
     * or string parameter "BiometricKeyPath" (see #setString()) must be set.
     *
     * @see @ref signdocshared_biometric_encryption
     */
    be_rsa,

    /**
     * @brief Fixed key (no security).
     */
    be_fixed,

    /**
     * @brief Binary 256-bit key.
     *
     * Blob parameter "BiometricKey" (see #setBlob()) must be set.
     */
    be_binary,

    /**
     * @brief Passphrase that will be hashed to a  256-bit key.
     *
     * String parameter "BiometricPassphrase" (see #setString()) must be set.
     */
    be_passphrase,

    /**
     * @brief The biometric data won't be stored in the document.
     *
     * Use this value if you want to use the biometric data for
     * generating the signature image only.  Note that using an
     * automatically generated self-signed certificate is secure only
     * if biometric data is stored in the document using asymmetric
     * encryption.
     */
    be_dont_store
  };

  /**
   * @brief Horizontal alignment.
   *
   * Used for integer parameters "ImageHAlignment" and "TextHAlignment"
   * (see #setInteger()).
   */
  enum HAlignment
  {
    ha_left, ha_center, ha_right, ha_justify
  };

  /**
   * @brief Vertical alignment.
   *
   * Used for integer parameters "ImageVAlignment" and "TextVAlignment"
   * (see #setInteger()).
   */
  enum VAlignment
  {
    va_top, va_center, va_bottom
  };

  /**
   * Position of the text block w.r.t. to the image.
   *
   * Used for integer parameter "TextPosition" (see #setInteger()).
   *
   * @todo tp_above, tp_left_of, tp_right_of
   */
  enum TextPosition
  {
    tp_overlay,       ///< Text and image are independent and overlap (text painted on image).
    tp_below,         ///< Text is put below the image, the image is scaled to fit.
    tp_underlay       ///< Text and image are independent and overlap (image painted on text).
  };

  /**
   * @brief Indicate how measurements are specified.
   *
   * @see setLength()
   */
  enum ValueType
  {
    vt_abs,                   ///< @a aValue is the value to be used (units of document coordinates).
    vt_field_height,          ///< Multiply @a aValue by the field height.
    vt_field_width            ///< Multiply @a aValue by the field width.
  };

  /**
   * @brief Select a string for the appearance stream of PDF documents.
   *
   * @see addTextItem(), setString()
   */
  enum TextItem
  {
    ti_signer,                ///< String parameter "Signer"
    ti_sign_time,             ///< String parameter "SignTime"
    ti_comment,               ///< String parameter "Comment"
    ti_adviser,               ///< String parameter "Adviser"
    ti_contact_info,          ///< String parameter "ContactInfo"
    ti_location,              ///< String parameter "Location"
    ti_reason                 ///< String parameter "Reason"
  };

  /**
   * @brief Text groups.
   *
   * One font size is used per group and is chosen such that the text
   * fits horizontally.  The maximum font size is specified by
   * length parameter "FontSize".
   * The font size of the slave group cannot be greater
   * than then font size of the master group, that is, long text in
   * the slave group won't reduce the font size of the master group.
   *
   * @see addTextItem(), setLength()
   */
  enum TextGroup
  {
    tg_master,                ///< Master group.
    tg_slave                  ///< Slave group.
  };

  /**
   * @brief Flags for selecting certificates.
   *
   * Used for integer parameter "SelectCertificate".
   *
   * If neither csf_ask_if_ambiguous nor csf_never_ask is included,
   * the certificate selection dialog will be displayed.
   *
   * @see setInteger()
   */
  enum CertificateSelectionFlags
  {
    csf_software = 0x01,        ///< include software-based certificates
    csf_hardware = 0x02,        ///< include hardware-based certificates
    csf_use_certificate_seed_values = 0x10, ///< include only certificates allowed by the PDF document's certificate seed value dictionary
    csf_ask_if_ambiguous = 0x20, ///< ask the user to select a certificate if there is more than one matching certificate
    csf_never_ask = 0x40,       ///< never ask the user to select a certificate; exactly one certificate must match
    csf_create_self_signed = 0x80 ///< offer to create a self-signed certificate (cannot be used with csf_never_ask and csf_ask_if_ambiguous)
  };

  /**
   * @brief Flags for rendering the signature.
   *
   * Used for integer parameter "RenderSignature".
   *
   * rsf_bw, rsf_gray, and rsf_antialias are mutually exclusive.
   *
   * @see setInteger()
   */
  enum RenderSignatureFlags
  {
    rsf_bw   = 0x01,              ///< black and white
    rsf_gray = 0x02,              ///< use gray levels computed from pressure
    rsf_antialias = 0x04          ///< use gray levels for antialiasing
  };

  /**
   * @brief Transparency of signature image.
   *
   * Used for integer parameter "ImageTransparency".
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
   * @see setInteger()
   */
  enum ImageTransparency
  {
    /** @brief Make signature image opaque.
     *
     * The signature image will be opaque unless the image has an
     * alpha channel or transparent colors in its palette.
     */
    it_opaque,

    /** @brief Make the brightest color transparent.
     *
     * If the image has an alpha channel (or if its palette contains a
     * transparent color), the image's transparency will be used.
     * Otherwise, white will be made transparent for truecolor images
     * and the brightest color in the palette will be made transparent
     * for indexed images (including grayscale images).
     */
    it_brightest
  };

  /**
   * @brief Return codes.
   */
  enum ReturnCode
  {
    rc_ok,                      ///< Parameter set successfully.
    rc_unknown,                 ///< Unknown parameter.
    rc_not_supported,           ///< Setting the parameter is not supported.
    rc_invalid_value            ///< The value for the parameter is invalid.
  };

  /**
   * @brief Status of a parameter.
   *
   * Don't make your code depend on the difference between ps_set and
   * ps_supported.
   *
   * @see getState()
   *
   * @todo implement ps_ignored
   */
  enum ParameterState
  {
    ps_set,             ///< Parameter has been set (most parameters have a default value such as the empty string which may be treated as "set" or "not set" depending on the implementation's fancy)
    ps_missing,         ///< Parameter must be set but is not set.
    ps_supported,       ///< Parameter is supported and optional, but has not been set or is set to the default value
    ps_ignored,         ///< Parameter can be (or is) set but will be ignored
    ps_not_supported,   ///< Parameter is not supported for this field.
    ps_unknown          ///< Unknown parameter.
  };

public:
  /**
   * @brief Constructor.
   *
   * Use SignDocDocument::createSignatureParameters() instead.
   */
  SignDocSignatureParameters ()
    : p (NULL)
  {
  }

  /**
   * @brief Destructor.
   *
   * Overwrites this object's copies of the private key and biometric
   * data.
   */
  ~SignDocSignatureParameters ()
  {
    SIGNDOC_SignatureParameters_delete (p);
  }

  /**
   * @brief Get the status of a parameter.
   *
   * @param[in] aName   The name of the parameter (case-sensitive).
   *
   * @return see enum #ParameterState.
   */
  ParameterState getState (const std::string &aName)
  {
    SIGNDOC_Exception *ex = NULL;
    ParameterState r;
    r = (ParameterState)SIGNDOC_SignatureParameters_getState (&ex, p, aName.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set a string parameter.
   *
   * Available string parameters are:
   * - @b Adviser          The adviser.
   *                       For DigSig signature fields, the adviser may be used
   *                       for the appearance stream of PDF documents
   *                       (see ti_adviser).
   *                       The default value is empty.
   *                       Complex scripts are supported,
   *                       see @ref signdocshared_complex_scripts.
   * - @b BiometricKeyPath   The pathname of a file containing the public key
   *                       in PKCS #1 or X.509 format for encrypting the
   *                       biometric data
   *                       with integer parameter "BiometricEncryption" set
   *                       to be_rsa. See also blob parameter "BiometricKey"
   *                       and @ref signdocshared_biometric_encryption.
   *                       See @ref winrt_store for restrictions on pathnames
   *                       in Windows Store apps.
   * - @b BiometricPassphrase  Passphrase to be used if integer parameter
   *                       "BiometricEncryption" is be_passphrase.
   *                       Should contain ASCII characters only.
   * - @b Comment          The comment.
   *                       For DigSig signature fields, the comment may be used
   *                       for the appearance stream of PDF documents
   *                       (see ti_comment).
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
   *                       (see ti_contact_info).
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
   *                       SignDocDocument::addSignature() will fail if no
   *                       matching certificate is available for signing.
   *                       Note that csf_software and/or csf_hardware must
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
   *                       SignDocDocument::addSignature() will fail if no
   *                       matching certificate is available for signing.
   *                       Note that csf_software and/or csf_hardware must
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
   *                       (see ti_location).
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
   *                       (see ti_reason).
   *                       The default value is empty.
   *                       Complex scripts are supported,
   *                       see @ref signdocshared_complex_scripts.
   * - @b Signer           The signer name.
   *                       This is the signer name that will be stored in the
   *                       digital signature. If not set, the name will be
   *                       taken from the certificate.
   *                       For DigSig signature fields, the signer name may be
   *                       used for the appearance stream of PDF documents
   *                       (see ti_signer).
   *                       The default value is empty (meaning that the name
   *                       will be taken from the certificate).
   *                       See also string parameter "CommonName".
   *                       Complex scripts are supported,
   *                       see @ref signdocshared_complex_scripts.
   * - @b SignTime         The time of signing in free format.
   *                       For DigSig signature fields, the time of
   *                       signing may be used for the appearance
   *                       stream of PDF documents (see ti_sign_time).
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
   *                       returned by SignDocDocument::addSignature() if
   *                       a time-stamp server is to be used and integer
   *                       parameter "Method" is not m_digsig_pkcs7_detached
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
   * @param[in] aEncoding  The encoding used for @a aValue.
   * @param[in] aName   The name of the parameter (case-sensitive).
   * @param[in] aValue  The value of the parameter. The encoding is specified
   *                    by @a aEncoding.
   *   
   *
   * @return rc_ok if successful.
   */
  ReturnCode setString (Encoding aEncoding, const std::string &aName,
                        const std::string &aValue)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_SignatureParameters_setString (&ex, p, aEncoding, aName.c_str (), aValue.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set a string parameter.
   *
   * See the other setString() function for a list of available
   * string parameters.
   *
   * @param[in] aName   The name of the parameter (case-sensitive).
   * @param[in] aValue  The value of the parameter.
   *
   * @return rc_ok if successful.
   */
  ReturnCode setString (const std::string &aName, const wchar_t *aValue)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_SignatureParameters_setStringW (&ex, p, aName.c_str (), aValue);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set an integer parameter.
   *
   * Available integer parameters are:
   * - @b %BiometricEncryption   Specifies how biometric data is to be
   *                       encrypted (enum #BiometricEncryption).
   *                       If not set, biometric data will not be embedded
   *                       in the signature.
   * - @b %CertificateSigningAlgorithm  The signing algorithm for the self-signed
   *                       certificate (enum #CertificateSigningAlgorithm).
   *                       When a self-signed certificate is to be generated,
   *                       the signing algorithm can be set. If not set, a
   *                       suitable default value will be used.
   * - @b %DetachedHashAlgorithm  Hash algorithm to be used for a detached signature
   *                       (ie, if integer parameter "Method" is
   *                       m_digsig_pkcs7_detached).
   *                       See enum #DetachedHashAlgorithm.
   *                       The default value is dha_default.
   * - @b GenerateKeyPair  Start generation of a key pair for the self-signed
   *                       certificate.  The value is the number of bits
   *                       (1024 through 4096, multiple of 8).
   *                       When a self-signed certificate is to be generated,
   *                       the private key can be either be generated by
   *                       setting this parameter or set as blob parameter
   *                       "CertificatePrivateKey".
   * - @b ImageHAlignment  The horizontal alignment of the image
   *                       (enum #HAlignment).
   *                       For DigSig signature fields, this parameter
   *                       defines the horizontal alignment of the image
   *                       in the appearance stream of PDF documents.
   *                       The default value depends on the profile
   *                       passed to
   *                       SignDocDocument::createSignatureParameters().
   * - @b ImageVAlignment  The vertical alignment of the image
   *                       (enum #VAlignment).
   *                       For DigSig signature fields, this parameter
   *                       defines the vertical alignment of the image
   *                       in the appearance stream of PDF documents.
   *                       The default value depends on the profile
   *                       passed to
   *                       SignDocDocument::createSignatureParameters().
   * - @b ImageTransparency  Image transparency (enum #ImageTransparency).
   *                       For DigSig signature fields, this parameter
   *                       defines how to handle transparency for signature
   *                       image (either the image passed in the "Image"
   *                       blob parameter or the image computed according
   *                       to the "RenderSignature" integer parameter).
   *                       The default value is it_brightest.
   * - @b %Method          The signing method (enum #Method).
   *                       If no signing method is set, a suitable
   *                       default method will be used.
   * - @b %Optimize        Set whether this is the first signature of the
   *                       document and the document shall be optimized or
   *                       whether the document shall not be optimized.
   *                       Use one of the values of enum #Optimize.
   *                       For PDF documents, o_optimize requires saving to
   *                       a new file, see string parameter "OutputPath".
   *                       The default value is o_dont_optimize.
   *                       If the return value of getRequiredSaveToFileFlags()
   *                       includes sf_incremental, signing with this parameter
   *                       set to o_optimize will fail.
   * - @b %PDFAButtons     Set whether appearance streams of check boxes
   *                       and radio buttons shall be frozen (fixed) for
   *                       PDF/A compliance before signing.
   *                       Use one of the values of enum #PDFAButtons.
   *                       The default value is pb_auto.
   * - @b PenWidth         Pen width for rendering the signature (see blob
   *                       parameter "BiometricData") for the signature image.
   *                       Ignored unless integer parameter "RenderSignature"
   *                       is non-zero.
   *                       The pen width is specified in micrometers, the
   *                       default value is 500 (0.5mm).
   * - @b RenderSignature  Specifies whether and how the signature (see blob
   *                       parameter "BiometricData") is to be
   *                       rendered for the signature image.  This parameter
   *                       contains a set of flags taken from
   *                       enum #RenderSignatureFlags.
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
   *                       The parameter contains a set of flags taken from
   *                       enum #CertificateSelectionFlags.
   *                       If this parameter is zero (which is the default
   *                       value), the user won't be asked and the certificate
   *                       will either be generated on the fly or be supplied
   *                       by the "Certificate" blob parameter and
   *                       SignDocDocument::addSignature() will fail if the
   *                       PDF document restricts acceptable certificates by
   *                       means of a certificate seed value dictionary.
   *                       This parameter is not yet implemented under Linux,
   *                       iOS, Android, and OS X.
   * - @b TextHAlignment   The horizontal alignment of text lines
   *                       (enum #HAlignment).
   *                       For DigSig signature fields, this parameter
   *                       defines the horizontal alignment of text lines
   *                       in the appearance stream of PDF documents.
   *                       The default value depends on the profile
   *                       passed to
   *                       SignDocDocument::createSignatureParameters().
   * - @b %TextPosition    The position of the text block w.r.t. the image
   *                       (enum #TextPosition).
   *                       For DigSig signature fields, this parameter
   *                       defines the position of the text block in the
   *                       appearance stream of PDF documents.  The
   *                       default value depends on the profile passed
   *                       to SignDocDocument::createSignatureParameters().
   * - @b TextVAlignment   The vertical alignment of text lines
   *                       (enum #VAlignment).
   *                       For DigSig signature fields, this parameter
   *                       defines the vertical alignment of text lines
   *                       in the appearance stream of PDF documents.
   *                       The default value depends on the profile
   *                       passed to
   *                       SignDocDocument::createSignatureParameters().
   * - @b %TimeStampHashAlgorithm  Hash algorithm for RFC 3161 time stamps.
   *                       See enum #TimeStampHashAlgorithm.
   *                       The default value is tsha_default.
   *                       See also string parameter "TimeStampServerURL".
   * - @b TimeStampServerTimeout  Time out in milliseconds for retrieving
   *                       a time stamp from an RFC 3161 time-stamp server.
   *                       The value must be positive. The default value
   *                       is 10000.
   *                       See also string parameter "TimeStampServerURL".
   * .
   *
   * @param[in] aName   The name of the parameter (case-sensitive).
   * @param[in] aValue  The value of the parameter.
   *
   * @return rc_ok if successful.
   *
   * @todo document when "SelectCertificate" presents the dialog
   * @todo implement "SelectCertificate" for Linux
   */
  ReturnCode setInteger (const std::string &aName, int aValue)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_SignatureParameters_setInteger (&ex, p, aName.c_str (), aValue);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set a blob parameter.
   *
   * Available blob parameters are:
   * - @b BiometricData    The biometric data must either be in
   *                       SignWare format (created by
   *                       SPFlatFileCreateFromSignature()).
   *                       The biometric data is stored in the document
   *                       (see integer parameter "BiometricEncryption")
   *                       and will be used for rendering the signature image
   *                       if integer parameter "RenderSignature" is non-zero
   *                       (unless a signature image is specified by blob
   *                       parameter "Image").
   * - @b BiometricKey     The public key (be_rsa) or the AES key (be_binary)
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
   *                       SignDocDocument::addSignature() will fail if no
   *                       matching certificate is available for signing.
   *                       Note that csf_software and/or csf_hardware must
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
   *                       SignDocDocument::addSignature() will fail if no
   *                       matching certificate is available for signing.
   *                       Note that csf_software and/or csf_hardware must
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
   * @param[in] aName   The name of the parameter (case-sensitive).
   * @param[in] aData   A pointer to the first octet of the value.
   * @param[in] aSize   Size of the blob (number of octets).
   *
   * @return rc_ok if successful.
   *
   * @todo support PKCS #7 for "Certificate"
   */
  ReturnCode setBlob (const std::string &aName, const unsigned char *aData,
                      size_t aSize)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_SignatureParameters_setBlob (&ex, p, aName.c_str (), aData, aSize);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   *                       SignDocDocument::createSignatureParameters().
   *                       See also string parameter "FontName" and
   *                       color parameter "TextColor".
   * - @b ImageMargin      The margin to add around the image.
   *                       For DigSig signature fields, this parameter
   *                       defines the margin to be added around the
   *                       image in the appearance stream of PDF
   *                       documents.  This margin is added at all
   *                       four edges of the image.  The default value
   *                       depends on the profile passed to
   *                       SignDocDocument::createSignatureParameters().
   * - @b TextHMargin      The horizontal margin for text.
   *                       For DigSig signature fields, this parameter
   *                       defines the horizontal margin of text in the
   *                       appearance stream of PDF documents.
   *                       If the text is justified, @a aValue/2 will be used
   *                       for the two margins.
   *                       If the text is centered, this value will be ignored.
   *                       The default value depends on the profile passed
   *                       to SignDocDocument::createSignatureParameters().
   * .
   *
   * @param[in] aName   The name of the parameter (case-sensitive).
   * @param[in] aType   Define how the length is specified.
   * @param[in] aValue  The value of the parameter.
   *
   * @return rc_ok if successful.
   */
  ReturnCode setLength (const std::string &aName, ValueType aType,
                        double aValue)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_SignatureParameters_setLength (&ex, p, aName.c_str (), aType, aValue);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   * @param[in] aName   The name of the parameter (case-sensitive).
   * @param[in] aValue  The value of the parameter.
   *
   * @return rc_ok if successful.
   */
  ReturnCode setColor (const std::string &aName, const SignDocColor &aValue)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_SignatureParameters_setColor (&ex, p, aName.c_str (), aValue.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Add another string to be displayed, top down.
   *
   * For DigSig signature fields, this function adds another string to
   * the appearance stream of PDF documents.
   * The first call clears any default strings.
   * The default values depend on the profile passed to
   * SignDocDocument::createSignatureParameters().
   *
   * @param[in] aItem   Select the string to be added.
   * @param[in] aGroup  The string's group for font size computation.
   *
   * @return rc_ok if successful.
   *
   * @see clearTextItems()
   */
  ReturnCode addTextItem (TextItem aItem, TextGroup aGroup)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_SignatureParameters_addTextItem (&ex, p, aItem, aGroup);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Remove all strings that were to be displayed.
   *
   * addTextItem() cannot remove the default strings without adding
   * a new string. This function does.
   *
   * @return rc_ok if successful.
   *
   * @see addTextItem()
   */
  ReturnCode clearTextItems ()
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_SignatureParameters_clearTextItems (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   * - Method             must be m_digsig_pkcs7_detached
   *                      or m_digsig_pkcs7_sha1
   * - SelectCertificate  must be zero (which is the default value)
   * .
   *
   * Requirements for blob parameters:
   * - Certificate        must not be set
   * - CertificatePrivateKey   must not be set
   * .
   *
   * @param[in] aPKCS7  The object that will create the PKCS #7 signature.
   *                    This function does not take ownership of that object.
   *
   * @return rc_ok if successful.
   */
  ReturnCode setPKCS7 (SignPKCS7 *aPKCS7)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_SignatureParameters_setPKCS7 (&ex, p, aPKCS7->getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get a bitset indicating which signing methods are available
   *        for this signature field.
   *
   * @return 1&lt;&lt;m_digsig_pkcs1 etc.
   *
   * @see SignDocDocument::getAvailableMethods()
   */
  int getAvailableMethods ()
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_SignatureParameters_getAvailableMethods (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get an error message for the last function call.
   *
   * @param[in] aEncoding  The encoding to be used for the error message.
   *
   * @return A pointer to a string describing the reason for the
   *         failure of the last function call. The string is empty
   *         if the last call succeeded. The pointer is valid until
   *         this object is destroyed or a member function of this
   *         object is called.
   *
   * @see getErrorMessageW()
   */
  const char *getErrorMessage (Encoding aEncoding) const
  {
    SIGNDOC_Exception *ex = NULL;
    const char *r;
    r = SIGNDOC_SignatureParameters_getErrorMessage (&ex, p, aEncoding);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get an error message for the last function call.
   *
   * @return A pointer to a string describing the reason for the
   *         failure of the last function call. The string is empty
   *         if the last call succeeded. The pointer is valid until
   *         this object is destroyed or a member function of this
   *         object is called.
   *
   * @see getErrorMessage()
   */
  const wchar_t *getErrorMessageW () const
  {
    SIGNDOC_Exception *ex = NULL;
    const wchar_t *r;
    r = SIGNDOC_SignatureParameters_getErrorMessageW (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

private:
  /**
   * @brief Copy Constructor (unavailable).
   */
  SignDocSignatureParameters (const SignDocSignatureParameters &);

  /**
   * @brief Assignment operator (unavailable).
   */
  SignDocSignatureParameters &operator= (const SignDocSignatureParameters &);
public:
  /**
   * @brief Internal function.
   * @internal
   */
  SignDocSignatureParameters (SIGNDOC_SignatureParameters *aP) : p (aP) { }

  /**
   * @brief Internal function.
   * @internal
   */
  SIGNDOC_SignatureParameters *getImpl () { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  const SIGNDOC_SignatureParameters *getImpl () const { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  void setImpl (SIGNDOC_SignatureParameters *aP) { SIGNDOC_SignatureParameters_delete (p); p  = aP; }

private:
  SIGNDOC_SignatureParameters *p;
};

/**
 * @brief One property, without value.
 *
 * Use SignDocDocument::getBooleanProperty(),
 * SignDocDocument::getIntegerProperty(), or
 * SignDocDocument::getStringProperty() to get the value of a
 * property.
 */
class SignDocProperty 
{
public:

public:
  /**
   * @brief Property types.
   */
  enum Type
  {
    t_string,
    t_integer,
    t_boolean
  };

public:
  /**
   * @brief Constructor.
   */
  SignDocProperty ()
    : p (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_Property_new (&ex);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Copy constructor.
   *
   * @param[in] aSource  The object to be copied.
   */
  SignDocProperty (const SignDocProperty &aSource)
    : p (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_Property_clone (&ex, aSource.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Destructor.
   */
  ~SignDocProperty ()
  {
    SIGNDOC_Property_delete (p);
  }

  /**
   * @brief Efficiently swap this object with another one.
   *
   * @param[in] aOther  The other object.
   */
  void swap (SignDocProperty &aOther)
  {
    std::swap (p, aOther.p);
  }

  /**
   * @brief Get the name of the property.
   *
   * Property names are compared under Unicode simple case folding, that is,
   * lower case and upper case is not distinguished.
   *
   * This function throws de::softpro::spooc::EncodingError if
   * the name cannot be represented using the specified encoding.
   *
   * @param[in] aEncoding  The encoding to be used for the return value.
   *
   * @return The name of the property.
   *
   * @see getNameUTF8()
   */
  std::string getName (Encoding aEncoding) const
  {
    SIGNDOC_Exception *ex = NULL;
    std::string r;
    char *s = SIGNDOC_Property_getName (&ex, p, aEncoding);
    if (ex != NULL) SignDoc_throw (ex);
    try
      {
        r = s;
      }
    catch (...)
      {
        SIGNDOC_free (s);
        throw;
      }
    SIGNDOC_free (s);
    return r;
  }

  /**
   * @brief Get the name of the property as UTF-8-encoded C string.
   *
   * Property names are compared under Unicode simple case folding, that is,
   * lower case and upper case is not distinguished.
   *
   * @return The name of the property.  This pointer will become invalid
   *         when setName() is called or this object is destroyed.
   *
   * @see getName()
   */
  const char *getNameUTF8 () const
  {
    SIGNDOC_Exception *ex = NULL;
    const char *r;
    r = SIGNDOC_Property_getNameUTF8 (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the type of the property.
   *
   * @return The type of the property.
   */
  Type getType () const
  {
    SIGNDOC_Exception *ex = NULL;
    Type r;
    r = (Type)SIGNDOC_Property_getType (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

private:
public:
  /**
   * @brief Internal function.
   * @internal
   */
  SignDocProperty (SIGNDOC_Property *aP) : p (aP) { }

  /**
   * @brief Internal function.
   * @internal
   */
  SIGNDOC_Property *getImpl () { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  const SIGNDOC_Property *getImpl () const { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  void setImpl (SIGNDOC_Property *aP) { SIGNDOC_Property_delete (p); p  = aP; }

private:
  SIGNDOC_Property *p;
};

/**
 * @brief Internal function.
 * @internal
 */
inline void assignArray (std::vector<SignDocProperty> &aDst,
                         SIGNDOC_PropertyArray *aSrc)
{
  aDst.clear ();
  unsigned n = SIGNDOC_PropertyArray_count (aSrc);
  if (aSrc == NULL)
    return;
  aDst.resize (n);
  for (unsigned i = 0; i < n; ++i)
    {
      SIGNDOC_Exception *ex = NULL;
      SIGNDOC_Property *p = SIGNDOC_Property_clone (&ex, SIGNDOC_PropertyArray_at (aSrc, i));
      if (ex != NULL) SignDoc_throw (ex);
      aDst[i].setImpl (p);
    }
}

/**
 * @brief An annotation.
 *
 * Currently, annotations are supported for PDF documents only.
 *
 * @see createLineAnnotation(), createScribbleAnnotation(), createFreeTextAnnotation(), getAnnotation()
 */
class SignDocAnnotation 
{
public:
  /**
   * @brief Annotation types.
   *
   * Most annotation types are supported for PDF documents only.
   */
  enum Type
  {
    t_unknown,              ///< Unknown annotation type.
    t_line,                 ///< Line annotation.
    t_scribble,             ///< Scribble annotation (freehand scribble).
    t_freetext              ///< FreeText annotation.
  };

  /**
   * @brief Line ending styles.
   */
  enum LineEnding
  {
    le_unknown,             ///< Unknown line ending style.
    le_none,                ///< No line ending.
    le_arrow                ///< Two short lines forming an arrowhead.
  };

  /**
   * @brief Horizontal alignment.
   */
  enum HAlignment
  {
    ha_left, ha_center, ha_right
  };

  /**
   * @brief Return codes.
   */
  enum ReturnCode
  {
    rc_ok,                      ///< Parameter set successfully.
    rc_not_supported,           ///< Setting the parameter is not supported.
    rc_invalid_value,           ///< The value for the parameter is invalid.
    rc_not_available            ///< The value is not available.
  };

protected:
  /**
   * @brief Constructor.
   */
  SignDocAnnotation ()
    : p (NULL)
  {
  }

public:
  /**
   * @brief Destructor.
   */
  ~SignDocAnnotation ()
  {
    SIGNDOC_Annotation_delete (p);
  }

  /**
   * @brief Get the type of the annotation.
   *
   * @return The type of the annotation.
   */
  Type getType () const
  {
    SIGNDOC_Exception *ex = NULL;
    Type r;
    r = (Type)SIGNDOC_Annotation_getType (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the name of the annotation.
   *
   * @param[in]  aEncoding  The encoding to be used for the return value.
   *
   * @return The name of the annotation or an empty string if the name is
   *         not available.
   */
  std::string getName (Encoding aEncoding) const
  {
    SIGNDOC_Exception *ex = NULL;
    std::string r;
    char *s = SIGNDOC_Annotation_getName (&ex, p, aEncoding);
    if (ex != NULL) SignDoc_throw (ex);
    try
      {
        r = s;
      }
    catch (...)
      {
        SIGNDOC_free (s);
        throw;
      }
    SIGNDOC_free (s);
    return r;
  }

  /**
   * @brief Get the page number of the annotation.
   *
   * The page number is available for objects returned by
   * SignDocDocument::getAnnotation() only.
   *
   * @return the 1-based page number of the annotation or 0 if the page
   *         number is not available.
   */
  int getPage () const
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_Annotation_getPage (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the bounding box of the annotation.
   *
   * The bounding box is available for objects returned by
   * SignDocDocument::getAnnotation() only.
   *
   * @param[out] aOutput  The bounding box (using document coordinates, see
   *          @ref signdocshared_coordinates) will be stored here.
   *
   * @return rc_ok if successful.
   */
  ReturnCode getBoundingBox (Rect &aOutput) const
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Annotation_getBoundingBox (&ex, p, (SIGNDOC_Rect*)&aOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the name of the annotation.
   *
   * In PDF documents, an annotation can have a name.  The names of
   * annotations must be unique within a page.  By default, annotations
   * are unnamed.
   *
   * @param[in] aEncoding  The encoding of @a aName.
   * @param[in] aName  The name of the annotation.
   *
   * @return rc_ok if successful.
   */
  ReturnCode setName (Encoding aEncoding, const std::string &aName)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Annotation_setName (&ex, p, aEncoding, aName.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the name of the annotation.
   *
   * In PDF documents, an annotation can have a name.  The names of
   * annotations must be unique within a page.  By default, annotations
   * are unnamed.
   *
   * @param[in] aName  The name of the annotation.
   *
   * @return rc_ok if successful.
   */
  ReturnCode setName (const wchar_t *aName)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Annotation_setNameW (&ex, p, aName);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set line ending styles.
   *
   * This function can be used for annotations of type t_line.
   * The default line ending style is le_none.
   *
   * @param[in] aStart  Line ending style for start point.
   * @param[in] aEnd    Line ending style for end point.
   *
   * @return rc_ok if successful.
   */
  ReturnCode setLineEnding (LineEnding aStart, LineEnding aEnd)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Annotation_setLineEnding (&ex, p, aStart, aEnd);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the foreground color of the annotation.
   *
   * This function can be used for annotations of types t_line, t_scribble,
   * and t_freetext.
   *
   * The default foreground color is black.
   *
   * @param[in] aColor  The foreground color of the annotation.
   *
   * @return rc_ok if successful.
   */
  ReturnCode setColor (const SignDocColor &aColor)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Annotation_setColor (&ex, p, aColor.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the background color of the annotation.
   *
   * This function can be used for annotations of type t_freetext.
   *
   * The default background color is white.
   *
   * @param[in] aColor  The background color of the annotation.
   *
   * @return rc_ok if successful.
   */
  ReturnCode setBackgroundColor (const SignDocColor &aColor)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Annotation_setBackgroundColor (&ex, p, aColor.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the border color of the annotation.
   *
   * This function can be used for annotations of type t_freetext.
   *
   * The default border color is black.
   *
   * @param[in] aColor  The border color of the annotation.
   *
   * @return rc_ok if successful.
   *
   * @see setBorderLineWidthInPoints()
   */
  ReturnCode setBorderColor (const SignDocColor &aColor)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Annotation_setBorderColor (&ex, p, aColor.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the opacity of the annotation.
   *
   * This function can be used for annotations of types t_line, t_scribble,
   * and t_freetext.
   *
   * The default opacity is 1.0. Documents conforming to PDF/A must
   * use an opacity of 1.0.
   *
   * @param[in] aOpacity  The opacity, 0.0 (transparent) through 1.0 (opaque).
   *
   * @return rc_ok if successful.
   */
  ReturnCode setOpacity (double aOpacity)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Annotation_setOpacity (&ex, p, aOpacity);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set line width in points.
   *
   * This function can be used for annotations of types t_line and t_scribble.
   * The default line width for PDF documents is 1 point.
   *
   * @param[in] aWidth  The line width in points (1/72 inch).
   *
   * @return rc_ok if successful.
   */
  ReturnCode setLineWidthInPoints (double aWidth)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Annotation_setLineWidthInPoints (&ex, p, aWidth);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set border line width in points.
   *
   * This function can be used for annotations of type t_freetext.
   * The default border line width for PDF documents is 1 point.
   *
   * @param[in] aWidth  The border line width in points (1/72 inch).  If this
   *                    value is negative, no border lines will be drawn.
   *
   * @return rc_ok if successful.
   *
   * @see setBorderColor()
   */
  ReturnCode setBorderLineWidthInPoints (double aWidth)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Annotation_setBorderLineWidthInPoints (&ex, p, aWidth);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Start a new stroke in a scribble annotation.
   *
   * This function can be used for annotations of type t_scribble.
   * Each stroke must contain at least two points.  This function need
   * not be called for the first stroke of a scribble annotation.
   *
   * @return rc_ok if successful.
   *
   * @see addPoint()
   */
  ReturnCode newStroke ()
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Annotation_newStroke (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Add a point to the current stroke of a scribble annotation.
   *
   * This function can be used for annotations of type t_scribble.
   * Each stroke must contain at least two points.
   * This function uses document (page) coordinates,
   * see @ref signdocshared_coordinates.
   *
   * @param[in] aPoint  The point to be added.
   *
   * @return rc_ok if successful.
   *
   * @see newStroke()
   */
  ReturnCode addPoint (const Point &aPoint)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Annotation_addPoint (&ex, p, (const SIGNDOC_Point*)&aPoint);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Add a point to the current stroke of a scribble annotation.
   *
   * This function can be used for annotations of type t_scribble.
   * Each stroke must contain at least two points.
   * This function uses document (page) coordinates,
   * see @ref signdocshared_coordinates.
   *
   * @param[in] aX  The X coordinate of the point.
   * @param[in] aY  The Y coordinate of the point.
   *
   * @return rc_ok if successful.
   *
   * @see newStroke()
   */
  ReturnCode addPoint (double aX, double aY)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Annotation_addPointXY (&ex, p, aX, aY);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the text of a text annotation.
   *
   * This function can be used for annotations of type t_freetext.
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
   * @param[in] aEncoding    The encoding of @a aText and @a aFont.
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
   * @param[in] aHAlignment  Horizontal alignment of the text.
   *
   * @see getFont(), getPlainText(), SignDocDocumentLoader::loadFontConfigFile(), SignDocDocumentLoader::loadFontConfigEnvironment(), SignDocDocumentLoader::loadFontConfigStream()
   */
  ReturnCode setPlainText (Encoding aEncoding, const std::string &aText,
                           const std::string &aFont, double aFontSize,
                           HAlignment aHAlignment)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Annotation_setPlainText (&ex, p, aEncoding, aText.c_str (), aFont.c_str (), aFontSize, aHAlignment);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the text of a text annotation.
   *
   * @param[in] aEncoding    The encoding to be used for the text returned
   *                         in @a aText.
   *
   * @param[out] aText       The text will be stored here. The start of
   *                         a new paragraph (except for the first one)
   *                         is represented by CR and/or LF characters.
   *
   * @return rc_ok if successful.
   *
   * @see getFont(), setPlainText()
   */
  ReturnCode getPlainText (Encoding aEncoding, std::string &aText)
  {
    SIGNDOC_Exception *ex = NULL;
    char *tempText = NULL;
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_Annotation_getPlainText (&ex, p, aEncoding, &tempText);
        if (tempText != NULL)
          aText = tempText;
      }
    catch (...)
      {
        SIGNDOC_free (tempText);
        throw;
      }
    SIGNDOC_free (tempText);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the font of a text annotation.
   *
   * @param[in] aEncoding    The encoding to be used for the font name returned
   *                         in @a aFont.
   *
   * @param[out] aFont       The font name will be stored here.
   * @param[out] aFontSize   The font size in user space units will be stored
   *                         here.
   *
   * @return rc_ok if successful.
   *
   * @see getPlainText(), setPlainText()
   *
   * @todo define behavior if there are multiple fonts
   */
  ReturnCode getFont (Encoding aEncoding, std::string &aFont,
                      double &aFontSize)
  {
    SIGNDOC_Exception *ex = NULL;
    char *tempFont = NULL;
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_Annotation_getFont (&ex, p, aEncoding, &tempFont, &aFontSize);
        if (tempFont != NULL)
          aFont = tempFont;
      }
    catch (...)
      {
        SIGNDOC_free (tempFont);
        throw;
      }
    SIGNDOC_free (tempFont);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }
  /**
   * @brief Internal function.
   * @internal
   */
  SignDocAnnotation (SIGNDOC_Annotation *aP) : p (aP) { }

  /**
   * @brief Internal function.
   * @internal
   */
  SIGNDOC_Annotation *getImpl () { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  const SIGNDOC_Annotation *getImpl () const { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  void setImpl (SIGNDOC_Annotation *aP) { SIGNDOC_Annotation_delete (p); p  = aP; }

private:
  SIGNDOC_Annotation *p;
};

/**
 * @brief Position of a character.
 *
 * This class uses document coordinates, see @ref signdocshared_coordinates.
 */
class SignDocCharacterPosition 
{
public:
  int mPage;                    ///< 1-based page number.
  Point mRef; ///< Reference point.
  Rect mBox;  ///< Bounding box (all four values are zero if not available).
};

/**
 * @brief Position of a hit returned by SignDocDocument::findText().
 */
class SignDocFindTextPosition 
{
public:
  SignDocCharacterPosition mFirst;   ///< First character
  SignDocCharacterPosition mLast;    ///< Last character
};

/**
 * @brief Internal function.
 * @internal
 */
inline void assignArray (std::vector<SignDocFindTextPosition> &aDst,
                         SIGNDOC_FindTextPositionArray *aSrc)
{
  if (aSrc == NULL)
    aDst.clear ();
  else
    {
      unsigned n = SIGNDOC_FindTextPositionArray_count (aSrc);
      aDst.resize (n);
      for (unsigned i = 0; i < n; ++i)
        aDst[i] = *(const SignDocFindTextPosition*)SIGNDOC_FindTextPositionArray_at (aSrc, i);
    }
}

/**
 * @brief Parameters for SignDocDocument::renderPageAsImage(),
 *        SignDocDocument::renderPageAsSpoocImage(), and
 *        SignDocDocument::renderPageAsSpoocImages().
 */
class SignDocRenderParameters 
{
public:
  /**
   * @brief Interlacing methods for setInterlacing().
   */
  enum Interlacing
  {
    /**
     * @brief No interlacing.
     */
    i_off,

    /**
     * @brief Enable Interlacing.
     *
     * A suitable interlacing method for the chosen image format will be used.
     */
    i_on
  };

  /**
   * @brief Quality of the rendered image.
   */
  enum Quality
  {
    /**
     * @brief Low quality, fast.
     */
    q_low,

    /**
     * @brief High quality, slow.
     */
    q_high
  };

  /**
   * @brief Pixel format for the rendered image.
   */
  enum PixelFormat
  {
    /**
     * @brief RGB for PDF documents, same as document for TIFF documents.
     */
    pf_default,

    /**
     * @brief Black and white (1 bit per pixel).
     */
    pf_bw
  };

  /**
   * @brief Compression for the rendered image.
   *
   * Not all compressions are available for all formats.
   * In fact, all these compressions are available for TIFF only.
   */
  enum Compression
  {
    c_default,     ///< no compression for PDF documents, same as document for TIFF documents
    c_none,        ///< no compression
    c_group4,      ///< CCITT Group 4
    c_lzw,         ///< LZW
    c_rle,         ///< RLE
    c_zip          ///< ZIP
  };

  /**
   * @brief Policy for verification of the certificate chain.
   *
   * @see setCertificateChainVerificationPolicy()
   */
  enum CertificateChainVerificationPolicy
  {
    /**
     * @brief Don't verify certificate chain.
     *
     * Always pretend that the certificate chain is OK.
     */
    ccvp_dont_verify,

    /**
     * @brief Accept self-signed certificates.
     *
     * If the signing certificate is not self-signed, it must chain up
     * to a trusted root certificate.
     */
    ccvp_accept_self_signed,

    /**
     * @brief Accept self-signed certificates if biometric data is present.
     *
     * If the signing certificate is not self-signed or if there is no
     * biometric data, the certificate must chain up to a trusted root
     * certificate.
     */
    ccvp_accept_self_signed_with_bio,

    /**
     * @brief Accept self-signed certificates if asymmetrically encrypted
     *        biometric data is present.
     *
     * If the signing certificate is not self-signed or if there is no
     * biometric data or if the biometric data is not encrypted with
     * RSA, the certificate must chain up to a trusted root
     * certificate.
     */
    ccvp_accept_self_signed_with_rsa_bio,

    /**
     * @brief Require a trusted root certificate.
     *
     * The signing certificate must chain up to a trusted root
     * certificate.
     */
    ccvp_require_trusted_root
  };

  /**
   * @brief Policy for verification of certificate revocation.
   *
   * @see setCertificateRevocationVerificationPolicy()
   */
  enum CertificateRevocationVerificationPolicy
  {
    /**
     * @brief Don't verify revocation of certificates.
     *
     * Always pretend that certificates have not been revoked.
     */
    crvp_dont_check,

    /**
     * @brief Check revocation, assume that certificates are not revoked
     *        if the revocation server is offline.
     */
    crvp_offline,

    /**
     * @brief Check revocation, assume that certificates are revoked
     *        if the revocation server is offline.
     */
    crvp_online
  };

  /**
   * @brief Certificate verification model.
   *
   * @see setVerificationModel()
   */
  enum VerificationModel
  {
    /**
     * @brief Whatever the Windows Crypto API or OpenSSL implements.
     */
    vm_default,

    /**
     * @brief As specfified by German law.
     *
     * @todo implement this
     * @todo name that law
     */
    vm_german_sig_law
  };

public:
  /**
   * @brief Constructor.
   */
  SignDocRenderParameters ()
    : p (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_RenderParameters_new (&ex);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Copy constructor.
   *
   * @param[in] aSource  The object to be copied.
   */
  SignDocRenderParameters (const SignDocRenderParameters &aSource)
    : p (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_RenderParameters_clone (&ex, aSource.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Destructor.
   */
  ~SignDocRenderParameters ()
  {
    SIGNDOC_RenderParameters_delete (p);
  }

  /**
   * @brief Assignment operator.
   *
   * @param[in] aSource  The source object.
   */
  SignDocRenderParameters &operator= (const SignDocRenderParameters &aSource)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_RenderParameters_assign (&ex, p, aSource.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return *this;
  }

  /**
   * @brief "Less than" operator.
   *
   * @param[in] aOther  The object to compare against.
   */
  bool operator< (const SignDocRenderParameters &aOther) const
  {
    return (bool)SIGNDOC_RenderParameters_isLessThan (p, aOther.getImpl ());
  }

  /**
   * @brief Select the page to be rendered.
   *
   * There is no initial value, ie, either this function or
   * setPages() must be called.
   *
   * @param[in]  aPage  The page number (1 for the first page).
   *
   * @return true if successful, false if the page number is invalid.
   *
   * @see getPage(), setPages()
   */
  bool setPage (int aPage)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_setPage (&ex, p, aPage);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the number of the selected page.
   *
   * @param[out]  aPage  The page number (1 for the first page) will be
   *                     stored here.
   *
   * @return true if successful, false if setPage() has not been called
   *         successfully or if multiple pages have been selected with
   *         setPages()
   *
   * @see getPages(), setPage()
   */
  bool getPage (int &aPage) const
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_getPage (&ex, p, &aPage);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Select a range of pages to be rendered.
   *
   * There is no initial value, ie, either this function or
   * setPage() must be called.
   *
   * @note If multiple pages are selected, the image format must be "tiff"
   *       for SignDocDocument::renderPageAsImage().
   *
   * @param[in]  aFirst  The first page number of the range (1 for the
   *                     first page of the document).
   * @param[in]  aLast   The last page number of the range (1 for the
   *                     first page of the document).
   *
   * @return true if successful, false if the page numbers are invalid.
   *
   * @see getPages(), setFormat(), setPage()
   *
   * @todo implement for TIFF documents
   */
  bool setPages (int aFirst, int aLast)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_setPages (&ex, p, aFirst, aLast);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the selected range of page numbers.
   *
   * @param[out]  aFirst The first page number of the range (1 for the
   *                     first page of the document) will be
   *                     stored here.
   * @param[out]  aLast  The last page number of the range (1 for the
   *                     first page of the document) will be
   *                     stored here.
   *
   * @return true if successful, false if setPage() and setPages() have
   *         not been called.
   *
   * @see getPage(), setPages()
   */
  bool getPages (int &aFirst, int &aLast) const
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_getPages (&ex, p, &aFirst, &aLast);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /** @brief Set the resolution for rendering PDF documents.
   *
   * The values passed to this function will be ignored for TIFF
   * documents as the resolution is computed automatically from the
   * zoom factor and the document's resolution.
   *
   * If this function is not called, 96 DPI (subject to change) will
   * be used for rendering PDF documents.
   *
   * @param[in] aResX  Horizontal resolution in DPI.
   * @param[in] aResY  Vertical resolution in DPI.
   *
   * @return true if successful, false if the resolution is invalid.
   *
   * @see getResolution(), setZoom()
   */
  bool setResolution (double aResX, double aResY)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_setResolution (&ex, p, aResX, aResY);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /** @brief Get the resolution set by setResolution().
   *
   * @param[out] aResX  Horizontal resolution in DPI.
   * @param[out] aResY  Vertical resolution in DPI.
   *
   * @return true if successful, false if setResolution() has not been
   *         called successfully.
   *
   * @see setResolution()
   */
  bool getResolution (double &aResX, double &aResY) const
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_getResolution (&ex, p, &aResX, &aResY);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the zoom factor for rendering.
   *
   * There is no initial value, ie, this function or fitWidth() or
   * fitHeight() or fitRect() must be called.  This function overrides
   * fitWidth(), fitHeight(), and fitRect().
   *
   * @param[in]  aZoom  The zoom factor.
   *
   * @return true if successful, false if the zoom factor is invalid.
   *
   * @see fitHeight(), fitRect(), fitWidth(), getZoom()
   */
  bool setZoom (double aZoom)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_setZoom (&ex, p, aZoom);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the zoom factor set by setZoom().
   *
   * This function does not retrieve the zoom factor to be computed for
   * fitWidth(), fitHeight(), and fitRect(). Use SignDocDocument::computeZoom()
   * for that.
   *
   * @param[out]  aZoom  The zoom factor will be stored here.
   *
   * @return true if successful, false if setZoom() has not been
   *         called successfully or has been overridden.
   *
   * @see fitHeight(), fitRect(), fitWidth(), setZoom(), SignDocDocument::computeZoom()
   */
  bool getZoom (double &aZoom) const
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_getZoom (&ex, p, &aZoom);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the width for automatic computation of the zoom factor
   *        to make the rendered image fit the specified width.
   *
   * This function overrides the zoom factor set by fitHeight(),
   * fitRect(), and setZoom().
   *
   * @param[in]  aWidth  The desired width (in pixels) of the rendered image.
   *
   * @return true if successful, false if the specified width is invalid.
   *
   * @see fitHeight(), fitRect(), getFitWidth(), setZoom(), SignDocDocument::computeZoom()
   */
  bool fitWidth (int aWidth)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_fitWidth (&ex, p, aWidth);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the width set by fitWidth().
   *
   * @param[out]  aWidth  The width will be stored here.
   *
   * @return true if successful, false if fitWidth() has not been called
   *         successfully or has been overridden.
   *
   * @see fitWidth()
   */
  bool getFitWidth (int &aWidth) const
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_getFitWidth (&ex, p, &aWidth);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the height for automatic computation of the zoom factor
   *        to make the rendered image fit the specified height.
   *
   * This function overrides the zoom factor set by fitWidth(),
   * fitRect(), and setZoom().
   *
   * @param[in]  aHeight  The desired height (in pixels) of the rendered image.
   *
   * @return true if successful, false if the specified height is invalid.
   *
   * @see fitRect(), fitWidth(), getFitHeight(), setZoom(), SignDocDocument::computeZoom()
   */
  bool fitHeight (int aHeight)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_fitHeight (&ex, p, aHeight);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the height set by fitHeight().
   *
   * @param[out]  aHeight  The height will be stored here.
   *
   * @return true if successful, false if fitHeight() has not been called
   *         successfully or has been overridden.
   *
   * @see fitHeight()
   */
  bool getFitHeight (int &aHeight) const
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_getFitHeight (&ex, p, &aHeight);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the width and height for automatic computation of the zoom
   *        factor to make the rendered image fit the specified width and
   *        height.
   *
   * This function overrides the zoom factor set by fitWidth(),
   * fitHeight(), and setZoom().
   *
   * @param[in]  aWidth   The desired width (in pixels) of the rendered image.
   * @param[in]  aHeight  The desired height (in pixels) of the rendered image.
   *
   * @return true if successful, false if the specified width or height
   *              is invalid.
   *
   * @see fitHeight(), fitWidth(), getFitRect(), setZoom(), SignDocDocument::computeZoom()
   */
  bool fitRect (int aWidth, int aHeight)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_fitRect (&ex, p, aWidth, aHeight);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the width and height set by fitRect().
   *
   * @param[out]  aWidth   The width will be stored here.
   * @param[out]  aHeight  The height will be stored here.
   *
   * @return true if successful, false if fitRect() has not been called
   *         successfully or has been overridden.
   *
   * @see fitRect()
   */
  bool getFitRect (int &aWidth, int &aHeight) const
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_getFitRect (&ex, p, &aWidth, &aHeight);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the image format.
   *
   * There is no initial value, ie, this function must be called if
   * this object is to be used for SignDocDocument::renderPageAsImage().
   * The image format is ignored for
   * SignDocDocument::renderPageAsSpoocImage() and
   * SignDocDocument::renderPageAsSpoocImages().
   *
   * Currently, this function does not check the image format.
   *
   * @param[in]  aFormat  The desired format of the image ("jpg", "png",
   *                      "tiff", or "bmp").
   *
   * @return true if successful, false if the image format is invalid.
   *
   * @see getFormat(), setInterlacing()
   */
  bool setFormat (const std::string &aFormat)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_setFormat (&ex, p, aFormat.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the image format.
   *
   * @param[out]  aFormat   The image format will be stored here.
   *
   * @return true if successful, false if setFormat() has not been called
   *         successfully.
   *
   * @see setFormat()
   */
  bool getFormat (std::string &aFormat) const
  {
    SIGNDOC_Exception *ex = NULL;
    char *tempFormat = NULL;
    bool r;
    try
      {
        r = (bool)SIGNDOC_RenderParameters_getFormat (&ex, p, &tempFormat);
        if (tempFormat != NULL)
          aFormat = tempFormat;
      }
    catch (...)
      {
        SIGNDOC_free (tempFormat);
        throw;
      }
    SIGNDOC_free (tempFormat);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the interlacing method.
   *
   * Interlacing is used for progressive encoding.
   * The initial value is i_off.
   * The interlacing method is ignored for
   * SignDocDocument::renderPageAsSpoocImage().
   *
   * @param[in]  aInterlacing  The interlacing method.
   *
   * @return true if successful, false if the interlacing mode is invalid.
   *
   * @see getInterlacing(), setFormat()
   */
  bool setInterlacing (Interlacing aInterlacing)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_setInterlacing (&ex, p, aInterlacing);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the interlacing method.
   *
   * @param[out]  aInterlacing   The interlacing mode will be
   *                             stored here.
   *
   * @return true if successful. This function never fails.
   *
   * @see setInterlacing()
   */
  bool getInterlacing (Interlacing &aInterlacing) const
  {
    SIGNDOC_Exception *ex = NULL;
    int tempInterlacing = 0;
    bool r;
    try
      {
        r = (bool)SIGNDOC_RenderParameters_getInterlacing (&ex, p, &tempInterlacing);
        aInterlacing = (Interlacing )tempInterlacing;
      }
    catch (...)
      {
        throw;
      }
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the desired quality.
   *
   * This setting affects scaling of pages of TIFF documents.
   * The initial value is q_low.
   *
   * @param[in]  aQuality  The desired quality.
   *
   * @return true if successful, false if the argument is invalid.
   *
   * @see getQuality()
   */
  bool setQuality (Quality aQuality)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_setQuality (&ex, p, aQuality);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the desired quality.
   *
   * @param[out]  aQuality   The quality setting will be stored here.
   *
   * @return true if successful. This function never fails.
   *
   * @see setQuality()
   */
  bool getQuality (Quality &aQuality) const
  {
    SIGNDOC_Exception *ex = NULL;
    int tempQuality = 0;
    bool r;
    try
      {
        r = (bool)SIGNDOC_RenderParameters_getQuality (&ex, p, &tempQuality);
        aQuality = (Quality )tempQuality;
      }
    catch (...)
      {
        throw;
      }
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the pixel format.
   *
   * The initial value is pf_default.
   *
   * @param[in]  aPixelFormat  The pixel format.
   *
   * @return true if successful, false if the argument is invalid.
   *
   * @see getPixelFormat()
   */
  bool setPixelFormat (PixelFormat aPixelFormat)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_setPixelFormat (&ex, p, aPixelFormat);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the pixel format.
   *
   * @param[out]  aPixelFormat   The pixel format will be stored here.
   *
   * @return true if successful. This function never fails.
   *
   * @see setPixelFormat()
   */
  bool getPixelFormat (PixelFormat &aPixelFormat) const
  {
    SIGNDOC_Exception *ex = NULL;
    int tempPixelFormat = 0;
    bool r;
    try
      {
        r = (bool)SIGNDOC_RenderParameters_getPixelFormat (&ex, p, &tempPixelFormat);
        aPixelFormat = (PixelFormat )tempPixelFormat;
      }
    catch (...)
      {
        throw;
      }
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the compression compression.
   *
   * The initial value is c_default.
   *
   * @param[in]  aCompression  The compression method.
   *
   * @return true if successful, false if the argument is invalid.
   *
   * @see getCompression()
   */
  bool setCompression (Compression aCompression)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_setCompression (&ex, p, aCompression);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the compression method.
   *
   * @param[out]  aCompression   The compression method will be stored here.
   *
   * @return true if successful. This function never fails.
   *
   * @see setCompression()
   */
  bool getCompression (Compression &aCompression) const
  {
    SIGNDOC_Exception *ex = NULL;
    int tempCompression = 0;
    bool r;
    try
      {
        r = (bool)SIGNDOC_RenderParameters_getCompression (&ex, p, &tempCompression);
        aCompression = (Compression )tempCompression;
      }
    catch (...)
      {
        throw;
      }
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the certificate chain verification policy.
   *
   * The certificate chain verification policy is used by
   * SignDocDocument::renderPageAsImage(),
   * SignDocDocument::renderPageAsSpoocImage(), and
   * SignDocDocument::renderPageAsSpoocImages()
   * if setDecorations(true) has been called
   *
   * The default value is ccvp_accept_self_signed_with_rsa_bio.
   * ccvp_require_trusted_root is not implemented for PKCS #1 signatures.
   *
   * @param[in] aPolicy  The certificate chain verification policy.
   *
   * @return true if successful, false if the argument is invalid.
   *
   * @see getCertificateChainVerificationPolicy(), setCertificateRevocationVerificationPolicy(), setVerificationModel(), SignDocDocument::renderPageAsImage(), SignDocDocument::renderPageAsSpoocImage(), SignDocDocument::renderPageAsSpoocImages()
   */
  bool setCertificateChainVerificationPolicy (CertificateChainVerificationPolicy aPolicy)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_setCertificateChainVerificationPolicy (&ex, p, aPolicy);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the certificate chain verification policy.
   *
   * See setCertificateChainVerificationPolicy() for details.
   *
   * @param[out] aPolicy  The certificate chain verification policy will
   *                      be stored here.
   *
   * @return true if successful. This function never fails.
   *
   * @see getCertificateRevocationVerificationPolicy(), getVerificationModel(), setCertificateChainVerificationPolicy(), SignDocDocument::renderPageAsImage(), SignDocDocument::renderPageAsSpoocImage(), SignDocDocument::renderPageAsSpoocImages()
   */
  bool getCertificateChainVerificationPolicy (CertificateChainVerificationPolicy &aPolicy) const
  {
    SIGNDOC_Exception *ex = NULL;
    int tempPolicy = 0;
    bool r;
    try
      {
        r = (bool)SIGNDOC_RenderParameters_getCertificateChainVerificationPolicy (&ex, p, &tempPolicy);
        aPolicy = (CertificateChainVerificationPolicy )tempPolicy;
      }
    catch (...)
      {
        throw;
      }
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the certificate revocation verification policy.
   *
   * The certificate revocation verification policy is used by
   * SignDocDocument::renderPageAsImage(),
   * SignDocDocument::renderPageAsSpoocImage(), and
   * SignDocDocument::renderPageAsSpoocImages()
   * if setDecorations(true) has been called
   *
   * The default value is crvp_dont_check.  crvp_online and crvp_offline
   * are not supported for PKCS #1 signatures.
   *
   * @param[in] aPolicy  The certificate revocation verification policy.
   *
   * @return true if successful, false if the argument is invalid.
   *
   * @see getCertificateRevocationVerificationPolicy(), setCertificateChainVerificationPolicy(), setVerificationModel(), SignDocDocument::renderPageAsImage(), SignDocDocument::renderPageAsSpoocImage(), SignDocDocument::renderPageAsSpoocImages()
   */
  bool setCertificateRevocationVerificationPolicy (CertificateRevocationVerificationPolicy aPolicy)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_setCertificateRevocationVerificationPolicy (&ex, p, aPolicy);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the certificate revocation verification policy.
   *
   * See setCertificateRevocationVerificationPolicy() for details.
   *
   * @param[out] aPolicy  The certificate revocation verification policy will
   *                      be stored here.
   *
   * @return true if successful. This function never fails.
   *
   * @see getCertificateChainVerificationPolicy(), getVerificationModel(), setCertificateRevocationVerificationPolicy(), SignDocDocument::renderPageAsImage(), SignDocDocument::renderPageAsSpoocImage(), SignDocDocument::renderPageAsSpoocImages()
   */
  bool getCertificateRevocationVerificationPolicy (CertificateRevocationVerificationPolicy &aPolicy) const
  {
    SIGNDOC_Exception *ex = NULL;
    int tempPolicy = 0;
    bool r;
    try
      {
        r = (bool)SIGNDOC_RenderParameters_getCertificateRevocationVerificationPolicy (&ex, p, &tempPolicy);
        aPolicy = (CertificateRevocationVerificationPolicy )tempPolicy;
      }
    catch (...)
      {
        throw;
      }
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the certificate verification model.
   *
   * The certificate verification model is used by
   * SignDocDocument::renderPageAsImage(),
   * SignDocDocument::renderPageAsSpoocImage(), and
   * SignDocDocument::renderPageAsSpoocImages()
   * if setDecorations(true) has been called
   *
   * The default value is vm_default.
   *
   * @param[in] aModel  The certificate verification model.
   *
   * @return true if successful, false if the argument is invalid.
   *
   * @see getVerificationModel(), setCertificateChainVerificationPolicy(), setCertificateRevocationVerificationPolicy(), SignDocDocument::renderPageAsImage(), SignDocDocument::renderPageAsSpoocImage(), SignDocDocument::renderPageAsSpoocImages()
   */
  bool setVerificationModel (VerificationModel aModel)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_setVerificationModel (&ex, p, aModel);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the certificate verification model.
   *
   * See setVerificationModel() for details.
   *
   * @param[out] aModel  The certificate verification model will be stored
   *                     here.
   *
   * @return true if successful. This function never fails.
   *
   * @see getCertificateChainVerificationPolicy(), getCertificateRevocationVerificationPolicy(), setVerificationModel(), SignDocDocument::renderPageAsImage(), SignDocDocument::renderPageAsSpoocImage(), SignDocDocument::renderPageAsSpoocImages()
   */
  bool getVerificationModel (VerificationModel &aModel) const
  {
    SIGNDOC_Exception *ex = NULL;
    int tempModel = 0;
    bool r;
    try
      {
        r = (bool)SIGNDOC_RenderParameters_getVerificationModel (&ex, p, &tempModel);
        aModel = (VerificationModel )tempModel;
      }
    catch (...)
      {
        throw;
      }
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Enable rendering of decorations.
   *
   * The default value is false.
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
   * @param[in]  aDecorations  true to render decorations.
   *
   * @return true if successful. This function never fails.
   *
   * @see getDecorations(), setPrint()
   */
  bool setDecorations (bool aDecorations)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_setDecorations (&ex, p, aDecorations);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the value set by setDecorations().
   *
   * @param[out]  aDecorations  The flag will be stored here.
   *
   * @return true if successful. This function never fails.
   *
   * @see getPrint(), setDecorations()
   */
  bool getDecorations (bool &aDecorations) const
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Boolean tempDecorations = 0;
    bool r;
    try
      {
        r = (bool)SIGNDOC_RenderParameters_getDecorations (&ex, p, &tempDecorations);
        aDecorations = (bool )tempDecorations;
      }
    catch (...)
      {
        throw;
      }
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Enable rendering for printing.
   *
   * The default value is false (render for displaying).
   *
   * @param[in]  aPrint   true to render for printing, false to render
   *                      for displaying.
   *
   * @return true if successful. This function never fails.
   *
   * @see getPrint(), setDecorations()
   */
  bool setPrint (bool aPrint)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_RenderParameters_setPrint (&ex, p, aPrint);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the value set by setPrint().
   *
   * @param[out]  aPrint  The flag will be stored here.
   *
   * @return true if successful. This function never fails.
   *
   * @see getDecorations(), setPrint()
   */
  bool getPrint (bool &aPrint) const
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Boolean tempPrint = 0;
    bool r;
    try
      {
        r = (bool)SIGNDOC_RenderParameters_getPrint (&ex, p, &tempPrint);
        aPrint = (bool )tempPrint;
      }
    catch (...)
      {
        throw;
      }
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Compare against another SignDocRenderParameters object.
   *
   * The exact order of SignDocRenderParameters objects is unspecified but
   * consistent.
   *
   * @param[in] aOther  The object to compare against.
   *
   * @return -1 if this object compares smaller than @a aOther, 0 if this
   *         object compares equal to @a aOther, 1 if this object compares
   *         greater than @a aOther.
   */
  int compare (const SignDocRenderParameters &aOther) const
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_RenderParameters_compare (&ex, p, aOther.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

private:
public:
  /**
   * @brief Internal function.
   * @internal
   */
  SignDocRenderParameters (SIGNDOC_RenderParameters *aP) : p (aP) { }

  /**
   * @brief Internal function.
   * @internal
   */
  SIGNDOC_RenderParameters *getImpl () { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  const SIGNDOC_RenderParameters *getImpl () const { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  void setImpl (SIGNDOC_RenderParameters *aP) { SIGNDOC_RenderParameters_delete (p); p  = aP; }

private:
  SIGNDOC_RenderParameters *p;
};

/**
 * @brief Output of SignDocDocument::renderPageAsImage(),
 *        SignDocDocument::renderPageAsSpoocImage(), and
 *        SignDocDocument::renderPageAsSpoocImages().
 *
 * If multiple pages are selected (see #SignDocRenderParameters::setPages()),
 * the maximum width and maximum height of all selected pages will be used.
 */
class SignDocRenderOutput 
{
public:
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
 * @brief Output of SignDocDocument::getAttachment().
 */
class SignDocAttachment 
{
public:

public:
  /**
   * @brief Constructor.
   */
  SignDocAttachment ()
    : p (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_Attachment_new (&ex);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Copy constructor.
   *
   * @param[in] aSource  The object to be copied.
   */
  SignDocAttachment (const SignDocAttachment &aSource)
    : p (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_Attachment_clone (&ex, aSource.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Destructor.
   */
  ~SignDocAttachment ()
  {
    SIGNDOC_Attachment_delete (p);
  }

  /**
   * @brief Assignment operator.
   *
   * @param[in] aSource  The source object.
   */
  SignDocAttachment &operator= (const SignDocAttachment &aSource)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Attachment_assign (&ex, p, aSource.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return *this;
  }

  /**
   * @brief Efficiently swap this object with another one.
   *
   * @param[in] aOther  The other object.
   */
  void swap (SignDocAttachment &aOther)
  {
    std::swap (p, aOther.p);
  }

  /**
   * @brief Get the name of the attachment.
   *
   * This function throws de::softpro::spooc::EncodingError if
   * the name cannot be represented using the specified encoding.
   *
   * @param[in] aEncoding  The encoding to be used for the return value.
   *
   * @return The name of the attachment.
   *
   * @see getNameUTF8()
   */
  std::string getName (Encoding aEncoding) const
  {
    SIGNDOC_Exception *ex = NULL;
    std::string r;
    char *s = SIGNDOC_Attachment_getName (&ex, p, aEncoding);
    if (ex != NULL) SignDoc_throw (ex);
    try
      {
        r = s;
      }
    catch (...)
      {
        SIGNDOC_free (s);
        throw;
      }
    SIGNDOC_free (s);
    return r;
  }

  /**
   * @brief Get the name of the attachment as UTF-8-encoded C string.
   *
   * @return The name of the attachment.  This pointer will become invalid
   *         when this object is destroyed.
   *
   * @see getName()
   */
  const char *getNameUTF8 () const
  {
    SIGNDOC_Exception *ex = NULL;
    const char *r;
    r = SIGNDOC_Attachment_getNameUTF8 (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the file name of the attachment.
   *
   * This function throws de::softpro::spooc::EncodingError if
   * the file name cannot be represented using the specified encoding.
   *
   * @param[in] aEncoding  The encoding to be used for the return value.
   *
   * @return The file name of the attachment.
   *
   * @see getFileNameUTF8()
   */
  std::string getFileName (Encoding aEncoding) const
  {
    SIGNDOC_Exception *ex = NULL;
    std::string r;
    char *s = SIGNDOC_Attachment_getFileName (&ex, p, aEncoding);
    if (ex != NULL) SignDoc_throw (ex);
    try
      {
        r = s;
      }
    catch (...)
      {
        SIGNDOC_free (s);
        throw;
      }
    SIGNDOC_free (s);
    return r;
  }

  /**
   * @brief Get the file name of the attachment as UTF-8-encoded C string.
   *
   * @return The file name of the attachment.  This pointer will become invalid
   *         when this object is destroyed.
   *
   * @see getFileName()
   */
  const char *getFileNameUTF8 () const
  {
    SIGNDOC_Exception *ex = NULL;
    const char *r;
    r = SIGNDOC_Attachment_getFileNameUTF8 (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the description of the attachment.
   *
   * The returned string will be empty if the description is missing.
   *
   * This function throws de::softpro::spooc::EncodingError if
   * the description cannot be represented using the specified encoding.
   *
   * @param[in] aEncoding  The encoding to be used for the return value.
   *
   * @return The description of the attachment.
   *
   * @see getDescriptionUTF8()
   */
  std::string getDescription (Encoding aEncoding) const
  {
    SIGNDOC_Exception *ex = NULL;
    std::string r;
    char *s = SIGNDOC_Attachment_getDescription (&ex, p, aEncoding);
    if (ex != NULL) SignDoc_throw (ex);
    try
      {
        r = s;
      }
    catch (...)
      {
        SIGNDOC_free (s);
        throw;
      }
    SIGNDOC_free (s);
    return r;
  }

  /**
   * @brief Get the description of the attachment as UTF-8-encoded C string.
   *
   * The returned string will be empty if the description is missing.
   *
   * @return The description of the attachment.  This pointer will become invalid
   *         when this object is destroyed.
   *
   * @see getDescription()
   */
  const char *getDescriptionUTF8 () const
  {
    SIGNDOC_Exception *ex = NULL;
    const char *r;
    r = SIGNDOC_Attachment_getDescriptionUTF8 (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the size (in octets) of the attachment.
   *
   * The return value is -1 if the size of the attachment is not readily
   * available.
   *
   * @return The size (in octets) of the attachment or -1.
   *
   * @see getCompressedSize()
   */
  int getSize () const
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_Attachment_getSize (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the compressed size (in octets) of the attachment.
   *
   * @return The compressed size (in octets) of the attachment.
   *
   * @see getSize()
   */
  int getCompressedSize () const
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_Attachment_getCompressedSize (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the MIME type of the attachment.
   *
   * The return string will be empty if the MIME type is missing.
   *
   * @return The MIME type of the attachment.  This pointer will become invalid
   *         when this object is destroyed.
   */
  const char *getType () const
  {
    SIGNDOC_Exception *ex = NULL;
    const char *r;
    r = SIGNDOC_Attachment_getType (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   * @return The creation time and date of the attachment.
   *         This pointer will become invalid when this object is destroyed.
   *
   * @see getModificationTime()
   */
  const char *getCreationTime () const
  {
    SIGNDOC_Exception *ex = NULL;
    const char *r;
    r = SIGNDOC_Attachment_getCreationTime (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   * @return The time and date of the last modification of the attachment.
   *         This pointer will become invalid when this object is destroyed.
   */
  const char *getModificationTime () const
  {
    SIGNDOC_Exception *ex = NULL;
    const char *r;
    r = SIGNDOC_Attachment_getModificationTime (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

private:
public:
  /**
   * @brief Internal function.
   * @internal
   */
  SignDocAttachment (SIGNDOC_Attachment *aP) : p (aP) { }

  /**
   * @brief Internal function.
   * @internal
   */
  SIGNDOC_Attachment *getImpl () { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  const SIGNDOC_Attachment *getImpl () const { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  void setImpl (SIGNDOC_Attachment *aP) { SIGNDOC_Attachment_delete (p); p  = aP; }

private:
  SIGNDOC_Attachment *p;
};

/**
 * @brief Parameters for a watermark.
 *
 * @see SignDocDocument::addWatermark()
 *
 * @todo fromFile(): PDF/image, page number, absolute scale
 * @todo setUnderline()
 */
class SignDocWatermark 
{
public:

  /**
   * @brief Justification of  multi-line text.
   */
  enum Justification
  {
    j_left, j_center, j_right
  };

  /**
   * @brief Location of watermark.
   */
  enum Location
  {
    l_overlay,                  ///< Watermark appears on top of page
    l_underlay                  ///< Watermark appears behind page
  };

  /**
   * @brief Horizontal alignment.
   */
  enum HAlignment
  {
    ha_left, ha_center, ha_right
  };

  /**
   * @brief Vertical alignment.
   */
  enum VAlignment
  {
    va_top, va_center, va_bottom
  };

public:
  /**
   * @brief Constructor.
   *
   * All parameters are set to their default values.
   */
  SignDocWatermark ()
    : p (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_Watermark_new (&ex);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Copy constructor.
   *
   * @param[in] aSource  The object to be copied.
   */
  SignDocWatermark (const SignDocWatermark &aSource)
    : p (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_Watermark_clone (&ex, aSource.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Destructor.
   */
  ~SignDocWatermark ()
  {
    SIGNDOC_Watermark_delete (p);
  }

  /**
   * @brief Assignment operator.
   *
   * @param[in] aSource  The source object.
   */
  SignDocWatermark &operator= (const SignDocWatermark &aSource)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Watermark_assign (&ex, p, aSource.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return *this;
  }

  /**
   * @brief Efficiently swap this object with another one.
   *
   * @param[in] aOther  The other object.
   */
  void swap (SignDocWatermark &aOther)
  {
    std::swap (p, aOther.p);
  }

  /**
   * @brief Reset all parameters to their default values.
   */
  void clear ()
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Watermark_clear (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Set the text to be used for the watermark.
   *
   * The default value is empty.
   *
   * The text can contain multiple lines, the newline character is
   * used to separate lines.  If there are multiple lines, their
   * relative position is specified by setJustification().
   *
   * @param[in] aEncoding   The encoding of @a aText.
   * @param[in] aText       The text. Complex scripts are supported,
   *                        see @ref signdocshared_complex_scripts.
   *
   * @see setFontName(), setFontSize(), setJustification(), setTextColor()
   */
  void setText (Encoding aEncoding, const std::string &aText)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Watermark_setText (&ex, p, aEncoding, aText.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Set the name of the font.
   *
   * The font name can be the name of a standard font, the name of an
   * already embedded font, or the name of a font defined by a font
   * configuration file.
   *
   * The default value is "Helvetica".
   *
   * @param[in] aEncoding  The encoding of @a aFontName.
   * @param[in] aFontName  The new font name.
   *
   * @see setFontSize(), setTextColor(), SignDocDocumentLoader::loadFontConfigFile(), SignDocDocumentLoader::loadFontConfigEnvironment(), SignDocDocumentLoader::loadFontConfigStream()
   */
  void setFontName (Encoding aEncoding, const std::string &aFontName)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Watermark_setFontName (&ex, p, aEncoding, aFontName.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Set the font size.
   *
   * The default value is 24.
   *
   * @param[in] aFontSize  The font size (in user space units).
   *
   * @see setFontName(), setScale()
   */
  void setFontSize (double aFontSize)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Watermark_setFontSize (&ex, p, aFontSize);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Set the text color.
   *
   * The default value is black (gray scale).
   *
   * @param[in] aTextColor  The text color.
   */
  void setTextColor (const SignDocColor &aTextColor)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Watermark_setTextColor (&ex, p, aTextColor.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Set the justification for multi-line text.
   *
   * The default value is j_left.
   *
   * If the text (see setText()) contains only one line (ie, no
   * newline characters), this parameter will be ignored.
   *
   * @param[in] aJustification  The justification.
   *
   * @see setText()
   */
  void setJustification (Justification aJustification)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Watermark_setJustification (&ex, p, aJustification);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Set the rotation.
   *
   * The default value is 0.
   *
   * @param[in] aRotation  The rotation in degrees (-180 through 180),
   *                       0 is horizontal (left to right),
   *                       45 is bottom left to upper right.
   */
  void setRotation (double aRotation)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Watermark_setRotation (&ex, p, aRotation);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Set the opacity.
   *
   * The default value is 1.0. Documents conforming to PDF/A must
   * use an opacity of 1.0.
   *
   * @param[in] aOpacity  The opacity, 0.0 (transparent) through 1.0 (opaque).
   *
   * @see setLocation()
   */
  void setOpacity (double aOpacity)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Watermark_setOpacity (&ex, p, aOpacity);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Disable scaling or set scaling relative to page.
   *
   * The default value is 0.5.
   *
   * @param[in] aScale  0 to disable scaling (use the font size set by
   *                    setFontSize()) or 0.01 through 64.0 to scale
   *                    relative to the page size.
   */
  void setScale (double aScale)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Watermark_setScale (&ex, p, aScale);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Set whether the watermark will appear behind the page or
   *        on top of the page.
   *
   * The default value is l_overlay.
   *
   * @param[in] aLocation   l_overlay or l_underlay.
   *
   * @see setOpacity()
   */
  void setLocation (Location aLocation)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Watermark_setLocation (&ex, p, aLocation);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Set the horizontal position of the watermark.
   *
   * The default values are ha_center and 0.
   *
   * The distance is measured from the left edge of the page to the
   * left edge of the watermark (ha_left), from the center of the page
   * to the center of the watermark (ha_center), or from the right
   * edge of the page to the right edge of the watermark (ha_right).
   *
   * For ha_left and ha_center, positive values push the watermark to
   * the right, for ha_right, positive values push the watermark to
   * the left.

   * @param[in] aAlignment  Measure distance from here.
   * @param[in] aDistance   The distance in user space units.
   *
   * @see setScale(), setVerticalPosition()
   */
  void setHorizontalPosition (HAlignment aAlignment, double aDistance)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Watermark_setHorizontalPosition (&ex, p, aAlignment, aDistance);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Set the vertical position of the watermark.
   *
   * The default values are va_center and 0.
   *
   * The distance is measured from the top edge of the page to the
   * top edge of the watermark (va_top), from the center of the page
   * to the center of the watermark (va_center), or from the bottom
   * edge of the page to the bottom edge of the watermark (va_bottom).
   *
   * For va_bottom and va_center, positive values push the watermark
   * up, for va_top, positive values push the watermark down.
   *
   * @param[in] aAlignment  Measure distance from here.
   * @param[in] aDistance   The distance in user space units.
   *
   * @see setHorizontalPosition(), setScale()
   */
  void setVerticalPosition (VAlignment aAlignment, double aDistance)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Watermark_setVerticalPosition (&ex, p, aAlignment, aDistance);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Set the first page number.
   *
   * The default value is 1.
   *
   * @param[in] aPage  The 1-based page number of the first page.
   *
   * @see setLastPage(), setPageIncrement()
   */
  void setFirstPage (int aPage)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Watermark_setFirstPage (&ex, p, aPage);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Set the last page number.
   *
   * The default value is 0.
   *
   * @param[in] aPage  The 1-based page number of the last page or
   *                   0 for the last page of the document.
   *
   * @see setFirstPage(), setPageIncrement()
   */
  void setLastPage (int aPage)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Watermark_setLastPage (&ex, p, aPage);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Set the page number increment.
   *
   * The default value is 1 (add watermark to all pages between
   * the first page and the last page)
   *
   * @param[in] aIncr  Add this number to the page number when iterating
   *                   over pages adding watermarks.  Must be positive.
   *
   * @see setFirstPage(), setLastPage()
   */
  void setPageIncrement (int aIncr)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Watermark_setPageIncrement (&ex, p, aIncr);
    if (ex != NULL) SignDoc_throw (ex);
  }

private:
public:
  /**
   * @brief Internal function.
   * @internal
   */
  SignDocWatermark (SIGNDOC_Watermark *aP) : p (aP) { }

  /**
   * @brief Internal function.
   * @internal
   */
  SIGNDOC_Watermark *getImpl () { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  const SIGNDOC_Watermark *getImpl () const { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  void setImpl (SIGNDOC_Watermark *aP) { SIGNDOC_Watermark_delete (p); p  = aP; }

private:
  SIGNDOC_Watermark *p;
};

class SignDocVerificationResult;

/**
 * @brief An interface for SignDoc documents.
 *
 * An object of this class represents one document.
 *
 * Use SignDocDocumentLoader::loadFromMemory(),
 * SignDocDocumentLoader::loadFromFile(), or
 * SignDocDocumentLoader::createPDF() to create objects.
 *
 * If the document is loaded from a file, the file may remain in
 * use until this object is destroyed or the document is saved
 * to a different file with saveToFile(). Please do not change the
 * file while there is a SignDocDocument object for it.
 *
 * @todo add fixFields()
 */
class SignDocDocument 
{
public:
  /**
   * @brief Supported document types.
   */
  enum DocumentType
  {
    dt_unknown,                 ///< For SignDocDocumentLoader::ping().
    dt_pdf,                     ///< PDF document.
    dt_tiff,                    ///< TIFF document.
    dt_other,                   ///< Other document.
    dt_fdf                      ///< FDF document.
  };

  /**
   * @brief Flags modifying the behavior of saveToFile() and saveToStream().
   */
  enum SaveFlags
  {
    /**
     * @brief Save incrementally (PDF).
     */
    sf_incremental   = 0x01,

    /**
     * @brief Remove unused objects (PDF).
     *
     * This flag is ignored, unused objects are always removed.
     */
    sf_remove_unused = 0x02,

    /**
     * @brief Linearize the document (PDF).
     *
     * This flag cannot be used with sf_incremental.
     *
     * @note This flag is currently ignored, it will be supported again
     *       in a future version of SignDoc SDK.
     *
     * @todo implement sf_linearized
     */
    sf_linearized    = 0x04,

    /**
     * @brief Do not use features introduced after PDF 1.4 for saving the document.
     *
     * This flag is assumed to be set for PDF 1.4 (and older) documents (PDF).
     */
    sf_pdf_1_4       = 0x08,

    /**
     * @brief Fix appearance streams of check boxes and radio buttons
     *        for PDF/A documents.
     *
     * The appearance streams of a check box or radio button field
     * added by addField() or modified by setField() or applyFdf() are
     * not PDF/A-1-compliant.
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
     * @see SignDocSignatureParameters::pb_auto, SignDocSignatureParameters::pb_freeze
     */
    sf_pdfa_buttons  = 0x10
  };

  /**
   * @brief Flags modifying the behavior of copyToStream().
   */
  enum CopyToStreamFlags
  {
    /**
     * @brief Include unsaved changes.
     *
     * See copyToStream() for details.
     */
    ctsf_unsaved = 0x01
  };

  /**
   * @brief Flags modifying the behavior of setField(), addField(),
   *        and applyFdf().
   *
   * Exactly one of sff_font_fail, sff_font_warn, and sff_font_ignore
   * must be specified.
   */
  enum SetFieldFlags
  {
    /**
     * @brief Fail if no suitable font is found.
     *
     * setField(), addField(), and applyFdf() won't modify/add the
     * field and will report error rc_font_not_found if no font
     * covering all required characters is found.
     */
    sff_font_fail    = 0x01,

    /**
     * @brief Warn if no suitable font is found.
     *
     * setField(), addField(), and applyFdf() will modify/add the
     * field even if no font covering all required characters is
     * found, but they will report error rc_font_not_found. The
     * appearance of the field won't represent the contents in that
     * case.
     */
    sff_font_warn    = 0x02,

    /**
     * @brief Ignore font problems.
     *
     * setField(), addField(), and applyFdf() will modify/add the
     * field even if no font covering all required characters is
     * found, and they won't report the problem to the caller. The
     * appearance of the field won't represent the contents in that
     * case.
     */
    sff_font_ignore  = 0x04,

    /**
     * @brief Move or resize field.
     *
     * setField() does not update the coordinates of the field unless
     * this flag is set as moving a field may require recomputing the
     * appearance which can have unexpected results (mostly due to
     * shortcomings of SignDoc SDK). If this flag is not set,
     * setField() ignores the coordinates set with
     * SignDocField::setLeft(), SignDocField::setBottom(),
     * SignDocField::setRight(), and SignDocField::setTop().
     * 
     * addField() ignores this flag, it always uses the coordinates.
     * applyFdf() ignores this flag, it never moves or resizes fields.
     */
    sff_move = 0x08,

    /**
     * @brief Keep appearance streams.
     *
     * If this flag is set, setField() and applyFdf() won't touch the
     * existing (or non-existing) appearance streams, addField() won't
     * add any appearance streams.
     *
     * Recomputing the appearance can have unexpected results
     * (mostly due to shortcomings of SignDoc SDK), therefore
     * you might want to set this flag if you make changes
     * that shall not affect the appearance such as setting
     * the SignDocField::f_ReadOnly flag.
     *
     * At most one of sff_keep_ap and #sff_update_ap can be set.
     *
     * @see sff_update_ap
     */
    sff_keep_ap = 0x10,

    /**
     * @brief Update appearance streams.
     *
     * If this flag is set, setField() and applyFdf() will always
     * recompute the appearance streams of the field. (addField()
     * always computes the appearance stream unless sff_keep_ap is
     * set).
     *
     * You might want to use this flag after changing the document's
     * default text field attributes.
     *
     * At most one of #sff_keep_ap and sff_update_ap can be set.
     *
     * If neither #sff_keep_ap and sff_update_ap is set, setField()
     * and applyFdf() try to update the appearance streams only if
     * necessary; the exact behavior depends on the version of SignDoc
     * SDK.
     *
     * @see sff_keep_ap, setTextFieldAttributes()
     */
    sff_update_ap = 0x20,

    /**
     * @brief Compute the default font size such that the field
     *        contents fit the height of the field.
     *
     * If the font size for a text field, list box field, or combo box
     * field is zero (see SignDocTextFieldAttributes::setFontSize()),
     * the default font size will be used. This flag controls how the
     * default font size is used.
     *
     * If this flag is set, the font size will be computed such that
     * the field contents fit the height of the field. This is the
     * behavior required by the PDF specification. If the field
     * contents are too long, they will be truncated.
     *
     * If this flag is not set, the font size will be computed such
     * that the field contents fit both the height and the width of
     * the field. This is the behavior implemented in, for instance,
     * Adobe Acrobat.
     */
    sff_fit_height_only = 0x40
  };

  /**
   * @brief Flags modifying the behavior of flattenFields().
   */
  enum FlattenFieldsFlags
  {
    /**
     * @brief Include unsigned signature fields.
     */
    fff_include_signature_unsigned      = 0x01,

    /**
     * @brief Include signed signature fields.
     */
    fff_include_signature_signed        = 0x02,

    /**
     * @brief Include hidden and invisible widgets.
     */
    fff_include_hidden                  = 0x04,

    /**
     * @brief Do not modify logical structure.
     *
     * Set this flag only if you don't care about the logical
     * structure of the document and fear problems due to errors in
     * the logical structure. For instance, you might want to use this
     * flag if flattening fields just for printing with a PDF
     * component that does not support annotations and then throw away
     * the document with the flattened fields.
     */
    fff_keep_structure                  = 0x08
  };

  /**
   * @brief Flags modifying the behavior of findText().
   */
  enum FindTextFlags
  {
    ftf_ignore_hspace      = 0x0001,  ///< Ignore horizontal whitespace (may be required)
    ftf_ignore_hyphenation = 0x0002,  ///< Ignore hyphenation (not yet implemented)
    ftf_ignore_sequence    = 0x0004   ///< Use character positions instead of sequence (can be expensive, not yet implemented)
  };

  /**
   * @brief Flags modifying the behavior of exportFields() and exportProperties().
   */
  enum ExportFlags
  {
    e_top = 0x01  ///< Include XML declaration and schema for top-level element
  };

  /**
   * @brief Flags modifying the behavior of importProperties().
   */
  enum ImportFlags
  {
    i_atomic = 0x01  ///< Modify all properties from XML or none (on error)
  };

  /**
   * @brief Flags modifying the behavior of addImageFromBlob(),
   *        addImageFromFile(), importPageFromImageBlob(), and
   *        importPageFromImageFile().
   */
  enum ImportImageFlags
  {
    /**
     * @brief Keep aspect ratio of image, center image on white background.
     */
    ii_keep_aspect_ratio = 0x01,

    /**
     * @brief Make the brightest color transparent.
     *
     * This flag may be specified for addImageFromBlob() and addImageFromFile()
     * only. importPageFromImageBlob() and importPageFromImageFile() always
     * make the image opaque.
     *
     * The rest of this description applies to addImageFromBlob() and
     * addImageFromFile() only.
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
    ii_brightest_transparent = 0x02
  };

  /**
   * @brief Tell removePages() to keep or to remove the specified pages.
   */
  enum KeepOrRemove
  {
    kor_keep,                   ///< Keep the specified pages, remove all other pages
    kor_remove                  ///< Remove the specified pages, keep all other pages
  };

  /**
   * @brief Return codes.
   *
   * Do not forget to update de/softpro/doc/SignDocException.java!
   */
  enum ReturnCode
  {
    rc_ok,                    ///< No error
    rc_invalid_argument,      ///< Invalid argument
    rc_field_not_found,       ///< Field not found (or not a signature field)
    rc_invalid_profile,       ///< Profile unknown or not applicable
    rc_invalid_image,         ///< Invalid image (e.g., unsupported format)
    rc_type_mismatch,         ///< Field type or property type mismatch
    rc_font_not_found,        ///< The requested font could not be found or does not contain all required characters, see also setShootInFoot()
    rc_no_datablock,          ///< No datablock found (obsolete)
    rc_not_supported,         ///< Operation not supported
    rc_io_error,              ///< I/O error
    rc_not_verified,          ///< (used by SignDocVerificationResult)
    rc_property_not_found,    ///< Property not found
    rc_page_not_found,        ///< Page not found (invalid page number)
    rc_wrong_collection,      ///< Property accessed via wrong collection
    rc_field_exists,          ///< Field already exists
    rc_license_error,         ///< License initialization failed or license check failed
    rc_unexpected_error,      ///< Unexpected error
    rc_cancelled,             ///< Certificate dialog cancelled by user
    rc_no_biometric_data,     ///< (used by SignDocVerificationResult)
    rc_parameter_not_set,     ///< (Java only)
    rc_field_not_signed,      ///< Field not signed, for copyAsSignedToStream()
    rc_invalid_signature,     ///< Signature is not valid, for copyAsSignedToStream()
    rc_annotation_not_found,  ///< Annotation not found, for getAnnotation()
    rc_attachment_not_found,  ///< Attachment not found
    rc_attachment_exists,     ///< Attachment already exists
    rc_no_certificate,        ///< No (matching) certificate found and csf_create_self_signed is not specified
    rc_ambiguous_certificate, ///< More than one matching certificate found and csf_never_ask is specified
    rc_not_allowed            ///< Operation not allowed due to document being signed or conforming to PDF/A, see setShootInFoot() and removePDFA()
  };

  /**
   * @brief Result of checkAttachment().
   */
  enum CheckAttachmentResult
  {
    car_match,                  ///< The attachment matches its checksum
    car_no_checksum,            ///< The attachment does not have a checksum
    car_mismatch                ///< The attachment does not match its checksum
  };

  /**
   * @brief Horizontal alignment for addTextRect().
   */
  enum HAlignment
  {
    ha_left, ha_center, ha_right
  };

  /**
   * @brief Vertical alignment for addTextRect().
   */
  enum VAlignment
  {
    va_top, va_center, va_bottom
  };

  /**
   * @brief Flags for setShootInFoot().
   */
  enum ShootInFootFlags
  {
    /**
     * @brief Allow operations to break existing signatures in
     *        signature fields.
     *
     * This flag is available for PDF documents only.
     */
    siff_allow_breaking_signatures  = 0x01,

    /**
     * @brief Allow operations to break signatures which grant permissions.
     *
     * This flag is available for PDF documents only.
     */
    siff_allow_breaking_permissions = 0x02,

    /**
     * @brief Allow signing with a certificate that is not yet valid
     *        or no longer valid or which is not qualified for
     *        digital signatures.
     */
    siff_allow_invalid_certificate  = 0x04,

    /**
     * @brief Allow non-standard usage of external (non-embedded)
     *        TrueType fonts.
     *
     * If this flag is not set, TrueType fonts must be embedded; when
     * trying to use a TrueType font that is not embededded, error
     * rc_font_not_found will be reported.
     *
     * If this flag is set, external TrueType fonts are allowed.
     * However, the document will violate Table 117, section 9.7.4.2
     * and section 9.7.5.2 of ISO 32000-1:2008.
     */
    siff_allow_non_standard_external_fonts = 0x08,

    /**
     * @brief Assume that appearance dictionaries and appearance streams
     *        are not shared.
     *
     * If this flag is set and that assumption doesn't hold, changing one
     * field may change the appearances of other fields.
     *
     * At most one of siff_assume_ap_not_shared and
     * #siff_assume_ap_shared can be set. If neither flag is set,
     * setField() and addSignature() look for shared objects. This can
     * be expensive in terms of time and memory.
     */
    siff_assume_ap_not_shared = 0x10,

    /**
     * @brief Always assume that appearance dictionaries and appearance
     *        streams are shared.
     *
     * Setting this flag partially simulates the behavior of SignDoc
     * SDK 3.x and older and causes a minor violation of section
     * 12.7.3.3 of ISO 32000-1:2008 by setField().
     *
     * At most one of #siff_assume_ap_not_shared and
     * siff_assume_ap_shared can be set. If neither flag is set,
     * setField() and addSignature() look for shared objects. This can
     * be expensive in terms of time and memory.
     */
    siff_assume_ap_shared = 0x20
  };

  /**
   * @brief Constructor.
   *
   * Use SignDocDocumentLoader::loadFromMemory(),
   * SignDocDocumentLoader::loadFromFile(), or
   * SignDocDocumentLoader::createPDF() to create objects.
   */
  SignDocDocument ()
    : p (NULL)
  {
  }

  /**
   * @brief Destructor.
   *
   * @see getSPPDFDocument()
   */
  ~SignDocDocument ()
  {
    SIGNDOC_Document_delete (p);
  }

  /**
   * @brief Get the type of the document.
   *
   * @return The document type.
   */
  DocumentType getType () const
  {
    SIGNDOC_Exception *ex = NULL;
    DocumentType r;
    r = (DocumentType)SIGNDOC_Document_getType (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the number of pages.
   *
   * @return The number of pages.
   */
  int getPageCount () const
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_Document_getPageCount (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Create a SignDocSignatureParameters object for signing a
   *        signature field.
   *
   * The caller is responsible for destroying the object.
   *
   * Any SignDocSignatureParameters object should be used for at most
   * one signature.
   *
   * @param[in] aEncoding    The encoding of @a aFieldName.
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
   * @return rc_ok if successful.
   *
   * @see addSignature(), getProfiles()
   */
  ReturnCode createSignatureParameters (Encoding aEncoding,
                                        const std::string &aFieldName,
                                        const std::string &aProfile,
                                        SIGNDOC_PTR<SignDocSignatureParameters> &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_SignatureParameters *tempOutput = NULL;
    aOutput.reset ((SignDocSignatureParameters*)NULL);
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_Document_createSignatureParameters (&ex, p, aEncoding, aFieldName.c_str (), aProfile.c_str (), &tempOutput);
        if (tempOutput != NULL)
          {
            aOutput.reset (new SignDocSignatureParameters (tempOutput));
            tempOutput = NULL;
          }
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_SignatureParameters_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_SignatureParameters_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Create a SignDocSignatureParameters object for signing a
   *        signature field.
   *
   * The caller is responsible for destroying the object.
   *
   * Any SignDocSignatureParameters object should be used for at most
   * one signature.
   *
   * @param[in] aFieldName   The name of the signature field.
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
   * @return rc_ok if successful.
   *
   * @see addSignature(), getProfiles()
   */
  ReturnCode createSignatureParameters (const wchar_t *aFieldName,
                                        const wchar_t *aProfile,
                                        SIGNDOC_PTR<SignDocSignatureParameters> &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_SignatureParameters *tempOutput = NULL;
    aOutput.reset ((SignDocSignatureParameters*)NULL);
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_Document_createSignatureParametersW (&ex, p, aFieldName, aProfile, &tempOutput);
        if (tempOutput != NULL)
          {
            aOutput.reset (new SignDocSignatureParameters (tempOutput));
            tempOutput = NULL;
          }
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_SignatureParameters_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_SignatureParameters_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get a list of profiles for a signature field.
   *
   * @param[in]  aEncoding    The encoding of @a aFieldName.
   * @param[in]  aFieldName   The name of the signature field encoded according
   *                          to @a aEncoding.
   * @param[out] aOutput      The names (ASCII) of all profiles supported by
   *                          the signature field will be stored here,
   *                          excluding the default profile "" which is
   *                          always available.
   *
   * @return rc_ok if successful.
   *
   * @see createSignatureParameters()
   */
  ReturnCode getProfiles (Encoding aEncoding, const std::string &aFieldName,
                          std::vector<std::string> &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_StringArray *tempOutput = NULL;
    ReturnCode r;
    try
      {
        tempOutput = SIGNDOC_StringArray_new (&ex);
        if (ex != NULL) SignDoc_throw (ex);
        r = (ReturnCode)SIGNDOC_Document_getProfiles (&ex, p, aEncoding, aFieldName.c_str (), tempOutput);
        assignArray (aOutput, tempOutput);
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_StringArray_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_StringArray_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   * If a PDF document is backed by memory (most recently loaded
   * from memory or saved to a stream) and "OutputPath" is empty,
   * the signed document will not be saved. Use
   * @code
   * doc.copyToStream (stream, 0);
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
   * @param[in] aParameters    The signing parameters.
   *
   * @return rc_ok if successful.
   *
   * @see copyToStream(), createSignatureParameters(), getPathname(), setStringProperty()
   */
  ReturnCode addSignature (const SignDocSignatureParameters *aParameters)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_addSignature (&ex, p, aParameters->getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the timestamp used by the last successful call of
   *        addSignature().
   *
   * This function may return a timestamp even if the last call of
   * addSignature() was not successful. See also string parameters
   * "Timestamp" and "TimeStampServerURL" of SignDocSignatureParameters.
   *
   * @param[out] aTime  The timestamp in ISO 8601 format (yyyy-mm-ddThh:mm:ss
   *                    without milliseconds, with optional timezone
   *                    (or an empty string if there is no timestamp available)
   *                    will be stored here.
   *
   * @return rc_ok if successful.
   *
   * @see addSignature(), getSignatureString(), SignDocSignatureParameters::setString()
   */
  ReturnCode getLastTimestamp (std::string &aTime)
  {
    SIGNDOC_Exception *ex = NULL;
    char *tempTime = NULL;
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_Document_getLastTimestamp (&ex, p, &tempTime);
        if (tempTime != NULL)
          aTime = tempTime;
      }
    catch (...)
      {
        SIGNDOC_free (tempTime);
        throw;
      }
    SIGNDOC_free (tempTime);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the current pathname of the document.
   *
   * The pathname will be empty if the document is stored in memory
   * (ie, if it has been loaded from memory or saved to a stream).
   *
   * If a FDF document has been opened, this function will return
   * the pathname of the referenced PDF file.
   *
   * @param[in]  aEncoding  The encoding to be used for @a aPath.
   * @param[out] aPath  The pathname will be stored here.
   *
   * @return rc_ok if successful.
   */
  ReturnCode getPathname (Encoding aEncoding, std::string &aPath)
  {
    SIGNDOC_Exception *ex = NULL;
    char *tempPath = NULL;
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_Document_getPathname (&ex, p, aEncoding, &tempPath);
        if (tempPath != NULL)
          aPath = tempPath;
      }
    catch (...)
      {
        SIGNDOC_free (tempPath);
        throw;
      }
    SIGNDOC_free (tempPath);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get a bitset indicating which signing methods are available
   *        for this document.
   *
   * This document's signature fields offer a subset of the signing methods
   * returned by this function.
   *
   * @return 1&lt;&lt;SignDocSignatureParameters::m_digsig_pkcs1 etc.
   *
   * @see SignDocSignatureParameters::getAvailableMethods()
   */
  int getAvailableMethods ()
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_Document_getAvailableMethods (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Verify a signature of the document.
   *
   * @param[in]  aEncoding   The encoding of @a aFieldName.
   * @param[in]  aFieldName  The name of the signature field encoded according
   *                         to @a aEncoding.
   * @param[out] aOutput     A pointer to a new SignDocVerificationResult
   *                         object or NULL will be stored here. The caller
   *                         is responsible for destroying that object.
   *
   * @return rc_ok if successful.
   *
   * @see SignDocField::isSigned()
   */
  ReturnCode verifySignature (Encoding aEncoding,
                              const std::string &aFieldName,
                              SIGNDOC_PTR<SignDocVerificationResult> &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_VerificationResult *tempOutput = NULL;
    aOutput.reset ((SignDocVerificationResult*)NULL);
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_Document_verifySignature (&ex, p, aEncoding, aFieldName.c_str (), &tempOutput);
        if (tempOutput != NULL)
          {
            aOutput.reset (makeSignDocVerificationResult (tempOutput));
            tempOutput = NULL;
          }
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_VerificationResult_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_VerificationResult_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Verify a signature of the document.
   *
   * @param[in]  aFieldName  The name of the signature field.
   * @param[out] aOutput     A pointer to a new SignDocVerificationResult
   *                         object or NULL will be stored here. The caller
   *                         is responsible for destroying that object.
   *
   * @return rc_ok if successful.
   *
   * @see SignDocField::isSigned()
   */
  ReturnCode verifySignature (const wchar_t *aFieldName,
                              SIGNDOC_PTR<SignDocVerificationResult> &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_VerificationResult *tempOutput = NULL;
    aOutput.reset ((SignDocVerificationResult*)NULL);
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_Document_verifySignatureW (&ex, p, aFieldName, &tempOutput);
        if (tempOutput != NULL)
          {
            aOutput.reset (makeSignDocVerificationResult (tempOutput));
            tempOutput = NULL;
          }
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_VerificationResult_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_VerificationResult_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Remove a signature of the document.
   *
   * For some document formats (TIFF), signatures may only be cleared in
   * the reverse order of signing (LIFO).
   *
   * @param[in]  aEncoding   The encoding of @a aFieldName.
   * @param[in]  aFieldName  The name of the signature field encoded according
   *                         to @a aEncoding.
   *
   * @return rc_ok if successful.
   *
   * @see clearAllSignatures(), getFields(), SignDocField::isCurrentlyClearable()
   */
  ReturnCode clearSignature (Encoding aEncoding, const std::string &aFieldName)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_clearSignature (&ex, p, aEncoding, aFieldName.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Remove all signature of the document.
   *
   * @return rc_ok if successful.
   *
   * @see clearSignature()
   */
  ReturnCode clearAllSignatures ()
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_clearAllSignatures (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Save the document to a stream.
   *
   * This function may have side effects on the document such as
   * marking it as not modified which may render sf_incremental
   * useless for the next saveToFile() call unless the document is
   * changed between those two calls.
   *
   * @param[in]  aStream  The document will be saved to this stream.
   * @param[in]  aFlags   Set of flags (of enum #SaveFlags, combined with `|')
   *                      modifying the behavior of this function.
   *                      Pass 0 for no flags.
   *                      Which flags are available depends on the document
   *                      type.
   *
   * @return rc_ok if successful.
   *
   * @see copyToStream(), getSaveToStreamFlags(), saveToFile(), SignDocDocumentLoader::loadFromFile(), SignDocDocumentLoader::loadFromMemory()
   */
  ReturnCode saveToStream (OutputStream &aStream, int aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_saveToStream (&ex, p, aStream.getImpl (), aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Save the document to a file.
   *
   * After a successful call to this function, the document behaves as
   * if it had been loaded from the specified file.
   *
   * Saving a signed PDF document without sf_incremental will fail,
   * see getRequiredSaveToFileFlags().
   *
   * @param[in] aEncoding  The encoding of the string pointed to by @a aPath.
   * @param[in]  aPath  The pathname of the file to be created or overwritten.
   *                    Pass NULL to save to the file from which the document
   *                    was loaded or most recently saved (which will
   *                    fail if the documment was loaded from memory
   *                    or saved to a stream).
   *                    See @ref winrt_store for restrictions on pathnames
   *                    in Windows Store apps.
   * @param[in]  aFlags   Set of flags (of enum #SaveFlags, combined with `|')
   *                      modifying the behavior of this function.
   *                      Pass 0 for no flags.
   *                      Which flags are available depends on the document
   *                      type.
   *
   * @return rc_ok if successful.
   *
   * @see copyToStream(), getRequiredSaveToFileFlags(), getSaveToFileFlags(), saveToStream(), SignDocDocumentLoader::loadFromFile(), SignDocDocumentLoader::loadFromMemory()
   */
  ReturnCode saveToFile (Encoding aEncoding, const char *aPath, int aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_saveToFile (&ex, p, aEncoding, aPath, aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Save the document to a file.
   *
   * After a successful call to this function, the document behaves as
   * if it had been loaded from the specified file.
   *
   * Saving a signed PDF document without sf_incremental will fail,
   * see getRequiredSaveToFileFlags().
   *
   * @param[in]  aPath  The pathname of the file to be created or overwritten.
   *                    Pass NULL to save to the file from which the document
   *                    was loaded or most recently saved (which will
   *                    fail if the documment was loaded from memory
   *                    or saved to a stream).
   * @param[in]  aFlags   Set of flags (of enum #SaveFlags, combined with `|')
   *                      modifying the behavior of this function.
   *                      Pass 0 for no flags.
   *                      Which flags are available depends on the document
   *                      type.
   *
   * @return rc_ok if successful.
   *
   * @see copyToStream(), getSaveToFileFlags(), saveToStream(), SignDocDocumentLoader::loadFromFile(), SignDocDocumentLoader::loadFromMemory()
   */
  ReturnCode saveToFile (const wchar_t *aPath, int aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_saveToFileW (&ex, p, aPath, aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Copy the document's current status or backing file or backing blob
   *        to a stream.
   *
   * If #ctsf_unsaved is not set in @a aFlags , this function will copy
   * to a stream the file or blob from which the document was loaded
   * or to which the document was most recently saved. Changes made to
   * the in-memory copy of the document since it was loaded or saved
   * will not be reflected in the copy written to the stream.
   *
   * If #ctsf_unsaved is set in @a aFlags, unsaved changes made to the
   * in-memory copy of the document will be included (as incremental
   * update for PDF documents) in the stream.
   *
   * This function does not have side effects on the in-memory copy of
   * the document, that is, unsaved changes remain unsaved (except for
   * being saved to the stream if #ctsf_unsaved is set in @a aFlags).
   *
   * @param[in] aStream  The file will be copied to this stream.
   * @param[in] aFlags   Flags modifying the behavior of this function,
   *                     see enum #CopyToStreamFlags.
   *
   * @return rc_ok if successful.
   *
   * @see copyAsSignedToStream(), saveToFile(), saveToStream(), SignDocDocumentLoader::loadFromFile(), SignDocDocumentLoader::loadFromMemory()
   */
  ReturnCode copyToStream (OutputStream &aStream, unsigned aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_copyToStream (&ex, p, aStream.getImpl (), aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Copy the document to a stream for viewing the document "as signed".
   *
   * This function copies to a stream the document as it was when the specified
   * signature field was signed.  If the specified signature field contains
   * the last signature applied to the document, this function is equivalent
   * to copyToStream(). However, for some document formats, this function
   * may require signatures to be valid.
   *
   * @param[in]  aEncoding    The encoding of @a aFieldName.
   * @param[in]  aFieldName   The name of the signature field encoded according
   *                          to @a aEncoding.
   * @param[in]  aStream      The file will be copied to this stream.
   *
   * @return rc_ok if successful.
   *
   * @see copyToStream(), SignDocDocumentLoader::loadFromMemory()
   */
  ReturnCode copyAsSignedToStream (Encoding aEncoding,
                                   const std::string &aFieldName,
                                   OutputStream &aStream)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_copyAsSignedToStream (&ex, p, aEncoding, aFieldName.c_str (), aStream.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get all flags currently valid for saveToStream().
   *
   * Note that sf_incremental cannot be used together with
   * sf_linearized even if all these flags are returned by this
   * function.
   * sf_pdfa_buttons is returned only if the document claims to be
   * PDF/A-1-compliant.
   *
   * @param[out]  aOutput  The flags will be stored here.
   *
   * @return rc_ok if successful.
   *
   * @see getSaveToFileFlags(), saveToStream()
   */
  ReturnCode getSaveToStreamFlags (int &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_getSaveToStreamFlags (&ex, p, &aOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get all flags currently valid for saveToFile().
   *
   * Note that sf_incremental cannot be used together with
   * sf_linearized even if all these flags are returned by this
   * function. sf_pdfa_buttons is returned only if the document
   * claims to be PDF/A-1-compliant.
   *
   * @param[out]  aOutput  The flags will be stored here.
   *
   * @return rc_ok if successful.
   *
   * @see getRequiredSaveToFileFlags(), getSaveToStreamFlags(), saveToFile()
   */
  ReturnCode getSaveToFileFlags (int &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_getSaveToFileFlags (&ex, p, &aOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get all flags currently required for saveToFile().
   *
   * This function currently stores #sf_incremental (saving the document
   * non-incrementally would destroy existing signatures) or 0 (the
   * document may be saved non-incrementally) to @a aOutput.
   *
   * @param[out]  aOutput  The flags will be stored here.
   *
   * @return rc_ok if successful.
   *
   * @see getSaveToFileFlags(), getSaveToStreamFlags(), saveToFile()
   */
  ReturnCode getRequiredSaveToFileFlags (int &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_getRequiredSaveToFileFlags (&ex, p, &aOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get all interactive fields of the specified types.
   *
   * @param[in]  aTypes   0 to get fields of all types.  Otherwise, a bitset
   *                      selecting the field types to be included. To include
   *                      a field of type t, add 1&lt;&lt;t, where t is a value of
   *                      SignDocField::Type.
   * @param[out] aOutput  The fields will be stored here.  They appear
   *                      in the order in which they have been defined.
   *
   * @return rc_ok if successful.
   *
   * @see exportFields(), getField(), getFieldsOfPage()
   */
  ReturnCode getFields (int aTypes, std::vector<SignDocField> &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_FieldArray *tempOutput = NULL;
    ReturnCode r;
    try
      {
        tempOutput = SIGNDOC_FieldArray_new (&ex);
        if (ex != NULL) SignDoc_throw (ex);
        r = (ReturnCode)SIGNDOC_Document_getFields (&ex, p, aTypes, tempOutput);
        assignArray (aOutput, tempOutput);
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_FieldArray_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_FieldArray_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get all interactive fields of the specified page, in tab order.
   *
   * If the document does not specify a tab order, the fields will be
   * returned in widget order.
   *
   * @note Structure order (S) is not yet supported.  If the page specifies
   *       structure order, the fields will be returned in widget order.
   *
   * @param[in]  aPage    The 1-based page number.
   * @param[in]  aTypes   0 to get fields of all types.  Otherwise, a bitset
   *                      selecting the field types to be included. To include
   *                      a field of type t, add 1&lt;&lt;t, where t is a value of
   *                      SignDocField::Type.
   * @param[out] aOutput  The fields will be stored here in tab order.
   *                      There will be one element per widget (rather than
   *                      per field); use SignDocField::getWidget() to find
   *                      out which widget of the field is referenced.
   *
   * @return rc_ok if successful.
   *
   * @see exportFields(), getField(), getFields()
   */
  ReturnCode getFieldsOfPage (int aPage, int aTypes,
                              std::vector<SignDocField> &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_FieldArray *tempOutput = NULL;
    ReturnCode r;
    try
      {
        tempOutput = SIGNDOC_FieldArray_new (&ex);
        if (ex != NULL) SignDoc_throw (ex);
        r = (ReturnCode)SIGNDOC_Document_getFieldsOfPage (&ex, p, aPage, aTypes, tempOutput);
        assignArray (aOutput, tempOutput);
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_FieldArray_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_FieldArray_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get an interactive field by name.
   *
   * @param[in]  aEncoding  The encoding of @a aName.
   * @param[in]  aName    The fully-qualified name of the field.
   * @param[out] aOutput  The field will be stored here.
   *
   * @return rc_ok if successful.
   *
   * @see getFields(), setField()
   */
  ReturnCode getField (Encoding aEncoding, const std::string &aName,
                       SignDocField &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_getField (&ex, p, aEncoding, aName.c_str (), aOutput.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Change a field.
   *
   * This function changes a field in the document using attributes
   * from a SignDocField object. Everything except for the name and
   * the type of the field can be changed. See the member functions of
   * SignDocField for details.
   *
   * Always get a SignDocField object for a field by calling
   * getField(), getFields(), or getFields(), then apply your
   * modifications to that object, then call setField().
   *
   * The coordinates of the field are not changed unless
   * #sff_move is set in @a aFlags.
   *
   * Do not try to build a SignDocField object from scratch for
   * changing a field as future versions of the SignDocField class may
   * have additional attributes.
   *
   * This function is implemented for PDF documents only.
   *
   * This function always fails for PDF documents that have signed
   * signature fields.
   *
   * @param[in,out]  aField    The field to be changed.  The font resource
   *                           name of the default text field attributes
   *                           may be modified. The value index and the
   *                           value may be modified
   *                           for radio button fields and check box fields.
   * @param[in]      aFlags    Flags modifying the behavior of this function,
   *                           see enum #SetFieldFlags.
   *
   * @return rc_ok if successful.
   *
   * @see addField(), getFields(), removeField()
   */
  ReturnCode setField (SignDocField &aField, unsigned aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_setField (&ex, p, aField.getImpl (), aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Add a field.
   *
   * See the members of SignDocField for details.
   *
   * This function can add check boxes, radio button groups,
   * text fields, and signature fields to PDF documents.
   *
   * When adding a radio button group or a check box
   * field, a value must be set, see SignDocField::setValue() and
   * SignDocField::setValueIndex().
   *
   * The SignDocField::f_NoToggleToOff flag should be set for all
   * radio button groups.  Adobe products seem to ignore this flag
   * being not set.
   *
   * When adding a text field, the justification must be set with
   * SignDocField::setJustification().
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
   * existing signature fields have flag f_EnableAddAfterSigning set.
   *
   * @param[in,out]  aField    The new field.  The font resource
   *                           name of the default text field attributes
   *                           may be modified. The value index and the
   *                           value may be modified
   *                           for radio button fields and check box fields.
   * @param[in]  aFlags        Flags modifying the behavior of this function,
   *                           see enum #SetFieldFlags.
   *
   * @return rc_ok if successful.
   *
   * @see getField(), removeField(), setField(), setTextFieldAttributes()
   */
  ReturnCode addField (SignDocField &aField, unsigned aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_addField (&ex, p, aField.getImpl (), aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Remove a field.
   *
   * Removing a field of a TIFF document will invalidate all signatures.
   *
   * @param[in]  aEncoding    The encoding of @a aName.
   * @param[in]  aName    The fully-qualified name of the field.
   *
   * @return rc_ok if successful.
   *
   * @see addField(), flattenField(), getFields()
   */
  ReturnCode removeField (Encoding aEncoding, const std::string &aName)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_removeField (&ex, p, aEncoding, aName.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Flatten a field.
   *
   * Flattening a field of a PDF document makes its appearance part of
   * the page and removes the selected widget or all widgets; the field
   * will be removed when all its widgets have been flattened.
   *
   * Flattening unsigned signature fields does not work correctly.
   *
   * @param[in]  aEncoding    The encoding of @a aName.
   * @param[in]  aName        The fully-qualified name of the field.
   * @param[in]  aWidget      The widget index to flatten only one widget
   *                          or -1 to flatten all widgets.
   *
   * @return rc_ok if successful.
   *
   * @see flattenFields(), removeField()
   */
  ReturnCode flattenField (Encoding aEncoding, const std::string &aName,
                           int aWidget)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_flattenField (&ex, p, aEncoding, aName.c_str (), aWidget);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   * @param[in] aFirstPage  1-based number of first page.
   * @param[in] aLastPage   1-based number of last page or 0 to process
   *                        all pages to the end of the document.
   * @param[in] aFlags      Flags modifying the behavior of this function,
   *                        see #FlattenFieldsFlags. If this value is 0,
   *                        signature fields and hidden/invisible widgets will
   *                        not be flattened.
   *
   * @return rc_ok if successful.
   *
   * @see flattenField(), removeField()
   */
  ReturnCode flattenFields (int aFirstPage, int aLastPage, unsigned aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_flattenFields (&ex, p, aFirstPage, aLastPage, aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Export all fields as XML.
   *
   * This function always uses UTF-8 encoding.  The output conforms
   * to schema PdfFields.xsd.
   *
   * @param[in]  aStream  The fields will be saved to this stream.
   * @param[in]  aFlags   Flags modifying the behavior of this function,
   *                      See enum #ExportFlags.
   *
   * @return rc_ok if successful.
   *
   * @see getFields(), setField()
   *
   * @todo implement for TIFF
   */
  ReturnCode exportFields (OutputStream &aStream, int aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_exportFields (&ex, p, aStream.getImpl (), aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Apply an FDF document to a PDF document.
   *
   * FDF documents can be applied to PDF documents only.
   *
   * @param[in] aEncoding  The encoding of the string pointed to by @a aPath.
   * @param[in] aPath      The pathname of the FDF document.
   *                       See @ref winrt_store for restrictions on pathnames
   *                       in Windows Store apps.
   * @param[in] aFlags     Flags modifying the behavior of this function,
   *                       see enum #SetFieldFlags.
   *
   * @return rc_ok if successful.
   */
  ReturnCode applyFdf (Encoding aEncoding, const char *aPath, unsigned aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_applyFdf (&ex, p, aEncoding, aPath, aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Apply an FDF document to a PDF document.
   *
   * FDF documents can be applied to PDF documents only.
   *
   * @param[in] aPath      The pathname of the FDF document.
   * @param[in] aFlags     Flags modifying the behavior of this function,
   *                       see enum #SetFieldFlags.
   *
   * @return rc_ok if successful.
   */
  ReturnCode applyFdf (const wchar_t *aPath, unsigned aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_applyFdfW (&ex, p, aPath, aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the document's default text field attributes.
   *
   * @param[in,out] aOutput  This object will be updated.
   *
   * @return rc_ok if successful.
   *
   * @see getField(), setTextFieldAttributes(), SignDocField::getTextFieldAttributes()
   */
  ReturnCode getTextFieldAttributes (SignDocTextFieldAttributes &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_getTextFieldAttributes (&ex, p, aOutput.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   * @param[in,out] aData  The new default text field attributes.
   *                       The font resource name will be updated.
   *
   * @return rc_ok iff successful.
   *
   * @see addField(), getTextFieldAttributes(), SignDocField::setTextFieldAttributes()
   */
  ReturnCode setTextFieldAttributes (SignDocTextFieldAttributes &aData)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_setTextFieldAttributes (&ex, p, aData.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the names and types of all SignDoc properties of a
   *        certain collection of properties of the document.
   *
   * Use getBooleanProperty(), getIntegerProperty(), or
   * getStringProperty() to get the values of the
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
   * rc_wrong_collection.  To move a property from one collection to
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
   * @param[in] aCollection   The name of the collection, see above.
   * @param[out] aOutput  The properties will be stored here.
   *
   * @return rc_ok if successful.
   *
   * @see removeProperty(), getStringProperty()
   */
  ReturnCode getProperties (const std::string &aCollection,
                            std::vector<SignDocProperty> &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_PropertyArray *tempOutput = NULL;
    ReturnCode r;
    try
      {
        tempOutput = SIGNDOC_PropertyArray_new (&ex);
        if (ex != NULL) SignDoc_throw (ex);
        r = (ReturnCode)SIGNDOC_Document_getProperties (&ex, p, aCollection.c_str (), tempOutput);
        assignArray (aOutput, tempOutput);
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_PropertyArray_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_PropertyArray_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the value of a SignDoc property (integer).
   *
   * In the "public" and "encrypted" collections, property names are
   * compared under Unicode simple case folding, that is, lower case
   * and upper case is not distinguished.
   *
   * @param[in]  aEncoding   The encoding of @a aName.
   * @param[in]  aCollection   The name of the collection, see getProperties().
   * @param[in]  aName   The name of the property.
   * @param[out] aValue  The value will be stored here.
   *
   * @return rc_ok if successful.
   *
   * @see getBooleanProperty(), getProperties(), getStringProperty()
   */
  ReturnCode getIntegerProperty (Encoding aEncoding,
                                 const std::string &aCollection,
                                 const std::string &aName, long &aValue)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_getIntegerProperty (&ex, p, aEncoding, aCollection.c_str (), aName.c_str (), &aValue);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the value of a SignDoc property (string).
   *
   * In the "public" and "encrypted" collections, property names are
   * compared under Unicode simple case folding, that is, lower case
   * and upper case is not distinguished.
   *
   * @param[in]  aEncoding   The encoding of @a aName and for @a aValue.
   * @param[in]  aCollection   The name of the collection, see getProperties().
   * @param[in]  aName   The name of the property.
   * @param[out] aValue  The value will be stored here, encoded according to
   *                     @a aEncoding.
   *
   * @return rc_ok if successful.
   *
   * @see getBooleanPropery(), getIntegerProperty(), getProperties()
   */
  ReturnCode getStringProperty (Encoding aEncoding,
                                const std::string &aCollection,
                                const std::string &aName, std::string &aValue)
  {
    SIGNDOC_Exception *ex = NULL;
    char *tempValue = NULL;
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_Document_getStringProperty (&ex, p, aEncoding, aCollection.c_str (), aName.c_str (), &tempValue);
        if (tempValue != NULL)
          aValue = tempValue;
      }
    catch (...)
      {
        SIGNDOC_free (tempValue);
        throw;
      }
    SIGNDOC_free (tempValue);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the value of a SignDoc property (boolean).
   *
   * In the "public" and "encrypted" collections, property names are
   * compared under Unicode simple case folding, that is, lower case
   * and upper case is not distinguished.
   *
   * @param[in]  aEncoding   The encoding of @a aName.
   * @param[in]  aCollection   The name of the collection, see getProperties().
   * @param[in]  aName   The name of the property.
   * @param[out] aValue  The value will be stored here.
   *
   * @return rc_ok if successful.
   *
   * @see getIntegerProperty(), getProperties(), getStringProperty()
   */
  ReturnCode getBooleanProperty (Encoding aEncoding,
                                 const std::string &aCollection,
                                 const std::string &aName, bool &aValue)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Boolean tempValue = 0;
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_Document_getBooleanProperty (&ex, p, aEncoding, aCollection.c_str (), aName.c_str (), &tempValue);
        aValue = (bool )tempValue;
      }
    catch (...)
      {
        throw;
      }
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the value of a SignDoc property (integer).
   *
   * In the "public" and "encrypted" collections, property names are
   * compared under Unicode simple case folding, that is, lower case
   * and upper case is not distinguished.
   *
   * It's not possible to change the type of a property.
   *
   * @param[in]  aEncoding   The encoding of @a aName.
   * @param[in]  aCollection   The name of the collection, see getProperties().
   * @param[in]  aName   The name of the property.
   * @param[in]  aValue  The new value of the property.
   *
   * @return rc_ok if successful.
   *
   * @see getProperties(), removeProperty(), setBooleanProperty(), setStringProperty(), addSignature()
   */
  ReturnCode setIntegerProperty (Encoding aEncoding,
                                 const std::string &aCollection,
                                 const std::string &aName, long aValue)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_setIntegerProperty (&ex, p, aEncoding, aCollection.c_str (), aName.c_str (), aValue);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   * @param[in]  aEncoding   The encoding of @a aName and @a aValue.
   * @param[in]  aCollection   The name of the collection, see getProperties().
   * @param[in]  aName   The name of the property.
   * @param[in]  aValue  The new value of the property.
   *
   * @return rc_ok if successful.
   *
   * @see getProperties(), removeProperty(), setBooleanProperty(), setIntegerProperty(), addSignature()
   */
  ReturnCode setStringProperty (Encoding aEncoding,
                                const std::string &aCollection,
                                const std::string &aName,
                                const std::string &aValue)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_setStringProperty (&ex, p, aEncoding, aCollection.c_str (), aName.c_str (), aValue.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Set the value of a SignDoc property (boolean).
   *
   * In the "public" and "encrypted" collections, property names are
   * compared under Unicode simple case folding, that is, lower case
   * and upper case is not distinguished.
   *
   * It's not possible to change the type of a property.
   *
   * @param[in]  aEncoding   The encoding of @a aName.
   * @param[in]  aCollection   The name of the collection, see getProperties().
   * @param[in]  aName   The name of the property.
   * @param[in]  aValue  The new value of the property.
   *
   * @return rc_ok if successful.
   *
   * @see getProperties(), removeProperty(), setIntegerProperty(), setStringProperty(), addSignature()
   */
  ReturnCode setBooleanProperty (Encoding aEncoding,
                                 const std::string &aCollection,
                                 const std::string &aName, bool aValue)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_setBooleanProperty (&ex, p, aEncoding, aCollection.c_str (), aName.c_str (), aValue);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Remove a SignDoc property.
   *
   * In the "public" and "encrypted" collections, property names are
   * compared under Unicode simple case folding, that is, lower case
   * and upper case is not distinguished.
   *
   * @param[in]  aEncoding   The encoding of @a aName.
   * @param[in]  aCollection   The name of the collection, see getProperties().
   * @param[in]  aName   The name of the property.
   *
   * @return rc_ok if successful.
   *
   * @see getProperties(), setStringProperty()
   */
  ReturnCode removeProperty (Encoding aEncoding,
                             const std::string &aCollection,
                             const std::string &aName)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_removeProperty (&ex, p, aEncoding, aCollection.c_str (), aName.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Export properties as XML.
   *
   * This function always uses UTF-8 encoding.
   * The output conforms to schema AllSignDocProperties.xsd
   * (if @a aCollection is empty) or SignDocProperties.xsd
   * (if @a aCollection is non-empty).
   *
   * @param[in]  aCollection   The name of the collection, see getProperties().
   *                           If the string is empty, all properties of the
   *                           "public" and "encrypted" collections
   *                           will be exported.
   * @param[in]  aStream  The properties will be saved to this stream.
   * @param[in]  aFlags   Flags modifying the behavior of this function,
   *                      See enum #ExportFlags.
   *
   * @return rc_ok if successful.
   *
   * @see importProperties()
   */
  ReturnCode exportProperties (const std::string &aCollection,
                               OutputStream &aStream, int aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_exportProperties (&ex, p, aCollection.c_str (), aStream.getImpl (), aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Import properties from XML.
   *
   * The input must conform to schema AllSignDocProperties.xsd
   * (if @a aCollection is empty) or SignDocProperties.xsd
   * (if @a aCollection is non-empty).
   *
   * @param[in]  aCollection   The name of the collection, see getProperties().
   *                           If the string is empty, properties will be
   *                           imported into all collections, otherwise
   *                           properties will be imported into the specified
   *                           collection.
   * @param[in]  aStream  The properties will be read from this stream.
   *                      This function reads the input completely, it doesn't
   *                      stop at the end tag.
   * @param[in]  aFlags   Flags modifying the behavior of this function,
   *                      see enum #ImportFlags.
   *
   * @return rc_ok if successful.
   *
   * @see exportProperties()
   */
  ReturnCode importProperties (const std::string &aCollection,
                               InputStream &aStream, int aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_importProperties (&ex, p, aCollection.c_str (), aStream.getImpl (), aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the SignDoc data block of the document.
   *
   * @note This function is no longer supported; it always returns
   *       rc_not_supported.
   *
   * @param[out]  aOutput  Not used.
   *
   * @return rc_not_supported.
   */
  ReturnCode getDataBlock (std::vector<unsigned char> &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_ByteArray *tempOutput = NULL;
    ReturnCode r;
    try
      {
        tempOutput = SIGNDOC_ByteArray_new (&ex);
        if (ex != NULL) SignDoc_throw (ex);
        r = (ReturnCode)SIGNDOC_Document_getDataBlock (&ex, p, tempOutput);
        assignArray (aOutput, tempOutput);
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_ByteArray_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_ByteArray_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Replace the SignDoc data block of the document.
   *
   * @note This function is no longer supported; it always returns
   *       rc_not_supported.
   *
   * @param[in] aData  Not used.
   * @param[in] aSize  Not used.
   *
   * @return rc_not_supported.
   */
  ReturnCode setDataBlock (const unsigned char *aData, size_t aSize)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_setDataBlock (&ex, p, aData, aSize);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the resolution of a page.
   *
   * Different pages of the document may have different resolutions.
   * Use getConversionFactors() to get factors for converting document
   * coordinates to real world coordinates.
   *
   * @param[in]  aPage    The page number (1 for the first page).
   * @param[out] aResX    The horizontal resolution in DPI will be stored here.
   *                      The value will be 0.0 if the resolution is not
   *                      available.
   * @param[out] aResY    The vertical resolution in DPI will be stored here.
   *                      The value will be 0.0 if the resolution is not
   *                      available.
   *
   * @return rc_ok if successful.
   *
   * @see getConversionFactors()
   */
  ReturnCode getResolution (int aPage, double &aResX, double &aResY)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_getResolution (&ex, p, aPage, &aResX, &aResY);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the conversion factors for a page.
   *
   * Different pages of the document may have different conversion factors.
   * For TIFF documents, this function yields the same values as
   * getResolution().
   *
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
   * @return rc_ok if successful.
   *
   * @see getPageSize(), getResolution()
   */
  ReturnCode getConversionFactors (int aPage, double &aFactorX,
                                   double &aFactorY)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_getConversionFactors (&ex, p, aPage, &aFactorX, &aFactorY);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the size of a page.
   *
   * Different pages of the document may have different sizes.
   * Use getConversionFactors() to get factors for converting the page size
   * from document coordinates to real world dimensions.
   *
   * @param[in]  aPage    The page number (1 for the first page).
   * @param[out] aWidth   The width of the page (in document coordinates)
   *                      will be stored here.
   * @param[out] aHeight  The height of the page (in document coordinates)
   *                      will be stored here.
   *
   * @return rc_ok if successful.
   *
   * @see getConversionFactors()
   */
  ReturnCode getPageSize (int aPage, double &aWidth, double &aHeight)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_getPageSize (&ex, p, aPage, &aWidth, &aHeight);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the number of bits per pixel (TIFF only).
   *
   * Different pages of the document may have different numbers of bits
   * per pixel.
   *
   * @param[in]  aPage    The page number (1 for the first page).
   * @param[out] aBPP     The number of bits per pixel of the page
   *                      (1, 8, 24, or 32) or 0 (for PDF documents)
   *                      will be stored here.
   *
   * @return rc_ok if successful, rc_invalid_argument if @a aPage is
   *         out of range.
   */
  ReturnCode getBitsPerPixel (int aPage, int &aBPP)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_getBitsPerPixel (&ex, p, aPage, &aBPP);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Compute the zoom factor used for rendering.
   *
   * If SignDocRenderParameters::fitWidth(),
   * SignDocRenderParameters::fitHeight(), or
   * SignDocRenderParameters::fitRect() has been called, the actual factor
   * depends on the document's page size.
   * If multiple pages are selected (see #SignDocRenderParameters::setPages()),
   * the maximum width and maximum height of all selected pages will be used.
   *
   * @param[out] aOutput  The zoom factor will be stored here.
   * @param[in]  aParams  The parameters such as the page number and the
   *                      zoom factor.
   *
   * @return rc_ok if successful.
   *
   * @see getRenderedSize(), renderPageAsImage(), SignDocRenderParameters::fitHeight(), SignDocRenderParameters::fitRect(), SignDocRenderParameters::fitWidth(), SignDocRenderParameters::setPages(), SignDocRenderParameters::setZoom()
   */
  ReturnCode computeZoom (double &aOutput,
                          const SignDocRenderParameters &aParams)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_computeZoom (&ex, p, &aOutput, aParams.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Convert a point expressed in canvas (image) coordinates to
   *        a point expressed in document coordinate system of the
   *        current page.
   *
   * The origin is in the bottom left corner of the page.
   * The origin is in the upper left corner of the image.
   * See @ref signdocshared_coordinates.
   * If multiple pages are selected (see #SignDocRenderParameters::setPages()),
   * the first page of the range will be used.
   *
   * Suppose the current page of a PDF document has height PH and the
   * rendered image has height IH.  Then, point (0,0) will be
   * converted to (0,PH) and point (0,IH) will be converted to (0,0).
   *
   * @param[in,out] aPoint   The point to be converted.
   * @param[in]     aParams  The parameters such as the page number and the
   *                         zoom factor.
   *
   * @return rc_ok if successful.
   */
  ReturnCode convCanvasPointToPagePoint (Point &aPoint,
                                         const SignDocRenderParameters &aParams)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_convCanvasPointToPagePoint (&ex, p, (SIGNDOC_Point*)&aPoint, aParams.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Convert a point expressed in document coordinate system of the
   *        current page to a point expressed in canvas (image) coordinates.
   *
   * The origin is in the bottom left corner of the page.
   * The origin is in the upper left corner of the image.
   * See @ref signdocshared_coordinates.
   * If multiple pages are selected (see #SignDocRenderParameters::setPages()),
   * the first page of the range will be used.
   *
   * Suppose the current page page of a PDF document has height PH and
   * the rendered image has height IH.  Then, point (0,0) will be
   * converted to (0,IH) and point (0,PH) will be converted to (0,0).
   *
   * @param[in,out] aPoint   The point to be converted.
   * @param[in]     aParams  The parameters such as the page number and the
   *                         zoom factor.
   *
   * @return rc_ok if successful.
   */
  ReturnCode convPagePointToCanvasPoint (Point &aPoint,
                                         const SignDocRenderParameters &aParams)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_convPagePointToCanvasPoint (&ex, p, (SIGNDOC_Point*)&aPoint, aParams.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Render the selected page (or pages) as image.
   *
   * @param[out] aImage  The image will be stored here as a blob.
   * @param[out] aOutput The image size will be stored here.
   * @param[in]  aParams    Parameters such as the page number.
   * @param[in]  aClipRect  The rectangle to be rendered (using document
   *                        coordinates, see @ref signdocshared_coordinates)
   *                        or NULL to render the complete page.
   *
   * @return rc_ok if successful.
   *
   * @see computeZoom(), getRenderedSize(), renderPageAsSpoocImage(), renderPageAsSpoocImages()
   *
   * @todo add another function which specifies the target rectangle
   *       (in addition than the source rectangle) to be rendered.
   */
  ReturnCode renderPageAsImage (std::vector<unsigned char> &aImage,
                                SignDocRenderOutput &aOutput,
                                const SignDocRenderParameters &aParams,
                                const Rect *aClipRect)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_ByteArray *tempImage = NULL;
    ReturnCode r;
    try
      {
        tempImage = SIGNDOC_ByteArray_new (&ex);
        if (ex != NULL) SignDoc_throw (ex);
        r = (ReturnCode)SIGNDOC_Document_renderPageAsImage (&ex, p, tempImage, (SIGNDOC_RenderOutput*)&aOutput, aParams.getImpl (), (const SIGNDOC_Rect*)aClipRect);
        assignArray (aImage, tempImage);
      }
    catch (...)
      {
        if (tempImage != NULL)
          SIGNDOC_ByteArray_delete (tempImage);
        throw;
      }
    if (tempImage != NULL)
      SIGNDOC_ByteArray_delete (tempImage);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the size of the rendered page in pixels (without actually
   *        rendering it).
   *
   * The returned values may be approximations for some document formats.
   * If multiple pages are selected (see #SignDocRenderParameters::setPages()),
   * the maximum width and maximum height of all selected pages will be used.
   *
   * @param[out] aOutput   The width and height of the image that would be
   *                       computed by renderPageAsImage() with @a aClipRect
   *                       being NULL will be stored here.
   * @param[in]  aParams   Parameters such as the page number.
   *
   * @return rc_ok if successful.
   *
   * @see renderPageAsImage(), renderPageAsSpoocImage(), renderPageAsSpoocImages()
   */
  ReturnCode getRenderedSize (SignDocRenderOutput &aOutput,
                              const SignDocRenderParameters &aParams)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_getRenderedSize (&ex, p, (SIGNDOC_RenderOutput*)&aOutput, aParams.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Create a line annotation.
   *
   * See SignDocAnnotation for details.
   *
   * This function uses document (page) coordinates,
   * see @ref signdocshared_coordinates.
   *
   * @param[in]  aStart    Start point.
   * @param[in]  aEnd      End point.
   *
   * @return The new annotation object. The caller is responsible for
   *         destroying the object after use.
   *
   * @see addAnnotation()
   */
  SignDocAnnotation *createLineAnnotation (const Point &aStart,
                                           const Point &aEnd)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Annotation *r;
    r = SIGNDOC_Document_createLineAnnotation (&ex, p, (const SIGNDOC_Point*)&aStart, (const SIGNDOC_Point*)&aEnd);
    if (ex != NULL) SignDoc_throw (ex);
    if (r == NULL)
      return NULL;
    try
      {
        return new SignDocAnnotation (r);
      }
    catch (...)
      {
        SIGNDOC_Annotation_delete (r);
        throw;
      }
  }

  /**
   * @brief Create a line annotation.
   *
   * See SignDocAnnotation for details.
   * This function uses document (page) coordinates,
   * see @ref signdocshared_coordinates.
   *
   * @param[in]  aStartX   X coordinate of start point.
   * @param[in]  aStartY   Y coordinate of start point.
   * @param[in]  aEndX     X coordinate of end point.
   * @param[in]  aEndY     Y coordinate of end point.
   *
   * @return The new annotation object. The caller is responsible for
   *         destroying the object after use.
   *
   * @see addAnnotation()
   */
  SignDocAnnotation *createLineAnnotation (double aStartX, double aStartY,
                                           double aEndX, double aEndY)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Annotation *r;
    r = SIGNDOC_Document_createLineAnnotationXY (&ex, p, aStartX, aStartY, aEndX, aEndY);
    if (ex != NULL) SignDoc_throw (ex);
    if (r == NULL)
      return NULL;
    try
      {
        return new SignDocAnnotation (r);
      }
    catch (...)
      {
        SIGNDOC_Annotation_delete (r);
        throw;
      }
  }

  /**
   * @brief Create a scribble annotation.
   *
   * See SignDocAnnotation for details.
   * This function uses document (page) coordinates,
   * see @ref signdocshared_coordinates.
   *
   * @return The new annotation object. The caller is responsible for
   *         destroying the object after use.
   *
   * @see addAnnotation(), SignDocAnnotation::addPoint(), SignDocAnnotation::newStroke()
   */
  SignDocAnnotation *createScribbleAnnotation ()
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Annotation *r;
    r = SIGNDOC_Document_createScribbleAnnotation (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    if (r == NULL)
      return NULL;
    try
      {
        return new SignDocAnnotation (r);
      }
    catch (...)
      {
        SIGNDOC_Annotation_delete (r);
        throw;
      }
  }

  /**
   * @brief Create a text annotation.
   *
   * See SignDocAnnotation for details.
   * This function uses document (page) coordinates,
   * see @ref signdocshared_coordinates.
   *
   * @param[in]  aLowerLeft  coordinates of lower left corner.
   * @param[in]  aUpperRight coordinates of upper right corner.
   *
   * @return The new annotation object. The caller is responsible for
   *         destroying the object after use.
   *
   * @see addAnnotation()
   */
  SignDocAnnotation *createFreeTextAnnotation (const Point &aLowerLeft,
                                               const Point &aUpperRight)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Annotation *r;
    r = SIGNDOC_Document_createFreeTextAnnotation (&ex, p, (const SIGNDOC_Point*)&aLowerLeft, (const SIGNDOC_Point*)&aUpperRight);
    if (ex != NULL) SignDoc_throw (ex);
    if (r == NULL)
      return NULL;
    try
      {
        return new SignDocAnnotation (r);
      }
    catch (...)
      {
        SIGNDOC_Annotation_delete (r);
        throw;
      }
  }

  /**
   * @brief Create a text annotation.
   *
   * See SignDocAnnotation for details.
   * This function uses document (page) coordinates,
   * see @ref signdocshared_coordinates.
   *
   * @param[in]  aX0       X coordinate of lower left corner.
   * @param[in]  aY0       Y coordinate of lower left corner.
   * @param[in]  aX1       X coordinate of upper right corner.
   * @param[in]  aY1       Y coordinate of upper right corner.
   *
   * @return The new annotation object. The caller is responsible for
   *         destroying the object after use.
   *
   * @see addAnnotation()
   */
  SignDocAnnotation *createFreeTextAnnotation (double aX0, double aY0,
                                               double aX1, double aY1)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Annotation *r;
    r = SIGNDOC_Document_createFreeTextAnnotationXY (&ex, p, aX0, aY0, aX1, aY1);
    if (ex != NULL) SignDoc_throw (ex);
    if (r == NULL)
      return NULL;
    try
      {
        return new SignDocAnnotation (r);
      }
    catch (...)
      {
        SIGNDOC_Annotation_delete (r);
        throw;
      }
  }

  /**
   * @brief Add an annotation to a page.
   *
   * See SignDocAnnotation for details.
   *
   * @param[in]  aPage     The page number (1 for the first page).
   * @param[in]  aAnnot    Pointer to the new annotation.  Ownership remains
   *                       at the caller.
   *
   * @return rc_ok if successful.
   *
   * @see createLineAnnotation(), createScribbleAnnotation(), createFreeTextAnnotation()
   */
  ReturnCode addAnnotation (int aPage, const SignDocAnnotation *aAnnot)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_addAnnotation (&ex, p, aPage, aAnnot->getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get a list of all named annotations of a page.
   *
   * Unnamed annotations are ignored by this function.
   *
   * @param[in]  aEncoding  The encoding to be used for the names of the
   *                        annotations returned in @a aOutput.
   * @param[in]  aPage     The page number (1 for the first page).
   * @param[out] aOutput   The names of the annotations will be stored here.
   *
   * @return rc_ok if successful.
   *
   * @see addAnnotation(), getAnnotation(), removeAnnotation(), SignDocAnnotation::setName()
   */
  ReturnCode getAnnotations (Encoding aEncoding, int aPage,
                             std::vector<std::string> &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_StringArray *tempOutput = NULL;
    ReturnCode r;
    try
      {
        tempOutput = SIGNDOC_StringArray_new (&ex);
        if (ex != NULL) SignDoc_throw (ex);
        r = (ReturnCode)SIGNDOC_Document_getAnnotations (&ex, p, aEncoding, aPage, tempOutput);
        assignArray (aOutput, tempOutput);
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_StringArray_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_StringArray_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get a named annotation of a page.
   *
   * All setters will fail for the returned object.
   *
   * @param[in]  aEncoding   The encoding of @a aName.
   * @param[in]  aPage     The page number (1 for the first page).
   * @param[in]  aName     The name of the annotation.
   * @param[out] aOutput   A pointer to a new SignDocAnnotation object or
   *                       NULL will be stored here. The caller is responsible
   *                       for destroying that object.
   *
   * @return rc_ok if successful.
   *
   * @see getAnnotations()
   */
  ReturnCode getAnnotation (Encoding aEncoding, int aPage,
                            const std::string &aName,
                            SIGNDOC_PTR<SignDocAnnotation> &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Annotation *tempOutput = NULL;
    aOutput.reset ((SignDocAnnotation*)NULL);
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_Document_getAnnotation (&ex, p, aEncoding, aPage, aName.c_str (), &tempOutput);
        if (tempOutput != NULL)
          {
            aOutput.reset (new SignDocAnnotation (tempOutput));
            tempOutput = NULL;
          }
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_Annotation_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_Annotation_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Remove an annotation identified by name.
   *
   * @param[in]  aEncoding   The encoding of @a aName.
   * @param[in]  aPage     The page number (1 for the first page).
   * @param[in]  aName     The name of the annotation, must not be
   *                       empty.
   *
   * @return rc_ok if successful.
   *
   * @see addAnnotation(), getAnnotations(), SignDocAnnotation::setName()
   */
  ReturnCode removeAnnotation (Encoding aEncoding, int aPage,
                               const std::string &aName)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_removeAnnotation (&ex, p, aEncoding, aPage, aName.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Add text to a page.
   *
   * Multiple lines are not supported, the text must not contain CR
   * and LF characters.
   *
   * @param[in] aEncoding   The encoding of @a aText and @a aFontName.
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
   * @see addTextRect(), addWatermark(), SignDocDocumentLoader::loadFontConfigFile(), SignDocDocumentLoader::loadFontConfigEnvironment(), SignDocDocumentLoader::loadFontConfigStream()
   *
   * @todo implement for TIFF documents
   */
  ReturnCode addText (Encoding aEncoding, const std::string &aText, int aPage,
                      double aX, double aY, const std::string &aFontName,
                      double aFontSize, const SignDocColor &aTextColor,
                      double aOpacity, int aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_addText (&ex, p, aEncoding, aText.c_str (), aPage, aX, aY, aFontName.c_str (), aFontSize, aTextColor.getImpl (), aOpacity, aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   * @param[in] aEncoding   The encoding of @a aText and @a aFontName.
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
   * @see addText(), addWatermark(), SignDocDocumentLoader::loadFontConfigFile(), SignDocDocumentLoader::loadFontConfigEnvironment(), SignDocDocumentLoader::loadFontConfigStream()
   *
   * @todo implement for TIFF documents
   */
  ReturnCode addTextRect (Encoding aEncoding, const std::string &aText,
                          int aPage, double aX0, double aY0, double aX1,
                          double aY1, const std::string &aFontName,
                          double aFontSize, double aLineSkip,
                          const SignDocColor &aTextColor, double aOpacity,
                          HAlignment aHAlignment, VAlignment aVAlignment,
                          int aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_addTextRect (&ex, p, aEncoding, aText.c_str (), aPage, aX0, aY0, aX1, aY1, aFontName.c_str (), aFontSize, aLineSkip, aTextColor.getImpl (), aOpacity, aHAlignment, aVAlignment, aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Add a watermark.
   *
   * @param[in] aInput   An object describing the watermark.
   *
   * @see addText(), addTextRect(), SignDocDocumentLoader::loadFontConfigFile(), SignDocDocumentLoader::loadFontConfigEnvironment(), SignDocDocumentLoader::loadFontConfigStream()
   *
   * @todo implement for TIFF documents
   */
  ReturnCode addWatermark (const SignDocWatermark &aInput)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_addWatermark (&ex, p, aInput.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Find text.
   *
   * @param[in] aEncoding   The encoding of @a aText.
   * @param[in] aFirstPage  1-based number of first page to be searched.
   * @param[in] aLastPage   1-based number of last page to be searched or
   *                        0 to search to the end of the document.
   * @param[in] aText       Text to be searched for.
   *                        Multiple successive spaces are treated as
   *                        single space (and may be ignored subject to
   *                        @a aFlags).
   * @param[in] aFlags      Flags modifying the behavior of this function,
   *                        see enum #FindTextFlags.
   * @param[out] aOutput    The positions where @a aText was found.
   *
   * @return rc_ok on success (even if the text was not found).
   */
  ReturnCode findText (Encoding aEncoding, int aFirstPage, int aLastPage,
                       const std::string &aText, int aFlags,
                       std::vector<SignDocFindTextPosition> &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_FindTextPositionArray *tempOutput = NULL;
    ReturnCode r;
    try
      {
        tempOutput = SIGNDOC_FindTextPositionArray_new (&ex);
        if (ex != NULL) SignDoc_throw (ex);
        r = (ReturnCode)SIGNDOC_Document_findText (&ex, p, aEncoding, aFirstPage, aLastPage, aText.c_str (), aFlags, tempOutput);
        assignArray (aOutput, tempOutput);
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_FindTextPositionArray_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_FindTextPositionArray_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Add an attachment to the document.
   *
   * Attachments are supported for PDF documents only.
   *
   * @param[in]  aEncoding       The encoding of @a aName and @a aDescription.
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
   * @return rc_ok if successful.
   *
   * @see addAttachmentFile(), getAttachments(), removeAttachment()
   */
  ReturnCode addAttachmentBlob (Encoding aEncoding, const std::string &aName,
                                const std::string &aDescription,
                                const std::string &aType,
                                const std::string &aModificationTime,
                                const void *aPtr, size_t aSize, int aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_addAttachmentBlob (&ex, p, aEncoding, aName.c_str (), aDescription.c_str (), aType.c_str (), aModificationTime.c_str (), aPtr, aSize, aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Add an attachment (read from a file) to the document.
   *
   * Attachments are supported for PDF documents only.
   *
   * @param[in]  aEncoding1      The encoding of @a aName and @a aDescription.
   * @param[in]  aName           The name of the attachment. Will also be
   *                             used as filename of the attachment and must
   *                             not contain slashes, backslashes, and colons.
   * @param[in]  aDescription    The description of the attachment (can be
   *                             empty).
   * @param[in]  aType           The MIME type of the attachment (can be
   *                             empty, seems to be ignored by Adobe Reader).
   * @param[in]  aEncoding2      The encoding of @a aPath.
   * @param[in]  aPath           The pathname of the file to be attached.
   * @param[in]  aFlags          Must be zero.
   *
   * @return rc_ok if successful.
   *
   * @see addAttachmentBlob(), getAttachments(), removeAttachment()
   */
  ReturnCode addAttachmentFile (Encoding aEncoding1, const std::string &aName,
                                const std::string &aDescription,
                                const std::string &aType, Encoding aEncoding2,
                                const std::string &aPath, int aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_addAttachmentFile (&ex, p, aEncoding1, aName.c_str (), aDescription.c_str (), aType.c_str (), aEncoding2, aPath.c_str (), aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Remove an attachment from the document.
   *
   * Attachments are supported for PDF documents only.
   *
   * @param[in]  aEncoding       The encoding of @a aName.
   * @param[in]  aName           The name of the attachment.
   *
   * @return rc_ok if successful.
   *
   * @see addAttachmentBlob(), addAttachmentFile(), getAttachments()
   */
  ReturnCode removeAttachment (Encoding aEncoding, const std::string &aName)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_removeAttachment (&ex, p, aEncoding, aName.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Change the description of an attachment of the document.
   *
   * Attachments are supported for PDF documents only.
   *
   * @param[in]  aEncoding       The encoding of @a aName and @a aDescription.
   * @param[in]  aName           The name of the attachment.
   * @param[in]  aDescription    The new description of the attachment.
   *
   * @return rc_ok if successful.
   *
   * @see addAttachmentBlob(), addAttachmentFile(), getAttachments(), removeAttachment()
   */
  ReturnCode changeAttachmentDescription (Encoding aEncoding,
                                          const std::string &aName,
                                          const std::string &aDescription)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_changeAttachmentDescription (&ex, p, aEncoding, aName.c_str (), aDescription.c_str ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get a list of all attachments of the document.
   *
   * Attachments are supported for PDF documents only.
   *
   * @param[in]  aEncoding  The encoding to be used for the names returned
   *                        in @a aOutput.
   * @param[out] aOutput    The names of the document's attachments
   *                        will be stored here.  Use getAttachment()
   *                        to get information for a single attachment.
   *
   * @return rc_ok if successful.
   *
   * @see checkAttachment(), getAttachment(), getAttachmentBlob(), getAttachmentStream()
   */
  ReturnCode getAttachments (Encoding aEncoding,
                             std::vector<std::string> &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_StringArray *tempOutput = NULL;
    ReturnCode r;
    try
      {
        tempOutput = SIGNDOC_StringArray_new (&ex);
        if (ex != NULL) SignDoc_throw (ex);
        r = (ReturnCode)SIGNDOC_Document_getAttachments (&ex, p, aEncoding, tempOutput);
        assignArray (aOutput, tempOutput);
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_StringArray_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_StringArray_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get information about an attachment.
   *
   * Attachments are supported for PDF documents only.
   *
   * @param[in]  aEncoding  The encoding of @a aName.
   * @param[in]  aName      The name of the attachment.
   * @param[out] aOutput    Information about the attachment will be stored
   *                        here.
   *
   * @return rc_ok if successful.
   *
   * @see checkAttachment(), getAttachments(), getAttachmentBlob(), getAttachmentStream()
   */
  ReturnCode getAttachment (Encoding aEncoding, const std::string &aName,
                            SignDocAttachment &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_getAttachment (&ex, p, aEncoding, aName.c_str (), aOutput.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Check the checksum of an attachment.
   *
   * Attachments are supported for PDF documents only.
   *
   * @param[in]  aEncoding  The encoding of @a aName.
   * @param[in]  aName      The name of the attachment.
   * @param[out] aOutput    The result of the check will be stored here.
   *
   * @return rc_ok if successful.
   *
   * @see getAttachment(), getAttachments(), getAttachmentBlob(), getAttachmentStream()
   */
  ReturnCode checkAttachment (Encoding aEncoding, const std::string &aName,
                              CheckAttachmentResult &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    int tempOutput = 0;
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_Document_checkAttachment (&ex, p, aEncoding, aName.c_str (), &tempOutput);
        aOutput = (CheckAttachmentResult )tempOutput;
      }
    catch (...)
      {
        throw;
      }
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get an attachment as blob.
   *
   * Attachments are supported for PDF documents only.
   *
   * @param[in]  aEncoding  The encoding of @a aName.
   * @param[in]  aName      The name of the attachment.
   * @param[out] aOutput    The attachment will be stored here.
   *
   * @return rc_ok if successful.
   *
   * @see checkAttachment(), getAttachments(), getAttachmentStream()
   */
  ReturnCode getAttachmentBlob (Encoding aEncoding, const std::string &aName,
                                std::vector<unsigned char> &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_ByteArray *tempOutput = NULL;
    ReturnCode r;
    try
      {
        tempOutput = SIGNDOC_ByteArray_new (&ex);
        if (ex != NULL) SignDoc_throw (ex);
        r = (ReturnCode)SIGNDOC_Document_getAttachmentBlob (&ex, p, aEncoding, aName.c_str (), tempOutput);
        assignArray (aOutput, tempOutput);
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_ByteArray_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_ByteArray_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get an InputStream for an attachment.
   *
   * Attachments are supported for PDF documents only.
   *
   * @param[in]  aEncoding  The encoding of @a aName.
   * @param[in]  aName      The name of the attachment.
   * @param[out] aOutput    A pointer to a new InputStream object will be
   *                        stored here; the caller is responsible for
   *                        deleting that object after use. The InputStream
   *                        does not support seek(), tell(), and avail().
   *
   * @return rc_ok if successful.
   *
   * @see checkAttachment(), getAttachments(), getAttachmentBlob()
   */
  ReturnCode getAttachmentStream (Encoding aEncoding, const std::string &aName,
                                  SIGNDOC_PTR<InputStream> &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_InputStream *tempOutput = NULL;
    aOutput.reset ((InputStream*)NULL);
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_Document_getAttachmentStream (&ex, p, aEncoding, aName.c_str (), &tempOutput);
        if (tempOutput != NULL)
          {
            aOutput.reset (new LibraryInputStream (tempOutput));
            tempOutput = NULL;
          }
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_InputStream_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_InputStream_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Add an empty page to the document.
   *
   * This function is currently implemented for PDF documents only.
   *
   * @param[in]  aTargetPage  The 1-based number of the page before which
   *                          to insert the new page.  The page will
   *                          be appended if this value is 0.
   * @param[in]  aWidth       The width of the page (in 1/72 inches
   *                          for PDF documents).
   * @param[in]  aHeight      The height of the page (in 1/72 inches
   *                          for PDF documents).
   *
   * @return rc_ok if successful.
   */
  ReturnCode addPage (int aTargetPage, double aWidth, double aHeight)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_addPage (&ex, p, aTargetPage, aWidth, aHeight);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Import pages from another document.
   *
   * This function is currently implemented for PDF documents only.
   * The pages to be imported must not contain any interactive fields
   * having names that are already used for intercative fields in the
   * target document.
   *
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
   * @return rc_ok if successful.
   */
  ReturnCode importPages (int aTargetPage, SignDocDocument *aSource,
                          int aSourcePage, int aPageCount, int aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_importPages (&ex, p, aTargetPage, aSource->getImpl (), aSourcePage, aPageCount, aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Import a page from a blob containing an image.
   *
   * This function is currently implemented for PDF documents only.
   *
   * @param[in]  aTargetPage  The 1-based number of the page before which
   *                          to insert the new page.  The page will
   *                          be appended if this value is 0.
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
   * @param[in]  aWidth       Page width (document coordinates) or zero.
   *                          If this argument is non-zero, @a aHeight must
   *                          also be non-zero and @a aZoom must be zero.
   *                          The image will be scaled to this width.
   * @param[in]  aHeight      Page height (document coordinates) or zero.
   *                          If this argument is non-zero, @a aWidth must
   *                          also be non-zero and @a aZoom must be zero.
   *                          The image will be scaled to this height.
   * @param[in]  aFlags       Flags modifying the behavior of this function,
   *                          See enum #ImportImageFlags.  ii_keep_aspect_ratio
   *                          is not needed if @a aZoom is non-zero.
   *
   * @return rc_ok if successful.
   *
   * @see addImageFromBlob(), importPageFromImageFile()
   *
   * @todo multi-page TIFF
   */
  ReturnCode importPageFromImageBlob (int aTargetPage,
                                      const unsigned char *aPtr, size_t aSize,
                                      double aZoom, double aWidth,
                                      double aHeight, int aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_importPageFromImageBlob (&ex, p, aTargetPage, aPtr, aSize, aZoom, aWidth, aHeight, aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Import a page from a file containing an image.
   *
   * This function is currently implemented for PDF documents only.
   *
   * @param[in]  aTargetPage  The 1-based number of the page before which
   *                          to insert the new page.  The page will
   *                          be appended if this value is 0.
   * @param[in]  aEncoding    The encoding of @a aPath.
   * @param[in]  aPath        The pathname of the file containing the image.
   *                          Supported formats for inserting into PDF
   *                          documents are: JPEG, PNG, GIF, TIFF, and BMP.
   * @param[in]  aZoom        Zoom factor or zero.  If this argument is
   *                          non-zero, @a aWidth and @a aHeight must be
   *                          zero.  The size of the page is computed from
   *                          the image size and resolution, multiplied by
   *                          @a aZoom.
   * @param[in]  aWidth       Page width (document coordinates) or zero.
   *                          If this argument is non-zero, @a aHeight must
   *                          also be non-zero and @a aZoom must be zero.
   *                          The image will be scaled to this width.
   * @param[in]  aHeight      Page height (document coordinates) or zero.
   *                          If this argument is non-zero, @a aWidth must
   *                          also be non-zero and @a aZoom must be zero.
   *                          The image will be scaled to this height.
   * @param[in]  aFlags       Flags modifying the behavior of this function,
   *                          See enum #ImportImageFlags.  ii_keep_aspect_ratio
   *                          is not needed if @a aZoom is non-zero.
   *
   * @return rc_ok if successful.
   *
   * @see addImageFromFile(), importPageFromImageBlob()
   *
   * @todo multi-page TIFF
   */
  ReturnCode importPageFromImageFile (int aTargetPage, Encoding aEncoding,
                                      const std::string &aPath, double aZoom,
                                      double aWidth, double aHeight,
                                      int aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_importPageFromImageFile (&ex, p, aTargetPage, aEncoding, aPath.c_str (), aZoom, aWidth, aHeight, aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Add an image (from a blob) to a page.
   *
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
   *                          be non-zero or ii_keep_aspect_ratio must
   *                          be set in @a aFlags.
   * @param[in]  aHeight      Page height (document coordinates) or zero.
   *                          The image will be scaled to this height.
   *                          If this argument is non-zero, @a aZoom must
   *                          be zero and either @a aWidth must
   *                          be non-zero or ii_keep_aspect_ratio must
   *                          be set in @a aFlags.
   * @param[in]  aFlags       Flags modifying the behavior of this function,
   *                          See enum #ImportImageFlags.  ii_keep_aspect_ratio
   *                          is not needed if @a aZoom is non-zero.
   *
   * @return rc_ok if successful.
   *
   * @see importPageFromImageBlob(), addImageFromFile()
   */
  ReturnCode addImageFromBlob (int aTargetPage, const unsigned char *aPtr,
                               size_t aSize, double aZoom, double aX,
                               double aY, double aWidth, double aHeight,
                               int aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_addImageFromBlob (&ex, p, aTargetPage, aPtr, aSize, aZoom, aX, aY, aWidth, aHeight, aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Add an image (from a file) to a page.
   *
   * @param[in]  aTargetPage  The 1-based number of the page.
   * @param[in]  aEncoding    The encoding of @a aPath.
   * @param[in]  aPath        The pathname of the file containing the image.
   *                          Supported formats for inserting into PDF
   *                          documents are: JPEG, PNG, GIF, TIFF, and BMP.
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
   *                          be non-zero or ii_keep_aspect_ratio must
   *                          be set in @a aFlags.
   * @param[in]  aHeight      Page height (document coordinates) or zero.
   *                          The image will be scaled to this height.
   *                          If this argument is non-zero, @a aZoom must
   *                          be zero and either @a aWidth must
   *                          be non-zero or ii_keep_aspect_ratio must
   *                          be set in @a aFlags.
   * @param[in]  aFlags       Flags modifying the behavior of this function,
   *                          See enum #ImportImageFlags.  ii_keep_aspect_ratio
   *                          is not needed if @a aZoom is non-zero.
   *
   * @return rc_ok if successful.
   *
   * @see importPageFromImageBlob()
   */
  ReturnCode addImageFromFile (int aTargetPage, Encoding aEncoding,
                               const std::string &aPath, double aZoom,
                               double aX, double aY, double aWidth,
                               double aHeight, int aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_addImageFromFile (&ex, p, aTargetPage, aEncoding, aPath.c_str (), aZoom, aX, aY, aWidth, aHeight, aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Remove pages from the document.
   *
   * A document must have at least page. This function will fail if
   * you attempt to remove all pages.
   *
   * Fields will be removed if all their widgets are on removed pages.
   *
   * Only signatures in signature fields having the SignDocField::f_SinglePage
   * flag set can survive removal of pages.
   *
   * @param[in] aPagesPtr    Pointer to an array of one-based page numbers.
   *                         The order does not matter, neither does the
   *                         number of occurences of a page number.
   * @param[in] aPagesCount  Number of page numbers pointed to by @a aPagesPtr.
   * @param[in] aMode        Tell this function whether to keep or to remove
   *                         the pages specified by @a aPagesPtr.
   *
   * @return rc_ok if successful.
   */
  ReturnCode removePages (const int *aPagesPtr, int aPagesCount,
                          KeepOrRemove aMode)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_removePages (&ex, p, aPagesPtr, aPagesCount, aMode);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Request to not make changes to the document which are
   *        incompatible with an older version of this class.
   *
   * No features introduced after @a aMajor.@a aMinor will be used.
   *
   * Passing a version number before 1.11 or after the current version
   * will fail.
   *
   * @param[in] aMajor  Major version number.
   * @param[in] aMinor  Minor version number.
   *
   * @return rc_ok if successful.
   */
  ReturnCode setCompatibility (int aMajor, int aMinor)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_setCompatibility (&ex, p, aMajor, aMinor);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Check if the document has unsaved changes.
   *
   * @param[out] aModified   Will be set to true if the document has
   *                         unsaved changes, will be set to false if
   *                         the document does not have unsaved changes.
   *
   * @return rc_ok if successful.
   */
  ReturnCode isModified (bool &aModified) const
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Boolean tempModified = 0;
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_Document_isModified (&ex, p, &tempModified);
        aModified = (bool )tempModified;
      }
    catch (...)
      {
        throw;
      }
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   * @param[in] aFlags    Must be 0.
   *
   * @see removePDFA(), setShootInFoot()
   */
  ReturnCode removePermissions (unsigned aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_removePermissions (&ex, p, aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Remove PDF/A conformance.
   *
   * Some operations on PDF documents (such as using standard fonts)
   * are not allowed in PDF/A documents. This function turns a PDF/A
   * document into a plain document, enabling those operations.
   *
   * This function is available for PDF documents only.
   *
   * @param[in] aFlags    Must be 0.
   *
   * @see removePermissions()
   */
  ReturnCode removePDFA (unsigned aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_removePDFA (&ex, p, aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Disable safety checks.
   *
   * The default value, 0, makes operations fail which would
   * invalidate existing signatures (signature fields) or signatures
   * granting permissions.
   *
   * @note If you set any flags you risk shooting yourself in the foot.
   *
   * @param[in] aFlags   New set of flags, see enum #ShootInFootFlags.
   *
   * @return rc_ok iff successful.
   *
   * @see removePermissions()
   */
  ReturnCode setShootInFoot (unsigned aFlags)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_Document_setShootInFoot (&ex, p, aFlags);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get an error message for the last function call.
   *
   * @param[in] aEncoding  The encoding to be used for the error message.
   *
   * @return A pointer to a string describing the reason for the
   *         failure of the last function call. The string is empty
   *         if the last call succeeded. The pointer is valid until
   *         this object is destroyed or a member function of this
   *         object is called.
   *
   * @see getErrorMessageW()
   */
  const char *getErrorMessage (Encoding aEncoding) const
  {
    SIGNDOC_Exception *ex = NULL;
    const char *r;
    r = SIGNDOC_Document_getErrorMessage (&ex, p, aEncoding);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get an error message for the last function call.
   *
   * @return A pointer to a string describing the reason for the
   *         failure of the last function call. The string is empty
   *         if the last call succeeded. The pointer is valid until
   *         this object is destroyed or a member function of this
   *         object is called.
   *
   * @see getErrorMessage()
   */
  const wchar_t *getErrorMessageW () const
  {
    SIGNDOC_Exception *ex = NULL;
    const wchar_t *r;
    r = SIGNDOC_Document_getErrorMessageW (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the underlying SPPDF_Document object.
   *
   * @note Please be careful to not interfere with SignDoc SDK operation.
   *
   * @param[in] aDestroy  false to let this SignDocDocument object
   *                      live, true to destroy this SignDocDocument object.
   *
   * @return A pointer to the underlying SPPDF_Document object or
   *         NULL if the document is not a PDF document.
   *         If @a aDestroy is false, do not destroy the
   *         SPPDF_Document object; the SPPDF_Document object is valid until
   *         this SignDocDocument object is destroyed.
   *         If @a aDestroy is true and the return value is not NULL,
   *         you must no longer use this SigndDocDocument object
   *         and you must destroy the SPPDF_Document object
   *         after use.
   *
   *
   * @see ~SignDocDocument()
   */
  SPPDF_Document *getSPPDFDocument (bool aDestroy)
  {
    SIGNDOC_Exception *ex = NULL;
    SPPDF_Document *r;
    r = SIGNDOC_Document_getSPPDFDocument (&ex, p, aDestroy);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

private:
  /**
   * @brief Copy Constructor (unavailable).
   */
  SignDocDocument (const SignDocDocument &);

  /**
   * @brief Assignment operator (unavailable).
   */
  SignDocDocument &operator= (const SignDocDocument &);
public:
  /**
   * @brief Internal function.
   * @internal
   */
  SignDocDocument (SIGNDOC_Document *aP) : p (aP) { }

  /**
   * @brief Internal function.
   * @internal
   */
  SIGNDOC_Document *getImpl () { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  const SIGNDOC_Document *getImpl () const { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  void setImpl (SIGNDOC_Document *aP) { SIGNDOC_Document_delete (p); p  = aP; }

private:
  SIGNDOC_Document *p;
};

/**
 * @brief Handler for one document type (internal interface).
 */
class SignDocDocumentHandler 
{
public:
  /**
   * @brief Constructor.
   *
   * @internal
   */
  SignDocDocumentHandler ()
    : p (NULL)
  {
  }

  /**
   * @brief Destructor.
   *
   * @internal
   */
  virtual ~SignDocDocumentHandler ()
  {
    SIGNDOC_DocumentHandler_delete (p);
  }

private:
  /**
   * @brief Copy Constructor (unavailable).
   */
  SignDocDocumentHandler (const SignDocDocumentHandler &);

public:
  /**
   * @brief Internal function.
   * @internal
   */
  SignDocDocumentHandler (SIGNDOC_DocumentHandler *aP) : p (aP) { }

  /**
   * @brief Internal function.
   * @internal
   */
  SIGNDOC_DocumentHandler *getImpl () { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  const SIGNDOC_DocumentHandler *getImpl () const { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  void destroyWithoutImpl () { p = NULL; delete this; }

  /**
   * @brief Internal function.
   * @internal
   */
  void setImpl (SIGNDOC_DocumentHandler *aP) { SIGNDOC_DocumentHandler_delete (p); p  = aP; }

protected:
  SIGNDOC_DocumentHandler *p;
};

/**
 * @brief Create SignDocDocument objects.
 *
 * As the error message is stored in this object, each thread should
 * have its own instance of SignDocDocumentLoader or synchronization
 * should be used.
 *
 * Unless you need differently configured SignDocDocumentLoader
 * objects, you should have only one SignDocDocumentLoader object per
 * process (but see above). Loading font configuration files can be
 * expensive, in particular if many fonts have to be scanned.

 * To be able to load documents, you have to register at least one
 * document handler by passing a pointer to a SignDocDocumentHandler object to
 * registerDocumentHandler().
 */
class SignDocDocumentLoader 
{
public:
  /**
   * @brief Specify which expiry date shall be used by getRemainingDays().
   */
  enum RemainingDays
  {
    /**
     * @brief Use the expiry date for the product.
     */
    rd_product,

    /**
     * @brief Use the expiry date for signing documents.
     */
    rd_signing
  };

public:
  /**
   * @brief Constructor.
   */
  SignDocDocumentLoader ()
    : p (NULL)
  {
    SIGNDOC_Exception *ex = NULL;
    p = SIGNDOC_DocumentLoader_new (&ex);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Destructor.
   */
  ~SignDocDocumentLoader ()
  {
    SIGNDOC_DocumentLoader_delete (p);
  }

  /**
   * @brief Initialize license management.
   *
   * License management must be initialized before the non-static
   * methods of SignDocDocumentLoader can be used.
   *
   * @deprecated Usage of license files is deprecated, please
   *             use a license key, see setLicenseKey().
   *
   * @param[in] aWho1   The first magic number for the product.
   * @param[in] aWho2   The second magic number for the product.
   *
   * @return true if successful, false on error.
   *
   * @see setLicenseKey()
   */
  static bool initLicenseManager (int aWho1, int aWho2)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_DocumentLoader_initLicenseManager (&ex, aWho1, aWho2);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Initialize license management with license key.
   *
   * License management must be initialized before the non-static
   * methods of SignDocDocumentLoader can be used.
   *
   * @param[in] aKeyPtr      Pointer to the first character of the license key.
   * @param[in] aKeySize     Size in octets of the license key, not including
   *                         any terminating NUL character.
   * @param[in] aProduct     Should be NULL.
   * @param[in] aVersion     Should be NULL.
   * @param[in] aTokenPtr    NULL or pointer to the first octet of the token.
   *                         Should be NULL.
   * @param[in] aTokenSize   Size in octets of the token. Should be 0.
   *
   * @return true if successful, false on error.
   *
   * @see generateLicenseToken(), initLicenseManager()
   */
  static bool setLicenseKey (const void *aKeyPtr, size_t aKeySize,
                             const char *aProduct, const char *aVersion,
                             const void *aTokenPtr, size_t aTokenSize)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_DocumentLoader_setLicenseKey (&ex, aKeyPtr, aKeySize, aProduct, aVersion, aTokenPtr, aTokenSize);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Generate a license token for other SDKs also covered
   *        by the license key passed to setLicenseKey().
   *
   * @param[in] aProduct   The name of the product which shall be able to use
   *                       the license key without providing a product version.
   * @param[out] aOutput   The token will be stored here.
   *
   * @return true if successful, false on error.
   *
   * @see setLicenseKey()
   */
  static bool generateLicenseToken (const char *aProduct,
                                    std::vector<unsigned char> &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_ByteArray *tempOutput = NULL;
    bool r;
    try
      {
        tempOutput = SIGNDOC_ByteArray_new (&ex);
        if (ex != NULL) SignDoc_throw (ex);
        r = (bool)SIGNDOC_DocumentLoader_generateLicenseToken (&ex, aProduct, tempOutput);
        assignArray (aOutput, tempOutput);
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_ByteArray_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_ByteArray_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the number of days until the license will expire.
   *
   * @param[in]  aWhat  Select which expiry date shall be used
   *                    (rd_product or rd_signing).
   *
   * @return -1 if the license has already expired or is invalid,
   *         0 if the license will expire today,
   *         a positive value for the number of days the license is
   *         still valid. For licenses without expiry date, that
   *         will be several millions of days.
   */
  static int getRemainingDays (RemainingDays aWhat)
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_DocumentLoader_getRemainingDays (&ex, aWhat);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the installation code needed for creating a license file.
   *
   * @param[out] aCode  The installation code will be stored here.
   *                    Only ASCII characters are used.
   *
   * @return true if successful, false on error.
   */
  static bool getInstallationCode (std::string &aCode)
  {
    SIGNDOC_Exception *ex = NULL;
    char *tempCode = NULL;
    bool r;
    try
      {
        r = (bool)SIGNDOC_DocumentLoader_getInstallationCode (&ex, &tempCode);
        if (tempCode != NULL)
          aCode = tempCode;
      }
    catch (...)
      {
        SIGNDOC_free (tempCode);
        throw;
      }
    SIGNDOC_free (tempCode);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the version number of SignDocShared or SignDoc SDK.
   *
   * @param[out] aVersion  The version number will be stored here.
   *                       It consists of 3 integers separated by
   *                       dots, .e.g.,  "1.16.7"
   *
   * @return true if successful, false on error.
   *
   * @see getComponentVersionNumber()
   */
  static bool getVersionNumber (std::string &aVersion)
  {
    SIGNDOC_Exception *ex = NULL;
    char *tempVersion = NULL;
    bool r;
    try
      {
        r = (bool)SIGNDOC_DocumentLoader_getVersionNumber (&ex, &tempVersion);
        if (tempVersion != NULL)
          aVersion = tempVersion;
      }
    catch (...)
      {
        SIGNDOC_free (tempVersion);
        throw;
      }
    SIGNDOC_free (tempVersion);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the version number of a SignDoc SDK component.
   *
   * @param[in]  aComponent  The component. Currently supported are
   *                         "sppdf", "splm2", and "spooc".
   * @param[out] aVersion  The version number will be stored here.
   *                       It consists of 3 or 4 integers separated by
   *                       dots, .e.g.,  "1.9.27".
   *
   * @return true if successful, false on error.
   *
   * @see getVersionNumber()
   */
  static bool getComponentVersionNumber (const char *aComponent,
                                         std::string &aVersion)
  {
    SIGNDOC_Exception *ex = NULL;
    char *tempVersion = NULL;
    bool r;
    try
      {
        r = (bool)SIGNDOC_DocumentLoader_getComponentVersionNumber (&ex, aComponent, &tempVersion);
        if (tempVersion != NULL)
          aVersion = tempVersion;
      }
    catch (...)
      {
        SIGNDOC_free (tempVersion);
        throw;
      }
    SIGNDOC_free (tempVersion);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the number of license texts.
   *
   * SignDocSDK includes several Open Source components. You can retrieve
   * the license texts one by one.
   *
   * @return The number of license texts.
   *
   * @see getLicenseText()
   */
  static int getLicenseTextCount ()
  {
    SIGNDOC_Exception *ex = NULL;
    int r;
    r = SIGNDOC_DocumentLoader_getLicenseTextCount (&ex);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get a license text.
   *
   * SignDocSDK includes several Open Source components. You can retrieve
   * the license texts one by one.
   *
   * @param[in] aIndex  The zero-based index of the license text.
   *
   * @return A pointer to the null-terminated license text. Lines are
   *         terminated by LF characters.  If @a aIndex is invalid,
   *         NULL will be returned.
   *
   * @see getLicenseTextCount()
   */
  static const char *getLicenseText (int aIndex)
  {
    SIGNDOC_Exception *ex = NULL;
    const char *r;
    r = SIGNDOC_DocumentLoader_getLicenseText (&ex, aIndex);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Load a document from memory.
   *
   * @param[in] aData  Pointer to the first octet of the document.
   *                   This array of octets must live at least as long
   *                   as the returned object unless @a aCopy is true.
   * @param[in] aCopy  true to make a copy of the array of octets
   *                   pointed to by @a aData.
   * @param[in] aSize  Size of the document (number of octets).
   *
   * @return A pointer to a new SignDocDocument object representing the
   *         document, NULL if the document could not be loaded.
   *         The caller is responsible for destroying the object.
   *
   * @see getErrorMessage(), loadFromFile()
   */
  SignDocDocument *loadFromMemory (const unsigned char *aData, size_t aSize,
                                   bool aCopy)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Document *r;
    r = SIGNDOC_DocumentLoader_loadFromMemory (&ex, p, aData, aSize, aCopy);
    if (ex != NULL) SignDoc_throw (ex);
    if (r == NULL)
      return NULL;
    try
      {
        return new SignDocDocument (r);
      }
    catch (...)
      {
        SIGNDOC_Document_delete (r);
        throw;
      }
  }

  /**
   * @brief Load a document from a file.
   *
   * Signing the document will overwrite the document, but see
   * integer parameter "Optimize" of SignDocSignatureParameters.
   *
   * @param[in] aEncoding  The encoding of the string pointed to
   *                        by @a aPath.
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
   * @see getErrorMessage(), loadFromMemory(), SignDocSignatureParameters::setInteger()
   */
  SignDocDocument *loadFromFile (Encoding aEncoding, const char *aPath,
                                 bool aWritable)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Document *r;
    r = SIGNDOC_DocumentLoader_loadFromFile (&ex, p, aEncoding, aPath, aWritable);
    if (ex != NULL) SignDoc_throw (ex);
    if (r == NULL)
      return NULL;
    try
      {
        return new SignDocDocument (r);
      }
    catch (...)
      {
        SIGNDOC_Document_delete (r);
        throw;
      }
  }

  /**
   * @brief Load a document from a file.
   *
   * Signing the document will overwrite the document, but see
   * integer parameter "Optimize" of SignDocSignatureParameters.
   *
   * @param[in] aPath       Pathname of the document file.
   * @param[in]  aWritable  Open for writing (used for signing TIFF
   *                        documents in place, ignored for PDF documents).
   *
   * @return A pointer to a new SignDocDocument object representing the
   *         document, NULL if the document could not be loaded.
   *         The caller is responsible for destroying the object.
   *
   * @see getErrorMessage(), loadFromMemory(), SignDocSignatureParameters::setInteger()
   */
  SignDocDocument *loadFromFile (const wchar_t *aPath, bool aWritable)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Document *r;
    r = SIGNDOC_DocumentLoader_loadFromFileW (&ex, p, aPath, aWritable);
    if (ex != NULL) SignDoc_throw (ex);
    if (r == NULL)
      return NULL;
    try
      {
        return new SignDocDocument (r);
      }
    catch (...)
      {
        SIGNDOC_Document_delete (r);
        throw;
      }
  }

  /**
   * @brief Create an empty PDF document.
   *
   * The PDF document is invalid until you add at least one page.
   *
   * @param[in] aMajor  Major PDF version, must be 1.
   * @param[in] aMinor  Minor PDF version, must be 0 through 7.
   *
   * @return A pointer to a new SignDocDocument object representing the
   *         document, NULL if the document could not be created.
   *         The caller is responsible for destroying the object.
   *
   * @see getErrorMessage()
   */
  SignDocDocument *createPDF (int aMajor, int aMinor)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Document *r;
    r = SIGNDOC_DocumentLoader_createPDF (&ex, p, aMajor, aMinor);
    if (ex != NULL) SignDoc_throw (ex);
    if (r == NULL)
      return NULL;
    try
      {
        return new SignDocDocument (r);
      }
    catch (...)
      {
        SIGNDOC_Document_delete (r);
        throw;
      }
  }

  /**
   * @brief Determine the type of a document.
   *
   * @param[in] aStream  A seekable stream for the document.
   *
   * @return The type of the document, dt_unknown on error.
   *
   * @see getErrorMessage()
   */
  SignDocDocument::DocumentType ping (InputStream &aStream)
  {
    SIGNDOC_Exception *ex = NULL;
    SignDocDocument::DocumentType r;
    r = (SignDocDocument::DocumentType)SIGNDOC_DocumentLoader_ping (&ex, p, aStream.getImpl ());
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   * by this object.
   *
   * @param[in] aEncoding  The encoding of the string pointed to
   *                        by @a aPath.
   * @param[in] aPath  The pathname of the file.
   *                   See @ref winrt_store for restrictions on pathnames
   *                   in Windows Store apps.
   *
   * @return true if successful, false on error.
   *
   * @see getFailedFontFiles(), loadFontConfigEnvironment(), loadFontConfigStream()
   */
  bool loadFontConfigFile (Encoding aEncoding, const char *aPath)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_DocumentLoader_loadFontConfigFile (&ex, p, aEncoding, aPath);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   * by this object.
   *
   * @param[in] aPath  The pathname of the file.
   *
   * @return true if successful, false on error.
   *
   * @see getFailedFontFiles(), loadFontConfigEnvironment(), loadFontConfigStream()
   */
  bool loadFontConfigFile (const wchar_t *aPath)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_DocumentLoader_loadFontConfigFileW (&ex, p, aPath);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   * by this object.
   *
   * @param[in] aName  The name of the environment variable.
   *
   * @return true if successful, false on error.
   *
   * @see getFailedFontFiles(), loadFontConfigFile(), loadFontConfigStream()
   */
  bool loadFontConfigEnvironment (const char *aName)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_DocumentLoader_loadFontConfigEnvironment (&ex, p, aName);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   * by this object.
   *
   * @param[in] aStream    The font configuration will be read from this stream.
   *                       This function reads the input completely, it doesn't
   *                       stop at the end tag.
   * @param[in] aEncoding  The encoding of the string pointed to
   *                       by @a aDirectory.
   * @param[in] aDirectory  If non-NULL, relative font pathnames will be
   *                        relative to this directory. The directory must
   *                        exist and must be readable. If NULL, relative
   *                        font pathnames will make this function fail.
   *                        See @ref winrt_store for restrictions on pathnames
   *                        in Windows Store apps.
   *
   * @return true if successful, false on error.
   *
   * @see getFailedFontFiles(), loadFontConfigEnvironment(), loadFontConfigFile()
   */
  bool loadFontConfigStream (InputStream &aStream, Encoding aEncoding,
                             const char *aDirectory)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_DocumentLoader_loadFontConfigStream (&ex, p, aStream.getImpl (), aEncoding, aDirectory);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   * by this object.
   *
   * @param[in] aStream  The font configuration will be read from this stream.
   *                     This function reads the input completely, it doesn't
   *                     stop at the end tag.
   * @param[in] aDirectory  If non-NULL, relative font pathnames will be
   *                        relative to this directory. The directory must
   *                        exist and must be readable. If NULL, relative
   *                        font pathnames will make this function fail.
   *
   * @return true if successful, false on error.
   *
   * @see getFailedFontFiles(), loadFontConfigEnvironment(), loadFontConfigFile()
   */
  bool loadFontConfigStream (InputStream &aStream, const wchar_t *aDirectory)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_DocumentLoader_loadFontConfigStreamW (&ex, p, aStream.getImpl (), aDirectory);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   * SignDocDocumentLoader object they have been created.
   *
   * @param[in] aEncoding  The encoding of the string pointed to
   *                        by @a aPath.
   * @param[in] aPath  The pathname of the file.
   *                   See @ref winrt_store for restrictions on pathnames
   *                   in Windows Store apps.
   *
   * @return true if successful, false on error.
   *
   * @see getFailedFontFiles(), loadPdfFontConfigEnvironment(), loadPdfFontConfigStream()
   */
  bool loadPdfFontConfigFile (Encoding aEncoding, const char *aPath)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_DocumentLoader_loadPdfFontConfigFile (&ex, p, aEncoding, aPath);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   * SignDocDocumentLoader object they have been created.
   *
   * @param[in] aPath  The pathname of the file.
   *
   * @return true if successful, false on error.
   *
   * @see getFailedFontFiles(), loadPdfFontConfigEnvironment(), loadPdfFontConfigStream()
   */
  bool loadPdfFontConfigFile (const wchar_t *aPath)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_DocumentLoader_loadPdfFontConfigFileW (&ex, p, aPath);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   * SignDocDocumentLoader object they have been created.
   *
   * Under Windows, directories are separated by semicolons. Under Unix,
   * directories are separated by colons.
   *
   * See section @ref signdocshared_fontconfig.
   * The "embed" attribute is ignored, substitutions with type="forced"
   * are applied before those with type="fallback".
   *
   * @param[in] aName  The name of the environment variable.
   *
   * @return true if successful, false on error.
   *
   * @see getFailedFontFiles(), loadPdfFontConfigFile(), loadPdfFontConfigStream()
   */
  bool loadPdfFontConfigEnvironment (const char *aName)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_DocumentLoader_loadPdfFontConfigEnvironment (&ex, p, aName);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   * SignDocDocumentLoader object they have been created.
   *
   * @param[in] aStream    The font configuration will be read from this stream.
   *                       This function reads the input completely, it doesn't
   *                       stop at the end tag.
   * @param[in] aEncoding  The encoding of the string pointed to
   *                       by @a aDirectory.
   * @param[in] aDirectory  If non-NULL, relative font pathnames will be
   *                        relative to this directory. The directory must
   *                        exist and must be readable. If NULL, relative
   *                        font pathnames will make this function fail.
   *                        See @ref winrt_store for restrictions on pathnames
   *                        in Windows Store apps.
   *
   * @return true if successful, false on error.
   *
   * @see getFailedFontFiles(), loadPdfFontConfigEnvironment(), loadPdfFontConfigFile()
   */
  bool loadPdfFontConfigStream (InputStream &aStream, Encoding aEncoding,
                                const char *aDirectory)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_DocumentLoader_loadPdfFontConfigStream (&ex, p, aStream.getImpl (), aEncoding, aDirectory);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   * SignDocDocumentLoader object they have been created.
   *
   * @param[in] aStream  The font configuration will be read from this stream.
   *                     This function reads the input completely, it doesn't
   *                     stop at the end tag.
   * @param[in] aDirectory  If non-NULL, relative font pathnames will be
   *                        relative to this directory. The directory must
   *                        exist and must be readable. If NULL, relative
   *                        font pathnames will make this function fail.
   *
   * @return true if successful, false on error.
   *
   * @see getFailedFontFiles(), loadPdfFontConfigEnvironment(), loadPdfFontConfigFile()
   */
  bool loadPdfFontConfigStream (InputStream &aStream,
                                const wchar_t *aDirectory)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_DocumentLoader_loadPdfFontConfigStreamW (&ex, p, aStream.getImpl (), aDirectory);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the pathnames of font files that failed to load for
   *        the most recent loadFontConfig*() or loadPdfFontConfig*()
   *        call.
   *
   * This includes files that could not be found and files that could
   * not be loaded. In the former case, the pathname may contain
   * wildcard characters.
   *
   * Note that loadFontConfig*() and loadPdfFontConfig() no longer
   * fail if a specified font file cannot be found or loaded.
   *
   * @param[out] aOutput  The pathnames will be stored here.
   *
   * @see loadFontConfigEnvironment(), loadFontConfigFile(), loadFontConfigStream(), loadPdfFontConfigEnvironment(), loadPdfFontConfigFile(), loadPdfFontConfigStream()
   */
  void getFailedFontFiles (std::vector<std::string> &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_StringArray *tempOutput = NULL;
    try
      {
        tempOutput = SIGNDOC_StringArray_new (&ex);
        if (ex != NULL) SignDoc_throw (ex);
        SIGNDOC_DocumentLoader_getFailedFontFiles (&ex, p, tempOutput);
        assignArray (aOutput, tempOutput);
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_StringArray_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_StringArray_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
  }

  /**
   * @brief Initialize logging.
   *
   * This function initializes logging for all threads of the current
   * process. This function is non-static to enable getErrorMessage();
   * the logging configuration is not restricted to this
   * SignDocDocumentLoader object.
   *
   * @param[in] aEncoding  The encoding of the string pointed to
   *                       by @a aPathname.
   * @param[in] aLevel     The logging level: "0" (log nothing) through
   *                       "5" (log everything), optionally followed by "T"
   *                       to log process and thread IDs.
   * @param[in] aPathname  The pathname of the log file.
   *                       See @ref winrt_store for restrictions on pathnames
   *                       in Windows Store apps.
   *
   * @return true iff successful.
   *
   * @see getErrorMessage()
   */
  bool initLogging (Encoding aEncoding, const char *aLevel,
                    const char *aPathname)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_DocumentLoader_initLogging (&ex, p, aEncoding, aLevel, aPathname);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get an error message for the last load*(), ping(), or
   *        initLogging() call.
   *
   * @param[in] aEncoding  The encoding to be used for the error message.
   *
   * @return A pointer to a string describing the reason for the
   *         failure of the last call of load*() or ping(). The string is empty
   *         if the last call succeeded. The pointer is valid until
   *         this object is destroyed or a member function of this
   *         object is called.
   *
   * @see getErrorMessageW(), loadFontConfigEnvironment(), loadFontConfigFile(), loadFontConfigStream(), loadFontConfigStream(), loadFromFile(), loadFromMemory(), loadPdfFontConfigEnvironment(), loadPdfFontConfigFile(), loadPdfFontConfigStream(), ping()
   */
  const char *getErrorMessage (Encoding aEncoding) const
  {
    SIGNDOC_Exception *ex = NULL;
    const char *r;
    r = SIGNDOC_DocumentLoader_getErrorMessage (&ex, p, aEncoding);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get an error message for the last load*(), ping(), or
   *        initLogging() call.
   *
   * @return A pointer to a string describing the reason for the
   *         failure of the last call of load*() or ping(). The string is empty
   *         if the last call succeeded. The pointer is valid until
   *         this object is destroyed or a member function of this
   *         object is called.
   *
   * @see getErrorMessage(), loadFontConfigEnvironment(), loadFontConfigFile(), loadFontConfigStream(), loadFontConfigStream(), loadFromFile(), loadFromMemory(), loadPdfFontConfigEnvironment(), loadPdfFontConfigFile(), loadPdfFontConfigStream(), ping()
   */
  const wchar_t *getErrorMessageW () const
  {
    SIGNDOC_Exception *ex = NULL;
    const wchar_t *r;
    r = SIGNDOC_DocumentLoader_getErrorMessageW (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Register a document handler.
   *
   * The behavior is undefined if multiple handlers for the same
   * document type are registered.
   *
   * @param[in] aHandler  An instance of a document handler. This object
   *                      takes ownerswhip of the object.
   *
   * @return true iff successful.
   */
  bool registerDocumentHandler (SignDocDocumentHandler *aHandler)
  {
    SIGNDOC_Exception *ex = NULL;
    bool r;
    r = (bool)SIGNDOC_DocumentLoader_registerDocumentHandler (&ex, p, aHandler->getImpl ());
    if (ex == NULL) aHandler->destroyWithoutImpl ();
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

private:
  /**
   * @brief Copy Constructor (unavailable).
   */
  SignDocDocumentLoader (const SignDocDocumentLoader &);

  /**
   * @brief Assignment operator (unavailable).
   */
  SignDocDocumentLoader &operator= (const SignDocDocumentLoader &);

private:
public:
  /**
   * @brief Internal function.
   * @internal
   */
  SignDocDocumentLoader (SIGNDOC_DocumentLoader *aP) : p (aP) { }

  /**
   * @brief Internal function.
   * @internal
   */
  SIGNDOC_DocumentLoader *getImpl () { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  const SIGNDOC_DocumentLoader *getImpl () const { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  void setImpl (SIGNDOC_DocumentLoader *aP) { SIGNDOC_DocumentLoader_delete (p); p  = aP; }

private:
  SIGNDOC_DocumentLoader *p;
};

/**
 * @brief Information about a signature field returned by
 * SignDocDocument::verifySignature().
 */
class SignDocVerificationResult 
{
public:
  /**
   * @brief Return codes.
   *
   * Do not forget to update de/softpro/doc/SignDocException.java!
   */
  enum ReturnCode
  {
    rc_ok = SignDocDocument::rc_ok, ///< No error
    rc_invalid_argument = SignDocDocument::rc_invalid_argument, ///< Invalid argument
    rc_not_supported = SignDocDocument::rc_not_supported, ///< Operation not supported
    rc_not_verified = SignDocDocument::rc_not_verified, ///< SignDocDocument::verifySignature() has not been called
    rc_no_biometric_data = SignDocDocument::rc_no_biometric_data, ///< No biometric data (or hash) available
    rc_unexpected_error = SignDocDocument::rc_unexpected_error ///< Unexpected error
  };

  /**
   * @brief State of a signature.
   */
  enum SignatureState
  {
    ss_unmodified,            ///< No error, signature and document verified.
    ss_document_extended,     ///< No error, signature and document verified, document modified by adding data to the signed document.
    ss_document_modified,     ///< Document modified (possibly forged).
    ss_unsupported_signature, ///< Unsupported signature method.
    ss_invalid_certificate,   ///< Invalid certificate.
    ss_empty                  ///< Signature field without signature.
  };

  /**
   * @brief State of the RFC 3161 time stamp.
   */
  enum TimeStampState
  {
    tss_valid,                ///< No error, an RFC 3161 time stamp is present and valid (but you have to check the certificate chain and revocation).
    tss_missing,              ///< There is no RFC 3161 time stamp.
    tss_invalid               ///< An RFC 3161 time stamp is present but invalid.
  };

  /**
   * @brief Policy for verification of the certificate chain.
   *
   * @see verifyCertificateSimplified(), verifyTimeStampCertificateSimplified()
   */
  enum CertificateChainVerificationPolicy
  {
    /**
     * @brief Don't verify the certificate chain.
     *
     * Always pretend that the certificate chain is OK.
     */
    ccvp_dont_verify,

    /**
     * @brief Accept self-signed certificates.
     *
     * If the signing certificate is not self-signed, it must chain up
     * to a trusted root certificate.
     */
    ccvp_accept_self_signed,

    /**
     * @brief Accept self-signed certificates if biometric data is present.
     *
     * If the signing certificate is not self-signed or if there is no
     * biometric data, the certificate must chain up to a trusted root
     * certificate.
     */
    ccvp_accept_self_signed_with_bio,

    /**
     * @brief Accept self-signed certificates if asymmetrically encrypted
     *        biometric data is present.
     *
     * If the signing certificate is not self-signed or if there is no
     * biometric data or if the biometric data is not encrypted with
     * RSA, the certificate must chain up to a trusted root
     * certificate.
     */
    ccvp_accept_self_signed_with_rsa_bio,

    /**
     * @brief Require a trusted root certificate.
     *
     * The signing certificate must chain up to a trusted root
     * certificate.
     */
    ccvp_require_trusted_root
  };

  /**
   * @brief Policy for verification of certificate revocation.
   *
   * @see verifyCertificateSimplified(), verifyTimeStampCertificateSimplified()
   */
  enum CertificateRevocationVerificationPolicy
  {
    /**
     * @brief Don't verify revocation of certificates.
     *
     * Always pretend that certificates have not been revoked.
     */
    crvp_dont_check,

    /**
     * @brief Check revocation, assume that certificates are not revoked
     *        if the revocation server is offline.
     */
    crvp_offline,

    /**
     * @brief Check revocation, assume that certificates are revoked
     *        if the revocation server is offline.
     */
    crvp_online
  };

  /**
   * @brief Certificate verification model.
   *
   * @see verifyCertificateRevocation(), verifyCertificateSimplified(), verifyTimeStampCertificateChain(), verifyTimeStampCertificateRevocation(), verifyTimeStampCertificateSimplified()
   */
  enum VerificationModel
  {
    /**
     * @brief Whatever the Windows Crypto API or OpenSSL implements.
     */
    vm_default,

    /**
     * @brief As specfified by German law.
     *
     * @todo implement this
     * @todo name that law
     */
    vm_german_sig_law
  };

  /**
   * @brief Certificate chain state for verifyCertificateChain()
   *        and verifyTimeStampCertificateChain().
   */
  enum CertificateChainState
  {
    ccs_ok,                   ///< Chain OK
    ccs_broken_chain,         ///< Chain broken
    ccs_untrusted_root,       ///< Untrusted root certificate
    ccs_critical_extension,   ///< A certificate has an unknown critical extension
    ccs_not_time_valid,       ///< A certificate is not yet valid or is expired
    ccs_path_length,          ///< Path length constraint not satisfied
    ccs_invalid,              ///< Invalid certificate or chain
    ccs_error                 ///< Other error
  };

  /**
   * @brief Certificate revocation state for verifyCertificateRevocation()
   *        and verifyTimeStampCertificateRevocation().
   */
  enum CertificateRevocationState
  {
    crs_ok,                     ///< No certificate revoked
    crs_not_checked,            ///< Revocation not checked
    crs_offline,                ///< Revocation server is offline
    crs_revoked,                ///< At least one certificate has been revoked
    crs_error                   ///< Error
  };

public:
  /**
   * @brief Constructor.
   */
  SignDocVerificationResult ()
    : p (NULL)
  {
  }

  /**
   * @brief Destructor.
   */
  ~SignDocVerificationResult ()
  {
    SIGNDOC_VerificationResult_delete (p);
  }

  /**
   * @brief Get the signature state.
   *
   * If the state is ss_unsupported_signature or
   * ss_invalid_certificate, getErrorMessage() will provide additional
   * information.
   *
   * @param[out]  aOutput  The signature state.
   *
   * @return rc_ok if successful.
   *
   * @see getErrorMessage(), SignDocDocument::verifySignature()
   */
  ReturnCode getState (SignatureState &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    int tempOutput = 0;
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_VerificationResult_getState (&ex, p, &tempOutput);
        aOutput = (SignatureState )tempOutput;
      }
    catch (...)
      {
        throw;
      }
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the signing method.
   *
   * @param[out]  aOutput  The signing method.
   *
   * @return rc_ok if successful, rc_not_verified if verification has failed.
   */
  ReturnCode getMethod (SignDocSignatureParameters::Method &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    int tempOutput = 0;
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_VerificationResult_getMethod (&ex, p, &tempOutput);
        aOutput = (SignDocSignatureParameters::Method )tempOutput;
      }
    catch (...)
      {
        throw;
      }
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the message digest algorithm of the signature.
   *
   * @param[out]  aOutput  The message digest algorithm (such as "SHA-1")
   *                       will be stored here.  If the message digest
   *                       algorithm is unsupported, an empty string will
   *                       be stored.
   *
   * @return rc_ok if successful, rc_not_verified if verification has failed.
   */
  ReturnCode getDigestAlgorithm (std::string &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    char *tempOutput = NULL;
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_VerificationResult_getDigestAlgorithm (&ex, p, &tempOutput);
        if (tempOutput != NULL)
          aOutput = tempOutput;
      }
    catch (...)
      {
        SIGNDOC_free (tempOutput);
        throw;
      }
    SIGNDOC_free (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the certificates of the signature.
   *
   * @param[out]  aOutput  The ASN.1-encoded X.509 certificates will be
   *                       stored here.  If there are multiple certificates,
   *                       the first one (at index 0) is the signing
   *                       certificate.
   *
   * @return rc_ok if successful, rc_not_verified if verification has failed.
   */
  ReturnCode getCertificates (std::vector<std::vector<unsigned char> > &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_ByteArrayArray *tempOutput = NULL;
    ReturnCode r;
    try
      {
        tempOutput = SIGNDOC_ByteArrayArray_new (&ex);
        if (ex != NULL) SignDoc_throw (ex);
        r = (ReturnCode)SIGNDOC_VerificationResult_getCertificates (&ex, p, tempOutput);
        assignArray (aOutput, tempOutput);
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_ByteArrayArray_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_ByteArrayArray_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Verify the certificate chain of the signature's certificate.
   *
   * Currently, this function supports PKCS #7 signatures only.
   * getErrorMessage() will return an error message if this function
   * fails (return value not rc_ok) or the verification result returned
   * in @a aOutput is not ccs_ok.
   *
   * @param[in]   aModel   Model to be used for verification.
   * @param[out]  aOutput  The result of the certificate chain verification.
   *
   * @return rc_ok if successful, rc_not_verified if verification has failed.
   *
   * @see getCertificateChainLength(), verifyCertificateRevocation(), verifyCertificateSimplified()
   *
   * @todo support vm_german_sig_law for @a aModel
   */
  ReturnCode verifyCertificateChain (VerificationModel aModel,
                                     CertificateChainState &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    int tempOutput = 0;
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_VerificationResult_verifyCertificateChain (&ex, p, aModel, &tempOutput);
        aOutput = (CertificateChainState )tempOutput;
      }
    catch (...)
      {
        throw;
      }
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Check the revocation status of the certificate chain of the
   *        signature's certificate.
   *
   * verifyCertificateChain() or verifyCertificateSimplified() must
   * have been called successfully.
   *
   * Currently, this function supports PKCS #7 signatures only.
   * getErrorMessage() will return an error message if this function
   * fails (return value not rc_ok) or the verification result returned
   * in @a aOutput is not crs_ok.
   *
   * @param[in]   aModel   Model to be used for verification.
   * @param[out]  aOutput  The result of the certificate revocation check.
   *
   * @return rc_ok if successful, rc_not_verified if verification has failed.
   *
   * @see getCertificateChainLength(), verifyCertificateChain(), verifyCertificateSimplified()
   *
   * @todo support vm_german_sig_law for @a aModel
   */
  ReturnCode verifyCertificateRevocation (VerificationModel aModel,
                                          CertificateRevocationState &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    int tempOutput = 0;
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_VerificationResult_verifyCertificateRevocation (&ex, p, aModel, &tempOutput);
        aOutput = (CertificateRevocationState )tempOutput;
      }
    catch (...)
      {
        throw;
      }
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Simplified verification of the certificate chain and revocation
   *        status of the signature's certificate.
   *
   * This function just returns a good / not good value according to
   * policies defined by the arguments. It does not tell the caller
   * what exactly is wrong. However, getErrorMessage() will return an
   * error message if this function fails. Do not attempt to base
   * decisions on that error message, please use verifyCertificateChain()
   * and verifyCertificateRevocation() instead of this function if
   * you need details about the failure.
   *
   * If @a aChainPolicy is ccvp_dont_verify, @a aRevocationPolicy must
   * be crvp_dont_check, otherwise this function will return
   * rc_invalid_argument.
   *
   * Currently, only self-signed certificates are supported for PKCS
   * #1, therefore ccvp_require_trusted_root always makes this
   * function fail for PKCS #1 signatures.  crvp_online and crvp_offline
   * also make this function fail for PKCS #1 signatures.
   *
   * @param[in] aChainPolicy       Policy for verification of the certificate
   *                               chain.
   * @param[in] aRevocationPolicy  Policy for verification of the revocation
   *                               status of the certificates.
   * @param[in] aModel             Model to be used for verification.
   *
   * @return rc_ok if successful, rc_not_verified if verification has failed,
   *         rc_invalid_argument if the arguments are invalid.
   *
   * @see getCertificateChainLength(), verifyCertificateChain(), verifyCertificateRevocation()
   *
   * @todo support vm_german_sig_law for @a aModel
   */
  ReturnCode verifyCertificateSimplified (CertificateChainVerificationPolicy aChainPolicy,
                                          CertificateRevocationVerificationPolicy aRevocationPolicy,
                                          VerificationModel aModel)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_VerificationResult_verifyCertificateSimplified (&ex, p, aChainPolicy, aRevocationPolicy, aModel);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the certificate chain length.
   *
   * verifyCertificateChain() or verifyCertificateSimplified() must
   * have been called successfully.
   *
   * Currently, this function supports PKCS #7 signatures only.
   *
   * @param[out]  aOutput  The chain length will be stored here if this
   *                       function is is successful.  If the signature was
   *                       performed with a self-signed certificate, the
   *                       chain length will be 1.
   *
   * @return rc_ok if successful, rc_not_verified if verification has failed.
   *
   * @see verifyCertificateChain(), verifyCertificateSimplified()
   */
  ReturnCode getCertificateChainLength (int &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_VerificationResult_getCertificateChainLength (&ex, p, &aOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

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
   *                       be stored in the PKCS #7 message, see getTimeStamp().
   * .
   *
   * @param[in]   aEncoding   The encoding to be used for @a aOutput.
   * @param[in]   aName    The name of the parameter.
   * @param[out]  aOutput  The string retrieved from the signature field.
   *
   * @return rc_ok if successful, rc_not_verified if verification has failed.
   *
   * @see getTimeStamp(), SignDocDocument::getLastTimestamp(), SignDocSignatureParameters::setString()
   *
   * @todo document which parameters are available for which methods
   */
  ReturnCode getSignatureString (Encoding aEncoding, const std::string &aName,
                                 std::string &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    char *tempOutput = NULL;
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_VerificationResult_getSignatureString (&ex, p, aEncoding, aName.c_str (), &tempOutput);
        if (tempOutput != NULL)
          aOutput = tempOutput;
      }
    catch (...)
      {
        SIGNDOC_free (tempOutput);
        throw;
      }
    SIGNDOC_free (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the biometric data of the field.
   *
   * Use getBiometricEncryption() to find out what parameters need to
   * be passed:
   * - be_rsa        Either @a aKeyPtr or @a aKeyPath must be non-NULL,
   *                 @a aPassphrase is required if the key file is encrypted
   * - be_fixed      @a aKeyPtr, @a aKeyPath, and @a aPassphrase must be NULL
   * - be_binary     @a aKeyPtr must be non-NULL, @a aKeySize must be 32,
   *                 @a aPassphrase must be NULL
   * - be_passphrase @a aKeyPtr must point to the passphrase (which should
   *                 contain ASCII characters only), @a aPassphrase
   *                 must be NULL
   * .
   * @note Don't forget to overwrite the biometric data in memory after use!
   *
   * @param[in]  aKeyPtr      Pointer to the first octet of the key (must
   *                          be NULL if @a aKeyPath is not NULL).
   * @param[in]  aKeySize     Size of the key pointed to by @a aKeyPtr (must
   *                          be 0 if @a aKeyPath is not NULL).
   * @param[in]  aKeyPath     Pathname of the file containing the key (must
   *                          be NULL if @a aKeyPtr is not NULL).
   *                          See @ref winrt_store for restrictions on
   *                          pathnames in Windows Store apps.
   * @param[in]  aPassphrase  Passphrase for decrypting the key contained in
   *                          the file named by @a aKeyPath.  If this argument
   *                          is NULL or points to the empty string, it will
   *                          be assumed that the key file is not protected
   *                          by a passphrase.  @a aPassphrase is used only
   *                          when reading the key from a file for
   *                          @ref SignDocSignatureParameters::be_rsa.
   *                          The passphrase must contain ASCII characters
   *                          only.
   * @param[out] aOutput      The decrypted biometric data will be stored here.
   *
   * @return rc_ok if successful, rc_no_biometric_data if no biometric
   *         data is availabable.
   *
   * @see checkBiometricHash(), getBiometricEncryption(), getEncryptedBiometricData()
   */
  ReturnCode getBiometricData (const unsigned char *aKeyPtr, size_t aKeySize,
                               const wchar_t *aKeyPath,
                               const char *aPassphrase,
                               std::vector<unsigned char> &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_ByteArray *tempOutput = NULL;
    ReturnCode r;
    try
      {
        tempOutput = SIGNDOC_ByteArray_new (&ex);
        if (ex != NULL) SignDoc_throw (ex);
        r = (ReturnCode)SIGNDOC_VerificationResult_getBiometricDataW (&ex, p, aKeyPtr, aKeySize, aKeyPath, aPassphrase, tempOutput);
        assignArray (aOutput, tempOutput);
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_ByteArray_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_ByteArray_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the biometric data of the field.
   *
   * Use getBiometricEncryption() to find out what parameters need to
   * be passed:
   * - be_rsa        Either @a aKeyPtr or @a aKeyPath must be non-NULL,
   *                 @a aPassphrase is required if the key file is encrypted
   * - be_fixed      @a aKeyPtr, @a aKeyPath, and @a aPassphrase must be NULL
   * - be_binary     @a aKeyPtr must be non-NULL, @a aKeySize must be 32,
   *                 @a aPassphrase must be NULL
   * - be_passphrase @a aKeyPtr must point to the passphrase (which should
   *                 contain ASCII characters only), @a aPassphrase
   *                 must be NULL
   * .
   * @note Don't forget to overwrite the biometric data in memory after use!
   *
   * @param[in]  aEncoding    The encoding of the string pointed to
   *                          by @a aKeyPath.
   * @param[in]  aKeyPtr      Pointer to the first octet of the key (must
   *                          be NULL if @a aKeyPath is not NULL).
   * @param[in]  aKeySize     Size of the key pointed to by @a aKeyPtr (must
   *                          be 0 if @a aKeyPath is not NULL).
   * @param[in]  aKeyPath     Pathname of the file containing the key (must
   *                          be NULL if @a aKeyPtr is not NULL).
   *                          See @ref winrt_store for restrictions on
   *                          pathnames in Windows Store apps.
   * @param[in]  aPassphrase  Passphrase for decrypting the key contained in
   *                          the file named by @a aKeyPath.  If this argument
   *                          is NULL or points to the empty string, it will
   *                          be assumed that the key file is not protected
   *                          by a passphrase.  @a aPassphrase is used only
   *                          when reading the key from a file for
   *                          @ref SignDocSignatureParameters::be_rsa.
   *                          The passphrase must contain ASCII characters
   *                          only.
   * @param[out] aOutput      The decrypted biometric data will be stored here.
   *
   * @return rc_ok if successful, rc_no_biometric_data if no biometric
   *         data is availabable.
   *
   * @see checkBiometricHash(), getBiometricEncryption(), getEncryptedBiometricData()
   */
  ReturnCode getBiometricData (Encoding aEncoding,
                               const unsigned char *aKeyPtr, size_t aKeySize,
                               const char *aKeyPath, const char *aPassphrase,
                               std::vector<unsigned char> &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_ByteArray *tempOutput = NULL;
    ReturnCode r;
    try
      {
        tempOutput = SIGNDOC_ByteArray_new (&ex);
        if (ex != NULL) SignDoc_throw (ex);
        r = (ReturnCode)SIGNDOC_VerificationResult_getBiometricData (&ex, p, aEncoding, aKeyPtr, aKeySize, aKeyPath, aPassphrase, tempOutput);
        assignArray (aOutput, tempOutput);
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_ByteArray_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_ByteArray_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the encrypted biometric data of the field.
   *
   * Use this function if you cannot use getBiometricData() for
   * decrypting the biometric data (for instance, because the private
   * key is stored in an HSM).
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
   * If the version number is 1, the encryption method is be_rsa with
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
   * - 4 octets: method (be_fixed, be_binary, be_passphrase)
   * - 32 octets: IV (only the first 16 bytes are used, please ignore the rest)
   * - 32 octets: SHA-256 hash of unencrypted biometric data
   * - rest: biometric data encrypted with AES-256 in CBC mode using
   *         padding as described in RFC 2246.
   * .
   *
   * If the version number is 3, the encryption method is be_rsa with
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
   * @param[out] aOutput      The decrypted biometric data will be stored here.
   *                          See above for the format.
   *
   * @return rc_ok if successful, rc_no_biometric_data if no biometric
   *         data is availabable.
   *
   * @see checkBiometricHash(), getBiometricData(), getBiometricEncryption()
   */
  ReturnCode getEncryptedBiometricData (std::vector<unsigned char> &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_ByteArray *tempOutput = NULL;
    ReturnCode r;
    try
      {
        tempOutput = SIGNDOC_ByteArray_new (&ex);
        if (ex != NULL) SignDoc_throw (ex);
        r = (ReturnCode)SIGNDOC_VerificationResult_getEncryptedBiometricData (&ex, p, tempOutput);
        assignArray (aOutput, tempOutput);
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_ByteArray_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_ByteArray_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the encryption method used for biometric data of the signature
   *        field.
   *
   * @param[out] aOutput     The encryption method.
   *
   * @return rc_ok if successful, rc_no_biometric_data if no biometric
   *         data is availabable.
   *
   * @see getBiometricData(), getEncryptedBiometricData()
   */
  ReturnCode getBiometricEncryption (SignDocSignatureParameters::BiometricEncryption &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    int tempOutput = 0;
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_VerificationResult_getBiometricEncryption (&ex, p, &tempOutput);
        aOutput = (SignDocSignatureParameters::BiometricEncryption )tempOutput;
      }
    catch (...)
      {
        throw;
      }
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Check the hash of the biometric data.
   *
   * @param[in]  aBioPtr        Pointer to unencrypted biometric data,
   *                            typically retrieved by getBiometricData().
   * @param[in]  aBioSize       Size of unencrypted biometric data in octets.
   * @param[out] aOutput        Result of the operation: true if the hash is
   *                            OK, false if the hash doesn't match (the
   *                            document has been tampered with).
   *
   * @return rc_ok if successful.
   *
   * @see getBiometricData(), getEncryptedBiometricData()
   */
  ReturnCode checkBiometricHash (const unsigned char *aBioPtr, size_t aBioSize,
                                 bool &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_Boolean tempOutput = 0;
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_VerificationResult_checkBiometricHash (&ex, p, aBioPtr, aBioSize, &tempOutput);
        aOutput = (bool )tempOutput;
      }
    catch (...)
      {
        throw;
      }
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the state of the RFC 3161 time stamp.
   *
   * @param[out]  aOutput  The state of the RFC 3161 time stamp.
   *
   * @return rc_ok if successful.
   */
  ReturnCode getTimeStampState (TimeStampState &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    int tempOutput = 0;
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_VerificationResult_getTimeStampState (&ex, p, &tempOutput);
        aOutput = (TimeStampState )tempOutput;
      }
    catch (...)
      {
        throw;
      }
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Verify the certificate chain of the RFC 3161 time stamp.
   *
   * getErrorMessage() will return an error message if this function
   * fails (return value not rc_ok) or the verification result returned
   * in @a aOutput is not ccs_ok.
   *
   * @param[in]   aModel   Model to be used for verification.
   * @param[out]  aOutput  The result of the certificate chain verification.
   *
   * @return rc_ok if successful, rc_not_verified if verification has failed.
   *
   * @see verifyTimeStampCertificateRevocation(), verifyTimeStampCertificateSimplified()
   *
   * @todo support vm_german_sig_law for @a aModel
   */
  ReturnCode verifyTimeStampCertificateChain (VerificationModel aModel,
                                              CertificateChainState &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    int tempOutput = 0;
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_VerificationResult_verifyTimeStampCertificateChain (&ex, p, aModel, &tempOutput);
        aOutput = (CertificateChainState )tempOutput;
      }
    catch (...)
      {
        throw;
      }
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Check the revocation status of the certificate chain of the
   *        RFC 3161 time stamp.
   *
   * getErrorMessage() will return an error message if this function
   * fails (return value not rc_ok) or the verification result returned
   * in @a aOutput is not crs_ok.
   *
   * @param[in]   aModel   Model to be used for verification.
   * @param[out]  aOutput  The result of the certificate revocation check.
   *
   * @return rc_ok if successful, rc_not_verified if verification has failed.
   *
   * @see verifyTimeStampCertificateChain(), verifyTimeStampCertificateSimplified()
   *
   * @todo support vm_german_sig_law for @a aModel
   */
  ReturnCode verifyTimeStampCertificateRevocation (VerificationModel aModel,
                                                   CertificateRevocationState &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    int tempOutput = 0;
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_VerificationResult_verifyTimeStampCertificateRevocation (&ex, p, aModel, &tempOutput);
        aOutput = (CertificateRevocationState )tempOutput;
      }
    catch (...)
      {
        throw;
      }
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Simplified verification of the certificate chain and revocation
   *        status of the RFC 3161 time stamp.
   *
   * This function just returns a good / not good value according to
   * policies defined by the arguments. It does not tell the caller
   * what exactly is wrong. However, getErrorMessage() will return an
   * error message if this function fails. Do not attempt to base
   * decisions on that error message, please use
   * verifyTimeStampCertificateChain() and
   * verifyTimeStampCertificateRevocation() instead of this function
   * if you need details about the failure.
   *
   * If @a aChainPolicy is ccvp_dont_verify, @a aRevocationPolicy must
   * be crvp_dont_check, otherwise this function will return
   * rc_invalid_argument.
   *
   * ccvp_accept_self_signed_with_bio and
   * ccvp_accept_self_signed_with_rsa_bio are treated like
   * ccvp_accept_self_signed.
   *
   * @param[in] aChainPolicy       Policy for verification of the certificate
   *                               chain.
   * @param[in] aRevocationPolicy  Policy for verification of the revocation
   *                               status of the certificates.
   * @param[in] aModel             Model to be used for verification.
   *
   * @return rc_ok if successful, rc_not_verified if verification has failed,
   *         rc_invalid_argument if the arguments are invalid,
   *         rc_not_supported if there is no RFC 3161 time stamp.
   *
   * @see verifyTimeStampCertificateChain(), verifyTimeStampCertificateRevocation()
   *
   * @todo support vm_german_sig_law for @a aModel
   */
  ReturnCode verifyTimeStampCertificateSimplified (CertificateChainVerificationPolicy aChainPolicy,
                                                   CertificateRevocationVerificationPolicy aRevocationPolicy,
                                                   VerificationModel aModel)
  {
    SIGNDOC_Exception *ex = NULL;
    ReturnCode r;
    r = (ReturnCode)SIGNDOC_VerificationResult_verifyTimeStampCertificateSimplified (&ex, p, aChainPolicy, aRevocationPolicy, aModel);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the value of the RFC 3161 time stamp.
   *
   * You must call verifyTimeStampCertificateChain() and
   * verifyTimeStampCertificateRevocation() to find out whether
   * the time stamp can be trusted.  If either of these functions
   * report a problem, the time stamp should not be displayed.
   *
   * A signature has either an RFC 3161 time stamp (returned by this
   * function) or a time stamp stored as string parameter (returned by
   * getSignatureString().
   *
   * @param[out]  aOutput  The RFC 3161 time stamp in ISO 8601
   *                       format: "yyyy-mm-ddThh:mm:ssZ"
   *                       (without milliseconds).
   *
   * @return rc_ok if successful.
   *
   * @see getSignatureString(), verifyTimeStampCertificateChain(), verifyTimeStampCertificateRevocation()
   */
  ReturnCode getTimeStamp (std::string &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    char *tempOutput = NULL;
    ReturnCode r;
    try
      {
        r = (ReturnCode)SIGNDOC_VerificationResult_getTimeStamp (&ex, p, &tempOutput);
        if (tempOutput != NULL)
          aOutput = tempOutput;
      }
    catch (...)
      {
        SIGNDOC_free (tempOutput);
        throw;
      }
    SIGNDOC_free (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get the certificates of the RFC 3161 time stamp.
   *
   * @param[out]  aOutput  The ASN.1-encoded X.509 certificates will be
   *                       stored here.  If there are multiple certificates,
   *                       the first one (at index 0) is the signing
   *                       certificate.
   *
   * @return rc_ok if successful, rc_not_verified if verification has failed.
   */
  ReturnCode getTimeStampCertificates (std::vector<std::vector<unsigned char> > &aOutput)
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_ByteArrayArray *tempOutput = NULL;
    ReturnCode r;
    try
      {
        tempOutput = SIGNDOC_ByteArrayArray_new (&ex);
        if (ex != NULL) SignDoc_throw (ex);
        r = (ReturnCode)SIGNDOC_VerificationResult_getTimeStampCertificates (&ex, p, tempOutput);
        assignArray (aOutput, tempOutput);
      }
    catch (...)
      {
        if (tempOutput != NULL)
          SIGNDOC_ByteArrayArray_delete (tempOutput);
        throw;
      }
    if (tempOutput != NULL)
      SIGNDOC_ByteArrayArray_delete (tempOutput);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get an error message for the last function call.
   *
   * @param[in] aEncoding  The encoding to be used for the error message.
   *
   * @return A pointer to a string describing the reason for the
   *         failure of the last function call. The string is empty
   *         if the last call succeeded. The pointer is valid until
   *         this object is destroyed or a member function of this
   *         object is called.
   *
   * @see getErrorMessageW()
   */
  const char *getErrorMessage (Encoding aEncoding) const
  {
    SIGNDOC_Exception *ex = NULL;
    const char *r;
    r = SIGNDOC_VerificationResult_getErrorMessage (&ex, p, aEncoding);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }

  /**
   * @brief Get an error message for the last function call.
   *
   * @return A pointer to a string describing the reason for the
   *         failure of the last function call. The string is empty
   *         if the last call succeeded. The pointer is valid until
   *         this object is destroyed or a member function of this
   *         object is called.
   *
   * @see getErrorMessage()
   */
  const wchar_t *getErrorMessageW () const
  {
    SIGNDOC_Exception *ex = NULL;
    const wchar_t *r;
    r = SIGNDOC_VerificationResult_getErrorMessageW (&ex, p);
    if (ex != NULL) SignDoc_throw (ex);
    return r;
  }
  /**
   * @brief Internal function.
   * @internal
   */
  SignDocVerificationResult (SIGNDOC_VerificationResult *aP) : p (aP) { }

  /**
   * @brief Internal function.
   * @internal
   */
  SIGNDOC_VerificationResult *getImpl () { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  const SIGNDOC_VerificationResult *getImpl () const { return p; }

  /**
   * @brief Internal function.
   * @internal
   */
  void setImpl (SIGNDOC_VerificationResult *aP) { SIGNDOC_VerificationResult_delete (p); p  = aP; }

private:
  SIGNDOC_VerificationResult *p;
};

/**
 * @brief SignDoc document handler for PDF documents.
 */
class SignDocPdfDocumentHandler : public SignDocDocumentHandler
{
public:

  /**
   * @brief Create a SignDocPdfDocumentHandler object.
   *
   * @return A pointer to a new SignDocPdfDocumentHandler object.
   */
  static SignDocDocumentHandler *create ()
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_DocumentHandler *r;
    r = SIGNDOC_PdfDocumentHandler_new (&ex);
    if (ex != NULL) SignDoc_throw (ex);
    if (r == NULL)
      return NULL;
    try
      {
        return new SignDocDocumentHandler (r);
      }
    catch (...)
      {
        SIGNDOC_DocumentHandler_delete (r);
        throw;
      }
  }

private:
  /**
   * @brief Internal function.
   * @internal
   */
  SignDocPdfDocumentHandler ();

  /**
   * @brief Internal function.
   * @internal
   */
  SignDocPdfDocumentHandler (const SIGNDOC_PdfDocumentHandler &);

  /**
   * @brief Internal function.
   * @internal
   */
  SignDocPdfDocumentHandler& operator= (const SIGNDOC_PdfDocumentHandler &);
};

/**
 * @brief SignDoc document handler for TIFF documents.
 */
class SignDocTiffDocumentHandler : public SignDocDocumentHandler
{
public:

  /**
   * @brief Create a SignDocTiffDocumentHandler object.
   *
   * @return A pointer to a new SignDocTiffDocumentHandler object.
   */
  static SignDocDocumentHandler *create ()
  {
    SIGNDOC_Exception *ex = NULL;
    SIGNDOC_DocumentHandler *r;
    r = SIGNDOC_TiffDocumentHandler_new (&ex);
    if (ex != NULL) SignDoc_throw (ex);
    if (r == NULL)
      return NULL;
    try
      {
        return new SignDocDocumentHandler (r);
      }
    catch (...)
      {
        SIGNDOC_DocumentHandler_delete (r);
        throw;
      }
  }

private:
  /**
   * @brief Internal function.
   * @internal
   */
  SignDocTiffDocumentHandler ();

  /**
   * @brief Internal function.
   * @internal
   */
  SignDocTiffDocumentHandler (const SIGNDOC_TiffDocumentHandler &);

  /**
   * @brief Internal function.
   * @internal
   */
  SignDocTiffDocumentHandler& operator= (const SIGNDOC_TiffDocumentHandler &);
};

inline SignDocVerificationResult *
makeSignDocVerificationResult (SIGNDOC_VerificationResult *aP)
{
  if (aP == NULL)
    return NULL;
  return new SignDocVerificationResult (aP);
}

#ifdef _MSC_VER
#pragma warning(pop)
#endif

}}}

#endif
