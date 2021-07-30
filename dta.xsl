<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:prop="http://saxonica.com/ns/html-property"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:style="http://saxonica.com/ns/html-style-property"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
    xmlns:js="http://saxonica.com/ns/globalJS" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs prop ixsl js style xhtml d fn array map"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:d="data:,dpc">

    <!-- The input JSON file -->
    <!--<xsl:param name="input" select="'url to json file'"/>-->
    <xsl:param name="input"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!-- The initial template that process the JSON -->
    <xsl:template name="xsl:initial-template">
        <xsl:apply-templates select="json-doc($input)"/>
    </xsl:template>

    <!-- Template that matches the maps -->
    <xsl:template match=".[. instance of map(*)]">

        <xsl:processing-instruction name="xml-model">
            href="http://www.deutschestextarchiv.de/basisformat.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"            
       </xsl:processing-instruction>
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <!--            <xsl:attribute name="xml:id">
                <xsl:value-of select="concat('item_', format-number(?ItemId, '#'))"/>
            </xsl:attribute>-->
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title type="main">
                            <xsl:apply-templates select="?Title"/>
                        </title>
                        <title type="part">
                            <xsl:attribute name="n">
                                <xsl:value-of select="?OrderIndex"/>
                            </xsl:attribute>
                            <xsl:value-of select="?StorydcTitle"/>
                        </title>
                        <author>
                            <xsl:call-template name="distinct-values-from-list">
                                <xsl:with-param name="list" select="?StorydcCreator"/>
                            </xsl:call-template>
                        </author>
                        <respStmt>
                            <orgName>
                                <xsl:value-of select="?StorydcContributor"/>
                            </orgName>
                            <orgName>
                                <xsl:value-of select="?StoryedmDataProvider"/>
                            </orgName>
                            <orgName>
                                <xsl:value-of select="?StoryedmProvider"/>
                            </orgName>
                            <resp>Contributors and data providers</resp>
                        </respStmt>
                    </titleStmt>
                    <editionStmt>
                        <edition>Digital</edition>
                    </editionStmt>
                    <extent>
                        <measure type="characters">
                            <xsl:apply-templates select="?Transcriptions" mode="extentchar"/>
                        </measure>
                    </extent>
                    <publicationStmt>
                        <publisher>
                            <orgName role="hostingInstitution">
                                <xsl:value-of select="?StoryedmDataProvider"/>
                            </orgName>
                            <orgName role="project">
                                <xsl:value-of select="?StoryedmDatasetName"/>
                            </orgName>
                        </publisher>
                        <!--                        <idno>
                            <xsl:apply-templates select="?dcIdentifier"/>
                        </idno>-->
                        <availability>

                            <!--  <xsl:call-template name="distinct-values-from-list">
                                        <xsl:with-param name="list" select="?StoryedmRights"></xsl:with-param>
                                    </xsl:call-template>-->
                            <xsl:call-template name="licence">
                                <xsl:with-param name="storyedm" select="?StoryedmRights"/>
                            </xsl:call-template>
                        </availability>
                    </publicationStmt>
                    <!--                    <seriesStmt>
                        <title>
                            <xsl:value-of select="?StorydcTitle"/>
                        </title>
                        <idno>
                            <xsl:value-of select="concat('s', ?StoryId)"/>
                        </idno>
                    </seriesStmt>-->
                    <sourceDesc>
                        <p>
                            <!-- <xsl:apply-templates select="?StorydcSource"/>-->
                            <!--                            <xsl:choose>
                                <xsl:when test="not(contains(?StorydcSource, '|'))">
                                    <xsl:value-of select="?StorydcSource"/>
                                </xsl:when> 
                                <xsl:otherwise>

                                    <xsl:call-template name="remove-duplicates">
                                        <xsl:with-param name="string"
                                            select="translate(?StorydcSource, ' ', ' ')"/>
                                        <xsl:with-param name="newstring" select="''"/>
                                    </xsl:call-template>
                                </xsl:otherwise>
                            </xsl:choose>-->
                            <xsl:call-template name="distinct-values-from-list">
                                <xsl:with-param name="list" select="?StorydcSource"/>
                            </xsl:call-template>
                        </p>
                    </sourceDesc>
                </fileDesc>
                <encodingDesc>
                    <tagsDecl>
                        <rendition scheme="css" xml:id="aq">font-family:sans-serif</rendition>
                        <rendition scheme="css" xml:id="b">font-weight:bold</rendition>
                        <rendition scheme="css" xml:id="blue">color:blue</rendition>
                        <rendition scheme="css" xml:id="c">display:block;
                            text-align:center</rendition>
                        <rendition scheme="css" xml:id="et">display:block; margin-left:2em;
                            text-indent:0</rendition>
                        <rendition scheme="css" xml:id="et2">display:block; margin-left:4em;
                            text-indent:0</rendition>
                        <rendition scheme="css" xml:id="et3">display:block; margin-left:6em;
                            text-indent:0</rendition>
                        <rendition scheme="css" xml:id="f">border:1px dotted silver</rendition>
                        <rendition scheme="css" xml:id="fr">border:1px dotted silver</rendition>
                        <rendition scheme="css" xml:id="g">letter-spacing:0.125em</rendition>
                        <rendition scheme="css" xml:id="i">font-style:italic</rendition>
                        <rendition scheme="css" xml:id="in">font-size:150%</rendition>
                        <rendition scheme="css" xml:id="k">font-variant:small-caps</rendition>
                        <rendition scheme="css" xml:id="larger">font-size:larger</rendition>
                        <rendition scheme="css" xml:id="red">color:red</rendition>
                        <rendition scheme="css" xml:id="right">display:block;
                            text-align:right</rendition>
                        <rendition scheme="css" xml:id="s">text-decoration:line-through</rendition>
                        <rendition scheme="css" xml:id="smaller">font-size:smaller</rendition>
                        <rendition scheme="css" xml:id="sub">vertical-align:sub;
                            font-size:.7em</rendition>
                        <rendition scheme="css" xml:id="sup">vertical-align:super;
                            font-size:.7em</rendition>
                        <rendition scheme="css" xml:id="u">text-decoration:underline</rendition>
                        <rendition scheme="css" xml:id="uu">border-bottom:double 3px
                            #000</rendition>
                    </tagsDecl>
                </encodingDesc>
                <profileDesc>
                    <textClass>
                        <xsl:variable name="testTrue">
                            <xsl:for-each select="?Properties">
                                <xsl:variable name="testkw">
                                    <xsl:apply-templates select="." mode="countproperties"/>
                                </xsl:variable>
                                <xsl:if test="$testkw = 'true'">
                                    <xsl:value-of select="true()"/>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:if test="$testTrue = 'true'">
                            <xsl:for-each select="?Properties">

                                <xsl:apply-templates select="." mode="prop"/>

                            </xsl:for-each>
                        </xsl:if>


                    </textClass>
                    <langUsage>
                        <xsl:apply-templates select="?Transcriptions" mode="languages"/>
                    </langUsage>
                    <abstract>
                        <p>
                            <xsl:apply-templates select="?Description"/>
                        </p>
                    </abstract>
                </profileDesc>

            </teiHeader>
            <text>
                <body>
                    <div>
                        <xsl:apply-templates select="?Transcriptions" mode="transcript"/>
                    </div>
                </body>
            </text>
        </TEI>

    </xsl:template>

    <xsl:template match=".[. instance of map(*)]" mode="transcript">
        <xsl:if test="?CurrentVersion = '1'">
            <xsl:call-template name="transcriptionHTML">
                <xsl:with-param name="html">
                    <xsl:copy-of select="d:htmlparse(?Text)"/>
                </xsl:with-param>
            </xsl:call-template>

        </xsl:if>
    </xsl:template>

    <xsl:template name="transcriptionHTML">
        <xsl:param name="html"/>
        <xsl:for-each select="$html/node()">
            <xsl:choose>
                <xsl:when test="self::xhtml:p">
                    
                    <xsl:apply-templates select="."/>
                </xsl:when>
                <xsl:when test="self::xhtml:span">  
                    
                    <xsl:apply-templates select="."/>
                </xsl:when>
                <xsl:when test="self::xhtml:table">
                    <xsl:apply-templates select="."/>
                </xsl:when>
                <xsl:when test="self::xhtml:br">
                    
                    <xsl:apply-templates select="."/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="stringTest">
                        <!--<xsl:value-of select="translate(normalize-space(.),' ','')"/>-->
                        <xsl:value-of select="replace(., '[\t\p{Zs}]', '')"/>
                    </xsl:variable>
                    <xsl:if test="not($stringTest='')">
                        <p>                     
                            <xsl:apply-templates select="."/>
                        </p>  
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        
    </xsl:template>

    <xsl:template name="licence">
        <xsl:param name="storyedm"/>
        <xsl:variable name="licenceBis">
            <xsl:call-template name="distinct-values-from-list">
                <xsl:with-param name="list" select="$storyedm"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="listLicences">
            <xsl:value-of select="fn:tokenize($licenceBis, '\|\|')"/>
        </xsl:variable>
        <xsl:for-each select="fn:tokenize($licenceBis, '\|\|')">
            <licence>
                <xsl:attribute name="target">
                    <xsl:value-of select="normalize-space(.)"/>
                </xsl:attribute>
            </licence>
        </xsl:for-each>


    </xsl:template>


    <xsl:template match=".[. instance of map(*)]" mode="extentchar">
        <xsl:if test="?CurrentVersion = '1'">
            <xsl:value-of select="string-length(?TextNoTags)"/>
        </xsl:if>
    </xsl:template>


    <xsl:template match=".[. instance of map(*)]" mode="countproperties">
        <xsl:if test="?PropertyType = 'Keyword'">
            <xsl:value-of select="true()"/>
        </xsl:if>
    </xsl:template>


    <xsl:template match=".[. instance of map(*)]" mode="prop">

        <xsl:if test="?PropertyType = 'Keyword'">
            <classCode scheme="#">
                <xsl:value-of select="?PropertyValue"/>
            </classCode>
        </xsl:if>


    </xsl:template>

    <xsl:template match=".[. instance of map(*)]" mode="languages">
        <xsl:if test="?CurrentVersion = '1'">

            <xsl:apply-templates select="?Languages" mode="lang"/>

        </xsl:if>
    </xsl:template>

    <xsl:template match=".[. instance of map(*)]" mode="lang">

        <language>
            <xsl:attribute name="ident">
                <xsl:value-of select="?Code"/>
            </xsl:attribute>
            <xsl:value-of select="?NameEnglish"/>
        </language>

    </xsl:template>


    <xsl:template match="xhtml:p">
        <p>
            
            <xsl:if test="@class">
                <!--                    <xsl:attribute name="rendition">
                        <xsl:value-of select="@class"/>
                    </xsl:attribute>     -->
                
                <xsl:variable name="attributP">
                    <xsl:if test="contains(@class, 'bold')">
                        <xsl:text>#b</xsl:text>
                    </xsl:if>
                    <xsl:if test="contains(@class, 'italic')">
                        <xsl:text> #i</xsl:text>
                    </xsl:if>
                    <xsl:if test="contains(@class, 'right')">
                        <xsl:text> #right</xsl:text>
                    </xsl:if>
                    <xsl:if test="contains(@class, 'center')">
                        <xsl:text> #c</xsl:text>
                    </xsl:if>
                    <xsl:if test="contains(@class, 'underline')">
                        <xsl:text> #u</xsl:text>
                    </xsl:if>
                </xsl:variable>
                
                <xsl:if test="not($attributP = '')">
                    <xsl:attribute name="rendition">
                        <xsl:value-of select="fn:normalize-space($attributP)"/>
                    </xsl:attribute>
                </xsl:if>
                
            </xsl:if>
            
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="xhtml:img">
        <xsl:if test="contains(@class, 'tct_missing')">
            <gap reason="illegible"/>
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template match="xhtml:span">
        
        <xsl:choose>
            <xsl:when test="parent::*">
                
                <xsl:choose>
                    <xsl:when test="@class | @style">
                        
                        <xsl:choose>
                            <xsl:when test="@class = 'tct-uncertain'">
                                <unclear>
                                    <xsl:apply-templates/>
                                </unclear>
                            </xsl:when>
                            <xsl:when test="@class = 'pos-in-text'">
                                <note type="editorial">
                                    <xsl:apply-templates/>
                                </note>
                            </xsl:when>
                            <xsl:otherwise>
                                
                                
                                
                                
                                <xsl:variable name="attributHi">
                                    <xsl:if test="contains(@class, 'bold')">
                                        
                                        <xsl:text>#b</xsl:text>
                                        
                                    </xsl:if>
                                    <xsl:if test="contains(@class, 'italic')">
                                        
                                        <xsl:text> #i</xsl:text>
                                        
                                    </xsl:if>
                                    <xsl:if test="contains(@class, 'right')">
                                        
                                        <xsl:text> #right</xsl:text>
                                        
                                    </xsl:if>
                                    <xsl:if test="contains(@class, 'center')">
                                        
                                        <xsl:text> #c</xsl:text>
                                        
                                    </xsl:if>
                                    <xsl:if test="contains(@class, 'underline')">
                                        
                                        <xsl:text> #u</xsl:text>
                                        
                                    </xsl:if>
                                </xsl:variable>
                                
                                <xsl:choose>
                                    <xsl:when test="not($attributHi = '')">
                                        <hi>
                                            <xsl:attribute name="rendition">
                                                <xsl:value-of
                                                    select="fn:normalize-space($attributHi)"/>
                                            </xsl:attribute>
                                            <xsl:apply-templates/>
                                        </hi>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                
                                
                                
                            </xsl:otherwise>
                        </xsl:choose>
                        
                        
                        
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                
                <p>
                    <xsl:choose>
                        <xsl:when test="@class | @style">
                            
                            <xsl:choose>
                                <xsl:when test="@class = 'tct-uncertain'">
                                    <unclear>
                                        <xsl:apply-templates/>
                                    </unclear>
                                </xsl:when>
                                <xsl:when test="@class = 'pos-in-text'">
                                    <note type="editorial">
                                        <xsl:apply-templates/>
                                    </note>
                                </xsl:when>
                                <xsl:otherwise>
                                    
                                    
                                    
                                    
                                    <xsl:variable name="attributHi">
                                        <xsl:if test="contains(@class, 'bold')">
                                            
                                            <xsl:text>#b</xsl:text>
                                            
                                        </xsl:if>
                                        <xsl:if test="contains(@class, 'italic')">
                                            
                                            <xsl:text> #i</xsl:text>
                                            
                                        </xsl:if>
                                        <xsl:if test="contains(@class, 'right')">
                                            
                                            <xsl:text> #right</xsl:text>
                                            
                                        </xsl:if>
                                        <xsl:if test="contains(@class, 'center')">
                                            
                                            <xsl:text> #c</xsl:text>
                                            
                                        </xsl:if>
                                        <xsl:if test="contains(@class, 'underline')">
                                            
                                            <xsl:text> #u</xsl:text>
                                            
                                        </xsl:if>
                                    </xsl:variable>
                                    
                                    <xsl:choose>
                                        <xsl:when test="not($attributHi = '')">
                                            <hi>
                                                <xsl:attribute name="rendition">
                                                    <xsl:value-of
                                                        select="fn:normalize-space($attributHi)"/>
                                                </xsl:attribute>
                                                <xsl:apply-templates/>
                                            </hi>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:apply-templates/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    
                                    
                                    
                                </xsl:otherwise>
                            </xsl:choose>
                            
                            
                            
                        </xsl:when>
                    </xsl:choose>
                </p>
            </xsl:otherwise>
        </xsl:choose>
        
        
        
    </xsl:template>
    
    <xsl:template match="xhtml:del">
        <del>
            <xsl:apply-templates/>
        </del>
    </xsl:template>
    
    <xsl:template match="xhtml:table">
        <table>
            <xsl:apply-templates/>
        </table>
    </xsl:template>

    <xsl:template match="xhtml:tr">
        <row>
            <xsl:apply-templates/>
        </row>
    </xsl:template>

    <xsl:template match="xhtml:td">
        <cell>
            <xsl:apply-templates/>
        </cell>
    </xsl:template>

    <xsl:template match="xhtml:br">
        <lb/>
    </xsl:template>

    <xsl:template name="distinct-values-from-list">
        <xsl:param name="list"/>
        <xsl:param name="delimiter" select="'||'"/>
        <xsl:choose>
            <xsl:when test="contains($list, $delimiter)">
                <xsl:variable name="token" select="substring-before($list, $delimiter)"/>
                <xsl:variable name="next-list" select="substring-after($list, $delimiter)"/>
                <!-- output token if it is unique -->
                <xsl:if
                    test="not(contains(concat($delimiter, $next-list, $delimiter), concat($delimiter, $token, $delimiter)))">
                    <xsl:value-of select="concat($token, $delimiter)"/>
                </xsl:if>
                <!-- recursive call -->
                <xsl:call-template name="distinct-values-from-list">
                    <xsl:with-param name="list" select="$next-list"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$list"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>




    <xsl:variable name="d:attr"
        select="'(\i\c*)\s*(=\s*(&quot;[^&quot;]*&quot;|''[^'']*''|[^ \t\n\r''&quot;&gt;]+))?\s*'"/>

    <xsl:variable name="d:elem" select="'(\i\c*)'"/>

    <xsl:variable name="d:comment" select="'&lt;!\-\-[^\-]*(\-[^\-]+)*\-\->'"/>

    <xsl:variable name="d:pi" select="'&lt;\?\i\c*[^>]*>'"/>

    <xsl:variable name="d:doctype" select="'&lt;!D[^\[&lt;>]*(\[[^\]]*\])?>'"/>


    <xsl:variable name="d:msif" select="'&lt;!\[(end)?if.*?\]>'"/>

    <xsl:variable name="d:cdata" select="'&lt;!\[CDATA(.|\s)*\]\]>'"/>

    <xsl:function name="d:htmlparse">
        <xsl:param name="string" as="xs:string"/>
        <xsl:sequence select="d:htmlparse($string, 'http://www.w3.org/1999/xhtml', true())"/>
    </xsl:function>

    <xsl:function name="d:htmlparse">
        <xsl:param name="string" as="xs:string"/>
        <xsl:param name="namespace" as="xs:string"/>
        <!-- anyURI -->
        <xsl:param name="html-mode" as="xs:boolean"/>

        <xsl:variable name="x">
            <xsl:analyze-string select="replace($string, '&#13;&#10;', '&#10;')"
                regex="&lt;(/?){$d:elem}\s*(({$d:attr})*)(/?)>|{$d:comment}|{$d:pi}|{$d:doctype}|{$d:cdata}|({$d:msif})">
                <xsl:matching-substring>
                    <xsl:choose>
                        <xsl:when test="starts-with(., '&lt;![CDATA')">
                            <xsl:value-of select="substring(., 10, string-length(.) - 13)"/>
                        </xsl:when>
                        <xsl:when test="starts-with(., '&lt;!D')"/>
                        <xsl:when test="starts-with(., '&lt;!-')">
                            <comment>
                                <xsl:value-of select="substring(., 5, string-length(.) - 7)"/>
                            </comment>
                        </xsl:when>
                        <xsl:when test="starts-with(., '&lt;![')"/>
                        <xsl:when test="starts-with(., '&lt;?')">
                            <pi>
                                <xsl:value-of
                                    select="normalize-space((substring(., 3, string-length(.) - 4)))"
                                />
                            </pi>
                        </xsl:when>
                        <xsl:when test="(regex-group(1) = '/')">
                            <end
                                name="{if ($html-mode) then lower-case(regex-group(2)) else regex-group(2)}"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <start
                                name="{if ($html-mode) then lower-case(regex-group(2)) else regex-group(2)}">
                                <attrib>
                                    <xsl:analyze-string regex="{$d:attr}" select="regex-group(3)">
                                        <xsl:matching-substring>
                                            <xsl:choose>
                                                <xsl:when
                                                  test="starts-with(regex-group(1), 'xmlns')">
                                                  <d:ns>
                                                  <xsl:variable name="n"
                                                  select="d:chars(substring(regex-group(3), 2, string-length(regex-group(3)) - 2))"/>
                                                  <xsl:namespace
                                                  name="{substring-after(regex-group(1),'xmlns:')}"
                                                  select="
                                                                if ($n) then
                                                                    $n
                                                                else
                                                                    'data:,dpc'"
                                                  />
                                                  </d:ns>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <attribute
                                                  name="{if ($html-mode) then lower-case(regex-group(1)) else regex-group(1)}">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="starts-with(regex-group(3), '&quot;')">
                                                  <xsl:value-of
                                                  select="d:chars(substring(regex-group(3), 2, string-length(regex-group(3)) - 2))"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when test="starts-with(regex-group(3), '''')">
                                                  <xsl:value-of
                                                  select="d:chars(substring(regex-group(3), 2, string-length(regex-group(3)) - 2))"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when test="string(regex-group(2))">
                                                  <xsl:value-of select="regex-group(3)"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="regex-group(1)"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </attribute>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                </attrib>
                            </start>
                            <xsl:if test="regex-group(8) = '/'">
                                <end
                                    name="{if ($html-mode) then lower-case(regex-group(2)) else regex-group(2)}"
                                />
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="."/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:variable>


        <xsl:variable name="y">
            <xsl:choose>
                <xsl:when test="$html-mode">
                    <xsl:apply-templates mode="d:html" select="$x/node()[1]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="d:gxml" select="$x/node()[1]"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="j">
            <xsl:element name="x" namespace="{if ($namespace) then $namespace else ''}"/>
        </xsl:variable>

        <xsl:variable name="z">
            <xsl:apply-templates mode="d:tree" select="$y/node()[1]">
                <xsl:with-param name="ns" select="$j/*/namespace::*[name() = '']"/>
            </xsl:apply-templates>
        </xsl:variable>

        <!--
   <xsl:copy-of select="$x"/>
  ===
  <xsl:copy-of select="$y"/>
  ===
