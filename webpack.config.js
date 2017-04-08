const path = require('path')
const webpack = require('webpack')

const config = {
  entry: './src/index.js',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'bundle.js'
  },
  module: {
    rules: [
      {
        test: /\.elm$/,
        include: path.resolve(__dirname, 'src'),
        use: [
          {
            loader: 'elm-hot-loader'
          },
          {
            loader: 'elm-webpack-loader',
            options: {
              warn: true,
              debug: false
            }
          }
        ]
      }
    ]
  },
  resolve: {
    extensions: ['.elm', '.js']
  },
  devServer: {
    contentBase: 'static/',
    hot: true,
  },
  plugins: [new webpack.HotModuleReplacementPlugin()]
}

module.exports = config