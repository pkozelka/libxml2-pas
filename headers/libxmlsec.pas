{This file generated automatically from xmlsec-api.xml}
{For libxmlsec version: 1.2.8}
Unit libxmlsec;

interface

{$ALIGN 8}
{$MINENUMSIZE 4}

uses libxml2, libxslt;

const
{$IFDEF WIN32}
   XMLSEC_SO = 'libxmlsec.dll';
{$ELSE}
   XMLSEC_SO = 'libxmlsec.so';
{$ENDIF}

type
      time_t = LongInt;
      xmlSecSize = Cardinal;
      xmlSecSizePtr = ^xmlSecSize;
      xmlSecByte = Byte;
      xmlSecBytePtr = ^xmlSecByte;
      xmlSecBytePtrPtr = ^xmlSecBytePtr;

      xmlEncCtxMode = (
          xmlEncCtxModeEncryptedData = 0,
          xmlEncCtxModeEncryptedKey = 1);

      xmlSecAllocMode = (
          xmlSecAllocModeExact = 0,
          xmlSecAllocModeDouble = 1);

      xmlSecBnFormat = (
          xmlSecBnBase64 = 1,
          xmlSecBnHex = 2,
          xmlSecBnDec = 3);

      xmlSecCheckVersionMode = (
          xmlSecCheckVersionExact = 0,
          xmlSecCheckVersionABICompatible = 1);

      xmlSecDSigReferenceOrigin = (
          xmlSecDSigReferenceOriginSignedInfo = 1,
          xmlSecDSigReferenceOriginManifest = 2);

      xmlSecDSigStatus = (
          xmlSecDSigStatusUnknown = 0,
          xmlSecDSigStatusSucceeded = 1,
          xmlSecDSigStatusInvalid = 2);

      xmlSecKeyDataFormat = (
          xmlSecKeyDataFormatUnknown = 0,
          xmlSecKeyDataFormatBinary = 1,
          xmlSecKeyDataFormatPem = 2,
          xmlSecKeyDataFormatDer = 3,
          xmlSecKeyDataFormatPkcs8Pem = 4,
          xmlSecKeyDataFormatPkcs8Der = 5,
          xmlSecKeyDataFormatPkcs12 = 6,
          xmlSecKeyDataFormatCertPem = 7,
          xmlSecKeyDataFormatCertDer = 8);

      xmlSecKeyInfoMode = (
          xmlSecKeyInfoModeRead = 0,
          xmlSecKeyInfoModeWrite = 1);

      xmlSecNodeSetOp = (
          xmlSecNodeSetIntersection = 0,
          xmlSecNodeSetSubtraction = 1,
          xmlSecNodeSetUnion = 2);

      xmlSecNodeSetType = (
          xmlSecNodeSetNormal = 0,
          xmlSecNodeSetInvert = 1,
          xmlSecNodeSetTree = 2,
          xmlSecNodeSetTreeWithoutComments = 3,
          xmlSecNodeSetTreeInvert = 4,
          xmlSecNodeSetTreeWithoutCommentsInvert = 5,
          xmlSecNodeSetList = 6);

      xmlSecSoap12FaultCode = (
          xmlSecSoap12FaultCodeUnknown = 0,
          xmlSecSoap12FaultCodeVersionMismatch = 1,
          xmlSecSoap12FaultCodeMustUnderstand = 2,
          xmlSecSoap12FaultCodeDataEncodingUnknown = 3,
          xmlSecSoap12FaultCodeSender = 4,
          xmlSecSoap12FaultCodeReceiver = 5);

      xmlSecTransformMode = (
          xmlSecTransformModeNone = 0,
          xmlSecTransformModePush = 1,
          xmlSecTransformModePop = 2);

      xmlSecTransformOperation = (
          xmlSecTransformOperationNone = 0,
          xmlSecTransformOperationEncode = 1,
          xmlSecTransformOperationDecode = 2,
          xmlSecTransformOperationSign = 3,
          xmlSecTransformOperationVerify = 4,
          xmlSecTransformOperationEncrypt = 5,
          xmlSecTransformOperationDecrypt = 6);

      xmlSecTransformStatus = (
          xmlSecTransformStatusNone = 0,
          xmlSecTransformStatusWorking = 1,
          xmlSecTransformStatusFinished = 2,
          xmlSecTransformStatusOk = 3,
          xmlSecTransformStatusFail = 4);

      xmlSecXkmsKeyBindingStatus = (
          xmlSecXkmsKeyBindingStatusNone = 1,
          xmlSecXkmsKeyBindingStatusValid = 2,
          xmlSecXkmsKeyBindingStatusInvalid = 3,
          xmlSecXkmsKeyBindingStatusIndeterminate = 4);

      xmlSecXkmsResultMajor = (
          xmlSecXkmsResultMajorSuccess = 0,
          xmlSecXkmsResultMajorVersionMismatch = 1,
          xmlSecXkmsResultMajorSender = 2,
          xmlSecXkmsResultMajorReceiver = 3,
          xmlSecXkmsResultMajorRepresent = 4,
          xmlSecXkmsResultMajorPending = 5);

      xmlSecXkmsResultMinor = (
          xmlSecXkmsResultMinorNone = 0,
          xmlSecXkmsResultMinorNoMatch = 1,
          xmlSecXkmsResultMinorTooManyResponses = 2,
          xmlSecXkmsResultMinorIncomplete = 3,
          xmlSecXkmsResultMinorFailure = 4,
          xmlSecXkmsResultMinorRefused = 5,
          xmlSecXkmsResultMinorNoAuthentication = 6,
          xmlSecXkmsResultMinorMessageNotSupported = 7,
          xmlSecXkmsResultMinorUnknownResponseId = 8,
          xmlSecXkmsResultMinorSynchronous = 9);

      xmlSecXkmsServerFormat = (
          xmlSecXkmsServerFormatUnknown = 0,
          xmlSecXkmsServerFormatPlain = 1,
          xmlSecXkmsServerFormatSoap11 = 2,
          xmlSecXkmsServerFormatSoap12 = 3);

       xmlSecPtr = Pointer;
       xmlSecPtrPtr = ^xmlSecPtr;

      xmlSecKeyDataUsage = Cardinal;

      xmlSecKeyPtr = Pointer;
      xmlSecKeyDataList = Pointer;
      xmlSecKeyDataListPtr = Pointer;
      xmlSecKeyDataPtr = Pointer;
      xmlSecKeyDataStorePtr = Pointer;
      xmlSecKeyInfoCtxPtr = Pointer;
      xmlSecKeyStorePtr = Pointer;

      xmlSecKeyDataType = Cardinal;
      xmlSecKeyDataId = ^_xmlSecKeyDataKlass;

      xmlSecKeyDataBinReadMethod = function  (id: xmlSecKeyDataId; key: xmlSecKeyPtr; const buf: xmlSecBytePtr; bufSize: xmlSecSize; keyInfoCtx: xmlSecKeyInfoCtxPtr) : Longint; cdecl;
        xmlSecKeyDataBinReadMethodPtr = ^xmlSecKeyDataBinReadMethod;

      xmlSecKeyDataBinWriteMethod = function  (id: xmlSecKeyDataId; key: xmlSecKeyPtr; buf: xmlSecBytePtrPtr; bufSize: xmlSecSizePtr; keyInfoCtx: xmlSecKeyInfoCtxPtr) : Longint; cdecl;
        xmlSecKeyDataBinWriteMethodPtr = ^xmlSecKeyDataBinWriteMethod;

      xmlSecKeyDataDebugDumpMethod = procedure  (data: xmlSecKeyDataPtr; output: PFILE); cdecl;
        xmlSecKeyDataDebugDumpMethodPtr = ^xmlSecKeyDataDebugDumpMethod;

      xmlSecKeyDataDuplicateMethod = function  (dst: xmlSecKeyDataPtr; src: xmlSecKeyDataPtr) : Longint; cdecl;
        xmlSecKeyDataDuplicateMethodPtr = ^xmlSecKeyDataDuplicateMethod;

      xmlSecKeyDataFinalizeMethod = procedure  (data: xmlSecKeyDataPtr); cdecl;
        xmlSecKeyDataFinalizeMethodPtr = ^xmlSecKeyDataFinalizeMethod;

      xmlSecKeyDataGenerateMethod = function  (data: xmlSecKeyDataPtr; sizeBits: xmlSecSize; type_: xmlSecKeyDataType) : Longint; cdecl;
        xmlSecKeyDataGenerateMethodPtr = ^xmlSecKeyDataGenerateMethod;

      xmlSecKeyDataGetIdentifierMethod = function  (data: xmlSecKeyDataPtr) : PChar; cdecl;
        xmlSecKeyDataGetIdentifierMethodPtr = ^xmlSecKeyDataGetIdentifierMethod;

      xmlSecKeyDataGetSizeMethod = function  (data: xmlSecKeyDataPtr) : xmlSecSize; cdecl;
        xmlSecKeyDataGetSizeMethodPtr = ^xmlSecKeyDataGetSizeMethod;

      xmlSecKeyDataGetTypeMethod = function  (data: xmlSecKeyDataPtr) : xmlSecKeyDataType; cdecl;
        xmlSecKeyDataGetTypeMethodPtr = ^xmlSecKeyDataGetTypeMethod;

      xmlSecKeyDataInitMethod = function  (data: xmlSecKeyDataPtr) : Longint; cdecl;
        xmlSecKeyDataInitMethodPtr = ^xmlSecKeyDataInitMethod;

      xmlSecKeyDataStoreFinalizeMethod = procedure  (store: xmlSecKeyDataStorePtr); cdecl;
        xmlSecKeyDataStoreFinalizeMethodPtr = ^xmlSecKeyDataStoreFinalizeMethod;

      xmlSecKeyDataStoreInitializeMethod = function  (store: xmlSecKeyDataStorePtr) : Longint; cdecl;
        xmlSecKeyDataStoreInitializeMethodPtr = ^xmlSecKeyDataStoreInitializeMethod;

      xmlSecKeyDataXmlReadMethod = function  (id: xmlSecKeyDataId; key: xmlSecKeyPtr; node: xmlNodePtr; keyInfoCtx: xmlSecKeyInfoCtxPtr) : Longint; cdecl;
        xmlSecKeyDataXmlReadMethodPtr = ^xmlSecKeyDataXmlReadMethod;

      xmlSecKeyDataXmlWriteMethod = function  (id: xmlSecKeyDataId; key: xmlSecKeyPtr; node: xmlNodePtr; keyInfoCtx: xmlSecKeyInfoCtxPtr) : Longint; cdecl;
        xmlSecKeyDataXmlWriteMethodPtr = ^xmlSecKeyDataXmlWriteMethod;

      xmlSecKeyStoreFinalizeMethod = procedure  (store: xmlSecKeyStorePtr); cdecl;
        xmlSecKeyStoreFinalizeMethodPtr = ^xmlSecKeyStoreFinalizeMethod;

      xmlSecKeyStoreFindKeyMethod = function  (store: xmlSecKeyStorePtr; const name: PChar; keyInfoCtx: xmlSecKeyInfoCtxPtr) : xmlSecKeyPtr; cdecl;
        xmlSecKeyStoreFindKeyMethodPtr = ^xmlSecKeyStoreFindKeyMethod;

      xmlSecKeyStoreInitializeMethod = function  (store: xmlSecKeyStorePtr) : Longint; cdecl;
        xmlSecKeyStoreInitializeMethodPtr = ^xmlSecKeyStoreInitializeMethod;

      _xmlSecKeyDataKlass = record
        klassSize : xmlSecSize;
        objSize : xmlSecSize;
        name : xmlCharPtr;
        usage : xmlSecKeyDataUsage;
        href : xmlCharPtr;
        dataNodeName : xmlCharPtr;
        dataNodeNs : xmlCharPtr;
        initialize : xmlSecKeyDataInitMethod;
        duplicate : xmlSecKeyDataDuplicateMethod;
        finalize : xmlSecKeyDataFinalizeMethod;
        generate : xmlSecKeyDataGenerateMethod;
        getType : xmlSecKeyDataGetTypeMethod;
        getSize : xmlSecKeyDataGetSizeMethod;
        getIdentifier : xmlSecKeyDataGetIdentifierMethod;
        xmlRead : xmlSecKeyDataXmlReadMethod;
        xmlWrite : xmlSecKeyDataXmlWriteMethod;
        binRead : xmlSecKeyDataBinReadMethod;
        binWrite : xmlSecKeyDataBinWriteMethod;
        debugDump : xmlSecKeyDataDebugDumpMethod;
        debugXmlDump : xmlSecKeyDataDebugDumpMethod;
        reserved0 : Pointer;
        reserved1 : Pointer;
      end;

      xmlSecKeyDataKlass = _xmlSecKeyDataKlass;

      _xmlSecKeyDataStoreKlass = record
        klassSize : xmlSecSize;
        objSize : xmlSecSize;
        name : xmlCharPtr;
        initialize : xmlSecKeyDataStoreInitializeMethod;
        finalize : xmlSecKeyDataStoreFinalizeMethod;
        reserved0 : Pointer;
        reserved1 : Pointer;
      end;

      xmlSecKeyDataStoreId = ^_xmlSecKeyDataStoreKlass;
      xmlSecKeyDataStoreKlass = _xmlSecKeyDataStoreKlass;

      _xmlSecKeyStoreKlass = record
        klassSize : xmlSecSize;
        objSize : xmlSecSize;
        name : xmlCharPtr;
        initialize : xmlSecKeyStoreInitializeMethod;
        finalize : xmlSecKeyStoreFinalizeMethod;
        findKey : xmlSecKeyStoreFindKeyMethod;
        reserved0 : Pointer;
        reserved1 : Pointer;
      end;

      xmlSecKeyStoreId = ^_xmlSecKeyStoreKlass;
      xmlSecKeyStoreKlass = _xmlSecKeyStoreKlass;

      _xmlSecKeyKlass = record  // Never actually defined in the headers!
      end;

      xmlSecKeyId = ^_xmlSecKeyKlass;
      xmlSecKeyKlass = _xmlSecKeyKlass;

      xmlSecBuffer = record
          data : xmlSecBytePtr; {}
          size : xmlSecSize; {}
          maxSize : xmlSecSize; {}
          allocMode : xmlSecAllocMode; {}
      end;

      xmlSecBufferPtr = ^xmlSecBuffer;
      xmlSecBn = xmlSecBuffer;
      xmlSecBnPtr = ^xmlSecBuffer;

      xmlSecPtrDebugDumpItemMethod = procedure  (ptr: xmlSecPtr; output: PFILE); cdecl;
        xmlSecPtrDebugDumpItemMethodPtr = ^xmlSecPtrDebugDumpItemMethod;

      xmlSecPtrDestroyItemMethod = procedure  (ptr: xmlSecPtr); cdecl;
        xmlSecPtrDestroyItemMethodPtr = ^xmlSecPtrDestroyItemMethod;

      xmlSecPtrDuplicateItemMethod = function  (ptr: xmlSecPtr) : xmlSecPtr; cdecl;
        xmlSecPtrDuplicateItemMethodPtr = ^xmlSecPtrDuplicateItemMethod;

      _xmlSecPtrListKlass = record
        name : xmlCharPtr;
        duplicateItem : xmlSecPtrDuplicateItemMethod;
        destroyItem : xmlSecPtrDestroyItemMethod;
        debugDumpItem : xmlSecPtrDebugDumpItemMethod;
        debugXmlDumpItem : xmlSecPtrDebugDumpItemMethod;
      end;

      xmlSecPtrListId = ^_xmlSecPtrListKlass;
      xmlSecPtrListKlass = _xmlSecPtrListKlass;

      _xmlSecPtrList = record
        id : xmlSecPtrListId;
        data : xmlSecPtrPtr;
        use : xmlSecSize;
        max : xmlSecSize;
        allocMode : xmlSecAllocMode;
      end;

      xmlSecTransformUsage = Cardinal;

      xmlSecTransformDataType = xmlSecByte;

      xmlSecTransformPtr = ^xmlSecTransform;

      xmlSecTransformCtxPtr = ^xmlSecTransformCtx;

      xmlSecNodeSetPtr = ^xmlSecNodeSet;

      xmlSecNodeSetPtrPtr = ^xmlSecNodeSetPtr;

      xmlSecKeyReqPtr = ^xmlSecKeyReq;

      xmlSecTransformExecuteMethod = function  (transform: xmlSecTransformPtr; last: Longint; transformCtx: xmlSecTransformCtxPtr) : Longint; cdecl;
        xmlSecTransformExecuteMethodPtr = ^xmlSecTransformExecuteMethod;

      xmlSecTransformFinalizeMethod = procedure  (transform: xmlSecTransformPtr); cdecl;
        xmlSecTransformFinalizeMethodPtr = ^xmlSecTransformFinalizeMethod;

      xmlSecTransformGetDataTypeMethod = function  (transform: xmlSecTransformPtr; mode: xmlSecTransformMode; transformCtx: xmlSecTransformCtxPtr) : xmlSecTransformDataType; cdecl;
        xmlSecTransformGetDataTypeMethodPtr = ^xmlSecTransformGetDataTypeMethod;

      xmlSecTransformInitializeMethod = function  (transform: xmlSecTransformPtr) : Longint; cdecl;
        xmlSecTransformInitializeMethodPtr = ^xmlSecTransformInitializeMethod;

      xmlSecTransformNodeReadMethod = function  (transform: xmlSecTransformPtr; node: xmlNodePtr; transformCtx: xmlSecTransformCtxPtr) : Longint; cdecl;
        xmlSecTransformNodeReadMethodPtr = ^xmlSecTransformNodeReadMethod;

      xmlSecTransformNodeWriteMethod = function  (transform: xmlSecTransformPtr; node: xmlNodePtr; transformCtx: xmlSecTransformCtxPtr) : Longint; cdecl;
        xmlSecTransformNodeWriteMethodPtr = ^xmlSecTransformNodeWriteMethod;

      xmlSecTransformPopBinMethod = function  (transform: xmlSecTransformPtr; data: xmlSecBytePtr; maxDataSize: xmlSecSize; dataSize: xmlSecSizePtr; transformCtx: xmlSecTransformCtxPtr) : Longint; cdecl;
        xmlSecTransformPopBinMethodPtr = ^xmlSecTransformPopBinMethod;

      xmlSecTransformPopXmlMethod = function  (transform: xmlSecTransformPtr; nodes: xmlSecNodeSetPtrPtr; transformCtx: xmlSecTransformCtxPtr) : Longint; cdecl;
        xmlSecTransformPopXmlMethodPtr = ^xmlSecTransformPopXmlMethod;

      xmlSecTransformPushBinMethod = function  (transform: xmlSecTransformPtr; const data: xmlSecBytePtr; dataSize: xmlSecSize; final: Longint; transformCtx: xmlSecTransformCtxPtr) : Longint; cdecl;
        xmlSecTransformPushBinMethodPtr = ^xmlSecTransformPushBinMethod;

      xmlSecTransformPushXmlMethod = function  (transform: xmlSecTransformPtr; nodes: xmlSecNodeSetPtr; transformCtx: xmlSecTransformCtxPtr) : Longint; cdecl;
        xmlSecTransformPushXmlMethodPtr = ^xmlSecTransformPushXmlMethod;

      xmlSecTransformSetKeyMethod = function  (transform: xmlSecTransformPtr; key: xmlSecKeyPtr) : Longint; cdecl;
        xmlSecTransformSetKeyMethodPtr = ^xmlSecTransformSetKeyMethod;

      xmlSecTransformSetKeyRequirementsMethod = function  (transform: xmlSecTransformPtr; keyReq: xmlSecKeyReqPtr) : Longint; cdecl;
        xmlSecTransformSetKeyRequirementsMethodPtr = ^xmlSecTransformSetKeyRequirementsMethod;

      xmlSecTransformVerifyMethod = function  (transform: xmlSecTransformPtr; const data: xmlSecBytePtr; dataSize: xmlSecSize; transformCtx: xmlSecTransformCtxPtr) : Longint; cdecl;
        xmlSecTransformVerifyMethodPtr = ^xmlSecTransformVerifyMethod;

      _xmlSecTransformKlass = record
        klassSize : xmlSecSize;
        objSize : xmlSecSize;
        name : xmlCharPtr;
        href : xmlCharptr;
        usage : xmlSecTransformUsage;
        initialize : xmlSecTransformInitializeMethod;
        finalize : xmlSecTransformFinalizeMethod;
        readNode : xmlSecTransformNodeReadMethod;
        writeNode : xmlSecTransformNodeWriteMethod;
        setKeyReq : xmlSecTransformSetKeyRequirementsMethod;
        setKey : xmlSecTransformSetKeyMethod;
        verify : xmlSecTransformVerifyMethod;
        getDataType : xmlSecTransformGetDataTypeMethod;
        pushBin : xmlSecTransformPushBinMethod;
        popBin : xmlSecTransformPopBinMethod;
        pushXml : xmlSecTransformPushXmlMethod;
        popXml : xmlSecTransformPopXmlMethod;
        execute : xmlSecTransformExecuteMethod;
        reserved0 : Pointer;
        reverved1 : Pointer;
      end;

      xmlSecBitMask = Cardinal;
      xmlSecBitMaskPtr = ^xmlSecBitMask;
      xmlSecKeyUsage = Cardinal;
      xmlSecTransformId = ^_xmlSecTransformKlass;
      xmlSecTransformKlass = _xmlSecTransformKlass;
      xmlSecTransformUriType = Cardinal;

      xmlSecKeyStore = record
          id : xmlSecKeyStoreId; { for the future}
          reserved0 : Pointer; {}
          reserved1 : Pointer; {}
      end;

      xmlSecPtrList = record
          id : xmlSecPtrListId; {}
          data : xmlSecPtrPtr; {}
          use : xmlSecSize; {}
          max : xmlSecSize; {}
          allocMode : xmlSecAllocMode; {}
      end;

      xmlSecPtrListPtr = ^xmlSecPtrList;

      xmlSecGetKeyCallback = function  (keyInfoNode: xmlNodePtr; keyInfoCtx: xmlSecKeyInfoCtxPtr) : xmlSecKeyPtr; cdecl;
        xmlSecGetKeyCallbackPtr = ^xmlSecGetKeyCallback;

      xmlSecKeysMngr = record
          keysStore : xmlSecKeyStorePtr; {}
          storesList : xmlSecPtrList; {}
          getKey : xmlSecGetKeyCallback; {}
      end;

      xmlSecKeysMngrPtr = ^xmlSecKeysMngr;

       xmlSecQName2BitMaskInfoPtr = ^xmlSecQName2BitMaskInfo;
       xmlSecQName2IntegerInfoPtr = ^xmlSecQName2IntegerInfo;
      xmlSecCryptoAppDefaultKeysMngrAdoptKeyMethod = function  (mngr: xmlSecKeysMngrPtr; key: xmlSecKeyPtr) : Longint; cdecl;
        xmlSecCryptoAppDefaultKeysMngrAdoptKeyMethodPtr = ^xmlSecCryptoAppDefaultKeysMngrAdoptKeyMethod;

      xmlSecCryptoAppDefaultKeysMngrInitMethod = function  (mngr: xmlSecKeysMngrPtr) : Longint; cdecl;
        xmlSecCryptoAppDefaultKeysMngrInitMethodPtr = ^xmlSecCryptoAppDefaultKeysMngrInitMethod;

      xmlSecCryptoAppDefaultKeysMngrLoadMethod = function  (mngr: xmlSecKeysMngrPtr; const uri: PChar) : Longint; cdecl;
        xmlSecCryptoAppDefaultKeysMngrLoadMethodPtr = ^xmlSecCryptoAppDefaultKeysMngrLoadMethod;

      xmlSecCryptoAppDefaultKeysMngrSaveMethod = function  (mngr: xmlSecKeysMngrPtr; const filename: PChar; type_: xmlSecKeyDataType) : Longint; cdecl;
        xmlSecCryptoAppDefaultKeysMngrSaveMethodPtr = ^xmlSecCryptoAppDefaultKeysMngrSaveMethod;

      xmlSecCryptoAppInitMethod = function  (const config: PChar) : Longint; cdecl;
        xmlSecCryptoAppInitMethodPtr = ^xmlSecCryptoAppInitMethod;

      xmlSecCryptoAppKeyCertLoadMemoryMethod = function  (key: xmlSecKeyPtr; const data: xmlSecBytePtr; dataSize: xmlSecSize; format: xmlSecKeyDataFormat) : Longint; cdecl;
        xmlSecCryptoAppKeyCertLoadMemoryMethodPtr = ^xmlSecCryptoAppKeyCertLoadMemoryMethod;

      xmlSecCryptoAppKeyCertLoadMethod = function  (key: xmlSecKeyPtr; const filename: PChar; format: xmlSecKeyDataFormat) : Longint; cdecl;
        xmlSecCryptoAppKeyCertLoadMethodPtr = ^xmlSecCryptoAppKeyCertLoadMethod;

      xmlSecCryptoAppKeyLoadMemoryMethod = function  (const data: xmlSecBytePtr; dataSize: xmlSecSize; format: xmlSecKeyDataFormat; const pwd: PChar; pwdCallback: Pointer; pwdCallbackCtx: Pointer) : xmlSecKeyPtr; cdecl;
        xmlSecCryptoAppKeyLoadMemoryMethodPtr = ^xmlSecCryptoAppKeyLoadMemoryMethod;

      xmlSecCryptoAppKeyLoadMethod = function  (const filename: PChar; format: xmlSecKeyDataFormat; const pwd: PChar; pwdCallback: Pointer; pwdCallbackCtx: Pointer) : xmlSecKeyPtr; cdecl;
        xmlSecCryptoAppKeyLoadMethodPtr = ^xmlSecCryptoAppKeyLoadMethod;

      xmlSecCryptoAppKeysMngrCertLoadMemoryMethod = function  (mngr: xmlSecKeysMngrPtr; const data: xmlSecBytePtr; dataSize: xmlSecSize; format: xmlSecKeyDataFormat; type_: xmlSecKeyDataType) : Longint; cdecl;
        xmlSecCryptoAppKeysMngrCertLoadMemoryMethodPtr = ^xmlSecCryptoAppKeysMngrCertLoadMemoryMethod;

      xmlSecCryptoAppKeysMngrCertLoadMethod = function  (mngr: xmlSecKeysMngrPtr; const filename: PChar; format: xmlSecKeyDataFormat; type_: xmlSecKeyDataType) : Longint; cdecl;
        xmlSecCryptoAppKeysMngrCertLoadMethodPtr = ^xmlSecCryptoAppKeysMngrCertLoadMethod;

      xmlSecCryptoAppPkcs12LoadMemoryMethod = function  (const data: xmlSecBytePtr; dataSize: xmlSecSize; const pwd: PChar; pwdCallback: Pointer; pwdCallbackCtx: Pointer) : xmlSecKeyPtr; cdecl;
        xmlSecCryptoAppPkcs12LoadMemoryMethodPtr = ^xmlSecCryptoAppPkcs12LoadMemoryMethod;

      xmlSecCryptoAppPkcs12LoadMethod = function  (const filename: PChar; const pwd: PChar; pwdCallback: Pointer; pwdCallbackCtx: Pointer) : xmlSecKeyPtr; cdecl;
        xmlSecCryptoAppPkcs12LoadMethodPtr = ^xmlSecCryptoAppPkcs12LoadMethod;

      xmlSecCryptoAppShutdownMethod = function  () : Longint; cdecl;
        xmlSecCryptoAppShutdownMethodPtr = ^xmlSecCryptoAppShutdownMethod;

      xmlSecCryptoInitMethod = function  () : Longint; cdecl;
        xmlSecCryptoInitMethodPtr = ^xmlSecCryptoInitMethod;

      xmlSecCryptoKeyDataGetKlassMethod = function  () : xmlSecKeyDataId; cdecl;
        xmlSecCryptoKeyDataGetKlassMethodPtr = ^xmlSecCryptoKeyDataGetKlassMethod;

      xmlSecCryptoKeyDataStoreGetKlassMethod = function  () : xmlSecKeyDataStoreId; cdecl;
        xmlSecCryptoKeyDataStoreGetKlassMethodPtr = ^xmlSecCryptoKeyDataStoreGetKlassMethod;

      xmlSecCryptoKeysMngrInitMethod = function  (mngr: xmlSecKeysMngrPtr) : Longint; cdecl;
        xmlSecCryptoKeysMngrInitMethodPtr = ^xmlSecCryptoKeysMngrInitMethod;

      xmlSecCryptoShutdownMethod = function  () : Longint; cdecl;
        xmlSecCryptoShutdownMethodPtr = ^xmlSecCryptoShutdownMethod;

      xmlSecCryptoTransformGetKlassMethod = function  () : xmlSecTransformId; cdecl;
        xmlSecCryptoTransformGetKlassMethodPtr = ^xmlSecCryptoTransformGetKlassMethod;

      xmlSecErrorsCallback = procedure  (const file_: PChar; line: Longint; const func: PChar; const errorObject: PChar; const errorSubject: PChar; reason: Longint; const msg: PChar); cdecl;
        xmlSecErrorsCallbackPtr = ^xmlSecErrorsCallback;

      xmlSecNodeSetWalkCallback = function  (nset: xmlSecNodeSetPtr; cur: xmlNodePtr; parent: xmlNodePtr; data: Pointer) : Longint; cdecl;
        xmlSecNodeSetWalkCallbackPtr = ^xmlSecNodeSetWalkCallback;

      xmlSecTransformCtxPreExecuteCallback = function  (transformCtx: xmlSecTransformCtxPtr) : Longint; cdecl;
        xmlSecTransformCtxPreExecuteCallbackPtr = ^xmlSecTransformCtxPreExecuteCallback;

      xmlSecBase64Ctx = record
      end;

      xmlSecBase64CtxPtr = ^xmlSecBase64Ctx;

      xmlSecCryptoDLFunctions = record
          cryptoInit : xmlSecCryptoInitMethod; {}
          cryptoShutdown : xmlSecCryptoShutdownMethod; {}
          cryptoKeysMngrInit : xmlSecCryptoKeysMngrInitMethod; {*
* Key data ids
*}
          keyDataAesGetKlass : xmlSecCryptoKeyDataGetKlassMethod; {}
          keyDataDesGetKlass : xmlSecCryptoKeyDataGetKlassMethod; {}
          keyDataDsaGetKlass : xmlSecCryptoKeyDataGetKlassMethod; {}
          keyDataHmacGetKlass : xmlSecCryptoKeyDataGetKlassMethod; {}
          keyDataRsaGetKlass : xmlSecCryptoKeyDataGetKlassMethod; {}
          keyDataX509GetKlass : xmlSecCryptoKeyDataGetKlassMethod; {}
          keyDataRawX509CertGetKlass : xmlSecCryptoKeyDataGetKlassMethod; {*
* Key data store ids
*}
          x509StoreGetKlass : xmlSecCryptoKeyDataStoreGetKlassMethod; {*
* Crypto transforms ids
*}
          transformAes128CbcGetKlass : xmlSecCryptoTransformGetKlassMethod; {}
          transformAes192CbcGetKlass : xmlSecCryptoTransformGetKlassMethod; {}
          transformAes256CbcGetKlass : xmlSecCryptoTransformGetKlassMethod; {}
          transformKWAes128GetKlass : xmlSecCryptoTransformGetKlassMethod; {}
          transformKWAes192GetKlass : xmlSecCryptoTransformGetKlassMethod; {}
          transformKWAes256GetKlass : xmlSecCryptoTransformGetKlassMethod; {}
          transformDes3CbcGetKlass : xmlSecCryptoTransformGetKlassMethod; {}
          transformKWDes3GetKlass : xmlSecCryptoTransformGetKlassMethod; {}
          transformDsaSha1GetKlass : xmlSecCryptoTransformGetKlassMethod; {}
          transformHmacSha1GetKlass : xmlSecCryptoTransformGetKlassMethod; {}
          transformHmacRipemd160GetKlass : xmlSecCryptoTransformGetKlassMethod; {}
          transformHmacMd5GetKlass : xmlSecCryptoTransformGetKlassMethod; {}
          transformRipemd160GetKlass : xmlSecCryptoTransformGetKlassMethod; {}
          transformRsaSha1GetKlass : xmlSecCryptoTransformGetKlassMethod; {}
          transformRsaPkcs1GetKlass : xmlSecCryptoTransformGetKlassMethod; {}
          transformRsaOaepGetKlass : xmlSecCryptoTransformGetKlassMethod; {}
          transformSha1GetKlass : xmlSecCryptoTransformGetKlassMethod; {*
* High level routines form xmlsec command line utility
*}
          cryptoAppInit : xmlSecCryptoAppInitMethod; {}
          cryptoAppShutdown : xmlSecCryptoAppShutdownMethod; {}
          cryptoAppDefaultKeysMngrInit : xmlSecCryptoAppDefaultKeysMngrInitMethod; {}
          cryptoAppDefaultKeysMngrAdoptKey : xmlSecCryptoAppDefaultKeysMngrAdoptKeyMethod; {}
          cryptoAppDefaultKeysMngrLoad : xmlSecCryptoAppDefaultKeysMngrLoadMethod; {}
          cryptoAppDefaultKeysMngrSave : xmlSecCryptoAppDefaultKeysMngrSaveMethod; {}
          cryptoAppKeysMngrCertLoad : xmlSecCryptoAppKeysMngrCertLoadMethod; {}
          cryptoAppKeysMngrCertLoadMemory : xmlSecCryptoAppKeysMngrCertLoadMemoryMethod; {}
          cryptoAppKeyLoad : xmlSecCryptoAppKeyLoadMethod; {}
          cryptoAppKeyLoadMemory : xmlSecCryptoAppKeyLoadMemoryMethod; {}
          cryptoAppPkcs12Load : xmlSecCryptoAppPkcs12LoadMethod; {}
          cryptoAppPkcs12LoadMemory : xmlSecCryptoAppPkcs12LoadMemoryMethod; {}
          cryptoAppKeyCertLoad : xmlSecCryptoAppKeyCertLoadMethod; {}
          cryptoAppKeyCertLoadMemory : xmlSecCryptoAppKeyCertLoadMemoryMethod; {}
          cryptoAppDefaultPwdCallback : Pointer; {}
      end;

      xmlSecCryptoDLFunctionsPtr = ^xmlSecCryptoDLFunctions;

      xmlSecEncCtxPtr = ^xmlSecEncCtx;

      xmlSecKeyReq = record
          keyId : xmlSecKeyDataId; {}
          keyType : xmlSecKeyDataType; {}
          keyUsage : xmlSecKeyUsage; {}
          keyBitsSize : xmlSecSize; {}
          keyUseWithList : xmlSecPtrList; {}
          reserved1 : Pointer; {}
          reserved2 : Pointer; {}
      end;

      xmlSecTransformCtx = record
          userData : Pointer; {}
          flags : Cardinal; {}
          flags2 : Cardinal; {}
          enabledUris : xmlSecTransformUriType; {}
          enabledTransforms : xmlSecPtrList; {}
          preExecCallback : xmlSecTransformCtxPreExecuteCallback; { results}
          result : xmlSecBufferPtr; {}
          status : xmlSecTransformStatus; {}
          uri : PChar; {}
          xptrExpr : PChar; {}
          first : xmlSecTransformPtr; {}
          last : xmlSecTransformPtr; { for the future}
          reserved0 : Pointer; {}
          reserved1 : Pointer; {}
      end;

      xmlSecKeyInfoCtx = record
          userData : Pointer; {}
          flags : Cardinal; {}
          flags2 : Cardinal; {}
          keysMngr : xmlSecKeysMngrPtr; {}
          mode : xmlSecKeyInfoMode; {}
          enabledKeyData : xmlSecPtrList; {}
          base64LineSize : Longint; { RetrievalMethod}
          retrievalMethodCtx : xmlSecTransformCtx; {}
          maxRetrievalMethodLevel : Longint; { EncryptedKey}
          encCtx : xmlSecEncCtxPtr; {}
          maxEncryptedKeyLevel : Longint; { x509 certificates}
          certsVerificationTime : time_t; {}
          certsVerificationDepth : Longint; { PGP}
          pgpReserved : Pointer; { TODO internal data}
          curRetrievalMethodLevel : Longint; {}
          curEncryptedKeyLevel : Longint; {}
          keyReq : xmlSecKeyReq; { for the future}
          reserved0 : Pointer; {}
          reserved1 : Pointer; {}
      end;

      xmlSecDSigCtx = record
          userData : Pointer; {}
          flags : Cardinal; {}
          flags2 : Cardinal; {}
          keyInfoReadCtx : xmlSecKeyInfoCtx; {}
          keyInfoWriteCtx : xmlSecKeyInfoCtx; {}
          transformCtx : xmlSecTransformCtx; {}
          enabledReferenceUris : xmlSecTransformUriType; {}
          enabledReferenceTransforms : xmlSecPtrListPtr; {}
          referencePreExecuteCallback : xmlSecTransformCtxPreExecuteCallback; {}
          defSignMethodId : xmlSecTransformId; {}
          defC14NMethodId : xmlSecTransformId; {}
          defDigestMethodId : xmlSecTransformId; { these data are returned}
          signKey : xmlSecKeyPtr; {}
          operation : xmlSecTransformOperation; {}
          result : xmlSecBufferPtr; {}
          status : xmlSecDSigStatus; {}
          signMethod : xmlSecTransformPtr; {}
          c14nMethod : xmlSecTransformPtr; {}
          preSignMemBufMethod : xmlSecTransformPtr; {}
          signValueNode : xmlNodePtr; {}
          id : PChar; {}
          signedInfoReferences : xmlSecPtrList; {}
          manifestReferences : xmlSecPtrList; { reserved for future}
          reserved0 : Pointer; {}
          reserved1 : Pointer; {}
      end;

      xmlSecDSigCtxPtr = ^xmlSecDSigCtx;

      xmlSecDSigReferenceCtx = record
          userData : Pointer; {}
          dsigCtx : xmlSecDSigCtxPtr; {}
          origin : xmlSecDSigReferenceOrigin; {}
          transformCtx : xmlSecTransformCtx; {}
          digestMethod : xmlSecTransformPtr; {}
          result : xmlSecBufferPtr; {}
          status : xmlSecDSigStatus; {}
          preDigestMemBufMethod : xmlSecTransformPtr; {}
          id : PChar; {}
          uri : PChar; {}
          type_ : PChar; { reserved for future}
          reserved0 : Pointer; {}
          reserved1 : Pointer; {}
      end;

      xmlSecDSigReferenceCtxPtr = ^xmlSecDSigReferenceCtx;

      xmlSecEncCtx = record
          userData : Pointer; {}
          flags : Cardinal; {}
          flags2 : Cardinal; {}
          mode : xmlEncCtxMode; {}
          keyInfoReadCtx : xmlSecKeyInfoCtx; {}
          keyInfoWriteCtx : xmlSecKeyInfoCtx; {}
          transformCtx : xmlSecTransformCtx; {}
          defEncMethodId : xmlSecTransformId; { these data are returned}
          encKey : xmlSecKeyPtr; {}
          operation : xmlSecTransformOperation; {}
          result : xmlSecBufferPtr; {}
          resultBase64Encoded : Longint; {}
          resultReplaced : Longint; {}
          encMethod : xmlSecTransformPtr; { attributes from EncryptedData or EncryptedKey}
          id : PChar; {}
          type_ : PChar; {}
          mimeType : PChar; {}
          encoding : PChar; {}
          recipient : PChar; {}
          carriedKeyName : PChar; { these are internal data, nobody should change that except us}
          encDataNode : xmlNodePtr; {}
          encMethodNode : xmlNodePtr; {}
          keyInfoNode : xmlNodePtr; {}
          cipherValueNode : xmlNodePtr; { reserved for future}
          reserved0 : Pointer; {}
          reserved1 : Pointer; {}
      end;

      xmlSecKey = record
          name : PChar; {}
          value : xmlSecKeyDataPtr; {}
          dataList : xmlSecPtrListPtr; {}
          usage : xmlSecKeyUsage; {}
          notValidBefore : time_t; {}
          notValidAfter : time_t; {}
      end;

      xmlSecKeyData = record
          id : xmlSecKeyDataId; {}
          reserved0 : Pointer; {}
          reserved1 : Pointer; {}
      end;

      xmlSecKeyDataStore = record
          id : xmlSecKeyDataStoreId; { for the future}
          reserved0 : Pointer; {}
          reserved1 : Pointer; {}
      end;

      xmlSecKeyUseWith = record
          application : PChar; {}
          identifier : PChar; {}
          reserved1 : Pointer; {}
          reserved2 : Pointer; {}
      end;

      xmlSecKeyUseWithPtr = ^xmlSecKeyUseWith;

      xmlSecNodeSet = record
          nodes : xmlNodeSetPtr; {}
          doc : xmlDocPtr; {}
          destroyDoc : Longint; {}
          type_ : xmlSecNodeSetType; {}
          op : xmlSecNodeSetOp; {}
          next : xmlSecNodeSetPtr; {}
          prev : xmlSecNodeSetPtr; {}
          children : xmlSecNodeSetPtr; {}
      end;

      xmlSecQName2BitMaskInfo = record
          qnameHref : PChar; {}
          qnameLocalPart : PChar; {}
          mask : xmlSecBitMask; {}
      end;

      xmlSecQName2IntegerInfo = record
          qnameHref : PChar; {}
          qnameLocalPart : PChar; {}
          intValue : Longint; {}
      end;

      xmlSecTransform = record
          id : xmlSecTransformId; {}
          operation : xmlSecTransformOperation; {}
          status : xmlSecTransformStatus; {}
          hereNode : xmlNodePtr; { transforms chain}
          next : xmlSecTransformPtr; {}
          prev : xmlSecTransformPtr; { binary data}
          inBuf : xmlSecBuffer; {}
          outBuf : xmlSecBuffer; { xml data}
          inNodes : xmlSecNodeSetPtr; {}
          outNodes : xmlSecNodeSetPtr; { reserved for the future}
          reserved0 : Pointer; {}
          reserved1 : Pointer; {}
      end;


      xmlSecXkmsRespondWithId = record
      end;

      xmlSecXkmsRespondWithKlass = record
      end;

      xmlSecXkmsServerCtxPtr = ^xmlSecXkmsServerCtx;

      xmlSecXkmsServerRequestId = record
      end;

      xmlSecXkmsServerRequestKlass = record
      end;

      xmlSecXkmsServerCtx = record
          userData : Pointer; {}
          flags : xmlSecBitMask; {}
          flags2 : xmlSecBitMask; {}
          keyInfoReadCtx : xmlSecKeyInfoCtx; {}
          keyInfoWriteCtx : xmlSecKeyInfoCtx; {}
          enabledRespondWithIds : xmlSecPtrList; {}
          enabledServerRequestIds : xmlSecPtrList; {}
          expectedService : PChar; {}
          idPrefix : PChar; {}
          idLen : xmlSecSize; { these data are returned}
          keys : xmlSecPtrList; {}
          resultMajor : xmlSecXkmsResultMajor; {}
          resultMinor : xmlSecXkmsResultMinor; {}
          requestId : xmlSecXkmsServerRequestId; {}
          id : PChar; {}
          service : PChar; {}
          nonce : PChar; {}
          originalRequestId : PChar; {}
          pendingNotificationMechanism : PChar; {}
          pendingNotificationIdentifier : PChar; {}
          responseLimit : Longint; {}
          responseMechanismMask : xmlSecBitMask; {}
          compoundRequestContexts : xmlSecPtrListPtr; { these are internal data, nobody should change that except us}
          requestNode : xmlNodePtr; {}
          opaqueClientDataNode : xmlNodePtr; {}
          firtsMsgExtNode : xmlNodePtr; {}
          keyInfoNode : xmlNodePtr; {}
          respWithList : xmlSecPtrList; { reserved for future}
          reserved0 : Pointer; {}
          reserved1 : Pointer; {}
      end;

  function xmlSecAddChild (parent: xmlNodePtr; const name: PChar; const ns: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecAddChildNode (parent: xmlNodePtr; child: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  procedure xmlSecAddIDs (doc: xmlDocPtr; cur: xmlNodePtr; const ids: PPChar); cdecl; external XMLSEC_SO;
  function xmlSecAddNextSibling (node: xmlNodePtr; const name: PChar; const ns: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecAddPrevSibling (node: xmlNodePtr; const name: PChar; const ns: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecBase64CtxCreate (encode: Longint; columns: Longint) : xmlSecBase64CtxPtr; cdecl; external XMLSEC_SO;
  procedure xmlSecBase64CtxDestroy (ctx: xmlSecBase64CtxPtr); cdecl; external XMLSEC_SO;
  function xmlSecBase64CtxFinal (ctx: xmlSecBase64CtxPtr; out_: xmlSecBytePtr; outSize: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecBase64CtxFinalize (ctx: xmlSecBase64CtxPtr); cdecl; external XMLSEC_SO;
  function xmlSecBase64CtxInitialize (ctx: xmlSecBase64CtxPtr; encode: Longint; columns: Longint) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBase64CtxUpdate (ctx: xmlSecBase64CtxPtr; const in_: xmlSecBytePtr; inSize: xmlSecSize; out_: xmlSecBytePtr; outSize: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBase64Decode (const str: PChar; buf: xmlSecBytePtr; len: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBase64Encode (const buf: xmlSecBytePtr; len: xmlSecSize; columns: Longint) : PChar; cdecl; external XMLSEC_SO;
  function xmlSecBnAdd (bn: xmlSecBnPtr; delta: Longint) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBnBlobSetNodeValue (const data: xmlSecBytePtr; dataSize: xmlSecSize; cur: xmlNodePtr; format: xmlSecBnFormat; reverse: Longint; addLineBreaks: Longint) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBnCompare (bn: xmlSecBnPtr; const data: xmlSecBytePtr; dataSize: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBnCompareReverse (bn: xmlSecBnPtr; const data: xmlSecBytePtr; dataSize: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBnCreate (size: xmlSecSize) : xmlSecBnPtr; cdecl; external XMLSEC_SO;
  procedure xmlSecBnDestroy (bn: xmlSecBnPtr); cdecl; external XMLSEC_SO;
  function xmlSecBnDiv (bn: xmlSecBnPtr; divider: Longint; mod_: PInteger) : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecBnFinalize (bn: xmlSecBnPtr); cdecl; external XMLSEC_SO;
  function xmlSecBnFromDecString (bn: xmlSecBnPtr; const str: PChar) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBnFromHexString (bn: xmlSecBnPtr; const str: PChar) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBnFromString (bn: xmlSecBnPtr; const str: PChar; base: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBnGetData (bn: xmlSecBnPtr) : xmlSecBytePtr; cdecl; external XMLSEC_SO;
  function xmlSecBnGetNodeValue (bn: xmlSecBnPtr; cur: xmlNodePtr; format: xmlSecBnFormat; reverse: Longint) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBnGetSize (bn: xmlSecBnPtr) : xmlSecSize; cdecl; external XMLSEC_SO;
  function xmlSecBnInitialize (bn: xmlSecBnPtr; size: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBnMul (bn: xmlSecBnPtr; multiplier: Longint) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBnReverse (bn: xmlSecBnPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBnSetData (bn: xmlSecBnPtr; const data: xmlSecBytePtr; size: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBnSetNodeValue (bn: xmlSecBnPtr; cur: xmlNodePtr; format: xmlSecBnFormat; reverse: Longint; addLineBreaks: Longint) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBnToDecString (bn: xmlSecBnPtr) : PChar; cdecl; external XMLSEC_SO;
  function xmlSecBnToHexString (bn: xmlSecBnPtr) : PChar; cdecl; external XMLSEC_SO;
  function xmlSecBnToString (bn: xmlSecBnPtr; base: xmlSecSize) : PChar; cdecl; external XMLSEC_SO;
  procedure xmlSecBnZero (bn: xmlSecBnPtr); cdecl; external XMLSEC_SO;
  function xmlSecBufferAppend (buf: xmlSecBufferPtr; const data: xmlSecBytePtr; size: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBufferBase64NodeContentRead (buf: xmlSecBufferPtr; node: xmlNodePtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBufferBase64NodeContentWrite (buf: xmlSecBufferPtr; node: xmlNodePtr; columns: Longint) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBufferCreate (size: xmlSecSize) : xmlSecBufferPtr; cdecl; external XMLSEC_SO;
  function xmlSecBufferCreateOutputBuffer (buf: xmlSecBufferPtr) : xmlOutputBufferPtr; cdecl; external XMLSEC_SO;
  procedure xmlSecBufferDestroy (buf: xmlSecBufferPtr); cdecl; external XMLSEC_SO;
  procedure xmlSecBufferEmpty (buf: xmlSecBufferPtr); cdecl; external XMLSEC_SO;
  procedure xmlSecBufferFinalize (buf: xmlSecBufferPtr); cdecl; external XMLSEC_SO;
  function xmlSecBufferGetData (buf: xmlSecBufferPtr) : xmlSecBytePtr; cdecl; external XMLSEC_SO;
  function xmlSecBufferGetMaxSize (buf: xmlSecBufferPtr) : xmlSecSize; cdecl; external XMLSEC_SO;
  function xmlSecBufferGetSize (buf: xmlSecBufferPtr) : xmlSecSize; cdecl; external XMLSEC_SO;
  function xmlSecBufferInitialize (buf: xmlSecBufferPtr; size: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBufferPrepend (buf: xmlSecBufferPtr; const data: xmlSecBytePtr; size: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBufferReadFile (buf: xmlSecBufferPtr; const filename: PChar) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBufferRemoveHead (buf: xmlSecBufferPtr; size: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBufferRemoveTail (buf: xmlSecBufferPtr; size: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBufferSetData (buf: xmlSecBufferPtr; const data: xmlSecBytePtr; size: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecBufferSetDefaultAllocMode (defAllocMode: xmlSecAllocMode; defInitialSize: xmlSecSize); cdecl; external XMLSEC_SO;
  function xmlSecBufferSetMaxSize (buf: xmlSecBufferPtr; size: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecBufferSetSize (buf: xmlSecBufferPtr; size: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecCheckNodeName (const cur: xmlNodePtr; const name: PChar; const ns: PChar) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecCheckVersionExt (major: Longint; minor: Longint; subminor: Longint; mode: xmlSecCheckVersionMode) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecCreateTree (const rootNodeName: PChar; const rootNodeNs: PChar) : xmlDocPtr; cdecl; external XMLSEC_SO;
  function xmlSecCryptoAppDefaultKeysMngrAdoptKey (mngr: xmlSecKeysMngrPtr; key: xmlSecKeyPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecCryptoAppDefaultKeysMngrInit (mngr: xmlSecKeysMngrPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecCryptoAppDefaultKeysMngrLoad (mngr: xmlSecKeysMngrPtr; const uri: PChar) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecCryptoAppDefaultKeysMngrSave (mngr: xmlSecKeysMngrPtr; const filename: PChar; type_: xmlSecKeyDataType) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecCryptoAppGetDefaultPwdCallback () : Pointer; cdecl; external XMLSEC_SO;
  function xmlSecCryptoAppInit (const config: PChar) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecCryptoAppKeyCertLoad (key: xmlSecKeyPtr; const filename: PChar; format: xmlSecKeyDataFormat) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecCryptoAppKeyCertLoadMemory (key: xmlSecKeyPtr; const data: xmlSecBytePtr; dataSize: xmlSecSize; format: xmlSecKeyDataFormat) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecCryptoAppKeyLoad (const filename: PChar; format: xmlSecKeyDataFormat; const pwd: PChar; pwdCallback: Pointer; pwdCallbackCtx: Pointer) : xmlSecKeyPtr; cdecl; external XMLSEC_SO;
  function xmlSecCryptoAppKeyLoadMemory (const data: xmlSecBytePtr; dataSize: xmlSecSize; format: xmlSecKeyDataFormat; const pwd: PChar; pwdCallback: Pointer; pwdCallbackCtx: Pointer) : xmlSecKeyPtr; cdecl; external XMLSEC_SO;
  function xmlSecCryptoAppKeysMngrCertLoad (mngr: xmlSecKeysMngrPtr; const filename: PChar; format: xmlSecKeyDataFormat; type_: xmlSecKeyDataType) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecCryptoAppKeysMngrCertLoadMemory (mngr: xmlSecKeysMngrPtr; const data: xmlSecBytePtr; dataSize: xmlSecSize; format: xmlSecKeyDataFormat; type_: xmlSecKeyDataType) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecCryptoAppPkcs12Load (const filename: PChar; const pwd: PChar; pwdCallback: Pointer; pwdCallbackCtx: Pointer) : xmlSecKeyPtr; cdecl; external XMLSEC_SO;
  function xmlSecCryptoAppPkcs12LoadMemory (const data: xmlSecBytePtr; dataSize: xmlSecSize; const pwd: PChar; pwdCallback: Pointer; pwdCallbackCtx: Pointer) : xmlSecKeyPtr; cdecl; external XMLSEC_SO;
  function xmlSecCryptoAppShutdown () : Longint; cdecl; external XMLSEC_SO;
  function xmlSecCryptoDLFunctionsRegisterKeyDataAndTransforms (functions: xmlSecCryptoDLFunctionsPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecCryptoDLGetFunctions () : xmlSecCryptoDLFunctionsPtr; cdecl; external XMLSEC_SO;
  function xmlSecCryptoDLGetLibraryFunctions (const crypto: PChar) : xmlSecCryptoDLFunctionsPtr; cdecl; external XMLSEC_SO;
  function xmlSecCryptoDLInit () : Longint; cdecl; external XMLSEC_SO;
  function xmlSecCryptoDLLoadLibrary (const crypto: PChar) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecCryptoDLSetFunctions (functions: xmlSecCryptoDLFunctionsPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecCryptoDLShutdown () : Longint; cdecl; external XMLSEC_SO;
  function xmlSecCryptoDLUnloadLibrary (const crypto: PChar) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecCryptoInit () : Longint; cdecl; external XMLSEC_SO;
  function xmlSecCryptoKeysMngrInit (mngr: xmlSecKeysMngrPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecCryptoShutdown () : Longint; cdecl; external XMLSEC_SO;
  function xmlSecDSigCtxCreate (keysMngr: xmlSecKeysMngrPtr) : xmlSecDSigCtxPtr; cdecl; external XMLSEC_SO;
  procedure xmlSecDSigCtxDebugDump (dsigCtx: xmlSecDSigCtxPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecDSigCtxDebugXmlDump (dsigCtx: xmlSecDSigCtxPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecDSigCtxDestroy (dsigCtx: xmlSecDSigCtxPtr); cdecl; external XMLSEC_SO;
  function xmlSecDSigCtxEnableReferenceTransform (dsigCtx: xmlSecDSigCtxPtr; transformId: xmlSecTransformId) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecDSigCtxEnableSignatureTransform (dsigCtx: xmlSecDSigCtxPtr; transformId: xmlSecTransformId) : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecDSigCtxFinalize (dsigCtx: xmlSecDSigCtxPtr); cdecl; external XMLSEC_SO;
  function xmlSecDSigCtxGetPreSignBuffer (dsigCtx: xmlSecDSigCtxPtr) : xmlSecBufferPtr; cdecl; external XMLSEC_SO;
  function xmlSecDSigCtxInitialize (dsigCtx: xmlSecDSigCtxPtr; keysMngr: xmlSecKeysMngrPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecDSigCtxSign (dsigCtx: xmlSecDSigCtxPtr; tmpl: xmlNodePtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecDSigCtxVerify (dsigCtx: xmlSecDSigCtxPtr; node: xmlNodePtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecDSigReferenceCtxCreate (dsigCtx: xmlSecDSigCtxPtr; origin: xmlSecDSigReferenceOrigin) : xmlSecDSigReferenceCtxPtr; cdecl; external XMLSEC_SO;
  procedure xmlSecDSigReferenceCtxDebugDump (dsigRefCtx: xmlSecDSigReferenceCtxPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecDSigReferenceCtxDebugXmlDump (dsigRefCtx: xmlSecDSigReferenceCtxPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecDSigReferenceCtxDestroy (dsigRefCtx: xmlSecDSigReferenceCtxPtr); cdecl; external XMLSEC_SO;
  procedure xmlSecDSigReferenceCtxFinalize (dsigRefCtx: xmlSecDSigReferenceCtxPtr); cdecl; external XMLSEC_SO;
  function xmlSecDSigReferenceCtxGetPreDigestBuffer (dsigRefCtx: xmlSecDSigReferenceCtxPtr) : xmlSecBufferPtr; cdecl; external XMLSEC_SO;
  function xmlSecDSigReferenceCtxInitialize (dsigRefCtx: xmlSecDSigReferenceCtxPtr; dsigCtx: xmlSecDSigCtxPtr; origin: xmlSecDSigReferenceOrigin) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecDSigReferenceCtxListGetKlass () : xmlSecPtrListId; cdecl; external XMLSEC_SO;
  function xmlSecDSigReferenceCtxProcessNode (dsigRefCtx: xmlSecDSigReferenceCtxPtr; node: xmlNodePtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecEncCtxBinaryEncrypt (encCtx: xmlSecEncCtxPtr; tmpl: xmlNodePtr; const data: xmlSecBytePtr; dataSize: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecEncCtxCopyUserPref (dst: xmlSecEncCtxPtr; src: xmlSecEncCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecEncCtxCreate (keysMngr: xmlSecKeysMngrPtr) : xmlSecEncCtxPtr; cdecl; external XMLSEC_SO;
  procedure xmlSecEncCtxDebugDump (encCtx: xmlSecEncCtxPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecEncCtxDebugXmlDump (encCtx: xmlSecEncCtxPtr; output: PFILE); cdecl; external XMLSEC_SO;
  function xmlSecEncCtxDecrypt (encCtx: xmlSecEncCtxPtr; node: xmlNodePtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecEncCtxDecryptToBuffer (encCtx: xmlSecEncCtxPtr; node: xmlNodePtr) : xmlSecBufferPtr; cdecl; external XMLSEC_SO;
  procedure xmlSecEncCtxDestroy (encCtx: xmlSecEncCtxPtr); cdecl; external XMLSEC_SO;
  procedure xmlSecEncCtxFinalize (encCtx: xmlSecEncCtxPtr); cdecl; external XMLSEC_SO;
  function xmlSecEncCtxInitialize (encCtx: xmlSecEncCtxPtr; keysMngr: xmlSecKeysMngrPtr) : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecEncCtxReset (encCtx: xmlSecEncCtxPtr); cdecl; external XMLSEC_SO;
  function xmlSecEncCtxUriEncrypt (encCtx: xmlSecEncCtxPtr; tmpl: xmlNodePtr; const uri: PChar) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecEncCtxXmlEncrypt (encCtx: xmlSecEncCtxPtr; tmpl: xmlNodePtr; node: xmlNodePtr) : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecError (const file_: PChar; line: Longint; const func: PChar; const errorObject: PChar; const errorSubject: PChar; reason: Longint; const msg: PChar); cdecl; varargs; external XMLSEC_SO;
  procedure xmlSecErrorsDefaultCallback (const file_: PChar; line: Longint; const func: PChar; const errorObject: PChar; const errorSubject: PChar; reason: Longint; const msg: PChar); cdecl; external XMLSEC_SO;
  procedure xmlSecErrorsDefaultCallbackEnableOutput (enabled: Longint); cdecl; external XMLSEC_SO;
  function xmlSecErrorsGetCode (pos: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecErrorsGetMsg (pos: xmlSecSize) : PChar; cdecl; external XMLSEC_SO;
  procedure xmlSecErrorsInit (); cdecl; external XMLSEC_SO;
  procedure xmlSecErrorsSetCallback (callback: xmlSecErrorsCallback); cdecl; external XMLSEC_SO;
  procedure xmlSecErrorsShutdown (); cdecl; external XMLSEC_SO;
  function xmlSecFindChild (const parent: xmlNodePtr; const name: PChar; const ns: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecFindNode (const parent: xmlNodePtr; const name: PChar; const ns: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecFindParent (const cur: xmlNodePtr; const name: PChar; const ns: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecGenerateAndAddID (node: xmlNodePtr; const attrName: PChar; const prefix: PChar; len: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecGenerateID (const prefix: PChar; len: xmlSecSize) : PChar; cdecl; external XMLSEC_SO;
  function xmlSecGetNextElementNode (cur: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecGetNodeNsHref (const cur: xmlNodePtr) : PChar; cdecl; external XMLSEC_SO;
  function xmlSecGetQName (node: xmlNodePtr; const href: PChar; const local: PChar) : PChar; cdecl; external XMLSEC_SO;
  procedure xmlSecIOCleanupCallbacks (); cdecl; external XMLSEC_SO;
  function xmlSecIOInit () : Longint; cdecl; external XMLSEC_SO;
  function xmlSecIORegisterCallbacks (matchFunc: xmlInputMatchCallback; openFunc: xmlInputOpenCallback; readFunc: xmlInputReadCallback; closeFunc: xmlInputCloseCallback) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecIORegisterDefaultCallbacks () : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecIOShutdown (); cdecl; external XMLSEC_SO;
  function xmlSecInit () : Longint; cdecl; external XMLSEC_SO;
  function xmlSecIsEmptyNode (node: xmlNodePtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecIsEmptyString (const str: PChar) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyAdoptData (key: xmlSecKeyPtr; data: xmlSecKeyDataPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyCopy (keyDst: xmlSecKeyPtr; keySrc: xmlSecKeyPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyCreate () : xmlSecKeyPtr; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataAesGetKlass () : xmlSecKeyDataId; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataBinRead (id: xmlSecKeyDataId; key: xmlSecKeyPtr; const buf: xmlSecBytePtr; bufSize: xmlSecSize; keyInfoCtx: xmlSecKeyInfoCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataBinWrite (id: xmlSecKeyDataId; key: xmlSecKeyPtr; buf: xmlSecBytePtrPtr; bufSize: xmlSecSizePtr; keyInfoCtx: xmlSecKeyInfoCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataBinaryValueBinRead (id: xmlSecKeyDataId; key: xmlSecKeyPtr; const buf: xmlSecBytePtr; bufSize: xmlSecSize; keyInfoCtx: xmlSecKeyInfoCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataBinaryValueBinWrite (id: xmlSecKeyDataId; key: xmlSecKeyPtr; buf: xmlSecBytePtrPtr; bufSize: xmlSecSizePtr; keyInfoCtx: xmlSecKeyInfoCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecKeyDataBinaryValueDebugDump (data: xmlSecKeyDataPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecKeyDataBinaryValueDebugXmlDump (data: xmlSecKeyDataPtr; output: PFILE); cdecl; external XMLSEC_SO;
  function xmlSecKeyDataBinaryValueDuplicate (dst: xmlSecKeyDataPtr; src: xmlSecKeyDataPtr) : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecKeyDataBinaryValueFinalize (data: xmlSecKeyDataPtr); cdecl; external XMLSEC_SO;
  function xmlSecKeyDataBinaryValueGetBuffer (data: xmlSecKeyDataPtr) : xmlSecBufferPtr; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataBinaryValueGetSize (data: xmlSecKeyDataPtr) : xmlSecSize; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataBinaryValueInitialize (data: xmlSecKeyDataPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataBinaryValueSetBuffer (data: xmlSecKeyDataPtr; const buf: xmlSecBytePtr; bufSize: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataBinaryValueXmlRead (id: xmlSecKeyDataId; key: xmlSecKeyPtr; node: xmlNodePtr; keyInfoCtx: xmlSecKeyInfoCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataBinaryValueXmlWrite (id: xmlSecKeyDataId; key: xmlSecKeyPtr; node: xmlNodePtr; keyInfoCtx: xmlSecKeyInfoCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataCreate (id: xmlSecKeyDataId) : xmlSecKeyDataPtr; cdecl; external XMLSEC_SO;
  procedure xmlSecKeyDataDebugDump (data: xmlSecKeyDataPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecKeyDataDebugXmlDump (data: xmlSecKeyDataPtr; output: PFILE); cdecl; external XMLSEC_SO;
  function xmlSecKeyDataDesGetKlass () : xmlSecKeyDataId; cdecl; external XMLSEC_SO;
  procedure xmlSecKeyDataDestroy (data: xmlSecKeyDataPtr); cdecl; external XMLSEC_SO;
  function xmlSecKeyDataDsaGetKlass () : xmlSecKeyDataId; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataDuplicate (data: xmlSecKeyDataPtr) : xmlSecKeyDataPtr; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataEncryptedKeyGetKlass () : xmlSecKeyDataId; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataGenerate (data: xmlSecKeyDataPtr; sizeBits: xmlSecSize; type_: xmlSecKeyDataType) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataGetIdentifier (data: xmlSecKeyDataPtr) : PChar; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataGetSize (data: xmlSecKeyDataPtr) : xmlSecSize; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataGetType (data: xmlSecKeyDataPtr) : xmlSecKeyDataType; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataHmacGetKlass () : xmlSecKeyDataId; cdecl; external XMLSEC_SO;
  procedure xmlSecKeyDataIdListDebugDump (list: xmlSecPtrListPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecKeyDataIdListDebugXmlDump (list: xmlSecPtrListPtr; output: PFILE); cdecl; external XMLSEC_SO;
  function xmlSecKeyDataIdListFind (list: xmlSecPtrListPtr; dataId: xmlSecKeyDataId) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataIdListFindByHref (list: xmlSecPtrListPtr; const href: PChar; usage: xmlSecKeyDataUsage) : xmlSecKeyDataId; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataIdListFindByName (list: xmlSecPtrListPtr; const name: PChar; usage: xmlSecKeyDataUsage) : xmlSecKeyDataId; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataIdListFindByNode (list: xmlSecPtrListPtr; const nodeName: PChar; const nodeNs: PChar; usage: xmlSecKeyDataUsage) : xmlSecKeyDataId; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataIdListGetKlass () : xmlSecPtrListId; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataIdsGet () : xmlSecPtrListPtr; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataIdsInit () : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataIdsRegister (id: xmlSecKeyDataId) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataIdsRegisterDefault () : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecKeyDataIdsShutdown (); cdecl; external XMLSEC_SO;
  function xmlSecKeyDataListGetKlass () : xmlSecPtrListId; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataNameGetKlass () : xmlSecKeyDataId; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataRawX509CertGetKlass () : xmlSecKeyDataId; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataRetrievalMethodGetKlass () : xmlSecKeyDataId; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataRsaGetKlass () : xmlSecKeyDataId; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataStoreCreate (id: xmlSecKeyDataStoreId) : xmlSecKeyDataStorePtr; cdecl; external XMLSEC_SO;
  procedure xmlSecKeyDataStoreDestroy (store: xmlSecKeyDataStorePtr); cdecl; external XMLSEC_SO;
  function xmlSecKeyDataStorePtrListGetKlass () : xmlSecPtrListId; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataValueGetKlass () : xmlSecKeyDataId; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataX509GetKlass () : xmlSecKeyDataId; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataXmlRead (id: xmlSecKeyDataId; key: xmlSecKeyPtr; node: xmlNodePtr; keyInfoCtx: xmlSecKeyInfoCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyDataXmlWrite (id: xmlSecKeyDataId; key: xmlSecKeyPtr; node: xmlNodePtr; keyInfoCtx: xmlSecKeyInfoCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecKeyDebugDump (key: xmlSecKeyPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecKeyDebugXmlDump (key: xmlSecKeyPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecKeyDestroy (key: xmlSecKeyPtr); cdecl; external XMLSEC_SO;
  function xmlSecKeyDuplicate (key: xmlSecKeyPtr) : xmlSecKeyPtr; cdecl; external XMLSEC_SO;
  procedure xmlSecKeyEmpty (key: xmlSecKeyPtr); cdecl; external XMLSEC_SO;
  function xmlSecKeyEnsureData (key: xmlSecKeyPtr; dataId: xmlSecKeyDataId) : xmlSecKeyDataPtr; cdecl; external XMLSEC_SO;
  function xmlSecKeyGenerate (dataId: xmlSecKeyDataId; sizeBits: xmlSecSize; type_: xmlSecKeyDataType) : xmlSecKeyPtr; cdecl; external XMLSEC_SO;
  function xmlSecKeyGenerateByName (const name: PChar; sizeBits: xmlSecSize; type_: xmlSecKeyDataType) : xmlSecKeyPtr; cdecl; external XMLSEC_SO;
  function xmlSecKeyGetData (key: xmlSecKeyPtr; dataId: xmlSecKeyDataId) : xmlSecKeyDataPtr; cdecl; external XMLSEC_SO;
  function xmlSecKeyGetName (key: xmlSecKeyPtr) : PChar; cdecl; external XMLSEC_SO;
  function xmlSecKeyGetType (key: xmlSecKeyPtr) : xmlSecKeyDataType; cdecl; external XMLSEC_SO;
  function xmlSecKeyGetValue (key: xmlSecKeyPtr) : xmlSecKeyDataPtr; cdecl; external XMLSEC_SO;
  function xmlSecKeyInfoCtxCopyUserPref (dst: xmlSecKeyInfoCtxPtr; src: xmlSecKeyInfoCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyInfoCtxCreate (keysMngr: xmlSecKeysMngrPtr) : xmlSecKeyInfoCtxPtr; cdecl; external XMLSEC_SO;
  function xmlSecKeyInfoCtxCreateEncCtx (keyInfoCtx: xmlSecKeyInfoCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecKeyInfoCtxDebugDump (keyInfoCtx: xmlSecKeyInfoCtxPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecKeyInfoCtxDebugXmlDump (keyInfoCtx: xmlSecKeyInfoCtxPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecKeyInfoCtxDestroy (keyInfoCtx: xmlSecKeyInfoCtxPtr); cdecl; external XMLSEC_SO;
  procedure xmlSecKeyInfoCtxFinalize (keyInfoCtx: xmlSecKeyInfoCtxPtr); cdecl; external XMLSEC_SO;
  function xmlSecKeyInfoCtxInitialize (keyInfoCtx: xmlSecKeyInfoCtxPtr; keysMngr: xmlSecKeysMngrPtr) : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecKeyInfoCtxReset (keyInfoCtx: xmlSecKeyInfoCtxPtr); cdecl; external XMLSEC_SO;
  function xmlSecKeyInfoNodeRead (keyInfoNode: xmlNodePtr; key: xmlSecKeyPtr; keyInfoCtx: xmlSecKeyInfoCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyInfoNodeWrite (keyInfoNode: xmlNodePtr; key: xmlSecKeyPtr; keyInfoCtx: xmlSecKeyInfoCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyMatch (key: xmlSecKeyPtr; const name: PChar; keyReq: xmlSecKeyReqPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyPtrListGetKlass () : xmlSecPtrListId; cdecl; external XMLSEC_SO;
  function xmlSecKeyReadBinaryFile (dataId: xmlSecKeyDataId; const filename: PChar) : xmlSecKeyPtr; cdecl; external XMLSEC_SO;
  function xmlSecKeyReadBuffer (dataId: xmlSecKeyDataId; buffer: xmlSecBufferPtr) : xmlSecKeyPtr; cdecl; external XMLSEC_SO;
  function xmlSecKeyReadMemory (dataId: xmlSecKeyDataId; const data: xmlSecBytePtr; dataSize: xmlSecSize) : xmlSecKeyPtr; cdecl; external XMLSEC_SO;
  function xmlSecKeyReqCopy (dst: xmlSecKeyReqPtr; src: xmlSecKeyReqPtr) : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecKeyReqDebugDump (keyReq: xmlSecKeyReqPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecKeyReqDebugXmlDump (keyReq: xmlSecKeyReqPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecKeyReqFinalize (keyReq: xmlSecKeyReqPtr); cdecl; external XMLSEC_SO;
  function xmlSecKeyReqInitialize (keyReq: xmlSecKeyReqPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyReqMatchKey (keyReq: xmlSecKeyReqPtr; key: xmlSecKeyPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyReqMatchKeyValue (keyReq: xmlSecKeyReqPtr; value: xmlSecKeyDataPtr) : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecKeyReqReset (keyReq: xmlSecKeyReqPtr); cdecl; external XMLSEC_SO;
  function xmlSecKeySetName (key: xmlSecKeyPtr; const name: PChar) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeySetValue (key: xmlSecKeyPtr; value: xmlSecKeyDataPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyStoreCreate (id: xmlSecKeyStoreId) : xmlSecKeyStorePtr; cdecl; external XMLSEC_SO;
  procedure xmlSecKeyStoreDestroy (store: xmlSecKeyStorePtr); cdecl; external XMLSEC_SO;
  function xmlSecKeyStoreFindKey (store: xmlSecKeyStorePtr; const name: PChar; keyInfoCtx: xmlSecKeyInfoCtxPtr) : xmlSecKeyPtr; cdecl; external XMLSEC_SO;
  function xmlSecKeyUseWithCopy (dst: xmlSecKeyUseWithPtr; src: xmlSecKeyUseWithPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyUseWithCreate (const application: PChar; const identifier: PChar) : xmlSecKeyUseWithPtr; cdecl; external XMLSEC_SO;
  procedure xmlSecKeyUseWithDebugDump (keyUseWith: xmlSecKeyUseWithPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecKeyUseWithDebugXmlDump (keyUseWith: xmlSecKeyUseWithPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecKeyUseWithDestroy (keyUseWith: xmlSecKeyUseWithPtr); cdecl; external XMLSEC_SO;
  function xmlSecKeyUseWithDuplicate (keyUseWith: xmlSecKeyUseWithPtr) : xmlSecKeyUseWithPtr; cdecl; external XMLSEC_SO;
  procedure xmlSecKeyUseWithFinalize (keyUseWith: xmlSecKeyUseWithPtr); cdecl; external XMLSEC_SO;
  function xmlSecKeyUseWithInitialize (keyUseWith: xmlSecKeyUseWithPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeyUseWithPtrListGetKlass () : xmlSecPtrListId; cdecl; external XMLSEC_SO;
  procedure xmlSecKeyUseWithReset (keyUseWith: xmlSecKeyUseWithPtr); cdecl; external XMLSEC_SO;
  function xmlSecKeyUseWithSet (keyUseWith: xmlSecKeyUseWithPtr; const application: PChar; const identifier: PChar) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeysMngrAdoptDataStore (mngr: xmlSecKeysMngrPtr; store: xmlSecKeyDataStorePtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeysMngrAdoptKeysStore (mngr: xmlSecKeysMngrPtr; store: xmlSecKeyStorePtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecKeysMngrCreate () : xmlSecKeysMngrPtr; cdecl; external XMLSEC_SO;
  procedure xmlSecKeysMngrDestroy (mngr: xmlSecKeysMngrPtr); cdecl; external XMLSEC_SO;
  function xmlSecKeysMngrFindKey (mngr: xmlSecKeysMngrPtr; const name: PChar; keyInfoCtx: xmlSecKeyInfoCtxPtr) : xmlSecKeyPtr; cdecl; external XMLSEC_SO;
  function xmlSecKeysMngrGetDataStore (mngr: xmlSecKeysMngrPtr; id: xmlSecKeyDataStoreId) : xmlSecKeyDataStorePtr; cdecl; external XMLSEC_SO;
  function xmlSecKeysMngrGetKey (keyInfoNode: xmlNodePtr; keyInfoCtx: xmlSecKeyInfoCtxPtr) : xmlSecKeyPtr; cdecl; external XMLSEC_SO;
  function xmlSecKeysMngrGetKeysStore (mngr: xmlSecKeysMngrPtr) : xmlSecKeyStorePtr; cdecl; external XMLSEC_SO;
  function xmlSecNodeSetAdd (nset: xmlSecNodeSetPtr; newNSet: xmlSecNodeSetPtr; op: xmlSecNodeSetOp) : xmlSecNodeSetPtr; cdecl; external XMLSEC_SO;
  function xmlSecNodeSetAddList (nset: xmlSecNodeSetPtr; newNSet: xmlSecNodeSetPtr; op: xmlSecNodeSetOp) : xmlSecNodeSetPtr; cdecl; external XMLSEC_SO;
  function xmlSecNodeSetContains (nset: xmlSecNodeSetPtr; node: xmlNodePtr; parent: xmlNodePtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecNodeSetCreate (doc: xmlDocPtr; nodes: xmlNodeSetPtr; type_: xmlSecNodeSetType) : xmlSecNodeSetPtr; cdecl; external XMLSEC_SO;
  procedure xmlSecNodeSetDebugDump (nset: xmlSecNodeSetPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecNodeSetDestroy (nset: xmlSecNodeSetPtr); cdecl; external XMLSEC_SO;
  procedure xmlSecNodeSetDocDestroy (nset: xmlSecNodeSetPtr); cdecl; external XMLSEC_SO;
  function xmlSecNodeSetDumpTextNodes (nset: xmlSecNodeSetPtr; out_: xmlOutputBufferPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecNodeSetGetChildren (doc: xmlDocPtr; const parent: xmlNodePtr; withComments: Longint; invert: Longint) : xmlSecNodeSetPtr; cdecl; external XMLSEC_SO;
  function xmlSecNodeSetWalk (nset: xmlSecNodeSetPtr; walkFunc: xmlSecNodeSetWalkCallback; data: Pointer) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecParseFile (const filename: PChar) : xmlDocPtr; cdecl; external XMLSEC_SO;
  function xmlSecParseMemory (const buffer: xmlSecBytePtr; size: xmlSecSize; recovery: Longint) : xmlDocPtr; cdecl; external XMLSEC_SO;
  function xmlSecParseMemoryExt (const prefix: xmlSecBytePtr; prefixSize: xmlSecSize; const buffer: xmlSecBytePtr; bufferSize: xmlSecSize; const postfix: xmlSecBytePtr; postfixSize: xmlSecSize) : xmlDocPtr; cdecl; external XMLSEC_SO;
  function xmlSecPtrListAdd (list: xmlSecPtrListPtr; item: xmlSecPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecPtrListCopy (dst: xmlSecPtrListPtr; src: xmlSecPtrListPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecPtrListCreate (id: xmlSecPtrListId) : xmlSecPtrListPtr; cdecl; external XMLSEC_SO;
  procedure xmlSecPtrListDebugDump (list: xmlSecPtrListPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecPtrListDebugXmlDump (list: xmlSecPtrListPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecPtrListDestroy (list: xmlSecPtrListPtr); cdecl; external XMLSEC_SO;
  function xmlSecPtrListDuplicate (list: xmlSecPtrListPtr) : xmlSecPtrListPtr; cdecl; external XMLSEC_SO;
  procedure xmlSecPtrListEmpty (list: xmlSecPtrListPtr); cdecl; external XMLSEC_SO;
  procedure xmlSecPtrListFinalize (list: xmlSecPtrListPtr); cdecl; external XMLSEC_SO;
  function xmlSecPtrListGetItem (list: xmlSecPtrListPtr; pos: xmlSecSize) : xmlSecPtr; cdecl; external XMLSEC_SO;
  function xmlSecPtrListGetSize (list: xmlSecPtrListPtr) : xmlSecSize; cdecl; external XMLSEC_SO;
  function xmlSecPtrListInitialize (list: xmlSecPtrListPtr; id: xmlSecPtrListId) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecPtrListRemove (list: xmlSecPtrListPtr; pos: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecPtrListSet (list: xmlSecPtrListPtr; item: xmlSecPtr; pos: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecPtrListSetDefaultAllocMode (defAllocMode: xmlSecAllocMode; defInitialSize: xmlSecSize); cdecl; external XMLSEC_SO;
  procedure xmlSecQName2BitMaskDebugDump (info: xmlSecQName2BitMaskInfoPtr; mask: xmlSecBitMask; const name: PChar; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecQName2BitMaskDebugXmlDump (info: xmlSecQName2BitMaskInfoPtr; mask: xmlSecBitMask; const name: PChar; output: PFILE); cdecl; external XMLSEC_SO;
  function xmlSecQName2BitMaskGetBitMask (info: xmlSecQName2BitMaskInfoPtr; const qnameLocalPart: PChar; const qnameHref: PChar; mask: xmlSecBitMaskPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecQName2BitMaskGetBitMaskFromString (info: xmlSecQName2BitMaskInfoPtr; node: xmlNodePtr; const qname: PChar; mask: xmlSecBitMaskPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecQName2BitMaskGetInfo (info: xmlSecQName2BitMaskInfoPtr; mask: xmlSecBitMask) : xmlSecQName2BitMaskInfoPtr; cdecl; external XMLSEC_SO;
  function xmlSecQName2BitMaskGetStringFromBitMask (info: xmlSecQName2BitMaskInfoPtr; node: xmlNodePtr; mask: xmlSecBitMask) : PChar; cdecl; external XMLSEC_SO;
  function xmlSecQName2BitMaskNodesRead (info: xmlSecQName2BitMaskInfoPtr; node: xmlNodePtrPtr; const nodeName: PChar; const nodeNs: PChar; stopOnUnknown: Longint; mask: xmlSecBitMaskPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecQName2BitMaskNodesWrite (info: xmlSecQName2BitMaskInfoPtr; node: xmlNodePtr; const nodeName: PChar; const nodeNs: PChar; mask: xmlSecBitMask) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecQName2IntegerAttributeRead (info: xmlSecQName2IntegerInfoPtr; node: xmlNodePtr; const attrName: PChar; intValue: PInteger) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecQName2IntegerAttributeWrite (info: xmlSecQName2IntegerInfoPtr; node: xmlNodePtr; const attrName: PChar; intValue: Longint) : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecQName2IntegerDebugDump (info: xmlSecQName2IntegerInfoPtr; intValue: Longint; const name: PChar; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecQName2IntegerDebugXmlDump (info: xmlSecQName2IntegerInfoPtr; intValue: Longint; const name: PChar; output: PFILE); cdecl; external XMLSEC_SO;
  function xmlSecQName2IntegerGetInfo (info: xmlSecQName2IntegerInfoPtr; intValue: Longint) : xmlSecQName2IntegerInfoPtr; cdecl; external XMLSEC_SO;
  function xmlSecQName2IntegerGetInteger (info: xmlSecQName2IntegerInfoPtr; const qnameHref: PChar; const qnameLocalPart: PChar; intValue: PInteger) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecQName2IntegerGetIntegerFromString (info: xmlSecQName2IntegerInfoPtr; node: xmlNodePtr; const qname: PChar; intValue: PInteger) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecQName2IntegerGetStringFromInteger (info: xmlSecQName2IntegerInfoPtr; node: xmlNodePtr; intValue: Longint) : PChar; cdecl; external XMLSEC_SO;
  function xmlSecQName2IntegerNodeRead (info: xmlSecQName2IntegerInfoPtr; node: xmlNodePtr; intValue: PInteger) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecQName2IntegerNodeWrite (info: xmlSecQName2IntegerInfoPtr; node: xmlNodePtr; const nodeName: PChar; const nodeNs: PChar; intValue: Longint) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecReplaceContent (node: xmlNodePtr; newNode: xmlNodePtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecReplaceNode (node: xmlNodePtr; newNode: xmlNodePtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecReplaceNodeBuffer (node: xmlNodePtr; const buffer: xmlSecBytePtr; size: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecShutdown () : Longint; cdecl; external XMLSEC_SO;
  function xmlSecSimpleKeysStoreAdoptKey (store: xmlSecKeyStorePtr; key: xmlSecKeyPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecSimpleKeysStoreGetKeys (store: xmlSecKeyStorePtr) : xmlSecPtrListPtr; cdecl; external XMLSEC_SO;
  function xmlSecSimpleKeysStoreGetKlass () : xmlSecKeyStoreId; cdecl; external XMLSEC_SO;
  function xmlSecSimpleKeysStoreLoad (store: xmlSecKeyStorePtr; const uri: PChar; keysMngr: xmlSecKeysMngrPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecSimpleKeysStoreSave (store: xmlSecKeyStorePtr; const filename: PChar; type_: xmlSecKeyDataType) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecSoap11AddBodyEntry (envNode: xmlNodePtr; entryNode: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecSoap11AddFaultEntry (envNode: xmlNodePtr; const faultCodeHref: PChar; const faultCodeLocalPart: PChar; const faultString: PChar; const faultActor: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecSoap11CheckEnvelope (envNode: xmlNodePtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecSoap11CreateEnvelope (doc: xmlDocPtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecSoap11EnsureHeader (envNode: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecSoap11GetBody (envNode: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecSoap11GetBodyEntriesNumber (envNode: xmlNodePtr) : xmlSecSize; cdecl; external XMLSEC_SO;
  function xmlSecSoap11GetBodyEntry (envNode: xmlNodePtr; pos: xmlSecSize) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecSoap11GetFaultEntry (envNode: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecSoap11GetHeader (envNode: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecSoap12AddBodyEntry (envNode: xmlNodePtr; entryNode: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecSoap12AddFaultDetailEntry (faultNode: xmlNodePtr; detailEntryNode: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecSoap12AddFaultEntry (envNode: xmlNodePtr; faultCode: xmlSecSoap12FaultCode; const faultReasonText: PChar; const faultReasonLang: PChar; const faultNodeURI: PChar; const faultRole: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecSoap12AddFaultReasonText (faultNode: xmlNodePtr; const faultReasonText: PChar; const faultReasonLang: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecSoap12AddFaultSubcode (faultNode: xmlNodePtr; const subCodeHref: PChar; const subCodeName: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecSoap12CheckEnvelope (envNode: xmlNodePtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecSoap12CreateEnvelope (doc: xmlDocPtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecSoap12EnsureHeader (envNode: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecSoap12GetBody (envNode: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecSoap12GetBodyEntriesNumber (envNode: xmlNodePtr) : xmlSecSize; cdecl; external XMLSEC_SO;
  function xmlSecSoap12GetBodyEntry (envNode: xmlNodePtr; pos: xmlSecSize) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecSoap12GetFaultEntry (envNode: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecSoap12GetHeader (envNode: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecStringListGetKlass () : xmlSecPtrListId; cdecl; external XMLSEC_SO;
  function xmlSecTmplCipherReferenceAddTransform (cipherReferenceNode: xmlNodePtr; transformId: xmlSecTransformId) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplEncDataAddEncProperty (encNode: xmlNodePtr; const id: PChar; const target: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplEncDataCreate (doc: xmlDocPtr; encMethodId: xmlSecTransformId; const id: PChar; const type_: PChar; const mimeType: PChar; const encoding: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplEncDataEnsureCipherReference (encNode: xmlNodePtr; const uri: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplEncDataEnsureCipherValue (encNode: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplEncDataEnsureEncProperties (encNode: xmlNodePtr; const id: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplEncDataEnsureKeyInfo (encNode: xmlNodePtr; const id: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplEncDataGetEncMethodNode (encNode: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplKeyInfoAddEncryptedKey (keyInfoNode: xmlNodePtr; encMethodId: xmlSecTransformId; const id: PChar; const type_: PChar; const recipient: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplKeyInfoAddKeyName (keyInfoNode: xmlNodePtr; const name: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplKeyInfoAddKeyValue (keyInfoNode: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplKeyInfoAddRetrievalMethod (keyInfoNode: xmlNodePtr; const uri: PChar; const type_: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplKeyInfoAddX509Data (keyInfoNode: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplManifestAddReference (manifestNode: xmlNodePtr; digestMethodId: xmlSecTransformId; const id: PChar; const uri: PChar; const type_: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplObjectAddManifest (objectNode: xmlNodePtr; const id: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplObjectAddSignProperties (objectNode: xmlNodePtr; const id: PChar; const target: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplReferenceAddTransform (referenceNode: xmlNodePtr; transformId: xmlSecTransformId) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplReferenceListAddDataReference (encNode: xmlNodePtr; const uri: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplReferenceListAddKeyReference (encNode: xmlNodePtr; const uri: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplRetrievalMethodAddTransform (retrMethodNode: xmlNodePtr; transformId: xmlSecTransformId) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplSignatureAddObject (signNode: xmlNodePtr; const id: PChar; const mimeType: PChar; const encoding: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplSignatureAddReference (signNode: xmlNodePtr; digestMethodId: xmlSecTransformId; const id: PChar; const uri: PChar; const type_: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplSignatureCreate (doc: xmlDocPtr; c14nMethodId: xmlSecTransformId; signMethodId: xmlSecTransformId; const id: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplSignatureEnsureKeyInfo (signNode: xmlNodePtr; const id: PChar) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplSignatureGetC14NMethodNode (signNode: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplSignatureGetSignMethodNode (signNode: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplTransformAddC14NInclNamespaces (transformNode: xmlNodePtr; const prefixList: PChar) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTmplTransformAddHmacOutputLength (transformNode: xmlNodePtr; bitsLen: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTmplTransformAddRsaOaepParam (transformNode: xmlNodePtr; const buf: xmlSecBytePtr; size: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTmplTransformAddXPath (transformNode: xmlNodePtr; const expression: PChar; const nsList: PPChar) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTmplTransformAddXPath2 (transformNode: xmlNodePtr; const type_: PChar; const expression: PChar; const nsList: PPChar) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTmplTransformAddXPointer (transformNode: xmlNodePtr; const expression: PChar; const nsList: PPChar) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTmplTransformAddXsltStylesheet (transformNode: xmlNodePtr; const xslt: PChar) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTmplX509DataAddCRL (x509DataNode: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplX509DataAddCertificate (x509DataNode: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplX509DataAddIssuerSerial (x509DataNode: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplX509DataAddSKI (x509DataNode: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTmplX509DataAddSubjectName (x509DataNode: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecTransformAes128CbcGetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformAes192CbcGetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformAes256CbcGetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformBase64GetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  procedure xmlSecTransformBase64SetLineSize (transform: xmlSecTransformPtr; lineSize: xmlSecSize); cdecl; external XMLSEC_SO;
  function xmlSecTransformConnect (left: xmlSecTransformPtr; right: xmlSecTransformPtr; transformCtx: xmlSecTransformCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformCreate (id: xmlSecTransformId) : xmlSecTransformPtr; cdecl; external XMLSEC_SO;
  function xmlSecTransformCreateInputBuffer (transform: xmlSecTransformPtr; transformCtx: xmlSecTransformCtxPtr) : xmlParserInputBufferPtr; cdecl; external XMLSEC_SO;
  function xmlSecTransformCreateOutputBuffer (transform: xmlSecTransformPtr; transformCtx: xmlSecTransformCtxPtr) : xmlOutputBufferPtr; cdecl; external XMLSEC_SO;
  function xmlSecTransformCtxAppend (ctx: xmlSecTransformCtxPtr; transform: xmlSecTransformPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformCtxBinaryExecute (ctx: xmlSecTransformCtxPtr; const data: xmlSecBytePtr; dataSize: xmlSecSize) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformCtxCopyUserPref (dst: xmlSecTransformCtxPtr; src: xmlSecTransformCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformCtxCreate () : xmlSecTransformCtxPtr; cdecl; external XMLSEC_SO;
  function xmlSecTransformCtxCreateAndAppend (ctx: xmlSecTransformCtxPtr; id: xmlSecTransformId) : xmlSecTransformPtr; cdecl; external XMLSEC_SO;
  function xmlSecTransformCtxCreateAndPrepend (ctx: xmlSecTransformCtxPtr; id: xmlSecTransformId) : xmlSecTransformPtr; cdecl; external XMLSEC_SO;
  procedure xmlSecTransformCtxDebugDump (ctx: xmlSecTransformCtxPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecTransformCtxDebugXmlDump (ctx: xmlSecTransformCtxPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecTransformCtxDestroy (ctx: xmlSecTransformCtxPtr); cdecl; external XMLSEC_SO;
  function xmlSecTransformCtxExecute (ctx: xmlSecTransformCtxPtr; doc: xmlDocPtr) : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecTransformCtxFinalize (ctx: xmlSecTransformCtxPtr); cdecl; external XMLSEC_SO;
  function xmlSecTransformCtxInitialize (ctx: xmlSecTransformCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformCtxNodeRead (ctx: xmlSecTransformCtxPtr; node: xmlNodePtr; usage: xmlSecTransformUsage) : xmlSecTransformPtr; cdecl; external XMLSEC_SO;
  function xmlSecTransformCtxNodesListRead (ctx: xmlSecTransformCtxPtr; node: xmlNodePtr; usage: xmlSecTransformUsage) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformCtxPrepare (ctx: xmlSecTransformCtxPtr; inputDataType: xmlSecTransformDataType) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformCtxPrepend (ctx: xmlSecTransformCtxPtr; transform: xmlSecTransformPtr) : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecTransformCtxReset (ctx: xmlSecTransformCtxPtr); cdecl; external XMLSEC_SO;
  function xmlSecTransformCtxSetUri (ctx: xmlSecTransformCtxPtr; const uri: PChar; hereNode: xmlNodePtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformCtxUriExecute (ctx: xmlSecTransformCtxPtr; const uri: PChar) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformCtxXmlExecute (ctx: xmlSecTransformCtxPtr; nodes: xmlSecNodeSetPtr) : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecTransformDebugDump (transform: xmlSecTransformPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecTransformDebugXmlDump (transform: xmlSecTransformPtr; output: PFILE); cdecl; external XMLSEC_SO;
  function xmlSecTransformDefaultGetDataType (transform: xmlSecTransformPtr; mode: xmlSecTransformMode; transformCtx: xmlSecTransformCtxPtr) : xmlSecTransformDataType; cdecl; external XMLSEC_SO;
  function xmlSecTransformDefaultPopBin (transform: xmlSecTransformPtr; data: xmlSecBytePtr; maxDataSize: xmlSecSize; dataSize: xmlSecSizePtr; transformCtx: xmlSecTransformCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformDefaultPopXml (transform: xmlSecTransformPtr; nodes: xmlSecNodeSetPtrPtr; transformCtx: xmlSecTransformCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformDefaultPushBin (transform: xmlSecTransformPtr; const data: xmlSecBytePtr; dataSize: xmlSecSize; final: Longint; transformCtx: xmlSecTransformCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformDefaultPushXml (transform: xmlSecTransformPtr; nodes: xmlSecNodeSetPtr; transformCtx: xmlSecTransformCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformDes3CbcGetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  procedure xmlSecTransformDestroy (transform: xmlSecTransformPtr); cdecl; external XMLSEC_SO;
  function xmlSecTransformDsaSha1GetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformEnvelopedGetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformExclC14NGetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformExclC14NWithCommentsGetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformExecute (transform: xmlSecTransformPtr; last: Longint; transformCtx: xmlSecTransformCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformGetDataType (transform: xmlSecTransformPtr; mode: xmlSecTransformMode; transformCtx: xmlSecTransformCtxPtr) : xmlSecTransformDataType; cdecl; external XMLSEC_SO;
  function xmlSecTransformHmacMd5GetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformHmacRipemd160GetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformHmacSha1GetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  procedure xmlSecTransformIdListDebugDump (list: xmlSecPtrListPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecTransformIdListDebugXmlDump (list: xmlSecPtrListPtr; output: PFILE); cdecl; external XMLSEC_SO;
  function xmlSecTransformIdListFind (list: xmlSecPtrListPtr; transformId: xmlSecTransformId) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformIdListFindByHref (list: xmlSecPtrListPtr; const href: PChar; usage: xmlSecTransformUsage) : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformIdListFindByName (list: xmlSecPtrListPtr; const name: PChar; usage: xmlSecTransformUsage) : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformIdListGetKlass () : xmlSecPtrListId; cdecl; external XMLSEC_SO;
  function xmlSecTransformIdsGet () : xmlSecPtrListPtr; cdecl; external XMLSEC_SO;
  function xmlSecTransformIdsInit () : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformIdsRegister (id: xmlSecTransformId) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformIdsRegisterDefault () : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecTransformIdsShutdown (); cdecl; external XMLSEC_SO;
  function xmlSecTransformInclC14NGetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformInclC14NWithCommentsGetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformInputURIGetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformInputURIOpen (transform: xmlSecTransformPtr; const uri: PChar) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformKWAes128GetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformKWAes192GetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformKWAes256GetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformKWDes3GetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformMemBufGetBuffer (transform: xmlSecTransformPtr) : xmlSecBufferPtr; cdecl; external XMLSEC_SO;
  function xmlSecTransformMemBufGetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformNodeRead (node: xmlNodePtr; usage: xmlSecTransformUsage; transformCtx: xmlSecTransformCtxPtr) : xmlSecTransformPtr; cdecl; external XMLSEC_SO;
  function xmlSecTransformPopBin (transform: xmlSecTransformPtr; data: xmlSecBytePtr; maxDataSize: xmlSecSize; dataSize: xmlSecSizePtr; transformCtx: xmlSecTransformCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformPopXml (transform: xmlSecTransformPtr; nodes: xmlSecNodeSetPtrPtr; transformCtx: xmlSecTransformCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformPump (left: xmlSecTransformPtr; right: xmlSecTransformPtr; transformCtx: xmlSecTransformCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformPushBin (transform: xmlSecTransformPtr; const data: xmlSecBytePtr; dataSize: xmlSecSize; final: Longint; transformCtx: xmlSecTransformCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformPushXml (transform: xmlSecTransformPtr; nodes: xmlSecNodeSetPtr; transformCtx: xmlSecTransformCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecTransformRemove (transform: xmlSecTransformPtr); cdecl; external XMLSEC_SO;
  function xmlSecTransformRemoveXmlTagsC14NGetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformRipemd160GetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformRsaOaepGetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformRsaPkcs1GetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformRsaSha1GetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformSetKey (transform: xmlSecTransformPtr; key: xmlSecKeyPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformSetKeyReq (transform: xmlSecTransformPtr; keyReq: xmlSecKeyReqPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformSha1GetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformUriTypeCheck (type_: xmlSecTransformUriType; const uri: PChar) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformVerify (transform: xmlSecTransformPtr; const data: xmlSecBytePtr; dataSize: xmlSecSize; transformCtx: xmlSecTransformCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformVerifyNodeContent (transform: xmlSecTransformPtr; node: xmlNodePtr; transformCtx: xmlSecTransformCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformVisa3DHackGetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformVisa3DHackSetID (transform: xmlSecTransformPtr; const id: PChar) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformXPath2GetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformXPathGetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformXPointerGetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformXPointerSetExpr (transform: xmlSecTransformPtr; const expr: PChar; nodeSetType: xmlSecNodeSetType; hereNode: xmlNodePtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecTransformXmlParserGetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecTransformXsltGetKlass () : xmlSecTransformId; cdecl; external XMLSEC_SO;
  function xmlSecX509DataGetNodeContent (node: xmlNodePtr; deleteChildren: Longint; keyInfoCtx: xmlSecKeyInfoCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecX509StoreGetKlass () : xmlSecKeyDataStoreId; cdecl; external XMLSEC_SO;
  procedure xmlSecXkmsRespondWithDebugDump (id: xmlSecXkmsRespondWithId; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecXkmsRespondWithDebugXmlDump (id: xmlSecXkmsRespondWithId; output: PFILE); cdecl; external XMLSEC_SO;
  function xmlSecXkmsRespondWithDefaultNodeRead (id: xmlSecXkmsRespondWithId; ctx: xmlSecXkmsServerCtxPtr; node: xmlNodePtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecXkmsRespondWithDefaultNodeWrite (id: xmlSecXkmsRespondWithId; ctx: xmlSecXkmsServerCtxPtr; node: xmlNodePtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecXkmsRespondWithIdListFind (list: xmlSecPtrListPtr; id: xmlSecXkmsRespondWithId) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecXkmsRespondWithIdListFindByNodeValue (list: xmlSecPtrListPtr; node: xmlNodePtr) : xmlSecXkmsRespondWithId; cdecl; external XMLSEC_SO;
  function xmlSecXkmsRespondWithIdListGetKlass () : xmlSecPtrListId; cdecl; external XMLSEC_SO;
  function xmlSecXkmsRespondWithIdListWrite (list: xmlSecPtrListPtr; ctx: xmlSecXkmsServerCtxPtr; node: xmlNodePtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecXkmsRespondWithIdsGet () : xmlSecPtrListPtr; cdecl; external XMLSEC_SO;
  function xmlSecXkmsRespondWithIdsInit () : Longint; cdecl; external XMLSEC_SO;
  function xmlSecXkmsRespondWithIdsRegister (id: xmlSecXkmsRespondWithId) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecXkmsRespondWithIdsRegisterDefault () : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecXkmsRespondWithIdsShutdown (); cdecl; external XMLSEC_SO;
  function xmlSecXkmsRespondWithKeyNameGetKlass () : xmlSecXkmsRespondWithId; cdecl; external XMLSEC_SO;
  function xmlSecXkmsRespondWithKeyValueGetKlass () : xmlSecXkmsRespondWithId; cdecl; external XMLSEC_SO;
  function xmlSecXkmsRespondWithNodeRead (id: xmlSecXkmsRespondWithId; ctx: xmlSecXkmsServerCtxPtr; node: xmlNodePtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecXkmsRespondWithNodeWrite (id: xmlSecXkmsRespondWithId; ctx: xmlSecXkmsServerCtxPtr; node: xmlNodePtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecXkmsRespondWithPGPGetKlass () : xmlSecXkmsRespondWithId; cdecl; external XMLSEC_SO;
  function xmlSecXkmsRespondWithPrivateKeyGetKlass () : xmlSecXkmsRespondWithId; cdecl; external XMLSEC_SO;
  function xmlSecXkmsRespondWithRetrievalMethodGetKlass () : xmlSecXkmsRespondWithId; cdecl; external XMLSEC_SO;
  function xmlSecXkmsRespondWithSPKIGetKlass () : xmlSecXkmsRespondWithId; cdecl; external XMLSEC_SO;
  function xmlSecXkmsRespondWithX509CRLGetKlass () : xmlSecXkmsRespondWithId; cdecl; external XMLSEC_SO;
  function xmlSecXkmsRespondWithX509CertGetKlass () : xmlSecXkmsRespondWithId; cdecl; external XMLSEC_SO;
  function xmlSecXkmsRespondWithX509ChainGetKlass () : xmlSecXkmsRespondWithId; cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerCtxCopyUserPref (dst: xmlSecXkmsServerCtxPtr; src: xmlSecXkmsServerCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerCtxCreate (keysMngr: xmlSecKeysMngrPtr) : xmlSecXkmsServerCtxPtr; cdecl; external XMLSEC_SO;
  procedure xmlSecXkmsServerCtxDebugDump (ctx: xmlSecXkmsServerCtxPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecXkmsServerCtxDebugXmlDump (ctx: xmlSecXkmsServerCtxPtr; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecXkmsServerCtxDestroy (ctx: xmlSecXkmsServerCtxPtr); cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerCtxFatalErrorResponseCreate (ctx: xmlSecXkmsServerCtxPtr; format: xmlSecXkmsServerFormat; doc: xmlDocPtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  procedure xmlSecXkmsServerCtxFinalize (ctx: xmlSecXkmsServerCtxPtr); cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerCtxInitialize (ctx: xmlSecXkmsServerCtxPtr; keysMngr: xmlSecKeysMngrPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerCtxProcess (ctx: xmlSecXkmsServerCtxPtr; node: xmlNodePtr; format: xmlSecXkmsServerFormat; doc: xmlDocPtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerCtxPtrListGetKlass () : xmlSecPtrListId; cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerCtxRequestRead (ctx: xmlSecXkmsServerCtxPtr; node: xmlNodePtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerCtxRequestUnwrap (ctx: xmlSecXkmsServerCtxPtr; node: xmlNodePtr; format: xmlSecXkmsServerFormat) : xmlNodePtr; cdecl; external XMLSEC_SO;
  procedure xmlSecXkmsServerCtxReset (ctx: xmlSecXkmsServerCtxPtr); cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerCtxResponseWrap (ctx: xmlSecXkmsServerCtxPtr; node: xmlNodePtr; format: xmlSecXkmsServerFormat; doc: xmlDocPtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerCtxResponseWrite (ctx: xmlSecXkmsServerCtxPtr; doc: xmlDocPtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  procedure xmlSecXkmsServerCtxSetResult (ctx: xmlSecXkmsServerCtxPtr; resultMajor: xmlSecXkmsResultMajor; resultMinor: xmlSecXkmsResultMinor); cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerFormatFromString (const str: PChar) : xmlSecXkmsServerFormat; cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerFormatToString (format: xmlSecXkmsServerFormat) : PChar; cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerRequestCompoundGetKlass () : xmlSecXkmsServerRequestId; cdecl; external XMLSEC_SO;
  procedure xmlSecXkmsServerRequestDebugDump (id: xmlSecXkmsServerRequestId; output: PFILE); cdecl; external XMLSEC_SO;
  procedure xmlSecXkmsServerRequestDebugXmlDump (id: xmlSecXkmsServerRequestId; output: PFILE); cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerRequestExecute (id: xmlSecXkmsServerRequestId; ctx: xmlSecXkmsServerCtxPtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerRequestIdListFind (list: xmlSecPtrListPtr; id: xmlSecXkmsServerRequestId) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerRequestIdListFindByName (list: xmlSecPtrListPtr; const name: PChar) : xmlSecXkmsServerRequestId; cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerRequestIdListFindByNode (list: xmlSecPtrListPtr; node: xmlNodePtr) : xmlSecXkmsServerRequestId; cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerRequestIdListGetKlass () : xmlSecPtrListId; cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerRequestIdsGet () : xmlSecPtrListPtr; cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerRequestIdsInit () : Longint; cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerRequestIdsRegister (id: xmlSecXkmsServerRequestId) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerRequestIdsRegisterDefault () : Longint; cdecl; external XMLSEC_SO;
  procedure xmlSecXkmsServerRequestIdsShutdown (); cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerRequestLocateGetKlass () : xmlSecXkmsServerRequestId; cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerRequestNodeRead (id: xmlSecXkmsServerRequestId; ctx: xmlSecXkmsServerCtxPtr; node: xmlNodePtr) : Longint; cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerRequestNodeWrite (id: xmlSecXkmsServerRequestId; ctx: xmlSecXkmsServerCtxPtr; doc: xmlDocPtr; node: xmlNodePtr) : xmlNodePtr; cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerRequestResultGetKlass () : xmlSecXkmsServerRequestId; cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerRequestStatusGetKlass () : xmlSecXkmsServerRequestId; cdecl; external XMLSEC_SO;
  function xmlSecXkmsServerRequestValidateGetKlass () : xmlSecXkmsServerRequestId; cdecl; external XMLSEC_SO;
  function xmlSecAttrAlgorithm(): xmlCharPtr; cdecl;
  function xmlSecAttrApplication(): xmlCharPtr; cdecl;
  function xmlSecAttrEncoding(): xmlCharPtr; cdecl;
  function xmlSecAttrFilter(): xmlCharPtr; cdecl;
  function xmlSecAttrId(): xmlCharPtr; cdecl;
  function xmlSecAttrIdentifier(): xmlCharPtr; cdecl;
  function xmlSecAttrMechanism(): xmlCharPtr; cdecl;
  function xmlSecAttrMimeType(): xmlCharPtr; cdecl;
  function xmlSecAttrNonce(): xmlCharPtr; cdecl;
  function xmlSecAttrNotBefore(): xmlCharPtr; cdecl;
  function xmlSecAttrNotOnOrAfter(): xmlCharPtr; cdecl;
  function xmlSecAttrOriginalRequestId(): xmlCharPtr; cdecl;
  function xmlSecAttrPrefixList(): xmlCharPtr; cdecl;
  function xmlSecAttrRecipient(): xmlCharPtr; cdecl;
  function xmlSecAttrRequestId(): xmlCharPtr; cdecl;
  function xmlSecAttrResponseLimit(): xmlCharPtr; cdecl;
  function xmlSecAttrResultMajor(): xmlCharPtr; cdecl;
  function xmlSecAttrResultMinor(): xmlCharPtr; cdecl;
  function xmlSecAttrService(): xmlCharPtr; cdecl;
  function xmlSecAttrStatusValue(): xmlCharPtr; cdecl;
  function xmlSecAttrTarget(): xmlCharPtr; cdecl;
  function xmlSecAttrTime(): xmlCharPtr; cdecl;
  function xmlSecAttrType(): xmlCharPtr; cdecl;
  function xmlSecAttrURI(): xmlCharPtr; cdecl;
  function xmlSecDSigNs(): xmlCharPtr; cdecl;
  function xmlSecEncNs(): xmlCharPtr; cdecl;
  function xmlSecHrefAESKeyValue(): xmlCharPtr; cdecl;
  function xmlSecHrefAes128Cbc(): xmlCharPtr; cdecl;
  function xmlSecHrefAes192Cbc(): xmlCharPtr; cdecl;
  function xmlSecHrefAes256Cbc(): xmlCharPtr; cdecl;
  function xmlSecHrefBase64(): xmlCharPtr; cdecl;
  function xmlSecHrefC14N(): xmlCharPtr; cdecl;
  function xmlSecHrefC14NWithComments(): xmlCharPtr; cdecl;
  function xmlSecHrefDESKeyValue(): xmlCharPtr; cdecl;
  function xmlSecHrefDSAKeyValue(): xmlCharPtr; cdecl;
  function xmlSecHrefDes3Cbc(): xmlCharPtr; cdecl;
  function xmlSecHrefDsaSha1(): xmlCharPtr; cdecl;
  function xmlSecHrefEncryptedKey(): xmlCharPtr; cdecl;
  function xmlSecHrefEnveloped(): xmlCharPtr; cdecl;
  function xmlSecHrefExcC14N(): xmlCharPtr; cdecl;
  function xmlSecHrefExcC14NWithComments(): xmlCharPtr; cdecl;
  function xmlSecHrefHMACKeyValue(): xmlCharPtr; cdecl;
  function xmlSecHrefHmacMd5(): xmlCharPtr; cdecl;
  function xmlSecHrefHmacRipemd160(): xmlCharPtr; cdecl;
  function xmlSecHrefHmacSha1(): xmlCharPtr; cdecl;
  function xmlSecHrefKWAes128(): xmlCharPtr; cdecl;
  function xmlSecHrefKWAes192(): xmlCharPtr; cdecl;
  function xmlSecHrefKWAes256(): xmlCharPtr; cdecl;
  function xmlSecHrefKWDes3(): xmlCharPtr; cdecl;
  function xmlSecHrefPGPData(): xmlCharPtr; cdecl;
  function xmlSecHrefRSAKeyValue(): xmlCharPtr; cdecl;
  function xmlSecHrefRawX509Cert(): xmlCharPtr; cdecl;
  function xmlSecHrefRipemd160(): xmlCharPtr; cdecl;
  function xmlSecHrefRsaOaep(): xmlCharPtr; cdecl;
  function xmlSecHrefRsaPkcs1(): xmlCharPtr; cdecl;
  function xmlSecHrefRsaSha1(): xmlCharPtr; cdecl;
  function xmlSecHrefSPKIData(): xmlCharPtr; cdecl;
  function xmlSecHrefSha1(): xmlCharPtr; cdecl;
  function xmlSecHrefX509Data(): xmlCharPtr; cdecl;
  function xmlSecHrefXslt(): xmlCharPtr; cdecl;
  function xmlSecKeyBindingReasonIssuerTrust(): xmlCharPtr; cdecl;
  function xmlSecKeyBindingReasonRevocationStatus(): xmlCharPtr; cdecl;
  function xmlSecKeyBindingReasonSignature(): xmlCharPtr; cdecl;
  function xmlSecKeyBindingReasonValidityInterval(): xmlCharPtr; cdecl;
  function xmlSecKeyBindingStatusIndeterminate(): xmlCharPtr; cdecl;
  function xmlSecKeyBindingStatusInvalid(): xmlCharPtr; cdecl;
  function xmlSecKeyBindingStatusValid(): xmlCharPtr; cdecl;
  function xmlSecKeyUsageEncryption(): xmlCharPtr; cdecl;
  function xmlSecKeyUsageExchange(): xmlCharPtr; cdecl;
  function xmlSecKeyUsageSignature(): xmlCharPtr; cdecl;
  function xmlSecNameAESKeyValue(): xmlCharPtr; cdecl;
  function xmlSecNameAes128Cbc(): xmlCharPtr; cdecl;
  function xmlSecNameAes192Cbc(): xmlCharPtr; cdecl;
  function xmlSecNameAes256Cbc(): xmlCharPtr; cdecl;
  function xmlSecNameBase64(): xmlCharPtr; cdecl;
  function xmlSecNameC14N(): xmlCharPtr; cdecl;
  function xmlSecNameC14NWithComments(): xmlCharPtr; cdecl;
  function xmlSecNameDESKeyValue(): xmlCharPtr; cdecl;
  function xmlSecNameDSAKeyValue(): xmlCharPtr; cdecl;
  function xmlSecNameDes3Cbc(): xmlCharPtr; cdecl;
  function xmlSecNameDsaSha1(): xmlCharPtr; cdecl;
  function xmlSecNameEncryptedKey(): xmlCharPtr; cdecl;
  function xmlSecNameEnveloped(): xmlCharPtr; cdecl;
  function xmlSecNameExcC14N(): xmlCharPtr; cdecl;
  function xmlSecNameExcC14NWithComments(): xmlCharPtr; cdecl;
  function xmlSecNameHMACKeyValue(): xmlCharPtr; cdecl;
  function xmlSecNameHmacMd5(): xmlCharPtr; cdecl;
  function xmlSecNameHmacRipemd160(): xmlCharPtr; cdecl;
  function xmlSecNameHmacSha1(): xmlCharPtr; cdecl;
  function xmlSecNameKWAes128(): xmlCharPtr; cdecl;
  function xmlSecNameKWAes192(): xmlCharPtr; cdecl;
  function xmlSecNameKWAes256(): xmlCharPtr; cdecl;
  function xmlSecNameKWDes3(): xmlCharPtr; cdecl;
  function xmlSecNameKeyName(): xmlCharPtr; cdecl;
  function xmlSecNameKeyValue(): xmlCharPtr; cdecl;
  function xmlSecNameMemBuf(): xmlCharPtr; cdecl;
  function xmlSecNamePGPData(): xmlCharPtr; cdecl;
  function xmlSecNameRSAKeyValue(): xmlCharPtr; cdecl;
  function xmlSecNameRawX509Cert(): xmlCharPtr; cdecl;
  function xmlSecNameRetrievalMethod(): xmlCharPtr; cdecl;
  function xmlSecNameRipemd160(): xmlCharPtr; cdecl;
  function xmlSecNameRsaOaep(): xmlCharPtr; cdecl;
  function xmlSecNameRsaPkcs1(): xmlCharPtr; cdecl;
  function xmlSecNameRsaSha1(): xmlCharPtr; cdecl;
  function xmlSecNameSPKIData(): xmlCharPtr; cdecl;
  function xmlSecNameSha1(): xmlCharPtr; cdecl;
  function xmlSecNameX509Data(): xmlCharPtr; cdecl;
  function xmlSecNameX509Store(): xmlCharPtr; cdecl;
  function xmlSecNameXPath(): xmlCharPtr; cdecl;
  function xmlSecNameXPath2(): xmlCharPtr; cdecl;
  function xmlSecNameXPointer(): xmlCharPtr; cdecl;
  function xmlSecNameXslt(): xmlCharPtr; cdecl;
  function xmlSecNodeAESKeyValue(): xmlCharPtr; cdecl;
  function xmlSecNodeBody(): xmlCharPtr; cdecl;
  function xmlSecNodeCanonicalizationMethod(): xmlCharPtr; cdecl;
  function xmlSecNodeCarriedKeyName(): xmlCharPtr; cdecl;
  function xmlSecNodeCipherData(): xmlCharPtr; cdecl;
  function xmlSecNodeCipherReference(): xmlCharPtr; cdecl;
  function xmlSecNodeCipherValue(): xmlCharPtr; cdecl;
  function xmlSecNodeCode(): xmlCharPtr; cdecl;
  function xmlSecNodeCompoundRequest(): xmlCharPtr; cdecl;
  function xmlSecNodeCompoundResult(): xmlCharPtr; cdecl;
  function xmlSecNodeDESKeyValue(): xmlCharPtr; cdecl;
  function xmlSecNodeDSAG(): xmlCharPtr; cdecl;
  function xmlSecNodeDSAJ(): xmlCharPtr; cdecl;
  function xmlSecNodeDSAKeyValue(): xmlCharPtr; cdecl;
  function xmlSecNodeDSAP(): xmlCharPtr; cdecl;
  function xmlSecNodeDSAPgenCounter(): xmlCharPtr; cdecl;
  function xmlSecNodeDSAQ(): xmlCharPtr; cdecl;
  function xmlSecNodeDSASeed(): xmlCharPtr; cdecl;
  function xmlSecNodeDSAX(): xmlCharPtr; cdecl;
  function xmlSecNodeDSAY(): xmlCharPtr; cdecl;
  function xmlSecNodeDataReference(): xmlCharPtr; cdecl;
  function xmlSecNodeDetail(): xmlCharPtr; cdecl;
  function xmlSecNodeDigestMethod(): xmlCharPtr; cdecl;
  function xmlSecNodeDigestValue(): xmlCharPtr; cdecl;
  function xmlSecNodeEncryptedData(): xmlCharPtr; cdecl;
  function xmlSecNodeEncryptedKey(): xmlCharPtr; cdecl;
  function xmlSecNodeEncryptionMethod(): xmlCharPtr; cdecl;
  function xmlSecNodeEncryptionProperties(): xmlCharPtr; cdecl;
  function xmlSecNodeEncryptionProperty(): xmlCharPtr; cdecl;
  function xmlSecNodeEnvelope(): xmlCharPtr; cdecl;
  function xmlSecNodeFault(): xmlCharPtr; cdecl;
  function xmlSecNodeFaultActor(): xmlCharPtr; cdecl;
  function xmlSecNodeFaultCode(): xmlCharPtr; cdecl;
  function xmlSecNodeFaultDetail(): xmlCharPtr; cdecl;
  function xmlSecNodeFaultString(): xmlCharPtr; cdecl;
  function xmlSecNodeHMACKeyValue(): xmlCharPtr; cdecl;
  function xmlSecNodeHMACOutputLength(): xmlCharPtr; cdecl;
  function xmlSecNodeHeader(): xmlCharPtr; cdecl;
  function xmlSecNodeInclusiveNamespaces(): xmlCharPtr; cdecl;
  function xmlSecNodeIndeterminateReason(): xmlCharPtr; cdecl;
  function xmlSecNodeInvalidReason(): xmlCharPtr; cdecl;
  function xmlSecNodeKeyInfo(): xmlCharPtr; cdecl;
  function xmlSecNodeKeyName(): xmlCharPtr; cdecl;
  function xmlSecNodeKeyReference(): xmlCharPtr; cdecl;
  function xmlSecNodeKeyUsage(): xmlCharPtr; cdecl;
  function xmlSecNodeKeyValue(): xmlCharPtr; cdecl;
  function xmlSecNodeLocateRequest(): xmlCharPtr; cdecl;
  function xmlSecNodeLocateResult(): xmlCharPtr; cdecl;
  function xmlSecNodeManifest(): xmlCharPtr; cdecl;
  function xmlSecNodeMessageExtension(): xmlCharPtr; cdecl;
  function xmlSecNodeNode(): xmlCharPtr; cdecl;
  function xmlSecNodeObject(): xmlCharPtr; cdecl;
  function xmlSecNodeOpaqueClientData(): xmlCharPtr; cdecl;
  function xmlSecNodePGPData(): xmlCharPtr; cdecl;
  function xmlSecNodePendingNotification(): xmlCharPtr; cdecl;
  function xmlSecNodeQueryKeyBinding(): xmlCharPtr; cdecl;
  function xmlSecNodeRSAExponent(): xmlCharPtr; cdecl;
  function xmlSecNodeRSAKeyValue(): xmlCharPtr; cdecl;
  function xmlSecNodeRSAModulus(): xmlCharPtr; cdecl;
  function xmlSecNodeRSAPrivateExponent(): xmlCharPtr; cdecl;
  function xmlSecNodeReason(): xmlCharPtr; cdecl;
  function xmlSecNodeReference(): xmlCharPtr; cdecl;
  function xmlSecNodeReferenceList(): xmlCharPtr; cdecl;
  function xmlSecNodeRequestSignatureValue(): xmlCharPtr; cdecl;
  function xmlSecNodeRespondWith(): xmlCharPtr; cdecl;
  function xmlSecNodeResponseMechanism(): xmlCharPtr; cdecl;
  function xmlSecNodeResult(): xmlCharPtr; cdecl;
  function xmlSecNodeRetrievalMethod(): xmlCharPtr; cdecl;
  function xmlSecNodeRole(): xmlCharPtr; cdecl;
  function xmlSecNodeRsaOAEPparams(): xmlCharPtr; cdecl;
  function xmlSecNodeSPKIData(): xmlCharPtr; cdecl;
  function xmlSecNodeSignature(): xmlCharPtr; cdecl;
  function xmlSecNodeSignatureMethod(): xmlCharPtr; cdecl;
  function xmlSecNodeSignatureProperties(): xmlCharPtr; cdecl;
  function xmlSecNodeSignatureValue(): xmlCharPtr; cdecl;
  function xmlSecNodeSignedInfo(): xmlCharPtr; cdecl;
  function xmlSecNodeStatus(): xmlCharPtr; cdecl;
  function xmlSecNodeStatusRequest(): xmlCharPtr; cdecl;
  function xmlSecNodeStatusResult(): xmlCharPtr; cdecl;
  function xmlSecNodeSubcode(): xmlCharPtr; cdecl;
  function xmlSecNodeText(): xmlCharPtr; cdecl;
  function xmlSecNodeTimeInstant(): xmlCharPtr; cdecl;
  function xmlSecNodeTransform(): xmlCharPtr; cdecl;
  function xmlSecNodeTransforms(): xmlCharPtr; cdecl;
  function xmlSecNodeUnverifiedKeyBinding(): xmlCharPtr; cdecl;
  function xmlSecNodeUseKeyWith(): xmlCharPtr; cdecl;
  function xmlSecNodeValidReason(): xmlCharPtr; cdecl;
  function xmlSecNodeValidateRequest(): xmlCharPtr; cdecl;
  function xmlSecNodeValidateResult(): xmlCharPtr; cdecl;
  function xmlSecNodeValidityInterval(): xmlCharPtr; cdecl;
  function xmlSecNodeValue(): xmlCharPtr; cdecl;
  function xmlSecNodeX509CRL(): xmlCharPtr; cdecl;
  function xmlSecNodeX509Certificate(): xmlCharPtr; cdecl;
  function xmlSecNodeX509Data(): xmlCharPtr; cdecl;
  function xmlSecNodeX509IssuerName(): xmlCharPtr; cdecl;
  function xmlSecNodeX509IssuerSerial(): xmlCharPtr; cdecl;
  function xmlSecNodeX509SKI(): xmlCharPtr; cdecl;
  function xmlSecNodeX509SerialNumber(): xmlCharPtr; cdecl;
  function xmlSecNodeX509SubjectName(): xmlCharPtr; cdecl;
  function xmlSecNodeXPath(): xmlCharPtr; cdecl;
  function xmlSecNodeXPath2(): xmlCharPtr; cdecl;
  function xmlSecNodeXPointer(): xmlCharPtr; cdecl;
  function xmlSecNs(): xmlCharPtr; cdecl;
  function xmlSecNsExcC14N(): xmlCharPtr; cdecl;
  function xmlSecNsExcC14NWithComments(): xmlCharPtr; cdecl;
  function xmlSecRespondWithKeyName(): xmlCharPtr; cdecl;
  function xmlSecRespondWithKeyValue(): xmlCharPtr; cdecl;
  function xmlSecRespondWithOCSP(): xmlCharPtr; cdecl;
  function xmlSecRespondWithPGP(): xmlCharPtr; cdecl;
  function xmlSecRespondWithPGPWeb(): xmlCharPtr; cdecl;
  function xmlSecRespondWithPrivateKey(): xmlCharPtr; cdecl;
  function xmlSecRespondWithRetrievalMethod(): xmlCharPtr; cdecl;
  function xmlSecRespondWithSPKI(): xmlCharPtr; cdecl;
  function xmlSecRespondWithX509CRL(): xmlCharPtr; cdecl;
  function xmlSecRespondWithX509Cert(): xmlCharPtr; cdecl;
  function xmlSecRespondWithX509Chain(): xmlCharPtr; cdecl;
  function xmlSecResponseMechanismPending(): xmlCharPtr; cdecl;
  function xmlSecResponseMechanismRepresent(): xmlCharPtr; cdecl;
  function xmlSecResponseMechanismRequestSignatureValue(): xmlCharPtr; cdecl;
  function xmlSecResultMajorCodePending(): xmlCharPtr; cdecl;
  function xmlSecResultMajorCodeReceiver(): xmlCharPtr; cdecl;
  function xmlSecResultMajorCodeRepresent(): xmlCharPtr; cdecl;
  function xmlSecResultMajorCodeSender(): xmlCharPtr; cdecl;
  function xmlSecResultMajorCodeSuccess(): xmlCharPtr; cdecl;
  function xmlSecResultMajorCodeVersionMismatch(): xmlCharPtr; cdecl;
  function xmlSecResultMinorCodeFailure(): xmlCharPtr; cdecl;
  function xmlSecResultMinorCodeIncomplete(): xmlCharPtr; cdecl;
  function xmlSecResultMinorCodeMessageNotSupported(): xmlCharPtr; cdecl;
  function xmlSecResultMinorCodeNoAuthentication(): xmlCharPtr; cdecl;
  function xmlSecResultMinorCodeNoMatch(): xmlCharPtr; cdecl;
  function xmlSecResultMinorCodeNotSynchronous(): xmlCharPtr; cdecl;
  function xmlSecResultMinorCodeRefused(): xmlCharPtr; cdecl;
  function xmlSecResultMinorCodeTooManyResponses(): xmlCharPtr; cdecl;
  function xmlSecResultMinorCodeUnknownResponseId(): xmlCharPtr; cdecl;
  function xmlSecSoap11Ns(): xmlCharPtr; cdecl;
  function xmlSecSoap12Ns(): xmlCharPtr; cdecl;
  function xmlSecSoapFaultCodeClient(): xmlCharPtr; cdecl;
  function xmlSecSoapFaultCodeMustUnderstand(): xmlCharPtr; cdecl;
  function xmlSecSoapFaultCodeReceiver(): xmlCharPtr; cdecl;
  function xmlSecSoapFaultCodeSender(): xmlCharPtr; cdecl;
  function xmlSecSoapFaultCodeServer(): xmlCharPtr; cdecl;
  function xmlSecSoapFaultCodeVersionMismatch(): xmlCharPtr; cdecl;
  function xmlSecSoapFaultDataEncodningUnknown(): xmlCharPtr; cdecl;
  function xmlSecStatusResultFailed(): xmlCharPtr; cdecl;
  function xmlSecStatusResultPending(): xmlCharPtr; cdecl;
  function xmlSecStatusResultSuccess(): xmlCharPtr; cdecl;
  function xmlSecStringCR(): xmlCharPtr; cdecl;
  function xmlSecStringEmpty(): xmlCharPtr; cdecl;
  function xmlSecTypeEncContent(): xmlCharPtr; cdecl;
  function xmlSecTypeEncElement(): xmlCharPtr; cdecl;
  function xmlSecXPath2FilterIntersect(): xmlCharPtr; cdecl;
  function xmlSecXPath2FilterSubtract(): xmlCharPtr; cdecl;
  function xmlSecXPath2FilterUnion(): xmlCharPtr; cdecl;
  function xmlSecXPath2Ns(): xmlCharPtr; cdecl;
  function xmlSecXPathNs(): xmlCharPtr; cdecl;
  function xmlSecXPointerNs(): xmlCharPtr; cdecl;
  function xmlSecXkmsFormatStrPlain(): xmlCharPtr; cdecl;
  function xmlSecXkmsFormatStrSoap11(): xmlCharPtr; cdecl;
  function xmlSecXkmsFormatStrSoap12(): xmlCharPtr; cdecl;
  function xmlSecXkmsNs(): xmlCharPtr; cdecl;
  function xmlSecXkmsServerRequestCompoundName(): xmlCharPtr; cdecl;
  function xmlSecXkmsServerRequestLocateName(): xmlCharPtr; cdecl;
  function xmlSecXkmsServerRequestResultName(): xmlCharPtr; cdecl;
  function xmlSecXkmsServerRequestStatusName(): xmlCharPtr; cdecl;
  function xmlSecXkmsServerRequestValidateName(): xmlCharPtr; cdecl;
  function xmlSecXkmsSoapFaultReasonLang(): xmlCharPtr; cdecl;
  function xmlSecXkmsSoapFaultReasonMessageInvalid(): xmlCharPtr; cdecl;
  function xmlSecXkmsSoapFaultReasonMessageNotSupported(): xmlCharPtr; cdecl;
  function xmlSecXkmsSoapFaultReasonServiceUnavailable(): xmlCharPtr; cdecl;
  function xmlSecXkmsSoapFaultReasonUnableToProcess(): xmlCharPtr; cdecl;
  function xmlSecXkmsSoapFaultReasonUnsupportedVersion(): xmlCharPtr; cdecl;
  function xmlSecXkmsSoapSubcodeValueBadMessage(): xmlCharPtr; cdecl;
  function xmlSecXkmsSoapSubcodeValueMessageNotSupported(): xmlCharPtr; cdecl;

implementation
uses
{$IFDEF WIN32}
  Windows,
{$ENDIF}
  SysUtils;

var
  libHandle: THandle;

procedure CheckForNil(ptr: Pointer; name:string);
begin
  if not Assigned(ptr) then
    raise Exception.Create('"' + name + '" could not be loaded from the dynamic library ' + XMLSEC_SO);
end;

var
   pxmlSecAttrAlgorithm: xmlCharPtr;

function xmlSecAttrAlgorithm: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrAlgorithm, 'xmlSecAttrAlgorithm');
  Result := pxmlSecAttrAlgorithm;
end;

var
   pxmlSecAttrApplication: xmlCharPtr;

function xmlSecAttrApplication: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrApplication, 'xmlSecAttrApplication');
  Result := pxmlSecAttrApplication;
end;

var
   pxmlSecAttrEncoding: xmlCharPtr;

function xmlSecAttrEncoding: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrEncoding, 'xmlSecAttrEncoding');
  Result := pxmlSecAttrEncoding;
end;

var
   pxmlSecAttrFilter: xmlCharPtr;

function xmlSecAttrFilter: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrFilter, 'xmlSecAttrFilter');
  Result := pxmlSecAttrFilter;
end;

var
   pxmlSecAttrId: xmlCharPtr;

function xmlSecAttrId: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrId, 'xmlSecAttrId');
  Result := pxmlSecAttrId;
end;

var
   pxmlSecAttrIdentifier: xmlCharPtr;

function xmlSecAttrIdentifier: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrIdentifier, 'xmlSecAttrIdentifier');
  Result := pxmlSecAttrIdentifier;
end;

var
   pxmlSecAttrMechanism: xmlCharPtr;

function xmlSecAttrMechanism: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrMechanism, 'xmlSecAttrMechanism');
  Result := pxmlSecAttrMechanism;
end;

var
   pxmlSecAttrMimeType: xmlCharPtr;

function xmlSecAttrMimeType: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrMimeType, 'xmlSecAttrMimeType');
  Result := pxmlSecAttrMimeType;
end;

var
   pxmlSecAttrNonce: xmlCharPtr;

function xmlSecAttrNonce: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrNonce, 'xmlSecAttrNonce');
  Result := pxmlSecAttrNonce;
end;

var
   pxmlSecAttrNotBefore: xmlCharPtr;

function xmlSecAttrNotBefore: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrNotBefore, 'xmlSecAttrNotBefore');
  Result := pxmlSecAttrNotBefore;
end;

var
   pxmlSecAttrNotOnOrAfter: xmlCharPtr;

function xmlSecAttrNotOnOrAfter: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrNotOnOrAfter, 'xmlSecAttrNotOnOrAfter');
  Result := pxmlSecAttrNotOnOrAfter;
end;

var
   pxmlSecAttrOriginalRequestId: xmlCharPtr;

function xmlSecAttrOriginalRequestId: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrOriginalRequestId, 'xmlSecAttrOriginalRequestId');
  Result := pxmlSecAttrOriginalRequestId;
end;

var
   pxmlSecAttrPrefixList: xmlCharPtr;

function xmlSecAttrPrefixList: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrPrefixList, 'xmlSecAttrPrefixList');
  Result := pxmlSecAttrPrefixList;
end;

var
   pxmlSecAttrRecipient: xmlCharPtr;

function xmlSecAttrRecipient: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrRecipient, 'xmlSecAttrRecipient');
  Result := pxmlSecAttrRecipient;
end;

var
   pxmlSecAttrRequestId: xmlCharPtr;

function xmlSecAttrRequestId: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrRequestId, 'xmlSecAttrRequestId');
  Result := pxmlSecAttrRequestId;
end;

var
   pxmlSecAttrResponseLimit: xmlCharPtr;

function xmlSecAttrResponseLimit: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrResponseLimit, 'xmlSecAttrResponseLimit');
  Result := pxmlSecAttrResponseLimit;
end;

var
   pxmlSecAttrResultMajor: xmlCharPtr;

function xmlSecAttrResultMajor: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrResultMajor, 'xmlSecAttrResultMajor');
  Result := pxmlSecAttrResultMajor;
end;

var
   pxmlSecAttrResultMinor: xmlCharPtr;

function xmlSecAttrResultMinor: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrResultMinor, 'xmlSecAttrResultMinor');
  Result := pxmlSecAttrResultMinor;
end;

var
   pxmlSecAttrService: xmlCharPtr;

function xmlSecAttrService: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrService, 'xmlSecAttrService');
  Result := pxmlSecAttrService;
end;

var
   pxmlSecAttrStatusValue: xmlCharPtr;

function xmlSecAttrStatusValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrStatusValue, 'xmlSecAttrStatusValue');
  Result := pxmlSecAttrStatusValue;
end;

var
   pxmlSecAttrTarget: xmlCharPtr;

function xmlSecAttrTarget: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrTarget, 'xmlSecAttrTarget');
  Result := pxmlSecAttrTarget;
end;

var
   pxmlSecAttrTime: xmlCharPtr;

function xmlSecAttrTime: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrTime, 'xmlSecAttrTime');
  Result := pxmlSecAttrTime;
end;

var
   pxmlSecAttrType: xmlCharPtr;

function xmlSecAttrType: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrType, 'xmlSecAttrType');
  Result := pxmlSecAttrType;
end;

var
   pxmlSecAttrURI: xmlCharPtr;

function xmlSecAttrURI: xmlCharPtr;
begin
  CheckForNil(pxmlSecAttrURI, 'xmlSecAttrURI');
  Result := pxmlSecAttrURI;
end;

var
   pxmlSecDSigNs: xmlCharPtr;

function xmlSecDSigNs: xmlCharPtr;
begin
  CheckForNil(pxmlSecDSigNs, 'xmlSecDSigNs');
  Result := pxmlSecDSigNs;
end;

var
   pxmlSecEncNs: xmlCharPtr;

function xmlSecEncNs: xmlCharPtr;
begin
  CheckForNil(pxmlSecEncNs, 'xmlSecEncNs');
  Result := pxmlSecEncNs;
end;

var
   pxmlSecHrefAESKeyValue: xmlCharPtr;

function xmlSecHrefAESKeyValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefAESKeyValue, 'xmlSecHrefAESKeyValue');
  Result := pxmlSecHrefAESKeyValue;
end;

var
   pxmlSecHrefAes128Cbc: xmlCharPtr;

function xmlSecHrefAes128Cbc: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefAes128Cbc, 'xmlSecHrefAes128Cbc');
  Result := pxmlSecHrefAes128Cbc;
end;

var
   pxmlSecHrefAes192Cbc: xmlCharPtr;

function xmlSecHrefAes192Cbc: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefAes192Cbc, 'xmlSecHrefAes192Cbc');
  Result := pxmlSecHrefAes192Cbc;
end;

var
   pxmlSecHrefAes256Cbc: xmlCharPtr;

function xmlSecHrefAes256Cbc: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefAes256Cbc, 'xmlSecHrefAes256Cbc');
  Result := pxmlSecHrefAes256Cbc;
end;

var
   pxmlSecHrefBase64: xmlCharPtr;

function xmlSecHrefBase64: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefBase64, 'xmlSecHrefBase64');
  Result := pxmlSecHrefBase64;
end;

var
   pxmlSecHrefC14N: xmlCharPtr;

function xmlSecHrefC14N: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefC14N, 'xmlSecHrefC14N');
  Result := pxmlSecHrefC14N;
end;

var
   pxmlSecHrefC14NWithComments: xmlCharPtr;

function xmlSecHrefC14NWithComments: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefC14NWithComments, 'xmlSecHrefC14NWithComments');
  Result := pxmlSecHrefC14NWithComments;
end;

var
   pxmlSecHrefDESKeyValue: xmlCharPtr;

function xmlSecHrefDESKeyValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefDESKeyValue, 'xmlSecHrefDESKeyValue');
  Result := pxmlSecHrefDESKeyValue;
end;

var
   pxmlSecHrefDSAKeyValue: xmlCharPtr;

function xmlSecHrefDSAKeyValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefDSAKeyValue, 'xmlSecHrefDSAKeyValue');
  Result := pxmlSecHrefDSAKeyValue;
end;

var
   pxmlSecHrefDes3Cbc: xmlCharPtr;

function xmlSecHrefDes3Cbc: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefDes3Cbc, 'xmlSecHrefDes3Cbc');
  Result := pxmlSecHrefDes3Cbc;
end;

var
   pxmlSecHrefDsaSha1: xmlCharPtr;

function xmlSecHrefDsaSha1: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefDsaSha1, 'xmlSecHrefDsaSha1');
  Result := pxmlSecHrefDsaSha1;
end;

var
   pxmlSecHrefEncryptedKey: xmlCharPtr;

function xmlSecHrefEncryptedKey: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefEncryptedKey, 'xmlSecHrefEncryptedKey');
  Result := pxmlSecHrefEncryptedKey;
end;

var
   pxmlSecHrefEnveloped: xmlCharPtr;

function xmlSecHrefEnveloped: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefEnveloped, 'xmlSecHrefEnveloped');
  Result := pxmlSecHrefEnveloped;
end;

var
   pxmlSecHrefExcC14N: xmlCharPtr;

function xmlSecHrefExcC14N: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefExcC14N, 'xmlSecHrefExcC14N');
  Result := pxmlSecHrefExcC14N;
end;

var
   pxmlSecHrefExcC14NWithComments: xmlCharPtr;

function xmlSecHrefExcC14NWithComments: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefExcC14NWithComments, 'xmlSecHrefExcC14NWithComments');
  Result := pxmlSecHrefExcC14NWithComments;
end;

var
   pxmlSecHrefHMACKeyValue: xmlCharPtr;

function xmlSecHrefHMACKeyValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefHMACKeyValue, 'xmlSecHrefHMACKeyValue');
  Result := pxmlSecHrefHMACKeyValue;
end;

var
   pxmlSecHrefHmacMd5: xmlCharPtr;

function xmlSecHrefHmacMd5: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefHmacMd5, 'xmlSecHrefHmacMd5');
  Result := pxmlSecHrefHmacMd5;
end;

var
   pxmlSecHrefHmacRipemd160: xmlCharPtr;

function xmlSecHrefHmacRipemd160: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefHmacRipemd160, 'xmlSecHrefHmacRipemd160');
  Result := pxmlSecHrefHmacRipemd160;
end;

var
   pxmlSecHrefHmacSha1: xmlCharPtr;

function xmlSecHrefHmacSha1: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefHmacSha1, 'xmlSecHrefHmacSha1');
  Result := pxmlSecHrefHmacSha1;
end;

var
   pxmlSecHrefKWAes128: xmlCharPtr;

function xmlSecHrefKWAes128: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefKWAes128, 'xmlSecHrefKWAes128');
  Result := pxmlSecHrefKWAes128;
end;

var
   pxmlSecHrefKWAes192: xmlCharPtr;

function xmlSecHrefKWAes192: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefKWAes192, 'xmlSecHrefKWAes192');
  Result := pxmlSecHrefKWAes192;
end;

var
   pxmlSecHrefKWAes256: xmlCharPtr;

function xmlSecHrefKWAes256: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefKWAes256, 'xmlSecHrefKWAes256');
  Result := pxmlSecHrefKWAes256;
end;

var
   pxmlSecHrefKWDes3: xmlCharPtr;

function xmlSecHrefKWDes3: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefKWDes3, 'xmlSecHrefKWDes3');
  Result := pxmlSecHrefKWDes3;
end;

var
   pxmlSecHrefPGPData: xmlCharPtr;

function xmlSecHrefPGPData: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefPGPData, 'xmlSecHrefPGPData');
  Result := pxmlSecHrefPGPData;
end;

var
   pxmlSecHrefRSAKeyValue: xmlCharPtr;

function xmlSecHrefRSAKeyValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefRSAKeyValue, 'xmlSecHrefRSAKeyValue');
  Result := pxmlSecHrefRSAKeyValue;
end;

var
   pxmlSecHrefRawX509Cert: xmlCharPtr;

function xmlSecHrefRawX509Cert: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefRawX509Cert, 'xmlSecHrefRawX509Cert');
  Result := pxmlSecHrefRawX509Cert;
end;

var
   pxmlSecHrefRipemd160: xmlCharPtr;

function xmlSecHrefRipemd160: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefRipemd160, 'xmlSecHrefRipemd160');
  Result := pxmlSecHrefRipemd160;
end;

var
   pxmlSecHrefRsaOaep: xmlCharPtr;

function xmlSecHrefRsaOaep: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefRsaOaep, 'xmlSecHrefRsaOaep');
  Result := pxmlSecHrefRsaOaep;
end;

var
   pxmlSecHrefRsaPkcs1: xmlCharPtr;

function xmlSecHrefRsaPkcs1: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefRsaPkcs1, 'xmlSecHrefRsaPkcs1');
  Result := pxmlSecHrefRsaPkcs1;
end;

var
   pxmlSecHrefRsaSha1: xmlCharPtr;

function xmlSecHrefRsaSha1: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefRsaSha1, 'xmlSecHrefRsaSha1');
  Result := pxmlSecHrefRsaSha1;
end;

var
   pxmlSecHrefSPKIData: xmlCharPtr;

function xmlSecHrefSPKIData: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefSPKIData, 'xmlSecHrefSPKIData');
  Result := pxmlSecHrefSPKIData;
end;

var
   pxmlSecHrefSha1: xmlCharPtr;

function xmlSecHrefSha1: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefSha1, 'xmlSecHrefSha1');
  Result := pxmlSecHrefSha1;
end;

var
   pxmlSecHrefX509Data: xmlCharPtr;

function xmlSecHrefX509Data: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefX509Data, 'xmlSecHrefX509Data');
  Result := pxmlSecHrefX509Data;
end;

var
   pxmlSecHrefXslt: xmlCharPtr;

function xmlSecHrefXslt: xmlCharPtr;
begin
  CheckForNil(pxmlSecHrefXslt, 'xmlSecHrefXslt');
  Result := pxmlSecHrefXslt;
end;

var
   pxmlSecKeyBindingReasonIssuerTrust: xmlCharPtr;

function xmlSecKeyBindingReasonIssuerTrust: xmlCharPtr;
begin
  CheckForNil(pxmlSecKeyBindingReasonIssuerTrust, 'xmlSecKeyBindingReasonIssuerTrust');
  Result := pxmlSecKeyBindingReasonIssuerTrust;
end;

var
   pxmlSecKeyBindingReasonRevocationStatus: xmlCharPtr;

function xmlSecKeyBindingReasonRevocationStatus: xmlCharPtr;
begin
  CheckForNil(pxmlSecKeyBindingReasonRevocationStatus, 'xmlSecKeyBindingReasonRevocationStatus');
  Result := pxmlSecKeyBindingReasonRevocationStatus;
end;

var
   pxmlSecKeyBindingReasonSignature: xmlCharPtr;

function xmlSecKeyBindingReasonSignature: xmlCharPtr;
begin
  CheckForNil(pxmlSecKeyBindingReasonSignature, 'xmlSecKeyBindingReasonSignature');
  Result := pxmlSecKeyBindingReasonSignature;
end;

var
   pxmlSecKeyBindingReasonValidityInterval: xmlCharPtr;

function xmlSecKeyBindingReasonValidityInterval: xmlCharPtr;
begin
  CheckForNil(pxmlSecKeyBindingReasonValidityInterval, 'xmlSecKeyBindingReasonValidityInterval');
  Result := pxmlSecKeyBindingReasonValidityInterval;
end;

var
   pxmlSecKeyBindingStatusIndeterminate: xmlCharPtr;

function xmlSecKeyBindingStatusIndeterminate: xmlCharPtr;
begin
  CheckForNil(pxmlSecKeyBindingStatusIndeterminate, 'xmlSecKeyBindingStatusIndeterminate');
  Result := pxmlSecKeyBindingStatusIndeterminate;
end;

var
   pxmlSecKeyBindingStatusInvalid: xmlCharPtr;

function xmlSecKeyBindingStatusInvalid: xmlCharPtr;
begin
  CheckForNil(pxmlSecKeyBindingStatusInvalid, 'xmlSecKeyBindingStatusInvalid');
  Result := pxmlSecKeyBindingStatusInvalid;
end;

var
   pxmlSecKeyBindingStatusValid: xmlCharPtr;

function xmlSecKeyBindingStatusValid: xmlCharPtr;
begin
  CheckForNil(pxmlSecKeyBindingStatusValid, 'xmlSecKeyBindingStatusValid');
  Result := pxmlSecKeyBindingStatusValid;
end;

var
   pxmlSecKeyUsageEncryption: xmlCharPtr;

function xmlSecKeyUsageEncryption: xmlCharPtr;
begin
  CheckForNil(pxmlSecKeyUsageEncryption, 'xmlSecKeyUsageEncryption');
  Result := pxmlSecKeyUsageEncryption;
end;

var
   pxmlSecKeyUsageExchange: xmlCharPtr;

function xmlSecKeyUsageExchange: xmlCharPtr;
begin
  CheckForNil(pxmlSecKeyUsageExchange, 'xmlSecKeyUsageExchange');
  Result := pxmlSecKeyUsageExchange;
end;

var
   pxmlSecKeyUsageSignature: xmlCharPtr;

function xmlSecKeyUsageSignature: xmlCharPtr;
begin
  CheckForNil(pxmlSecKeyUsageSignature, 'xmlSecKeyUsageSignature');
  Result := pxmlSecKeyUsageSignature;
end;

var
   pxmlSecNameAESKeyValue: xmlCharPtr;

function xmlSecNameAESKeyValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameAESKeyValue, 'xmlSecNameAESKeyValue');
  Result := pxmlSecNameAESKeyValue;
end;

var
   pxmlSecNameAes128Cbc: xmlCharPtr;

function xmlSecNameAes128Cbc: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameAes128Cbc, 'xmlSecNameAes128Cbc');
  Result := pxmlSecNameAes128Cbc;
end;

var
   pxmlSecNameAes192Cbc: xmlCharPtr;

function xmlSecNameAes192Cbc: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameAes192Cbc, 'xmlSecNameAes192Cbc');
  Result := pxmlSecNameAes192Cbc;
end;

var
   pxmlSecNameAes256Cbc: xmlCharPtr;

function xmlSecNameAes256Cbc: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameAes256Cbc, 'xmlSecNameAes256Cbc');
  Result := pxmlSecNameAes256Cbc;
end;

var
   pxmlSecNameBase64: xmlCharPtr;

function xmlSecNameBase64: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameBase64, 'xmlSecNameBase64');
  Result := pxmlSecNameBase64;
end;

var
   pxmlSecNameC14N: xmlCharPtr;

function xmlSecNameC14N: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameC14N, 'xmlSecNameC14N');
  Result := pxmlSecNameC14N;
end;

var
   pxmlSecNameC14NWithComments: xmlCharPtr;

function xmlSecNameC14NWithComments: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameC14NWithComments, 'xmlSecNameC14NWithComments');
  Result := pxmlSecNameC14NWithComments;
end;

var
   pxmlSecNameDESKeyValue: xmlCharPtr;

function xmlSecNameDESKeyValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameDESKeyValue, 'xmlSecNameDESKeyValue');
  Result := pxmlSecNameDESKeyValue;
end;

var
   pxmlSecNameDSAKeyValue: xmlCharPtr;

function xmlSecNameDSAKeyValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameDSAKeyValue, 'xmlSecNameDSAKeyValue');
  Result := pxmlSecNameDSAKeyValue;
end;

var
   pxmlSecNameDes3Cbc: xmlCharPtr;

function xmlSecNameDes3Cbc: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameDes3Cbc, 'xmlSecNameDes3Cbc');
  Result := pxmlSecNameDes3Cbc;
end;

var
   pxmlSecNameDsaSha1: xmlCharPtr;

function xmlSecNameDsaSha1: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameDsaSha1, 'xmlSecNameDsaSha1');
  Result := pxmlSecNameDsaSha1;
end;

var
   pxmlSecNameEncryptedKey: xmlCharPtr;

function xmlSecNameEncryptedKey: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameEncryptedKey, 'xmlSecNameEncryptedKey');
  Result := pxmlSecNameEncryptedKey;
end;

var
   pxmlSecNameEnveloped: xmlCharPtr;

function xmlSecNameEnveloped: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameEnveloped, 'xmlSecNameEnveloped');
  Result := pxmlSecNameEnveloped;
end;

var
   pxmlSecNameExcC14N: xmlCharPtr;

function xmlSecNameExcC14N: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameExcC14N, 'xmlSecNameExcC14N');
  Result := pxmlSecNameExcC14N;
end;

var
   pxmlSecNameExcC14NWithComments: xmlCharPtr;

function xmlSecNameExcC14NWithComments: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameExcC14NWithComments, 'xmlSecNameExcC14NWithComments');
  Result := pxmlSecNameExcC14NWithComments;
end;

var
   pxmlSecNameHMACKeyValue: xmlCharPtr;

function xmlSecNameHMACKeyValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameHMACKeyValue, 'xmlSecNameHMACKeyValue');
  Result := pxmlSecNameHMACKeyValue;
end;

var
   pxmlSecNameHmacMd5: xmlCharPtr;

function xmlSecNameHmacMd5: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameHmacMd5, 'xmlSecNameHmacMd5');
  Result := pxmlSecNameHmacMd5;
end;

var
   pxmlSecNameHmacRipemd160: xmlCharPtr;

function xmlSecNameHmacRipemd160: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameHmacRipemd160, 'xmlSecNameHmacRipemd160');
  Result := pxmlSecNameHmacRipemd160;
end;

var
   pxmlSecNameHmacSha1: xmlCharPtr;

function xmlSecNameHmacSha1: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameHmacSha1, 'xmlSecNameHmacSha1');
  Result := pxmlSecNameHmacSha1;
end;

var
   pxmlSecNameKWAes128: xmlCharPtr;

function xmlSecNameKWAes128: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameKWAes128, 'xmlSecNameKWAes128');
  Result := pxmlSecNameKWAes128;
end;

var
   pxmlSecNameKWAes192: xmlCharPtr;

function xmlSecNameKWAes192: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameKWAes192, 'xmlSecNameKWAes192');
  Result := pxmlSecNameKWAes192;
end;

var
   pxmlSecNameKWAes256: xmlCharPtr;

function xmlSecNameKWAes256: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameKWAes256, 'xmlSecNameKWAes256');
  Result := pxmlSecNameKWAes256;
end;

var
   pxmlSecNameKWDes3: xmlCharPtr;

function xmlSecNameKWDes3: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameKWDes3, 'xmlSecNameKWDes3');
  Result := pxmlSecNameKWDes3;
end;

var
   pxmlSecNameKeyName: xmlCharPtr;

function xmlSecNameKeyName: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameKeyName, 'xmlSecNameKeyName');
  Result := pxmlSecNameKeyName;
end;

var
   pxmlSecNameKeyValue: xmlCharPtr;

function xmlSecNameKeyValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameKeyValue, 'xmlSecNameKeyValue');
  Result := pxmlSecNameKeyValue;
end;

var
   pxmlSecNameMemBuf: xmlCharPtr;

function xmlSecNameMemBuf: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameMemBuf, 'xmlSecNameMemBuf');
  Result := pxmlSecNameMemBuf;
end;

var
   pxmlSecNamePGPData: xmlCharPtr;

function xmlSecNamePGPData: xmlCharPtr;
begin
  CheckForNil(pxmlSecNamePGPData, 'xmlSecNamePGPData');
  Result := pxmlSecNamePGPData;
end;

var
   pxmlSecNameRSAKeyValue: xmlCharPtr;

function xmlSecNameRSAKeyValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameRSAKeyValue, 'xmlSecNameRSAKeyValue');
  Result := pxmlSecNameRSAKeyValue;
end;

var
   pxmlSecNameRawX509Cert: xmlCharPtr;

function xmlSecNameRawX509Cert: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameRawX509Cert, 'xmlSecNameRawX509Cert');
  Result := pxmlSecNameRawX509Cert;
end;

var
   pxmlSecNameRetrievalMethod: xmlCharPtr;

function xmlSecNameRetrievalMethod: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameRetrievalMethod, 'xmlSecNameRetrievalMethod');
  Result := pxmlSecNameRetrievalMethod;
end;

var
   pxmlSecNameRipemd160: xmlCharPtr;

function xmlSecNameRipemd160: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameRipemd160, 'xmlSecNameRipemd160');
  Result := pxmlSecNameRipemd160;
end;

var
   pxmlSecNameRsaOaep: xmlCharPtr;

function xmlSecNameRsaOaep: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameRsaOaep, 'xmlSecNameRsaOaep');
  Result := pxmlSecNameRsaOaep;
end;

var
   pxmlSecNameRsaPkcs1: xmlCharPtr;

function xmlSecNameRsaPkcs1: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameRsaPkcs1, 'xmlSecNameRsaPkcs1');
  Result := pxmlSecNameRsaPkcs1;
end;

var
   pxmlSecNameRsaSha1: xmlCharPtr;

function xmlSecNameRsaSha1: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameRsaSha1, 'xmlSecNameRsaSha1');
  Result := pxmlSecNameRsaSha1;
end;

var
   pxmlSecNameSPKIData: xmlCharPtr;

function xmlSecNameSPKIData: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameSPKIData, 'xmlSecNameSPKIData');
  Result := pxmlSecNameSPKIData;
end;

var
   pxmlSecNameSha1: xmlCharPtr;

function xmlSecNameSha1: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameSha1, 'xmlSecNameSha1');
  Result := pxmlSecNameSha1;
end;

var
   pxmlSecNameX509Data: xmlCharPtr;

function xmlSecNameX509Data: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameX509Data, 'xmlSecNameX509Data');
  Result := pxmlSecNameX509Data;
end;

var
   pxmlSecNameX509Store: xmlCharPtr;

function xmlSecNameX509Store: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameX509Store, 'xmlSecNameX509Store');
  Result := pxmlSecNameX509Store;
end;

var
   pxmlSecNameXPath: xmlCharPtr;

function xmlSecNameXPath: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameXPath, 'xmlSecNameXPath');
  Result := pxmlSecNameXPath;
end;

var
   pxmlSecNameXPath2: xmlCharPtr;

function xmlSecNameXPath2: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameXPath2, 'xmlSecNameXPath2');
  Result := pxmlSecNameXPath2;
end;

var
   pxmlSecNameXPointer: xmlCharPtr;

function xmlSecNameXPointer: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameXPointer, 'xmlSecNameXPointer');
  Result := pxmlSecNameXPointer;
end;

var
   pxmlSecNameXslt: xmlCharPtr;

function xmlSecNameXslt: xmlCharPtr;
begin
  CheckForNil(pxmlSecNameXslt, 'xmlSecNameXslt');
  Result := pxmlSecNameXslt;
end;

var
   pxmlSecNodeAESKeyValue: xmlCharPtr;

function xmlSecNodeAESKeyValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeAESKeyValue, 'xmlSecNodeAESKeyValue');
  Result := pxmlSecNodeAESKeyValue;
end;

var
   pxmlSecNodeBody: xmlCharPtr;

function xmlSecNodeBody: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeBody, 'xmlSecNodeBody');
  Result := pxmlSecNodeBody;
end;

var
   pxmlSecNodeCanonicalizationMethod: xmlCharPtr;

function xmlSecNodeCanonicalizationMethod: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeCanonicalizationMethod, 'xmlSecNodeCanonicalizationMethod');
  Result := pxmlSecNodeCanonicalizationMethod;
end;

var
   pxmlSecNodeCarriedKeyName: xmlCharPtr;

function xmlSecNodeCarriedKeyName: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeCarriedKeyName, 'xmlSecNodeCarriedKeyName');
  Result := pxmlSecNodeCarriedKeyName;
end;

var
   pxmlSecNodeCipherData: xmlCharPtr;

function xmlSecNodeCipherData: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeCipherData, 'xmlSecNodeCipherData');
  Result := pxmlSecNodeCipherData;
end;

var
   pxmlSecNodeCipherReference: xmlCharPtr;

function xmlSecNodeCipherReference: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeCipherReference, 'xmlSecNodeCipherReference');
  Result := pxmlSecNodeCipherReference;
end;

var
   pxmlSecNodeCipherValue: xmlCharPtr;

function xmlSecNodeCipherValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeCipherValue, 'xmlSecNodeCipherValue');
  Result := pxmlSecNodeCipherValue;
end;

var
   pxmlSecNodeCode: xmlCharPtr;

function xmlSecNodeCode: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeCode, 'xmlSecNodeCode');
  Result := pxmlSecNodeCode;
end;

var
   pxmlSecNodeCompoundRequest: xmlCharPtr;

function xmlSecNodeCompoundRequest: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeCompoundRequest, 'xmlSecNodeCompoundRequest');
  Result := pxmlSecNodeCompoundRequest;
end;

var
   pxmlSecNodeCompoundResult: xmlCharPtr;

function xmlSecNodeCompoundResult: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeCompoundResult, 'xmlSecNodeCompoundResult');
  Result := pxmlSecNodeCompoundResult;
end;

var
   pxmlSecNodeDESKeyValue: xmlCharPtr;

function xmlSecNodeDESKeyValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeDESKeyValue, 'xmlSecNodeDESKeyValue');
  Result := pxmlSecNodeDESKeyValue;
end;

var
   pxmlSecNodeDSAG: xmlCharPtr;

function xmlSecNodeDSAG: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeDSAG, 'xmlSecNodeDSAG');
  Result := pxmlSecNodeDSAG;
end;

var
   pxmlSecNodeDSAJ: xmlCharPtr;

function xmlSecNodeDSAJ: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeDSAJ, 'xmlSecNodeDSAJ');
  Result := pxmlSecNodeDSAJ;
end;

var
   pxmlSecNodeDSAKeyValue: xmlCharPtr;

function xmlSecNodeDSAKeyValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeDSAKeyValue, 'xmlSecNodeDSAKeyValue');
  Result := pxmlSecNodeDSAKeyValue;
end;

var
   pxmlSecNodeDSAP: xmlCharPtr;

function xmlSecNodeDSAP: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeDSAP, 'xmlSecNodeDSAP');
  Result := pxmlSecNodeDSAP;
end;

var
   pxmlSecNodeDSAPgenCounter: xmlCharPtr;

function xmlSecNodeDSAPgenCounter: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeDSAPgenCounter, 'xmlSecNodeDSAPgenCounter');
  Result := pxmlSecNodeDSAPgenCounter;
end;

var
   pxmlSecNodeDSAQ: xmlCharPtr;

function xmlSecNodeDSAQ: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeDSAQ, 'xmlSecNodeDSAQ');
  Result := pxmlSecNodeDSAQ;
end;

var
   pxmlSecNodeDSASeed: xmlCharPtr;

function xmlSecNodeDSASeed: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeDSASeed, 'xmlSecNodeDSASeed');
  Result := pxmlSecNodeDSASeed;
end;

var
   pxmlSecNodeDSAX: xmlCharPtr;

function xmlSecNodeDSAX: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeDSAX, 'xmlSecNodeDSAX');
  Result := pxmlSecNodeDSAX;
end;

var
   pxmlSecNodeDSAY: xmlCharPtr;

function xmlSecNodeDSAY: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeDSAY, 'xmlSecNodeDSAY');
  Result := pxmlSecNodeDSAY;
end;

var
   pxmlSecNodeDataReference: xmlCharPtr;

function xmlSecNodeDataReference: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeDataReference, 'xmlSecNodeDataReference');
  Result := pxmlSecNodeDataReference;
end;

var
   pxmlSecNodeDetail: xmlCharPtr;

function xmlSecNodeDetail: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeDetail, 'xmlSecNodeDetail');
  Result := pxmlSecNodeDetail;
end;

var
   pxmlSecNodeDigestMethod: xmlCharPtr;

function xmlSecNodeDigestMethod: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeDigestMethod, 'xmlSecNodeDigestMethod');
  Result := pxmlSecNodeDigestMethod;
end;

var
   pxmlSecNodeDigestValue: xmlCharPtr;

function xmlSecNodeDigestValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeDigestValue, 'xmlSecNodeDigestValue');
  Result := pxmlSecNodeDigestValue;
end;

var
   pxmlSecNodeEncryptedData: xmlCharPtr;

function xmlSecNodeEncryptedData: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeEncryptedData, 'xmlSecNodeEncryptedData');
  Result := pxmlSecNodeEncryptedData;
end;

var
   pxmlSecNodeEncryptedKey: xmlCharPtr;

function xmlSecNodeEncryptedKey: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeEncryptedKey, 'xmlSecNodeEncryptedKey');
  Result := pxmlSecNodeEncryptedKey;
end;

var
   pxmlSecNodeEncryptionMethod: xmlCharPtr;

function xmlSecNodeEncryptionMethod: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeEncryptionMethod, 'xmlSecNodeEncryptionMethod');
  Result := pxmlSecNodeEncryptionMethod;
end;

var
   pxmlSecNodeEncryptionProperties: xmlCharPtr;

function xmlSecNodeEncryptionProperties: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeEncryptionProperties, 'xmlSecNodeEncryptionProperties');
  Result := pxmlSecNodeEncryptionProperties;
end;

var
   pxmlSecNodeEncryptionProperty: xmlCharPtr;

function xmlSecNodeEncryptionProperty: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeEncryptionProperty, 'xmlSecNodeEncryptionProperty');
  Result := pxmlSecNodeEncryptionProperty;
end;

var
   pxmlSecNodeEnvelope: xmlCharPtr;

function xmlSecNodeEnvelope: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeEnvelope, 'xmlSecNodeEnvelope');
  Result := pxmlSecNodeEnvelope;
end;

var
   pxmlSecNodeFault: xmlCharPtr;

function xmlSecNodeFault: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeFault, 'xmlSecNodeFault');
  Result := pxmlSecNodeFault;
end;

var
   pxmlSecNodeFaultActor: xmlCharPtr;

function xmlSecNodeFaultActor: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeFaultActor, 'xmlSecNodeFaultActor');
  Result := pxmlSecNodeFaultActor;
end;

var
   pxmlSecNodeFaultCode: xmlCharPtr;

function xmlSecNodeFaultCode: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeFaultCode, 'xmlSecNodeFaultCode');
  Result := pxmlSecNodeFaultCode;
end;

var
   pxmlSecNodeFaultDetail: xmlCharPtr;

function xmlSecNodeFaultDetail: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeFaultDetail, 'xmlSecNodeFaultDetail');
  Result := pxmlSecNodeFaultDetail;
end;

var
   pxmlSecNodeFaultString: xmlCharPtr;

function xmlSecNodeFaultString: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeFaultString, 'xmlSecNodeFaultString');
  Result := pxmlSecNodeFaultString;
end;

var
   pxmlSecNodeHMACKeyValue: xmlCharPtr;

function xmlSecNodeHMACKeyValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeHMACKeyValue, 'xmlSecNodeHMACKeyValue');
  Result := pxmlSecNodeHMACKeyValue;
end;

var
   pxmlSecNodeHMACOutputLength: xmlCharPtr;

function xmlSecNodeHMACOutputLength: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeHMACOutputLength, 'xmlSecNodeHMACOutputLength');
  Result := pxmlSecNodeHMACOutputLength;
end;

var
   pxmlSecNodeHeader: xmlCharPtr;

function xmlSecNodeHeader: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeHeader, 'xmlSecNodeHeader');
  Result := pxmlSecNodeHeader;
end;

var
   pxmlSecNodeInclusiveNamespaces: xmlCharPtr;

function xmlSecNodeInclusiveNamespaces: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeInclusiveNamespaces, 'xmlSecNodeInclusiveNamespaces');
  Result := pxmlSecNodeInclusiveNamespaces;
end;

var
   pxmlSecNodeIndeterminateReason: xmlCharPtr;

function xmlSecNodeIndeterminateReason: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeIndeterminateReason, 'xmlSecNodeIndeterminateReason');
  Result := pxmlSecNodeIndeterminateReason;
end;

var
   pxmlSecNodeInvalidReason: xmlCharPtr;

function xmlSecNodeInvalidReason: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeInvalidReason, 'xmlSecNodeInvalidReason');
  Result := pxmlSecNodeInvalidReason;
end;

var
   pxmlSecNodeKeyInfo: xmlCharPtr;

function xmlSecNodeKeyInfo: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeKeyInfo, 'xmlSecNodeKeyInfo');
  Result := pxmlSecNodeKeyInfo;
end;

var
   pxmlSecNodeKeyName: xmlCharPtr;

function xmlSecNodeKeyName: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeKeyName, 'xmlSecNodeKeyName');
  Result := pxmlSecNodeKeyName;
end;

var
   pxmlSecNodeKeyReference: xmlCharPtr;

function xmlSecNodeKeyReference: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeKeyReference, 'xmlSecNodeKeyReference');
  Result := pxmlSecNodeKeyReference;
end;

var
   pxmlSecNodeKeyUsage: xmlCharPtr;

function xmlSecNodeKeyUsage: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeKeyUsage, 'xmlSecNodeKeyUsage');
  Result := pxmlSecNodeKeyUsage;
end;

var
   pxmlSecNodeKeyValue: xmlCharPtr;

function xmlSecNodeKeyValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeKeyValue, 'xmlSecNodeKeyValue');
  Result := pxmlSecNodeKeyValue;
end;

var
   pxmlSecNodeLocateRequest: xmlCharPtr;

function xmlSecNodeLocateRequest: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeLocateRequest, 'xmlSecNodeLocateRequest');
  Result := pxmlSecNodeLocateRequest;
end;

var
   pxmlSecNodeLocateResult: xmlCharPtr;

function xmlSecNodeLocateResult: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeLocateResult, 'xmlSecNodeLocateResult');
  Result := pxmlSecNodeLocateResult;
end;

var
   pxmlSecNodeManifest: xmlCharPtr;

function xmlSecNodeManifest: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeManifest, 'xmlSecNodeManifest');
  Result := pxmlSecNodeManifest;
end;

var
   pxmlSecNodeMessageExtension: xmlCharPtr;

function xmlSecNodeMessageExtension: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeMessageExtension, 'xmlSecNodeMessageExtension');
  Result := pxmlSecNodeMessageExtension;
end;

var
   pxmlSecNodeNode: xmlCharPtr;

function xmlSecNodeNode: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeNode, 'xmlSecNodeNode');
  Result := pxmlSecNodeNode;
end;

var
   pxmlSecNodeObject: xmlCharPtr;

function xmlSecNodeObject: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeObject, 'xmlSecNodeObject');
  Result := pxmlSecNodeObject;
end;

var
   pxmlSecNodeOpaqueClientData: xmlCharPtr;

function xmlSecNodeOpaqueClientData: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeOpaqueClientData, 'xmlSecNodeOpaqueClientData');
  Result := pxmlSecNodeOpaqueClientData;
end;

var
   pxmlSecNodePGPData: xmlCharPtr;

function xmlSecNodePGPData: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodePGPData, 'xmlSecNodePGPData');
  Result := pxmlSecNodePGPData;
end;

var
   pxmlSecNodePendingNotification: xmlCharPtr;

function xmlSecNodePendingNotification: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodePendingNotification, 'xmlSecNodePendingNotification');
  Result := pxmlSecNodePendingNotification;
end;

var
   pxmlSecNodeQueryKeyBinding: xmlCharPtr;

function xmlSecNodeQueryKeyBinding: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeQueryKeyBinding, 'xmlSecNodeQueryKeyBinding');
  Result := pxmlSecNodeQueryKeyBinding;
end;

var
   pxmlSecNodeRSAExponent: xmlCharPtr;

function xmlSecNodeRSAExponent: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeRSAExponent, 'xmlSecNodeRSAExponent');
  Result := pxmlSecNodeRSAExponent;
end;

var
   pxmlSecNodeRSAKeyValue: xmlCharPtr;

function xmlSecNodeRSAKeyValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeRSAKeyValue, 'xmlSecNodeRSAKeyValue');
  Result := pxmlSecNodeRSAKeyValue;
end;

var
   pxmlSecNodeRSAModulus: xmlCharPtr;

function xmlSecNodeRSAModulus: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeRSAModulus, 'xmlSecNodeRSAModulus');
  Result := pxmlSecNodeRSAModulus;
end;

var
   pxmlSecNodeRSAPrivateExponent: xmlCharPtr;

function xmlSecNodeRSAPrivateExponent: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeRSAPrivateExponent, 'xmlSecNodeRSAPrivateExponent');
  Result := pxmlSecNodeRSAPrivateExponent;
end;

var
   pxmlSecNodeReason: xmlCharPtr;

function xmlSecNodeReason: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeReason, 'xmlSecNodeReason');
  Result := pxmlSecNodeReason;
end;

var
   pxmlSecNodeReference: xmlCharPtr;

function xmlSecNodeReference: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeReference, 'xmlSecNodeReference');
  Result := pxmlSecNodeReference;
end;

var
   pxmlSecNodeReferenceList: xmlCharPtr;

function xmlSecNodeReferenceList: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeReferenceList, 'xmlSecNodeReferenceList');
  Result := pxmlSecNodeReferenceList;
end;

var
   pxmlSecNodeRequestSignatureValue: xmlCharPtr;

function xmlSecNodeRequestSignatureValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeRequestSignatureValue, 'xmlSecNodeRequestSignatureValue');
  Result := pxmlSecNodeRequestSignatureValue;
end;

var
   pxmlSecNodeRespondWith: xmlCharPtr;

function xmlSecNodeRespondWith: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeRespondWith, 'xmlSecNodeRespondWith');
  Result := pxmlSecNodeRespondWith;
end;

var
   pxmlSecNodeResponseMechanism: xmlCharPtr;

function xmlSecNodeResponseMechanism: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeResponseMechanism, 'xmlSecNodeResponseMechanism');
  Result := pxmlSecNodeResponseMechanism;
end;

var
   pxmlSecNodeResult: xmlCharPtr;

function xmlSecNodeResult: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeResult, 'xmlSecNodeResult');
  Result := pxmlSecNodeResult;
end;

var
   pxmlSecNodeRetrievalMethod: xmlCharPtr;

function xmlSecNodeRetrievalMethod: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeRetrievalMethod, 'xmlSecNodeRetrievalMethod');
  Result := pxmlSecNodeRetrievalMethod;
end;

var
   pxmlSecNodeRole: xmlCharPtr;

function xmlSecNodeRole: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeRole, 'xmlSecNodeRole');
  Result := pxmlSecNodeRole;
end;

var
   pxmlSecNodeRsaOAEPparams: xmlCharPtr;

function xmlSecNodeRsaOAEPparams: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeRsaOAEPparams, 'xmlSecNodeRsaOAEPparams');
  Result := pxmlSecNodeRsaOAEPparams;
end;

var
   pxmlSecNodeSPKIData: xmlCharPtr;

function xmlSecNodeSPKIData: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeSPKIData, 'xmlSecNodeSPKIData');
  Result := pxmlSecNodeSPKIData;
end;

var
   pxmlSecNodeSignature: xmlCharPtr;

function xmlSecNodeSignature: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeSignature, 'xmlSecNodeSignature');
  Result := pxmlSecNodeSignature;
end;

var
   pxmlSecNodeSignatureMethod: xmlCharPtr;

function xmlSecNodeSignatureMethod: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeSignatureMethod, 'xmlSecNodeSignatureMethod');
  Result := pxmlSecNodeSignatureMethod;
end;

var
   pxmlSecNodeSignatureProperties: xmlCharPtr;

function xmlSecNodeSignatureProperties: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeSignatureProperties, 'xmlSecNodeSignatureProperties');
  Result := pxmlSecNodeSignatureProperties;
end;

var
   pxmlSecNodeSignatureValue: xmlCharPtr;

function xmlSecNodeSignatureValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeSignatureValue, 'xmlSecNodeSignatureValue');
  Result := pxmlSecNodeSignatureValue;
end;

var
   pxmlSecNodeSignedInfo: xmlCharPtr;

function xmlSecNodeSignedInfo: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeSignedInfo, 'xmlSecNodeSignedInfo');
  Result := pxmlSecNodeSignedInfo;
end;

var
   pxmlSecNodeStatus: xmlCharPtr;

function xmlSecNodeStatus: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeStatus, 'xmlSecNodeStatus');
  Result := pxmlSecNodeStatus;
end;

var
   pxmlSecNodeStatusRequest: xmlCharPtr;

function xmlSecNodeStatusRequest: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeStatusRequest, 'xmlSecNodeStatusRequest');
  Result := pxmlSecNodeStatusRequest;
end;

var
   pxmlSecNodeStatusResult: xmlCharPtr;

function xmlSecNodeStatusResult: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeStatusResult, 'xmlSecNodeStatusResult');
  Result := pxmlSecNodeStatusResult;
end;

var
   pxmlSecNodeSubcode: xmlCharPtr;

function xmlSecNodeSubcode: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeSubcode, 'xmlSecNodeSubcode');
  Result := pxmlSecNodeSubcode;
end;

var
   pxmlSecNodeText: xmlCharPtr;

function xmlSecNodeText: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeText, 'xmlSecNodeText');
  Result := pxmlSecNodeText;
end;

var
   pxmlSecNodeTimeInstant: xmlCharPtr;

function xmlSecNodeTimeInstant: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeTimeInstant, 'xmlSecNodeTimeInstant');
  Result := pxmlSecNodeTimeInstant;
end;

var
   pxmlSecNodeTransform: xmlCharPtr;

function xmlSecNodeTransform: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeTransform, 'xmlSecNodeTransform');
  Result := pxmlSecNodeTransform;
end;

var
   pxmlSecNodeTransforms: xmlCharPtr;

function xmlSecNodeTransforms: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeTransforms, 'xmlSecNodeTransforms');
  Result := pxmlSecNodeTransforms;
end;

var
   pxmlSecNodeUnverifiedKeyBinding: xmlCharPtr;

function xmlSecNodeUnverifiedKeyBinding: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeUnverifiedKeyBinding, 'xmlSecNodeUnverifiedKeyBinding');
  Result := pxmlSecNodeUnverifiedKeyBinding;
end;

var
   pxmlSecNodeUseKeyWith: xmlCharPtr;

function xmlSecNodeUseKeyWith: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeUseKeyWith, 'xmlSecNodeUseKeyWith');
  Result := pxmlSecNodeUseKeyWith;
end;

var
   pxmlSecNodeValidReason: xmlCharPtr;

function xmlSecNodeValidReason: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeValidReason, 'xmlSecNodeValidReason');
  Result := pxmlSecNodeValidReason;
end;

var
   pxmlSecNodeValidateRequest: xmlCharPtr;

function xmlSecNodeValidateRequest: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeValidateRequest, 'xmlSecNodeValidateRequest');
  Result := pxmlSecNodeValidateRequest;
end;

var
   pxmlSecNodeValidateResult: xmlCharPtr;

function xmlSecNodeValidateResult: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeValidateResult, 'xmlSecNodeValidateResult');
  Result := pxmlSecNodeValidateResult;
end;

var
   pxmlSecNodeValidityInterval: xmlCharPtr;

function xmlSecNodeValidityInterval: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeValidityInterval, 'xmlSecNodeValidityInterval');
  Result := pxmlSecNodeValidityInterval;
end;

var
   pxmlSecNodeValue: xmlCharPtr;

function xmlSecNodeValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeValue, 'xmlSecNodeValue');
  Result := pxmlSecNodeValue;
end;

var
   pxmlSecNodeX509CRL: xmlCharPtr;

function xmlSecNodeX509CRL: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeX509CRL, 'xmlSecNodeX509CRL');
  Result := pxmlSecNodeX509CRL;
end;

var
   pxmlSecNodeX509Certificate: xmlCharPtr;

function xmlSecNodeX509Certificate: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeX509Certificate, 'xmlSecNodeX509Certificate');
  Result := pxmlSecNodeX509Certificate;
