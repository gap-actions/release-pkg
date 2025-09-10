# release-pkg

This GitHub action helps making releases of a GAP package.

## Usage

Once this action has been properly set up in a GitHub Actions workflow
for your GAP package (as described in the subsequent sections of this
document), you can make a new release of your package by following
these steps:

1. Update the version and release date in `PackageInfo.g` and anywhere
   else it appears (e.g. a changelog file).

2. Navigate to the `Actions` tab of your package's GitHub repository.<br>
   <img src="./images/make_release_step_1.png" width="560" alt="The Actions tab">

3. On the left side is a list of all workflows configured for your package.
   Locate the "Release" workflow and click on it.<br>
   <img src="./images/make_release_step_2.png" width="560" alt="The link to the Release workflow">

4. Now towards the right side of your browser window, a button "Run workflow"
   should have appeared; click it.<br>
   <img src="./images/make_release_step_3.png" width="560" alt="The first 'Run workflow' button">

5. The click should have revealed a new box with a big green button also labelled
   "Run workflow". Once again, click it.<br>
   <img src="./images/make_release_step_4.png" width="560" alt="The second 'Run workflow' button">

If everything is configured right, the new release of your package should
appear on GitHub and your package's website within a few minutes.


## Installation

The action `release-pkg` has to be called by the workflow of a GAP
package.
It creates release archives and publishes them in a GitHub release.

It is recommended to create a separate YAML file inside the
`.github/workflows/` folder of your package, containing a workflow
that calls this action. By setting the trigger to `workflow_dispatch`,
you can then manually create a release from the "Actions" tab of your
repository.

By default, this action will fail if there already exists a release
with the same version number, or if the date in `PackageInfo.g` is more
than 1 day off from the current date. These safety checks can be turned
off using the `force` input.

### Migration from ReleaseTools

 - It is not necessary to provide a token. This action will automatically
   use your repository's `GITHUB_TOKEN`.
 - The documentation **will not** be compiled during this action. This must
   be done in a separate step in the release workflow, e.g. by the action
   [build-pkg-docs](https://github.com/gap-actions/update-gh-pages), as
   shown in the examples later in this document.
 - If your package has a `.release` script, this **will not** be executed.
   Instead, add a separate step in your release workflow, before this action.
   This step can either invoke your `.release` script, or you can copy the
   content of that script into the step and delete the script afterwards.
 - The GitHub Pages **will not** be updated. This is now done by a separate
   action, [update-gh-pages](https://github.com/gap-actions/update-gh-pages).
   This is also demonstrated in the examples below.

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

#### Minimal example

Below is a minimal example of a workflow using this action. It does the
absolute minimum and for example does not update your package's website. For
that, look at the next example.

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
      - uses: gap-actions/setup-gap@v3
      - uses: gap-actions/build-pkg-docs@v2
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
        description: "Only create an archive containing the release instead of publishing it on GitHub"
        type: boolean
        required: false
        default: false
      force:
        description: "Allow overwriting an existing release, or making a release with an incorrect date"
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
      - uses: gap-actions/setup-gap@v3
      - uses: gap-actions/build-pkg-docs@v2
        with:
          use-latex: true
      - uses: gap-actions/release-pkg@v1
        with:
          dry-run: ${{ inputs.dry-run }}
          force: ${{ inputs.force }}
      - uses: gap-actions/update-gh-pages@v1
        if: ${{ !inputs.dry-run }}
```

We recommend that you start with this example in your package and refine
it as needed. For example you could insert an additional `run` step before
`release-pkg` to perform additional work before creating the release archives,
such as compressing data files (the smallgrp package does that in its
[release workflow](https://github.com/gap-packages/smallgrp/blob/master/.github/workflows/release.yml)),
or deleting files that should not end up in the release archives.

## Contact
Please submit bug reports, suggestions for improvements and patches via
the [issue tracker](https://github.com/gap-actions/release-pkg/issues).

## License
The action `release-pkg` is free software; you can redistribute
and/or modify it under the terms of the GNU General Public License as published
by the Free Software Foundation; either version 2 of the License, or (at your
opinion) any later version. For details, see the file `LICENSE` distributed
with this action or the FSF's own site.
