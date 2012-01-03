<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [
    <!ENTITY nbsp "&#160;">
    <!ENTITY raquo  "&#187;">
    <!ENTITY laquo  "&#171;">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="base.xsl"/>

<!-- ====================================================================  -->
<!-- ГОЛОВА -->
<!-- ====================================================================  -->

<xsl:template name="link-css">    
    <link rel="stylesheet" type="text/css" media="all"  href="/static/site-media/css/screen-base.css" />
	<link rel="stylesheet" type="text/css" media="all"  href="/static/site-media/css/screen-logo-flag.css" />
	<link rel="stylesheet" type="text/css" media="all"  href="/static/site-media/css/screen-docs.css" />
	<link rel="stylesheet" type="text/css" media="all"  href="/static/site-media/css/screen-game.css" />
    <link rel="stylesheet" type="text/css" media="all" href="/static/site-media/css/screen-news-list.css" />
</xsl:template>

<xsl:template name="title">
    <xsl:call-template name="docs-container-header" />
</xsl:template>
<!-- ====================================================================  -->
<!-- ТЕЛО -->
<!-- ====================================================================  -->

<!-- Основная изменяемая часть  -->
<xsl:template name="changeble-containers">
    <div id="logo-container" class="main-part">
        <xsl:call-template name="logo-container" />
    </div>
    <div id="middle-container">
        <!-- Новости и иже с ними  -->
        <xsl:call-template name="middle-container" />
    </div>
    <div id="bottom-banner-container" class="main-part" >
        <xsl:call-template name="bootom-banner-container" />
    </div>
</xsl:template>

<!-- Строка с логотипом -->
<!-- ====================================================================  -->
<xsl:template name="logo-container">
    <div id="logo-flag">
        <div id="logo">
            <header>
                <a href="/Home/Index/">
                    <img id="logo-image"  src="/static/site-media/images/logo-trans.png" alt="МЧС России"/>
                </a>
                <div id="logo-caption">Защита населения от&nbsp;чрезвычайных ситуаций природного и&nbsp;техногенного характера на&nbsp;транспорте</div>
            </header>
        </div> 
        <div id="transport-container">
            <!-- Транспортные кнопки -->
            <xsl:call-template name="transport-container" />
        </div> 
    </div>
</xsl:template>

<!-- Строка с логотипом -->
<!-- ====================================================================  -->
<xsl:template name="middle-container">
    <div id="docs-container" class="main-part">
        <div id="docs-container-header" class="header">
            <xsl:call-template name="docs-container-header" />
        </div>
        <div id="game-container"> 
            <xsl:call-template name="game-container" />
        </div>
        <div id="docs-container-search" >
            <div id="docs-printer-holder"> 
                <div id="docs-printer">&nbsp;</div>
                <span>&nbsp;</span>
                <a href="?print=1">версия для печати</a>
            </div>
        </div> 
        <div id="docs-content"> 
            <xsl:call-template name="docs-content" />
        </div>
    </div>
</xsl:template>

<xsl:template name="docs-container-header">
    Название
</xsl:template>

<!-- Нормативно-правовые документы    -->

<xsl:template name="docs-content">
    &nbsp; <!-- EMPTY -->
</xsl:template>

<xsl:template name="foot-scripts">
    <script type="text/javascript" src="/static/site-media/js/jquery.min.js">&nbsp;</script>
    <script type="text/javascript" src="/static/site-media/js/banners.js">&nbsp;</script>
    <script type="text/javascript" src="/static/site-media/js/list-page.js">&nbsp;</script>
</xsl:template>

</xsl:stylesheet>
