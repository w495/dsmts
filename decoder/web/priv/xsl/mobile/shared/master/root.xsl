<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>
<!--
    Это основной шаблон для вывода на экран монитора.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output
    omit-xml-declaration="yes"
    method="html"
    indent="yes"
    encoding="utf-8"
/>


<!-- ====================================================================  -->
<!-- <HTML></HTML> -->
<!-- ====================================================================  -->


<xsl:template match="/" name="root">
<xsl:text disable-output-escaping="yes"><![CDATA[﻿<!doctype html>]]></xsl:text>
<html>
    <head xml:lang="ru">
        <xsl:call-template name="head" />
    </head>
    <body xml:lang="ru">
        <xsl:call-template name="body" />
    </body>
    <xsl:call-template name="foot-scripts" />
</html>
</xsl:template>

<!-- ====================================================================  -->
<!-- ГОЛОВА -->
<!-- ====================================================================  -->

<xsl:template name="head">
    <xsl:call-template name="viewport" />
    <xsl:call-template name="meta" />
        
    <title xmlns="http://www.w3.org/1999/xhtml" >
        <xsl:call-template name="title" />
    </title>
    
    <xsl:call-template name="links" />
    <xsl:call-template name="head-scripts" />
</xsl:template>

<!-- МETA -->
<!-- ====================================================================  -->
<xsl:template name="meta">
    <meta http-equiv="Content-Type" content="text/html" charset="UTF-8" />
</xsl:template>

<!-- viewport -->
<!-- ====================================================================  -->
<xsl:template name="viewport">
    <!--
    <meta name="viewport" content="initial-scale=0.5, width=device-width,
        target-densitydpi=device-dpi, minimum-scale=0.1, user-scalable=no" />
    -->
    
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
</xsl:template>

<!-- links -->
<!-- ====================================================================  -->
<xsl:template name="links">
    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    
    <xsl:call-template name="link-css" />
</xsl:template>

<xsl:template name="link-css">
    <link rel="stylesheet" type="text/css" media="all" href="/static/site-media/css/mobile/base.css" />
</xsl:template>


<xsl:template name="head-scripts">
    <script src="http://code.jquery.com/jquery-1.4.4.js">&nbsp;</script>
    <script type="application/javascript" src="/static/site-media/js/mobile/iscroll.js">&nbsp;</script>
    <script type="application/javascript" src="/static/site-media/js/mobile/mini.js">&nbsp;</script>
    <script type="application/javascript" src="/static/site-media/js/mobile/init.js">&nbsp;</script>
    <script src="//www.google.ru/jsapi" type="text/javascript">&nbsp;</script>
    <script type="text/javascript" src="/static/site-media/js/mobile/google-search-get.js">&nbsp;</script>
</xsl:template>

<!-- ====================================================================  -->
<!-- ТЕЛО -->
<!-- ====================================================================  -->

<xsl:template name="body">
<div id="user">
    <xsl:call-template name="header" />
    <div id="content">
        <div id="scroller">
            <xsl:call-template name="content" />
        </div>
    </div>
    <xsl:call-template name="footer" />
</div>
</xsl:template>

<xsl:template name="header">
    <div id="head-container">
        <div id="top-line">
            <div>
                <xsl:text disable-output-escaping="yes">Защита населения от&nbsp;чрезвычайных ситуаций</xsl:text>
                <br />
                <xsl:text disable-output-escaping="yes" >природного и&nbsp;техногенного характера на&nbsp;транспорте</xsl:text>
            </div>

            <form id="search-form" action="/Mobile/Search/" method="POST">
                <xsl:choose>
                    <xsl:when test="not(/data/meta/search-param) or (/data/meta/search-param = '')">
                        <input id="search-field"  type="text" size="32" name="q" />
                    </xsl:when>
                    <xsl:otherwise>
                        <input id="search-field" type="text" size="32" name="q"  value="{/data/meta/search-param}"/>
                    </xsl:otherwise>
                </xsl:choose>
                
                <input id="search-submitter" type="submit" name="submiter" value="искать" />
            </form>

        </div>
    </div>
</xsl:template>

<xsl:template name="content">
		<div id="logo-line">
			<img src="/static/site-media/images/mobile/logo-trans.png" alt="МЧС России" />
		</div>
		<div class="head-line">
			<xsl:text>Виды транспорта</xsl:text>
		</div>
        
        <a href="/Mobile/Transport/Surface/" class="item1 item-link">
            <div class="itev_txt">
                <xsl:text>Наземный транспорт</xsl:text>
                <div style="height:2px;">&nbsp;</div>
            </div>
        </a>
        
        <a href="/Mobile/Transport/Air/" class="item2 item-link">
            <div class="itev_txt">
                <xsl:text>Воздушный транспорт</xsl:text>
                <div style="height:2px;">&nbsp;</div>
            </div>
        </a>
        
        <a href="/Mobile/Transport/Water/" class="item1 item-link">
            <div class="itev_txt">
                <xsl:text>Водный транспорт</xsl:text>
                <div style="height:2px;">&nbsp;</div>
            </div>
        </a>
        <xsl:call-template name="main" />
</xsl:template>


<xsl:template name="footer">
<div id="footer">
    <table width="100%" height="90" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td align="center">
                <a href="/Mobile/"><img src="/static/site-media/images/mobile/home.png" width="58" height="90"/>&nbsp;</a>
            </td>
            <td align="center">
                <a href="/Mobile/News/List/">
                    <img src="/static/site-media/images/mobile/news.png" width="58" height="90"/>
                </a>
            </td>
            <td align="center">
                <a href="/Mobile/">
                    <img src="/static/site-media/images/mobile/menu.png" width="58" height="90" />
                </a>
            </td>
        </tr>
    </table>
</div>

</xsl:template>    

<!-- ====================================================================  -->
<!-- ХВОСТ -->
<!-- ====================================================================  -->

<xsl:template name="foot-scripts">

</xsl:template>


</xsl:stylesheet>
