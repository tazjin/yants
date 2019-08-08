# Provides a "type-system" for Nix that provides various primitive &
# polymorphic types as well as the ability to define & check records.
#
# All types (should) compose as expected.
#
# TODO:
#  - error messages for type-checks of map/list elements are bad
#  - enums?

{ toPretty ? ((import <nixpkgs> {}).lib.generators.toPretty) }:

# Checks are simply functions of the type `a -> bool` which check
# whether `a` conforms to the specification.
with builtins; let
  # Internal utilities:
  typeError = type: val:
  throw "Expected type '${type}', but value '${toPretty {} val}' is of type '${typeOf val}'";

  typedef = name: check: {
    inherit name check;
    __functor = self: value:
      if check value then value
      else typeError name value;
  };

  poly = n: c: { "${n}" = t: typedef "${n}<${t.name}>" (c t); };

  poly2 = n: c: {
    "${n}" = t1: t2: typedef "${n}<${t1.name},${t2.name}>" (c t1 t2);
  };

  typeSet = foldl' (s: t: s // (if t ? "name" then { "${t.name}" = t; } else t)) {};

  # Struct checker implementation
  #
  # Checks performed:
  # 1. All existing fields match their types
  # 2. No non-optional fields are missing.
  # 3. No unexpected fields are in the struct.
  #
  # Anonymous structs are supported (e.g. for nesting) by omitting the
  # name.
  checkField = def: value: current: field:
  let
    fieldVal = if hasAttr field value then value."${field}" else null;
    type = def."${field}";
    checked = type.check fieldVal;
  in if checked then (current && true)
     else (throw "Field ${field} is of type ${typeOf fieldVal}, but expected ${type.name}");

  checkExtraneous = name: def: present:
  if (length present) == 0 then true
  else if (hasAttr (head present) def)
    then checkExtraneous name def (tail present)
    else (throw "Found unexpected field '${head present}' in struct '${name}'");

  struct' = name: def: {
    inherit name def;
    check = value:
      let
        fieldMatch = foldl' (checkField def value) true (attrNames def);
        noExtras = checkExtraneous name def (attrNames value);
      in (isAttrs value && fieldMatch && noExtras);

    __functor = self: value: if self.check value
      then value
      else (throw "Expected '${self.name}'-struct, but ${toPretty value} is of type ${typeOf value}");
  };

  struct = arg:
  if isString arg then (struct' arg)
  else (struct' "anonymous" arg);
in (typeSet [
  # Primitive types
  (typedef "any" (_: true))
  (typedef "int" isInt)
  (typedef "bool" isBool)
  (typedef "float" isFloat)
  (typedef "string" isString)

  # Polymorphic types
  (poly "option" (t: v: (isNull v) || t.check v))
  (poly "list" (t: v: isList v && (foldl' (s: e: s && (t.check e)) true v)))
  (poly "attrs" (t: v:
    isAttrs v && (foldl' (s: e: s && (t.check e)) true (attrValues v))
  ))
  (poly2 "either" (t1: t2: v: t1.check v || t2.check v))
]) // { inherit struct; }
