exports.actionMap =
	'$create': ['post', (str) -> "/#{str}"]
	'$list': ['get', (str) -> "/#{str}"]
	'$count': ['get', (str) -> "/#{str}/count"]
	'$first': ['get', (str) -> "/#{str}/:id"]
	'$update': ['patch', (str) -> "/#{str}/:id"]
	'$remove': ['delete', (str) -> "/#{str}/:id"]
