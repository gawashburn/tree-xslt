<?xml version="1.0"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:tree="http://types.bu.edu/XSL/Transform/Tree"
  version="1.1">
  <xsl:output method="text" />

  <xsl:include href="render-tree-lib.xslt"/>

  <xsl:template match="/">
    <xsl:text>
\documentclass{article}      
\usepackage{pst-tree}
\begin{document}
</xsl:text>
    <xsl:call-template name="render-tree-latex">
      <xsl:with-param name="tree" select="."/>
      <xsl:with-param name="options">
        <tree:options />
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
<xsl:text>
\end{document}
</xsl:text>
</xsl:stylesheet>
