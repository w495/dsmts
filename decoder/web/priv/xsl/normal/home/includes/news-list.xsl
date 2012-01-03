<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:include href="../../shared/utils/erlangFormatDate.xsl" />


<xsl:template name="news-list">
    <xsl:param name="Item" />
    <xsl:param name="NewsPath"  select="'/News'" />
    <xsl:param name="Spec" select="'false'" />
    <xsl:param name="DefaultPicture" select="default"/>

    <ul>
        <xsl:for-each select="$Item">
            <li class="news-snippet" id="news-{generate-id(id)}">
                <xsl:choose>
                    <xsl:when test="$Spec  != 'true'">
                        <!-- В специальном представлении,
                             никакая snippet-picture вообще не нужна. -->
                        <div class="snippet-picture">
                            <a href="{$NewsPath}/{id}/">
                                <xsl:choose>
                                    <xsl:when test="(pic_url = '')">
                                        <img src="{$DefaultPicture}" alt="{name}" />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <img src="/{pic_url}" alt="{name}" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </a>
                        </div>
                    </xsl:when>
                </xsl:choose>
                <div class="snippet-header">
                    <a href="{$NewsPath}/{id}/">
                        <xsl:call-template name="tipograf">
                            <xsl:with-param  name="Input" select="name"/>
                        </xsl:call-template>
                    </a>
                </div>            
                <div class="snippet-text">
                    <xsl:call-template name="tipograf">
                        <xsl:with-param  name="Input" select="content"/>
                    </xsl:call-template>
                </div>
                <div class="snippet-date">
                    <span>
                        <xsl:call-template name="erlangFormatDateTime">
                              <xsl:with-param name="DateTime" select="datatime"/>
                        </xsl:call-template>                    
                    </span>
                </div>
            </li>
        </xsl:for-each>
    </ul>
</xsl:template>

</xsl:stylesheet>
