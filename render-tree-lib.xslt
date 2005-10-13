<?xml version="1.0"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:tree="http://types.bu.edu/XSL/Transform/Tree"
  version="1.1">

<!-- ##################################################################### -->

<!-- Some shared variables -->

  <xsl:variable name="newline"><xsl:text>
</xsl:text></xsl:variable>

<!-- ##################################################################### -->  
<!--
  Tree renderers operate on a trees of the following form:

  tree child ::= tree |
                 <tree:leaf>
                   <tree:content>(* target appropriate content *)</tree:content>
                 </tree:leaf>

  tree ::= <tree:node>
             <tree:content>(* target appropriate content *)</tree:content>
             (* zero or more tree children *)
           </tree:node>

  Nodes need not have children, but if they do not it helps the renderer if
  you specify that node as a leaf instead.  Future versions will probably
  just be smarter.  In addition to taking a tree, renderers also consume an
  options element, which looks something like the following, with some
  subset of the children shown here:

  <tree:options>
    (* LaTeX options *)
    <tree:latex-root-nodesep>(* TeX size *)</tree:latex-root-nodesep>
    <tree:latex-node-nodesep>(* TeX size *)</tree:latex-node-nodesep>
    
    <tree:latex-root-levelsep>(* TeX size *)</tree:latex-root-levelsep>
    <tree:latex-node-levelsep>(* TeX size *)</tree:latex-node-levelsep>
  
    <tree:latex-root-treesep>(* TeX size *)</tree:latex-root-treesep>
    <tree:latex-node-treesep>(* TeX size *)</tree:latex-node-treesep>

    <tree:latex-root-psnode>(* pst-tree node *)</tree:latex-root-psnode>
    <tree:latex-node-psnode>(* pst-tree node *)</tree:latex-node-psnode>
    <tree:latex-leaf-psnode>(* pst-tree node *)</tree:latex-leaf-psnode>

    <tree:latex-fit>(* loose | tight *)</tree:latex-fit>

    <tree:latex-orientation>
      (* right | left | up | down *)
    </tree:latex-orientation>

    (* ASCII options *)
    <tree:ascii-vertical-character>(* character *)</tree:ascii-vertical-character>    
    <tree:ascii-horizontal-character>(* character *)</tree:ascii-horizontal-character>    
    <tree:ascii-join-character>(* character *)</tree:ascii-join-character>    
    <tree:ascii-initial-space>(* natural number *)</tree:ascii-initial-space>    

    (* XHTML options *)
    <tree:xhtml-child-image>(* url *)</tree:xhtml-child-image>
    <tree:xhtml-no-child-image>(* url *)</tree:xhtml-no-child-image>
    <tree:xhtml-last-child-image>(* url *)</tree:xhtml-last-child-image>

    <tree:xhtml-root-width>(* CSS size *)</tree:xhtml-root-width>
    <tree:xhtml-child-width>(* CSS size *)</tree:xhtml-child-width>
    <tree:xhtml-no-child-width>(* CSS size *)</tree:xhtml-no-child-width>
    <tree:xhtml-last-child-width>(* CSS size *)</tree:xhtml-last-child-width>
                    
  </tree:options>
-->

<!-- ##################################################################### -->  

<!-- LaTeX defaults -->

  <xsl:variable name="latex-root-nodesep-default">
   <xsl:text>6pt</xsl:text>
  </xsl:variable>

  <xsl:variable name="latex-node-nodesep-default">
   <xsl:text>6pt</xsl:text>
  </xsl:variable>

  <xsl:variable name="latex-root-levelsep-default">
   <xsl:text>1cm</xsl:text>
  </xsl:variable>

  <xsl:variable name="latex-node-levelsep-default">
   <xsl:text>1cm</xsl:text>
  </xsl:variable>

  <xsl:variable name="latex-root-treesep-default">
   <xsl:text>0.5cm</xsl:text>
  </xsl:variable>

  <xsl:variable name="latex-node-treesep-default">
   <xsl:text>0.5cm</xsl:text>
  </xsl:variable>

  <xsl:variable name="latex-root-psnode-default">
   <xsl:text>\Tr[ref=lB]</xsl:text>
  </xsl:variable>

  <xsl:variable name="latex-node-psnode-default">
   <xsl:text>\Tr[ref=lB]</xsl:text>
  </xsl:variable>

  <xsl:variable name="latex-leaf-psnode-default">
   <xsl:text>\Tr[ref=lB]</xsl:text>
  </xsl:variable>

  <xsl:variable name="latex-fit-default">
   <xsl:text>loose</xsl:text>
  </xsl:variable>

  <xsl:variable name="latex-orientation-default">
   <xsl:text>right</xsl:text>
  </xsl:variable>

