Accessibility
=============

## Table of Contents

1. [Overview](#overview)
1. [Tools](#tools)
1. [How To Test](#how-to-test)
1. [What to Look For](#what-to-look-for)

# Overview

Accessibility compliance is important beacause it allows *all* people to use our website. It is also legally obligated in some countries - see [Wikipedia about WCAG](https://en.wikipedia.org/wiki/Web_Content_Accessibility_Guidelines#Legal_obligations) and [ADA 2010 Standards](https://www.ada.gov/2010ADAstandards_index.htm). We follow [Web Content Accessibility Guidelines 2.0 AA compliance](https://www.w3.org/WAI/WCAG20/quickref/?currentsidebar=%23col_customize&levels=aa>).

Below are presentations about the benefits of accessbility and general accessbility guidelines by Alli:

-   [Consumer Accessibility Benefit Presentation (Q1 2016)](https://docs.google.com/a/eventbrite.com/presentation/d/1tfRxOJ1N6MAWLo6Mey2TSqFvpD5d1sOKm6ssYJNE5tA/edit?usp=sharing)
-   [How to be Accessible Slides](http://slides.com/alacker/how-to-accessible/)

# Tools

-   [WCAG 2.0 AA Checklist](https://www.w3.org/WAI/WCAG20/quickref/?currentsidebar=%23col_customize&levels=aa)
-   [Tota11y Plugin](http://khan.github.io/tota11y/)
-   [WAVE Chrome Extension](http://wave.webaim.org/extension/)
-   [SSA Standard Keyboard Shortcuts](https://www.ssa.gov/accessibility/keyboard_nav.html)

The [Web Content Accessbiility Guidelines](https://www.w3.org/WAI/intro/wcag) is developed by World Wide Web Consortium (W3C). Tota11y is now installed on all EVB Dev and EVBQA pages (thanks Amira!) for testing. Download WAVE at the link above for use on Chrome.

# How To Test

### Validators

-   Install WAVE and/or open Tota11y (installed on Dev and QA)
-   Open one of the validators (Tota11y or WAVE)
-   See the Checklist below for more details

### Tab Through

-   Tab through the page using only a keyboard.
    -   Can you do all the interactions you want?
    -   Try some of the SSA keyboard shortcuts from above.

### Automation Tests

-   Add accessibility checks to automation tests by calling:

``` sourceCode
Accessibility(self.driver).full_accessibility_audit()
```

### VoiceOver

VoiceOver is a screenreader built into Mac computers. Check out this [VoiceOver Tutorial]

| Keyboard Shortcut | Action |
| --- | --- |
| Command-F5 | On/Off |
| Ctrl OR Caps Lock | Pause/Unpause | 
| Ctrl + Option + A | Start Reading |
| Ctrl + Option + U | View Page Navigation |
| Ctrl + Option + U + Arrows | Change Navigation Type |
| Ctrl + Option + Arrows | Read Previous/Next |

-   Do your headings make sense?
-   Do your your icons get read?
-   Can you find everything you would want to?

# Checklist: What to Look For

> **warning**
>
> This is not complete. For a full overview, read the [WCAG 2.0 AA guidelines][WCAG 2.0 AA compliance].

### Images

 - All `<img>` tag must have an `alt` attribute. These should be empty if the image is only decoration or is not visible to users.

### Contrast and Color

 - Text must be at least 4.5:1 contrast with the background behind it
 - Large text (<18px) may be 3:1 ratio
 - Logos are exempt from this requirement
 - Color cannot be the only visual thing conveying information (ie: a link must be differentiated by more than color)

### Headers

 - Heading structure must indicate hierarchy and relationship between sections of the page

### Zoom
 
 - You should be able to zoom in on the page to 200% and still be able to read content

### Keyboard

 - You should be able to do everything on the page by using only your keyboard
 - You should always be able to see what element is focused with a visual differentiator

### Title

 - Every page must have a descriptive title explaining the page contents

### Links

 - All links must have descriptive content inside explaining what it is linking to. With our site this means to be careful of links that are icons, or that say things like "more". (Users often navigate webpages by looking at only the links and not surrounding content)

### Inputs

 - Every input needs a label associated with it
 - If an input is required, it must have aria-required=True
 - If an error is automatically detected, the error must be described to the user in text
 - Must provide suggestions for fixing content when there are errors

### Consistent Navigation

 - Pages should maintain the same relative order for navigation
 - Components that have the same functionality are identified the same

### Good HTML Markup

 - Complete start and end tags
 - Correct nesting
 - No duplicate ids or attributes

### Purchase-Specific Implementations

 - Must be reversible or ask for confirmation
 - Must allow for longer time frames and communicate timeouts

  [Wikipedia about WCAG]: https://en.wikipedia.org/wiki/Web_Content_Accessibility_Guidelines#Legal_obligations
  [ADA 2010 Standards]: http://www.ada.gov/2010ADAstandards_index.htm
  [WCAG 2.0 AA compliance]: https://www.w3.org/WAI/WCAG20/quickref/?currentsidebar=%23col_customize&levels=aaa
  [Consumer Accessibility Benefit Presentation]: https://docs.google.com/a/eventbrite.com/presentation/d/1tfRxOJ1N6MAWLo6Mey2TSqFvpD5d1sOKm6ssYJNE5tA/edit?usp=sharing
  [How to be Accessible Slides]: http://slides.com/alacker/how-to-accessible#/
  [Tota11y Plugin]: http://khan.github.io/tota11y/
  [WAVE Chrome Extension]: http://wave.webaim.org/extension/
  [SSA Standard Keyboard Shortcuts]: https://www.ssa.gov/accessibility/keyboard_nav.html
  [Web Content Accessbiility Guidelines]: https://www.w3.org/WAI/intro/wcag
  [VoiceOver Tutorial]: http://webaim.org/articles/voiceover
