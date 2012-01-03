<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../shared/master/screen/athorised-page.xsl"/>

<xsl:include href="includes/dirs-list.xsl" />

<xsl:include href="../shared/utils/tipograf.xsl" />

<!-- переопределен docs-container-header -->
<xsl:include href="includes/docs-container-header.xsl" />

<xsl:template name="docs-content">
    <div id="test-body">
        <div>
            <article>
                <div id="test-body-open-materials-holder" >
                    <h3 id="test-body-open-materials" >
                        <xsl:text>Обучающие материалы</xsl:text>
                    </h3>
                </div>
                <div id="test-body-materials">
                    <div>
                        <xsl:call-template name="tipograf">
                            <xsl:with-param  name="Input" select="data/doc/content"/>
                        </xsl:call-template>
                    </div>
                    <div id="test-body-close-materials-holder">
                        <div id="test-body-close-materials">
                            <xsl:text>Закрыть</xsl:text>
                        </div>
                    </div>
                </div>
            </article>
        </div>
        
        <div>
            <form action="." method="POST">
                <ol id="question-list">
                    <xsl:for-each select="data/questions/item">
                        <xsl:variable name="Qid" select="id"/>
                        <xsl:variable name="Right" select="right"/>
                        <li>
                            <xsl:value-of select="rightness" />
                            <input type="hidden" name="questions" value="{id}"   />
                            <div>
                                <h3>[?] <xsl:value-of select="name" /></h3>
                            </div>
                            <ol id="answer-list">
                              <xsl:for-each select="answers/item">
                                <li>
                                    <input type="checkbox" name="{$Qid}" value="{id}">
                                        <xsl:if test="correct_flag and correct_flag = 'true'">
                                            <xsl:attribute name="checked">checked</xsl:attribute>
                                        </xsl:if>
                                    </input>
                                    <xsl:text>&nbsp;</xsl:text>
                                    <xsl:value-of select="name" />
                                    <xsl:if test="user_ch and user_ch = 'true'">
                                        <span>&nbsp;<em>(это и был ваш ответ)</em></span>
                                    </xsl:if>
                                    <xsl:choose>
                                        <xsl:when test="correct_flag and correct_flag = 'false'">
                                            <div>
                                                Ответ не верный. Cмотрите почему:
                                                <div>
                                                    <xsl:value-of select="content" />
                                                </div>
                                            </div>
                                        </xsl:when>
                                        <xsl:when test="correct_flag and correct_flag = 'true'">
                                            <div>
                                                Ответ верный. Cмотрите почему:
                                                <div>
                                                    <xsl:value-of select="content" />
                                                </div>
                                            </div>
                                        </xsl:when>    
                                    </xsl:choose>
                                </li>
                             </xsl:for-each>
                            </ol>
                        </li>                
                    </xsl:for-each>
                </ol>
                
                <input type="submit" value="Проверить"/>
                <a href="." >Пройти еще раз</a>
                
            </form>
        </div>
    </div>
</xsl:template>


<xsl:template match="/">
  <xsl:apply-imports/>
</xsl:template>

</xsl:stylesheet>
