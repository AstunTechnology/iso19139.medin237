<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="#all"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
<xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>

   <!--PHASES-->


<!--PROLOG-->
<xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>
   <xsl:include xmlns:svrl="http://purl.oclc.org/dsdl/svrl" href="../../../xsl/utils-fn.xsl"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="lang"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="thesaurusDir"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="rule"/>
   <xsl:variable xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="loc"
                 select="document(concat('../loc/', $lang, '/', $rule, '.xml'))"/>

   <!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
            <xsl:variable name="p_1" select="1+    count(preceding-sibling::*[name()=name(current())])"/>
            <xsl:if test="$p_1&gt;1 or following-sibling::*[name()=name(current())]">[<xsl:value-of select="$p_1"/>]</xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>']</xsl:text>
            <xsl:variable name="p_2"
                          select="1+   count(preceding-sibling::*[local-name()=local-name(current())])"/>
            <xsl:if test="$p_2&gt;1 or following-sibling::*[local-name()=local-name(current())]">[<xsl:value-of select="$p_2"/>]</xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH -->
<xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>

   <!--MODE: GENERATE-ID-2 -->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters--><xsl:template match="text()" priority="-1"/>

   <!--SCHEMA SETUP-->
<xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                              title="Schematron validation for ISO 19115(19139) UK GEMINI 2.2 Profile"
                              schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="http://www.opengis.net/gml/3.2" prefix="gml"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/gmd" prefix="gmd"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/srv" prefix="srv"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.isotc211.org/2005/gco" prefix="gco"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.fao.org/geonetwork" prefix="geonet"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/UK0503"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M8"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/UK0601"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M9"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/UK999"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M10"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Title</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M11"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi1-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M12"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Alternative title</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M13"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi2-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M14"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Dataset Language</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M15"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi3-Language</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M16"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Abstract</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M17"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi4-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M18"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Topic Category</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M19"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Keyword</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M20"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi6-Keyword-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M21"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi6-Thesaurus-Title-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M22"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi6-Thesaurus-DateType-CodeList</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M23"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Temporal extent</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M24"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Dataset reference date</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M25"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi8-ReferenceDate-DateType-CodeList</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M26"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Lineage</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M27"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi10-Statement-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M28"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">West and east longitude, north and south latitude </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M29"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi11-BoundingBox</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M30"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi11-West-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M31"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi11-East-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M32"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi11-South-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M33"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mill-North-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M34"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Extent</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M35"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi15-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M36"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Vertical extent information</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M37"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi16-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M38"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Spatial reference system</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M39"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi17-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M40"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Spatial Resolution</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M41"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi18-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M42"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Resource locator</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M43"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi19-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M44"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Data Format</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M45"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi21-Name-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M46"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi21-Version-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M47"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Responsible organisation</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M48"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi23-ResponsibleParty</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M49"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi23-OrganisationName-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M50"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi23-Role-CodeList</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M51"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Frequency of update</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M52"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi24-CodeList</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M53"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Limitations on public access</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M54"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi25-OtherConstraints-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M55"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi25-AccessConstraints-CodeList</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M56"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Use constraints</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M57"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi26-UseLimitation-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M58"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Additional information source</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M59"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi27-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M60"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Unique resource identifier</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M61"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi36-Code-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M62"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi36-CodeSpace-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M63"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Resource type</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M64"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi39-CodeList</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M65"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Conformity</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M66"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi41-Pass-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M67"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi41-Explanation-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M68"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Specification</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M69"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi42-Title-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M70"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi42-Date-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M71"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi42-DateType-CodeList</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M72"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Equivalent scale</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M73"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi43-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M74"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Metadata language</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M75"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi33-Language</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M76"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Metadata date</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M77"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi30-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M78"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Metadata point of contact</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M79"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi35-ResponsibleParty</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M80"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi35-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M81"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Spatial data service type</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M82"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-mi37-Nillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M83"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Coupled resource</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M84"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Data identification citation</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M85"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Metadata resource type test</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M86"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Metadata file identifier</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M87"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Gemini2-at3-NotNillable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M88"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Constraints</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M89"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">Creation date type</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M90"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Schematron validation for ISO 19115(19139) UK GEMINI 2.2 Profile</svrl:text>
   <xsl:variable name="langCodeList">eng;cym;gle;gla;cor;sco</xsl:variable>

   <!--PATTERN $loc/strings/UK0503-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/UK0503"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="gmd:MD_DataIdentification" priority="1000" mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="gmd:MD_DataIdentification"/>
      <xsl:variable name="value" select=".//gmd:language/gmd:LanguageCode/@codeListValue"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="exists(tokenize($langCodeList, ';')[. = $value])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="exists(tokenize($langCodeList, ';')[. = $value])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.UK0503"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
<xsl:if test="true()">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="true()">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
                <xsl:text/>
               <xsl:copy-of select="$loc/strings/UK0503.selected"/>
               <xsl:text/> "<xsl:text/>
               <xsl:copy-of select="normalize-space($value)"/>
               <xsl:text/>"</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>

   <!--PATTERN $loc/strings/UK0601-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/UK0601"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata" priority="1000" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata"/>
      <xsl:variable name="value" select="gmd:language/gmd:LanguageCode/@codeListValue"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="exists(tokenize($langCodeList, ';')[. = $value])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="exists(tokenize($langCodeList, ';')[. = $value])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/alert.UK0601"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
<xsl:if test="true()">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="true()">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:copy-of select="$loc/strings/UK0601.selected"/>
               <xsl:text/> "<xsl:text/>
               <xsl:copy-of select="normalize-space($value)"/>
               <xsl:text/>"</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M9"/>
   </xsl:template>

   <!--PATTERN $loc/strings/UK999-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/UK999"/>
   </svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:MD_Metadata" priority="1000" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//gmd:MD_Metadata"/>

		    <!--REPORT -->
