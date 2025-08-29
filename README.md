# release-pkg

This GitHub action helps making releases of a GAP package.

## Usage

The action `release-pkg` has to be called by the workflow of a GAP
package.
It creates release archives and publishes them in a GitHub release.

It is recommended to create a separate YML file inside the
`.github/workflows` folder of your package, containing a workflow
that calls this action. By setting the trigger to `workflow_dispatch`,
you can then manually create a release from the "Actions" tab of your
repository.

By default, this action will fail if there already exists a release
with the same version number, or if the date in `PackageInfo.g` is more
than 1 day off from the current date. These safety checks can be turned
off using the `force` input.

### Inputs

All of the following inputs are optional.

- `dry-run`:
  - Set to `true` to create an archive containing the release
    instead of publishing it on GitHub.
  - default: `false`
- `force`:
  - Set to `true` to allow this action to overwrite an existing
    release, and to make a release with an incorrect date
  - default: `false`

### Examples

Examples of actual GAP packages using this action are
[aclib](https://github.com/gap-packages/aclib) and
[polycyclic](https://github.com/gap-packages/polycyclic).

Below is a minimal example of a workflow using this action.

#### Minimal example
```yaml
name: Release

on:
  workflow_dispatch:

permissions: write-all

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

The following example adds a boolean input `dry-run` to test the release without actually publishing it on GitHub,
and a second boolean input `force` to allow the workflow to overwrite an existing release.
It also uses the `update-gh-pages` action to update the GitHub Pages of the package after making the release.
```yaml
name: Release

on:
  workflow_dispatch:
    inputs:
      dry-run:
        description: "Set to true to create an archive containing the release instead of publishing it on GitHub"
        type: boolean
        required: false
        default: false
      force:
        description: "Set to true to allow this action to overwrite an existing release, and to make a release with an incorrect date"
        type: boolean
        required: false
        default: false

permissions: write-all

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
          force: ${{ inputs.force }}
      - uses: gap-actions/update-gh-pages@v1
        if: ${{ !inputs.dry-run }}
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
