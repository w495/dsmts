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
    <link rel="stylesheet" type="text/css" media="all" href="/static/site-media/css/print-base.css" />
    <link rel="stylesheet" type="text/css" media="all" href="/static/site-media/css/print-search.css" /> 
</xsl:template>

<xsl:template name="title">МЧС: печать документа</xsl:template>

<!-- ====================================================================  -->
<!-- ТЕЛО -->
<!-- ====================================================================  -->

<xsl:template name="main">
	<div id="logo-container">
        <xsl:call-template name="logo-container" />
	</div>
	<div id="middle-container">
        <xsl:call-template name="middle-container" />        
	</div>
	<div id="footer-container">
        <xsl:call-template name="footer-container" />
	</div> 
</xsl:template>

<!-- Строка с логотипом -->
<!-- ====================================================================  -->
<xsl:template name="logo-container">
    <div id="logo-line"> 
        <div id="logo"> 
            <img id="logo-image"  src="/static/site-media/images/logo-trans-bw.png" alt="МЧС России"/> 
        </div> 
        <div id="logo-caption"> 
            <div>Защита населения от&nbsp;чрезвычайных ситуаций</div>
            <div>природного и&nbsp;техногенного характера на&nbsp;транспорте</div>
        </div>
    </div> 
</xsl:template>


<xsl:template name="middle-container">
    <div id="docs-container" class="main-part">
		<span id="docs-container-header">
            <xsl:call-template name="docs-container-header" />
        </span>        
        <div id="docs-content">
            <xsl:call-template name="docs-content" />
		</div>
    </div>
</xsl:template>

<xsl:template name="docs-container-header">
    <xsl:text>&nbsp;</xsl:text>
</xsl:template>

<xsl:template id="docs-content">
    <xsl:text>&nbsp;</xsl:text>
</xsl:template>

<xsl:template name="foot-scripts">
    <script src="//www.google.ru/jsapi" type="text/javascript">&nbsp;</script>
    <script type="text/javascript" src="/static/site-media/js/google-search-get.js">&nbsp;</script>
</xsl:template>

</xsl:stylesheet>
