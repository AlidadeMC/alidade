# Documentation Styleguide

@Metadata {
    @PageImage(purpose: card, source: "Card-Styleguide")
}

Learn and understand the style guide used to author documentation.

## Overview

Alidade's documentation aims to provide sufficient, concise, and clear
information about the codebase, file format, and more. The following
document outlines the best practices when authoring documentation.

## Guidelines

> Documentation does not need to _strictly_ follow the guidelines listed
> below, but it is generally recommended to be consistent.

### Refer to end users as players.

Most applications will use the term _end user_ or _user_ to describe the
person or people using said application. However, Alidade documentation
refers to these people as _players_, since they are likely using Alidade
as an aid to their Minecraft experience.

### Keep documentation readable at smaller sizes.

Documentation written for Alidade should span no wider than seventy-five
(75) characters or columns, unless the documentation is written as a
comment to an existing type. This helps ensure that documentation files
can be read on a wider variety of displays. Directives and annotations
such as `@Image` or Markdown tables are excluded from this guideline.
