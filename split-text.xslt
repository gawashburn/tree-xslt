<!--
split-text.xslt $Id: split-text.xslt 3 2005-10-16 23:44:42Z geoffw $
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
