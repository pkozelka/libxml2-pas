{
	encoding.h : interface for the encoding conversion functions needed for XML

	Related specs:
	rfc2044        (UTF-8 and UTF-16) F. Yergeau Alis Technologies
	[ISO-10646]    UTF-8 and UTF-16 in Annexes
	[ISO-8859-1]   ISO Latin-1 characters codes.
	[UNICODE]      The Unicode Consortium, "The Unicode Standard --
								Worldwide Character Encoding -- Version 1.0", Addison-
								Wesley, Volume 1, 1991, Volume 2, 1992.  UTF-8 is
								described in Unicode Technical Report #4.
	[US-ASCII]     Coded Character Set--7-bit American Standard Code for
								Information Interchange, ANSI X3.4-1986.

	See Copyright for the status of this software.

	daniel@veillard.com
}

{
	------------------------------------------------------------------------------
	Translated into pascal with help of h2pas utility from the FreePascal project.
	Petr Kozelka <pkozelka@email.cz>
	------------------------------------------------------------------------------
}

type
	xmlCharEncoding =  Longint;
const
	{
		xmlCharEncoding:

		Predefined values for some standard encodings
		Libxml don't do beforehand translation on UTF8, ISOLatinX
		It also support UTF16 (LE and BE) by default.

		Anything else would have to be translated to UTF8 before being
		given to the parser itself. The BOM for UTF16 and the encoding
		declaration are looked at and a converter is looked for at that
		point. If not found the parser stops here as asked by the XML REC
		Converter can be registered by the user using xmlRegisterCharEncodingHandler
		but the currentl form doesn't allow stateful transcoding (a serious
		problem agreed !). If iconv has been found it will be used
		automatically and allow stateful transcoding, the simplest is then
		to be sure to enable icon and to provide iconv libs for the encoding
		support needed.
	}
	XML_CHAR_ENCODING_ERROR = -(1);   { No char encoding detected  }
	XML_CHAR_ENCODING_NONE = 0;       { No char encoding detected  }
	XML_CHAR_ENCODING_UTF8 = 1;       { UTF-8  }
	XML_CHAR_ENCODING_UTF16LE = 2;    { UTF-16 little endian  }
	XML_CHAR_ENCODING_UTF16BE = 3;    { UTF-16 big endian  }
	XML_CHAR_ENCODING_UCS4LE = 4;     { UCS-4 little endian  }
	XML_CHAR_ENCODING_UCS4BE = 5;     { UCS-4 big endian  }
	XML_CHAR_ENCODING_EBCDIC = 6;     { EBCDIC uh!  }
	XML_CHAR_ENCODING_UCS4_2143 = 7;  { UCS-4 unusual ordering  }
	XML_CHAR_ENCODING_UCS4_3412 = 8;  { UCS-4 unusual ordering  }
	XML_CHAR_ENCODING_UCS2 = 9;       { UCS-2  }
	XML_CHAR_ENCODING_8859_1 = 10;    { ISO-8859-1 ISO Latin 1  }
	XML_CHAR_ENCODING_8859_2 = 11;    { ISO-8859-2 ISO Latin 2  }
	XML_CHAR_ENCODING_8859_3 = 12;    { ISO-8859-3  }
	XML_CHAR_ENCODING_8859_4 = 13;    { ISO-8859-4  }
	XML_CHAR_ENCODING_8859_5 = 14;    { ISO-8859-5  }
	XML_CHAR_ENCODING_8859_6 = 15;    { ISO-8859-6  }
	XML_CHAR_ENCODING_8859_7 = 16;    { ISO-8859-7  }
	XML_CHAR_ENCODING_8859_8 = 17;    { ISO-8859-8  }
	XML_CHAR_ENCODING_8859_9 = 18;    { ISO-8859-9  }
	XML_CHAR_ENCODING_2022_JP = 19;   { ISO-2022-JP  }
	XML_CHAR_ENCODING_SHIFT_JIS = 20; { Shift_JIS  }
	XML_CHAR_ENCODING_EUC_JP = 21;    { EUC-JP  }
	XML_CHAR_ENCODING_ASCII = 22;     { pure ASCII  }

