Handlebars Templates
====================

# Intro

Handlebars.js is a client-side (although we can use it on the server with pyBars) templating engine for JavaScript. It is a JavaScript library that we include in our pages. With it, we can add templates to our HTML page that will be parsed and interpolated (values of properties inserted in place) with the values from the data you passed to the Handlebars.js function.

Our Marionette Views will usually require a template that will be loaded with this syntax:
```
    const template = require('hb!PATH_TO_FILE.handlebars')
```

The amount of logic that a Handlebar template can manage is pretty limited, and we want it to be like that, as we don't want our templates to contain business logic.

The best way to learn Handlebars is with this [Handlebars tutorial] and consulting the [Handlebars docs].


# Helpers

Handlebars has the concept of “helpers”. Helpers are registered into the Handlebars runtime either globally or locally at each view level (using Marionette). Below we’ve included some commonly used helpers and how to use them.

## Debug

The debug helper will output either all variables to the console or just a single variable:

    <h1>Bacon and the Infinite Bacon on Ice</h1>
    {{debug}}
    {{debug myVariable}}


## i18n

The i18n helper allows developers to mark and translate strings. The i18n helper also has access to interpolation features:

    {{_ "Let's go to the event" }}
    {{_ "Let's go to %s" event.name }}
    {{_ "Let's go to %(event_name)s %(count)s times" event_name=event.name count=3 }}


## Chain

The chain helper allows for running a few helpers in succession. Note: The i18n helper works in conjunction with this helper also:

    {{chain "_ markSafe widont" "I want to %(name)s things instead so it's even easier for %(translators)s" name=name_var translators=translators_var "just to be annoying" }}


## Widont

Widont allows developers to prevent “widows” from occuring. It does this by joining &nbsp; between the last 2 words in the string. This can be useful sometimes, but can also produce bugs and unexpectedly large strings in some languages *cough*German\*cough\*:

    {{widont "Hello World" }}

  [Handlebars docs]: http://handlebarsjs.com/
  [Handlebars tutorial]: http://javascriptissexy.com/handlebars-js-tutorial-learn-everything-about-handlebars-js-javascript-templating/

