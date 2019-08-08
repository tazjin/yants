with (import ./yants.nix {});
with builtins;

# Note: Derivations are not included in the tests below as they cause
# issues with deepSeq.

deepSeq rec {
  # Test that all primitive types match
  primitives = [
    (int 15)
    (bool false)
    (float 13.37)
    (string "Hello!")
    (function (x: x * 2))
  ];

  # Test that polymorphic types work as intended
  poly = [
    (option int null)
    (list string [ "foo" "bar" ])
    (either int float 42)
  ];

  # Test that structures work as planned.
  person = struct "person" {
    name = string;
    age  = int;

    contact = option (struct {
      email = string;
      phone = option string;
    });
  };

  testPerson = person {
    name = "Brynhjulf";
    age  = 42;
    contact.email = "brynhjulf@yants.nix";
  };

  # Test enum definitions & matching
  colour = enum "colour" [ "red" "blue" "green" ];
  testMatch = colour.match "red" {
    red = "It is in fact red!";
    blue = throw "It should not be blue!";
    green = throw "It should not be green!";
  };
} "All tests passed!\n"
