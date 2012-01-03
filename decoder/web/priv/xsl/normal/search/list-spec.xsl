<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../shared/master/spec/search-page.xsl"/>


<xsl:import href="../shared/widgets/doc-body.xsl"/>

<xsl:template name="title">
    <xsl:text>МЧС: Поиск по сайту</xsl:text>
</xsl:template>

<xsl:template name="docs-container-header">
    <xsl:text>Поиск по сайту</xsl:text>
</xsl:template>

<xsl:template name="docs-content">
    <div id="search-body">
        <form action="/Search/" method="POST" >
            <input id="long-search-field" type="text" size="64"  name="q" placeholder="Введите поисковый запрос" value="{/data/meta/search-param}" />
            <input class="relief" id="long-search-submitter"  type="submit"  value="искать" />
        </form>
        <br/>
        <div id="cse" style="width: 100%;">
            <xsl:text>Загрузка ...</xsl:text>
        </div>
    </div>
</xsl:template>


<xsl:template match="/">
  <xsl:apply-imports/>
</xsl:template>

</xsl:stylesheet>

