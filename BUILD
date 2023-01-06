genrule(
  name = "build_haxelib",
  srcs = ["haxelib.json","src/main/haxe"],
  outs = ["haxelib.zip"],
  cmd  = "zip -r $OUT $SRCS" 
)