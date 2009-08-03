<xsl:stylesheet version = '1.0'
    xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
    xmlns:bgf="http://planet-sl.org/bgf"
    xmlns:ldf="http://planet-sl.org/ldf"
    xmlns:mml="http://www.w3.org/1998/Math/MathML"
    xmlns:xhtml="http://www.w3.org/1999/xhtml">

  <xsl:import href="bgf2xhtml.xslt" />
  <xsl:import href="mathml2xhtml.xslt" />

  <xsl:output
      method="html"
      encoding="UTF-8"
      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    />

  <xsl:preserve-space elements="sample"/>
  <xsl:preserve-space elements="runnable"/>



  <xsl:template match="/ldf:document">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
      <head>
        <title>
          <xsl:value-of select="titlePage/topic"/> - generated by LDF2XHTML
        </title>
        <style type="text/css">
          h1, table { text-align: center; }
          .label, .sel { color: green; }
          .marked { background-color: #FFE5B4;}
          .nt { color: blue; font-weight: bold; }
          .cmd { color: teal; font-weight: bold; }
          .t { color: red;  font-style:italic; }
          .meta { font-style:italic; font-family: Roman, "Times New Roman", serif; }
          h6 { text-align: right; }
          .date { font-size: small; }

          .note
          {
          text-align: right;
          font-weight: bold;
          margin: 0px;
          }
          .frame, pre
          {
          border: 1px solid black;
          border-spacing: 2px;
          border-collapse: collapse;
          background-color: #ECECEC;
          }

        </style>
      </head>
      <body>
        <!-- title -->
        <h1>
          <xsl:value-of select="titlePage/topic"/>
          <!-- version or edition -->
          <xsl:if test="titlePage/version">
            <xsl:text> v.</xsl:text>
            <xsl:value-of select="titlePage/version"/>
          </xsl:if>
          <xsl:if test="titlePage/edition">
            <xsl:text> </xsl:text>
            <xsl:value-of select="titlePage/edition"/>
            <xsl:text>ed</xsl:text>
          </xsl:if>
        <!-- status -->
          <xsl:if test="titlePage/status != 'unknown'">
            <br/>
            <xsl:value-of select="titlePage/status"/>
          </xsl:if>
          <!-- date -->
          <br/>
          <span class="date">
          <xsl:value-of select="titlePage/date"/></span></h1>
        <!-- titlePage done -->
        <!-- placeholder: not completely implemented 
        <xsl:apply-templates select="placeholder"/>-->
        <!--xsl:text>
		%% START_CONTENT
	  </xsl:text-->
        <!-- frontMatter -->
        <xsl:for-each select="frontMatter/*">
          <xsl:choose>
            <xsl:when test="local-name() = 'placeholder'">
              <xsl:apply-templates select="."/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="sectionize">
                <xsl:with-param name="target" select="."/>
              </xsl:call-template>
              <xsl:call-template name="process-SimpleSection">
                <xsl:with-param name="section" select="."/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <!-- lists -->
        <xsl:for-each select="lists/*">
          <xsl:call-template name="process-ListOfTerms">
            <xsl:with-param name="list" select="."/>
          </xsl:call-template>
        </xsl:for-each>
        <!-- lexicalPart -->
        <xsl:for-each select="lexicalPart/*">
          <xsl:call-template name="sectionize">
            <xsl:with-param name="target" select="."/>
          </xsl:call-template>
          <xsl:call-template name="process-SimpleSection">
            <xsl:with-param name="section" select="."/>
          </xsl:call-template>
        </xsl:for-each>
        <!--<xsl:apply-templates select="core"/>-->
        <xsl:choose>
          <xsl:when test="count(part) = 1">
            <xsl:apply-templates select="part/core"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="part">
              <xsl:call-template name="treatPart">
                <xsl:with-param name="part" select="."/>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:for-each select="backMatter/*">
          <xsl:choose>
            <xsl:when test="local-name() = 'placeholder'">
              <xsl:apply-templates select="."/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="sectionize">
                <xsl:with-param name="target" select="."/>
              </xsl:call-template>
              <xsl:call-template name="process-SimpleSection">
                <xsl:with-param name="section" select="."/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <xsl:apply-templates select="annex"/>
        <hr/>
        <!-- body/number or author -->
        <h6>
          (c)
          <xsl:choose>
            <xsl:when test="titlePage/body">
              <xsl:call-template name="uppercase">
                <xsl:with-param name="string" select="titlePage/body"/>
              </xsl:call-template>
              <xsl:value-of select="titlePage/number"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="titlePage/author"/>
            </xsl:otherwise>
          </xsl:choose>
        </h6>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="list">
    <ul xmlns="http://www.w3.org/1999/xhtml">
      <xsl:for-each select="item">
        <li>
          <xsl:call-template name="process-mixed">
            <xsl:with-param name="content" select="."/>
          </xsl:call-template>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template name="process-ListOfTerms">
    <xsl:param name="list"/>
    <h2 xmlns="http://www.w3.org/1999/xhtml">
      <xsl:choose>
        <xsl:when test="$list/title">
          <xsl:value-of select="$list/title"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>List of </xsl:text>
          <xsl:value-of select="local-name($list)"/>
        </xsl:otherwise>
      </xsl:choose>
    </h2>
    <dl xmlns="http://www.w3.org/1999/xhtml">
      <xsl:for-each select="$list/term">
        <dt>
          <strong>
            <xsl:call-template name="capitaliseString">
              <xsl:with-param name="string" select="name"/>
            </xsl:call-template>
          </strong>
        </dt>
        <dd>
          <xsl:call-template name="process-text">
            <xsl:with-param name="text" select="definition"/>
          </xsl:call-template>
        </dd>
      </xsl:for-each>
    </dl>
  </xsl:template>

  <xsl:template name="process-mixed">
    <xsl:param name="content"/>
    <xsl:for-each select="$content/node()">
      <xsl:choose>
        <xsl:when test="local-name() = 'keyword'">
          <strong xmlns="http://www.w3.org/1999/xhtml">
            <xsl:call-template name="linkIfExists">
              <xsl:with-param name="target" select="text()"/>
            </xsl:call-template>
          </strong>
        </xsl:when>
        <xsl:when test="local-name() = 'link'">
          <strong xmlns="http://www.w3.org/1999/xhtml">
            <a>
              <xsl:attribute name="href">
                <xsl:text>#</xsl:text>
                <xsl:value-of select="reference"/>
              </xsl:attribute>
              <xsl:value-of select="text"/>
            </a>
          </strong>
        </xsl:when>
        <xsl:when test="local-name() = 'formula'">
          <xsl:apply-templates select="mml:math/*"/>
        </xsl:when>
        <!--
              <xsl:when test="namespace-uri() = 'http://planet-sl.org/ldf'">
                <xsl:apply-templates select="."/>
              </xsl:when>-->
        <xsl:otherwise>
          <xsl:copy-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="linkIfExists">
    <xsl:param name="target"/>
    <xsl:choose>
      <xsl:when test="//*[@id = $target]">
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:text>#</xsl:text>
            <xsl:value-of select="$target"/>
          </xsl:attribute>
          <xsl:value-of select="$target"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$target"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="process-text">
    <xsl:param name="text"/>
    <xsl:for-each select="$text/node()">
      <xsl:choose>
        <xsl:when test="local-name() = 'title'"/>
        <xsl:when test="local-name() = 'author'"/>
        <xsl:when test="local-name() = 'empty'"/>
        <xsl:when test="local-name() = 'text'">
          <xsl:call-template name="process-mixed">
            <xsl:with-param name="content" select="."/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="local-name() = 'list'">
          <xsl:apply-templates select="."/>
        </xsl:when>
        <xsl:when test="local-name() = 'formula'">
          <xsl:choose>
            <xsl:when test="local-name($text) != 'cell'">
              <center xmlns="http://www.w3.org/1999/xhtml">
                <xsl:apply-templates select="mml:math/*"/>
              </center>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="mml:math/*"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="local-name() = 'production'">
          <pre xmlns="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates select="."/>
          </pre>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="sectionize">
    <xsl:param name="target"/>
    <h2 xmlns="http://www.w3.org/1999/xhtml">
      <!-- anchor -->
      <a>
        <xsl:attribute name="name">
          <xsl:choose>
            <xsl:when test="@id">
              <xsl:value-of select="@id"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="local-name()"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </a>
      <!-- text -->
      <xsl:choose>
        <xsl:when test="$target/title">
          <xsl:value-of select="$target/title"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <!-- can be replaced with a unified CamelCase2Whitespace -->
            <xsl:when test="local-name() = 'lineContinuations'">
              <xsl:text>Line continuations</xsl:text>
            </xsl:when>
            <xsl:when test="local-name() = 'designGoals'">
              <xsl:text>Design goals</xsl:text>
            </xsl:when>
            <xsl:when test="local-name() = 'normativeReferences'">
              <xsl:text>Normative references</xsl:text>
            </xsl:when>
            <xsl:when test="local-name() = 'documentStructure'">
              <xsl:text>Document structure</xsl:text>
            </xsl:when>
            <xsl:when test="local-name() = 'whatsnew'">
              <xsl:text>What's new</xsl:text>
            </xsl:when>
            <xsl:when test="local-name() = 'languageOverview'">
              <xsl:text>Language overview</xsl:text>
            </xsl:when>
            <!-- end of CamelCase2Whitespace -->
            <xsl:otherwise>
              <xsl:call-template name="capitaliseLocalName">
                <xsl:with-param name="section" select="$target"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </h2>
  </xsl:template>

  <xsl:template name="subsectionize">
    <xsl:param name="target"/>
    <xsl:param name="level" select="'h3'"/>
    <xsl:if test="@id">
      <a xmlns="http://www.w3.org/1999/xhtml">
        <xsl:attribute name="name">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
      </a>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$level != ''">
        <xsl:element name="{$level}">
          <xsl:choose>
            <xsl:when test="$target/title">
              <xsl:value-of select="$target/title"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="capitaliseLocalName">
                <xsl:with-param name="section" select="$target"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="h3">
          <xsl:choose>
            <xsl:when test="$target/title">
              <xsl:value-of select="$target/title"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="capitaliseLocalName">
                <xsl:with-param name="section" select="$target"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="process-SimpleSection">
    <xsl:param name="section"/>
    <xsl:for-each select="$section/*">
      <xsl:choose>
        <xsl:when test="local-name() = 'title'"/>
        <xsl:when test="local-name() = 'author'"/>
        <xsl:when test="local-name() = 'production'">
          <pre xmlns="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates select="."/>
          </pre>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="process-text">
            <xsl:with-param name="text" select="."/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <!--<xsl:if test="$section/@id">
      <xsl:text>\label{</xsl:text>
      <xsl:value-of select="$section/@id"/>
      <xsl:text>}</xsl:text>
    </xsl:if>-->
  </xsl:template>

  <xsl:template name="process-StructuredSection">
    <xsl:param name="section"/>
    <xsl:param name="level"/>
    <xsl:for-each select="$section/*">
      <xsl:choose>
        <xsl:when test="local-name() = 'subtopic'">
          <xsl:call-template name="subsectionize">
            <xsl:with-param name="target" select="."/>
            <xsl:with-param name="level">
              <xsl:value-of select="$level"/>
            </xsl:with-param>
          </xsl:call-template>
          <xsl:call-template name="process-StructuredSection">
            <xsl:with-param name="section" select="."/>
            <xsl:with-param name="level">
              <xsl:choose>
                <xsl:when test="$level = 'h3'">
                  <xsl:text>h4</xsl:text>
                </xsl:when>
                <xsl:when test="$level = 'h4'">
                  <xsl:text>h5</xsl:text>
                </xsl:when>
                <xsl:when test="$level = 'h5'">
                  <xsl:text>h6</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>h3</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="local-name() = 'author'"/>
        <xsl:when test="local-name() = 'title'"/>
        <xsl:when test="local-name() = 'placeholder'">
          <xsl:apply-templates select="."/>
        </xsl:when>
        <xsl:when test="local-name() = 'synopsis'">
          <!-- inline -->
          <xsl:call-template name="process-SimpleSection">
            <xsl:with-param name="section" select="."/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="subsectionize">
            <xsl:with-param name="target" select="."/>
            <xsl:with-param name="level">
              <xsl:choose>
                <xsl:when test="$level = 'h3'">
                  <xsl:text>h4</xsl:text>
                </xsl:when>
                <xsl:when test="$level = 'h4'">
                  <xsl:text>h5</xsl:text>
                </xsl:when>
                <xsl:when test="$level = 'h5'">
                  <xsl:text>h6</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>h3</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
          <xsl:call-template name="process-SimpleSection">
            <xsl:with-param name="section" select="."/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <!--<xsl:if test="$section/@id">
      <xsl:text>\label{</xsl:text>
      <xsl:value-of select="$section/@id"/>
      <xsl:text>}</xsl:text>
    </xsl:if>-->
  </xsl:template>

  <xsl:template name="treatPart">
    <xsl:param name="part"/>
    <h1 xmlns="http://www.w3.org/1999/xhtml">
      <!-- anchor -->
      <a>
        <xsl:attribute name="name">
          <xsl:choose>
            <xsl:when test="$part/@id">
              <xsl:value-of select="$part/@id"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="local-name($part)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </a>
      <!-- text -->
      <xsl:text>Part I. </xsl:text>
      <!-- need to work on numbering -->
      <xsl:if test="$part/title">
        <xsl:value-of select="$part/title"/>
      </xsl:if>
    </h1>
    <xsl:apply-templates select="$part/*"/>
  </xsl:template>

  <xsl:template match="core|annex">
    <xsl:call-template name="sectionize">
      <xsl:with-param name="target" select="."/>
    </xsl:call-template>
    <xsl:call-template name="process-StructuredSection">
      <xsl:with-param name="section" select="."/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="capitaliseLocalName">
    <xsl:param name="section"/>
    <xsl:call-template name="capitaliseString">
      <xsl:with-param name="string" select="local-name($section)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="capitaliseString">
    <xsl:param name="string"/>
    <xsl:value-of select="concat(translate(substring($string,1,1), 'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ'), substring($string,2))"/>
  </xsl:template>

  <xsl:template name="uppercase">
    <xsl:param name="string"/>
    <xsl:value-of select="translate($string, 'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
  </xsl:template>

  <xsl:template match="sample">
    <pre xmlns="http://www.w3.org/1999/xhtml">
      <xsl:copy-of select="node()"/>
    </pre>
  </xsl:template>

  <xsl:template match="code">
    <code xmlns="http://www.w3.org/1999/xhtml">
      <xsl:copy-of select="node()"/>
    </code>
  </xsl:template>

  <!--
	\begin{figure}[t!]
	\begin{center}
	\includegraphics[width=0.85\textwidth]{convtree_jls_s.pdf}
	\end{center}
	\icaption{Convergence tree for the JLS grammars.}
	\label{F:jls-less}
	\end{figure}
	
-->
  <xsl:template match="figure">
    <p xmlns="http://www.w3.org/1999/xhtml">
      <xsl:if test="@id">
        <a>
          <xsl:attribute name="name">
            <xsl:value-of select="@id"/>
          </xsl:attribute>
        </a>
      </xsl:if>
      <center>
        <xsl:choose>
          <xsl:when test="source[type = 'PNG']">
            <img>
              <xsl:attribute name="src">
                <xsl:value-of select="source[type = 'PNG']/*[2]"/>
              </xsl:attribute>
              <xsl:attribute name="alt">
                <xsl:value-of select="shortcaption"/>
              </xsl:attribute>
            </img>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>...don't know how to insert a figure...</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <br/>
        <strong>
          <xsl:text>Figure.</xsl:text>
        </strong>
        <xsl:value-of select="caption"/>
      </center>
    </p>
  </xsl:template>

  <xsl:template match="table">
    <table xmlns="http://www.w3.org/1999/xhtml" border="1">
      <xsl:if test="./header">
        <xsl:for-each select="./header">
          <tr>
            <xsl:for-each select="cell">
              <th>
                <xsl:call-template name="process-text">
                  <xsl:with-param name="text" select="."/>
                </xsl:call-template>
              </th>
            </xsl:for-each>
          </tr>
        </xsl:for-each>
      </xsl:if>
      <xsl:for-each select="./row">
        <tr>
          <th>
            <xsl:call-template name="process-text">
              <xsl:with-param name="text" select="cell[1]"/>
            </xsl:call-template>
          </th>
          <xsl:for-each select="cell[position()>1]">
            <td>
              <xsl:call-template name="process-text">
                <xsl:with-param name="text" select="."/>
              </xsl:call-template>
            </td>
          </xsl:for-each>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="item-from-topSection">
    <xsl:param name="section"/>
    <li xmlns="http://www.w3.org/1999/xhtml">
      <a>
        <xsl:attribute name="href">
          <xsl:text>#</xsl:text>
          <xsl:choose>
            <xsl:when test="$section/@id">
              <xsl:value-of select="$section/@id"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="local-name($section)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:choose>
          <!-- can be replaced with a unified CamelCase2Whitespace -->
          <xsl:when test="local-name($section) = 'lineContinuations'">
            <xsl:text>Line continuations</xsl:text>
          </xsl:when>
          <xsl:when test="local-name($section) = 'designGoals'">
            <xsl:text>Design goals</xsl:text>
          </xsl:when>
          <xsl:when test="local-name($section) = 'normativeReferences'">
            <xsl:text>Normative references</xsl:text>
          </xsl:when>
          <xsl:when test="local-name($section) = 'documentStructure'">
            <xsl:text>Document structure</xsl:text>
          </xsl:when>
          <xsl:when test="local-name($section) = 'whatsnew'">
            <xsl:text>What's new</xsl:text>
          </xsl:when>
          <xsl:when test="local-name($section) = 'languageOverview'">
            <xsl:text>Language overview</xsl:text>
          </xsl:when>
          <!-- end of CamelCase2Whitespace -->
          <xsl:otherwise>
            <xsl:call-template name="capitaliseLocalName">
              <xsl:with-param name="section" select="$section"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </li>
  </xsl:template>
  <xsl:template name="item-from-coreSection">
    <xsl:param name="section"/>
    <li xmlns="http://www.w3.org/1999/xhtml">
      <a>
        <xsl:attribute name="href">
          <xsl:text>#</xsl:text>
          <xsl:value-of select="$section/@id"/>
        </xsl:attribute>
        <xsl:value-of select="$section/title"/>
      </a>
      <xsl:if test="$section/*/title">
        <ol>
          <xsl:for-each select="$section/*">
            <xsl:if test="title">
              <li>
                <a>
                  <xsl:attribute name="href">
                    <xsl:text>#</xsl:text>
                    <xsl:value-of select="@id"/>
                  </xsl:attribute>
                  <xsl:value-of select="title"/>
                </a>
              </li>
            </xsl:if>
          </xsl:for-each>
        </ol>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="placeholder">
    <!--
      <xsd:enumeration value="index"/>
      <xsd:enumeration value="listofauthors"/>
      <xsd:enumeration value="listofreferences"/>
    -->
    <xsl:choose>
      <xsl:when test=". = 'listofcontents'">
        <h2 xmlns="http://www.w3.org/1999/xhtml">Table of contents</h2>
        <ol xmlns="http://www.w3.org/1999/xhtml">
          <xsl:for-each select="//frontMatter/*|//backMatter/*|//core|//appendix">
            <xsl:choose>
              <xsl:when test="local-name() = 'foreword'
                        or    local-name() = 'designGoals'
                        or    local-name() = 'scope'
                        or    local-name() = 'conformance'
                        or    local-name() = 'compliance'
                        or    local-name() = 'compatibility'
                        or    local-name() = 'notation'
                        or    local-name() = 'normativeReferences'
                        or    local-name() = 'documentStructure'
                        or    local-name() = 'whatsnew'">
                <xsl:call-template name="item-from-topSection">
                  <xsl:with-param name="section" select="."/>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="local-name() = 'core'
                        or    local-name() = 'appendix'">
                <xsl:if test="title">
                  <xsl:call-template name="item-from-coreSection">
                    <xsl:with-param name="section" select="."/>
                  </xsl:call-template>
                </xsl:if>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>
        </ol>
      </xsl:when>
      <xsl:when test=". = 'listoftables'">
        <xsl:text>\listoftables</xsl:text>
      </xsl:when>
      <xsl:when test=". = 'fullgrammar'">
        <xsl:text>
	        \begin{lstlisting}[language=pp]
</xsl:text>
        <xsl:for-each select="//bgf:production">
          <xsl:apply-templates select="."/>
        </xsl:for-each>
        <xsl:text>\end{lstlisting}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>(generated content placeholder)</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>