<?xml version="1.0"?>
<!--
  Stylesheet to convert the API bindings described in libxml2-api.xml into
  Delphi declarations. I'm no expert in XSLT, do don't regard this as
  exemplary.

  This still could use a bit of refinement. Not everything comes out in 
  the right order. The macros and conditional logic are completely ignored. 

  The "variable" elements are not all handled, partially because some of 
  these are actually implemented in part as C macros, and partially because
  Delphi does not really know how to import variables. In many cases, like
  "xmlParserVersion", the "variable" is actually implemented as a function
  (with a double underscore prepended to the name) which returns a pointer
  the desired value. I attempt to import these functions (though there is
  no reliable way of knowing which variables are so implemented); to use
  them in a Delphi application, one can use "__xmlParserVersion^" rather
  than "xmlParserVersion". In some other cases (notably xmlMalloc, xmlFree,
  and friends), the exported variable is a pointer to a function. These
  are handled by proxy functions which are defined by using GetProcAddress 
  during module initialization to obtain the address of the pointer to the 
  function.

  15 December 2004 - Eric Zurcher - CSIRO Livestock Industries
-->
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" encoding="UTF-8"/>

<xsl:param name="unit">libxml2</xsl:param>

<xsl:key name="enumTypeKey" match="enum" use="@type"/>

<!-- 
  Template for the document root. This generates a boiler-plate header
  and footer around the other code 
-->  
<xsl:template match="/">

<xsl:text>{This file generated automatically from </xsl:text>
<xsl:value-of select="$unit"/>
<xsl:text>-api.xml}
Unit </xsl:text>
<xsl:value-of select="$unit"/>
<xsl:text>;

interface

{$ALIGN 8}
{$MINENUMSIZE 4}

</xsl:text>
<xsl:if test="not($unit='libxml2')">
  <xsl:text>uses libxml2</xsl:text>
  <xsl:if test="not($unit='libxslt')">
    <xsl:text>, libxslt</xsl:text>
  </xsl:if>
  <xsl:text>;</xsl:text>
</xsl:if>
<xsl:text>

const
{$IFDEF WIN32}
  </xsl:text>
<xsl:call-template name="WriteLibName"/>
<xsl:text> = '</xsl:text>
<xsl:value-of select="$unit"/><xsl:text>.dll';
{$ELSE}
  </xsl:text>
<xsl:call-template name="WriteLibName"/>
<xsl:text> = '</xsl:text>
<xsl:value-of select="$unit"/><xsl:text>.so';
{$ENDIF}

type

</xsl:text>
<xsl:choose>
  <xsl:when test="$unit='libxml2'">
    <xsl:text>
      PFILE = Pointer;
      iconv_t = Cardinal;
      size_t = Cardinal;
      va_list = Pointer;
      xmlCharPtr = ^xmlChar;
      xmlNodePtrPtr = ^xmlNodePtr;
      xmlDocPtrPtr = ^xmlDocPtr;
      xmlNSPtrPtr = ^xmlNSPtr;
      xmlSchemaValPtrPtr = ^xmlSchemaValPtr;
      xmlEnumerationPtrPtr = ^xmlEnumerationPtr;
      xmlElementContentPtrPtr = ^xmlElementContentPtr;
      xlinkHRefPtr = ^xlinkHRef;
      xlinkRolePtr = ^xlinkRole;
      xlinkShowPtr = ^xlinkShow;
      xlinkActuatePtr = ^xlinkActuate;
      xlinkTitlePtr = ^xlinkTitle;
      xmlXPathObjectPtrPtr = ^xmlXPathObjectPtr;
      xmlParserInputPtrPtr = ^xmlParserInputPtr;
      xmlBufferAllocationSchemePtr = ^xmlBufferAllocationScheme;

    </xsl:text>
  </xsl:when>
  <xsl:when test="$unit='libxslt'">
    <xsl:text>
      xsltTemplatePtrPtr = ^xsltTemplatePtr;
      xsltStackElemPtrPtr = ^xsltStackElemPtr;

    </xsl:text>
  </xsl:when>
