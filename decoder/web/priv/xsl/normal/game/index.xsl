<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import href="../shared/master/screen/game-page.xsl"/>

<xsl:template name="docs-container-header">
    <xsl:text>Тематическая игра</xsl:text>
</xsl:template>

<xsl:template name="docs-content">

<div id="game-area" >
    <div>
        <a href="#" class="game-start">
            <xsl:text>Начать игру</xsl:text>
        </a>
        <xsl:text>&nbsp;&nbsp;&nbsp;</xsl:text>
        <a href="/Game/Details/"><xsl:text>Описание</xsl:text></a>
    </div>
    
    <br/>
    
    <!--
    <div id="game-image">
        <a href="#" class="game-start">
            <img src="/static/site-media/images/manual-game-files/image016.jpg" width="960" />
        </a>
    </div>
    -->
    <!--
        newGame(string json_db, string path_to_db_xml)
    -->
    <!--
    <div id="game-holder" name="game-holder">
        <div id="game-content">
            <h1>game</h1>
            <p>Alternative content</p>
            <p><a href="http://www.adobe.com/go/getflashplayer"><img 
                src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" 
                alt="Get Adobe Flash player" /></a></p>
        </div>    
    </div>
    -->
    

<object id="o-game-content" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="1000" height="600">
  <param name="movie" value="/static/site-media/flash/game.swf?xml=/static/site-media/flash/visuals.xml" />
  <!--[if !IE]>-->
  <object type="application/x-shockwave-flash" data="/static/site-media/flash/game.swf?xml=/static/site-media/flash/visuals.xml" width="1000" height="600">
  <!--<![endif]-->
    <embed
        src="/static/site-media/flash/game.swf?xml=/static/site-media/flash/visuals.xml"
        name="n-o-game-content" align="middle"
        play="true"
        loop="false"
        quality="high"
        allowScriptAccess="sameDomain"
        width="1000"
        height="600"
        scale="exactfit"
        type="application/x-shockwave-flash"
        pluginspage="http://www.macromedia.com/go/getflashplayer">
    </embed>
  <!--[if !IE]>-->
  </object>
  <!--<![endif]-->
</object>





</div>

</xsl:template>


<xsl:template match="/">
  <xsl:apply-imports/>
</xsl:template>

</xsl:stylesheet>
