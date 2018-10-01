# hide-lines-plus

Hide or fold lines matched on regex patterns. See examples below.

1) **Hide comments**: Pattern `^\s*//` + default marker
![comments](https://user-images.githubusercontent.com/4193335/46317472-6058be00-c5d3-11e8-869f-e7ec584fc16a.gif)

2) **Hide answers**: Pattern `^>` + custom marker
![question-words](https://user-images.githubusercontent.com/4193335/46316917-c7757300-c5d1-11e8-8214-0d9ba139d520.gif)

## Keys

* `alt + a` : toggle hide/unhide matched lines

## Settings

* **Patterns**: Comma separated list of regex patterns to hide. Default value is `^>`
* **Use Custom Marker**: Use `Show >` marker insetad of the default one

_This plugin is inspired by [hide-lines](https://atom.io/packages/hide-lines)._
