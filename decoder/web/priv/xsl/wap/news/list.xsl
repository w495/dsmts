<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../shared/master/root.xsl"/>


<xsl:include href="../shared/utils/tipograf.xsl" />
<xsl:include href="./includes/news-list.xsl" />

<xsl:template name="title">МЧС</xsl:template>

<xsl:template name="main">
    <div id="news-list">
        <xsl:call-template name="news-list">
            <xsl:with-param name="Item" select="/data/news/item" />
            <xsl:with-param name="NewsPath" select="'/News'" />
        </xsl:call-template>
    </div>
</xsl:template>


<xsl:template match="/">
  <xsl:apply-imports/>
</xsl:template>

</xsl:stylesheet>
