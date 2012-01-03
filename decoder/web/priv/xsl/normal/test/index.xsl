<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../shared/master/screen/athorised-page.xsl"/>

<xsl:include href="includes/test-body.xsl" />

<xsl:template name="docs-container-header">
    <xsl:text>Он-лайн тестрование</xsl:text>
</xsl:template>

<xsl:template name="docs-content">
    <div id="test-body">
        <xsl:call-template name="test-body" />
    </div>
</xsl:template>

<xsl:template match="/">
  <xsl:apply-imports/>
</xsl:template>

</xsl:stylesheet>
