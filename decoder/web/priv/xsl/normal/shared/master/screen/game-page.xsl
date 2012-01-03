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
        <div id="docs-container-search" >
            <xsl:call-template name="athorise-container" />
        </div> 
        <div id="docs-content"> 
            <xsl:call-template name="docs-content" />
        </div>
    </div>
    <div id="bottom-banner-container" >
        <xsl:call-template name="bootom-banner-container" />
    </div>
</xsl:template>

<xsl:template name="athorise-container">
    <xsl:param name ="Login"  select="/data/meta/login" />
    <xsl:param name ="LoginPath"  select="concat('/Users/Login', /data/meta/current-path)" />
    <xsl:param name ="LoginPathHidden"  select="concat('/Users/LoginAjax', /data/meta/current-path)" />
    <xsl:param name ="LogoutPath"  select="concat('/Users/Logout', /data/meta/self-retpath)" />
    <xsl:param name ="RegistrationPath"  select="'/Users/Registration/'" />
    <xsl:param name ="ChangePassPath"  select="'/Users/ChangePass/'" />
    <span id="athorise-container-on">
        <xsl:if test="not($Login) or ($Login = 'undefined')">
            <xsl:attribute name="style">display:none</xsl:attribute>
        </xsl:if>
        <xsl:text>Это Вы:</xsl:text>
        <span id="athorise-container-login"><xsl:value-of select="$Login" /></span>
        <span>&nbsp;/&nbsp;</span>
        <a href="{$LogoutPath}">выйти</a>
        <span>&nbsp;</span>
    </span>
    <xsl:choose>
        <xsl:when test="not($Login) or ($Login = 'undefined')">
            <!--
                Эту разметку можно вставлять и через javascript,
                но разметка в javascript это очень плохо
            -->
            <div id="login-form-error" style="display:none">&nbsp;</div>
            <form action="{$LoginPath}"  method="POST" id="common-login-form" >
                <input type="text"
                       name="login"
                       placeholder="введите логин" />
                <input type="password"
                       name="password"
                       placeholder="введите пароль" />
                <input type="submit" value="войти"/>
                <span>
                    <span>&nbsp;</span>
                    <a href="{$RegistrationPath}">регистрация</a>
                    <span>&nbsp;/&nbsp;</span>
                    <a href="{$ChangePassPath}">забыли пароль?</a>
                </span>
            </form>
        </xsl:when>
    </xsl:choose>
</xsl:template>    


<xsl:template name="docs-container-header">
    <xsl:text>Название</xsl:text>
</xsl:template>

<!-- Нормативно-правовые документы    -->

<xsl:template name="docs-content">
    <!-- EMPTY -->
    <xsl:text>&nbsp;</xsl:text>
</xsl:template>



<xsl:template name="foot-scripts">
    <script type="text/javascript" src="/static/site-media/js/jquery.min.js">&nbsp;</script>
    <script type="text/javascript" src="/static/site-media/flash/swfobject.js" >&nbsp;</script>
    <script type="text/javascript" src="/static/site-media/js/login.js">&nbsp;</script>    
    <script type="text/javascript" src="/static/site-media/js/banners.js">&nbsp;</script>
    <script type="text/javascript" src="/static/site-media/js/game.js">&nbsp;</script>
    <script type="text/javascript" src="/static/site-media/js/game-page.js">&nbsp;</script>
</xsl:template>


</xsl:stylesheet>
