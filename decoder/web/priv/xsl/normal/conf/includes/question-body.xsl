<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


<!--
<xsl:include href="../../shared/utils/tipograf.xsl" />
-->

<xsl:template name="question-body">
    <xsl:param name="Question" />
    <xsl:param name="QuestionList" />
    <xsl:param name="CurrentPath" />
    <xsl:param name="PrinterFlag" />
    <xsl:param name="IsDoube" select="'false'" />
    
    <!-- Основное содержимое вопроса -->
    <span>
        <strong>
            <xsl:text disable-output-escaping="yes">Вопрос:</xsl:text>
        </strong>
    </span>
    <xsl:call-template name="partial-doc-body-q">
        <xsl:with-param  name="Document" select="$Question"/>
        <xsl:with-param  name="PrinterFlag" select="$PrinterFlag"/>
    </xsl:call-template>

    <!-- Интерфейс объединения вопросов -->
    <xsl:if test="not($PrinterFlag) and not($Question/same/item) and not($Question/answer/item)">
        <form action="/Conf/MergeQuestions{$CurrentPath}#questions" method="POST">
            <select name="choosen-id" >
                <xsl:for-each select="$QuestionList/item">
                    <xsl:if test="./id != $Question/id">
                        <option value="{id}">
                            <xsl:value-of select="name" />
                        </option>
                    </xsl:if>
                </xsl:for-each>
            </select>
            <input type='hidden' name="current-id" value="{$Question/id}"/>
            <input type='submit' class="relief" value="Объединить"/>
        </form>
    </xsl:if>
    
    
    <!-- Дублированные вопросы -->
    <xsl:if test="count($Question/same/item) &gt; 0">
        <xsl:choose>
            <xsl:when test="count($Question/same/item) &gt; 1">
                <span>
                    <xsl:text disable-output-escaping="yes">Похожие вопросы:</xsl:text>
                </span>
            </xsl:when>
            <xsl:when test="count($Question/same/item) = 1">
                <span>
                    <xsl:text disable-output-escaping="yes">Похожий вопрос:</xsl:text>
                </span>
            </xsl:when>
        </xsl:choose>
        <div id="same-{$Question/id}">
            <ul class="question-same-list">
            <xsl:for-each select="$Question/same/item">
                <li>
                    <xsl:call-template name="partial-doc-body-q">
                        <xsl:with-param  name="Document" select="."/>
                        <xsl:with-param  name="PrinterFlag" select="$PrinterFlag"/>
                    </xsl:call-template>
                </li>
            </xsl:for-each>
            </ul>
        </div>
    </xsl:if>
    
    <!-- Ответы -->
    <xsl:if test="count($Question/answer/item) &gt; 0">
        <xsl:choose>
            <xsl:when test="count($Question/answer/item) &gt; 1">
                <span>
                    <strong>
                        <xsl:text disable-output-escaping="yes">Ответы:</xsl:text>
                    </strong>
                </span>
            </xsl:when>
            <xsl:when test="count($Question/answer/item) = 1">
                <span>
                    <strong>
                        <xsl:text disable-output-escaping="yes">Ответ:</xsl:text>
                    </strong>
                </span>
            </xsl:when>
        </xsl:choose>
        <div id="answers-{$Question/id}">
            <!-- задаем id для возвращения на эту позицию -->
            <ul>
            <xsl:for-each select="$Question/answer/item">
                <li>
                    <xsl:call-template name="partial-doc-body-a">
                        <xsl:with-param  name="Document" select="."/>
                        <xsl:with-param  name="PrinterFlag" select="$PrinterFlag"/>
                    </xsl:call-template>
                </li>
            </xsl:for-each>
            </ul>
        </div>
    </xsl:if>
    
    <!-- Интерфейс ответа -->
    <xsl:if test="not($PrinterFlag) and (/data/meta/login-is-expert = 'true')">
        <div>
            <span>
                <xsl:text disable-output-escaping="yes">Ответить:</xsl:text>
            </span>
            <div>
                <form action="/Conf/Answer{$CurrentPath}#answers-{$Question/id}" method="POST" enctype="multipart/form-data">
                    <!--
                        @note:
                            "{$CurrentPath}#answers-{$Question/id}" ~~~ путь возврата, после отпарвки формы
                        @note:
                            multipart/form-data ~~~ т.к. можем отправить файл
                    -->
                    <input name="id" type="hidden" value="{$Question/id}" />
                    <div class="question-text">
                        <textarea placeholder="Введите текст сюда ..." class="question-textarea" name="content"  rows="2" cols="20">
                            <xsl:text>&nbsp;</xsl:text>
                        </textarea>
                    </div>
                    <div>
                        <span class="add-question-file-field">[+]</span>
                    </div>
                    <div class="question-file-field-display-none" style="display:none">
                        <div class="question-file-field">
                            <select name="file-type" >
                                <option selected="selected" value="1">
                                    <xsl:text disable-output-escaping="yes">Файл</xsl:text>
                                </option>
                                <option value="2">
                                    <xsl:text disable-output-escaping="yes">Картинка</xsl:text>
                                </option>
                                <option value="3">
                                    <xsl:text disable-output-escaping="yes">Видео</xsl:text>
                                </option>
                                <option value="4">
                                    <xsl:text disable-output-escaping="yes">Ссылка</xsl:text>
                                </option>
                            </select>
                            <input type='file' name="file" />
                            <span>&nbsp;</span>
                            <span class="rem-question-file-field-h">[x]</span>
                        </div>
                    </div>
                    <input type='submit' class="relief" value="Отправить"/>
                </form>
            </div>
        </div>
    </xsl:if>
</xsl:template>