<!-- LaTeX tree renderer -->

  <xsl:template name="render-tree-latex">
    <xsl:param name="tree"/>
    <xsl:param name="options"/>    

    <xsl:variable name="root-settings">
      <xsl:text>[</xsl:text>

      <xsl:text>nodesep=</xsl:text>
      <xsl:choose>
        <xsl:when test="$options/tree:options/tree:latex-root-nodesep">
          <xsl:copy-of 
            select="$options/tree:options/tree:latex-root-nodesep/node()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$latex-root-nodesep-default" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>,</xsl:text>

      <xsl:text>levelsep=</xsl:text>
      <xsl:choose>
        <xsl:when test="$options/tree:options/tree:latex-root-levelsep">
          <xsl:copy-of 
            select="$options/tree:options/tree:latex-root-levelsep/node()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$latex-root-levelsep-default" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>,</xsl:text>

      <xsl:text>treesep=</xsl:text>
      <xsl:choose>
        <xsl:when test="$options/tree:options/tree:latex-root-treesep">
          <xsl:copy-of 
            select="$options/tree:options/tree:latex-root-treesep/node()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$latex-root-treesep-default" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>,</xsl:text>

      <xsl:text>treemode=</xsl:text>
      <xsl:choose>
        <xsl:when test="$options/tree:options/tree:latex-orientation">
          <xsl:choose>
            <xsl:when test="$options/tree:options/tree:latex-orientation/node()='right'">
              <xsl:text>R</xsl:text>
            </xsl:when>
            <xsl:when test="$options/tree:options/tree:latex-orientation/node()='left'">
              <xsl:text>L</xsl:text>
            </xsl:when>
            <xsl:when test="$options/tree:options/tree:latex-orientation/node()='up'">
              <xsl:text>U</xsl:text>
            </xsl:when>
            <xsl:when test="$options/tree:options/tree:latex-orientation/node()='down'">
              <xsl:text>D</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$latex-orientation-default='right'">
              <xsl:text>R</xsl:text>
            </xsl:when>
            <xsl:when test="$latex-orientation-default='left'">
              <xsl:text>L</xsl:text>
            </xsl:when>
            <xsl:when test="$latex-orientation-default='up'">
              <xsl:text>U</xsl:text>
            </xsl:when>
            <xsl:when test="$latex-orientation-default='down'">
              <xsl:text>D</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>,</xsl:text>

      <xsl:text>treefit=</xsl:text>
      <xsl:choose>
        <xsl:when test="$options/tree:options/tree:latex-fit">
          <xsl:choose>
            <xsl:when test="$options/tree:options/tree:latex-fit/node()='tight'">
              <xsl:text>tight</xsl:text>
            </xsl:when>
            <xsl:when test="$options/tree:options/tree:latex-fit/node()='loose'">
              <xsl:text>loose</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$latex-fit-default='tight'">
              <xsl:text>tight</xsl:text>
            </xsl:when>
            <xsl:when test="$latex-fit-default='loose'">
              <xsl:text>loose</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>]</xsl:text>
    </xsl:variable>

    <xsl:variable name="node-settings">
      <xsl:text>[</xsl:text>

      <xsl:text>nodesep=</xsl:text>
      <xsl:choose>
        <xsl:when test="$options/tree:options/tree:latex-node-nodesep">
          <xsl:copy-of 
            select="$options/tree:options/tree:latex-node-nodesep/node()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$latex-node-nodesep-default" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>,</xsl:text>

      <xsl:text>levelsep=</xsl:text>
      <xsl:choose>
        <xsl:when test="$options/tree:options/tree:latex-node-levelsep">
          <xsl:copy-of 
            select="$options/tree:options/tree:latex-node-levelsep/node()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$latex-node-levelsep-default" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>,</xsl:text>

      <xsl:text>treesep=</xsl:text>
      <xsl:choose>
        <xsl:when test="$options/tree:options/tree:latex-node-treesep">
          <xsl:copy-of 
            select="$options/tree:options/tree:latex-node-treesep/node()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$latex-node-treesep-default" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>]</xsl:text>
    </xsl:variable>

    <xsl:variable name="root-psnode">
      <xsl:choose>
        <xsl:when test="$options/tree:options/tree:latex-root-psnode">
          <xsl:copy-of 
            select="$options/tree:options/tree:latex-root-psnode/node()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$latex-root-psnode-default" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="node-psnode">
      <xsl:choose>
        <xsl:when test="$options/tree:options/tree:latex-node-psnode">
          <xsl:copy-of 
            select="$options/tree:options/tree:latex-node-psnode/node()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$latex-node-psnode-default" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="leaf-psnode">
      <xsl:choose>
        <xsl:when test="$options/tree:options/tree:latex-leaf-psnode">
          <xsl:copy-of 
            select="$options/tree:options/tree:latex-leaf-psnode/node()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$latex-leaf-psnode-default" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:text>\pstree</xsl:text>
    <xsl:copy-of select="$root-settings" /><xsl:text>{</xsl:text>
    <xsl:copy-of select="$root-psnode" />
    <xsl:text>{</xsl:text>    
    <xsl:copy-of select="$tree/tree:node[1]/tree:content" />
    <xsl:text>}}{</xsl:text>
    <xsl:copy-of select="$newline" />
    
    <xsl:for-each select="$tree/tree:node/tree:leaf|$tree/tree:node/tree:node">
      <xsl:choose>
        <xsl:when test="name(.)='tree:leaf'">
          <xsl:copy-of select="$leaf-psnode" />
          <xsl:text>{</xsl:text>    
          <xsl:copy-of select="tree:content" />
          <xsl:text>}</xsl:text>
          <xsl:copy-of select="$newline" />
        </xsl:when>
        <xsl:when test="name(.)='tree:node'">
          <xsl:call-template name="render-tree-nonroot-latex">
            <xsl:with-param name="tree" select="."/>  
            <xsl:with-param name="root-settings" select="$root-settings"/> 
            <xsl:with-param name="node-settings" select="$node-settings"/> 
            <xsl:with-param name="root-psnode" select="$root-psnode"/> 
            <xsl:with-param name="node-psnode" select="$node-psnode"/> 
            <xsl:with-param name="leaf-psnode" select="$leaf-psnode"/> 
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:text>}</xsl:text>
  </xsl:template>

