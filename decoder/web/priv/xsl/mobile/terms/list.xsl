<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../shared/master/root.xsl"/>

<xsl:include href="includes/leters-list.xsl" /> 
<xsl:include href="includes/terms-list.xsl" /> 


<xsl:template name="title">
    <xsl:choose>
        <xsl:when test="contains(/data/meta/current-path, 'Water')">
            <xsl:text>Термины водного транспорта</xsl:text>
        </xsl:when>
        <xsl:when test="contains(/data/meta/current-path, 'Air')">
            <xsl:text>Термины воздушного транспорта</xsl:text>
        </xsl:when>
        <xsl:when test="contains(/data/meta/current-path, 'Surface')">
            <xsl:text>Термины наземного транспорта</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>Термины</xsl:text>      
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="main">
    <div id="leters-list"> 
        <xsl:call-template name="leters-list">
            <xsl:with-param name="CurrentPath" select="/data/meta/current-path"/>
            <xsl:with-param name="Leters" select="/data/leters"/>
        </xsl:call-template>
    </div>
    <div id="terms-list"> 
        <xsl:call-template name="terms-list" >
            <xsl:with-param name="ItemParentPath" select="concat('/Mobile', /data/meta/item-parent-path)" />
            <xsl:with-param name="Leters" select="/data/leters"/>
        </xsl:call-template>
    </div>
</xsl:template>


<xsl:template match="/">
  <xsl:apply-imports/>
</xsl:template>

</xsl:stylesheet>
