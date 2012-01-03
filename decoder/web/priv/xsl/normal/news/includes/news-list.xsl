<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:include href="../../shared/utils/erlangFormatDate.xsl" />

<xsl:include href="../../shared/widgets/simple-pager.xsl" />

<xsl:template name="news-list">
    <xsl:param name="Item" />
    <xsl:param name="NewsPath"  />
    <xsl:param name="Spec" select="'false'" />
    <xsl:param name="DefaultPicture" select="default"/>
    
    <xsl:call-template name="news-prev-next" />
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
                <div class="snippet-body">
                    <div class="snippet-date">
                        <span>
                            <xsl:call-template name="erlangFormatDateTime">
                                  <xsl:with-param name="DateTime" select="datatime"/>
                            </xsl:call-template>                    
                        </span>
                    </div>
                    <div class="snippet-header">
                        <a href="{$NewsPath}/{id}/">
                            <xsl:value-of select="name" />
                        </a>
                    </div>            
                    <div class="snippet-text">
                        <xsl:call-template name="tipograf">
                            <xsl:with-param  name="Input" select="content"/>
                        </xsl:call-template>
                    </div>
                </div>
            </li>
        </xsl:for-each>
    </ul>
    <xsl:if test="$Item">
        <xsl:call-template name="news-prev-next" />
    </xsl:if>
</xsl:template>


<xsl:template name="news-prev-next">
    <xsl:param name="LinkPathPreffix" select="/data/meta/self-parent-path" />
    
    <ul class="news-prev-next">
        <li class="news-prev-next-item">
            <xsl:choose>
                <xsl:when test="/data/meta/prev-id != 'undefined'">
                    <a href="{$LinkPathPreffix}{/data/meta/prev-id}/">
                        <xsl:text>предыдущая</xsl:text>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <a href="javascript:void(0)">  
                        <xsl:text>предыдущая</xsl:text>
                    </a>
                </xsl:otherwise>
            </xsl:choose>    
        </li>
        <li class="news-prev-next-item">
            <xsl:choose>
                <xsl:when test="/data/meta/next-id &lt; (/data/meta/pages + 1)">
                    <a href="{$LinkPathPreffix}{/data/meta/next-id}/">
                        <xsl:text>следующая</xsl:text>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <a href="javascript:void(0)">  
                        <xsl:text>следующая</xsl:text>
                    </a>
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </ul>
    
    <xsl:call-template name="simple-pager">
        <xsl:with-param name="Current" select="/data/meta/cur-id"/>
        <xsl:with-param name="Total" select="/data/meta/pages + 1"/>
        <xsl:with-param name="LinkPathPreffix" select="$LinkPathPreffix" />
        <xsl:with-param name="Width" select="10" />
    </xsl:call-template>

</xsl:template>



</xsl:stylesheet>
