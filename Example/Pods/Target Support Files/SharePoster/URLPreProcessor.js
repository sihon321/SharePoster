#!/bin/sh

#  URLPreProcessor.js
#  Pods
#
#  Created by sihon321 on 09/10/2019.
#  

var Preprocessor = function() {};

Preprocessor.prototype = {
run: function(arguments) {
    arguments.completionFunction({"URL": document.URL,
                                 "title": document.title,
                                 "selection": window.getSelection().toString()});
}
};

var ExtensionPreprocessingJS = new Preprocessor;
