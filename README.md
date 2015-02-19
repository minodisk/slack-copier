# slack-copier [![Circle CI][circleci-image]][circleci-url] [![Coverage Status][coveralls-image]][coveralls-url] [![dependencies][dependencies-image]][dependencies-url]

A Chrome extension to copy text as markdown in Slack


## Development

> Managed with gulp.

### Ready

```sh
npm install
```

### Building and testing

```sh
gulp
```

### Publish

```sh
gulp publish

npm run bump
git commit package.json -m "Bump"
git push
```

[circleci-image]: https://img.shields.io/circleci/project/minodisk/slack-copier/master.svg?style=flat-square
[circleci-url]: https://circleci.com/gh/minodisk/slack-copier/tree/master
[coveralls-image]: https://img.shields.io/coveralls/minodisk/slack-copier.svg?style=flat-square
[coveralls-url]: https://coveralls.io/r/minodisk/slack-copier
[dependencies-image]: http://img.shields.io/david/minodisk/slack-copier.svg?style=flat-square
[dependencies-url]: https://david-dm.org/minodisk/slack-copier
