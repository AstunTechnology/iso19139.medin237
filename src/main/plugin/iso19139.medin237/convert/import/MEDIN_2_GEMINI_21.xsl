<?xml version="1.0" encoding="utf-8"?>
<!-- 
  James Rapaport 
  SeaZone Solutions Limited
  2010-11-19
  
  This stylesheet is designed to tranform MEDIN metadata to GEMINI 2.1  
  metadata conforming to the encoding guidelines. Actions performed by the 
  stylesheet:
  
  - Remove the NDGO001 keyword
  - Copy all other elements
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:gsr="http://www.isotc211.org/2005/gsr"
                xmlns:gss="http://www.isotc211.org/2005/gss"
                xmlns:gts="http://www.isotc211.org/2005/gts"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                exclude-result-prefixes="xsl" version="1.0">
  <xsl:output method="xml" omit-xml-declaration="no" encoding="utf-8" indent="yes" />
  <!-- ========================================================================== -->
  <!-- Core Template                                                              -->
  <!-- ========================================================================== -->
  <xsl:template match="/*">
    <gmd:MD_Metadata xmlns:gmd="http://www.isotc211.org/2005/gmd"
                    xmlns:gco="http://www.isotc211.org/2005/gco"
                    xmlns:gmx="http://www.isotc211.org/2005/gmx"
                    xmlns:gsr="http://www.isotc211.org/2005/gsr"
                    xmlns:gss="http://www.isotc211.org/2005/gss"
                    xmlns:gts="http://www.isotc211.org/2005/gts"
                    xmlns:srv="http://www.isotc211.org/2005/srv"
                    xmlns:gml="http://www.opengis.net/gml/3.2"
                    xmlns:xlink="http://www.w3.org/1999/xlink"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <xsl:apply-templates mode="copy"/>
    </gmd:MD_Metadata>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Core copy template                                                         -->
  <!-- ========================================================================== -->
  <xsl:template match="*" mode="copy">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="copy"/>
    </xsl:copy>
  </xsl:template>
  <!-- ========================================================================== -->
  <!-- Descriptive keywords                                                       -->
  <!-- ========================================================================== -->
  <xsl:template match="gmd:descriptiveKeywords[*/gmd:keyword/*/@xlink:href='http://vocab.ndg.nerc.ac.uk/term/N010/0']" mode="copy"/>
</xsl:stylesheet>
