# Eventbrite CSS Naming Style Guide

In addition to using CSS pre and post processors, we've adopted a variety of CSS naming conventions to keep our CSS modular and maintainable. Our CSS naming rules allow us to:

- scope our styles using namespaces instead of specific, difficult-to-override selectors
- quickly determine what a class is for and how it's meant to be used
- avoid accidentally removing or modifying classes meant for automation testing or JavaScript

## Table of Contents

0. [SMACSS](#smacss)
    0. [Layout]
    0. [State]
    0. [Javascript]
    0. [Automation]
0. [BEM](#bem)
0. [Helper Classes](#helper-classes)
0. [Resources](#resources)
0. [License](#license)

## SMACSS

We use our own flavor of [SMACSS](https://smacss.com/) for system-wide CSS class naming. SMACSS stands for Scalable and Modular Architecture for CSS. It organizes CSS classes by functionality __ and has general guidelines for keeping specificity low and, like Layout, State, Modular, Non-Modular. Some examples of how we use SMACSS within our code base:

- `.l-*` is for layout and spacing classes, like `.l-mar-top-5` or `l-media`
- `.is-*` is classes describing component state, like `.is-hidden`
- `.js-*` is for classes used only as JavaScript hooks, like `.js-`

## BEM

We use [BEM](https://en.bem.info/) for component-level CSS class naming. BEM stands for Block Element Modifier and describes a broad methodology for frontend development. It helps us encapsulate behaviors and understand components in terms of their parts and variations. We use the [hyphenated version](http://csswizardry.com/2013/01/mindbemding-getting-your-head-round-bem-syntax/) of BEM.

P.S. BEM is a lot more than just CSS class names; read more about it [here](https://en.bem.info/methodology/)).

### Block

A [block](https://en.bem.info/methodology/key-concepts/#block) is a standalone component. This would be an event card, navigation slat, or any reusable, self-contained _____.

```css
.block {}

.multi-word-block {}
```

When the name of a component is multiple words, we use a single dash as a delimiter, i.e. `.event-card`.

### Element

An [element](https://en.bem.info/methodology/key-concepts/#element) is a subcomponent of a block, and only exists within the scope of that block. This would be the event title in an event card, the ______, or any element that only exists as part of another element.

We use double underscores for subcomponents.

```css
.block__element {}
```

### Modifier

We use double dashes for modifiers, or variations of components and subcomponents.

```css
.block--modifier {}
```

Modifier refers to variations of either components or subcomponents. This would be poster versions of the event card, disabled versions of slats, ____________.

**Examples**

Taking the above rules, we can create meaningful classes for our components.

```css
// A basic event card
.event-card {}

// Poster version of the event card
.event-card--poster {}

// The title of an event card
.event-card__title {}
```

Order matters. `.slat--disabled__link` describes a disabled link in an otherwise normal slat, while `.slat--disabled__link` describes links when an entire slat is disabled.

```css
// A link in a disabled slat
.slat--disabled__link {}

// A disabled link in a slat
.slat__link--disabled {}
```

We don't always need a new class for every single variation, subcomponent, variation of a subcomponent. Sometimes the right thing to do *is* to use a more general selector (`.slat a`) rather than a new class (`.slat__link`).

Whenever you decide to, you're making a statement about its purpose _____,  Is it  a style you'll likely just override later. In SMACSS we call this [Depth of Applicability](https://smacss.com/book/applicability).

While

## Helper Classes

Helper classes, e.g. our grid and layout classes, don't use the BEM convention. Their ___ might differ depending on the ____.

`.l-mar-top-5` and `.l-pad-sm-`. See [Spacing Classes](spacing) for more on our spacing class conventions.

`.g-cell` `.g-cell-1-1`

especially

`.is-*` , `.is-hidden`

## Automation

(XXX: Where does this belong?)

We use `data-automation="automation-selector"` attributes for automation instead of CSS classes or IDs, to prevent style changes from affecting automation tests.

## Greppable Is Better Than "Perfect"

Remember that **greppable is better than perfect**.

We should always aim to future-proof, but changes are often unavoidable. A great CSS class name is better than a not-so-great name, but a not-so-great name you can search/replace later is a lot better than a great one you can't!

