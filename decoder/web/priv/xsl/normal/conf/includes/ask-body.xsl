<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!--
<xsl:include href="../../shared/utils/tipograf.xsl" />
-->

<xsl:template name="ask-body">
    <xsl:param name="CurId" />
    <xsl:param name="CurrentPath" />    
    
    <form  action="/Conf/Ask{$CurrentPath}#questions" method="POST" >
        <div id="ask-text">
            <input name="id" type='hidden' value="{$CurId}"/>
            <textarea placeholder="Введите текст сюда ..." id="ask-textarea" name="content">
                <xsl:text>&nbsp;</xsl:text>
            </textarea>
            <div id="ask-submit-wrapper">
                <input type="submit" class="relief" value="Отправить"/>
            </div>
        </div>
    </form>
</xsl:template>

</xsl:stylesheet>