<!-- LaTeX tree renderer helper function -->

  <xsl:template name="render-tree-nonroot-latex">
    <xsl:param name="tree"/>

    <xsl:param name="root-settings" />
    <xsl:param name="node-settings" />
    <xsl:param name="root-psnode" />
    <xsl:param name="node-psnode" />
    <xsl:param name="leaf-psnode" />

    <xsl:text>\pstree</xsl:text><xsl:copy-of select="$node-settings" />
    <xsl:text>{</xsl:text><xsl:copy-of select="$node-psnode" />
    <xsl:text>{</xsl:text>    
    <xsl:copy-of select="tree:content" />
    <xsl:text>}}{</xsl:text>
    <xsl:copy-of select="$newline" />

    <xsl:for-each select="$tree/tree:node|$tree/tree:leaf">
      <xsl:choose>
        <xsl:when test="name(.)='tree:leaf'">
          <xsl:copy-of select="$leaf-psnode" />
          <xsl:text>{</xsl:text>    
          <xsl:copy-of select="tree:content" />
          <xsl:text>}</xsl:text>
          <xsl:copy-of select="$newline" />
        </xsl:when>
        <xsl:when test="name(.)='tree:node'">
          <xsl:call-template name="render-tree-nonroot-latex">
            <xsl:with-param name="tree" select="."/>          
            <xsl:with-param name="root-settings" select="$root-settings"/> 
            <xsl:with-param name="node-settings" select="$node-settings"/> 
            <xsl:with-param name="root-psnode" select="$root-psnode"/> 
            <xsl:with-param name="node-psnode" select="$node-psnode"/> 
            <xsl:with-param name="leaf-psnode" select="$leaf-psnode"/> 
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:text>}</xsl:text>
    <xsl:copy-of select="$newline" />
  </xsl:template>

