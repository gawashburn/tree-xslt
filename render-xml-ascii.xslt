<!--
render-xml-ascii.xslt $Id: render-xml-ascii.xslt 3 2005-10-16 23:44:42Z geoffw $
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
  xmlns:split="http://types.bu.edu/XSL/Transform/Split"
  version="1.1">
  <xsl:output method="text" />

  <xsl:param name="omit-empty-text">0</xsl:param>
  <xsl:param name="multi-node-text">0</xsl:param>

  <xsl:include href="render-tree-lib.xslt"/>
  <xsl:include href="split-text.xslt"/>

  <xsl:template match="/">
    <xsl:call-template name="render-tree-ascii">
      <xsl:with-param name="tree">
        <xsl:apply-templates select="*" mode="treeroot"/>
      </xsl:with-param>
      <xsl:with-param name="options">
        <tree:options />
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="tree">
    <xsl:apply-templates select="*" mode="treeroot"/>
  </xsl:template>
  
 <xsl:template match="*" mode="treeroot">
    <tree:node>
      <tree:content><xsl:value-of select="name()"/></tree:content>
      <xsl:apply-templates select="node()" mode="tree"/>
    </tree:node>
 </xsl:template>

  <xsl:template match="*" mode="tree">
    <xsl:choose>
    <xsl:when test="count(*|text()|comment()|processing-instruction())=0">
        <tree:leaf>
          <tree:content><xsl:apply-templates select="."
              mode="treenode"/></tree:content>
        </tree:leaf>
      </xsl:when>
      <xsl:otherwise>
        <tree:node>
          <tree:content><xsl:apply-templates select="."
              mode="treenode"/></tree:content>
          <xsl:apply-templates select="node()" mode="tree"/>
        </tree:node>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="*" mode="treenode">
  <!-- <xsl:text>ELEMENT: </xsl:text> -->
    <xsl:value-of select="name()"/>
    <xsl:for-each select="attribute::*">
      <xsl:choose>
        <xsl:when test="position()=1">
          <xsl:text> (</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="name()"/>
      <xsl:text>="</xsl:text>
      <xsl:value-of select="normalize-space(.)"/>
      <xsl:text>"</xsl:text>
      <xsl:if test="position()=last()">
        <xsl:text>)</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="text()" mode="tree">
    <xsl:variable name="text">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:variable>
    <xsl:if test="not(($text='') and ($omit-empty-text=1))">
      <xsl:choose>
        <xsl:when test="$multi-node-text!=1">
          <tree:leaf>         
            <tree:content>    
              <xsl:text>"</xsl:text>
              <xsl:value-of select="$text" />
              <xsl:text>"</xsl:text>
            </tree:content>
          </tree:leaf>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="convert-splits">
            <xsl:with-param name="splits">
              <xsl:call-template name="split-text">
                <xsl:with-param name="text">
                  <xsl:value-of select="." />
                </xsl:with-param>
                <xsl:with-param name="split" select="'&#x0A;'" />
              </xsl:call-template>          
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="comment()" mode="tree">
    <xsl:choose>
      <xsl:when test="$multi-node-text!=1">
        <tree:leaf>         
          <tree:content>    
            <xsl:text>COMMENT: "</xsl:text>
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:text>"</xsl:text>
          </tree:content>
        </tree:leaf>
      </xsl:when>
      <xsl:otherwise>
        <tree:node>         
          <tree:content>    
            <xsl:text>COMMENT:</xsl:text>
          </tree:content>
          <xsl:call-template name="convert-splits">
            <xsl:with-param name="splits">
              <xsl:call-template name="split-text">
                <xsl:with-param name="text">
                  <xsl:value-of select="." />
                </xsl:with-param>
                <xsl:with-param name="split" select="'&#x0A;'" />
              </xsl:call-template>          
            </xsl:with-param>
          </xsl:call-template>
        </tree:node>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="processing-instruction()" mode="tree">
     <xsl:choose>
      <xsl:when test="$multi-node-text!=1">
        <tree:leaf>         
          <tree:content>    
            <xsl:text>PI: "</xsl:text>
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:text>"</xsl:text>
          </tree:content>
        </tree:leaf>
      </xsl:when>
      <xsl:otherwise>
        <tree:node>         
          <tree:content>    
            <xsl:text>PI:</xsl:text>
          </tree:content>
          <xsl:call-template name="convert-splits">
            <xsl:with-param name="splits">
              <xsl:call-template name="split-text">
                <xsl:with-param name="text">
                  <xsl:value-of select="." />
                </xsl:with-param>
                <xsl:with-param name="split" select="'&#x0A;'" />
              </xsl:call-template>          
            </xsl:with-param>
          </xsl:call-template>
        </tree:node>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="convert-splits">
    <xsl:param name="splits" /> 
    <xsl:for-each select="$splits/split:text"> 
      <xsl:if test="not((string(.)='') and ($omit-empty-text=1))">
        <tree:leaf>
          <tree:content>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>"</xsl:text>
          </tree:content>
        </tree:leaf>
      </xsl:if>      
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
