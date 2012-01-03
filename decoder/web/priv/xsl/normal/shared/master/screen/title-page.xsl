<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [
    <!ENTITY nbsp "&#160;">
    <!ENTITY raquo  "&#187;">
    <!ENTITY laquo  "&#171;">
    <!ENTITY bull     "&#8226;"> 
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="base.xsl"/>

<!-- ====================================================================  -->
<!-- ГОЛОВА -->
<!-- ====================================================================  -->


<!-- ====================================================================  -->
<!-- ТЕЛО -->
<!-- ====================================================================  -->

<!-- Основная изменяемая часть  -->
<xsl:template name="changeble-containers">
    <header>
        <div id="logo-container" class="main-part">
            <!-- Логотип -->
                <xsl:call-template name="logo-container" />
        </div>
    </header>
    <nav>
        <div id="transport-container" class="main-part">
            <!-- Транспортные кнопки -->
            <xsl:call-template name="transport-container" />
        </div>
    </nav>
    <section>
        <div id="middle-container">
            <!-- Новости и иже с ними  -->
            <xsl:call-template name="middle-container" />
        </div>
    </section>
    <article>
        <div id="article-container" class="main-part">
            <!-- О проекте -->
                <xsl:call-template name="article-container" />
        </div>
    </article>
    <article>
        <div id="bottom-banners-container" class="main-part">
            <!-- При участии -->
                <xsl:call-template name="bottom-banners-container" />
        </div>
    </article>
</xsl:template>

<!-- Строка с логотипом -->
<!-- ====================================================================  -->

<xsl:template name="logo-container">
        <div id="logo">
                <img id="logo-image"  src="/static/site-media/images/logo-trans.png" 
                    alt="МЧС России"/>
                <div id="logo-caption">
                    <xsl:text disable-output-escaping="yes">Защита населения от&nbsp;чрезвычайных ситуаций природного </xsl:text>
                    <xsl:text disable-output-escaping="yes">и&nbsp;техногенного характера на&nbsp;транспорте</xsl:text>
                </div>
        </div>
        <div id="slide-show-holder">
            <xsl:call-template name="fade-slider" />
        </div>
</xsl:template>


<!-- Серединное содержимое -->
<!-- ====================================================================  -->

<xsl:template name="middle-container">
    <div id="news-container" class="main-part">
            <div id="news-container-header" class="header">
                <h1>Новости</h1>
            </div>
            <div id="news-buttons">
                <a href="/News/List/" class="news-button">читать все</a>
                <a href="/News/Rss/" class="news-button">подписаться</a>
            </div>
            <div id="news">
                <xsl:call-template name="news" />
            </div>
    </div>
    <div id="game-container-home-index">
        <xsl:call-template name="game-container" />
    </div>
</xsl:template>

<xsl:template name="news">
    <!-- Так примерно должен выглядеть сниппет новости.
        Вообще не плохо бы это все вынести в отдельный шаблон.
        Но так нагляднее. -->
    <div class="news-snippet" id="news-{generate-id(id)}">
        <div class="snippet-picture">
            <a href="/news/{id}">
                <img src="/static/site-media/content/thumb_cosmo-filre.jpg" alt="{name}" />
            </a>
        </div>
        <div class="snippet-header">
            <a href="/news/{id}">
                <xsl:value-of select="name" />
            </a>
        </div>
        <div class="snippet-text">
            <xsl:value-of select="content" />
        </div>
        <div class="snippet-date">
            <span>
                <xsl:value-of select="datatime" />
            </span>
        </div>
    </div>
</xsl:template>

<!-- О проекте -->
<!-- ====================================================================  -->
<xsl:template name="article-container">
        <span id="article-container-header" class="header">
            <h1>
                <xsl:text disable-output-escaping="yes">О проекте</xsl:text>
            </h1>
        </span>
        <div id="article">
            <xsl:call-template name="article" />
        </div>
</xsl:template>

<xsl:template name="article">
    <xsl:text disable-output-escaping="yes">Произвольный текст.</xsl:text>
</xsl:template>


<!-- При участии -->
<!-- ====================================================================  -->
<xsl:template name="bottom-banners-container">
        <span id="bottom-banners-header" class="header">
            <h1>
                <xsl:text disable-output-escaping="yes">При участии:</xsl:text>
            </h1>
        </span>
        <div id="bottom-banners">
            <div id="bottom-banner-container" >
                <xsl:call-template name="bootom-banner-container" />
            </div>
        </div>
</xsl:template>

<xsl:template name="foot-scripts">
    <script type="text/javascript" src="/static/site-media/js/jquery.min.js">&nbsp;</script>
    <script type="text/javascript" src="/static/site-media/js/slider.js">&nbsp;</script>
    <script type="text/javascript" src="/static/site-media/js/banners.js">&nbsp;</script>
    <script type="text/javascript" src="/static/site-media/js/title-page.js">&nbsp;</script>
</xsl:template>


</xsl:stylesheet>
