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
</xsl:template>

<xsl:template name="title">
    <xsl:text disable-output-escaping="yes">МЧС</xsl:text>
</xsl:template>

<!-- ====================================================================  -->
<!-- ТЕЛО -->
<!-- ====================================================================  -->

<xsl:template name="main">
	<div id="logo-container">
        <xsl:call-template name="logo-container" />
	</div>
    <div class="breakline">&nbsp;</div>
	<div id="middle-container">
        <xsl:call-template name="middle-container" />        
	</div>
    <div class="breakline">&nbsp;</div>
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
            <div>
                <xsl:text disable-output-escaping="yes">Защита населения от&nbsp;чрезвычайных ситуаций</xsl:text>   
            </div>
            <div>
                <xsl:text disable-output-escaping="yes">природного и&nbsp;техногенного характера на&nbsp;транспорте</xsl:text>
            </div>
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
    <xsl:text disable-output-escaping="yes">Нормативно-правовые документы</xsl:text>
</xsl:template>

<xsl:template id="docs-content">
    <xsl:text>&nbsp;</xsl:text>
</xsl:template>

</xsl:stylesheet>