<xsl:if test="true()">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="true()">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:copy-of select="$loc/strings/UK999.report.name"/>
               <xsl:text/> 
               <xsl:text/>
               <xsl:copy-of select="gmd:metadataStandardName/gco:CharacterString"/>
               <xsl:text/>
            </svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:metadataStandardName/gco:CharacterString and gmd:metadataStandardName/gco:CharacterString = 'UK GEMINI'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:metadataStandardName/gco:CharacterString and gmd:metadataStandardName/gco:CharacterString = 'UK GEMINI'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/UK999.alert.name"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
<xsl:if test="true()">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="true()">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:copy-of select="$loc/strings/UK999.report.version"/>
               <xsl:text/>
               <xsl:text/>
               <xsl:copy-of select="gmd:metadataStandardVersion/gco:CharacterString"/>
               <xsl:text/>
            </svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:metadataStandardVersion/gco:CharacterString and gmd:metadataStandardVersion/gco:CharacterString= '2.2'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:metadataStandardVersion/gco:CharacterString and gmd:metadataStandardVersion/gco:CharacterString= '2.2'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/UK999.alert.version"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M10"/>
   </xsl:template>

   <!--PATTERN Title-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Title</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M11"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi1-NotNillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi1-NotNillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:title"
                 priority="1000"
                 mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:title"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(.)&gt;0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.)&gt;0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element is not nillable and shall have a value: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M12"/>
   </xsl:template>

   <!--PATTERN Alternative title-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Alternative title</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M13"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi2-Nillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi2-Nillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:alternateTitle"
                 priority="1000"
                 mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:alternateTitle"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(.)&gt;0) or (@gco:nilReason = 'inapplicable' or                                @gco:nilReason = 'missing' or                                @gco:nilReason = 'template' or                                @gco:nilReason = 'unknown' or                                @gco:nilReason = 'withheld' or                                starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.)&gt;0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element shall have a value or a valid Nil Reason: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M14"/>
   </xsl:template>

   <!--PATTERN Dataset Language-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Dataset Language</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M15"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi3-Language-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi3-Language</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:language" priority="1001"
                 mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:language"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(gmd:LanguageCode) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:LanguageCode) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Language shall be implemented with gmd:LanguageCode.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M16"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:language/gmd:LanguageCode"
                 priority="1000"
                 mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:language/gmd:LanguageCode"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The language code list value is absent.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M16"/>
   </xsl:template>

   <!--PATTERN Abstract-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Abstract</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M17"/>
   <xsl:template match="@*|node()" priority="-2" mode="M17">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M17"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi4-NotNillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi4-NotNillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:abstract" priority="1000"
                 mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:abstract"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element is not nillable and shall have a value: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M18"/>
   </xsl:template>

   <!--PATTERN Topic Category-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Topic Category</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]" priority="1001" mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="((../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or                                 ../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series')                                and                                  count(gmd:topicCategory) &gt;= 1)                               or                                (../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and                                 ../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series')                               or                                 count(../../gmd:hierarchyLevel) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or ../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and count(gmd:topicCategory) &gt;= 1) or (../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and ../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or count(../../gmd:hierarchyLevel) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Topic category is mandatory for datasets and series. One or more shall be provided.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M19"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:topicCategory" priority="1000"
                 mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:topicCategory"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="((../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or                                 ../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series')                                and                                  count(@gco:nilReason) = 0) or                                  (../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and                                   ../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series')                                or                                 count(../../../gmd:hierarchyLevel) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or ../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and count(@gco:nilReason) = 0) or (../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and ../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or count(../../../gmd:hierarchyLevel) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Topic Category shall not be null.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M19"/>
   </xsl:template>

   <!--PATTERN Keyword-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Keyword</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]" priority="1000" mode="M20">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(gmd:descriptiveKeywords) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:descriptiveKeywords) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Descriptive keywords are mandatory.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M20"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi6-Keyword-Nillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi6-Keyword-Nillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:descriptiveKeywords/*[1]/gmd:keyword"
                 priority="1000"
                 mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:descriptiveKeywords/*[1]/gmd:keyword"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                     (@gco:nilReason = 'inapplicable' or                      @gco:nilReason = 'missing' or                      @gco:nilReason = 'template' or                      @gco:nilReason = 'unknown' or                      @gco:nilReason = 'withheld' or                    starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element shall have a value or a valid Nil Reason: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi6-Thesaurus-Title-NotNillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi6-Thesaurus-Title-NotNillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:descriptiveKeywords/*[1]/gmd:thesaurusName/*[1]/gmd:title"
                 priority="1000"
                 mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:descriptiveKeywords/*[1]/gmd:thesaurusName/*[1]/gmd:title"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element is not nillable and shall have a value: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M22"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi6-Thesaurus-DateType-CodeList-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi6-Thesaurus-DateType-CodeList</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:descriptiveKeywords/*[1]/gmd:thesaurusName/*[1]/gmd:date/*[1]/gmd:dateType/*[1]"
                 priority="1000"
                 mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:descriptiveKeywords/*[1]/gmd:thesaurusName/*[1]/gmd:date/*[1]/gmd:dateType/*[1]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The codeListValue attribute does not have a value.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M23"/>
   </xsl:template>

   <!--PATTERN Temporal extent-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Temporal extent</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent |               /*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/*[@gco:isoType='gmd:EX_TemporalExtent'][1]/gmd:extent |               /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent |               /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/*[@gco:isoType='gmd:EX_TemporalExtent'][1]/gmd:extent"
                 priority="1000"
                 mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent |               /*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:temporalElement/*[@gco:isoType='gmd:EX_TemporalExtent'][1]/gmd:extent |               /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent |               /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:temporalElement/*[@gco:isoType='gmd:EX_TemporalExtent'][1]/gmd:extent"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(gml:TimePeriod) = 1 or count(gml:TimeInstant) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gml:TimePeriod) = 1 or count(gml:TimeInstant) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Temporal extent shall be implemented using gml:TimePeriod or
                        gml:TimeInstant</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M24"/>
   </xsl:template>

   <!--PATTERN Dataset reference date-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Dataset reference date</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M25"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi8-ReferenceDate-DateType-CodeList-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi8-ReferenceDate-DateType-CodeList</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:date/*[1]/gmd:dateType/*[1]"
                 priority="1000"
                 mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:date/*[1]/gmd:dateType/*[1]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The codeListValue attribute does not have a value.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M26"/>
   </xsl:template>

   <!--PATTERN Lineage-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Lineage</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]" priority="1000" mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*[1]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="((gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or                    gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and                    count(gmd:dataQualityInfo[1]/*[1]/gmd:lineage/*[1]/gmd:statement) = 1) or                    (gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and                    gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or                     count(gmd:hierarchyLevel) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and count(gmd:dataQualityInfo[1]/*[1]/gmd:lineage/*[1]/gmd:statement) = 1) or (gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or count(gmd:hierarchyLevel) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Lineage is mandatory for datasets and series. One shall be provided.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M27"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi10-Statement-Nillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi10-Statement-Nillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:dataQualityInfo[1]/*[1]/gmd:lineage/*[1]/gmd:statement"
                 priority="1000"
                 mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:dataQualityInfo[1]/*[1]/gmd:lineage/*[1]/gmd:statement"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld'                      or starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element shall have a value or a valid Nil Reason: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M28"/>
   </xsl:template>

   <!--PATTERN West and east longitude, north and south latitude -->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">West and east longitude, north and south latitude </svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]" priority="1000" mode="M29">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="((../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or                    ../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and                    (count(gmd:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicBoundingBox) &gt;= 1) or                   count(gmd:extent/*[1]/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicBoundingBox'][1]) &gt;= 1) or                   (../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and                    ../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or                     count(../../gmd:hierarchyLevel) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or ../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and (count(gmd:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicBoundingBox) &gt;= 1) or count(gmd:extent/*[1]/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicBoundingBox'][1]) &gt;= 1) or (../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and ../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or count(../../gmd:hierarchyLevel) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Geographic bounding box is mandatory for datasets and series. One or more
                        shall be provided.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M29"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="@*|node()" priority="-2" mode="M29">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M29"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi11-BoundingBox-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi11-BoundingBox</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicBoundingBox |                /*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicBoundingBox'] [1]|                /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicBoundingBox |                /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicBoundingBox'][1]"
                 priority="1000"
                 mode="M30">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicBoundingBox |                /*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicBoundingBox'] [1]|                /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicBoundingBox |                /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicBoundingBox'][1]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(gmd:westBoundLongitude) = 0                               or (gmd:westBoundLongitude &gt;= -180.0 and                                   gmd:westBoundLongitude &lt;= 180.0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(gmd:westBoundLongitude) = 0 or (gmd:westBoundLongitude &gt;= -180.0 and gmd:westBoundLongitude &lt;= 180.0)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>West bound longitude has a value of
                        
                        which is outside bounds.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(gmd:eastBoundLongitude) = 0                               or (gmd:eastBoundLongitude &gt;= -180.0 and                               gmd:eastBoundLongitude &lt;= 180.0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(gmd:eastBoundLongitude) = 0 or (gmd:eastBoundLongitude &gt;= -180.0 and gmd:eastBoundLongitude &lt;= 180.0)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>East bound longitude has a value of
                        
                        which is outside bounds.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(gmd:southBoundLatitude) = 0                               or (gmd:southBoundLatitude &gt;= -90.0 and                                   gmd:southBoundLatitude &lt;= gmd:northBoundLatitude)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(gmd:southBoundLatitude) = 0 or (gmd:southBoundLatitude &gt;= -90.0 and gmd:southBoundLatitude &lt;= gmd:northBoundLatitude)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>South bound latitude has a value of
                        
                        which is outside bounds.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(gmd:northBoundLatitude) = 0                               or (gmd:northBoundLatitude &lt;= 90.0 and                                   gmd:northBoundLatitude &gt;= gmd:southBoundLatitude)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(gmd:northBoundLatitude) = 0 or (gmd:northBoundLatitude &lt;= 90.0 and gmd:northBoundLatitude &gt;= gmd:southBoundLatitude)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>North bound latitude has a value of
                        
                        which is outside bounds.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi11-West-NotNillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi11-West-NotNillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[1]/gmd:westBoundLongitude |                /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[1]/gmd:westBoundLongitude"
                 priority="1000"
                 mode="M31">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[1]/gmd:westBoundLongitude |                /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[1]/gmd:westBoundLongitude"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element is not nillable and shall have a value: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M31"/>
   <xsl:template match="@*|node()" priority="-2" mode="M31">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi11-East-NotNillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi11-East-NotNillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[1]/gmd:eastBoundLongitude |                /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[1]/gmd:eastBoundLongitude"
                 priority="1000"
                 mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[1]/gmd:eastBoundLongitude |                /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[1]/gmd:eastBoundLongitude"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element is not nillable and shall have a value: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi11-South-NotNillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi11-South-NotNillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[1]/gmd:southBoundLatitude |                /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[1]/gmd:southBoundLatitude"
                 priority="1000"
                 mode="M33">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[1]/gmd:southBoundLatitude |                /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[1]/gmd:southBoundLatitude"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element is not nillable and shall have a value: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M33"/>
   <xsl:template match="@*|node()" priority="-2" mode="M33">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>

   <!--PATTERN Gemini2-mill-North-NotNillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mill-North-NotNillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[1]/gmd:northBoundLatitude |                /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[1]/gmd:northBoundLatitude"
                 priority="1000"
                 mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[1]/gmd:northBoundLatitude |                /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[1]/gmd:northBoundLatitude"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element is not nillable and shall have a value: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M34"/>
   <xsl:template match="@*|node()" priority="-2" mode="M34">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>

   <!--PATTERN Extent-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Extent</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M35"/>
   <xsl:template match="@*|node()" priority="-2" mode="M35">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M35"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi15-Nillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi15-Nillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicDescription/gmd:geographicIdentifier/*[1]/gmd:code |                            /*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicDescription'][1]/gmd:geographicIdentifier/*[1]/gmd:code |                            /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicDescription/gmd:geographicIdentifier/*[1]/gmd:code |                            /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicDescription'][1]/gmd:geographicIdentifier/*[1]/gmd:code"
                 priority="1000"
                 mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicDescription/gmd:geographicIdentifier/*[1]/gmd:code |                            /*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicDescription'][1]/gmd:geographicIdentifier/*[1]/gmd:code |                            /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/gmd:EX_GeographicDescription/gmd:geographicIdentifier/*[1]/gmd:code |                            /*[1]/gmd:identificationInfo[1]/*[1]/srv:extent/*[1]/gmd:geographicElement/*[@gco:isoType='gmd:EX_GeographicDescription'][1]/gmd:geographicIdentifier/*[1]/gmd:code"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                     (@gco:nilReason = 'inapplicable' or                      @gco:nilReason = 'missing' or                      @gco:nilReason = 'template' or                      @gco:nilReason = 'unknown' or                      @gco:nilReason = 'withheld' or                    starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element shall have a value or a valid Nil Reason: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M36"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M36"/>
   <xsl:template match="@*|node()" priority="-2" mode="M36">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M36"/>
   </xsl:template>

   <!--PATTERN Vertical extent information-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Vertical extent information</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M37"/>
   <xsl:template match="@*|node()" priority="-2" mode="M37">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M37"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi16-Nillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi16-Nillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:verticalElement/*[1]/gmd:minimumValue |                /*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:verticalElement/*[1]/gmd:maximumValue"
                 priority="1000"
                 mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:verticalElement/*[1]/gmd:minimumValue |                /*[1]/gmd:identificationInfo[1]/*[1]/gmd:extent/*[1]/gmd:verticalElement/*[1]/gmd:maximumValue"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                     (@gco:nilReason = 'inapplicable' or                      @gco:nilReason = 'missing' or                      @gco:nilReason = 'template' or                      @gco:nilReason = 'unknown' or                      @gco:nilReason = 'withheld' or                    starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element shall have a value or a valid Nil Reason: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M38"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M38"/>
   <xsl:template match="@*|node()" priority="-2" mode="M38">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M38"/>
   </xsl:template>

   <!--PATTERN Spatial reference system-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Spatial reference system</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M39"/>
   <xsl:template match="@*|node()" priority="-2" mode="M39">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M39"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi17-Nillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi17-Nillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:referenceSystemInfo/*[1]/gmd:referenceSystemIdentifier/*[1]/gmd:code"
                 priority="1000"
                 mode="M40">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:referenceSystemInfo/*[1]/gmd:referenceSystemIdentifier/*[1]/gmd:code"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                     (@gco:nilReason = 'inapplicable' or                      @gco:nilReason = 'missing' or                      @gco:nilReason = 'template' or                      @gco:nilReason = 'unknown' or                      @gco:nilReason = 'withheld' or                    starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element shall have a value or a valid Nil Reason: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M40"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M40"/>
   <xsl:template match="@*|node()" priority="-2" mode="M40">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M40"/>
   </xsl:template>

   <!--PATTERN Spatial Resolution-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Spatial Resolution</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M41"/>
   <xsl:template match="@*|node()" priority="-2" mode="M41">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M41"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi18-Nillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi18-Nillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:spatialResolution/*[1]/gmd:distance"
                 priority="1000"
                 mode="M42">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:spatialResolution/*[1]/gmd:distance"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                     (@gco:nilReason = 'inapplicable' or                      @gco:nilReason = 'missing' or                      @gco:nilReason = 'template' or                      @gco:nilReason = 'unknown' or                      @gco:nilReason = 'withheld' or                    starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element shall have a value or a valid Nil Reason: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M42"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M42"/>
   <xsl:template match="@*|node()" priority="-2" mode="M42">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M42"/>
   </xsl:template>

   <!--PATTERN Resource locator-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Resource locator</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:distributionInfo/*[1]/gmd:transferOptions/*[1]/gmd:onLine/*[1]"
                 priority="1000"
                 mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:distributionInfo/*[1]/gmd:transferOptions/*[1]/gmd:onLine/*[1]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(gmd:linkage) = 0 or                                (starts-with(normalize-space(gmd:linkage/*[1]), 'http://')  or                                 starts-with(normalize-space(gmd:linkage/*[1]), 'https://') or                                 starts-with(normalize-space(gmd:linkage/*[1]), 'ftp://'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:linkage) = 0 or (starts-with(normalize-space(gmd:linkage/*[1]), 'http://') or starts-with(normalize-space(gmd:linkage/*[1]), 'https://') or starts-with(normalize-space(gmd:linkage/*[1]), 'ftp://'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value of resource locator does not appear to be a valid URL.
                        It has a value of ''. The URL must start with either http://, https:// or ftp://.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M43"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M43"/>
   <xsl:template match="@*|node()" priority="-2" mode="M43">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M43"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi19-Nillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi19-Nillable</svrl:text>

	  <!--RULE -->
<xsl:template match="*[1]/gmd:distributionInfo/*[1]/gmd:transferOptions/*[1]/gmd:onLine/*[1]/gmd:linkage"
                 priority="1000"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[1]/gmd:distributionInfo/*[1]/gmd:transferOptions/*[1]/gmd:onLine/*[1]/gmd:linkage"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                     (@gco:nilReason = 'inapplicable' or                      @gco:nilReason = 'missing' or                      @gco:nilReason = 'template' or                      @gco:nilReason = 'unknown' or                      @gco:nilReason = 'withheld' or                    starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element shall have a value or a valid Nil Reason: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M44"/>
   <xsl:template match="@*|node()" priority="-2" mode="M44">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>

   <!--PATTERN Data Format-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Data Format</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M45"/>
   <xsl:template match="@*|node()" priority="-2" mode="M45">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M45"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi21-Name-Nillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi21-Name-Nillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:distributionInfo/*[1]/gmd:distributionFormat/*[1]/gmd:name"
                 priority="1000"
                 mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:distributionInfo/*[1]/gmd:distributionFormat/*[1]/gmd:name"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                     (@gco:nilReason = 'inapplicable' or                      @gco:nilReason = 'missing' or                      @gco:nilReason = 'template' or                      @gco:nilReason = 'unknown' or                      @gco:nilReason = 'withheld' or                    starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element shall have a value or a valid Nil Reason: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M46"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M46"/>
   <xsl:template match="@*|node()" priority="-2" mode="M46">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M46"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi21-Version-Nillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi21-Version-Nillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:distributionInfo/*[1]/gmd:distributionFormat/*[1]/gmd:version"
                 priority="1000"
                 mode="M47">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:distributionInfo/*[1]/gmd:distributionFormat/*[1]/gmd:version"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                     (@gco:nilReason = 'inapplicable' or                      @gco:nilReason = 'missing' or                      @gco:nilReason = 'template' or                      @gco:nilReason = 'unknown' or                      @gco:nilReason = 'withheld' or                    starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element shall have a value or a valid Nil Reason: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M47"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M47"/>
   <xsl:template match="@*|node()" priority="-2" mode="M47">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M47"/>
   </xsl:template>

   <!--PATTERN Responsible organisation-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Responsible organisation</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]" priority="1001" mode="M48">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(gmd:pointOfContact) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:pointOfContact) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Responsible organisation is mandatory. At least one shall be provided.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M48"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact" priority="1000"
                 mode="M48">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value of responsible organisation shall not be null.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M48"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M48"/>
   <xsl:template match="@*|node()" priority="-2" mode="M48">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M48"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi23-ResponsibleParty-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi23-ResponsibleParty</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact" priority="1000"
                 mode="M49">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(*/gmd:organisationName) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:organisationName) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>One organisation name shall be provided.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(*/gmd:contactInfo/*[1]/gmd:address/*[1]/gmd:electronicMailAddress) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:contactInfo/*[1]/gmd:address/*[1]/gmd:electronicMailAddress) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>One email address shall be provided</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M49"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M49"/>
   <xsl:template match="@*|node()" priority="-2" mode="M49">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M49"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi23-OrganisationName-NotNillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi23-OrganisationName-NotNillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact/*[1]/gmd:organisationName |                /*[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact/*[1]/gmd:contactInfo/*[1]/gmd:address/*[1]/gmd:electronicMailAddress"
                 priority="1000"
                 mode="M50">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact/*[1]/gmd:organisationName |                /*[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact/*[1]/gmd:contactInfo/*[1]/gmd:address/*[1]/gmd:electronicMailAddress"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element is not nillable and shall have a value: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M50"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M50"/>
   <xsl:template match="@*|node()" priority="-2" mode="M50">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M50"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi23-Role-CodeList-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi23-Role-CodeList</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact/*[1]/gmd:role/*[1]"
                 priority="1000"
                 mode="M51">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:pointOfContact/*[1]/gmd:role/*[1]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The codeListValue attribute does not have a value.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M51"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M51"/>
   <xsl:template match="@*|node()" priority="-2" mode="M51">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M51"/>
   </xsl:template>

   <!--PATTERN Frequency of update-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Frequency of update</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M52"/>
   <xsl:template match="@*|node()" priority="-2" mode="M52">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M52"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi24-CodeList-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi24-CodeList</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceMaintenance/*[1]/gmd:maintenanceAndUpdateFrequency/*[1]"
                 priority="1000"
                 mode="M53">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceMaintenance/*[1]/gmd:maintenanceAndUpdateFrequency/*[1]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The codeListValue attribute does not have a value.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M53"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M53"/>
   <xsl:template match="@*|node()" priority="-2" mode="M53">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M53"/>
   </xsl:template>

   <!--PATTERN Limitations on public access-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Limitations on public access</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/gmd:MD_LegalConstraints |                            /*[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1][gco:isoType='gmd:MD_LegalConstraints']"
                 priority="1000"
                 mode="M54">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/gmd:MD_LegalConstraints |                            /*[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1][gco:isoType='gmd:MD_LegalConstraints']"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(gmd:accessConstraints[*/@codeListValue='otherRestrictions']) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:accessConstraints[*/@codeListValue='otherRestrictions']) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Limitations on public access code list value shall be 'otherRestrictions'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(gmd:otherConstraints) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:otherConstraints) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Limitations on public access shall be expressed using gmd:otherConstraints.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M54"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M54"/>
   <xsl:template match="@*|node()" priority="-2" mode="M54">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M54"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi25-OtherConstraints-Nillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi25-OtherConstraints-Nillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1]/gmd:otherConstraints"
                 priority="1000"
                 mode="M55">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1]/gmd:otherConstraints"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                     (@gco:nilReason = 'inapplicable' or                      @gco:nilReason = 'missing' or                      @gco:nilReason = 'template' or                      @gco:nilReason = 'unknown' or                      @gco:nilReason = 'withheld' or                    starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element shall have a value or a valid Nil Reason: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M55"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M55"/>
   <xsl:template match="@*|node()" priority="-2" mode="M55">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M55"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi25-AccessConstraints-CodeList-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi25-AccessConstraints-CodeList</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1]/gmd:accessConstraints/*[1]"
                 priority="1000"
                 mode="M56">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1]/gmd:accessConstraints/*[1]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The codeListValue attribute does not have a value.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M56"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M56"/>
   <xsl:template match="@*|node()" priority="-2" mode="M56">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M56"/>
   </xsl:template>

   <!--PATTERN Use constraints-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Use constraints</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]" priority="1000" mode="M57">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(gmd:resourceConstraints/*[1]/gmd:useLimitation) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:resourceConstraints/*[1]/gmd:useLimitation) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Use limitation shall be provided.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M57"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M57"/>
   <xsl:template match="@*|node()" priority="-2" mode="M57">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M57"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi26-UseLimitation-Nillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi26-UseLimitation-Nillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1]/gmd:useLimitation"
                 priority="1000"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:resourceConstraints/*[1]/gmd:useLimitation"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                     (@gco:nilReason = 'inapplicable' or                      @gco:nilReason = 'missing' or                      @gco:nilReason = 'template' or                      @gco:nilReason = 'unknown' or                      @gco:nilReason = 'withheld' or                    starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element shall have a value or a valid Nil Reason: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M58"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M58"/>
   <xsl:template match="@*|node()" priority="-2" mode="M58">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M58"/>
   </xsl:template>

   <!--PATTERN Additional information source-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Additional information source</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M59"/>
   <xsl:template match="@*|node()" priority="-2" mode="M59">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M59"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi27-Nillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi27-Nillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:supplementalInformation"
                 priority="1000"
                 mode="M60">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:supplementalInformation"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                     (@gco:nilReason = 'inapplicable' or                      @gco:nilReason = 'missing' or                      @gco:nilReason = 'template' or                      @gco:nilReason = 'unknown' or                      @gco:nilReason = 'withheld' or                    starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element shall have a value or a valid Nil Reason: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M60"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M60"/>
   <xsl:template match="@*|node()" priority="-2" mode="M60">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M60"/>
   </xsl:template>

   <!--PATTERN Unique resource identifier-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Unique resource identifier</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]" priority="1000"
                 mode="M61">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="((../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or                     ../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and                     count(gmd:identifier) &gt;= 1) or                     (../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and                     ../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or                     count(../../../../gmd:hierarchyLevel) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="((../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or ../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series') and count(gmd:identifier) &gt;= 1) or (../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'dataset' and ../../../../gmd:hierarchyLevel[1]/*[1]/@codeListValue != 'series') or count(../../../../gmd:hierarchyLevel) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Unique resource identifier is mandatory for datasets and series. One or
                        more shall be provided.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M61"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M61"/>
   <xsl:template match="@*|node()" priority="-2" mode="M61">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M61"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi36-Code-NotNillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi36-Code-NotNillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:identifier/*[1]/gmd:code"
                 priority="1000"
                 mode="M62">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:identifier/*[1]/gmd:code"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element is not nillable and shall have a value: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M62"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M62"/>
   <xsl:template match="@*|node()" priority="-2" mode="M62">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M62"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi36-CodeSpace-Nillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi36-CodeSpace-Nillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:identifier/*[1]/gmd:codeSpace"
                 priority="1000"
                 mode="M63">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:citation/*[1]/gmd:identifier/*[1]/gmd:codeSpace"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                     (@gco:nilReason = 'inapplicable' or                      @gco:nilReason = 'missing' or                      @gco:nilReason = 'template' or                      @gco:nilReason = 'unknown' or                      @gco:nilReason = 'withheld' or                    starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element shall have a value or a valid Nil Reason: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M63"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M63"/>
   <xsl:template match="@*|node()" priority="-2" mode="M63">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M63"/>
   </xsl:template>

   <!--PATTERN Resource type-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Resource type</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]" priority="1000" mode="M64">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*[1]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(gmd:hierarchyLevel) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:hierarchyLevel) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Resource type is mandatory. One shall be provided.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or                               gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series' or                               gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'service'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'dataset' or gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'series' or gmd:hierarchyLevel[1]/*[1]/@codeListValue = 'service'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Value of resource type shall be 'dataset', 'series' or 'service'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M64"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M64"/>
   <xsl:template match="@*|node()" priority="-2" mode="M64">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M64"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi39-CodeList-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi39-CodeList</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:hierarchyLevel/*[1]" priority="1000" mode="M65">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:hierarchyLevel/*[1]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The codeListValue attribute does not have a value.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M65"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M65"/>
   <xsl:template match="@*|node()" priority="-2" mode="M65">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M65"/>
   </xsl:template>

   <!--PATTERN Conformity-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Conformity</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M66"/>
   <xsl:template match="@*|node()" priority="-2" mode="M66">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M66"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi41-Pass-NotNillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi41-Pass-NotNillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:dataQualityInfo/*[1]/gmd:report/*[1]/gmd:result/*[1]/gmd:pass"
                 priority="1000"
                 mode="M67">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:dataQualityInfo/*[1]/gmd:report/*[1]/gmd:result/*[1]/gmd:pass"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element is not nillable and shall have a value: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M67"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M67"/>
   <xsl:template match="@*|node()" priority="-2" mode="M67">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M67"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi41-Explanation-Nillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi41-Explanation-Nillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:dataQualityInfo/*[1]/gmd:report/*[1]/gmd:result/*[1]/gmd:explanation"
                 priority="1000"
                 mode="M68">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:dataQualityInfo/*[1]/gmd:report/*[1]/gmd:result/*[1]/gmd:explanation"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                     (@gco:nilReason = 'inapplicable' or                      @gco:nilReason = 'missing' or                      @gco:nilReason = 'template' or                      @gco:nilReason = 'unknown' or                      @gco:nilReason = 'withheld' or                    starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element shall have a value or a valid Nil Reason: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M68"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M68"/>
   <xsl:template match="@*|node()" priority="-2" mode="M68">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M68"/>
   </xsl:template>

   <!--PATTERN Specification-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Specification</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M69"/>
   <xsl:template match="@*|node()" priority="-2" mode="M69">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M69"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi42-Title-NotNillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi42-Title-NotNillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:dataQualityInfo/*[1]/gmd:report/*[1]/gmd:result/*[1]/gmd:specification/*[1]/gmd:title"
                 priority="1000"
                 mode="M70">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:dataQualityInfo/*[1]/gmd:report/*[1]/gmd:result/*[1]/gmd:specification/*[1]/gmd:title"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element is not nillable and shall have a value: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M70"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M70"/>
   <xsl:template match="@*|node()" priority="-2" mode="M70">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M70"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi42-Date-Nillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi42-Date-Nillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:dataQualityInfo/*[1]/gmd:report/*[1]/gmd:result/*[1]/gmd:specification/*[1]/gmd:date/*[1]/gmd:date"
                 priority="1000"
                 mode="M71">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:dataQualityInfo/*[1]/gmd:report/*[1]/gmd:result/*[1]/gmd:specification/*[1]/gmd:date/*[1]/gmd:date"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                     (@gco:nilReason = 'inapplicable' or                      @gco:nilReason = 'missing' or                      @gco:nilReason = 'template' or                      @gco:nilReason = 'unknown' or                      @gco:nilReason = 'withheld' or                    starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element shall have a value or a valid Nil Reason: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M71"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M71"/>
   <xsl:template match="@*|node()" priority="-2" mode="M71">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M71"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi42-DateType-CodeList-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi42-DateType-CodeList</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:dataQualityInfo/*[1]/gmd:report/*[1]/gmd:result/*[1]/gmd:specification/*[1]/gmd:date/*[1]/gmd:date/*[1]/gmd:dateType/*[1]"
                 priority="1000"
                 mode="M72">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:dataQualityInfo/*[1]/gmd:report/*[1]/gmd:result/*[1]/gmd:specification/*[1]/gmd:date/*[1]/gmd:date/*[1]/gmd:dateType/*[1]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The codeListValue attribute does not have a value.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M72"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M72"/>
   <xsl:template match="@*|node()" priority="-2" mode="M72">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M72"/>
   </xsl:template>

   <!--PATTERN Equivalent scale-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Equivalent scale</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M73"/>
   <xsl:template match="@*|node()" priority="-2" mode="M73">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M73"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi43-Nillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi43-Nillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:spatialResolution/*[1]/gmd:equivalentScale/*[1]/gmd:denominator"
                 priority="1000"
                 mode="M74">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:spatialResolution/*[1]/gmd:equivalentScale/*[1]/gmd:denominator"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                     (@gco:nilReason = 'inapplicable' or                      @gco:nilReason = 'missing' or                      @gco:nilReason = 'template' or                      @gco:nilReason = 'unknown' or                      @gco:nilReason = 'withheld' or                    starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element shall have a value or a valid Nil Reason: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M74"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M74"/>
   <xsl:template match="@*|node()" priority="-2" mode="M74">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M74"/>
   </xsl:template>

   <!--PATTERN Metadata language-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Metadata language</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]" priority="1000" mode="M75">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*[1]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(gmd:language) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:language) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Metadata language is mandatory. One shall be provided.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M75"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M75"/>
   <xsl:template match="@*|node()" priority="-2" mode="M75">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M75"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi33-Language-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi33-Language</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:language" priority="1001" mode="M76">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*[1]/gmd:language"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(gmd:LanguageCode) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:LanguageCode) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Language shall be implemented with gmd:LanguageCode.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M76"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:language/gmd:LanguageCode" priority="1000" mode="M76">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:language/gmd:LanguageCode"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(@codeListValue) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(@codeListValue) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The language code list value is absent.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M76"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M76"/>
   <xsl:template match="@*|node()" priority="-2" mode="M76">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M76"/>
   </xsl:template>

   <!--PATTERN Metadata date-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Metadata date</svrl:text>
   <xsl:template match="text()" priority="-1" mode="M77"/>
   <xsl:template match="@*|node()" priority="-2" mode="M77">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M77"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi30-Nillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi30-Nillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:dateStamp" priority="1000" mode="M78">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*[1]/gmd:dateStamp"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                     (@gco:nilReason = 'inapplicable' or                      @gco:nilReason = 'missing' or                      @gco:nilReason = 'template' or                      @gco:nilReason = 'unknown' or                      @gco:nilReason = 'withheld' or                    starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element shall have a value or a valid Nil Reason: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M78"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M78"/>
   <xsl:template match="@*|node()" priority="-2" mode="M78">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M78"/>
   </xsl:template>

   <!--PATTERN Metadata point of contact-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Metadata point of contact</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:contact" priority="1000" mode="M79">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*[1]/gmd:contact"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value of metadata point of contact shall not be null.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(parent::node()[gmd:contact/*[1]/gmd:role/*[1]/@codeListValue='pointOfContact']) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(parent::node()[gmd:contact/*[1]/gmd:role/*[1]/@codeListValue='pointOfContact']) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>At least one metadata point of contact shall have the role
                        'pointOfContact'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M79"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M79"/>
   <xsl:template match="@*|node()" priority="-2" mode="M79">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M79"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi35-ResponsibleParty-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi35-ResponsibleParty</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:contact" priority="1000" mode="M80">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*[1]/gmd:contact"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(*/gmd:organisationName) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:organisationName) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>One organisation name shall be provided.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(*/gmd:contactInfo/*[1]/gmd:address/*[1]/gmd:electronicMailAddress) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(*/gmd:contactInfo/*[1]/gmd:address/*[1]/gmd:electronicMailAddress) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>One email address shall be provided</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M80"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M80"/>
   <xsl:template match="@*|node()" priority="-2" mode="M80">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M80"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi35-NotNillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi35-NotNillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:contact/*[1]/gmd:organisationName | /*[1]/gmd:contact/*[1]/gmd:contactInfo/*[1]/gmd:address/*[1]/gmd:electronicMailAddress"
                 priority="1000"
                 mode="M81">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:contact/*[1]/gmd:organisationName | /*[1]/gmd:contact/*[1]/gmd:contactInfo/*[1]/gmd:address/*[1]/gmd:electronicMailAddress"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element is not nillable and shall have a value: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M81"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M81"/>
   <xsl:template match="@*|node()" priority="-2" mode="M81">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M81"/>
   </xsl:template>

   <!--PATTERN Spatial data service type-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Spatial data service type</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/srv:SV_ServiceIdentification |                            /*[1]/gmd:identificationInfo[1]/*[@gco:isoType='srv:SV_ServiceIdentification'][1]"
                 priority="1000"
                 mode="M82">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/srv:SV_ServiceIdentification |                            /*[1]/gmd:identificationInfo[1]/*[@gco:isoType='srv:SV_ServiceIdentification'][1]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(../../gmd:hierarchyLevel/*[1]/@codeListValue = 'service' and                                count(srv:serviceType) = 1) or                               ../../gmd:hierarchyLevel/*[1]/@codeListValue != 'service'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(../../gmd:hierarchyLevel/*[1]/@codeListValue = 'service' and count(srv:serviceType) = 1) or ../../gmd:hierarchyLevel/*[1]/@codeListValue != 'service'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>If the resource type is service, one spatial data service type shall
                        be provided.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="srv:serviceType/*[1] = 'discovery' or                               srv:serviceType/*[1] = 'view' or                               srv:serviceType/*[1] = 'download' or                               srv:serviceType/*[1] = 'transformation' or                               srv:serviceType/*[1] = 'invoke' or                               srv:serviceType/*[1] = 'other'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="srv:serviceType/*[1] = 'discovery' or srv:serviceType/*[1] = 'view' or srv:serviceType/*[1] = 'download' or srv:serviceType/*[1] = 'transformation' or srv:serviceType/*[1] = 'invoke' or srv:serviceType/*[1] = 'other'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Service type shall be one of 'discovery', 'view', 'download',
                        'transformation', 'invoke' or 'other' following INSPIRE generic
                        names.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M82"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M82"/>
   <xsl:template match="@*|node()" priority="-2" mode="M82">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M82"/>
   </xsl:template>

   <!--PATTERN Gemini2-mi37-Nillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-mi37-Nillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/srv:serviceType" priority="1000"
                 mode="M83">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/srv:serviceType"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="(string-length(.) &gt; 0) or                     (@gco:nilReason = 'inapplicable' or                      @gco:nilReason = 'missing' or                      @gco:nilReason = 'template' or                      @gco:nilReason = 'unknown' or                      @gco:nilReason = 'withheld' or                    starts-with(@gco:nilReason, 'other:'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(string-length(.) &gt; 0) or (@gco:nilReason = 'inapplicable' or @gco:nilReason = 'missing' or @gco:nilReason = 'template' or @gco:nilReason = 'unknown' or @gco:nilReason = 'withheld' or starts-with(@gco:nilReason, 'other:'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element shall have a value or a valid Nil Reason: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M83"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M83"/>
   <xsl:template match="@*|node()" priority="-2" mode="M83">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M83"/>
   </xsl:template>

   <!--PATTERN Coupled resource-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Coupled resource</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/srv:operatesOn" priority="1000"
                 mode="M84">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/srv:operatesOn"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(@xlink:href) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(@xlink:href) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Coupled resource shall be implemented by reference using the xlink:href
                        attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M84"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M84"/>
   <xsl:template match="@*|node()" priority="-2" mode="M84">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M84"/>
   </xsl:template>

   <!--PATTERN Data identification citation-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Data identification citation</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:citation" priority="1000"
                 mode="M85">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]/gmd:citation"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Identification information citation shall not be null.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M85"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M85"/>
   <xsl:template match="@*|node()" priority="-2" mode="M85">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M85"/>
   </xsl:template>

   <!--PATTERN Metadata resource type test-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Metadata resource type test</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]" priority="1000" mode="M86">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]"/>
      <xsl:variable name="isData"
                    select="../gmd:hierarchyLevel[1]/gmd:MD_ScopeCode/@codeListValue='dataset' or                                       ../gmd:hierarchyLevel[1]/gmd:MD_ScopeCode/@codeListValue='series'"/>
      <xsl:variable name="isService"
                    select="../gmd:hierarchyLevel[1]/gmd:MD_ScopeCode/@codeListValue='service'"/>
      <xsl:variable name="dataIdExists"
                    select="count(*[local-name()='MD_DataIdentification'])=1 or                                             count(*[@gco:isoType='gmd:MD_DataIdentification'])=1"/>
      <xsl:variable name="serviceIdExists"
                    select="count(*[local-name()='SV_ServiceIdentification'])=1 or                                             count(*[@gco:isoType='srv:SV_ServiceIdentification'])=1"/>

		    <!--REPORT -->
<xsl:if test="$isData">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$isData">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Resource type is data</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT -->
<xsl:if test="$isService">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$isService">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Resource type is service</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($isData) or                           ( $isData and $dataIdExists ) or                           count(../gmd:hierarchyLevel) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="not($isData) or ( $isData and $dataIdExists ) or count(../gmd:hierarchyLevel) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The first identification information element shall be of type
                gmd:MD_DataIdentification.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="not($isService) or                           ( $isService and $serviceIdExists ) or                           count(../gmd:hierarchyLevel) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="not($isService) or ( $isService and $serviceIdExists ) or count(../gmd:hierarchyLevel) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The first identification information element shall be of type
                srv:SV_ServiceIdentification.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M86"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M86"/>
   <xsl:template match="@*|node()" priority="-2" mode="M86">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M86"/>
   </xsl:template>

   <!--PATTERN Metadata file identifier-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Metadata file identifier</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]" priority="1000" mode="M87">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*[1]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(gmd:fileIdentifier) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:fileIdentifier) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A metadata file identifier shall be provided. Its value shall be a
                system generated GUID.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M87"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M87"/>
   <xsl:template match="@*|node()" priority="-2" mode="M87">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M87"/>
   </xsl:template>

   <!--PATTERN Gemini2-at3-NotNillable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Gemini2-at3-NotNillable</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:fileIdentifier" priority="1000" mode="M88">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*[1]/gmd:fileIdentifier"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="string-length(.) &gt; 0 and count(./@gco:nilReason) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Element is not nillable and shall have a value: <xsl:text/>
                  <xsl:copy-of select="name(.)"/>
                  <xsl:text/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M88"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M88"/>
   <xsl:template match="@*|node()" priority="-2" mode="M88">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M88"/>
   </xsl:template>

   <!--PATTERN Constraints-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Constraints</svrl:text>

	  <!--RULE -->
<xsl:template match="/*[1]/gmd:identificationInfo[1]/*[1]" priority="1000" mode="M89">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/*[1]/gmd:identificationInfo[1]/*[1]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(gmd:resourceConstraints) &gt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:resourceConstraints) &gt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Limitations on public access and use constrains are required.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M89"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M89"/>
   <xsl:template match="@*|node()" priority="-2" mode="M89">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M89"/>
   </xsl:template>

   <!--PATTERN Creation date type-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Creation date type</svrl:text>

	  <!--RULE -->
<xsl:template match="//gmd:CI_Citation | //*[@gco:isoType='gmd:CI_Citation'][1]"
                 priority="1000"
                 mode="M90">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//gmd:CI_Citation | //*[@gco:isoType='gmd:CI_Citation'][1]"/>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(gmd:date/*[1]/gmd:dateType/*[1][@codeListValue='creation']) &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(gmd:date/*[1]/gmd:dateType/*[1][@codeListValue='creation']) &lt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>There shall not be more than one creation date.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M90"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M90"/>
   <xsl:template match="@*|node()" priority="-2" mode="M90">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M90"/>
   </xsl:template>
</xsl:stylesheet>