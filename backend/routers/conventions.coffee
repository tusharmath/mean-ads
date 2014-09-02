exports.actionMap = [
    ['create', 'post', (str) -> "/#{str}"]
    [ 'list', 'get', (str) -> "/#{str}"]
    [ 'first', 'get', (str) -> "/#{str}/:id"]
    [ 'update', 'put', (str) -> "/#{str}/:id"]
    [ 'remove', 'delete', (str) -> "/#{str}/:id"]
]

exports.resources = [
    'programs'
    'styles'
    'keywords'
    'subscriptions'
    'campaigns'
]