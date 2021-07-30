<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output omit-xml-declaration="yes" method="text" encoding="utf-8"/>
    <xsl:strip-space elements="*"/>
    
     <xsl:template match="TEI">
       [
        <xsl:for-each select="facsimile/surface/*">
            <xsl:apply-templates/>
        
        </xsl:for-each>
       ] 
    
       </xsl:template> 
   
    
    <xsl:template match="zone">
        <xsl:variable name="id">
            <xsl:value-of select="@xml:id"/>
        </xsl:variable>
        {
            "type":"Annotation",
            "@context": "http://www.w3.org/ns/anno.jsonld",
            "motivation": "commenting",
            "id": "<xsl:value-of select="$id"/>",
        <xsl:for-each select="/TEI/text/body/div/ab/lb">
            <xsl:if test="substring-after(@facs,'#') = $id">
                "body":[
                {
                "type": "TextualBody",
                "value": "<xsl:value-of select="normalize-space(following-sibling::text()[1])" disable-output-escaping="yes"/>",
                "purpose": "commenting",
                "creator": { "id": "http://www.example.com/rainer", "name": "rainer" },
                "created": "2021-04-20T15:05:45.250Z",
                "modified": "2021-04-20T15:05:45.613Z"
                }
                ],
            </xsl:if>
        </xsl:for-each>
            
       "target": {
       "source":"",
       "selector":
           { 
           "type":"SvgSelector",
           "value":"<xsl:text disable-output-escaping="yes">&lt;svg&gt;&lt;polygon points=\"</xsl:text><xsl:value-of select="@points"/><xsl:text>\"&gt;&lt;/polygon&gt;&lt;/svg&gt;</xsl:text>"
            }
       }
       }
       <xsl:if test="following::zone">,</xsl:if>
    </xsl:template>
    
    
    <xsl:template match="text()"/>
    

</xsl:stylesheet>