<xsl:template name="partial-doc-body-q">
    <xsl:param name="Document" />
    <xsl:param name="PrinterFlag" />
    
    <div class="partial-doc" id="partial-doc-{$Document/id}">
        <!-- задаем id для возвращения на эту позицию -->
        <xsl:if test="not($PrinterFlag)">
            <div class="partial-doc-author-wrapper">
                <div class="partial-doc-author-pic">
                    <xsl:choose>
                        <xsl:when test="($Document/customer_pic_url = '') or ($Document/customer_pic_url = 'null')">
                            <img src="/static/site-media/images/defaults/user.png" height="92" title="{$Document/lastname}" alt="{$Document/lastname}" />
                        </xsl:when>
                        <xsl:otherwise>
                            <img src="/{$Document/customer_pic_url}" alt="{$Document/lastname}" title="{$Document/lastname}" height="92" />
                        </xsl:otherwise>                                    
                    </xsl:choose>
                </div>
            </div>
        </xsl:if>
        <div class="partial-doc-content-wrapper">
            <div class="partial-doc-author">
                <xsl:value-of select="$Document/firstname" />
                <xsl:text>&nbsp;</xsl:text>
                <xsl:value-of select="$Document/lastname" />
                <xsl:text>&nbsp;</xsl:text>
                <xsl:value-of select="$Document/organization" />
                <xsl:text>&nbsp;</xsl:text>
                <xsl:value-of select="$Document/position" />
                <xsl:text>,&nbsp;</xsl:text>
                <xsl:text>задал вопрос</xsl:text>
                <xsl:text>&nbsp;</xsl:text>
                <xsl:call-template name="erlangFormatDateTime">
                    <xsl:with-param name="DateTime" select="$Document/datatime"/>
                </xsl:call-template>
            </div>
            <div class="partial-doc-content conf-question-c">
                <xsl:call-template name="tipograf">
                    <xsl:with-param  name="Input" select="$Document/content"/>
                </xsl:call-template>
            </div>
        </div>    
    </div>
</xsl:template>

<xsl:template name="partial-doc-body-a">
    <xsl:param name="Document" />
    <xsl:param name="PrinterFlag" />
    <div class="partial-doc" id="partial-doc-{$Document/id}">
        <div class="partial-doc-content-wrapper">
            <div class="partial-doc-author">
                <xsl:value-of select="$Document/firstname" />
                <xsl:text>&nbsp;</xsl:text>
                <xsl:value-of select="$Document/lastname" />
                <xsl:text>&nbsp;</xsl:text>
                <xsl:value-of select="$Document/organization" />
                <xsl:text>&nbsp;</xsl:text>
                <xsl:value-of select="$Document/position" />
                <xsl:text>,&nbsp;</xsl:text>
                <xsl:text>ответил</xsl:text>
                <xsl:text>&nbsp;</xsl:text>
                <xsl:call-template name="erlangFormatDateTime">
                    <xsl:with-param name="DateTime" select="$Document/datatime"/>
                </xsl:call-template>
            </div>
            <div class="partial-doc-content conf-answer-c">
                <xsl:call-template name="tipograf">
                    <xsl:with-param  name="Input" select="$Document/content"/>
                </xsl:call-template>
               <xsl:if test="count($Document/attach/item) &gt; 0" >
                <div>
                        <!-- <span>Вложения:</span> -->
                        <ul>
                            <xsl:for-each select="$Document/attach/item">
                                <li>
                                    <!-- ********** ********** ********** -->            
                                    <xsl:choose>
                                        <!-- файл -->
                                        <xsl:when test="attach_type_id = 1">
                                            <a href="/{url}" title="{alt}">
                                                <xsl:value-of select="name" />
                                            </a>
                                        </xsl:when>
                                        <!-- картика -->
                                        <xsl:when test="attach_type_id = 2">
                                            <center>
                                                <img src="/{url}" alt="{name}" title="{alt}" width="200px"/>
                                            </center>
                                            <br/>
                                        </xsl:when>
                                        <!-- видео -->
                                        <xsl:when test="attach_type_id = 3">
                                            <a href="/{url}" title="{alt}">
                                                <xsl:value-of select="name" />
                                            </a>
                                        </xsl:when>
                                        <!-- ссылка -->
                                        <xsl:when test="attach_type_id = 4">
                                            <a href="/{url}" title="{alt}">
                                                <xsl:value-of select="name" />
                                            </a>
                                        </xsl:when>
                                        <!-- что-то -->
                                        <xsl:otherwise>
                                            <a href="/{url}" title="{alt}">
                                                <xsl:value-of select="name" />
                                            </a>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <!-- ********** ********** ********** -->
                                </li>
                            </xsl:for-each>
                        </ul>
                </div>
               </xsl:if>
            </div>
        </div>
        <xsl:if test="not($PrinterFlag)">
            <div class="partial-doc-author-wrapper">
                <div class="partial-doc-author-pic">
                    <xsl:choose>
                        <xsl:when test="($Document/customer_pic_url = '') or ($Document/customer_pic_url = 'null')">
                            <img src="/static/site-media/images/defaults/expert.png" height="92" title="{$Document/lastname}" alt="{$Document/lastname}" />
                        </xsl:when>
                        <xsl:otherwise>
                            <img src="/{$Document/customer_pic_url}" alt="{$Document/lastname}" title="{$Document/lastname}" height="92" />
                        </xsl:otherwise>                                    
                    </xsl:choose>
                    <!--
                        <img src="/{$Document/customer_pic_url}"  width="100" height="100"/>
                    -->
                </div>
            </div>
        </xsl:if>
    </div>
</xsl:template>

    
</xsl:stylesheet>
