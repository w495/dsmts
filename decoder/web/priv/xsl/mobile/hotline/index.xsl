<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../shared/master/root.xsl"/>

<xsl:include  href="../shared/widgets/hotline.xsl"/>

<xsl:template name="title">
    <xsl:text>Горячая линия</xsl:text>
</xsl:template>

<xsl:template name="main">
    <div class="item">
        <xsl:call-template name="hotline"/>
    </div>
</xsl:template>


<xsl:template match="/">
  <xsl:apply-imports/>
</xsl:template>

</xsl:stylesheet>
