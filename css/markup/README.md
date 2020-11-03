HTML Syntax, Style, and Best Practices
======================================

## Table of Contents
1. [Syntax and Style](#syntax-and-style)
1. [Handlebars](handlebars/README.md)
1. [Template Logic](template_logic/README.md)
1. [Accessibility](accessibility/README.md)


# Syntax and Style

All of our pages use the [HTML5 DOCTYPE], but we should still write valid XHTML. If you want to double-check before pushing your code, you can use the [W3C Markup Validator].

### General

-   All tags must be closed (including [void elements]):

``` sourceCode
<!-- Correct -->
<div><input /></div>
<!-- Incorrect -->
<div><input>
```

-   All pages must be [WCAG 2.0 AA compliant]
-   Don’t minimize tag attributes:

``` sourceCode
<!-- Correct -->
<option selected="selected"></option>

<!-- Incorrect -->
<option selected></option>
```

-   Properly nest your tags:

``` sourceCode
<!-- Correct -->
<section><p></p></section>

<!-- Incorrect -->
<section><p></section></p>
```

-   Don’t put [block-level elements] inside [inline elements].

    Block-display elements include `<div>`, `<h1>`, `<p>`, `<ul>`, `<dt>`, `<table>`, and `<form>`. Inline-display elements include `<span>`, `<a>`, `<img>`, and `<input>`.

``` sourceCode
<!-- Correct -->
<p><span></span></p>

<!-- Incorrect -->
<span><p></p></span>
```

-   Don’t use deprecated tags like `<center>` or deprecated attributes like `bgcolor`; use CSS instead. Check out [W3 Deprecated Tags] and [W3 Deprecated Attributes].

``` sourceCode
<!-- All Deprecated -->
<i></i>
<s></s>
<center></center>
<b></b>
```

### Eventbrite Conventions

-   4-space indentation, no tabs.

    Check out **Indentation Scheme** in [Template Logic](template_logic/template_logic) for how to mix Handlebars logic with HTML.

-   Don’t use unnecessary whitespace.
-   Block-display elements start a new line. Inline-display elements can also start a new line where it makes sense (i.e. if an `<a>` tag has a bunch of classes, a really long href, etc. - more line breaks make files much more readable).
-   Use Handlebars comments instead of HTML comments to hide notes meant for Briteling eyes only.

    See **Comments** in html-template\_logic.

``` sourceCode
<div class="carousel">
...
    <p>Eventbrite gives you all the online tools you need to bring people together for an event and sell tickets.</p>
    <ul class="carousel_body">
        <li>
            <img src="http://eventbrite-qa.s3.amazonaws.com/admin/marketing/featuredev
```

  [HTML5 DOCTYPE]: http://diveintohtml5.org/
  [W3C Markup Validator]: http://validator.w3.org/
  [void elements]: http://www.w3.org/html/wg/drafts/html/master/syntax.html#void-elements
  [WCAG 2.0 AA compliant]: https://www.w3.org/WAI/WCAG20/quickref/
  [block-level elements]: https://developer.mozilla.org/en-US/docs/HTML/Block-level_elements
  [inline elements]: https://developer.mozilla.org/en-US/docs/HTML/Inline_elements
  [W3 Deprecated Tags]: http://www.w3.org/TR/html5-diff/#obsolete-elements
  [W3 Deprecated Attributes]: http://www.w3.org/TR/html5-diff/#obsolete-attributes

