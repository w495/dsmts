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
    <nav>
        <div id="transport-container" class="main-part">
            <!-- Транспортные кнопки -->
            <xsl:call-template name="transport-container" />
        </div>
    </nav>
    <hr class="breakline"/>
    <section>
        <div id="middle-container">
            <!-- Новости и иже с ними  -->
            <xsl:call-template name="middle-container" />
        </div>
    </section>
    <hr class="breakline"/>
    <article>
        <div id="article-container" class="main-part">
            <!-- О проекте -->
            <xsl:call-template name="article-container" />
        </div>
    </article>
</xsl:template>


<!-- Серединное содержимое -->
<!-- ====================================================================  -->

<xsl:template name="middle-container">
    <div id="news-container" class="main-part">
        <div id="news-container-header" class="header">
            <h1>
                <xsl:text disable-output-escaping="yes">Новости</xsl:text>
            </h1>
        </div>
        <div id="news-buttons">
            <a href="/News/List/" class="news-button relief">
                <xsl:text disable-output-escaping="yes">читать все</xsl:text>
            </a>
            <a href="/News/Rss/" class="news-button relief">
                <xsl:text disable-output-escaping="yes">подписаться</xsl:text>
            </a>
        </div>
        <div id="news">
            <xsl:call-template name="news" />
        </div>
    </div>
</xsl:template>

<xsl:template name="news">
    <!-- Так примерно должен выглядеть сниппет новости.
        Вообще не плохо бы это все вынести в отдельный шаблон.
        Но так нагляднее. -->

</xsl:template>

<!-- О проекте -->
<!-- ====================================================================  -->
<xsl:template name="article-container">
    <span id="article-container-header" class="header">
        <xsl:text disable-output-escaping="yes">О проекте</xsl:text>
    </span>
    <div id="article">
        <xsl:call-template name="article" />
    </div>
</xsl:template>

<xsl:template name="article">
    <xsl:text disable-output-escaping="yes">Произвольный текст.</xsl:text>
</xsl:template>



</xsl:stylesheet>
