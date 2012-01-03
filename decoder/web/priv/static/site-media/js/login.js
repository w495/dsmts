/**
 * Различные функции для стр с автооризацией
 * TODO: разнести не несколько функций
**/

(function($) {
    $.fn.loginAndEtc = function(a_options){
        var obj = $(this);
        var defaults = {};
        var options = $.extend(defaults, a_options);
        
        $("#test-body-materials").show();
        $("#test-body-open-materials").click(function(){ $("#test-body-materials").slideToggle();});
        $("#test-body-close-materials").click(function(){ $("#test-body-materials").slideUp();});
        
        $("#common-login-form").submit(function(event) {
            event.preventDefault(); // отключаем простой submit
            var $form = $( this ),
                _login = jQuery.trim($form.find( 'input[name="login"]' ).val()),
                _password = jQuery.trim($form.find( 'input[name="password"]' ).val()),
                _url = jQuery.trim( $form.attr( 'action' ) ),
                url = "/!" + _url;
            if(("" == _login) || ("" == _password))
                return false;
            $.post( url, { login: _login, password: _password },
                function( data ) {
                    if(data.mess){
                        $("#login-form-error").html("Ошибка: ");
                        if("bad_customer" == data.mess){
                            $("#login-form-error")
                                .append("нет такого пользователя: " + _login);
                        }
                        if("bad_password" == data.mess){
                            $("#login-form-error").append("не правильный пароль");    
                        }
                        $("#login-form-error").show();
                    }
                    else{
                        $("#athorise-container-login").html(_login);
                        $("#athorise-container-on").show();
                        $form.hide();
                        document.cookie = data.val
                    }
                }
            );
            return true;
        });
        
        $("#ask-body").hide();    
        $("#ask").click(function(){$("#ask-body").slideToggle();});
        $(".add-question-file-field").click(function(){
            var html = $(".question-file-field-display-none").html()
            $(this).parent().append(html);
            
            
            //$(".add-rem-question-file-fields").show();
            
            $(".rem-question-file-field-h").click(function(){
                $(this).parent().html("");
            });
        });
    }
})(jQuery);