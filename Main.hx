using stx.Pico;

import stx.pico.Test;

class Main {
	static function main() {
		#if test
		stx.pico.Test.main();
		#end
	}
}