type
	{
		xmlCharEncodingInputFunc:
		@aOut:  a pointer ot an array of bytes to store the UTF-8 result
		@outlen:  the lenght of @out
		@aIn:  a pointer ot an array of chars in the original encoding
		@inlen:  the lenght of @in

		Take a block of chars in the original encoding and try to convert
		it to an UTF-8 block of chars out.

		Returns the number of byte written, or -1 by lack of space, or -2
			 if the transcoding failed.
		The value of @inlen after return is the number of octets consumed
			 as the return value is positive, else unpredictiable.
		The value of @outlen after return is the number of ocetes consumed.
	}
	xmlCharEncodingInputFunc = function (aOut: PByte; outlen: integer; aIn: PByte; inlen: integer): integer; cdecl;

	{
		xmlCharEncodingOutputFunc:
		@aOut:  a pointer ot an array of bytes to store the result
		@outlen:  the lenght of @out
		@aIn:  a pointer ot an array of UTF-8 chars
		@inlen:  the lenght of @in

		Take a block of UTF-8 chars in and try to convert it to an other
		encoding.
		Note: a first call designed to produce heading info is called with
		in = NULL. If stateful this should also initialize the encoder state

		Returns the number of byte written, or -1 by lack of space, or -2
			 if the transcoding failed.
		The value of @inlen after return is the number of octets consumed
			 as the return value is positive, else unpredictiable.
		The value of @outlen after return is the number of ocetes consumed.
	}
	xmlCharEncodingOutputFunc = function (aOut: PByte; outlen: integer; aIn: PByte; inlen: integer): integer; cdecl;

	{
		Block defining the handlers for non UTF-8 encodings.
		If iconv is supported, there is two extra fields
	}
	xmlCharEncodingHandlerPtr = ^xmlCharEncodingHandler;
	xmlCharEncodingHandler = record
		name : Pchar;
		input : xmlCharEncodingInputFunc;
		output : xmlCharEncodingOutputFunc;
{$ifdef LIBXML_ICONV_ENABLED}
		iconv_in : iconv_t;
		iconv_out : iconv_t;
{$endif} //LIBXML_ICONV_ENABLED
	end;

{
	Interfaces for encoding handlers
}
procedure xmlInitCharEncodingHandlers;cdecl;external LIBXML2_SO;
procedure xmlCleanupCharEncodingHandlers;cdecl;external LIBXML2_SO;
procedure xmlRegisterCharEncodingHandler(handler:xmlCharEncodingHandlerPtr);cdecl;external LIBXML2_SO;
function  xmlGetCharEncodingHandler(enc:xmlCharEncoding):xmlCharEncodingHandlerPtr;cdecl;external LIBXML2_SO;
function  xmlFindCharEncodingHandler(name:Pchar):xmlCharEncodingHandlerPtr;cdecl;external LIBXML2_SO;

{
	Interfaces for encoding names and aliases
}
function  xmlAddEncodingAlias(name:Pchar; alias:Pchar):longint;cdecl;external LIBXML2_SO;
function  xmlDelEncodingAlias(alias:Pchar):longint;cdecl;external LIBXML2_SO;
function  xmlGetEncodingAlias(alias:Pchar):Pchar;cdecl;external LIBXML2_SO;
procedure xmlCleanupEncodingAliases;cdecl;external LIBXML2_SO;
function  xmlParseCharEncoding(name:Pchar):xmlCharEncoding;cdecl;external LIBXML2_SO;
function  xmlGetCharEncodingName(enc:xmlCharEncoding):Pchar;cdecl;external LIBXML2_SO;

{
	Interfaces directly used by the parsers.
}
function  xmlDetectCharEncoding(aIn:Pbyte; len:longint):xmlCharEncoding;cdecl;external LIBXML2_SO;
function  xmlCharEncOutFunc(handler:xmlCharEncodingHandlerPtr; aOut:xmlBufferPtr; aIn:xmlBufferPtr):longint;cdecl;external LIBXML2_SO;
function  xmlCharEncInFunc(handler:xmlCharEncodingHandlerPtr; aOut:xmlBufferPtr; aIn:xmlBufferPtr):longint;cdecl;external LIBXML2_SO;
function  xmlCharEncFirstLine(handler:xmlCharEncodingHandlerPtr; aOut:xmlBufferPtr; aIn:xmlBufferPtr):longint;cdecl;external LIBXML2_SO;
function  xmlCharEncCloseFunc(handler:xmlCharEncodingHandlerPtr):longint;cdecl;external LIBXML2_SO;

{
	Export a few useful functions
}
function  UTF8Toisolat1(aOut:Pbyte; outlen:Plongint; aIn:Pbyte; inlen:Plongint):longint;cdecl;external LIBXML2_SO;
function  isolat1ToUTF8(aOut:Pbyte; outlen:Plongint; aIn:Pbyte; inlen:Plongint):longint;cdecl;external LIBXML2_SO;

{
	exports additional "UTF-8 aware" string routines which are
}
function  xmlCheckUTF8(utf:Pbyte):longint;cdecl;external LIBXML2_SO;
function  xmlUTF8Strsize(utf:PxmlChar; len:longint):longint;cdecl;external LIBXML2_SO;
function  xmlUTF8Strndup(utf:PxmlChar; len:longint):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlUTF8Strpos(utf:PxmlChar; pos:longint):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlUTF8Strloc(utf:PxmlChar; utfchar:PxmlChar):longint;cdecl;external LIBXML2_SO;
function  xmlUTF8Strsub(utf:PxmlChar; start:longint; len:longint):PxmlChar;cdecl;external LIBXML2_SO;
function  xmlUTF8Strlen(utf:PxmlChar):longint;cdecl;external LIBXML2_SO;
