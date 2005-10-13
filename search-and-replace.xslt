<?xml version="1.0"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="1.1">
  
  <xsl:template name="search-and-replace">
    <xsl:param name="text"></xsl:param>
    <xsl:param name="search"></xsl:param>
    <xsl:param name="replace"></xsl:param>
    
    <xsl:choose>
      <xsl:when test="contains($text, $search)">
        <xsl:value-of select="substring-before($text, $search)"/>
        <xsl:value-of select="$replace" />
        <xsl:call-template name="search-and-replace"> 
          <xsl:with-param name="text">
            <xsl:value-of select="substring-after($text, $search)"/>
          </xsl:with-param>
          <xsl:with-param name="search" select="$search" />
          <xsl:with-param name="replace" select="$replace" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
