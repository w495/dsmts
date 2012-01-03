<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../shared/master/root.xsl"/>
<xsl:include href="../shared/utils/erlangFormatDate.xsl" />

<xsl:template name="lastBuildDate">
    <xsl:call-template name="erlangFormatPubdate">
        <xsl:with-param name="DateTime" select="/data/news/item/datatime"/>
    </xsl:call-template>
</xsl:template>

<xsl:template name="pubDate">
    <xsl:call-template name="erlangFormatPubdate">
        <xsl:with-param name="DateTime" select="/data/news/item/datatime"/>
    </xsl:call-template>
</xsl:template>


<xsl:template name="items">
    <xsl:for-each select="/data/news/item">
        <item>
            <xsl:call-template name="item" >
                <xsl:with-param name="Item" select="."/>
            </xsl:call-template>
        </item>
    </xsl:for-each>
</xsl:template>


<xsl:template name="item">
    <xsl:param name="Item" />

    <title>
        <xsl:value-of select="$Item/name" />
    </title>
    
    <description>
        <xsl:value-of select="$Item/content" />
    </description>
    
    <link>/News/<xsl:value-of select="$Item/id" /></link>
    
    <guid>
        <xsl:value-of select="$Item/id" />
    </guid>
    
    <pubDate>
        <xsl:call-template name="erlangFormatPubdate">
            <xsl:with-param name="DateTime" select="$Item/datatime"/>
        </xsl:call-template>
    </pubDate>
    
</xsl:template>



<xsl:template match="/">
  <xsl:apply-imports/>
</xsl:template>

</xsl:stylesheet>
