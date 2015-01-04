gulp = require 'gulp'
browserify = require 'gulp-browserify'
inject = require 'gulp-inject'
rename = require 'gulp-rename'
bowerFiles = require 'main-bower-files'
bowerInstall = require 'gulp-bower'
config = require './backend/config/config'

gulp.task 'bower-install', -> bowerInstall()

# TODO: remove bower-copy
gulp.task 'bower-copy', ['bower-install'], ->
	gulp.src bowerFiles()
	.pipe gulp.dest 'frontend/lib'

nonBowerMainFiles = [
	'./bower_components/ace-builds/src/*'
]
gulp.task 'non-bower-copy', ['bower-install'], ->
	gulp.src nonBowerMainFiles
	.pipe gulp.dest 'frontend/lib'

gulp.task 'inject-modules', ->
	gulp.src 'frontend/modules/**/*.coffee', read: false
	.pipe inject 'frontend/module-loader.coffee',
		starttag: '# start-inject:modules'
		endtag: '# end-inject'
		transform: (filepath, file, index, length) ->
			filepath = filepath
			.replace /^.+?\//, '' #removes frontend/, .tmp/
			.replace /\.coffee/, '' #remove the .coffee extension
			"require('../#{filepath}')"
	.pipe gulp.dest 'frontend/lib/'

gulp.task 'move-files', ->
	rename = require 'gulp-rename'
	clean = require 'gulp-clean'

	gulp.src 'frontend/**/*ctrl.coffee'
	.pipe clean()
	.pipe rename (path) ->
		# dirname = path.dirname.replace 'modules', 'templates'
		# console.log path
		basename = path.basename.replace /\-ctrl/, 'Ctrl'
		basename = basename.replace /.?/, basename[0].toUpperCase()
		# console.log basename
		path.basename = basename
		return undefined
	.pipe gulp.dest 'frontend'
gulp.task 'browserify', ->
	gulp.src './backend/sdk/init.coffee', read: false
	.pipe browserify(
		debug: config.browserify.debug
		transform: ['coffeeify']
		extensions: ['.coffee']
		)
	.pipe rename 'meanads-sdk.js'
	.pipe gulp.dest './frontend/lib'
gulp.task 'browserify-fe', ->
	gulp.src './frontend/app-bootstrap.coffee', read: false
	.pipe browserify(
		debug: config.browserify.debug
		external: ['angular']
		transform: ['coffeeify']
		extensions: ['.coffee']
		)
	.pipe rename 'meanads-client.js'
	.pipe gulp.dest './frontend/lib'

gulp.task 'watch', ->
	gulp.watch 'frontend/modules/**/*.coffee', ['inject-modules']
	gulp.watch 'backend/sdk/*.coffee', ['browserify']
	gulp.watch 'bower.json', ['setup-assets']

gulp.task 'setup-assets', ['bower-copy', 'non-bower-copy', 'inject-modules', 'browserify']

