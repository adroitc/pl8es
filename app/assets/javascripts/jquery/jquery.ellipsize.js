/**
 * jQuery Ellipsis Plugin
 *
 * Copyright 2012 Minjie Zha
 */
(function($) {
    $.fn.ellipsis = function(options) {
        options = $.extend({
            'ellipsis': '...',
            'multilineClass': 'multiline',
            'trimFunction': $.fn.ellipsis.trimToWord
        }, options);

        return this.each(function() {
            var el = $(this);
            
            el.css("overflow","hidden");
            if (el.css("overflow") === "hidden") {
                // Clone current background and get content
                var text = el.html(),
                    multiline = el.hasClass(options.multilineClass),
                    t = $(this.cloneNode(true))
                        //.hide()
                        .css({
                            'position': 'absolute',
                            'overflow': 'visible'
                        })
                        //.width(multiline ? el.width() : 'auto')
                        //.height(multiline ? 'auto' : el.height())
                        .width("100%")
                        ;
                el.after(t);

                // Calculate size of content
                function height() { return t.height() > el.height(); }
                function width() { return t.width() > el.width(); }
                var func = multiline ? height : width;

                // Fit content to panel
                console.log("while"+t.width()+"-"+el.width());
                while (text.length > 0 && func()) {
                    text = text.substr(0, text.length - 1);
                    t.html(text + options.ellipsis);
                }

                // Setup content, clean up.
                el.html(options.trimFunction(t.html()));
                //t.remove();
            }
        });
    };

    // Trim the text to length (will remove extra spaces etc)
    $.fn.ellipsis.trimToLength = function (text) {
        return $.trim(text);
    };

    // Trim the text that fits to a word boundary.
    $.fn.ellipsis.trimToWord = function (text) {
        return $.trim(text);
    };
})(jQuery);