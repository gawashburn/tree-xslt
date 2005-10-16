<!--
search-and-replace.xslt $Id: search-and-replace.xslt 3 2005-10-16 23:44:42Z geoffw $
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
