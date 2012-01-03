<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:include href="../../shared/utils/tipograf.xsl" />

<xsl:template name="dirs-list">
    <xsl:param name="Item"  select="/data/dirs/item" />
    <xsl:param name="DirPath" select="/TEST" />
    <xsl:choose>
        <xsl:when test="$Item">
            <section>
                <ul>
                    <xsl:for-each select="$Item">        
                        <li>
                            <a href="{$DirPath}/{id}/">
                                <xsl:call-template name="tipograf">
                                    <xsl:with-param  name="Input" select="name"/>
                                </xsl:call-template>
                            </a>
                            <span>
                                <xsl:text>&nbsp;</xsl:text>
                                <xsl:value-of select="start" />
                                <xsl:text>&nbsp;</xsl:text>
                                <xsl:value-of select="stop" />
                            </span>
                        </li> 
                    </xsl:for-each>
                </ul>
            </section>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>Сейчас нет ни одной активной конференции.</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


<xsl:template name="docs-list">
    <xsl:param name="Item"  select="/data/docs/item" />
    <xsl:param name="DocPath" select="/TEST" />
    <xsl:if test="$Item">
        <section>
            <h3>Документы:</h3>
            <ul>
                <xsl:for-each select="$Item">        
                    <li>
                        <a href="{$DocPath}/{id}/">
                            <xsl:call-template name="tipograf">
                                <xsl:with-param  name="Input" select="name"/>
                            </xsl:call-template>
                        </a>
                    </li> 
                </xsl:for-each>
            </ul>
        </section>
    </xsl:if>
</xsl:template>



</xsl:stylesheet>
