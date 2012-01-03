<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template name="doc-body">
    <xsl:if test="/data/doc/pic_url != '' ">
        <!-- Картинки может и не быть -->
        <div id="doc-body-picture" >
            <img src="{/data/doc/pic_url}" alt="/data/doc/name" />
        </div>
    </xsl:if>    
    <div id="doc-body-text">
        <xsl:value-of select="/data/doc/content" />
    </div>
</xsl:template>

</xsl:stylesheet>
