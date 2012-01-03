<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:include href="../../shared/utils/inputFieldTr.xsl" />
    
<xsl:template name="edit-user-form">
    <xsl:param name="Action" select="'/Users/Registration/'" />
    <xsl:param name="Method" select="'POST'"/>
    <xsl:param name="HasErrors" select="/data/meta/has-errors"/>
    <xsl:param name="ErrorMess" select="/data/meta/error-mess"/>    

<xsl:if test="$HasErrors = 'true'">
    <div style="color:red">
        <br/>
        <span>ЕСТЬ ОШИБКИ:</span>
        <xsl:choose>
            <xsl:when test="$ErrorMess = 'not_unique email'">
                <xsl:text> пользователь с таким E-mail уже существует</xsl:text>
            </xsl:when>
            <xsl:when test="$ErrorMess = 'not_unique login'">
                <xsl:text> пользователь с таким логином уже существует</xsl:text>
            </xsl:when>
            <xsl:when test="$ErrorMess = 'not conf'">
                <xsl:text> пароли не совпадают</xsl:text>
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
        <xsl:call-template name="inputFieldTr">
            <xsl:with-param name="LabelName" select="'Повторите пароль'" />
            <xsl:with-param name="Name" select="'passwordC'"  />
            <xsl:with-param name="Placeholder" select="'Повторите пароль'"  />
            <xsl:with-param name="Type" select="'password'"  />
            <xsl:with-param name="Required" select="'true'"/>
        </xsl:call-template>
        <xsl:call-template name="inputFieldTr">
            <xsl:with-param name="LabelName" select="'Электронная почта'" />
            <xsl:with-param name="Name" select="'email'"  />
            <xsl:with-param name="Placeholder" select="'Введите email'"  />
            <xsl:with-param name="Required" select="'true'"/>
        </xsl:call-template>
        <xsl:call-template name="inputFieldTr">
            <xsl:with-param name="LabelName" select="'Город'" />
            <xsl:with-param name="Name" select="'city'"  />
            <xsl:with-param name="Placeholder" select="'Введите город'"  />
        </xsl:call-template>
        <xsl:call-template name="inputFieldTr">
            <xsl:with-param name="LabelName" select="'Организация'" />
            <xsl:with-param name="Name" select="'organization'"  />
            <xsl:with-param name="Placeholder" select="'Введите организацию'"  />
        </xsl:call-template>
        <xsl:call-template name="inputFieldTr">
            <xsl:with-param name="LabelName" select="'Должность'" />
            <xsl:with-param name="Name" select="'position'"  />
            <xsl:with-param name="Placeholder" select="'Введите позицию'"  />
        </xsl:call-template>
        <xsl:call-template name="inputFieldTr">
            <xsl:with-param name="LabelName" select="'Фамилия'" />
            <xsl:with-param name="Name" select="'lastname'"  />
            <xsl:with-param name="Placeholder" select="'Назовите Фамимлию'"  />
            <xsl:with-param name="Required" select="'true'"/>
        </xsl:call-template>
        <xsl:call-template name="inputFieldTr">
            <xsl:with-param name="LabelName" select="'Имя'" />
            <xsl:with-param name="Name" select="'firstname'"  />
            <xsl:with-param name="Placeholder" select="'Назовите Имя'"  />
            <xsl:with-param name="Required" select="'true'"/>
        </xsl:call-template>
        <xsl:call-template name="inputFieldTr">
            <xsl:with-param name="LabelName" select="'Отчество'" />
            <xsl:with-param name="Name" select="'patronimic'"  />
            <xsl:with-param name="Placeholder" select="'Отчество'"  />
        </xsl:call-template>
    </table>
    <input type="submit" value="Принять"/>
    
    <div id="doc-body-text">
        <div>
            <a href="/Users/ChangePass/">Забыли пароль?</a>
        </div>
        <div>&nbsp;</div>
        <div>
            Поля, обязательные для заполнения, помечены <span style="color:red;">*</span>.
        </div>
    </div>
    </form>
</xsl:template>

</xsl:stylesheet>
