<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../shared/master/printer/athorised-page.xsl"/>

<xsl:include href="./includes/root-test-list.xsl" />

<xsl:template name="docs-container-header">
    <xsl:text>Онлайн-тестирование</xsl:text>
</xsl:template>

<xsl:template name="docs-content">
    <div id="dirs-list">
        <section>
            <ul>
                <li>
                    <a href="/Tests/List/Air/">Воздушный транспорт</a>
                </li>
                <li>
                    <a href="/Tests/List/Water/">Водный транспорт</a>
                </li>
                <li>
                    <a href="/Tests/List/Surface/">Наземный транспорт</a>
                </li>
            </ul>
        </section>
    </div>
</xsl:template>


<xsl:template match="/">
  <xsl:apply-imports/>
</xsl:template>

</xsl:stylesheet>