-->

        <xsl:copy-of select="$z"/>

    </xsl:function>

    <xsl:function name="d:chars">
        <xsl:param name="s" as="xs:string"/>
        <xsl:value-of>
            <xsl:analyze-string select="$s"
                regex="&amp;(#?)(x?)([0-9a-fA-F]+|[a-zA-Z][a-zA-Z0-9]*);">
                <xsl:matching-substring>
                    <xsl:choose>
                        <xsl:when test="regex-group(2) = 'x'">
                            <xsl:value-of select="
                                    codepoints-to-string(
                                    d:hex(
                                    for $i in string-to-codepoints(upper-case(regex-group(3)))
                                    return
                                        if ($i &gt; 64) then
                                            $i - 55
                                        else
                                            $i - 48))"/>
                        </xsl:when>
                        <xsl:when test="regex-group(1) = '#'">
                            <xsl:value-of select="codepoints-to-string(xs:integer(regex-group(3)))"
                            />
                        </xsl:when>
                        <xsl:when test="$d:ents/key('d:ents', regex-group(3))">
                            <xsl:value-of select="$d:ents/key('d:ents', regex-group(3))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:message>htmlparse: Unknown entity: <xsl:value-of
                                    select="regex-group(3)"/></xsl:message>
                            <xsl:text>&amp;</xsl:text>
                            <xsl:value-of select="regex-group(3)"/>
                            <xsl:text>;</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="."/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:value-of>
    </xsl:function>


    <xsl:function name="d:hex" as="xs:integer">
        <xsl:param name="x" as="xs:integer*"/>
        <xsl:value-of select="
                if (empty($x)) then
                    0
                else
                    ($x[last()] + 16 * d:hex($x[position() != last()]))"/>
    </xsl:function>

    <xsl:template mode="d:cdata" match="text()">
        <xsl:param name="s" select="()" as="xs:string*"/>
        <xsl:value-of select="."/>
        <xsl:apply-templates mode="#current" select="following-sibling::node()[1]">
            <xsl:with-param name="s" select="$s"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template mode="d:html d:gxml" match="text()">
        <xsl:param name="s" select="()" as="xs:string*"/>
        <xsl:value-of select="d:chars(.)"/>
        <xsl:apply-templates mode="#current" select="following-sibling::node()[1]">
            <xsl:with-param name="s" select="$s"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template mode="d:html d:gxml" match="comment | pi">
        <xsl:param name="s" select="()" as="xs:string*"/>
        <xsl:copy-of select="."/>
        <xsl:apply-templates mode="#current" select="following-sibling::node()[1]">
            <xsl:with-param name="s" select="$s"/>
        </xsl:apply-templates>
    </xsl:template>


    <xsl:template mode="d:html" match="start[@name = ('script', 'style')]">
        <xsl:param name="s" select="()" as="xs:string*"/>
        <start name="{@name}" s="{$s}">
            <xsl:copy-of select="attrib"/>
        </start>
        <xsl:apply-templates mode="d:cdata" select="following-sibling::node()[1]"/>
        <end name="{@name}" s="{$s}"/>
        <xsl:apply-templates mode="d:html"
            select="following-sibling::end[@name = current()/@name][1]/following-sibling::node()[1]">
            <xsl:with-param name="s" select="$s"/>
        </xsl:apply-templates>
    </xsl:template>



    <xsl:template mode="d:cdata" match="start">
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="(@name, .)"/>
        <xsl:text>&gt;</xsl:text>
        <xsl:apply-templates mode="d:cdata" select="following-sibling::node()[1]"/>
    </xsl:template>

    <xsl:template mode="d:html d:gxml" match="start">
        <xsl:param name="s" select="()" as="xs:string*"/>
        <start name="{@name}" s="{$s}">
            <xsl:copy-of select="attrib"/>
        </start>
        <xsl:apply-templates mode="#current" select="following-sibling::node()[1]">
            <xsl:with-param name="s" select="(string(@name), $s)"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template mode="d:html"
        match="start[@name = ('br', 'hr', 'basefont', 'area', 'link', 'img', 'param', 'input', 'col', 'frame', 'isindex', 'base', 'meta')]">
        <xsl:param name="s" select="()" as="xs:string*"/>
        <start name="{@name}" s="{$s}">
            <xsl:copy-of select="attrib"/>
        </start>
        <end name="{@name}" s="{$s}"/>
        <xsl:apply-templates mode="d:html"
            select="following-sibling::node()[not(self::end/@name = current()/@name)][1]">
            <xsl:with-param name="s" select="$s"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:variable name="d:lists" select="('ul', 'ol', 'dl')"/>
    <xsl:variable name="d:listitems" select="('li', 'dt', 'dd')"/>

    <xsl:template mode="d:html" match="start[@name = $d:listitems]">
        <xsl:param name="s" select="()" as="xs:string*"/>
        <xsl:choose>
            <xsl:when test="not($d:lists = $s) or $d:lists = $s[1]">
                <start name="{@name}" s="{$s}">
                    <xsl:copy-of select="attrib"/>
                </start>
                <xsl:apply-templates mode="d:html" select="following-sibling::node()[1]">
                    <xsl:with-param name="s" select="(string(@name), $s)"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="d:end">
                    <xsl:with-param name="s" select="$s"/>
                    <xsl:with-param name="n" select="$s[1]"/>
                    <xsl:with-param name="next" select="."/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <xsl:template mode="d:html" match="start[@name = 'td']">
        <xsl:param name="s" select="()" as="xs:string*"/>
        <xsl:choose>
            <xsl:when test="not('tr' = $s) or 'tr' = $s[1]">
                <start name="{@name}" s="{$s}">
                    <xsl:copy-of select="attrib"/>
                </start>
                <xsl:apply-templates mode="d:html" select="following-sibling::node()[1]">
                    <xsl:with-param name="s" select="(string(@name), $s)"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="d:end">
                    <xsl:with-param name="s" select="$s"/>
                    <xsl:with-param name="n" select="$s[1]"/>
                    <xsl:with-param name="next" select="."/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template mode="d:html" match="start[@name = 'p']">
        <xsl:param name="s" select="()" as="xs:string*"/>
        <xsl:choose>
            <xsl:when test="not('p' = $s)">
                <start name="{@name}" s="{$s}">
                    <xsl:copy-of select="attrib"/>
                </start>
                <xsl:apply-templates mode="d:html" select="following-sibling::node()[1]">
                    <xsl:with-param name="s" select="(string(@name), $s)"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="d:end">
                    <xsl:with-param name="s" select="$s"/>
                    <xsl:with-param name="n" select="$s[1]"/>
                    <xsl:with-param name="next" select="."/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template mode="d:gxml" match="end">
        <xsl:param name="n" select="@name" as="xs:string"/>
        <xsl:param name="s" select="()" as="xs:string*"/>
        <xsl:param name="next" select="following-sibling::node()[1]" as="node()?"/>
        <xsl:variable name="s2" select="$s[position() != 1]"/>
        <xsl:choose>
            <xsl:when test="$s[1] = $n">
                <end name="{$n}" s="{$s2}"/>
                <xsl:apply-templates mode="#current" select="$next">
                    <xsl:with-param name="s" select="$s2"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="not($n = $s)">
                <!--====/<xsl:value-of select="$n"/>======-->
                <xsl:message>htmlparse: Not well formed (ignoring /<xsl:value-of select="$n"
                    />)</xsl:message>
                <xsl:apply-templates mode="#current" select="$next">
                    <xsl:with-param name="s" select="$s"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <end name="{$s[1]}" s="{$s2}"/>
                <xsl:apply-templates mode="#current" select=".">
                    <xsl:with-param name="s" select="$s2"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:variable name="d:restart" select="('i', 'b', 'font')"/>

    <xsl:template mode="d:html" match="end" name="d:end">
        <xsl:param name="n" select="@name" as="xs:string"/>
        <xsl:param name="s" select="()" as="xs:string*"/>
        <xsl:param name="r" select="()" as="xs:string*"/>
        <xsl:param name="next" select="following-sibling::node()[1]" as="node()?"/>
        <xsl:variable name="s2" select="$s[position() != 1]"/>
        <xsl:choose>
            <xsl:when test="$s[1] = $n">
                <end name="{$n}" s="{$s2}"/>
                <xsl:for-each select="$r">
                    <xsl:variable name="rp" select="1 + last() - position()"/>
                    <start name="{$r[$rp]}" s="{($r[position()&gt;$rp],$s2)}"/>
                </xsl:for-each>
                <xsl:apply-templates mode="#current" select="$next">
                    <xsl:with-param name="s" select="($r, $s2)"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="not($n = $s)">
                <!--====/<xsl:value-of select="$n"/>======-->
                <xsl:message>htmlparse: Not well formed (ignoring /<xsl:value-of select="$n"
                    />)</xsl:message>
                <xsl:apply-templates mode="#current" select="$next">
                    <xsl:with-param name="s" select="$s"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <end name="{$s[1]}" s="{$s2}"/>
                <xsl:apply-templates mode="#current" select=".">
                    <xsl:with-param name="s" select="$s2"/>
                    <xsl:with-param name="r" select="
                            if ($s[1] = $d:restart) then
                                ($r, $s[1])
                            else
                                ()"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <xsl:template mode="d:tree" match="text()">
        <xsl:param name="ns" as="node()*"/>
        <xsl:copy-of select="."/>
        <xsl:apply-templates select="following-sibling::node()[1]" mode="d:tree">
            <xsl:with-param name="ns" select="$ns"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template mode="d:tree" match="comment">
        <xsl:param name="ns" as="node()*"/>
        <xsl:comment>
    <xsl:value-of select="."/>
  </xsl:comment>
        <xsl:apply-templates select="following-sibling::node()[1]" mode="d:tree">
            <xsl:with-param name="ns" select="$ns"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template mode="d:tree" match="pi">
        <xsl:param name="ns" as="node()*"/>
        <xsl:processing-instruction name="{substring-before(.,' ')}">
    <xsl:value-of select="substring-after(., ' ')"/>
  </xsl:processing-instruction>
        <xsl:apply-templates select="following-sibling::node()[1]" mode="d:tree">
            <xsl:with-param name="ns" select="$ns"/>
        </xsl:apply-templates>
    </xsl:template>



    <xsl:template mode="d:tree" match="start">
        <xsl:param name="ns" as="node()*"/>
        <xsl:variable name="n" select="following-sibling::end[@s = current()/@s][1]"/>
        <xsl:variable name="xns" select="attrib/d:ns/namespace::*" as="node()*"/>
        <xsl:variable name="nns" select="($ns, $xns)" as="node()*"/>
        <xsl:element name="{if(string(@name))then @name else 'xml'}"
            namespace="{$nns[name()=substring-before(current()/@name,':')][last()][not(.='data:,dpc')]}">
            <xsl:for-each select="attrib/attribute">
                <xsl:attribute name="{@name}"
                    namespace="{if(contains(@name,':')) then $nns[name()=substring-before(current()/@name,':')][last()][not(.='data:,dpc')] else ''}"
                    select="."/>
            </xsl:for-each>
            <xsl:apply-templates select="following-sibling::node()[1][not(. is $n)]" mode="d:tree">
                <xsl:with-param name="ns" select="$nns"/>
            </xsl:apply-templates>
        </xsl:element>
        <xsl:apply-templates select="$n/following-sibling::node()[1]" mode="d:tree">
            <xsl:with-param name="ns" select="$ns"/>
        </xsl:apply-templates>
    </xsl:template>

    <!--
