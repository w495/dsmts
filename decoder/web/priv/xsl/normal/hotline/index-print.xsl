<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../shared/master/printer/common-page.xsl"/>

<xsl:include  href="../shared/widgets/hotline.xsl"/>

<xsl:template name="title">
    <xsl:text>Горячая линия</xsl:text>
</xsl:template>

<xsl:template name="docs-container-header">
    <xsl:text>Горячая линия</xsl:text>
</xsl:template>

<xsl:template name="docs-content">
    <div id="doc-body">
        <xsl:call-template name="hotline">
            <xsl:with-param name="Visible" select="'true'" />
        </xsl:call-template>
    </div>
</xsl:template>

<xsl:template match="/">
  <xsl:apply-imports/>
</xsl:template>

</xsl:stylesheet>
