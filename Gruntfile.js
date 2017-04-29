"use strict";

module.exports = function(grunt) {
    grunt.initConfig({
        pkg: grunt.file.readJSON("package.json"),
        watch: {
            elm: {
                files: ["src/*.elm"],
                tasks: ["elm:make"]
            },
            sass: {
                files: ["src/wwwroot/css/*.scss", "src/wwwroot/css/**/*.scss"],
                tasks: ["sass:process"]
            }
        },
        elm: {
            make: {
                options: {
                    yes: true,
                    debug: true
                },
                files: {
                    "src/wwwroot/js/main.js": ["src/Main.elm"]
                }
            }
        },
        sass: {
            process: {
                options: {
                    outputStyle: "expanded",
                    sourceMapEmbed: true,
                    sourceMap: "src/wwwroot/app.css.map"
                },
                files: {
                    "src/wwwroot/css/app.css": "src/wwwroot/css/app.scss"
                }
            }
        },
        postcss: {
            options: {
                map: true,
                processors: [require("autoprefixer")]
            },
            process: {
                src: "src/wwwroot/css/app.css"
            }
        }
    });

    grunt.loadNpmTasks("grunt-contrib-watch");
    grunt.loadNpmTasks("grunt-elm");
    grunt.loadNpmTasks("grunt-sass");
    grunt.loadNpmTasks("grunt-postcss");

    grunt.registerTask("default", ["elm:make"]);
}