# Jekyll::DirectoryTag

This tag lets you iterate over files at a particular path. The directory tag yields a `file` object and a [`forloop`](http://wiki.shopify.com/UsingLiquid#For_loops) object.
If files conform to the standard Jekyll format, YYYY-MM-DD-file-title, then those attributes will be populated on that `file` object.

## Installation

In your plugins directory:

```bash
curl -L -O https://github.com/sillylogger/jekyll-directory/raw/master/_plugins/directory_tag.rb
```

## Syntax

```html
{% directory path: path/from/source [reverse] [exclude] %}
  {{ file.date }}
  {{ file.name }}
  {{ file.slug }}
  {{ file.url }}

  {{ forloop }}
{% enddirectory %}
```

### parameters:

- `reverse` - Defaults to 'false', ordering files the same way `ls` does: 0-9A-Za-z.
- `exclude` - Defaults to '.html$', a Regexp of files to skip.
- `bydate`  - Sorts by date. Adding also 'reverse' switches the order.

### file attributes:

- `url` - The absolute path to the published file
- `name` - The basename
- `date` - The date extracted from the filename, otherwise the file's creation time
- `slug` - The basename with date and extension removed

### forloop attributes:

See Shopify's liquid documentation [here](http://wiki.shopify.com/UsingLiquid#For_loops).

## Usage

images:

```html
<ul>
  {% directory path: images/vacation exclude: private %}
    <li>
      <img src="{{ file.url }}"
           alt="{{ file.name }}"
           datetime="{{ file.date | date_to_xmlschema }}" />
    </li>
  {% enddirectory %}
</ul>
```

downloads:

```html
{% directory path: torrents/complete %}
  <a href="{{ file.url }}" >{{ file.name }}</a>{% unless forloop.last %}, {% endunless %}
{% enddirectory %}
```

