<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../shared/master/spec/common-page.xsl"/>

<xsl:include  href="../shared/widgets/doc-body.xsl"/>
<xsl:include href="includes/docs-container-header.xsl" />


<xsl:template name="docs-content">
    <div id="doc-body"> 
        <article>
            <xsl:call-template name="doc-body" >
                <xsl:with-param name="Text"  select="/data/doc/content"/>
                <xsl:with-param name="Title"  select="/data/doc/name"/>
                <xsl:with-param name="Attaches"  select="/data/attaches"/>
                <xsl:with-param name="DateTime"  select="/data/doc/datatime"/>
            </xsl:call-template>
        </article>
    </div>
</xsl:template>


<xsl:template match="/">
  <xsl:apply-imports/>
</xsl:template>

</xsl:stylesheet>
