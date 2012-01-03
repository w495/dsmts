
google.load('search', '1', {language : 'ru'});
google.setOnLoadCallback(function() {
    var cse_search_form = new google.search.CustomSearchControl('002321279033096311768:xfysweb_bja');
    cse_search_form.setResultSetSize(google.search.Search.FILTERED_CSE_RESULTSET);
    var options = new google.search.DrawOptions();
    options.enableSearchboxOnly("http://127.0.0.1:8080/SearchA/");
    cse_search_form.draw('cse-search-form', options);
}, true);
