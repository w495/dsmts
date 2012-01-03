<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


<xsl:template name="leters-list">
    <xsl:param name="CurrentPath" select="/data/meta/item-parent-path"/>
    <xsl:param name="Leters" select="/data/leters"/>
    
    <xsl:variable name="LETTERS" select="'AБВГДЕЁЖЗИКЛМНОПРСТУФХЦЧШЩЭЮЯ'"/>
    
    <div id="leter-list">
        <xsl:call-template name="leters-list-for-each">
            <xsl:with-param name="CurrentPath" select="$CurrentPath"/>
            <xsl:with-param name="Pos" select="1"/>
            <xsl:with-param name="Leters" select="$LETTERS"/>
            <xsl:with-param name="Len" select="string-length($LETTERS)"/>
        </xsl:call-template>
    </div>
    
    <!--
        <comment>
            Старый вариант, основанный на буквах, загружаемых из базы данных
        </comment>
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
    -->
    
</xsl:template>


<xsl:template name="leters-list-for-each">
    <xsl:param name="CurrentPath" select="/data/meta/current-path"/>
    <xsl:param name="Leters" />
    <xsl:param name="Pos" />
    <xsl:param name="Len" />

    <xsl:text> </xsl:text>
    <span class="termin-leter relief" >
        <a href="{concat($CurrentPath, substring($Leters,$Pos,1))}/">
            <xsl:value-of select="substring($Leters,$Pos,1)"/>
        </a>
    </span>
    <xsl:text> </xsl:text>
    
    <xsl:if test="$Pos &lt; $Len">
        <xsl:call-template name="leters-list-for-each">
            <xsl:with-param name="CurrentPath" select="$CurrentPath"/>
            <xsl:with-param name="Pos" select="$Pos + 1"/>
            <xsl:with-param name="Leters" select="$Leters"/>
            <xsl:with-param name="Len" select="$Len"/>
        </xsl:call-template>
    </xsl:if>
    
</xsl:template>
    
</xsl:stylesheet>