end;

var
   pxmlSecNodeX509Data: xmlCharPtr;

function xmlSecNodeX509Data: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeX509Data, 'xmlSecNodeX509Data');
  Result := pxmlSecNodeX509Data;
end;

var
   pxmlSecNodeX509IssuerName: xmlCharPtr;

function xmlSecNodeX509IssuerName: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeX509IssuerName, 'xmlSecNodeX509IssuerName');
  Result := pxmlSecNodeX509IssuerName;
end;

var
   pxmlSecNodeX509IssuerSerial: xmlCharPtr;

function xmlSecNodeX509IssuerSerial: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeX509IssuerSerial, 'xmlSecNodeX509IssuerSerial');
  Result := pxmlSecNodeX509IssuerSerial;
end;

var
   pxmlSecNodeX509SKI: xmlCharPtr;

function xmlSecNodeX509SKI: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeX509SKI, 'xmlSecNodeX509SKI');
  Result := pxmlSecNodeX509SKI;
end;

var
   pxmlSecNodeX509SerialNumber: xmlCharPtr;

function xmlSecNodeX509SerialNumber: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeX509SerialNumber, 'xmlSecNodeX509SerialNumber');
  Result := pxmlSecNodeX509SerialNumber;
end;

var
   pxmlSecNodeX509SubjectName: xmlCharPtr;

