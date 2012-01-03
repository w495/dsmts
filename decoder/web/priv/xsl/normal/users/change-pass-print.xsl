<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../shared/master/printer/common-page.xsl"/>

<xsl:include href="includes/login-user-form.xsl" />

<xsl:template name="docs-container-header">
    <xsl:text>Забыли пароль</xsl:text>
</xsl:template>

<xsl:template name="docs-content">
    <section>
        <div id="doc-body-text">                    
            <span>
                <xsl:text>Если Вы забыли пароль нужно обратиться к администратору сайта по почте:</xsl:text>
                <a href="mailto:w@w-495.ru">w@w-495.ru</a>
                <xsl:text>.</xsl:text>
            </span>
            <span>
                <xsl:text>В письме укажите свой логин и e-mail, с которым Вы зарегистрировались на сайте.</xsl:text>
            </span>
        </div>
    </section>
</xsl:template>

<xsl:template match="/">
  <xsl:apply-imports/>
</xsl:template>

</xsl:stylesheet>
