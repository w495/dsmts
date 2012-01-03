<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../shared/master/screen/common-page.xsl"/>

<xsl:include href="includes/areagen.xsl" />

<xsl:template name="docs-content">
    sds
    <!--    
    <xsl:call-template name="areagen">
        <xsl:with-param name="Prefix" select="'/Contacts/Details'" />
    </xsl:call-template>
    -->
    
</xsl:template>


<xsl:template match="/">
  <xsl:apply-imports/>
</xsl:template>

</xsl:stylesheet>