<!-- ##################################################################### -->  

<!-- ASCII defaults -->

  <xsl:variable name="ascii-vertical-character-default">
    <xsl:text>|</xsl:text>
  </xsl:variable>

  <xsl:variable name="ascii-horizontal-character-default">
    <xsl:text>-</xsl:text>
  </xsl:variable>

  <xsl:variable name="ascii-join-character-default">
    <xsl:text>+</xsl:text>
  </xsl:variable>

  <xsl:variable name="ascii-initial-space-default">
    <xsl:text>0</xsl:text>
  </xsl:variable>


<!-- "Function" to generate a string of spaces the specified length -->

  <xsl:template name="generate-space"> 
    <!-- Length of the resultant string -->
    <xsl:param name="length"/>  
    <xsl:choose>
      <xsl:when test="$length=0">
        <xsl:text></xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="recursive-call">
          <xsl:call-template name="generate-space">
            <xsl:with-param name="length" select="$length - 1"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:copy-of select="concat($recursive-call,' ')" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


<!-- ASCII tree renderer -->

  <xsl:template name="render-tree-ascii">
    <xsl:param name="tree"/>
    <xsl:param name="options"/>

    <xsl:variable name="ascii-initial-space">
      <xsl:call-template name="generate-space">
        <xsl:with-param name="length" >
          <xsl:choose>
            <xsl:when test="$options/tree:options/tree:ascii-initial-space">
              <xsl:copy-of 
                select="$options/tree:options/tree:ascii-initial-space/node()" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="$ascii-initial-space-default" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="ascii-vertical-chunk">
      <xsl:choose>
        <xsl:when test="$options/tree:options/tree:ascii-vertical-character">
          <xsl:copy-of 
            select="$options/tree:options/tree:ascii-vertical-character/node()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$ascii-vertical-character-default" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
    </xsl:variable>

    <xsl:variable name="ascii-horizontal-chunk">
      <xsl:choose>
        <xsl:when test="$options/tree:options/tree:ascii-join-character">
          <xsl:copy-of 
            select="$options/tree:options/tree:ascii-join-character/node()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$ascii-join-character-default" />
        </xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="$options/tree:options/tree:ascii-horizontal-character">
          <xsl:copy-of 
            select="$options/tree:options/tree:ascii-horizontal-character/node()" />
          <xsl:copy-of 
            select="$options/tree:options/tree:ascii-horizontal-character/node()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$ascii-horizontal-character-default" />
          <xsl:copy-of select="$ascii-horizontal-character-default" />
        </xsl:otherwise>
      </xsl:choose>

      <xsl:text> </xsl:text>
    </xsl:variable>

    <xsl:variable name="ascii-vertical-space">
      <xsl:text>  </xsl:text>
    </xsl:variable>

    <xsl:copy-of select="$ascii-initial-space" />
    <xsl:copy-of select="$tree/tree:node[1]/tree:content" />
    <xsl:copy-of select="$newline" />
    <xsl:variable name="newprefix" select="concat(concat($ascii-initial-space,$ascii-vertical-chunk),$ascii-vertical-space)" />
    <xsl:copy-of select="$newprefix"/>
    <xsl:copy-of select="$newline" />

    <xsl:for-each select="$tree/tree:node/tree:leaf|$tree/tree:node/tree:node">
      <xsl:choose>       
        <xsl:when test="name(.)='tree:leaf'">        
          <xsl:copy-of select="$ascii-initial-space" />
          <xsl:copy-of select="$ascii-horizontal-chunk" />
          <xsl:copy-of select="tree:content" />
          <xsl:copy-of select="$newline" />
        </xsl:when>
        <xsl:when test="name(.)='tree:node'">
          <xsl:choose>
            <xsl:when test="position()=last()">
              <xsl:call-template name="render-tree-nonroot-ascii">
                <xsl:with-param name="tree" select="."/>          
                <xsl:with-param name="first" select="concat($ascii-initial-space,$ascii-horizontal-chunk)"/>
                <xsl:with-param name="remainder"
                  select="concat(concat($ascii-initial-space,$ascii-vertical-space),$ascii-vertical-space)"/>
                <xsl:with-param name="ascii-vertical-chunk" select="$ascii-vertical-chunk"/>
                <xsl:with-param name="ascii-vertical-space" select="$ascii-vertical-space"/>
                <xsl:with-param name="ascii-horizontal-chunk" select="$ascii-horizontal-chunk"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="render-tree-nonroot-ascii">
                <xsl:with-param name="tree" select="."/>
                <xsl:with-param name="first" select="concat($ascii-initial-space,$ascii-horizontal-chunk)"/>
                <xsl:with-param name="remainder" select="$newprefix"/>
                <xsl:with-param name="ascii-vertical-chunk" select="$ascii-vertical-chunk"/>
                <xsl:with-param name="ascii-vertical-space" select="$ascii-vertical-space"/>
                <xsl:with-param name="ascii-horizontal-chunk" select="$ascii-horizontal-chunk"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
      <xsl:if test="not(position()=last())">
        <xsl:value-of select="$newprefix" />
        <xsl:copy-of select="$newline" />
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

