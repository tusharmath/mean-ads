gulp = require 'gulp'
inject = require 'gulp-inject'
bowerFiles = require 'main-bower-files'
bowerInstall = require 'gulp-bower'
rename = require 'gulp-rename'

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
			"'#{filepath}'"
	.pipe gulp.dest 'frontend/lib/'

gulp.task 'move-files', ->
	gulp.src 'frontend/modules/**/*Ctrl.coffee'
	.pipe rename (path) ->
		basename = path.basename.replace /Ctrl/, ''

		path.basename = "#{basename.toLowerCase()}-ctrl"
		return undefined
	.pipe gulp.dest 'frontend/modules'

gulp.task 'setup-assets', ['bower-copy', 'non-bower-copy', 'inject-modules']
