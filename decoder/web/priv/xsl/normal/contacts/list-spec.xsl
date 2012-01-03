<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../shared/master/spec/common-page.xsl"/>

<xsl:include href="../shared/widgets/areagen.xsl" />

<xsl:template name="docs-container-header">
    <xsl:text>Контакты</xsl:text>
</xsl:template>

<xsl:template name="docs-content">
    <section>
        <div id="doc-body-text">                    
            <xsl:call-template name="areagen">
                <xsl:with-param name="Prefix" select="'/Contacts/Details'" />
            </xsl:call-template>
        </div>
    </section>
</xsl:template>


<xsl:template match="/">
  <xsl:apply-imports/>
</xsl:template>

</xsl:stylesheet>
