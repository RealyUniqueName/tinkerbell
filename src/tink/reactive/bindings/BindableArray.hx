package tink.reactive.bindings;
import tink.lang.Cls;

/**
 * ...
 * @author back2dos
 */

class BindableArray<T> implements Cls {
	var data:Array<T>;
	static inline var CHANGE = 'change';//TODO: all this is not particularly granular, but optimizing it is non-trivial since operations like shift mess with the whole array
	@:bindable(change) @:read(data.length) var length:Int;
	public function new(?data) {
		this.data = data == null ? [] : data;
	}
	function onChange<T>(value:T) {
		this.bindings.fire(CHANGE);
		return value;
	}
	@:bindable(CHANGE) public function first() {
		return data[0];
	}
	@:bindable(CHANGE) public function last() {
		return data[data.length - 1];
	}
	public function push(x:T):Int {
		return onChange(data.push(x));
	}
	public function pop(x:T):Null<T> {
		return onChange(data.pop());
	}
	public function unshift(x:T):Int {
		onChange(data.unshift(x));
		return length;
	}
	public function shift():Null<T> {
		return onChange(data.shift());
	}
	@:bindable(CHANGE) public function get(index:Int) {
		return data[index];
	}
	public function set(index:Int, x:T) {
		return onChange(data[index] = x);
	}
	@:bindable(CHANGE) public function iterator() {
		return data.iterator();
	}
	
}