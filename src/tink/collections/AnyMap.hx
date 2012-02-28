package tink.collections;
import tink.lang.Cls;

/**
 * ...
 * @author back2dos
 */

private class StringRepMap<T> extends tink.collections.abstract.StringIDMap < Dynamic, T > {
	override function transform(k:Dynamic) {
		return Std.string(k); 
	}
}
 
class AnyMap<V> implements Map<Dynamic,V>, implements Cls {
	var ints = new IntHash<V>();
	var strings = new Hash<V>();
	var objs = new ObjectMap<Dynamic, V>();
	var misc = new StringRepMap();
	public function new() {
		
	}
	public function get(k:Dynamic):Null<V> {
		return
			switch (Type.typeof(k)) {
				case TNull, TBool, TFloat, TUnknown: misc.get(k);
				case TInt: ints.get(k);
				case TClass(c):
					if (c == String) strings.get(k);
					else objs.get(k);
				case TObject, TFunction, TEnum(_): objs.get(k);
			}
	}
	public function set(k:Dynamic, v:V):V {
		switch (Type.typeof(k)) {
			case TNull, TBool, TFloat, TUnknown: misc.set(k, v);
			case TInt: ints.set(k, v);
			case TClass(c):
				if (c == String) strings.set(k, v);
				else objs.set(k, v);
			case TObject, TFunction, TEnum(_): objs.set(k, v);
		}		
		return v;
	}
	public function exists(k:Dynamic):Bool {
		return
			switch (Type.typeof(k)) {
				case TNull, TBool, TFloat, TUnknown: misc.exists(k);
				case TInt: ints.exists(k);
				case TClass(c):
					if (c == String) strings.exists(k);
					else objs.exists(k);
				case TObject, TFunction, TEnum(_): objs.exists(k);
			}
	}
	public function remove(k:Dynamic):Bool {
		return
			switch (Type.typeof(k)) {
				case TNull, TBool, TFloat, TUnknown: misc.remove(k);
				case TInt: ints.remove(k);
				case TClass(c):
					if (c == String) strings.remove(k);
					else objs.remove(k);
				case TObject, TFunction, TEnum(_): objs.remove(k);
			}
	}
	public function keys():Iterator<Dynamic> {
		return group([ints.keys(), strings.keys(), objs.keys(), misc.keys()]);
	}
	public function iterator():Iterator<V> {
		return group([ints.iterator(), strings.iterator(), objs.iterator(), misc.iterator()]);		
	}
	function group<A>(a:Iterable<Iterator<A>>) {//TODO: it might make sense extracting this
		var i = a.iterator();
		return 
			if (i.hasNext()) {
				var cur = i.next();
				{
					hasNext: function () return cur.hasNext() || i.hasNext(),
					next: function () {
						if (!cur.hasNext()) cur = i.next();
						return cur.next();
					}
				}
			}
			else [].iterator();//TODO: unlazify
	}
}