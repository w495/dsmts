<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../shared/master/spec/athorised-page.xsl"/>

<xsl:include href="includes/dirs-list.xsl" />

<xsl:template name="docs-container-header">
    <xsl:text>Онлайн-тестирование</xsl:text>
</xsl:template>

<xsl:template name="docs-content">
    <div id="dirs-list">
        <xsl:call-template name="dirs-list" >
            <xsl:with-param name="Item" select="/data/dirs/item" />
            <xsl:with-param name="DirPath" select="'/Test/Details'" />
        </xsl:call-template>
        <xsl:text>&nbsp;</xsl:text>        
        <xsl:call-template name="docs-list" >
            <xsl:with-param name="Item" select="/data/docs/item" />
            <xsl:with-param name="DocPath" select="'/Doc'" />
        </xsl:call-template>
    </div>
</xsl:template>


<xsl:template match="/">
  <xsl:apply-imports/>
</xsl:template>

</xsl:stylesheet>
