<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../shared/master/printer/common-page.xsl"/>
<xsl:import href="../shared/widgets/doc-body.xsl"/>

<xsl:template name="docs-container-header">
    <xsl:text>Виды транспорта</xsl:text>
</xsl:template>

<xsl:template name="docs-content">
    <div id="doc-body">
        <xsl:call-template name="doc-body" >
            <xsl:with-param name="Text"  select="/data/doc/content"/>
            <xsl:with-param name="Title"  select="/data/doc/name"/>
            <xsl:with-param name="Attaches"  select="/data/attaches"/>
            <xsl:with-param name="DateTime"  select="/data/doc/datatime"/>
            <xsl:with-param name="PrinterFlag"  select="'true'"/>
        </xsl:call-template>
    </div>
</xsl:template>


<xsl:template match="/">
  <xsl:apply-imports/>
</xsl:template>

</xsl:stylesheet>
