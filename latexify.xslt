<?xml version="1.0"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:tree="http://types.bu.edu/XSL/Transform/Tree"
  version="1.0">

  <xsl:include href="search-and-replace.xslt"/>

  <xsl:template name="latexify">
    <xsl:param name="text" />
    
    <xsl:call-template name="search-and-replace">
      <xsl:with-param name="text">
        <xsl:call-template name="search-and-replace">
          <xsl:with-param name="text">
            <xsl:call-template name="search-and-replace">
              <xsl:with-param name="text">
                <xsl:call-template name="search-and-replace">
                  <xsl:with-param name="text" select="$text" />
                  <xsl:with-param name="search" select="'&amp;'" />
                  <xsl:with-param name="replace" select="'\&amp;'" />
                </xsl:call-template>    
              </xsl:with-param>
              <xsl:with-param name="search" select="'%'" />
              <xsl:with-param name="replace" select="'\%'" />        
            </xsl:call-template>    
          </xsl:with-param>
          <xsl:with-param name="search" select="'_'" />
          <xsl:with-param name="replace" select="'\_'" />        
        </xsl:call-template>        
        </xsl:with-param>
      <xsl:with-param name="search" select="'#'" />
      <xsl:with-param name="replace" select="'\#'" />        
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="latexify-visible-whitespace">
    <xsl:param name="text" />
    <xsl:call-template name="search-and-replace">
      <xsl:with-param name="text">
        <xsl:call-template name="search-and-replace">
          <xsl:with-param name="text">
            <xsl:call-template name="search-and-replace">
              <xsl:with-param name="text">
                <xsl:call-template name="latexify">
                  <xsl:with-param name="text" select="$text" />
                </xsl:call-template>
              </xsl:with-param>
              <xsl:with-param name="search" select="'&#x20;'" />
              <xsl:with-param name="replace" select="'\textvisiblespace'" />
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="search" select="'&#x09;'" />
          <xsl:with-param name="replace" select="'&#x24;\triangleright&#x24;'" />
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="search" select="'&#x0a;'" />
      <xsl:with-param name="replace" select="'&#x24;\downarrow&#x24;'" />
    </xsl:call-template>    
  </xsl:template>

</xsl:stylesheet>
