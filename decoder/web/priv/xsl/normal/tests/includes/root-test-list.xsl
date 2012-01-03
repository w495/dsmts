<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:include href="../../shared/utils/tipograf.xsl" />

<xsl:template name="root-test-list">
    <xsl:param name="Path"  select="/data/meta/parent-path" />
    <xsl:param name="AirCount"  select="/data/air-count" />
    <xsl:param name="WaterCount"  select="/data/water-count" />
    <xsl:param name="SurfaceCount"  select="/data/surface-count" />        
    <section>
        <ul>
            <li><a href="{$Path}Air/">Тесты воздушного транспорта</a> (<xsl:value-of select="$AirCount" />) </li>
            <li><a href="{$Path}Water/">Тесты водного транспорта</a> (<xsl:value-of select="$WaterCount" />) </li>
            <li><a href="{$Path}Surface/">Тесты наземного транспорта</a> (<xsl:value-of select="$SurfaceCount" />) </li>
        </ul>
    </section>
</xsl:template>

</xsl:stylesheet>
