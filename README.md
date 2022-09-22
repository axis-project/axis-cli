# Axis - A time management tool

## Data Design
| Collection	| Fields |
|-------------|--------|
|AxisItem	    |id title description timeCreated timeDue priority universe status |
|AxisUniverse	|name description |
	

## CLI design

```Shell
axis universe
$ axis-cli universe create
 usage: axis universe create [options] universe
	options:
		-d, —description text

$ axis-cli universe list
 usage: axis universe list [options]
	options:

$ axis-cli universe show
 usage: axis universe show  [options] name
	options:

$ axis-cli universe delete
 usage: axis universe delete [options] name
	options:
		-f, —force

$ axis-cli universe update
usage: axis universe update [options] name
	options:
		—name text
		-d, —description	text

axis item
$ axis-cli item create
usage: axis item create [options] title
	options:
		-p, —priority value		default: 1
		-u, —universe name	(required)
		—due timestamp
		-d, —description	text

$ axis-cli item list
 usage: axis item list [options]
	options:
		-n, —limit N	default: 20	max: 100
		—skip M	
		-f, —filter json
		-p, —priority value	
		-u, —universe name
		-s, —status string

$ axis-cli item search
 usage: axis item search [options] regex
	options:
		-n, —limit N	default: 20	max: 100
		—skip M
		-d, —search-description	default: False

$ axis-cli item show
 usage: axis item show  [options] id
	options:

$ axis-cli item delete
 usage: axis item delete [options] id
	options:

$ axis-cli item update
usage: axis item update [options] id
	options:
		-t, —title text
		-p, —priority value
		—due timestamp
		-d, —description text
		-s, —status string

$ axis-cli item move
usage: axis item move [options] id
	options:
		-u, —universe name
```
