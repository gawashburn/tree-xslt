<!--
render-tree-xhtml.xslt $Id: render-tree-xhtml.xslt 3 2005-10-16 23:44:42Z geoffw $
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
