<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>
<!--
    Это основной шаблон для вывода на экран монитора.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="html" indent="yes" />

<!-- ====================================================================  -->
<!-- <HTML></HTML> -->
<!-- ====================================================================  -->


<xsl:template match="/" name="root">
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
</xsl:template>

<!-- МETA -->
<!-- ====================================================================  -->
<xsl:template name="meta">
    <xsl:call-template name="meta-http-equiv" />
    <xsl:call-template name="meta-oth" />
</xsl:template>

<xsl:template name="meta-http-equiv">
    <meta http-equiv="Content-Type" content="text/html" charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />    
</xsl:template>

<xsl:template name="meta-oth">
    <meta name="author" content="TvZavr Team" />
    <meta name="description" content="" />
</xsl:template>

<!-- viewport -->
<!-- ====================================================================  -->
<xsl:template name="viewport">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
</xsl:template>

<!-- links -->
<!-- ====================================================================  -->
<xsl:template name="links">
    <link rel="icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="shortcut icon" href="/static/site-media/favicon.ico" />
    
    <xsl:call-template name="link-css" />
</xsl:template>

<xsl:template name="link-css">
    <link rel="stylesheet" type="text/css" media="all" href="/static/site-media/css/wap/base.css" />
</xsl:template>


<!-- ====================================================================  -->
<!-- ТЕЛО -->
<!-- ====================================================================  -->

<xsl:template name="body">
    <xsl:call-template name="menu" />
    <xsl:call-template name="main" />
    <xsl:call-template name="footer" />
</xsl:template>

<xsl:template name="menu">
	<div id="header">
		<xsl:text>Защита населения от&nbsp;чрезвычайных ситуаций природного </xsl:text>
        <br/>
		<xsl:text>и&nbsp;техногенного характера на&nbsp;транспорте</xsl:text>
	</div>
	<div id="transport">
		<div class="header"><h1>Виды транспорта</h1></div>
		<div class="even"><a href="/Wap/Transport/Surface/" class="" id=""><xsl:text>Наземный транспорт</xsl:text></a></div>
		<div class="odd"><a href="/Wap/Transport/Air/" class="" id=""><xsl:text>Воздушный транспорт</xsl:text></a></div>
		<div class="even"><a href="/Wap/Transport/Water/" class="" id=""><xsl:text>Водный транспорт</xsl:text></a></div>
	</div>
	<div id="menu">
		<div class="header"><h1><xsl:text>Главное меню</xsl:text></h1></div>
		<div class="odd"><a href="/Wap/Home/Index/" class="" id=""><xsl:text>Главная</xsl:text></a></div>
        <div class="even"><a href="/Wap/News/List/" class="" id=""><xsl:text>Новости</xsl:text></a></div>
		<div class="odd"><a href="/Wap/Regulatory/List/" class="" id=""><xsl:text>Нормативно правовые документы</xsl:text></a></div>
		<div class="even"><a href="/Wap/Secure/List/" class="" id=""><xsl:text>Безопасность на транспорте</xsl:text></a></div>
        <div class="odd"><a href="/Wap/Contacts/List/" class="" id=""><xsl:text>Контакты</xsl:text></a></div>
        <div class="even"><a href="/Wap/Hotline/Index/" class="" id=""><xsl:text>Горячая линия</xsl:text></a></div>
		<div class="odd"><a href="/Wap/Terms/List/" class="" id=""><xsl:text>Термины</xsl:text></a></div>
        
        <!--
		<div class="even"><a href="#" class="" id=""><xsl:text>Онлайн тестирование</xsl:text></a></div>
        -->
	</div>
</xsl:template>

<xsl:template name="main">

</xsl:template>

<xsl:template name="footer">
	<div id="footer">
		<xsl:text>Copyright "МЧС России", 2010</xsl:text>
	</div>
</xsl:template>    

<!-- ====================================================================  -->
<!-- ХВОСТ -->
<!-- ====================================================================  -->

<xsl:template name="foot-scripts">

</xsl:template>


</xsl:stylesheet>
