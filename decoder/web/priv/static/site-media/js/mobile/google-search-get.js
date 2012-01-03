google.load('search', '1', {language : 'ru'});
google.setOnLoadCallback(function() {
    var cse_search_res = new google.search.CustomSearchControl( '002321279033096311768:xfysweb_bja');
    cse_search_res.setResultSetSize(google.search.Search.FILTERED_CSE_RESULTSET);
    var options = new google.search.DrawOptions();
    options.enableSearchResultsOnly();
    cse_search_res.draw('cse', options);
    var queryFromUrl = function () {
        var parts = window.location.toString().split('/');
        if(parts.length != 7){return "";}
        query_string = parts[parts.length - 2]
        return decodeURIComponent(query_string);
    }();
    if (queryFromUrl) {cse_search_res.execute(queryFromUrl);}
}, true);


