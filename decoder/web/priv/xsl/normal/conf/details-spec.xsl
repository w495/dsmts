<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../shared/master/spec/athorised-page.xsl"/>

<xsl:include href="includes/doc-body.xsl" />

<xsl:template name="docs-container-header">
    <xsl:text>Конференция</xsl:text>
</xsl:template>

<xsl:template name="docs-content">
    <div id="doc-body">
        <article>
            <xsl:call-template name="doc-body" >
                <xsl:with-param name="Pic"  select="/data/doc/pic_url"/>
                <xsl:with-param name="Text"  select="/data/doc/content"/>
                <xsl:with-param name="Title"  select="/data/doc/name"/>
                <xsl:with-param name="Attaches"  select="/data/attaches"/>
                <xsl:with-param name="DateTime"  select="/data/doc/datatime"/>
                <xsl:with-param name="Experts"  select="/data/experts"/>
                <xsl:with-param name="Questions"  select="/data/questions"/>
                <xsl:with-param name="CurrentPath"  select="/data/meta/current-path"/>
                <xsl:with-param name="CurId"  select="/data/doc/id"/>
            </xsl:call-template>
        </article>
    </div>
</xsl:template>

<xsl:template match="/">
  <xsl:apply-imports/>
</xsl:template>


</xsl:stylesheet>
