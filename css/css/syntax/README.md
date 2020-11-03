CSS Syntax, Style, and Best Practices
=====================================

Formatting Guidelines
---------------------

Correct Formatting:

``` sourceCode
#events_bubble > p {
    float: left;
    margin: 25px 0 0 10px;
    width: 113px;
    font-size: 13px;
    color: #999;
    line-height: 16px;
}
```

-   One CSS rule per line, indented 4 spaces.
-   Selector is on its own line.

Benefits of external stylesheets
--------------------------------

-   Easier to maintain
-   Accessibility
-   Smaller HTML document
    -   CSS files can be cached by the browser

-   Separate styles from content

CSS Inheritance
---------------

-   Properties that Inherit

    > -   color
    > -   line-height
    > -   list-style (and related properties)
    > -   text-align
    > -   visibility

-   Properties that don’t Inherit:

    > -   background
    > -   border
    > -   display
    > -   float and clear
    > -   height and width
    > -   margin
    > -   overflow
    > -   padding
    > -   position
    > -   text-decoration
    > -   z-index

> **note**
>
> CSS Inheritance is A Good Thing because it reduces file size and typing effort!

Specificity
-----------

-   <http://www.smashingmagazine.com/2007/07/27/css-specificity-things-you-should-know/>
-   Specificity determines which CSS rule the browser applies.
-   If two selectors apply to the same element, the one with higher specificity wins.

### Specificity hierarchy

1.  Inline styles `<h1 style="color: #fff;">` -&gt; Don’t use
2.  IDs `#carousel`
3.  Classes `.blog_post`
4.  Elements and pseudo elements `span ; :hover`

### How to measure specificity?

-   Start at 0, add 1000 for style attribute, add 100 for each ID, add 10 for each attribute, class or pseudo-class, add 1 for each element name or pseudo-element. So in

``` sourceCode
body #content .data img:hover
```

the specificity value would be 122 (0,1,2,2 or 0122): 100 for \#content, 10 for .data, 10 for :hover, 1 for body and 1 for img

Shorthand properties
--------------------

Long way:

``` sourceCode
body {
    background: url(bg.gif);
    background-color: #fff;
    background-repeat: repeat-x;
}
```

Short way is better -

``` sourceCode
body {
    background: url(bg.gif) #fff repeat-x;
}
```

### “The Clock”

top, right, bottom, left:

``` sourceCode
p {
    margin: 1px 2px 3px 4px;
}
```

all margins set to 2px:

``` sourceCode
p {
    margin: 2px;
}
```

top and bottom: 1px;
right and left: 2px:

``` sourceCode
p {
    margin: 1px 2px;
}
```

top: 1px;
right and left: 2px;
bottom: 3px:

``` sourceCode
p {
    margin: 1px 2px 3px;
```