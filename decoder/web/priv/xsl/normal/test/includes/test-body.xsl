<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:include href="../../shared/utils/tipograf.xsl" />

<xsl:template name="test-body">
    <div id="test-body">
        <div id="test-body-holder">        
            <xsl:call-template name="test-body-holder" />
        </div>
        <div id="test-questions-body">
            <xsl:call-template name="test-questions-body" />            
        </div>
    </div>
</xsl:template>

<xsl:template name="test-body-holder">
    <div id="test-body-holder">
        <article>
            <div id="test-body-open-materials-holder" >
                <h3 id="test-body-open-materials" class="relief" >
                    <xsl:text>Обучающие материалы</xsl:text>
                </h3>
            </div>
            <div id="test-body-materials">
                <div>
                    <xsl:call-template name="tipograf">
                        <xsl:with-param  name="Input" select="/data/doc/content"/>
                    </xsl:call-template>
                </div>
                <div id="test-body-close-materials-holder">
                    <div id="test-body-close-materials" class="relief" >
                        <xsl:text>Закрыть</xsl:text>
                    </div>
                </div>
            </div>
        </article>
    </div>
</xsl:template>

<xsl:template name="test-questions-body">
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
                        <xsl:if test="(pic_url != '') and (pic_url != 'null')">
                            <!-- Картинки может и не быть -->
                            <div class="test-question-picture" >
                                <img src="/{pic_url}" alt="{name}"  />
                            </div>
                        </xsl:if>
                    </div>
                    <!-- -->
                    <ol id="answer-list">
                      <xsl:text>&nbsp;</xsl:text>
                      <xsl:for-each select="answers/item">
                        <li>
                            <input type="radio" name="{$Qid}" value="{id}">
                                <xsl:if test="correct_flag and correct_flag = 'true'">
                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                </xsl:if>
                            </input>
                            <xsl:text>&nbsp;</xsl:text>
                            <xsl:value-of select="name" />
                            <xsl:if test="(pic_url != '') and (pic_url != 'null')">
                                <!-- Картинки может и не быть -->
                                <div class="test-answer-picture" >
                                    <img src="/{pic_url}" alt="{name}"  />
                                </div>
                            </xsl:if>
                            <xsl:choose>
                                <xsl:when test="(user_ch and user_ch = 'true') and (correct_flag and correct_flag = 'false')">
                                    <div>
                                        <span style="color:red; font-size: 120%;">✗</span>
                                        <xsl:text> Ответ неправильный. Cмотрите почему:</xsl:text>
                                        <div class="answer-list">
                                            <xsl:value-of select="content" />
                                        </div>
                                    </div>
                                </xsl:when>
                                <xsl:when test="(user_ch and user_ch = 'true') and (correct_flag and correct_flag = 'true')">
                                    <div>
                                        <span style="color:green; font-size: 120%;">✔</span>
                                        <xsl:text> Ответ верный.</xsl:text> 
                                    </div>
                                </xsl:when>    
                            </xsl:choose>
                        </li>
                     </xsl:for-each>
                    </ol>
                </li>                
            </xsl:for-each>
        </ol>
        <br/>
        <input type="submit" value="Проверить" class="relief" />
        <xsl:text> </xsl:text>
    </form>
    <xsl:choose>
        <xsl:when test="/data/test-rightness != 'undefined'">
            <form action=".">
                <input type="submit" value="Пройти тест заново" class="relief" />
            </form>
            <div>
                <br />
                <span>Правильных ответов:</span>
                <span><xsl:value-of select="/data/test-rightness" /></span>
            </div>
        </xsl:when>
        <xsl:otherwise>
            <xsl:if test="/data/test-last-res/result">
                <div>
                    <br />
                    <span>Последний результат (количество правильных ответов):</span>
                    <span><xsl:value-of select="/data/test-last-res/result" /></span>
                </div>
            </xsl:if>
        </xsl:otherwise>
    </xsl:choose>

</xsl:template>


</xsl:stylesheet>
