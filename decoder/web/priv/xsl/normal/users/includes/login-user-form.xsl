<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:include href="../../shared/utils/inputFieldTr.xsl" />
    
<xsl:template name="edit-user-form">
    <xsl:param name="Action" select="'/Users/Registration/'" />
    <xsl:param name="RegAction" select="'/Users/Registration/'" />
    
    <xsl:param name="Method" select="'POST'"/>
    <xsl:param name="HasErrors" select="/data/meta/has-errors"/>
    <xsl:param name="ErrorMess" select="/data/meta/error-mess"/>    

<xsl:if test="$HasErrors = 'true'">
    <div style="color:red">
        <br/>
        <span>есть ошибки:</span>
        <span>&nbsp;</span>
        <xsl:choose>
            <xsl:when test="$ErrorMess = 'bad_customer'">
                <xsl:text>такого пользователя не существует</xsl:text>
            </xsl:when>
            <xsl:when test="$ErrorMess = 'bad_password 9'">
                <xsl:text>вы ввели не верный пароль</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$ErrorMess" />
            </xsl:otherwise>
        </xsl:choose>
    </div>
</xsl:if>

<form action="{$Action}" method="{$Method}" >
    <table>
        <xsl:call-template name="inputFieldTr">
            <xsl:with-param name="LabelName" select="'#'"  />
            <xsl:with-param name="Name" select="'id'"  />
            <xsl:with-param name="Value" select="'null'"  />
            <xsl:with-param name="Type" select="'hidden'"  />
        </xsl:call-template>
        <xsl:call-template name="inputFieldTr">
            <xsl:with-param name="LabelName" select="'Логин'"  />
            <xsl:with-param name="Name" select="'login'"  />
            <xsl:with-param name="Placeholder" select="'Введите логин'"  />
            <xsl:with-param name="Required" select="'true'"/>
        </xsl:call-template>
        <xsl:call-template name="inputFieldTr">
            <xsl:with-param name="LabelName" select="'Пароль'" />
            <xsl:with-param name="Name" select="'password'"  />
            <xsl:with-param name="Placeholder" select="'Введите пароль'"  />
            <xsl:with-param name="Type" select="'password'"  />
            <xsl:with-param name="Required" select="'true'"/>
        </xsl:call-template>
    </table>
    <input type="submit" value="Принять"/>

    <div id="doc-body-text">    
        <span>
            <a href="{$RegAction}">
                <xsl:text>Регистрация</xsl:text>
            </a>
        </span>
        <span>&nbsp;</span>
        <span>
            <a href="/Users/ChangePass/">
                <xsl:text>Забыли пароль?</xsl:text>
            </a>
        </span>
    </div>
    
    </form>
</xsl:template>



</xsl:stylesheet>