function xmlSecNodeX509SubjectName: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeX509SubjectName, 'xmlSecNodeX509SubjectName');
  Result := pxmlSecNodeX509SubjectName;
end;

var
   pxmlSecNodeXPath: xmlCharPtr;

function xmlSecNodeXPath: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeXPath, 'xmlSecNodeXPath');
  Result := pxmlSecNodeXPath;
end;

var
   pxmlSecNodeXPath2: xmlCharPtr;

function xmlSecNodeXPath2: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeXPath2, 'xmlSecNodeXPath2');
  Result := pxmlSecNodeXPath2;
end;

var
   pxmlSecNodeXPointer: xmlCharPtr;

function xmlSecNodeXPointer: xmlCharPtr;
begin
  CheckForNil(pxmlSecNodeXPointer, 'xmlSecNodeXPointer');
  Result := pxmlSecNodeXPointer;
end;

var
   pxmlSecNs: xmlCharPtr;

function xmlSecNs: xmlCharPtr;
begin
  CheckForNil(pxmlSecNs, 'xmlSecNs');
  Result := pxmlSecNs;
end;

var
   pxmlSecNsExcC14N: xmlCharPtr;

function xmlSecNsExcC14N: xmlCharPtr;
begin
  CheckForNil(pxmlSecNsExcC14N, 'xmlSecNsExcC14N');
  Result := pxmlSecNsExcC14N;
