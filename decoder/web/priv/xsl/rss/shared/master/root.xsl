<?xml version="1.0" encoding="utf-8"?>
<!--
    Это основной шаблон для вывода RSS
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:date="http://exslt.org/dates-and-times"
    extension-element-prefixes="date"
    >

<xsl:output
    method="xml"
    indent="yes"
    encoding="utf-8"
/>

<xsl:strip-space elements="*"/>


<!-- ====================================================================  -->
<!-- <HTML></HTML> -->
<!-- ====================================================================  -->

<xsl:template match="/" name="root">
<rss version="2.0">
<channel>
        <title>МЧС лента новостей</title>
        <description>Защита населения от чрезвычайных ситуаций природного и техногенного характера на транспорте</description>
        <link>/News</link>
        <lastBuildDate>
            <xsl:call-template name="lastBuildDate" />
        </lastBuildDate>
        <pubDate>
            <xsl:call-template name="pubDate" />
        </pubDate>
        <ttl>1800</ttl>
        <xsl:call-template name="items" />
</channel>
</rss>
</xsl:template>

<xsl:template name="lastBuildDate">
    Mon, 06 Sep 2010 00:01:00 +0000
</xsl:template>

<xsl:template name="pubDate">
    Mon, 06 Sep 2010 00:01:00 +0000
</xsl:template>

</xsl:stylesheet>
