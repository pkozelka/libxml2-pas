<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="no"/>

  <xsl:param name="aFileName" select="'security'"/>
  <xsl:param name="aExternalConst" select="'LIBXSLT_SO'"/>

  <xsl:template match="text()"/>

  <xsl:template match="/">
    <html>
      <style>
pre {
    color: yellow;
    background-color: navy;
}

div {
    padding: 0;
    margin: 0;
    border: 0;
}
a {
    color: yellow;
    text-decoration: none;
}
a:hover {
    text-decoration: underline;
}
.keyword {
    color: white;
    font-weight: bold;
}
.error {
    color: red;
    font-weight: bold;
}
.comment {
    color: lime;
    font-style: italic;
}
      </style>
      <body>
        <xsl:apply-templates select="api/files/file"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="file">
    <xsl:variable name="fileName" select="@name"/>
    <h1><xsl:value-of select="$fileName"/>.h</h1>
    <pre>
      <div class="comment">//
// libxslt_<xsl:value-of select="$fileName"/>.inc
//
// Symbols from <xsl:value-of select="$fileName"/>.h
// as published in <a href="http://xmlsoft.org">libxslt-api.xml</a> with <a href="http://libxml2-pas.sourceforge.net">headers.xsl</a> script
// Petr Kozelka (C) 2002
//

</div>
      <xsl:apply-templates select="/api/symbols/*[@file=$fileName]"/>
    </pre>
  </xsl:template>

  <xsl:template match="*">
    <a name="#{@name}"/><xsl:call-template name="functionComment"/><div class="comment" title="unable to translate">// <span class="keyword error"><xsl:value-of select="name()"/></span><xsl:value-of select="concat(' ',@name)"/>
</div>
  </xsl:template>

  <xsl:template match="const">
    <xsl:variable name="thisFile" select="@file"/>
    <a name="#{@name}"/><xsl:call-template name="comment2"/>
    <xsl:if test="name(preceding-sibling::*[@file=$thisFile][1])!='const'"><div><span class="keyword">const</span></div></xsl:if>
    <div><xsl:value-of select="concat('  ',@name,' = ')"/><span class="error">'Unknown value'</span>;
</div>
  </xsl:template>

  <xsl:template match="functype">
    <a name="#{@name}"/><xsl:call-template name="comment2"/>
    <xsl:call-template name="functionComment"/>
    <div><span class="keyword">type</span></div>
    <div title="{info}"><xsl:value-of select="concat('  ',@name,' = ')"/><xsl:call-template name="functionDecl"/>
</div></xsl:template>

  <xsl:template match="typedef">
    <xsl:variable name="allBut3" select="substring(@name,1,string-length(@name)-3)"/>
    <xsl:variable name="last3" select="substring(@name,string-length(@name)+1)"/>
    <xsl:variable name="thisFile" select="@file"/>
    <a name="#{@name}"/><xsl:call-template name="comment2"/>
    <xsl:if test="name(preceding-sibling::*[@file=$thisFile][1])!='typedef'"><div><span class="keyword">type</span></div></xsl:if>
    <div title="{info}"><xsl:choose>
      <xsl:when test="$last3='Ptr'"><xsl:value-of select="concat('  ',@name,' = ^',$last3)"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="concat('  ',@name,' = ')"/><span class="error">Pointer</span>;<span class="comment"> // declaration not available</span></xsl:otherwise>
    </xsl:choose>;
</div>
  </xsl:template>

  <xsl:template match="struct">
    <a name="#{@name}"/><xsl:call-template name="comment2"/>
    <div><span class="keyword">type</span></div>
    <div><xsl:value-of select="concat('  ',@name,' = ')"/><span class="keyword">record</span><span class="comment">
    // <span class="error">error:</span> members not available
  </span><span class="keyword">end</span>;

</div>
  </xsl:template>

  <xsl:template match="function">
    <a name="#{@name}"/><div class="function">
      <xsl:call-template name="functionComment"/><div class="declaration"><xsl:call-template name="functionDecl">
