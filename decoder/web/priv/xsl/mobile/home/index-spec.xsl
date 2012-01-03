<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../shared/master/root.xsl"/>

<xsl:include href="../shared/utils/tipograf.xsl" />

<xsl:template name="title">МЧС России - мобильная версия интернет-портала</xsl:template>

<xsl:template name="main">
    <div class="head-line">
        <xsl:text>Главное меню</xsl:text>
    </div>
    
    <a href="/Mobile/Regulatory/List/" class="item1 item-link">
        <div class="itev_txt">
            <xsl:text>Нормативные документы</xsl:text>
            <div style="height:2px;">&nbsp;</div>
        </div>
    </a>
    
    <a href="/Mobile/Secure/List/" class="item2 item-link">
        <div class="itev_txt">
            <xsl:text>Безопасность на транспорте</xsl:text>
            <div style="height:2px;">&nbsp;</div>
        </div>
    </a>

    <a href="/Mobile/Hotline/Index/" class="item1 item-link">
        <div class="itev_txt">
            <xsl:text>Контакты</xsl:text>
            <div style="height:2px;">&nbsp;</div>
        </div>
    </a>
    
    <a href="/Mobile/Hotline/Index/" class="item2 item-link">
        <div class="itev_txt">
            <xsl:text>Горячая линия</xsl:text>
            <div style="height:2px;">&nbsp;</div>
        </div>
    </a>
    
</xsl:template>


<xsl:template match="/">
    <xsl:apply-imports />
</xsl:template>
</xsl:stylesheet>
