<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [
    <!ENTITY nbsp "&#160;">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../root.xsl"/>

<xsl:include href="../../includes/spec/top-line-container.xsl" />

<!-- ====================================================================  -->
<!-- ГОЛОВА -->
<!-- ====================================================================  -->


<xsl:template name="link-css">
    <link rel="stylesheet" type="text/css" media="all" href="/static/site-media/css/spec-base.css" />
    <link rel="stylesheet" type="text/css" media="all" href="/static/site-media/css/spec-docs.css" />
    <link rel="stylesheet" type="text/css" media="all" href="/static/site-media/css/spec-doc.css" />
    <link rel="stylesheet" type="text/css" media="all" href="/static/site-media/css/spec-search.css" />
    
    <!-- ======== -->
    <xsl:choose>
        <xsl:when test="/data/meta/spec-color = 'white'">
            <link rel="stylesheet" type="text/css" media="all" href="/static/site-media/css/spec-white.css" />
            <link rel="stylesheet" type="text/css" media="all" href="/static/site-media/css/spec-search-white.css" />
        </xsl:when>
        <xsl:when test="/data/meta/spec-color = 'black'">
            <link rel="stylesheet" type="text/css" media="all" href="/static/site-media/css/spec-black.css" />
            <link rel="stylesheet" type="text/css" media="all" href="/static/site-media/css/spec-search-black.css" />
        </xsl:when>
        <xsl:when test="/data/meta/spec-color = 'blue'">
            <link rel="stylesheet" type="text/css" media="all" href="/static/site-media/css/spec-blue.css" />
            <link rel="stylesheet" type="text/css" media="all" href="/static/site-media/css/spec-search-blue.css" />
        </xsl:when>
    </xsl:choose>
    <!-- ======== -->
    <xsl:choose>
        <xsl:when test="/data/meta/spec-variant = 'big'">
            <link rel="stylesheet" type="text/css" media="all" href="/static/site-media/css/spec-big.css" />
            <link rel="stylesheet" type="text/css" media="all" href="/static/site-media/css/spec-search-big.css" />
        </xsl:when>
        <xsl:when test="/data/meta/spec-variant = 'medium'">
            <link rel="stylesheet" type="text/css" media="all" href="/static/site-media/css/spec-medium.css" />
            <link rel="stylesheet" type="text/css" media="all" href="/static/site-media/css/spec-search-medium.css" />
        </xsl:when>
        <xsl:when test="/data/meta/spec-variant = 'small'">
            <link rel="stylesheet" type="text/css" media="all" href="/static/site-media/css/spec-small.css" />
            <link rel="stylesheet" type="text/css" media="all" href="/static/site-media/css/spec-search-small.css" />
        </xsl:when>
    </xsl:choose>
    <!-- ======== -->
</xsl:template>

<xsl:template name="link-css-adds">
    <link rel="stylesheet" type="text/css" media="all" href="/static/site-media/css/spec-base.css" />        
</xsl:template>


<!-- ====================================================================  -->
<!-- ТЕЛО -->
<!-- ====================================================================  -->

<xsl:template name="main">
    <div id="main-center">
        <xsl:call-template name="main-content" />
    </div>
</xsl:template>

<xsl:template name="main-content">
    <nav>
        <div id="top-line-container">
            <!-- Самая верхняя строка с кнопками и поиском -->
            <xsl:call-template name="top-line-container" />
        </div>
    </nav>
    <header>
        <div id="logo-container" class="main-part">
            <!-- Логотип -->
            <xsl:call-template name="logo-container" />
        </div>
    </header>
    <div class="breakline">&nbsp;</div>
    <nav>
        <div id="menu-container">
            <!-- Верхнее меню с пунктами -->
            <xsl:call-template name="menu-container" />
        </div>
    </nav>
    <div class="breakline">&nbsp;</div>
    <section>
        <div id="changeble-containers">
            <!-- Основная изменяемая часть -->
            <xsl:call-template name="changeble-containers" />
        </div>
    </section>
    <div class="breakline">&nbsp;</div>
    <footer>
        <div id="footer-container" class="main-part">
            <!-- Подол -->
            <xsl:call-template name="footer-container" />
        </div>
    </footer>
</xsl:template>

<!-- Строка с логотипом -->
<!-- ====================================================================  -->

<xsl:template name="logo-container">
        <div id="logo">
                <a id="logo-image" href="/Home/Index/">
                    <xsl:text>&nbsp;</xsl:text>
                </a>
            <div id="logo-caption">
                <xsl:text>Защита населения от&nbsp;чрезвычайных ситуаций </xsl:text>
                <xsl:text>природного и&nbsp;техногенного характера </xsl:text>
                <xsl:text>на&nbsp;транспорте</xsl:text>
            </div>
        </div>
</xsl:template>



<xsl:template name="changeble-containers">
    Основная часть.
</xsl:template>

</xsl:stylesheet>
