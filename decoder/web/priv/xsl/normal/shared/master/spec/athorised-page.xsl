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

<xsl:template name="title">
    <xsl:text disable-output-escaping="yes">МЧС</xsl:text>
</xsl:template>
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
    <div id="middle-container">
        <!-- Новости и иже с ними  -->
        <xsl:call-template name="middle-container" />
    </div>
</xsl:template>

<!-- Строка с логотипом -->
<!-- ====================================================================  -->
<xsl:template name="middle-container">
    <div id="docs-container" class="main-part">
        <div id="docs-container-header" class="header">
            <h1>
                <xsl:call-template name="docs-container-header" />
            </h1>
        </div>
        <div id="athorise-container">
            <xsl:call-template name="athorise-container" />
        </div>
        <a href="?print=1" class="relief" id="docs-printer" >
            <xsl:text disable-output-escaping="yes">версия для печати</xsl:text>
        </a>   
        <div id="docs-content"> 
            <xsl:call-template name="docs-content" />
        </div>
    </div>
</xsl:template>

<xsl:template name="docs-container-header">
    Нормативы:
</xsl:template>


<!-- Нормативно-правовые документы    -->
<xsl:template name="docs-content">
    &nbsp; <!-- EMPTY -->
</xsl:template>

<xsl:template name="foot-scripts">
    <script type="text/javascript" src="/static/site-media/js/jquery.min.js">&nbsp;</script> 
    <script type="text/javascript" src="/static/site-media/js/login.js">&nbsp;</script>
    <script type="text/javascript" src="/static/site-media/js/banners.js">&nbsp;</script>
    <script type="text/javascript" src="/static/site-media/js/authorised-page.js">&nbsp;</script>
</xsl:template>

</xsl:stylesheet>