<!-- ASCII tree renderer helper function -->
  
  <xsl:template name="render-tree-nonroot-ascii">
    <xsl:param name="tree"/>
    <xsl:param name="first"/>
    <xsl:param name="remainder"/>

    <xsl:param name="ascii-vertical-chunk"/>
    <xsl:param name="ascii-vertical-space"/>
    <xsl:param name="ascii-horizontal-chunk"/>

    <xsl:copy-of select="$first" />
    <xsl:copy-of select="$tree/tree:content" />
    <xsl:copy-of select="$newline" />

    <xsl:variable name="newprefix" select="concat(concat($remainder,$ascii-vertical-chunk),$ascii-vertical-space)" />
    <xsl:copy-of select="$newprefix"/>
    <xsl:copy-of select="$newline" />

    <xsl:for-each select="$tree/tree:node|$tree/tree:leaf">
      <xsl:choose>
        <xsl:when test="name(.)='tree:leaf'">
          <xsl:copy-of select="concat($remainder, $ascii-horizontal-chunk)" />
          <xsl:copy-of select="tree:content" />
          <xsl:copy-of select="$newline" />         
        </xsl:when>
        <xsl:when test="name(.)='tree:node'">
          <xsl:choose>
            <xsl:when test="position()=last()">
              <xsl:call-template name="render-tree-nonroot-ascii">
                <xsl:with-param name="tree" select="."/>          
                <xsl:with-param name="first" select="concat($remainder,$ascii-horizontal-chunk)"/>
                <xsl:with-param name="remainder"
                  select="concat(concat($remainder,$ascii-vertical-space),$ascii-vertical-space)"/>
                <xsl:with-param name="ascii-vertical-chunk" select="$ascii-vertical-chunk"/>
                <xsl:with-param name="ascii-vertical-space" select="$ascii-vertical-space"/>
                <xsl:with-param name="ascii-horizontal-chunk" select="$ascii-horizontal-chunk"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="render-tree-nonroot-ascii">
                <xsl:with-param name="tree" select="."/>    
                <xsl:with-param name="first" select="concat($remainder,$ascii-horizontal-chunk)"/>      
                <xsl:with-param name="remainder" select="$newprefix"/>
                <xsl:with-param name="ascii-vertical-chunk" select="$ascii-vertical-chunk"/>
                <xsl:with-param name="ascii-vertical-space" select="$ascii-vertical-space"/>
                <xsl:with-param name="ascii-horizontal-chunk" select="$ascii-horizontal-chunk"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
      <xsl:if test="not(position()=last())">
        <xsl:copy-of select="$newprefix"/>
        <xsl:copy-of select="$newline" />         
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

