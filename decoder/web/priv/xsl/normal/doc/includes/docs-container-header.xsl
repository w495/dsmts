<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [
    <!ENTITY nbsp "&#160;">
    <!ENTITY raquo  "&#187;">
    <!ENTITY laquo  "&#171;">
]>

<!--

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
    
<!-- Переопределен -->

<xsl:template name="docs-container-header">
    <xsl:choose>
        <xsl:when test="contains(/data/meta/current-path, 'News')">
            <xsl:text>Новость</xsl:text>
        </xsl:when>
        <xsl:when test="contains(/data/meta/current-path, 'Term')">
            <xsl:text>Термин</xsl:text>
        </xsl:when>
        <xsl:when test="contains(/data/meta/current-path, 'Doc')">
            <xsl:text>Документ</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            Err
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


</xsl:stylesheet> 
