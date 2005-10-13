<?xml version="1.0"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tree="http://types.bu.edu/XSL/Transform/Tree"
  xmlns:split="http://types.bu.edu/XSL/Transform/Split"
  version="1.1">
  <xsl:output method="text" />

  <xsl:param name="omit-empty-text">0</xsl:param>
  <xsl:param name="multi-node-text">0</xsl:param>
  <xsl:param name="visible-whitespace">0</xsl:param>

  <xsl:include href="split-text.xslt"/>
  <xsl:include href="latexify.xslt"/>
  <xsl:include href="render-tree-lib.xslt"/>

  <xsl:template match="/">
    <xsl:text>
\documentclass{article}      
\usepackage{pst-tree}
\begin{document}
    </xsl:text>
    <xsl:call-template name="render-tree-latex">
      <xsl:with-param name="tree">
        <xsl:apply-templates select="*" mode="treeroot"/>
      </xsl:with-param>
      <xsl:with-param name="options">
        <tree:options />
      </xsl:with-param>
    </xsl:call-template>
    <xsl:text>
\end{document}
    </xsl:text>
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
      <xsl:call-template name="render-text">
        <xsl:with-param name="text" select="." />
      </xsl:call-template>
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
              <xsl:call-template name="render-text">
                <xsl:with-param name="text" select="." />
              </xsl:call-template>
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
            <xsl:call-template name="render-text">
              <xsl:with-param name="text" select="." />
            </xsl:call-template>
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
            <xsl:call-template name="render-text">
              <xsl:with-param name="text" select="." />
            </xsl:call-template>
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

  <xsl:template name="render-text">
    <xsl:param name="text" />
      <xsl:choose>
        <xsl:when test="$visible-whitespace=1">
        <xsl:call-template name="latexify-visible-whitespace">
          <xsl:with-param name="text">
            <xsl:value-of select="$text"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="latexify">
          <xsl:with-param name="text">
            <xsl:value-of select="normalize-space($text)"/>
          </xsl:with-param>
        </xsl:call-template>        
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
            <xsl:call-template name="render-text">
              <xsl:with-param name="text" select="." />
            </xsl:call-template>
            <xsl:text>"</xsl:text>
          </tree:content>
        </tree:leaf>
      </xsl:if>      
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>