program signing;

{$APPTYPE CONSOLE}

uses
  libxml2, libxslt, libxmlsec, SysUtils;

(**
 * XML Security Library example: Signing a template file.
 *
 * Signs a template file using a key from PEM file
 *
 * Usage:
 *	./sign1 <xml-tmpl> <pem-key>
 *
 * Example:
 *	./sign1 sign1-tmpl.xml rsakey.pem > sign1-res.xml
 *
 * The result signature could be validated using verify1 example:
 *	./verify1 sign1-res.xml rsapub.pem
 *
 * This is free software; see Copyright file in the source
 * distribution for preciese wording.
 *
 * Copyright (C) 2002-2003 Aleksey Sanin <aleksey@aleksey.com>
 *)

(**
 * sign_file:
 * @tmpl_file:		the signature template file name.
 * @key_file:		the PEM private key file name.
 *
 * Signs the #tmpl_file using private key from #key_file.
 *
 * Returns 0 on success or a negative value if an error occurs.
 *)


function sign_file(const tmpl_file: PChar; const key_file: PChar): integer;
var
  doc: xmlDocPtr;
  node: xmlNodePtr;
  dsigCtx: xmlSecDSigCtxPtr;
  buffer: PChar;
  bufSize: integer;
label done;
begin
    doc := nil;
    node := nil;
    dsigCtx := nil;
    result := -1;

    if (tmpl_file = nil) or (key_file = nil) then Exit;

    { load template }
    doc := xmlParseFile(tmpl_file);
    if ((doc = nil) or (xmlDocGetRootElement(doc) = nil)) then
    begin
      Writeln(ErrOutput, 'Error: unable to parse file "' + tmpl_file + '"');
	    goto done;
    end;

    { find start node }
    node := xmlSecFindNode(xmlDocGetRootElement(doc), PChar(xmlSecNodeSignature), PChar(xmlSecDSigNs));
    if (node = nil) then
    begin
      Writeln(ErrOutput, 'Error: start node not found in "' + tmpl_file + '"');
    	goto done;
    end;

    { create signature context, we don't need keys manager in this example }
    dsigCtx := xmlSecDSigCtxCreate(nil);
    if (dsigCtx = nil) then
    begin
      Writeln(ErrOutput, 'Error :failed to create signature context');
    	goto done;
    end;

    { load private key, assuming that there is not password }
    dsigCtx.signKey := xmlSecCryptoAppKeyLoad(key_file, xmlSecKeyDataFormatPem, nil, nil, nil);
    if (dsigCtx.signKey = nil) then
    begin
        Writeln(ErrOutput, 'Error: failed to load private pem key from "' + key_file + '"');
        goto done;
    end;

    { set key name to the file name, this is just an example! }
    if (xmlSecKeySetName(dsigCtx.signKey, key_file) < 0) then
    begin
      Writeln(ErrOutput, 'Error: failed to set key name for key from "' + key_file + '"');
      goto done;
    end;

    { sign the template }
    if (xmlSecDSigCtxSign(dsigCtx, node) < 0) then
    begin
      Writeln(ErrOutput, 'Error: signature failed');
      goto done;
    end;

    { print signed document to stdout }
    //xmlDocDump(stdout, doc);
    buffer := nil;
    xmlDocDumpMemory(doc, @buffer, @bufSize);
    if (buffer <> nil) then
    begin
      Writeln(buffer);
      xmlFree(buffer);
    end;

    { success }
    result := 0;

done:
    { cleanup }
    if (dsigCtx <> nil) then
      xmlSecDSigCtxDestroy(dsigCtx);

    if (doc <> nil) then
      xmlFreeDoc(doc);
end;

begin
    if ParamCount <> 2 then
    begin
      Writeln(ErrOutput, 'Error: wrong number of arguments.');
      Writeln(ErrOutput, 'Usage: ' + ParamStr(0) + ' <tmpl-file> <key-file>');
      Exit;
    end;

    { Init libxml and libxslt libraries }
    xmlInitParser();
    __xmlLoadExtDtdDefaultValue^ := XML_DETECT_IDS or XML_COMPLETE_ATTRS;
    xmlSubstituteEntitiesDefault(1);
    __xmlIndentTreeOutput^ := 1;

    { Init xmlsec library }
    if (xmlSecInit() < 0) then
    begin
      Writeln(ErrOutput, 'Error: xmlsec initialization failed.');
      Exit;
    end;

    { Check loaded library version }
    if(xmlSecCheckVersionExt(1, 2, 8, xmlSecCheckVersionABICompatible) <> 1) then
    begin
      Writeln(ErrOutput, 'Error: loaded xmlsec library version is not compatible.');
      Exit;
    end;

    (* Load default crypto engine if we are supporting dynamic
     * loading for xmlsec-crypto libraries. Use the crypto library
     * name ("openssl", "nss", etc.) to load corresponding
     * xmlsec-crypto library.
     *)
    // if (xmlSecCryptoDLLoadLibrary('mscrypto') < 0) then
    if (xmlSecCryptoDLLoadLibrary('openssl') < 0) then
    begin
      Writeln(ErrOutput, 'Error: unable to load default xmlsec-crypto library. Make sure'#10 +
			'that you have it installed and check shared libraries path'#10 +
			'(LD_LIBRARY_PATH) environment variable.');
      Exit;
    end;

    { Init crypto library }
    if (xmlSecCryptoAppInit(nil) < 0) then
    begin
      Writeln(ErrOutput, 'Error: crypto initialization failed.');
      Exit;
    end;

    { Init xmlsec-crypto library }
    if (xmlSecCryptoInit() < 0) then
    begin
      Writeln(ErrOutput, 'Error: xmlsec-crypto initialization failed.');
      Exit;
    end;

    if(sign_file(PChar(ParamStr(1)), PChar(ParamStr(2))) < 0) then
      Exit;

    { Shutdown xmlsec-crypto library }
    xmlSecCryptoShutdown();

    { Shutdown crypto library }
    xmlSecCryptoAppShutdown();

    { Shutdown xmlsec library }
    xmlSecShutdown();

    { Shutdown libxslt/libxml }
    xsltCleanupGlobals();
    xmlCleanupParser();
end.
