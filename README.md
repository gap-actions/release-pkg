# release-pkg

This GitHub action helps making releases of a GAP package.

## Usage

The action `release-pkg` has to be called by the workflow of a GAP
package.
It creates release archives and publishes them in a GitHub release.


### Examples

See below for a minimal example to run this action.

#### Minimal example
```yaml
name: Release

# Trigger the workflow on push or pull request
on:
  workflow_dispatch:

jobs:
  release:
    name: "Release the GAP package"
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v5
      - uses: gap-actions/setup-gap@v2
        with:
          GAP_PKGS_TO_BUILD: json
      - uses: gap-actions/build-pkg-docs@v1
      - uses: gap-actions/release-pkg@v1
```

#### Larger example

The following example adds a boolean input to test the Release without actually publishing it on GitHub.
```yaml
name: Release

# Trigger the workflow on push or pull request
on:
  workflow_dispatch:
    inputs:
      dry-run:
        description: "Do not upload the release to GitHub"
        type: boolean
        required: false
        default: false

jobs:
  release:
    name: "Release the GAP package"
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v5
      - uses: gap-actions/setup-gap@v2
        with:
          GAP_PKGS_TO_BUILD: json
      - uses: gap-actions/build-pkg-docs@v1
        with:
          use-latex: true
      - uses: gap-actions/release-pkg@v1
        with:
          dry-run: ${{ inputs.dry-run }}
```

## Contact
Please submit bug reports, suggestions for improvements and patches via
the [issue tracker](https://github.com/gap-actions/release-pkg/issues).

## License
The action `release-pkg` is free software; you can redistribute
and/or modify it under the terms of the GNU General Public License as published
by the Free Software Foundation; either version 2 of the License, or (at your
opinion) any later version. For details, see the file `LICENSE` distributed
with this action or the FSF's own site.