end;

var
   pxmlSecNsExcC14NWithComments: xmlCharPtr;

function xmlSecNsExcC14NWithComments: xmlCharPtr;
begin
  CheckForNil(pxmlSecNsExcC14NWithComments, 'xmlSecNsExcC14NWithComments');
  Result := pxmlSecNsExcC14NWithComments;
end;

var
   pxmlSecRespondWithKeyName: xmlCharPtr;

function xmlSecRespondWithKeyName: xmlCharPtr;
begin
  CheckForNil(pxmlSecRespondWithKeyName, 'xmlSecRespondWithKeyName');
  Result := pxmlSecRespondWithKeyName;
end;

var
   pxmlSecRespondWithKeyValue: xmlCharPtr;

function xmlSecRespondWithKeyValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecRespondWithKeyValue, 'xmlSecRespondWithKeyValue');
  Result := pxmlSecRespondWithKeyValue;
end;

var
   pxmlSecRespondWithOCSP: xmlCharPtr;

function xmlSecRespondWithOCSP: xmlCharPtr;
begin
  CheckForNil(pxmlSecRespondWithOCSP, 'xmlSecRespondWithOCSP');
  Result := pxmlSecRespondWithOCSP;
end;

var
   pxmlSecRespondWithPGP: xmlCharPtr;