</xsl:choose>


  <!--
   Apply templates to various portions of the input. Currently this completely
   ignores the <files> element, and works only with the contents of the 
   <symbols> element.
   
   There are several stages here. 
     1) Any enumerated types are processed.
     2) Type declarations which declare pointer (^) types are handled. 
   This is done at this stage because many of the record declarations 
   include these pointer types, so it's best if we declare these first.
     3) Function types are handled. Also, a pointer type is generated for each
   of these types.
     4) Struct (record) types are handled. In a very few cases where one record
   type incorporates another, the order of these declarations needs to be 
   changed manually.
     5) At last we get to the heart of the matter - the declaration of the
   functions to be imported from libxml2.
     6) Finally we attempt to deal with imported "variables". This part is 
   not very robust.
  -->

  <xsl:apply-templates select="api/symbols/typedef[@type='enum']" mode="NonPtrTypes"/>
  <xsl:apply-templates select="api/symbols/typedef[@type!='enum']" mode="PtrTypes"/>
  <xsl:apply-templates select="api/symbols/functype"/>
  <xsl:apply-templates select="api/symbols/struct"/>
  <xsl:apply-templates select="api/symbols/typedef[@type!='enum']" mode="NonPtrTypes"/>
  <xsl:apply-templates select="api/symbols/function"/>
  <xsl:apply-templates select="api/symbols/variable" mode="VariablesPassOne"/>
  <xsl:text>

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
    raise Exception.Create('"' + name + '" could not be loaded from the dynamic library ' + </xsl:text>
<xsl:call-template name="WriteLibName"/>
<xsl:text>);
end;

</xsl:text>
  <xsl:apply-templates select="api/symbols/variable" mode="VariablesPassTwo"/>
  <xsl:text>

initialization
  // The Delphi 'external' directive can be used for functions and procedures,
  // but here we need to obtain the addresses of POINTERS to functions. We can
  // get to these addresses (and also those of other data values exported from
  // the DLL) by using GetProcAddress.
  libHandle := LoadLibrary(</xsl:text>
  <xsl:call-template name="WriteLibName"/>
  <xsl:text>);
  if libHandle &lt;&gt; 0 then 
  begin
</xsl:text>
  <xsl:apply-templates select="api/symbols/variable" mode="VariablesPassThree"/>
  <xsl:text>
    FreeLibrary(libHandle);
  end;

end.
</xsl:text>
</xsl:template>

<!--
  Handles the declaration of function types. Also generates a type of pointer 
  to each function, appending "Ptr" to the function's name.
-->
<xsl:template match="functype">
  <xsl:text>      </xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:text> = </xsl:text>
  <xsl:call-template name="WriteFunction">
    <xsl:with-param name="func" select="."/>
    <xsl:with-param name="type" select="'functype'"/>
  </xsl:call-template>
  <xsl:text>
        </xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:text>Ptr = ^</xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:text>;

</xsl:text>
</xsl:template>

<!-- 
  Handles struct (Pascal record) declarations. Includes the associated comments
  of each field.
-->
<xsl:template match="struct">
  <xsl:text>      </xsl:text>
  <xsl:value-of select="@name"/>
  <xsl:text> = record</xsl:text>
  <xsl:for-each select="field">
    <xsl:text>
          </xsl:text>
    <xsl:call-template name="FixupVarName">
      <xsl:with-param name="text" select="@name"/>
    </xsl:call-template>
    <xsl:text> : </xsl:text>
    <xsl:choose>
      <xsl:when test="(starts-with(@type, 'struct _')) or
                      (starts-with(@type, 'const struct _'))">
        <xsl:value-of select="substring-before(substring-after(@type, 'struct _'), ' *')"/>
        <xsl:text>Ptr</xsl:text>
      </xsl:when>
      <xsl:when test="starts-with(@type, 'const ')">
        <xsl:call-template name="FixupVarType">
          <xsl:with-param name="text" select="substring-after(@type, 'const ')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="FixupVarType">
          <xsl:with-param name="text" select="@type"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>  
    <xsl:text>;</xsl:text>
    <xsl:apply-templates select="@info"/>
  </xsl:for-each>
  <xsl:text>
      end;

</xsl:text>
</xsl:template>

<!--
  Handles the declaration of pointer types.
-->
<xsl:template match="typedef" mode="PtrTypes">
  <xsl:if test="contains(@type, ' *')">
    <xsl:text>       </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text> = </xsl:text>
    <xsl:text>^</xsl:text>
    <xsl:value-of select="substring-before(@type, ' *')"/>
    <xsl:text>;
</xsl:text>
  </xsl:if>
</xsl:template>

<!--
  Handles both enumerated types and declaration of non-pointer types
