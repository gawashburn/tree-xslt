<?xml version="1.0"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:split="http://types.bu.edu/XSL/Transform/Split"
  version="1.1">
  
  <xsl:template name="split-text">
    <xsl:param name="text" />
    <xsl:param name="split" />  
    <xsl:choose>
      <xsl:when test="contains($text, $split)">
        <xsl:variable name="split-text">
        </xsl:variable>
          <split:text>
            <xsl:value-of select="substring-before($text, $split)"/>
          </split:text>
        
        <xsl:call-template name="split-text">
          <xsl:with-param name="text">
            <xsl:value-of select="substring-after($text, $split)"/>
          </xsl:with-param>
          <xsl:with-param name="split" select="$split"/>  
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <split:text>
          <xsl:value-of select="$text"/>
        </split:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
