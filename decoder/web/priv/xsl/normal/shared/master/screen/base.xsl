<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [
    <!ENTITY nbsp "&#160;">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../root.xsl"/>


<!-- Самая верхняя строка с кнопками и поиском
    Далее будет переопределена в версии для слабовидящих.
-->
<xsl:include href="../../includes/screen/top-line-container.xsl" />
<xsl:include href="../../includes/screen/fade-slider.xsl" />


<!-- ====================================================================  -->
<!-- ГОЛОВА -->
<!-- ====================================================================  -->


<xsl:template name="link-css">
    <link rel="stylesheet" type="text/css" media="screen" href="/c/normal-screen-base.css" />
</xsl:template>


<!-- ====================================================================  -->
<!-- ТЕЛО -->
<!-- ====================================================================  -->

<xsl:template name="main">

</xsl:template>

<xsl:template name="main-content">
    <nav>
        <div id="top-line-container">
            <!-- Самая верхняя строка с кнопками и поиском -->
            <xsl:call-template name="top-line-container" />
        </div>
    </nav>
    <nav>
        <div id="menu-container">
            <!-- Верхнее меню с пунктами -->
            <xsl:call-template name="menu-container" />
        </div>
    </nav>
    <section>
        <div id="changeble-containers">
            <!-- Основная изменяемая часть -->
            <xsl:call-template name="changeble-containers" />
        </div>
    </section>
    <footer>
        <div id="footer-container" class="main-part">
            <!-- Подол -->
            <xsl:call-template name="footer-container" />
        </div>
    </footer>
</xsl:template>

<xsl:template name="changeble-containers">
    Основная часть.
</xsl:template>

</xsl:stylesheet>