Old version without NS support
<xsl:template mode="d:tree" match="start">
  <xsl:variable name="n" select="following-sibling::end[@s=current()/@s][1]"/>
  <xsl:element name="{@name}" namespace="http://www.w3.org/1999/xhtml">
  <xsl:copy-of select="attrib/@*"/>
  <xsl:apply-templates select="following-sibling::node()[1][not(. is $n)]" mode="d:tree"/>
  </xsl:element>
  <xsl:apply-templates select="$n/following-sibling::node()[1]" mode="d:tree"/>
</xsl:template>
-->


    <xsl:variable name="d:ents">

        <entity name="Aacute">&#xC1;</entity>
        <entity name="aacute">&#xE1;</entity>
        <entity name="Acirc">&#xC2;</entity>
        <entity name="acirc">&#xE2;</entity>
        <entity name="acute">&#xB4;</entity>
        <entity name="AElig">&#xC6;</entity>
        <entity name="aelig">&#xE6;</entity>
        <entity name="Agrave">&#xC0;</entity>
        <entity name="agrave">&#xE0;</entity>
        <entity name="Aring">&#xC5;</entity>
        <entity name="aring">&#xE5;</entity>
        <entity name="Atilde">&#xC3;</entity>
        <entity name="atilde">&#xE3;</entity>
        <entity name="Auml">&#xC4;</entity>
        <entity name="auml">&#xE4;</entity>
        <entity name="brvbar">&#xA6;</entity>
        <entity name="Ccedil">&#xC7;</entity>
        <entity name="ccedil">&#xE7;</entity>
        <entity name="cedil">&#xB8;</entity>
        <entity name="cent">&#xA2;</entity>
        <entity name="copy">&#xA9;</entity>
        <entity name="COPY">&#xA9;</entity>
        <entity name="curren">&#xA4;</entity>
        <entity name="deg">&#xB0;</entity>
        <entity name="divide">&#xF7;</entity>
        <entity name="Eacute">&#xC9;</entity>
        <entity name="eacute">&#xE9;</entity>
        <entity name="Ecirc">&#xCA;</entity>
        <entity name="ecirc">&#xEA;</entity>
        <entity name="Egrave">&#xC8;</entity>
        <entity name="egrave">&#xE8;</entity>
        <entity name="ETH">&#xD0;</entity>
        <entity name="eth">&#xF0;</entity>
        <entity name="Euml">&#xCB;</entity>
        <entity name="euml">&#xEB;</entity>
        <entity name="frac12">&#xBD;</entity>
        <entity name="frac14">&#xBC;</entity>
        <entity name="frac34">&#xBE;</entity>
        <entity name="Iacute">&#xCD;</entity>
        <entity name="iacute">&#xED;</entity>
        <entity name="Icirc">&#xCE;</entity>
        <entity name="icirc">&#xEE;</entity>
        <entity name="iexcl">&#xA1;</entity>
        <entity name="Igrave">&#xCC;</entity>
        <entity name="igrave">&#xEC;</entity>
        <entity name="iquest">&#xBF;</entity>
        <entity name="Iuml">&#xCF;</entity>
        <entity name="iuml">&#xEF;</entity>
        <entity name="laquo">&#xAB;</entity>
        <entity name="macr">&#xAF;</entity>
        <entity name="micro">&#xB5;</entity>
        <entity name="middot">&#xB7;</entity>
        <entity name="nbsp">&#xA0;</entity>
        <entity name="not">&#xAC;</entity>
        <entity name="Ntilde">&#xD1;</entity>
        <entity name="ntilde">&#xF1;</entity>
        <entity name="Oacute">&#xD3;</entity>
        <entity name="oacute">&#xF3;</entity>
        <entity name="Ocirc">&#xD4;</entity>
        <entity name="ocirc">&#xF4;</entity>
        <entity name="Ograve">&#xD2;</entity>
        <entity name="ograve">&#xF2;</entity>
        <entity name="ordf">&#xAA;</entity>
        <entity name="ordm">&#xBA;</entity>
        <entity name="Oslash">&#xD8;</entity>
        <entity name="oslash">&#xF8;</entity>
        <entity name="Otilde">&#xD5;</entity>
        <entity name="otilde">&#xF5;</entity>
        <entity name="Ouml">&#xD6;</entity>
        <entity name="ouml">&#xF6;</entity>
        <entity name="para">&#xB6;</entity>
        <entity name="plusmn">&#xB1;</entity>
        <entity name="pound">&#xA3;</entity>
        <entity name="raquo">&#xBB;</entity>
        <entity name="reg">&#xAE;</entity>
        <entity name="REG">&#xAE;</entity>
        <entity name="sect">&#xA7;</entity>
        <entity name="shy">&#xAD;</entity>
        <entity name="sup1">&#xB9;</entity>
        <entity name="sup2">&#xB2;</entity>
        <entity name="sup3">&#xB3;</entity>
        <entity name="szlig">&#xDF;</entity>
        <entity name="THORN">&#xDE;</entity>
        <entity name="thorn">&#xFE;</entity>
        <entity name="times">&#xD7;</entity>
        <entity name="Uacute">&#xDA;</entity>
        <entity name="uacute">&#xFA;</entity>
        <entity name="Ucirc">&#xDB;</entity>
        <entity name="ucirc">&#xFB;</entity>
        <entity name="Ugrave">&#xD9;</entity>
        <entity name="ugrave">&#xF9;</entity>
        <entity name="uml">&#xA8;</entity>
        <entity name="Uuml">&#xDC;</entity>
        <entity name="uuml">&#xFC;</entity>
        <entity name="Yacute">&#xDD;</entity>
        <entity name="yacute">&#xFD;</entity>
        <entity name="yen">&#xA5;</entity>
        <entity name="yuml">&#xFF;</entity>


        <entity name="bdquo">&#x201E;</entity>
        <entity name="circ">&#x2C6;</entity>
        <entity name="Dagger">&#x2021;</entity>
        <entity name="dagger">&#x2020;</entity>
        <entity name="emsp">&#x2003;</entity>
        <entity name="ensp">&#x2002;</entity>
        <entity name="euro">&#x20AC;</entity>
        <entity name="gt">&#x3E;</entity>
        <entity name="GT">&#x3E;</entity>
        <entity name="ldquo">&#x201C;</entity>
        <entity name="lrm">&#x200E;</entity>
        <entity name="lsaquo">&#x2039;</entity>
        <entity name="lsquo">&#x2018;</entity>
        <entity name="lt">&#60;</entity>
        <entity name="LT">&#60;</entity>
        <entity name="amp">&#38;</entity>
        <entity name="AMP">&#38;</entity>
        <entity name="mdash">&#x2014;</entity>
        <entity name="ndash">&#x2013;</entity>
        <entity name="OElig">&#x152;</entity>
        <entity name="oelig">&#x153;</entity>
        <entity name="permil">&#x2030;</entity>
        <entity name="quot">&#x22;</entity>
        <entity name="QUOT">&#x22;</entity>
        <entity name="rdquo">&#x201D;</entity>
        <entity name="rlm">&#x200F;</entity>
        <entity name="rsaquo">&#x203A;</entity>
        <entity name="rsquo">&#x2019;</entity>
        <entity name="sbquo">&#x201A;</entity>
        <entity name="Scaron">&#x160;</entity>
        <entity name="scaron">&#x161;</entity>
        <entity name="thinsp">&#x2009;</entity>
        <entity name="tilde">&#x2DC;</entity>
        <entity name="Yuml">&#x178;</entity>
        <entity name="zwj">&#x200D;</entity>
        <entity name="zwnj">&#x200C;</entity>


        <entity name="alefsym">&#x2135;</entity>
        <entity name="Alpha">&#x391;</entity>
        <entity name="alpha">&#x3B1;</entity>
        <entity name="and">&#x2227;</entity>
        <entity name="ang">&#x2220;</entity>
        <entity name="asymp">&#x2248;</entity>
        <entity name="Beta">&#x392;</entity>
        <entity name="beta">&#x3B2;</entity>
        <entity name="bull">&#x2022;</entity>
        <entity name="cap">&#x2229;</entity>
        <entity name="Chi">&#x3A7;</entity>
        <entity name="chi">&#x3C7;</entity>
        <entity name="clubs">&#x2663;</entity>
        <entity name="cong">&#x2245;</entity>
        <entity name="crarr">&#x21B5;</entity>
        <entity name="cup">&#x222A;</entity>
        <entity name="dArr">&#x21D3;</entity>
        <entity name="darr">&#x2193;</entity>
        <entity name="Delta">&#x394;</entity>
        <entity name="delta">&#x3B4;</entity>
        <entity name="diams">&#x2666;</entity>
        <entity name="empty">&#x2205;</entity>
        <entity name="Epsilon">&#x395;</entity>
        <entity name="epsilon">&#x3B5;</entity>
        <entity name="equiv">&#x2261;</entity>
        <entity name="Eta">&#x397;</entity>
        <entity name="eta">&#x3B7;</entity>
        <entity name="exist">&#x2203;</entity>
        <entity name="fnof">&#x192;</entity>
        <entity name="forall">&#x2200;</entity>
        <entity name="frasl">&#x2044;</entity>
        <entity name="Gamma">&#x393;</entity>
        <entity name="gamma">&#x3B3;</entity>
        <entity name="ge">&#x2265;</entity>
        <entity name="hArr">&#x21D4;</entity>
        <entity name="harr">&#x2194;</entity>
        <entity name="hearts">&#x2665;</entity>
        <entity name="hellip">&#x2026;</entity>
        <entity name="image">&#x2111;</entity>
        <entity name="infin">&#x221E;</entity>
        <entity name="int">&#x222B;</entity>
        <entity name="Iota">&#x399;</entity>
        <entity name="iota">&#x3B9;</entity>
        <entity name="isin">&#x2208;</entity>
        <entity name="Kappa">&#x39A;</entity>
        <entity name="kappa">&#x3BA;</entity>
        <entity name="Lambda">&#x39B;</entity>
        <entity name="lambda">&#x3BB;</entity>
        <entity name="lang">&#x2329;</entity>
        <entity name="lArr">&#x21D0;</entity>
        <entity name="larr">&#x2190;</entity>
        <entity name="lceil">&#x2308;</entity>
        <entity name="le">&#x2264;</entity>
        <entity name="lfloor">&#x230A;</entity>
        <entity name="lowast">&#x2217;</entity>
        <entity name="loz">&#x25CA;</entity>
        <entity name="minus">&#x2212;</entity>
        <entity name="Mu">&#x39C;</entity>
        <entity name="mu">&#x3BC;</entity>
        <entity name="nabla">&#x2207;</entity>
        <entity name="ne">&#x2260;</entity>
        <entity name="ni">&#x220B;</entity>
        <entity name="notin">&#x2209;</entity>
        <entity name="nsub">&#x2284;</entity>
        <entity name="Nu">&#x39D;</entity>
        <entity name="nu">&#x3BD;</entity>
        <entity name="oline">&#x203E;</entity>
        <entity name="Omega">&#x3A9;</entity>
        <entity name="omega">&#x3C9;</entity>
        <entity name="Omicron">&#x39F;</entity>
        <entity name="omicron">&#x3BF;</entity>
        <entity name="oplus">&#x2295;</entity>
        <entity name="or">&#x2228;</entity>
        <entity name="otimes">&#x2297;</entity>
        <entity name="part">&#x2202;</entity>
        <entity name="perp">&#x22A5;</entity>
        <entity name="Phi">&#x3A6;</entity>
        <entity name="phi">&#x3D5;</entity>
        <entity name="Pi">&#x3A0;</entity>
        <entity name="pi">&#x3C0;</entity>
        <entity name="piv">&#x3D6;</entity>
        <entity name="Prime">&#x2033;</entity>
        <entity name="prime">&#x2032;</entity>
        <entity name="prod">&#x220F;</entity>
        <entity name="prop">&#x221D;</entity>
        <entity name="Psi">&#x3A8;</entity>
        <entity name="psi">&#x3C8;</entity>
        <entity name="radic">&#x221A;</entity>
        <entity name="rang">&#x232A;</entity>
        <entity name="rArr">&#x21D2;</entity>
        <entity name="rarr">&#x2192;</entity>
        <entity name="rceil">&#x2309;</entity>
        <entity name="real">&#x211C;</entity>
        <entity name="rfloor">&#x230B;</entity>
        <entity name="Rho">&#x3A1;</entity>
        <entity name="rho">&#x3C1;</entity>
        <entity name="sdot">&#x22C5;</entity>
        <entity name="Sigma">&#x3A3;</entity>
        <entity name="sigma">&#x3C3;</entity>
        <entity name="sigmaf">&#x3C2;</entity>
        <entity name="sim">&#x223C;</entity>
        <entity name="spades">&#x2660;</entity>
        <entity name="sub">&#x2282;</entity>
        <entity name="sube">&#x2286;</entity>
        <entity name="sum">&#x2211;</entity>
        <entity name="sup">&#x2283;</entity>
        <entity name="supe">&#x2287;</entity>
        <entity name="Tau">&#x3A4;</entity>
        <entity name="tau">&#x3C4;</entity>
        <entity name="there4">&#x2234;</entity>
        <entity name="Theta">&#x398;</entity>
        <entity name="theta">&#x3B8;</entity>
        <entity name="thetasym">&#x3D1;</entity>
        <entity name="trade">&#x2122;</entity>
        <entity name="TRADE">&#x2122;</entity>
        <entity name="uArr">&#x21D1;</entity>
        <entity name="uarr">&#x2191;</entity>
        <entity name="upsih">&#x3D2;</entity>
        <entity name="Upsilon">&#x3A5;</entity>
        <entity name="upsilon">&#x3C5;</entity>
        <entity name="weierp">&#x2118;</entity>
        <entity name="Xi">&#x39E;</entity>
        <entity name="xi">&#x3BE;</entity>
        <entity name="Zeta">&#x396;</entity>
        <entity name="zeta">&#x3B6;</entity>

    </xsl:variable>

    <xsl:key name="d:ents" match="entity" use="@name"/>

</xsl:stylesheet>
