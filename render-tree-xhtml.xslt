<?xml version="1.0"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:saxon="http://icl.com/saxon" 
  extension-element-prefixes="saxon"
  xmlns:tree="http://types.bu.edu/XSL/Transform/Tree"
  version="1.1">
  <xsl:output method="saxon:xhtml" />

  <xsl:include href="render-tree-lib.xslt"/>

  <xsl:template match="/">
    <html>
      <body>
        <xsl:call-template name="render-tree-xhtml">
          <xsl:with-param name="tree" select="."/>
          <xsl:with-param name="options">
            <tree:options />
          </xsl:with-param>
        </xsl:call-template>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
