document.addEventListener("turbolinks:load", function () {
    $input = $("[data-behavior='autocomplete']")
    var options = {
        getValue: "name",
        url: function (phrase) {
            return "/search.json?q=" + phrase;
        },
        categories: [{
            listLocation: "books",
            header: "<div style='color:#239B56';>Books</div>"
        },
        {
            listLocation: "isbns",
            header: "<div style='color:#239B56';>Isbns</div>"
        },
        {
            listLocation: "authors",
            header: "<div style='color:#239B56';>Authors</div>"
        },
        {
            listLocation: "putlishers",
            header: "<div style='color:#239B56';>Putlishers</div>"
        },
        {
            listLocation: "series",
            header: "<div style='color:#239B56';>Series</div>"
        },
        {
            listLocation: "shelfs",
            header: "<div style='color:#239B56';>Shelfs</div>"
        }],
        list: {
            onChooseEvent: function () {
                var url = $input.getSelectedItemData().url
                console.log(url)
                $input.val("")
                Turbolinks.visit(url)
            }
        }
    }
    $input.easyAutocomplete(options)
})