function xmlSecRespondWithPGP: xmlCharPtr;
begin
  CheckForNil(pxmlSecRespondWithPGP, 'xmlSecRespondWithPGP');
  Result := pxmlSecRespondWithPGP;
end;

var
   pxmlSecRespondWithPGPWeb: xmlCharPtr;

function xmlSecRespondWithPGPWeb: xmlCharPtr;
begin
  CheckForNil(pxmlSecRespondWithPGPWeb, 'xmlSecRespondWithPGPWeb');
  Result := pxmlSecRespondWithPGPWeb;
end;

var
   pxmlSecRespondWithPrivateKey: xmlCharPtr;

function xmlSecRespondWithPrivateKey: xmlCharPtr;
begin
  CheckForNil(pxmlSecRespondWithPrivateKey, 'xmlSecRespondWithPrivateKey');
  Result := pxmlSecRespondWithPrivateKey;
end;

var
   pxmlSecRespondWithRetrievalMethod: xmlCharPtr;

function xmlSecRespondWithRetrievalMethod: xmlCharPtr;
begin
  CheckForNil(pxmlSecRespondWithRetrievalMethod, 'xmlSecRespondWithRetrievalMethod');
  Result := pxmlSecRespondWithRetrievalMethod;
end;

var
   pxmlSecRespondWithSPKI: xmlCharPtr;

