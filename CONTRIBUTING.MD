# Alidade Contribution Guidelines

Thanks for your interest in contributing to the development of Alidade!
This document will outline some of the guidelines to follow when making a
contribution.


## Ensure changes have tests, wherever possible.

Any change made to the codebase should come with accompanying unit or UI
tests to ensure that it remains testable and reproducible over platform
and code change boundaries. Following test-driven development isn't
strictly required, but it is a recommendation.

## Ensure files are properly linted and formatted.

This project leverages SwiftLint and swift-format to ensure consistent
formatting and that code follows best practices. Run the formatter inside
Xcode and lint your files before committing.

## Provide meaningful commit messages.

Commit messages on this project follow a type-summary-description based approach
that tries to explains as much as possible while being concise. An example is
provided below:

```
Disable rxn_use_guides (#31)

User tests on this feature have concluded that the guide wasn't used at
all. Most users didn't discover the feature until late into the game;
by then, users were already familiar with the mechanics and didn't need
a guide to ensure they draw lines within the puzzle bounds. This flag
will be disabled as a result, and it will be removed from the codebase
in future commits.

Closes #31.
```

- The first component is a summary of the changes being made. Try to be as
  descriptive and concise as possible.
    - If a lot of changes have been made with no clear objective, use "Do stuff"
      as the summary; however, this should be avoided at all costs, as it may
      become unclear over time what changes were made.
- Finally, if you want to provide an addition description, separate it with a
  line as a new paragraph. The description should contain details on the change,
  why it was made, and the impact of it.