<xsl:with-param name="aName" select="@name"/></xsl:call-template>
<span class="keyword">external </span> <xsl:value-of select="$aExternalConst" />;

</div></div>
  </xsl:template>

  <xsl:template match="arg">
    <xsl:if test="@type!='...'"><xsl:if test="position()!=1">; </xsl:if>
    <span title="{@info}"><xsl:value-of select="@name" /></span>: <xsl:call-template name="translateType">
      <xsl:with-param name="aType" select="@type"/>
    </xsl:call-template></xsl:if>
  </xsl:template>

  <xsl:template match="arg[@type!='...']" mode="javadoc">
 * <xsl:value-of select="concat('@param ',@name,'  ',@info)" />
  </xsl:template>

  <xsl:template match="arg[@type='...']" mode="javadoc">
 * <span title="variable number of arguments"><xsl:value-of select="concat('@param ... ',@info)" /></span>
  </xsl:template>

  <xsl:template name="functionComment">
<xsl:if test="*[@info]|info">
    <div class="comment">(**
<xsl:if test="info"> * <xsl:value-of select="info"/></xsl:if>
<xsl:if test="*[@info]">
 *<xsl:apply-templates select="arg" mode="javadoc"/></xsl:if>
<xsl:if test="return/@info">
 * @return  <xsl:value-of select="return/@info"/></xsl:if>
 *)</div>
</xsl:if>
</xsl:template>

  <xsl:template name="comment2">
<xsl:if test="@info">
    <div class="comment">(**
 * <xsl:value-of select="@info"/>
 *)</div>
</xsl:if>
</xsl:template>

  <xsl:template name="functionDecl">
    <xsl:param name="aName"/>
    <span class="keyword"><xsl:choose>
        <xsl:when test="return/@type='void'">procedure </xsl:when>
        <xsl:otherwise>function  </xsl:otherwise>
      </xsl:choose></span>
      <span title="{info}"><xsl:value-of select="$aName"/></span><xsl:if test="arg">(<xsl:apply-templates select="arg"/>)</xsl:if><xsl:if test="return/@type!='void'">: <xsl:call-template name="translateType">
          <xsl:with-param name="aType" select="return/@type"/>
        </xsl:call-template></xsl:if>; <span class="keyword">cdecl</span>; <xsl:if test="arg[@type='...']"><span class="keyword">varargs</span>; </xsl:if></xsl:template>

  <xsl:template name="translateType">
    <xsl:param name="aType"/>
    <xsl:variable name="type" select="normalize-space($aType)"/>
    <xsl:choose>
      <xsl:when test="$type='int'">Longint</xsl:when>
      <xsl:when test="$type='int *'">PLongint</xsl:when>
      <xsl:when test="$type='void *'">Pointer</xsl:when>
      <xsl:when test="$type='const char **'">^PChar</xsl:when>
      <xsl:when test="$type='char **'">^PChar</xsl:when>
      <xsl:when test="$type='FILE *'">PLibXml2File</xsl:when>
      <xsl:when test="$type='const xmlChar *'">PxmlChar</xsl:when>
      <xsl:when test="$type='xmlChar *'">PxmlChar</xsl:when>
      <xsl:when test="$type='const xmlChar*'">PxmlChar</xsl:when>
      <xsl:when test="$type='xmlChar*'">PxmlChar</xsl:when>
      <xsl:when test="$type='xmlChar**'">^PxmlChar</xsl:when>
      <xsl:when test="$type='xmlChar **'">^PxmlChar</xsl:when>
      <xsl:when test="$type='const char *'">PChar</xsl:when>
      <xsl:when test="$type='char *'">PChar</xsl:when>
      <xsl:when test="$type='unsigned char *'">PChar</xsl:when>
      <xsl:when test="$type='const char*'">PChar</xsl:when>
      <xsl:when test="$type='char*'">PChar</xsl:when>
      <xsl:when test="$type='xmlNodePtr *'">PxmlNodePtr</xsl:when>
      <xsl:otherwise><a href="#{$type}"><xsl:value-of select="$type"/></a></xsl:otherwise>
    </xsl:choose></xsl:template>
</xsl:stylesheet>
