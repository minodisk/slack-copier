fs = require 'fs'
{inc} = require 'semver'
increase = (v) -> inc v, 'patch'

PACKAGE_JSON = 'package.json'
MANIFEST_JSON = 'dest/manifest.json'

pkg = JSON.parse fs.readFileSync PACKAGE_JSON
pkg.version = increase pkg.version
fs.writeFileSync PACKAGE_JSON, JSON.stringify pkg, null, 2

manifest = JSON.parse fs.readFileSync MANIFEST_JSON
manifest.version = pkg.version
fs.writeFileSync MANIFEST_JSON, JSON.stringify pkg, null, 2