function xmlSecRespondWithSPKI: xmlCharPtr;
begin
  CheckForNil(pxmlSecRespondWithSPKI, 'xmlSecRespondWithSPKI');
  Result := pxmlSecRespondWithSPKI;
end;

var
   pxmlSecRespondWithX509CRL: xmlCharPtr;

function xmlSecRespondWithX509CRL: xmlCharPtr;
begin
  CheckForNil(pxmlSecRespondWithX509CRL, 'xmlSecRespondWithX509CRL');
  Result := pxmlSecRespondWithX509CRL;
end;

var
   pxmlSecRespondWithX509Cert: xmlCharPtr;

function xmlSecRespondWithX509Cert: xmlCharPtr;
begin
  CheckForNil(pxmlSecRespondWithX509Cert, 'xmlSecRespondWithX509Cert');
  Result := pxmlSecRespondWithX509Cert;
end;

var
   pxmlSecRespondWithX509Chain: xmlCharPtr;

function xmlSecRespondWithX509Chain: xmlCharPtr;
begin
  CheckForNil(pxmlSecRespondWithX509Chain, 'xmlSecRespondWithX509Chain');
  Result := pxmlSecRespondWithX509Chain;
end;

var
   pxmlSecResponseMechanismPending: xmlCharPtr;

function xmlSecResponseMechanismPending: xmlCharPtr;
begin
  CheckForNil(pxmlSecResponseMechanismPending, 'xmlSecResponseMechanismPending');
  Result := pxmlSecResponseMechanismPending;
