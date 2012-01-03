<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../shared/master/screen/common-page.xsl"/>

<xsl:include href="includes/login-user-form.xsl" />

<xsl:template name="docs-container-header">
    <xsl:text>Вход на сайт</xsl:text>
</xsl:template>

<xsl:template name="docs-content">
    <div id="edit-user-form">
        <xsl:call-template name="edit-user-form">
            <xsl:with-param name="Action" select="concat('/Users/Login', /data/meta/self-retpath)" />
            <xsl:with-param name="RegAction" select="concat('/Users/Registration', /data/meta/self-retpath)" />
            <xsl:with-param name="Method" select="'POST'"/>
            <xsl:with-param name="HasErrors" select="/data/meta/has-errors"/>
            <xsl:with-param name="ErrorMess" select="/data/meta/error-mess"/>
        </xsl:call-template>
    </div>
</xsl:template>

<xsl:template match="/">
  <xsl:apply-imports/>
</xsl:template>

</xsl:stylesheet>
