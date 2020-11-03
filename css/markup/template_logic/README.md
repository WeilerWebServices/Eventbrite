Template Logic and HTML
=======================

# Comments

We should favor Handlebars comments over HTML and Javascript comments in template files, especially when these comments reveal possibly sensitive implementation details or to-do notes meant for Eventbrite engineers, not the casual “View Source”-savvy user.

In a precompiled Handlebars template rendered on the client:

``` sourceCode
{{! This is a Handlebars comment that won't be visible in the resulting output after the template is compiled }}
<div class="notification notification--success">{{ message }}</div>
```

# Indentation Scheme

We used to do a "double level indentation" on our files, creating two levels of indentation (one for markup and another one for logic). We don't want to keep doing that, and instead, we will be trying to keep one level of indentation, combining markup and logic.

This is how we should do it now:

```
{{! Handlebars }}
{{#if canDisplay}}
    <ul>
        {{#each items}}
            <li>{{ itemName }}</li>
        {{/each}}
    </ul>
{{/if}}
```

This would make it easier for us to read and think about our templates, although the HTML output could have some weird spacing (but that's OK).