-->
<xsl:template match="typedef" mode="NonPtrTypes">
  <xsl:choose>
    <!-- Handles enumerated types here -->
    <xsl:when test="@type='enum'">
      <xsl:variable name="enumType" select="@name"/>
      <xsl:text>      </xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text> = (
          </xsl:text>
      <xsl:variable name="enumSize" select="count(key('enumTypeKey', @name))"/>
      <xsl:for-each select="key('enumTypeKey', @name)">
        <xsl:sort select="@value" data-type="number" order="ascending"/>
        <xsl:value-of select="@name"/>
        <xsl:text> = </xsl:text>
        <xsl:value-of select="@value"/>
        <xsl:if test="position() &lt; $enumSize">
          <xsl:text>,
          </xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:text>);

</xsl:text>
    </xsl:when>
    <!-- Handles non-pointer, non-record typedefs here. These are really just synonyms -->
    <xsl:otherwise>
      <xsl:if test="not(contains(@type, ' *'))">
        <xsl:text>      </xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:text> = </xsl:text>
        <xsl:call-template name="FixupVarType">
          <xsl:with-param name="text" select="@type"/>
        </xsl:call-template>
        <xsl:text>;
</xsl:text>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:value-of select="name"/>
</xsl:template>

<!--
  Handles the declaration of the functions in the API
-->
<xsl:template match="function">
  <xsl:text>
  </xsl:text>
  <xsl:call-template name="WriteFunction">
    <xsl:with-param name="func" select="."/>
    <xsl:with-param name="type" select="'function'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="variable" mode="VariablesPassOne">
  <xsl:choose>
    <xsl:when test="contains(@type, 'Func') and not(contains(@name, 'DefaultValue'))">
      <xsl:variable name="typeName" select="@type"/>
      <xsl:variable name="nArgs" select="count(../functype[@name=$typeName]/arg)"/>
      <xsl:if test="../functype[@name=$typeName]/arg[$nArgs]/@type!='...'">
        <xsl:text>
  </xsl:text>
        <xsl:call-template name="WriteFunction">
          <xsl:with-param name="func" select="../functype[@name=$typeName]"/>
          <xsl:with-param name="type" select="'proxy'"/>
          <xsl:with-param name="funcName" select="@name"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:when>
    <xsl:when test="($unit!='libxml2') and starts-with(@type, 'const ')">
      <xsl:text>
  function </xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>(): </xsl:text>
      <xsl:call-template name="FixupVarType">
        <xsl:with-param name="text" select="substring-after(@type, 'const ')"/>
      </xsl:call-template>
      <xsl:text>; cdecl;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
       <xsl:if test="not(starts-with(@name, 'xmlIs')) and not(contains(@type, '[]'))">
         <xsl:text>
  function __</xsl:text>
         <xsl:value-of select="@name"/>
         <xsl:text>(): </xsl:text>
         <xsl:call-template name="FixupVarType">
           <xsl:with-param name="text" select="concat(@type, ' *')"/>
         </xsl:call-template>
         <xsl:text>; cdecl; external </xsl:text>
         <xsl:call-template name="WriteLibName"/>
         <xsl:text>;</xsl:text>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="variable" mode="VariablesPassTwo">
  <xsl:choose>
    <xsl:when test="contains(@type, 'Func') and not(contains(@name, 'DefaultValue'))">
      <xsl:variable name="typeName" select="@type"/>
      <xsl:variable name="nArgs" select="count(../functype[@name=$typeName]/arg)"/>
      <xsl:if test="../functype[@name=$typeName]/arg[$nArgs]/@type!='...'">
        <xsl:text>var
   p</xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:text>: </xsl:text> 
        <xsl:value-of select="@type"/>
        <xsl:text>Ptr;

</xsl:text>
        <xsl:call-template name="WriteFunction">
          <xsl:with-param name="func" select="../functype[@name=$typeName]"/>
          <xsl:with-param name="type" select="'proxy'"/>
          <xsl:with-param name="funcName" select="@name"/>
        </xsl:call-template>
        <xsl:text>
begin
  CheckForNil(p</xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:text>, '</xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:text>');
  </xsl:text>
        <xsl:if test="../functype[@name=$typeName]/return/@type!='void'">
          <xsl:text>Result := </xsl:text>
        </xsl:if>
        <xsl:text>p</xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:text>^(</xsl:text>
        <xsl:for-each select="../functype[@name=$typeName]/arg">
          <xsl:call-template name="FixupVarName">
            <xsl:with-param name="text" select="@name"/>
          </xsl:call-template>
          <xsl:if test="position() &lt; $nArgs">
            <xsl:text>, </xsl:text>
          </xsl:if>
        </xsl:for-each>
      <xsl:text>);
end;

