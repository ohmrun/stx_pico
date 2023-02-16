genrule(
  name = "build_haxelib",
  srcs = ["haxelib.json","src/main/haxe","CHANGELOG.md"],
  outs = ["haxelib.zip"],
  cmd  = "zip -r $OUT $SRCS"
)