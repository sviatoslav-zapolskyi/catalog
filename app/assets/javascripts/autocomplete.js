document.addEventListener("turbolinks:load", function () {
    $('.autocomplete_author').easyAutocomplete({
        getValue: "name",
        url: function (phrase) {
            return "/autocomplete.json?type=author&q=" + phrase;
        },
        categories: [{
            listLocation: "authors"
        }]
    })
    $('.autocomplete_interpreter').easyAutocomplete({
        getValue: "name",
        url: function (phrase) {
            return "/autocomplete.json?type=interpreter&q=" + phrase;
        },
        categories: [{
            listLocation: "interpreters"
        }]
    })
})