</xsl:text>
      </xsl:if>
    </xsl:when>
    <xsl:when test="($unit!='libxml2') and starts-with(@type, 'const ')">
      <xsl:text>var
   p</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>: </xsl:text>
      <xsl:call-template name="FixupVarType">
        <xsl:with-param name="text" select="concat(substring-after(@type, 'const '), ' *')"/>
      </xsl:call-template>
      <xsl:text>;

function </xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>: </xsl:text>
      <xsl:call-template name="FixupVarType">
        <xsl:with-param name="text" select="substring-after(@type, 'const ')"/>
      </xsl:call-template>
      <xsl:text>;
begin
  CheckForNil(p</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>, '</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>');
  Result := p</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>^;
end;

</xsl:text>  
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="variable" mode="VariablesPassThree">
  <xsl:if test="(contains(@type, 'Func') and not(contains(@name, 'DefaultValue'))) or (starts-with(@type, 'const '))">
    <xsl:variable name="typeName" select="@type"/>
    <xsl:variable name="nArgs" select="count(../functype[@name=$typeName]/arg)"/>
    <xsl:if test="(($unit!='libxml2') and starts-with(@type, 'const ')) or (../functype[@name=$typeName]/arg[$nArgs]/@type!='...')">
      <xsl:text>    p</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text> := </xsl:text>
      <xsl:choose>
        <xsl:when test="($unit!='libxml2') and starts-with(@type, 'const ')">
          <xsl:call-template name="FixupVarType">
            <xsl:with-param name="text" select="concat(substring-after(@type, 'const '), ' *')"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@type"/>
          <xsl:text>Ptr</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>(GetProcAddress(libHandle, '</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>'));
</xsl:text>
    </xsl:if>
  </xsl:if>
</xsl:template>



<!-- 
  Handles comments
