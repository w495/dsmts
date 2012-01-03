<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template name="hotlinegen">
    <xsl:param name="Prefix"  select="'/Contacts/Details'" />
    <xsl:variable name="Areas" select="document('hotlinegen/hotline.xml')/areas"/>
    
    <xsl:call-template name="hotlinegen-item-select">
        <xsl:with-param name="Areas" select="$Areas/area" />
        <xsl:with-param name="Prefix" select="$Prefix" />
    </xsl:call-template>
    
</xsl:template>

<xsl:template name="hotlinegen-item-select">
    <xsl:param name="Areas" />
    <xsl:param name="Prefix" />
    <select>
        <xsl:for-each select="$Areas">
            <xsl:choose>
                <xsl:when test="not(item)">
                    <option value="{$Prefix}/{code}">
                        <xsl:value-of select="name" />
                    </option>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="name" />
                    <xsl:call-template name="hotlinegen-item-option">
                        <xsl:with-param name="Items" select="item" />
                        <xsl:with-param name="Prefix" select="$Prefix" />
                        <xsl:with-param name="AreaTr" select="tr" />
                    </xsl:call-template>                        
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </select>
</xsl:template>

<xsl:template name="hotlinegen-item-option">
    <xsl:param name="Items" />
    <xsl:param name="Prefix" />
    <xsl:for-each select="$Items">        
        <option value="{$Prefix}/{code}/">
            <xsl:value-of select="name" />
        </option>
    </xsl:for-each>
</xsl:template>

<xsl:template name="hotlinegen-area">
    <xsl:param name="Areas" />
    <xsl:param name="Prefix" />
    <ul>
        <xsl:for-each select="$Areas">        
            <li id="areagen-area-{tr}">
                <xsl:choose>
                    <xsl:when test="not(item)">
                        <a href="{$Prefix}/{code}">
                            <xsl:value-of select="name" />
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="name" />
                        <xsl:call-template name="hotlinegen-item">
                            <xsl:with-param name="Items" select="item" />
                            <xsl:with-param name="Prefix" select="$Prefix" />
                            <xsl:with-param name="AreaTr" select="tr" />
                        </xsl:call-template>                        
                    </xsl:otherwise>
                </xsl:choose>
            </li> 
        </xsl:for-each>
    </ul>
</xsl:template>

<xsl:template name="hotlinegen-item">
    <xsl:param name="Items" />
    <xsl:param name="Prefix" />
    <ul>
        <xsl:for-each select="$Items">        
            <li>
                <a href="{$Prefix}/{code}/">
                    <xsl:value-of select="name" />
                </a>
            </li> 
        </xsl:for-each>
    </ul>
</xsl:template>

</xsl:stylesheet>
