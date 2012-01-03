<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


<xsl:template name="leters-list">
    <xsl:param name="CurrentPath" select="/data/meta/current-path"/>
    <xsl:param name="Leters" select="/data/leters"/>
    
    <xsl:if test="count($Leters/item) &gt; 1">
        <div id="leter-list">
            <xsl:for-each select="$Leters/item">
                <span class="termin-leter relief">
                    <a href="{concat($CurrentPath, substring(leter,1,1))}/">
                        <xsl:value-of select="substring(leter,1,1)"/>
                    </a>
                </span>
                <span class="leter-spase">&nbsp;</span>
            </xsl:for-each>
        </div>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>