-->
<xsl:template match="@info">
  <xsl:text> {</xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template name="WriteLibName">
  <xsl:value-of select="translate($unit, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
  <xsl:text>_SO</xsl:text>
</xsl:template>
<!--
  Handles the generation of both procedures and procedural types
-->
<xsl:template name="WriteFunction">
  <xsl:param name="func"/>
  <xsl:param name="type"/>
  <xsl:param name="funcName"/>
  <xsl:choose>
    <xsl:when test="$func/return/@type='void'">
      <xsl:text>procedure </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>function </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:variable name="nArgs" select="count($func/arg)"/>
  <xsl:variable name="hasVarArgs" select="$func/arg[$nArgs]/@type='...'"/>
  <xsl:choose>
    <xsl:when test="$type='function'">
      <xsl:value-of select="$func/@name"/>
    </xsl:when>
    <xsl:when test="$type='proxy'">
      <xsl:value-of select="$funcName"/>
    </xsl:when>
  </xsl:choose>
  <xsl:text> (</xsl:text>
  <xsl:for-each select="$func/arg">
    <xsl:if test="@type != '...'">
      <xsl:variable name="isConst" select="starts-with(@type, 'const ')"/>
      <xsl:if test="$isConst">
        <xsl:text>const </xsl:text>
      </xsl:if>
      <xsl:call-template name="FixupVarName">
        <xsl:with-param name="text" select="@name"/>
      </xsl:call-template>
      <xsl:text>: </xsl:text>
      <xsl:choose>
        <xsl:when test="$isConst">
          <xsl:call-template name="FixupVarType">
            <xsl:with-param name="text" select="substring-after(@type, 'const ')"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="FixupVarType">
            <xsl:with-param name="text" select="@type"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="(position() &lt; $nArgs) and (following-sibling::arg/@type != '...')">
        <xsl:text>; </xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:for-each>
  <xsl:text>)</xsl:text>
  <xsl:if test="$func/return/@type!='void'">
    <xsl:text> : </xsl:text>
    <xsl:choose>
      <xsl:when test="starts-with($func/return/@type, 'const ')">
        <xsl:call-template name="FixupVarType">
          <xsl:with-param name="text" select="substring-after($func/return/@type, 'const ')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="FixupVarType">
          <xsl:with-param name="text" select="$func/return/@type"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
  <xsl:text>; cdecl;</xsl:text>
  <xsl:if test="$type='function'">
    <xsl:if test="$hasVarArgs">
      <xsl:text> varargs;</xsl:text>
    </xsl:if>
    <xsl:text> external </xsl:text>
    <xsl:call-template name="WriteLibName"/>
    <xsl:text>;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- 
  This template is called to adjust variable names that are also Delphi 
  reserved words. The adjustment consists of simply appending an underscore
  to the name 
-->
<xsl:template name="FixupVarName">
  <xsl:param name="text"/>
  <xsl:value-of select="$text"/>
  <xsl:if test="($text='type') or
                ($text='in') or
                ($text='out') or
                ($text='to') or
                ($text='inline') or
                ($text='inLine') or
                ($text='string') or
                ($text='end') or
                ($text='set') or
                ($text='function') or
                ($text='file')">
    <xsl:text>_</xsl:text>
  </xsl:if>
</xsl:template>

<!-- 
  This template is called to change C types into Delphi equivalents (or near
  equivalents). Pointers to "non-standard" types are modified by appending the
  suffix "Ptr" to the type name
-->
<xsl:template name="FixupVarType">
  <xsl:param name="text"/>
  <xsl:choose>
    <xsl:when test="starts-with($text, 'const ')">
      <xsl:call-template name="FixupNonconstVarType">
        <xsl:with-param name="text" select="substring-after($text, 'const ')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="FixupNonconstVarType">
        <xsl:with-param name="text" select="$text"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
   
<xsl:template name="FixupNonconstVarType">
  <xsl:param name="text"/>
  <xsl:choose>
    <xsl:when test="contains($text, '(*')">
      <xsl:text>Pointer</xsl:text>
    </xsl:when>
    <xsl:when test="$text='void *'">
      <xsl:text>Pointer</xsl:text>
    </xsl:when>
    <xsl:when test="$text='void **'">
      <xsl:text>PPointer</xsl:text>
    </xsl:when>
    <xsl:when test="$text='void * *'">
      <xsl:text>PPointer</xsl:text>
    </xsl:when>
    <xsl:when test="$text='int *'">
      <xsl:text>PInteger</xsl:text>
    </xsl:when>
    <xsl:when test="$text='long *'">
      <xsl:text>PLongInt</xsl:text>
    </xsl:when>
    <xsl:when test="$text='double *'">
      <xsl:text>PDouble</xsl:text>
    </xsl:when>
    <xsl:when test="$text='int'">
      <xsl:text>Longint</xsl:text>
    </xsl:when>
    <xsl:when test="$text='long'">
      <xsl:text>Longint</xsl:text>
    </xsl:when>
    <xsl:when test="$text='float'">
      <xsl:text>Single</xsl:text>
    </xsl:when>
    <xsl:when test="$text='unsigned int'">
      <xsl:text>Cardinal</xsl:text>
    </xsl:when>
    <xsl:when test="$text='unsigned long'">
      <xsl:text>Cardinal</xsl:text>
    </xsl:when>
    <xsl:when test="$text='unsigned short'">
      <xsl:text>Word</xsl:text>
    </xsl:when>
    <xsl:when test="$text='unsigned char'">
      <xsl:text>Byte</xsl:text>
    </xsl:when>
    <xsl:when test="$text='char *'">
      <xsl:text>PChar</xsl:text>
    </xsl:when>
    <xsl:when test="$text='char const *'">
      <xsl:text>PChar</xsl:text>
    </xsl:when>
    <xsl:when test="$text='unsigned char *'">
      <xsl:text>PByte</xsl:text>
    </xsl:when>
    <xsl:when test="$text='unsigned long *'">
      <xsl:text>PCardinal</xsl:text>
    </xsl:when>
    <xsl:when test="$text='unsigned int *'">
      <xsl:text>PInteger</xsl:text>
    </xsl:when>
    <xsl:when test="$text='char **'">
      <xsl:text>PPChar</xsl:text>
    </xsl:when>
    <xsl:when test="$text='char * *'">
      <xsl:text>PPChar</xsl:text>
    </xsl:when>
    <xsl:when test="$text='xmlChar *'">
      <xsl:text>PChar</xsl:text>
    </xsl:when>
    <xsl:when test="$text='xmlChar **'">
      <xsl:text>PPChar</xsl:text>
    </xsl:when>
    <xsl:when test="$text='xmlChar * *'">
      <xsl:text>PPChar</xsl:text>
    </xsl:when>
    <xsl:when test="$text='FILE *'">
      <xsl:text>PFILE</xsl:text>
    </xsl:when>
    <xsl:when test="contains($text, ' **')">
      <xsl:value-of select="substring-before($text, ' **')"/>
      <xsl:text>PtrPtr</xsl:text>
    </xsl:when>
    <xsl:when test="contains($text, ' * *')">
      <xsl:value-of select="substring-before($text, ' * *')"/>
      <xsl:text>PtrPtr</xsl:text>
    </xsl:when>
    <xsl:when test="contains($text, ' *')">
      <xsl:value-of select="substring-before($text, ' *')"/>
      <xsl:text>Ptr</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>