<!-- ##################################################################### -->  

<!-- XHTML defaults -->

  <xsl:variable name="xhtml-child-image-default">
    <xsl:text>child.png</xsl:text>
  </xsl:variable>

  <xsl:variable name="xhtml-no-child-image-default">
    <xsl:text>no-child.png</xsl:text>
  </xsl:variable>

  <xsl:variable name="xhtml-last-child-image-default">
    <xsl:text>last-child.png</xsl:text>
  </xsl:variable>

  <xsl:variable name="xhtml-root-width-default">
    <xsl:text>40px</xsl:text>
  </xsl:variable>

  <xsl:variable name="xhtml-child-width-default">
    <xsl:text>40px</xsl:text>
  </xsl:variable>

  <xsl:variable name="xhtml-no-child-width-default">
    <xsl:text>40px</xsl:text>
  </xsl:variable>

  <xsl:variable name="xhtml-last-child-width-default">
    <xsl:text>40px</xsl:text>
  </xsl:variable>

<!-- XHTML tree renderer -->

  <xsl:template name="render-tree-xhtml">
    <xsl:param name="tree"/>
    <xsl:param name="options"/>

    <xsl:variable name="xhtml-root-style">
      <xsl:text>margin: 0; padding: 0 0 0 </xsl:text>
      <xsl:choose>
        <xsl:when test="$options/tree:options/tree:xhtml-root-width">
          <xsl:copy-of 
            select="$options/tree:options/tree:xhtml-root-width/node()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$xhtml-root-width-default" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>;</xsl:text>
    </xsl:variable>

    <xsl:variable name="xhtml-child-style">
      <xsl:text>margin: 0; padding: 0 0 0 </xsl:text>
      <xsl:choose>
        <xsl:when test="$options/tree:options/tree:xhtml-child-width">
          <xsl:copy-of 
            select="$options/tree:options/tree:xhtml-child-width/node()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$xhtml-child-width-default" />           
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>; background-image: url(</xsl:text>
      <xsl:choose>
        <xsl:when test="$options/tree:options/tree:xhtml-child-image">
          <xsl:copy-of 
            select="$options/tree:options/tree:xhtml-child-image/node()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$xhtml-child-image-default" />           
        </xsl:otherwise>
      </xsl:choose>                    
      <xsl:text>); background-repeat: no-repeat;</xsl:text>
    </xsl:variable>

    <xsl:variable name="xhtml-last-child-style">
      <xsl:text>margin: 0; padding: 0 0 0 </xsl:text>
      <xsl:choose>
        <xsl:when test="$options/tree:options/tree:xhtml-last-child-width">
          <xsl:copy-of 
            select="$options/tree:options/tree:xhtml-last-child-width/node()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$xhtml-last-child-width-default" />           
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>; background-image: url(</xsl:text>
      <xsl:choose>
        <xsl:when test="$options/tree:options/tree:xhtml-last-child-image">
          <xsl:copy-of 
            select="$options/tree:options/tree:xhtml-last-child-image/node()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$xhtml-last-child-image-default" />           
        </xsl:otherwise>
      </xsl:choose>                    
      <xsl:text>); background-repeat: no-repeat;</xsl:text>
    </xsl:variable>

    <xsl:variable name="xhtml-no-child-style">
      <xsl:text>margin: 0; padding: 0 0 0 </xsl:text>
      <xsl:choose>
        <xsl:when test="$options/tree:options/tree:xhtml-no-child-width">
          <xsl:copy-of 
            select="$options/tree:options/tree:xhtml-no-child-width/node()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$xhtml-no-child-width-default" />           
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>; background-image: url(</xsl:text>
      <xsl:choose>
        <xsl:when test="$options/tree:options/tree:xhtml-no-child-image">
          <xsl:copy-of 
            select="$options/tree:options/tree:xhtml-no-child-image/node()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$xhtml-no-child-image-default" />           
        </xsl:otherwise>
      </xsl:choose>                    
      <xsl:text>); background-repeat: repeat-y;</xsl:text>
    </xsl:variable>

    <div>
      <xsl:attribute name="style">
        <xsl:copy-of select="$xhtml-root-style" />        
      </xsl:attribute>

      <xsl:copy-of select="$tree/tree:node[1]/tree:content/node()" />

      <xsl:for-each select="$tree/tree:node/tree:leaf|$tree/tree:node/tree:node">
        <xsl:choose>       
          <xsl:when test="name(.)='tree:leaf'">        
            <div>
              <xsl:attribute name="style">
                <xsl:choose>
                  <xsl:when test="position()=last()">
                    <xsl:copy-of select="$xhtml-last-child-style" />        
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:copy-of select="$xhtml-child-style" />        
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>            
              <xsl:copy-of select="tree:content/node()" />
            </div>
            <xsl:copy-of select="$newline" />
          </xsl:when>
          <xsl:when test="name(.)='tree:node'">
            <xsl:call-template name="render-tree-nonroot-xhtml">
              <xsl:with-param name="tree" select="."/>          
              <xsl:with-param name="options" select="$options"/>          
              <xsl:with-param name="xhtml-root-style" select="$xhtml-root-style"/>
              <xsl:with-param name="xhtml-child-style" select="$xhtml-child-style"/>
              <xsl:with-param name="xhtml-last-child-style" select="$xhtml-last-child-style"/>
              <xsl:with-param name="xhtml-no-child-style" select="$xhtml-no-child-style"/>
            </xsl:call-template>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </div>
    <xsl:copy-of select="$newline" />
  </xsl:template>

