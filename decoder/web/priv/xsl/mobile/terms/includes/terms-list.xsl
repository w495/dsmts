<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:include href="../../shared/utils/toCaseVariant.xsl" />

<xsl:template name="terms-list">
    <xsl:param name="ItemParentPath" select="/data/meta/item-parent-path"/>
    <xsl:param name="Terms" select="/data/terms"/>
    
    <ul id="term-list"> 
        <xsl:for-each select="$Terms/item">
            <xsl:sort select="name" data-type="text" order="ascending" case-order="upper-first"/>
            <li>
                <a href="{concat($ItemParentPath, id)}/">
                    <xsl:call-template name="toCapitlize">
                          <xsl:with-param name="Text" select="name"/>
                    </xsl:call-template>
                </a>
            </li> 
        </xsl:for-each>
    </ul>
</xsl:template>

</xsl:stylesheet>
