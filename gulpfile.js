var gulp = require('gulp'),
    gutil = require('gulp-util'),
    sass = require('gulp-sass'),
    connect = require('gulp-connect'),
    autoprefixer = require('gulp-autoprefixer'),
    minifyCSS = require('gulp-minify-css'),
    jade = require('gulp-jade'),
    coffee = require('gulp-coffee');

gulp.task('lib-copy', function() {
    gulp.src('src/lib/**/*')
        .pipe(gulp.dest('target/scripts'));
});

gulp.task('assets', function() {
    gulp.src('./src/assets/**/*')
        .pipe(gulp.dest('target/assets'));
});

gulp.task('coffee', function() {
    gulp.src('src/scripts/**/*.coffee')
        .pipe(coffee({bare: true}).on('error', gutil.log))
        .pipe(gulp.dest('target/scripts'))
        .pipe(connect.reload());
});

gulp.task('sass', function(){
   return gulp.src('src/styles/**/*.scss')
       .pipe(sass())
       .pipe(autoprefixer({ browsers: ['last 2 version'] }))
       .pipe(gulp.dest('target/styles'))
       .pipe(connect.reload());
});

gulp.task('jade', function() {
    gulp.src('./src/**/*.jade')
        .pipe(jade())
        .pipe(gulp.dest('./target/'))
        .pipe(connect.reload());
});

gulp.task('watch', [], function(callback) {
    gulp.watch('src/styles/**/*.scss', ['sass']);
    gulp.watch('src/scripts/**/*.coffee', ['coffee']);
    gulp.watch('src/**/*.jade', ['jade']);
    gulp.watch('./src/assets/**/*', ['assets']);
});

gulp.task('connect', function() {
    connect.server({
        root: 'target',
        port: 8282,
        livereload: true
    });
});

gulp.task('default', ['lib-copy', 'coffee', 'sass', 'jade', 'assets', 'connect', 'watch']);