<!-- XHTML tree renderer helper function -->

  <xsl:template name="render-tree-nonroot-xhtml">
    <xsl:param name="tree"/>
    <xsl:param name="options"/>
    <xsl:param name="xhtml-root-style"/>
    <xsl:param name="xhtml-child-style"/>
    <xsl:param name="xhtml-last-child-style"/>
    <xsl:param name="xhtml-no-child-style"/>

    <div>
      <xsl:attribute name="style">
        <xsl:choose>
          <xsl:when test="position()=last()">
            <xsl:copy-of select="$xhtml-last-child-style"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$xhtml-child-style"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:copy-of select="$tree/tree:content/node()" />
    </div>
    <xsl:copy-of select="$newline" />
    <div>
      <xsl:attribute name="style">
        <xsl:choose>
          <xsl:when test="position()=last()">
            <xsl:copy-of select="$xhtml-root-style"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$xhtml-no-child-style"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <xsl:for-each select="$tree/tree:node|$tree/tree:leaf">
        <xsl:choose>
          <xsl:when test="name(.)='tree:leaf'">
            <div>
              <xsl:attribute name="style">
                <xsl:choose>
                  <xsl:when test="position()=last()">
                    <xsl:copy-of select="$xhtml-last-child-style"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:copy-of select="$xhtml-child-style"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>            
              <xsl:copy-of select="tree:content/node()" />
            </div>
          </xsl:when>
          <xsl:when test="name(.)='tree:node'">
            <xsl:call-template name="render-tree-nonroot-xhtml">
              <xsl:with-param name="tree" select="."/>
              <xsl:with-param name="options" select="$options"/>          
              <xsl:with-param name="xhtml-root-style" select="$xhtml-root-style"/>
              <xsl:with-param name="xhtml-child-style" select="$xhtml-child-style"/>
              <xsl:with-param name="xhtml-last-child-style" select="$xhtml-last-child-style"/>
              <xsl:with-param name="xhtml-no-child-style" select="$xhtml-no-child-style"/>
            </xsl:call-template>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </div>
    <xsl:copy-of select="$newline" />
  </xsl:template>

</xsl:stylesheet>
