<!--
latexify.xslt $Id: latexify.xslt 3 2005-10-16 23:44:42Z geoffw $
Copyright Geoffrey Alan Washburn, 2005.
Some parts copyright Trustees of Boston University, 2002.
Some parts copyright Joe B Wells, 2002.

You can redistribute and/or modify this software under the terms of
the GNU General Public License as published by the Free Software
Foundation; either version 2, or (at your option) any later version.

This software is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You may obtain the GNU General Public License by writing to the Free
Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
02111-1307, USA.
-->

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
