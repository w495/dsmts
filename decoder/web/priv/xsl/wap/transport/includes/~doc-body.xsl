<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!--
    Шаблон тела документа.
    Имеет вид:
    ~~~~~~~~~~~~~~~~~~~~~~
     $DateTime
    ~~~~~~~~~~~~~~~~~~~~~~     
     $Title
    ~~~~~~~~~~~~~~~~~~~~~~
     | $Pic |  $Text ...
         ...
    [~~~~~~~~~~~~~~~~~~~~~~
     Вложения:
        $Attaches
    ~~~~~~~~~~~~~~~~~~~~~~]
-->


<xsl:include href="../../shared/utils/erlangFormatDate.xsl" />
<xsl:include href="../../shared/utils/tipograf.xsl" />


<xsl:template name="doc-body">
    
    
    <xsl:param name="Pic" />
    <xsl:param name="Title" />
    <xsl:param name="Text" />
    <xsl:param name="DateTime" />
    <xsl:param name="Attaches" />
    <xsl:param name="PrinterFlag" />
    <xsl:param name="GoBack" select="'#'"/>
    
    
    <header>
        <div id="doc-body-datetime-holder">
            <time pubdate="pubdate">
                <xsl:attribute name="datetime">
                    <xsl:call-template name="erlangFormatPubdate">
                        <xsl:with-param name="DateTime" select="$DateTime"/>
                        <xsl:with-param name="TimeZone" select="'MSD'"/>
                    </xsl:call-template>
                </xsl:attribute>
                <span id="doc-body-datetime" class="doc-body-border-bar">
                    <xsl:call-template name="erlangFormatDateTime">
                        <xsl:with-param name="DateTime" select="$DateTime"/>
                    </xsl:call-template>
                </span>
            </time>
            <div class="breakline">&nbsp;</div>
        </div>        
        <h2 id="doc-body-header" class="second-header"><xsl:value-of select="$Title" /></h2>
        <div class="breakline">&nbsp;</div>
    </header>
    <section>
        <div id="doc-body-text">
            <xsl:if test="$Pic != '' ">
                <div id="doc-body-picture" >
                    <img src="/{$Pic}" alt="{$Title}" />
                </div>
            </xsl:if>            
            <xsl:call-template name="tipograf">
                <xsl:with-param  name="Input" select="$Text"/>
            </xsl:call-template>
        </div>
    </section>
    <xsl:if test="not($PrinterFlag)">
        <footer>
            <xsl:if test="$Attaches/item">
                <section>
                    <div id="doc-body-attaches">
                        <h3 id="doc-body-attaches-header" class="second-header">Вложения:</h3>
                        <ul id="doc-body-attaches-list">
                            <xsl:for-each select="$Attaches/item">
                                <li class="doc-body-attaches-item">

                                    
                                    <a href="/{url}">
                                        <xsl:value-of select="name" />
                                    </a>

                                </li>
                            </xsl:for-each>
                        </ul>
                    </div>
                </section>
            </xsl:if>
            <div id="doc-body-goback-holder" >
                <div class="breakline">&nbsp;</div>
                <span id="doc-body-goback" class="doc-body-border-bar relief">
                    <a href="{$GoBack}" >вернуться</a>
                </span>
            </div>
        </footer>
    </xsl:if>

    
</xsl:template>

</xsl:stylesheet>
