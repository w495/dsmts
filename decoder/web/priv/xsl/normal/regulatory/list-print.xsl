<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../shared/master/printer/list-page.xsl"/>

<xsl:import href="../shared/widgets/dirs-list.xsl"/>
<xsl:import href="../shared/widgets/doc-body.xsl"/>

<xsl:template name="docs-container-header">
    <xsl:text>Нормативно-правовые документы</xsl:text>
</xsl:template>

<xsl:template name="docs-content">
    <div id="doc-body">
        <xsl:if test="/data/meta/is-root != 'true'">
            <article>
                <xsl:call-template name="doc-body" >
                    <xsl:with-param name="Pic"  select="false"/>
                    <xsl:with-param name="Text"  select="/data/doc/content"/>
                    <xsl:with-param name="Title" select="/data/doc/name" />
                    <xsl:with-param name="Attaches"  select="false"/>
                    <xsl:with-param name="DateTime"  select="false"/>
                    <xsl:with-param name="GoBack"  select="false"/>
                </xsl:call-template>
            </article>
        </xsl:if>
    </div>
    <div id="dirs-list">
        <xsl:call-template name="dirs-list" >
            <xsl:with-param name="Item" select="/data/dirs/item" />
            <xsl:with-param name="DirPath" select="'/Regulatory/List'" />
        </xsl:call-template>
        <xsl:text>&nbsp;</xsl:text>
        <xsl:call-template name="docs-list" >
            <xsl:with-param name="Item" select="/data/docs/item" />
            <xsl:with-param name="DocPath" select="'/Doc'" />
        </xsl:call-template>
        <xsl:text>&nbsp;</xsl:text>        
        <xsl:call-template name="dirs-attaches" >
            <xsl:with-param name="Attaches" select="/data/attaches" />
        </xsl:call-template>
    </div>
</xsl:template>


<xsl:template match="/">
  <xsl:apply-imports/>
</xsl:template>

</xsl:stylesheet>
