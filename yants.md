yants
=====

This is a tiny type-checker for data in Nix, written in Nix.

Features:

* Checking of primitive types (`int`, `string` etc.)
* Checking polymorphic types (`option`, `list`, `either`)
* Defining & checking struct/record types
* Defining & matching enum types
* Defining function signatures (including curried functions)
* Types are composable! `option string`! `list (either int (option float))`!

Lacking:

* Any kind of inference (Nix's reflection ability is not strong enough)
* Convenient syntax for attribute-set function signatures

## Primitives & simple polymorphism

![simple](https://gist.githubusercontent.com/tazjin/ad6d48bc2416335acc5da4a197eb9ddc/raw/d7b1fa0a511ae40f0831b369df4b97103441c7e5/z-simple.png)

## Structs

![structs](https://gist.githubusercontent.com/tazjin/ad6d48bc2416335acc5da4a197eb9ddc/raw/d7a7cff3639115538a5085561bedf11cb36d04e7/z-structs.png)

## Nested structs!

![nested structs](https://gist.githubusercontent.com/tazjin/ad6d48bc2416335acc5da4a197eb9ddc/raw/d7b1fa0a511ae40f0831b369df4b97103441c7e5/z-nested-structs.png)

## Enums!

![enums](https://gist.githubusercontent.com/tazjin/ad6d48bc2416335acc5da4a197eb9ddc/raw/b435b5996a176a9e824c42da4713a1d30f261338/z-enums.png)

## Functions!

![functions](https://gist.githubusercontent.com/tazjin/ad6d48bc2416335acc5da4a197eb9ddc/raw/ccece1eb9a1cb3b1add1ba1a1f65df3adca64a8f/z-functions.png)