end;

var
   pxmlSecResponseMechanismRepresent: xmlCharPtr;

function xmlSecResponseMechanismRepresent: xmlCharPtr;
begin
  CheckForNil(pxmlSecResponseMechanismRepresent, 'xmlSecResponseMechanismRepresent');
  Result := pxmlSecResponseMechanismRepresent;
end;

var
   pxmlSecResponseMechanismRequestSignatureValue: xmlCharPtr;

function xmlSecResponseMechanismRequestSignatureValue: xmlCharPtr;
begin
  CheckForNil(pxmlSecResponseMechanismRequestSignatureValue, 'xmlSecResponseMechanismRequestSignatureValue');
  Result := pxmlSecResponseMechanismRequestSignatureValue;
end;

var
   pxmlSecResultMajorCodePending: xmlCharPtr;

function xmlSecResultMajorCodePending: xmlCharPtr;
begin
  CheckForNil(pxmlSecResultMajorCodePending, 'xmlSecResultMajorCodePending');
  Result := pxmlSecResultMajorCodePending;
end;

var
   pxmlSecResultMajorCodeReceiver: xmlCharPtr;

function xmlSecResultMajorCodeReceiver: xmlCharPtr;
begin
  CheckForNil(pxmlSecResultMajorCodeReceiver, 'xmlSecResultMajorCodeReceiver');
  Result := pxmlSecResultMajorCodeReceiver;
end;

var
   pxmlSecResultMajorCodeRepresent: xmlCharPtr;

function xmlSecResultMajorCodeRepresent: xmlCharPtr;
begin
  CheckForNil(pxmlSecResultMajorCodeRepresent, 'xmlSecResultMajorCodeRepresent');
  Result := pxmlSecResultMajorCodeRepresent;
end;

var
   pxmlSecResultMajorCodeSender: xmlCharPtr;

function xmlSecResultMajorCodeSender: xmlCharPtr;
begin
  CheckForNil(pxmlSecResultMajorCodeSender, 'xmlSecResultMajorCodeSender');
  Result := pxmlSecResultMajorCodeSender;
end;

var
   pxmlSecResultMajorCodeSuccess: xmlCharPtr;

function xmlSecResultMajorCodeSuccess: xmlCharPtr;
begin
  CheckForNil(pxmlSecResultMajorCodeSuccess, 'xmlSecResultMajorCodeSuccess');
  Result := pxmlSecResultMajorCodeSuccess;
end;

var
   pxmlSecResultMajorCodeVersionMismatch: xmlCharPtr;

function xmlSecResultMajorCodeVersionMismatch: xmlCharPtr;
begin
  CheckForNil(pxmlSecResultMajorCodeVersionMismatch, 'xmlSecResultMajorCodeVersionMismatch');
  Result := pxmlSecResultMajorCodeVersionMismatch;
end;

var
   pxmlSecResultMinorCodeFailure: xmlCharPtr;

function xmlSecResultMinorCodeFailure: xmlCharPtr;
begin
  CheckForNil(pxmlSecResultMinorCodeFailure, 'xmlSecResultMinorCodeFailure');
  Result := pxmlSecResultMinorCodeFailure;
end;

var
   pxmlSecResultMinorCodeIncomplete: xmlCharPtr;

function xmlSecResultMinorCodeIncomplete: xmlCharPtr;
begin
  CheckForNil(pxmlSecResultMinorCodeIncomplete, 'xmlSecResultMinorCodeIncomplete');
  Result := pxmlSecResultMinorCodeIncomplete;
end;

var
   pxmlSecResultMinorCodeMessageNotSupported: xmlCharPtr;

function xmlSecResultMinorCodeMessageNotSupported: xmlCharPtr;
begin
  CheckForNil(pxmlSecResultMinorCodeMessageNotSupported, 'xmlSecResultMinorCodeMessageNotSupported');
  Result := pxmlSecResultMinorCodeMessageNotSupported;
end;

var
   pxmlSecResultMinorCodeNoAuthentication: xmlCharPtr;

function xmlSecResultMinorCodeNoAuthentication: xmlCharPtr;
begin
  CheckForNil(pxmlSecResultMinorCodeNoAuthentication, 'xmlSecResultMinorCodeNoAuthentication');
  Result := pxmlSecResultMinorCodeNoAuthentication;
end;

var
   pxmlSecResultMinorCodeNoMatch: xmlCharPtr;

function xmlSecResultMinorCodeNoMatch: xmlCharPtr;
begin
  CheckForNil(pxmlSecResultMinorCodeNoMatch, 'xmlSecResultMinorCodeNoMatch');
  Result := pxmlSecResultMinorCodeNoMatch;
end;

var
   pxmlSecResultMinorCodeNotSynchronous: xmlCharPtr;

function xmlSecResultMinorCodeNotSynchronous: xmlCharPtr;
begin
  CheckForNil(pxmlSecResultMinorCodeNotSynchronous, 'xmlSecResultMinorCodeNotSynchronous');
  Result := pxmlSecResultMinorCodeNotSynchronous;
end;

var
   pxmlSecResultMinorCodeRefused: xmlCharPtr;

function xmlSecResultMinorCodeRefused: xmlCharPtr;
begin
  CheckForNil(pxmlSecResultMinorCodeRefused, 'xmlSecResultMinorCodeRefused');
  Result := pxmlSecResultMinorCodeRefused;
end;

var
   pxmlSecResultMinorCodeTooManyResponses: xmlCharPtr;

function xmlSecResultMinorCodeTooManyResponses: xmlCharPtr;
begin
  CheckForNil(pxmlSecResultMinorCodeTooManyResponses, 'xmlSecResultMinorCodeTooManyResponses');
  Result := pxmlSecResultMinorCodeTooManyResponses;
end;

var
   pxmlSecResultMinorCodeUnknownResponseId: xmlCharPtr;

function xmlSecResultMinorCodeUnknownResponseId: xmlCharPtr;
begin
  CheckForNil(pxmlSecResultMinorCodeUnknownResponseId, 'xmlSecResultMinorCodeUnknownResponseId');
  Result := pxmlSecResultMinorCodeUnknownResponseId;
end;

var
   pxmlSecSoap11Ns: xmlCharPtr;

function xmlSecSoap11Ns: xmlCharPtr;
begin
  CheckForNil(pxmlSecSoap11Ns, 'xmlSecSoap11Ns');
  Result := pxmlSecSoap11Ns;
end;

var
   pxmlSecSoap12Ns: xmlCharPtr;

function xmlSecSoap12Ns: xmlCharPtr;
begin
  CheckForNil(pxmlSecSoap12Ns, 'xmlSecSoap12Ns');
  Result := pxmlSecSoap12Ns;
end;

var
   pxmlSecSoapFaultCodeClient: xmlCharPtr;

function xmlSecSoapFaultCodeClient: xmlCharPtr;
begin
  CheckForNil(pxmlSecSoapFaultCodeClient, 'xmlSecSoapFaultCodeClient');
  Result := pxmlSecSoapFaultCodeClient;
end;

var
   pxmlSecSoapFaultCodeMustUnderstand: xmlCharPtr;

function xmlSecSoapFaultCodeMustUnderstand: xmlCharPtr;
begin
  CheckForNil(pxmlSecSoapFaultCodeMustUnderstand, 'xmlSecSoapFaultCodeMustUnderstand');
  Result := pxmlSecSoapFaultCodeMustUnderstand;
end;

var
   pxmlSecSoapFaultCodeReceiver: xmlCharPtr;

function xmlSecSoapFaultCodeReceiver: xmlCharPtr;
begin
  CheckForNil(pxmlSecSoapFaultCodeReceiver, 'xmlSecSoapFaultCodeReceiver');
  Result := pxmlSecSoapFaultCodeReceiver;
end;

var
   pxmlSecSoapFaultCodeSender: xmlCharPtr;

function xmlSecSoapFaultCodeSender: xmlCharPtr;
begin
  CheckForNil(pxmlSecSoapFaultCodeSender, 'xmlSecSoapFaultCodeSender');
  Result := pxmlSecSoapFaultCodeSender;
end;

var
   pxmlSecSoapFaultCodeServer: xmlCharPtr;

function xmlSecSoapFaultCodeServer: xmlCharPtr;
begin
  CheckForNil(pxmlSecSoapFaultCodeServer, 'xmlSecSoapFaultCodeServer');
  Result := pxmlSecSoapFaultCodeServer;
end;

var
   pxmlSecSoapFaultCodeVersionMismatch: xmlCharPtr;

function xmlSecSoapFaultCodeVersionMismatch: xmlCharPtr;
begin
  CheckForNil(pxmlSecSoapFaultCodeVersionMismatch, 'xmlSecSoapFaultCodeVersionMismatch');
  Result := pxmlSecSoapFaultCodeVersionMismatch;
end;

var
   pxmlSecSoapFaultDataEncodningUnknown: xmlCharPtr;

function xmlSecSoapFaultDataEncodningUnknown: xmlCharPtr;
begin
  CheckForNil(pxmlSecSoapFaultDataEncodningUnknown, 'xmlSecSoapFaultDataEncodningUnknown');
  Result := pxmlSecSoapFaultDataEncodningUnknown;
end;

var
   pxmlSecStatusResultFailed: xmlCharPtr;

function xmlSecStatusResultFailed: xmlCharPtr;
begin
  CheckForNil(pxmlSecStatusResultFailed, 'xmlSecStatusResultFailed');
  Result := pxmlSecStatusResultFailed;
end;

var
   pxmlSecStatusResultPending: xmlCharPtr;

function xmlSecStatusResultPending: xmlCharPtr;
begin
  CheckForNil(pxmlSecStatusResultPending, 'xmlSecStatusResultPending');
  Result := pxmlSecStatusResultPending;
end;

var
   pxmlSecStatusResultSuccess: xmlCharPtr;

function xmlSecStatusResultSuccess: xmlCharPtr;
begin
  CheckForNil(pxmlSecStatusResultSuccess, 'xmlSecStatusResultSuccess');
  Result := pxmlSecStatusResultSuccess;
end;

var
   pxmlSecStringCR: xmlCharPtr;

function xmlSecStringCR: xmlCharPtr;
begin
  CheckForNil(pxmlSecStringCR, 'xmlSecStringCR');
  Result := pxmlSecStringCR;
end;

var
   pxmlSecStringEmpty: xmlCharPtr;

function xmlSecStringEmpty: xmlCharPtr;
begin
  CheckForNil(pxmlSecStringEmpty, 'xmlSecStringEmpty');
  Result := pxmlSecStringEmpty;
end;

var
   pxmlSecTypeEncContent: xmlCharPtr;

function xmlSecTypeEncContent: xmlCharPtr;
begin
  CheckForNil(pxmlSecTypeEncContent, 'xmlSecTypeEncContent');
  Result := pxmlSecTypeEncContent;
end;

var
   pxmlSecTypeEncElement: xmlCharPtr;

function xmlSecTypeEncElement: xmlCharPtr;
begin
  CheckForNil(pxmlSecTypeEncElement, 'xmlSecTypeEncElement');
  Result := pxmlSecTypeEncElement;
end;

var
   pxmlSecXPath2FilterIntersect: xmlCharPtr;

function xmlSecXPath2FilterIntersect: xmlCharPtr;
begin
  CheckForNil(pxmlSecXPath2FilterIntersect, 'xmlSecXPath2FilterIntersect');
  Result := pxmlSecXPath2FilterIntersect;
end;

var
   pxmlSecXPath2FilterSubtract: xmlCharPtr;

function xmlSecXPath2FilterSubtract: xmlCharPtr;
begin
  CheckForNil(pxmlSecXPath2FilterSubtract, 'xmlSecXPath2FilterSubtract');
  Result := pxmlSecXPath2FilterSubtract;
end;

var
   pxmlSecXPath2FilterUnion: xmlCharPtr;

function xmlSecXPath2FilterUnion: xmlCharPtr;
begin
  CheckForNil(pxmlSecXPath2FilterUnion, 'xmlSecXPath2FilterUnion');
  Result := pxmlSecXPath2FilterUnion;
end;

var
   pxmlSecXPath2Ns: xmlCharPtr;

function xmlSecXPath2Ns: xmlCharPtr;
begin
  CheckForNil(pxmlSecXPath2Ns, 'xmlSecXPath2Ns');
  Result := pxmlSecXPath2Ns;
end;

var
   pxmlSecXPathNs: xmlCharPtr;

function xmlSecXPathNs: xmlCharPtr;
begin
  CheckForNil(pxmlSecXPathNs, 'xmlSecXPathNs');
  Result := pxmlSecXPathNs;
end;

var
   pxmlSecXPointerNs: xmlCharPtr;

function xmlSecXPointerNs: xmlCharPtr;
begin
  CheckForNil(pxmlSecXPointerNs, 'xmlSecXPointerNs');
  Result := pxmlSecXPointerNs;
end;

var
   pxmlSecXkmsFormatStrPlain: xmlCharPtr;

