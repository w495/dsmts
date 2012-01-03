function flashPlayerInvoke(div){
    $.get("/action/get-clip-url/"+clip_id, {seed: Math.round(Math.random()*10000), media: 'http'}, flashPlayerEmbed);
}

var p_uuid='';

function flashPlayerEmbed(url){
    
    var fvars = {};
    var params = {};
    var playerSWF="/js/tvzavrplayer.swf";
    var ip = url;

    var ip = ip.replace(/^http\:\/\//,'');
    var ip = ip.replace(/\/httpstream.*$/,'');
    
    params.wmode = 'transparent';
    params.quality = 'high';
    params.allowScriptAccess = 'always';
    params.allowFullScreen = 'true';
    var noCache=Math.random()*1000000;
    fvars.noStats = '1';
    fvars.autoplay = '1';
    fvars.statURL = 'http://'+ip+'/streamstat';
    fvars.src=url;
    fvars.UserId=p_uuid;
    swfobject.embedSWF(playerSWF,"videoarea",'100%','100%',"10","http://www.infox.ru/player/expressInstall.swf",fvars,params,"#869ca7");
    
}

function playerStreamComplete(src){

        if (channel_id==0){
                if ($("form.follow_url").length>0) $("form.follow_url")[0].submit();
        } else {
                for(j=0;j<=$("form.follow_url").find("input").length-1;j++){
                    var ign = readCookie('ignore_clip_'+$("form.follow_url").find("input")[j].value+'_at_'+channel_id);
                    if(!ign){
                        $("form.follow_url").attr("action", "/video/channel/"+channel_id+"?page="+(j+clip_position+1));
                        if ($("form.follow_url").length>0) $("form.follow_url")[0].submit();
                        return false;
                    }
                }
            }
    

}

var channel_id = 0;

$(document).ready(function(){
    
    $("#search_stop").click(function() {
        $('input[name=query]').val('');
    });
});
