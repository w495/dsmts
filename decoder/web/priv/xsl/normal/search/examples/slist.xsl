<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../shared/master/screen/list-page.xsl"/>

<xsl:import href="../shared/widgets/dirs-list.xsl"/>
<xsl:import href="../shared/widgets/doc-body.xsl"/>

<xsl:template name="docs-container-header">
    <xsl:text>Нормативно-правовые документы</xsl:text>
</xsl:template>

<xsl:template name="docs-content">
    <div id="search-body">
        <div>
            <div id="cse" style="width: 100%;">Loading</div>
            
            <script src="//www.google.ru/jsapi" type="text/javascript">&nbsp;</script>
            <script type="text/javascript">
                <xsl:text disable-output-escaping="yes">
                    <![CDATA[
  google.load('search', '1', {language : 'ru', style : google.loader.themes.MINIMALIST});
  google.setOnLoadCallback(function() {
    var customSearchControl = new google.search.CustomSearchControl(
      '002321279033096311768:xfysweb_bja');

    customSearchControl.setResultSetSize(google.search.Search.FILTERED_CSE_RESULTSET);
    var options = new google.search.DrawOptions();
    options.setSearchFormRoot('cse-search-form');
    customSearchControl.draw('cse', options);
  }, true);
                    ]]>
                </xsl:text>
            </script>
        </div>
    </div>
</xsl:template>


<xsl:template match="/">
  <xsl:apply-imports/>
</xsl:template>

</xsl:stylesheet>