function xmlSecXkmsFormatStrPlain: xmlCharPtr;
begin
  CheckForNil(pxmlSecXkmsFormatStrPlain, 'xmlSecXkmsFormatStrPlain');
  Result := pxmlSecXkmsFormatStrPlain;
end;

var
   pxmlSecXkmsFormatStrSoap11: xmlCharPtr;

function xmlSecXkmsFormatStrSoap11: xmlCharPtr;
begin
  CheckForNil(pxmlSecXkmsFormatStrSoap11, 'xmlSecXkmsFormatStrSoap11');
  Result := pxmlSecXkmsFormatStrSoap11;
end;

var
   pxmlSecXkmsFormatStrSoap12: xmlCharPtr;

function xmlSecXkmsFormatStrSoap12: xmlCharPtr;
begin
  CheckForNil(pxmlSecXkmsFormatStrSoap12, 'xmlSecXkmsFormatStrSoap12');
  Result := pxmlSecXkmsFormatStrSoap12;
end;

var
   pxmlSecXkmsNs: xmlCharPtr;

function xmlSecXkmsNs: xmlCharPtr;
begin
  CheckForNil(pxmlSecXkmsNs, 'xmlSecXkmsNs');
  Result := pxmlSecXkmsNs;
end;

var
   pxmlSecXkmsServerRequestCompoundName: xmlCharPtr;

function xmlSecXkmsServerRequestCompoundName: xmlCharPtr;
begin
  CheckForNil(pxmlSecXkmsServerRequestCompoundName, 'xmlSecXkmsServerRequestCompoundName');
  Result := pxmlSecXkmsServerRequestCompoundName;
end;

var
   pxmlSecXkmsServerRequestLocateName: xmlCharPtr;

function xmlSecXkmsServerRequestLocateName: xmlCharPtr;
begin
  CheckForNil(pxmlSecXkmsServerRequestLocateName, 'xmlSecXkmsServerRequestLocateName');
  Result := pxmlSecXkmsServerRequestLocateName;
end;

var
   pxmlSecXkmsServerRequestResultName: xmlCharPtr;

function xmlSecXkmsServerRequestResultName: xmlCharPtr;
begin
  CheckForNil(pxmlSecXkmsServerRequestResultName, 'xmlSecXkmsServerRequestResultName');
  Result := pxmlSecXkmsServerRequestResultName;
end;

var
   pxmlSecXkmsServerRequestStatusName: xmlCharPtr;

function xmlSecXkmsServerRequestStatusName: xmlCharPtr;
begin
  CheckForNil(pxmlSecXkmsServerRequestStatusName, 'xmlSecXkmsServerRequestStatusName');
  Result := pxmlSecXkmsServerRequestStatusName;
end;

var
   pxmlSecXkmsServerRequestValidateName: xmlCharPtr;

function xmlSecXkmsServerRequestValidateName: xmlCharPtr;
begin
  CheckForNil(pxmlSecXkmsServerRequestValidateName, 'xmlSecXkmsServerRequestValidateName');
  Result := pxmlSecXkmsServerRequestValidateName;
end;

var
   pxmlSecXkmsSoapFaultReasonLang: xmlCharPtr;

function xmlSecXkmsSoapFaultReasonLang: xmlCharPtr;
begin
  CheckForNil(pxmlSecXkmsSoapFaultReasonLang, 'xmlSecXkmsSoapFaultReasonLang');
  Result := pxmlSecXkmsSoapFaultReasonLang;
end;

var
   pxmlSecXkmsSoapFaultReasonMessageInvalid: xmlCharPtr;

function xmlSecXkmsSoapFaultReasonMessageInvalid: xmlCharPtr;
begin
  CheckForNil(pxmlSecXkmsSoapFaultReasonMessageInvalid, 'xmlSecXkmsSoapFaultReasonMessageInvalid');
  Result := pxmlSecXkmsSoapFaultReasonMessageInvalid;
end;

var
   pxmlSecXkmsSoapFaultReasonMessageNotSupported: xmlCharPtr;

function xmlSecXkmsSoapFaultReasonMessageNotSupported: xmlCharPtr;
begin
  CheckForNil(pxmlSecXkmsSoapFaultReasonMessageNotSupported, 'xmlSecXkmsSoapFaultReasonMessageNotSupported');
  Result := pxmlSecXkmsSoapFaultReasonMessageNotSupported;
end;

var
   pxmlSecXkmsSoapFaultReasonServiceUnavailable: xmlCharPtr;

function xmlSecXkmsSoapFaultReasonServiceUnavailable: xmlCharPtr;
begin
  CheckForNil(pxmlSecXkmsSoapFaultReasonServiceUnavailable, 'xmlSecXkmsSoapFaultReasonServiceUnavailable');
  Result := pxmlSecXkmsSoapFaultReasonServiceUnavailable;
end;

var
   pxmlSecXkmsSoapFaultReasonUnableToProcess: xmlCharPtr;

function xmlSecXkmsSoapFaultReasonUnableToProcess: xmlCharPtr;
begin
  CheckForNil(pxmlSecXkmsSoapFaultReasonUnableToProcess, 'xmlSecXkmsSoapFaultReasonUnableToProcess');
  Result := pxmlSecXkmsSoapFaultReasonUnableToProcess;
end;

var
   pxmlSecXkmsSoapFaultReasonUnsupportedVersion: xmlCharPtr;

function xmlSecXkmsSoapFaultReasonUnsupportedVersion: xmlCharPtr;
begin
  CheckForNil(pxmlSecXkmsSoapFaultReasonUnsupportedVersion, 'xmlSecXkmsSoapFaultReasonUnsupportedVersion');
  Result := pxmlSecXkmsSoapFaultReasonUnsupportedVersion;
end;

var
   pxmlSecXkmsSoapSubcodeValueBadMessage: xmlCharPtr;

function xmlSecXkmsSoapSubcodeValueBadMessage: xmlCharPtr;
begin
  CheckForNil(pxmlSecXkmsSoapSubcodeValueBadMessage, 'xmlSecXkmsSoapSubcodeValueBadMessage');
  Result := pxmlSecXkmsSoapSubcodeValueBadMessage;
end;

var
   pxmlSecXkmsSoapSubcodeValueMessageNotSupported: xmlCharPtr;

function xmlSecXkmsSoapSubcodeValueMessageNotSupported: xmlCharPtr;
begin
  CheckForNil(pxmlSecXkmsSoapSubcodeValueMessageNotSupported, 'xmlSecXkmsSoapSubcodeValueMessageNotSupported');
  Result := pxmlSecXkmsSoapSubcodeValueMessageNotSupported;
end;



initialization
  // The Delphi 'external' directive can be used for functions and procedures,
  // but here we need to obtain the addresses of POINTERS to functions. We can
  // get to these addresses (and also those of other data values exported from
  // the DLL) by using GetProcAddress.
  libHandle := LoadLibrary(XMLSEC_SO);
  if libHandle <> 0 then
  begin
    pxmlSecAttrAlgorithm := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrAlgorithm'));
    pxmlSecAttrApplication := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrApplication'));
    pxmlSecAttrEncoding := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrEncoding'));
    pxmlSecAttrFilter := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrFilter'));
    pxmlSecAttrId := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrId'));
    pxmlSecAttrIdentifier := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrIdentifier'));
    pxmlSecAttrMechanism := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrMechanism'));
    pxmlSecAttrMimeType := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrMimeType'));
    pxmlSecAttrNonce := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrNonce'));
    pxmlSecAttrNotBefore := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrNotBefore'));
    pxmlSecAttrNotOnOrAfter := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrNotOnOrAfter'));
    pxmlSecAttrOriginalRequestId := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrOriginalRequestId'));
    pxmlSecAttrPrefixList := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrPrefixList'));
    pxmlSecAttrRecipient := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrRecipient'));
    pxmlSecAttrRequestId := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrRequestId'));
    pxmlSecAttrResponseLimit := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrResponseLimit'));
    pxmlSecAttrResultMajor := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrResultMajor'));
    pxmlSecAttrResultMinor := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrResultMinor'));
    pxmlSecAttrService := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrService'));
    pxmlSecAttrStatusValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrStatusValue'));
    pxmlSecAttrTarget := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrTarget'));
    pxmlSecAttrTime := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrTime'));
    pxmlSecAttrType := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrType'));
    pxmlSecAttrURI := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecAttrURI'));
    pxmlSecDSigNs := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecDSigNs'));
    pxmlSecEncNs := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecEncNs'));
    pxmlSecHrefAESKeyValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefAESKeyValue'));
    pxmlSecHrefAes128Cbc := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefAes128Cbc'));
    pxmlSecHrefAes192Cbc := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefAes192Cbc'));
    pxmlSecHrefAes256Cbc := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefAes256Cbc'));
    pxmlSecHrefBase64 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefBase64'));
    pxmlSecHrefC14N := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefC14N'));
    pxmlSecHrefC14NWithComments := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefC14NWithComments'));
    pxmlSecHrefDESKeyValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefDESKeyValue'));
    pxmlSecHrefDSAKeyValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefDSAKeyValue'));
    pxmlSecHrefDes3Cbc := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefDes3Cbc'));
    pxmlSecHrefDsaSha1 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefDsaSha1'));
    pxmlSecHrefEncryptedKey := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefEncryptedKey'));
    pxmlSecHrefEnveloped := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefEnveloped'));
    pxmlSecHrefExcC14N := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefExcC14N'));
    pxmlSecHrefExcC14NWithComments := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefExcC14NWithComments'));
    pxmlSecHrefHMACKeyValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefHMACKeyValue'));
    pxmlSecHrefHmacMd5 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefHmacMd5'));
    pxmlSecHrefHmacRipemd160 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefHmacRipemd160'));
    pxmlSecHrefHmacSha1 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefHmacSha1'));
    pxmlSecHrefKWAes128 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefKWAes128'));
    pxmlSecHrefKWAes192 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefKWAes192'));
    pxmlSecHrefKWAes256 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefKWAes256'));
    pxmlSecHrefKWDes3 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefKWDes3'));
    pxmlSecHrefPGPData := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefPGPData'));
    pxmlSecHrefRSAKeyValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefRSAKeyValue'));
    pxmlSecHrefRawX509Cert := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefRawX509Cert'));
    pxmlSecHrefRipemd160 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefRipemd160'));
    pxmlSecHrefRsaOaep := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefRsaOaep'));
    pxmlSecHrefRsaPkcs1 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefRsaPkcs1'));
    pxmlSecHrefRsaSha1 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefRsaSha1'));
    pxmlSecHrefSPKIData := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefSPKIData'));
    pxmlSecHrefSha1 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefSha1'));
    pxmlSecHrefX509Data := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefX509Data'));
    pxmlSecHrefXslt := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecHrefXslt'));
    pxmlSecKeyBindingReasonIssuerTrust := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecKeyBindingReasonIssuerTrust'));
    pxmlSecKeyBindingReasonRevocationStatus := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecKeyBindingReasonRevocationStatus'));
    pxmlSecKeyBindingReasonSignature := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecKeyBindingReasonSignature'));
    pxmlSecKeyBindingReasonValidityInterval := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecKeyBindingReasonValidityInterval'));
    pxmlSecKeyBindingStatusIndeterminate := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecKeyBindingStatusIndeterminate'));
    pxmlSecKeyBindingStatusInvalid := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecKeyBindingStatusInvalid'));
    pxmlSecKeyBindingStatusValid := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecKeyBindingStatusValid'));
    pxmlSecKeyUsageEncryption := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecKeyUsageEncryption'));
    pxmlSecKeyUsageExchange := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecKeyUsageExchange'));
    pxmlSecKeyUsageSignature := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecKeyUsageSignature'));
    pxmlSecNameAESKeyValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameAESKeyValue'));
    pxmlSecNameAes128Cbc := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameAes128Cbc'));
    pxmlSecNameAes192Cbc := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameAes192Cbc'));
    pxmlSecNameAes256Cbc := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameAes256Cbc'));
    pxmlSecNameBase64 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameBase64'));
    pxmlSecNameC14N := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameC14N'));
    pxmlSecNameC14NWithComments := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameC14NWithComments'));
    pxmlSecNameDESKeyValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameDESKeyValue'));
    pxmlSecNameDSAKeyValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameDSAKeyValue'));
    pxmlSecNameDes3Cbc := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameDes3Cbc'));
    pxmlSecNameDsaSha1 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameDsaSha1'));
    pxmlSecNameEncryptedKey := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameEncryptedKey'));
    pxmlSecNameEnveloped := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameEnveloped'));
    pxmlSecNameExcC14N := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameExcC14N'));
    pxmlSecNameExcC14NWithComments := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameExcC14NWithComments'));
    pxmlSecNameHMACKeyValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameHMACKeyValue'));
    pxmlSecNameHmacMd5 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameHmacMd5'));
    pxmlSecNameHmacRipemd160 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameHmacRipemd160'));
    pxmlSecNameHmacSha1 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameHmacSha1'));
    pxmlSecNameKWAes128 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameKWAes128'));
    pxmlSecNameKWAes192 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameKWAes192'));
    pxmlSecNameKWAes256 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameKWAes256'));
    pxmlSecNameKWDes3 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameKWDes3'));
    pxmlSecNameKeyName := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameKeyName'));
    pxmlSecNameKeyValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameKeyValue'));
    pxmlSecNameMemBuf := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameMemBuf'));
    pxmlSecNamePGPData := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNamePGPData'));
    pxmlSecNameRSAKeyValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameRSAKeyValue'));
    pxmlSecNameRawX509Cert := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameRawX509Cert'));
    pxmlSecNameRetrievalMethod := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameRetrievalMethod'));
    pxmlSecNameRipemd160 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameRipemd160'));
    pxmlSecNameRsaOaep := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameRsaOaep'));
    pxmlSecNameRsaPkcs1 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameRsaPkcs1'));
    pxmlSecNameRsaSha1 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameRsaSha1'));
    pxmlSecNameSPKIData := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameSPKIData'));
    pxmlSecNameSha1 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameSha1'));
    pxmlSecNameX509Data := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameX509Data'));
    pxmlSecNameX509Store := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameX509Store'));
    pxmlSecNameXPath := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameXPath'));
    pxmlSecNameXPath2 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameXPath2'));
    pxmlSecNameXPointer := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameXPointer'));
    pxmlSecNameXslt := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNameXslt'));
    pxmlSecNodeAESKeyValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeAESKeyValue'));
    pxmlSecNodeBody := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeBody'));
    pxmlSecNodeCanonicalizationMethod := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeCanonicalizationMethod'));
    pxmlSecNodeCarriedKeyName := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeCarriedKeyName'));
    pxmlSecNodeCipherData := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeCipherData'));
    pxmlSecNodeCipherReference := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeCipherReference'));
    pxmlSecNodeCipherValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeCipherValue'));
    pxmlSecNodeCode := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeCode'));
    pxmlSecNodeCompoundRequest := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeCompoundRequest'));
    pxmlSecNodeCompoundResult := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeCompoundResult'));
    pxmlSecNodeDESKeyValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeDESKeyValue'));
    pxmlSecNodeDSAG := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeDSAG'));
    pxmlSecNodeDSAJ := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeDSAJ'));
    pxmlSecNodeDSAKeyValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeDSAKeyValue'));
    pxmlSecNodeDSAP := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeDSAP'));
    pxmlSecNodeDSAPgenCounter := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeDSAPgenCounter'));
    pxmlSecNodeDSAQ := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeDSAQ'));
    pxmlSecNodeDSASeed := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeDSASeed'));
    pxmlSecNodeDSAX := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeDSAX'));
    pxmlSecNodeDSAY := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeDSAY'));
    pxmlSecNodeDataReference := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeDataReference'));
    pxmlSecNodeDetail := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeDetail'));
    pxmlSecNodeDigestMethod := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeDigestMethod'));
    pxmlSecNodeDigestValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeDigestValue'));
    pxmlSecNodeEncryptedData := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeEncryptedData'));
    pxmlSecNodeEncryptedKey := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeEncryptedKey'));
    pxmlSecNodeEncryptionMethod := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeEncryptionMethod'));
    pxmlSecNodeEncryptionProperties := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeEncryptionProperties'));
    pxmlSecNodeEncryptionProperty := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeEncryptionProperty'));
    pxmlSecNodeEnvelope := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeEnvelope'));
    pxmlSecNodeFault := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeFault'));
    pxmlSecNodeFaultActor := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeFaultActor'));
    pxmlSecNodeFaultCode := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeFaultCode'));
    pxmlSecNodeFaultDetail := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeFaultDetail'));
    pxmlSecNodeFaultString := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeFaultString'));
    pxmlSecNodeHMACKeyValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeHMACKeyValue'));
    pxmlSecNodeHMACOutputLength := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeHMACOutputLength'));
    pxmlSecNodeHeader := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeHeader'));
    pxmlSecNodeInclusiveNamespaces := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeInclusiveNamespaces'));
    pxmlSecNodeIndeterminateReason := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeIndeterminateReason'));
    pxmlSecNodeInvalidReason := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeInvalidReason'));
    pxmlSecNodeKeyInfo := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeKeyInfo'));
    pxmlSecNodeKeyName := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeKeyName'));
    pxmlSecNodeKeyReference := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeKeyReference'));
    pxmlSecNodeKeyUsage := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeKeyUsage'));
    pxmlSecNodeKeyValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeKeyValue'));
    pxmlSecNodeLocateRequest := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeLocateRequest'));
    pxmlSecNodeLocateResult := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeLocateResult'));
    pxmlSecNodeManifest := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeManifest'));
    pxmlSecNodeMessageExtension := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeMessageExtension'));
    pxmlSecNodeNode := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeNode'));
    pxmlSecNodeObject := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeObject'));
    pxmlSecNodeOpaqueClientData := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeOpaqueClientData'));
    pxmlSecNodePGPData := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodePGPData'));
    pxmlSecNodePendingNotification := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodePendingNotification'));
    pxmlSecNodeQueryKeyBinding := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeQueryKeyBinding'));
    pxmlSecNodeRSAExponent := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeRSAExponent'));
    pxmlSecNodeRSAKeyValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeRSAKeyValue'));
    pxmlSecNodeRSAModulus := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeRSAModulus'));
    pxmlSecNodeRSAPrivateExponent := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeRSAPrivateExponent'));
    pxmlSecNodeReason := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeReason'));
    pxmlSecNodeReference := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeReference'));
    pxmlSecNodeReferenceList := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeReferenceList'));
    pxmlSecNodeRequestSignatureValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeRequestSignatureValue'));
    pxmlSecNodeRespondWith := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeRespondWith'));
    pxmlSecNodeResponseMechanism := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeResponseMechanism'));
    pxmlSecNodeResult := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeResult'));
    pxmlSecNodeRetrievalMethod := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeRetrievalMethod'));
    pxmlSecNodeRole := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeRole'));
    pxmlSecNodeRsaOAEPparams := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeRsaOAEPparams'));
    pxmlSecNodeSPKIData := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeSPKIData'));
    pxmlSecNodeSignature := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeSignature'));
    pxmlSecNodeSignatureMethod := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeSignatureMethod'));
    pxmlSecNodeSignatureProperties := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeSignatureProperties'));
    pxmlSecNodeSignatureValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeSignatureValue'));
    pxmlSecNodeSignedInfo := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeSignedInfo'));
    pxmlSecNodeStatus := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeStatus'));
    pxmlSecNodeStatusRequest := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeStatusRequest'));
    pxmlSecNodeStatusResult := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeStatusResult'));
    pxmlSecNodeSubcode := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeSubcode'));
    pxmlSecNodeText := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeText'));
    pxmlSecNodeTimeInstant := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeTimeInstant'));
    pxmlSecNodeTransform := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeTransform'));
    pxmlSecNodeTransforms := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeTransforms'));
    pxmlSecNodeUnverifiedKeyBinding := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeUnverifiedKeyBinding'));
    pxmlSecNodeUseKeyWith := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeUseKeyWith'));
    pxmlSecNodeValidReason := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeValidReason'));
    pxmlSecNodeValidateRequest := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeValidateRequest'));
    pxmlSecNodeValidateResult := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeValidateResult'));
    pxmlSecNodeValidityInterval := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeValidityInterval'));
    pxmlSecNodeValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeValue'));
    pxmlSecNodeX509CRL := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeX509CRL'));
    pxmlSecNodeX509Certificate := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeX509Certificate'));
    pxmlSecNodeX509Data := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeX509Data'));
    pxmlSecNodeX509IssuerName := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeX509IssuerName'));
    pxmlSecNodeX509IssuerSerial := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeX509IssuerSerial'));
    pxmlSecNodeX509SKI := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeX509SKI'));
    pxmlSecNodeX509SerialNumber := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeX509SerialNumber'));
    pxmlSecNodeX509SubjectName := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeX509SubjectName'));
    pxmlSecNodeXPath := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeXPath'));
    pxmlSecNodeXPath2 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeXPath2'));
    pxmlSecNodeXPointer := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNodeXPointer'));
    pxmlSecNs := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNs'));
    pxmlSecNsExcC14N := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNsExcC14N'));
    pxmlSecNsExcC14NWithComments := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecNsExcC14NWithComments'));
    pxmlSecRespondWithKeyName := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecRespondWithKeyName'));
    pxmlSecRespondWithKeyValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecRespondWithKeyValue'));
    pxmlSecRespondWithOCSP := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecRespondWithOCSP'));
    pxmlSecRespondWithPGP := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecRespondWithPGP'));
    pxmlSecRespondWithPGPWeb := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecRespondWithPGPWeb'));
    pxmlSecRespondWithPrivateKey := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecRespondWithPrivateKey'));
    pxmlSecRespondWithRetrievalMethod := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecRespondWithRetrievalMethod'));
    pxmlSecRespondWithSPKI := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecRespondWithSPKI'));
    pxmlSecRespondWithX509CRL := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecRespondWithX509CRL'));
    pxmlSecRespondWithX509Cert := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecRespondWithX509Cert'));
    pxmlSecRespondWithX509Chain := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecRespondWithX509Chain'));
    pxmlSecResponseMechanismPending := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecResponseMechanismPending'));
    pxmlSecResponseMechanismRepresent := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecResponseMechanismRepresent'));
    pxmlSecResponseMechanismRequestSignatureValue := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecResponseMechanismRequestSignatureValue'));
    pxmlSecResultMajorCodePending := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecResultMajorCodePending'));
    pxmlSecResultMajorCodeReceiver := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecResultMajorCodeReceiver'));
    pxmlSecResultMajorCodeRepresent := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecResultMajorCodeRepresent'));
    pxmlSecResultMajorCodeSender := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecResultMajorCodeSender'));
    pxmlSecResultMajorCodeSuccess := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecResultMajorCodeSuccess'));
    pxmlSecResultMajorCodeVersionMismatch := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecResultMajorCodeVersionMismatch'));
    pxmlSecResultMinorCodeFailure := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecResultMinorCodeFailure'));
    pxmlSecResultMinorCodeIncomplete := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecResultMinorCodeIncomplete'));
    pxmlSecResultMinorCodeMessageNotSupported := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecResultMinorCodeMessageNotSupported'));
    pxmlSecResultMinorCodeNoAuthentication := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecResultMinorCodeNoAuthentication'));
    pxmlSecResultMinorCodeNoMatch := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecResultMinorCodeNoMatch'));
    pxmlSecResultMinorCodeNotSynchronous := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecResultMinorCodeNotSynchronous'));
    pxmlSecResultMinorCodeRefused := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecResultMinorCodeRefused'));
    pxmlSecResultMinorCodeTooManyResponses := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecResultMinorCodeTooManyResponses'));
    pxmlSecResultMinorCodeUnknownResponseId := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecResultMinorCodeUnknownResponseId'));
    pxmlSecSoap11Ns := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecSoap11Ns'));
    pxmlSecSoap12Ns := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecSoap12Ns'));
    pxmlSecSoapFaultCodeClient := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecSoapFaultCodeClient'));
    pxmlSecSoapFaultCodeMustUnderstand := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecSoapFaultCodeMustUnderstand'));
    pxmlSecSoapFaultCodeReceiver := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecSoapFaultCodeReceiver'));
    pxmlSecSoapFaultCodeSender := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecSoapFaultCodeSender'));
    pxmlSecSoapFaultCodeServer := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecSoapFaultCodeServer'));
    pxmlSecSoapFaultCodeVersionMismatch := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecSoapFaultCodeVersionMismatch'));
    pxmlSecSoapFaultDataEncodningUnknown := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecSoapFaultDataEncodningUnknown'));
    pxmlSecStatusResultFailed := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecStatusResultFailed'));
    pxmlSecStatusResultPending := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecStatusResultPending'));
    pxmlSecStatusResultSuccess := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecStatusResultSuccess'));
    pxmlSecStringCR := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecStringCR'));
    pxmlSecStringEmpty := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecStringEmpty'));
    pxmlSecTypeEncContent := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecTypeEncContent'));
    pxmlSecTypeEncElement := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecTypeEncElement'));
    pxmlSecXPath2FilterIntersect := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecXPath2FilterIntersect'));
    pxmlSecXPath2FilterSubtract := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecXPath2FilterSubtract'));
    pxmlSecXPath2FilterUnion := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecXPath2FilterUnion'));
    pxmlSecXPath2Ns := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecXPath2Ns'));
    pxmlSecXPathNs := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecXPathNs'));
    pxmlSecXPointerNs := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecXPointerNs'));
    pxmlSecXkmsFormatStrPlain := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecXkmsFormatStrPlain'));
    pxmlSecXkmsFormatStrSoap11 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecXkmsFormatStrSoap11'));
    pxmlSecXkmsFormatStrSoap12 := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecXkmsFormatStrSoap12'));
    pxmlSecXkmsNs := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecXkmsNs'));
    pxmlSecXkmsServerRequestCompoundName := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecXkmsServerRequestCompoundName'));
    pxmlSecXkmsServerRequestLocateName := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecXkmsServerRequestLocateName'));
    pxmlSecXkmsServerRequestResultName := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecXkmsServerRequestResultName'));
    pxmlSecXkmsServerRequestStatusName := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecXkmsServerRequestStatusName'));
    pxmlSecXkmsServerRequestValidateName := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecXkmsServerRequestValidateName'));
    pxmlSecXkmsSoapFaultReasonLang := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecXkmsSoapFaultReasonLang'));
    pxmlSecXkmsSoapFaultReasonMessageInvalid := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecXkmsSoapFaultReasonMessageInvalid'));
    pxmlSecXkmsSoapFaultReasonMessageNotSupported := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecXkmsSoapFaultReasonMessageNotSupported'));
    pxmlSecXkmsSoapFaultReasonServiceUnavailable := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecXkmsSoapFaultReasonServiceUnavailable'));
    pxmlSecXkmsSoapFaultReasonUnableToProcess := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecXkmsSoapFaultReasonUnableToProcess'));
    pxmlSecXkmsSoapFaultReasonUnsupportedVersion := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecXkmsSoapFaultReasonUnsupportedVersion'));
    pxmlSecXkmsSoapSubcodeValueBadMessage := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecXkmsSoapSubcodeValueBadMessage'));
    pxmlSecXkmsSoapSubcodeValueMessageNotSupported := xmlCharPtr(GetProcAddress(libHandle, 'xmlSecXkmsSoapSubcodeValueMessageNotSupported'));
  end;

finalization
  if libHandle <> 0 then
    FreeLibrary(libHandle);
end.
