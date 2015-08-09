require('coffee-script');

var webpack = require("webpack");

webpack({
  context: __dirname + "/app",
  entry: "./entry.coffee",
  output: {
      path: __dirname + "/dist",
      filename: "bundle.js"
  },

  resolve: {
    extensions: ["", ".js", ".coffee"],
    alias: {
      "firebase": "firebase/lib/firebase-web",
      "angular-bootstrap": "angular-bootstrap-npm/dist/angular-bootstrap",
      "uploadcare": "uploadcare/uploadcare-2.3.4"
    },
    root: __dirname + "app"
  },

  module: {
      loaders: [
          { test: /\.coffee$/, loader: "coffee-loader" },
          { test: /\.(coffee\.md|litcoffee)$/, loader: "coffee-loader?literate" }
      ]
  },

  plugins: [
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery"
    })
  ]  
}, function(err, stats) {
  console.log(stats)
});

var connect = require('connect');
var serveStatic = require('serve-static');
connect().use(serveStatic(__dirname)).listen(process.env.PORT || 5000);
