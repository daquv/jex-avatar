/*! 
 * jex javascript library v0.1.90 
 * Copyright 2011, 2018 Webcash. All Rights Reserved. 
 * http://jexframe.com 
 * 
 * Created: 2018-05-21 10:36:34 
 */ 

(function() {

   "use strict";


/*! 
 * IE8에서 동작 가능하도록 function 추가
 */
if (!Object.create) {
    Object.create = function (o) {
        if (arguments.length > 1) {
            throw new Error('Object.create implementation only accepts the first parameter.');
        }
        function F() {}
        F.prototype = o;
        return new F();
    };
}

if(typeof String.prototype.trim !== 'function') {
	String.prototype.trim = function() {
		return this.replace(/^\s+|\s+$/g, ''); 
	};
}
// Source: https://gist.github.com/k-gun/c2ea7c49edf7b757fe9561ba37cb19ca
// classList polyfill
;(function() {
    // helpers
    var regExp = function(name) {
        return new RegExp('(^| )'+ name +'( |$)');
    };
    var forEach = function(list, fn, scope) {
        for (var i = 0; i < list.length; i++) {
            fn.call(scope, list[i]);
        }
    };

    // class list object with basic methods
    function ClassList(element) {
        this.element = element;
    }

    ClassList.prototype = {
        add: function() {
            forEach(arguments, function(name) {
                if (!this.contains(name)) {
                    this.element.className += this.element.className.length > 0 ? ' ' + name : name;
                }
            }, this);
        },
        remove: function() {
            forEach(arguments, function(name) {
                this.element.className =
                    this.element.className.replace(regExp(name), '');
            }, this);
        },
        toggle: function(name) {
            return this.contains(name) 
                ? (this.remove(name), false) : (this.add(name), true);
        },
        contains: function(name) {
            return regExp(name).test(this.element.className);
        },
        // bonus..
        replace: function(oldName, newName) {
            this.remove(oldName), this.add(newName);
        }
    };

    // IE8/9, Safari
    if (!('classList' in Element.prototype)) {
        Object.defineProperty(Element.prototype, 'classList', {
            get: function() {
                return new ClassList(this);
            }
        });
    }

    // replace() support for others
    if (window.DOMTokenList && DOMTokenList.prototype.replace == null) {
        DOMTokenList.prototype.replace = ClassList.prototype.replace;
    }
})();

  //https://gist.github.com/Aldlevine/3f716f447322edbb3671
  //axe-core 에서사용.
  (function(){
    
    // performance.now already exists
    if(window.performance && window.performance.now)
        return;
    
    // performance exists and has the necessary methods to hack out the current DOMHighResTimestamp
    if(
        window.performance &&
        window.performance.timing && 
        window.performance.timing.navigationStart &&
        window.performance.mark &&
        window.performance.clearMarks &&
        window.performance.getEntriesByName
    ){
        window.performance.now = function(){
            window.performance.clearMarks('__PERFORMANCE_NOW__');
            window.performance.mark('__PERFORMANCE_NOW__');
            return window.performance.getEntriesByName('__PERFORMANCE_NOW__')[0].startTime;
        };
        return;
    }
    
    // All else fails, can't access a DOMHighResTimestamp, use a boring old Date...
    window.performance = window.performance || {};
    var start = (new Date()).valueOf();
    window.performance.now = function(){
        return (new Date()).valueOf() - start;
    };
           
})();

//https://github.com/davidchambers/Base64.js
;(function () {

    if (window.btoa && window.atob) {   //jexjs 수정 browser가 지원하는 경우는 사용안함.
        return;
    }
    var object =
      typeof exports != 'undefined' ? exports :
      typeof self != 'undefined' ? self : // #8: web workers
      $.global; // #31: ExtendScript
  
    var chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
  
    function InvalidCharacterError(message) {
      this.message = message;
    }
    InvalidCharacterError.prototype = new Error;
    InvalidCharacterError.prototype.name = 'InvalidCharacterError';
  
    // encoder
    // [https://gist.github.com/999166] by [https://github.com/nignag]
    object.btoa || (
    object.btoa = function (input) {
      var str = String(input);
      for (
        // initialize result and counter
        var block, charCode, idx = 0, map = chars, output = '';
        // if the next str index does not exist:
        //   change the mapping table to "="
        //   check if d has no fractional digits
        str.charAt(idx | 0) || (map = '=', idx % 1);
        // "8 - idx % 1 * 8" generates the sequence 2, 4, 6, 8
        output += map.charAt(63 & block >> 8 - idx % 1 * 8)
      ) {
        charCode = str.charCodeAt(idx += 3/4);
        if (charCode > 0xFF) {
          throw new InvalidCharacterError("'btoa' failed: The string to be encoded contains characters outside of the Latin1 range.");
        }
        block = block << 8 | charCode;
      }
      return output;
    });
  
    // decoder
    // [https://gist.github.com/1020396] by [https://github.com/atk]
    object.atob || (
    object.atob = function (input) {
      var str = String(input).replace(/[=]+$/, ''); // #31: ExtendScript bad parse of /=
      if (str.length % 4 == 1) {
        throw new InvalidCharacterError("'atob' failed: The string to be decoded is not correctly encoded.");
      }
      for (
        // initialize result and counters
        var bc = 0, bs, buffer, idx = 0, output = '';
        // get next character
        buffer = str.charAt(idx++);
        // character found in table? initialize bit storage and add its ascii value;
        ~buffer && (bs = bc % 4 ? bs * 64 + buffer : buffer,
          // and if not first of each 4 characters,
          // convert the first 8 bits to one ascii character
          bc++ % 4) ? output += String.fromCharCode(255 & bs >> (-2 * bc & 6)) : 0
      ) {
        // try to find character in table (0-63, not found => -1)
        buffer = chars.indexOf(buffer);
      }
      return output;
    });
  
  }());

// IE9 지원
//https://github.com/inexorabletash/polyfill/blob/master/typedarray.js
/*
 Copyright (c) 2010, Linden Research, Inc.
 Copyright (c) 2014, Joshua Bell

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 $/LicenseInfo$
 */

// Original can be found at:
//   https://bitbucket.org/lindenlab/llsd
// Modifications by Joshua Bell inexorabletash@gmail.com
//   https://github.com/inexorabletash/polyfill

// ES3/ES5 implementation of the Krhonos Typed Array Specification
//   Ref: http://www.khronos.org/registry/typedarray/specs/latest/
//   Date: 2011-02-01
//
// Variations:
//  * Allows typed_array.get/set() as alias for subscripts (typed_array[])
//  * Gradually migrating structure from Khronos spec to ES2015 spec
//
// Caveats:
//  * Beyond 10000 or so entries, polyfilled array accessors (ta[0],
//    etc) become memory-prohibitive, so array creation will fail. Set
//    self.TYPED_ARRAY_POLYFILL_NO_ARRAY_ACCESSORS=true to disable
//    creation of accessors. Your code will need to use the
//    non-standard get()/set() instead, and will need to add those to
//    native arrays for interop.
(function(global) {
    'use strict';
    var undefined = (void 0); // Paranoia
  
    // Beyond this value, index getters/setters (i.e. array[0], array[1]) are so slow to
    // create, and consume so much memory, that the browser appears frozen.
    var MAX_ARRAY_LENGTH = 1e5;
  
    // Approximations of internal ECMAScript conversion functions
    function Type(v) {
      switch(typeof v) {
      case 'undefined': return 'undefined';
      case 'boolean': return 'boolean';
      case 'number': return 'number';
      case 'string': return 'string';
      default: return v === null ? 'null' : 'object';
      }
    }
  
    // Class returns internal [[Class]] property, used to avoid cross-frame instanceof issues:
    function Class(v) { return Object.prototype.toString.call(v).replace(/^\[object *|\]$/g, ''); }
    function IsCallable(o) { return typeof o === 'function'; }
    function ToObject(v) {
      if (v === null || v === undefined) throw TypeError();
      return Object(v);
    }
    function ToInt32(v) { return v >> 0; }
    function ToUint32(v) { return v >>> 0; }
  
    // Snapshot intrinsics
    var LN2 = Math.LN2,
        abs = Math.abs,
        floor = Math.floor,
        log = Math.log,
        max = Math.max,
        min = Math.min,
        pow = Math.pow,
        round = Math.round;
  
    // emulate ES5 getter/setter API using legacy APIs
    // http://blogs.msdn.com/b/ie/archive/2010/09/07/transitioning-existing-code-to-the-es5-getter-setter-apis.aspx
    // (second clause tests for Object.defineProperty() in IE<9 that only supports extending DOM prototypes, but
    // note that IE<9 does not support __defineGetter__ or __defineSetter__ so it just renders the method harmless)
  
    (function() {
      var orig = Object.defineProperty;
      var dom_only = !(function(){try{return Object.defineProperty({},'x',{});}catch(_){return false;}}());
  
      if (!orig || dom_only) {
        Object.defineProperty = function (o, prop, desc) {
          // In IE8 try built-in implementation for defining properties on DOM prototypes.
          if (orig)
            try { return orig(o, prop, desc); } catch (_) {}
          if (o !== Object(o))
            throw TypeError('Object.defineProperty called on non-object');
          if (Object.prototype.__defineGetter__ && ('get' in desc))
            Object.prototype.__defineGetter__.call(o, prop, desc.get);
          if (Object.prototype.__defineSetter__ && ('set' in desc))
            Object.prototype.__defineSetter__.call(o, prop, desc.set);
          if ('value' in desc)
            o[prop] = desc.value;
          return o;
        };
      }
    }());
  
    // ES5: Make obj[index] an alias for obj._getter(index)/obj._setter(index, value)
    // for index in 0 ... obj.length
    function makeArrayAccessors(obj) {
      if ('TYPED_ARRAY_POLYFILL_NO_ARRAY_ACCESSORS' in global)
        return;
  
      if (obj.length > MAX_ARRAY_LENGTH) throw RangeError('Array too large for polyfill');
  
      function makeArrayAccessor(index) {
        Object.defineProperty(obj, index, {
          'get': function() { return obj._getter(index); },
          'set': function(v) { obj._setter(index, v); },
          enumerable: true,
          configurable: false
        });
      }
  
      var i;
      for (i = 0; i < obj.length; i += 1) {
        makeArrayAccessor(i);
      }
    }
  
    // Internal conversion functions:
    //    pack<Type>()   - take a number (interpreted as Type), output a byte array
    //    unpack<Type>() - take a byte array, output a Type-like number
  
    function as_signed(value, bits) { var s = 32 - bits; return (value << s) >> s; }
    function as_unsigned(value, bits) { var s = 32 - bits; return (value << s) >>> s; }
  
    function packI8(n) { return [n & 0xff]; }
    function unpackI8(bytes) { return as_signed(bytes[0], 8); }
  
    function packU8(n) { return [n & 0xff]; }
    function unpackU8(bytes) { return as_unsigned(bytes[0], 8); }
  
    function packU8Clamped(n) { n = round(Number(n)); return [n < 0 ? 0 : n > 0xff ? 0xff : n & 0xff]; }
  
    function packI16(n) { return [n & 0xff, (n >> 8) & 0xff]; }
    function unpackI16(bytes) { return as_signed(bytes[1] << 8 | bytes[0], 16); }
  
    function packU16(n) { return [n & 0xff, (n >> 8) & 0xff]; }
    function unpackU16(bytes) { return as_unsigned(bytes[1] << 8 | bytes[0], 16); }
  
    function packI32(n) { return [n & 0xff, (n >> 8) & 0xff, (n >> 16) & 0xff, (n >> 24) & 0xff]; }
    function unpackI32(bytes) { return as_signed(bytes[3] << 24 | bytes[2] << 16 | bytes[1] << 8 | bytes[0], 32); }
  
    function packU32(n) { return [n & 0xff, (n >> 8) & 0xff, (n >> 16) & 0xff, (n >> 24) & 0xff]; }
    function unpackU32(bytes) { return as_unsigned(bytes[3] << 24 | bytes[2] << 16 | bytes[1] << 8 | bytes[0], 32); }
  
    function packIEEE754(v, ebits, fbits) {
  
      var bias = (1 << (ebits - 1)) - 1;
  
      function roundToEven(n) {
        var w = floor(n), f = n - w;
        if (f < 0.5)
          return w;
        if (f > 0.5)
          return w + 1;
        return w % 2 ? w + 1 : w;
      }
  
      // Compute sign, exponent, fraction
      var s, e, f;
      if (v !== v) {
        // NaN
        // http://dev.w3.org/2006/webapi/WebIDL/#es-type-mapping
        e = (1 << ebits) - 1; f = pow(2, fbits - 1); s = 0;
      } else if (v === Infinity || v === -Infinity) {
        e = (1 << ebits) - 1; f = 0; s = (v < 0) ? 1 : 0;
      } else if (v === 0) {
        e = 0; f = 0; s = (1 / v === -Infinity) ? 1 : 0;
      } else {
        s = v < 0;
        v = abs(v);
  
        if (v >= pow(2, 1 - bias)) {
          // Normalized
          e = min(floor(log(v) / LN2), 1023);
          var significand = v / pow(2, e);
          if (significand < 1) {
            e -= 1;
            significand *= 2;
          }
          if (significand >= 2) {
            e += 1;
            significand /= 2;
          }
          var d = pow(2, fbits);
          f = roundToEven(significand * d) - d;
          e += bias;
          if (f / d >= 1) {
            e += 1;
            f = 0;
          }
          if (e > 2 * bias) {
            // Overflow
            e = (1 << ebits) - 1;
            f = 0;
          }
        } else {
          // Denormalized
          e = 0;
          f = roundToEven(v / pow(2, 1 - bias - fbits));
        }
      }
  
      // Pack sign, exponent, fraction
      var bits = [], i;
      for (i = fbits; i; i -= 1) { bits.push(f % 2 ? 1 : 0); f = floor(f / 2); }
      for (i = ebits; i; i -= 1) { bits.push(e % 2 ? 1 : 0); e = floor(e / 2); }
      bits.push(s ? 1 : 0);
      bits.reverse();
      var str = bits.join('');
  
      // Bits to bytes
      var bytes = [];
      while (str.length) {
        bytes.unshift(parseInt(str.substring(0, 8), 2));
        str = str.substring(8);
      }
      return bytes;
    }
  
    function unpackIEEE754(bytes, ebits, fbits) {
      // Bytes to bits
      var bits = [], i, j, b, str,
          bias, s, e, f;
  
      for (i = 0; i < bytes.length; ++i) {
        b = bytes[i];
        for (j = 8; j; j -= 1) {
          bits.push(b % 2 ? 1 : 0); b = b >> 1;
        }
      }
      bits.reverse();
      str = bits.join('');
  
      // Unpack sign, exponent, fraction
      bias = (1 << (ebits - 1)) - 1;
      s = parseInt(str.substring(0, 1), 2) ? -1 : 1;
      e = parseInt(str.substring(1, 1 + ebits), 2);
      f = parseInt(str.substring(1 + ebits), 2);
  
      // Produce number
      if (e === (1 << ebits) - 1) {
        return f !== 0 ? NaN : s * Infinity;
      } else if (e > 0) {
        // Normalized
        return s * pow(2, e - bias) * (1 + f / pow(2, fbits));
      } else if (f !== 0) {
        // Denormalized
        return s * pow(2, -(bias - 1)) * (f / pow(2, fbits));
      } else {
        return s < 0 ? -0 : 0;
      }
    }
  
    function unpackF64(b) { return unpackIEEE754(b, 11, 52); }
    function packF64(v) { return packIEEE754(v, 11, 52); }
    function unpackF32(b) { return unpackIEEE754(b, 8, 23); }
    function packF32(v) { return packIEEE754(v, 8, 23); }
  
    //
    // 3 The ArrayBuffer Type
    //
  
    (function() {
  
      function ArrayBuffer(length) {
        length = ToInt32(length);
        if (length < 0) throw RangeError('ArrayBuffer size is not a small enough positive integer.');
        Object.defineProperty(this, 'byteLength', {value: length});
        Object.defineProperty(this, '_bytes', {value: Array(length)});
  
        for (var i = 0; i < length; i += 1)
          this._bytes[i] = 0;
      }
  
      global.ArrayBuffer = global.ArrayBuffer || ArrayBuffer;
  
      //
      // 5 The Typed Array View Types
      //
  
      function $TypedArray$() {
  
        // %TypedArray% ( length )
        if (!arguments.length || typeof arguments[0] !== 'object') {
          return (function(length) {
            length = ToInt32(length);
            if (length < 0) throw RangeError('length is not a small enough positive integer.');
            Object.defineProperty(this, 'length', {value: length});
            Object.defineProperty(this, 'byteLength', {value: length * this.BYTES_PER_ELEMENT});
            Object.defineProperty(this, 'buffer', {value: new ArrayBuffer(this.byteLength)});
            Object.defineProperty(this, 'byteOffset', {value: 0});
  
           }).apply(this, arguments);
        }
  
        // %TypedArray% ( typedArray )
        if (arguments.length >= 1 &&
            Type(arguments[0]) === 'object' &&
            arguments[0] instanceof $TypedArray$) {
          return (function(typedArray){
            if (this.constructor !== typedArray.constructor) throw TypeError();
  
            var byteLength = typedArray.length * this.BYTES_PER_ELEMENT;
            Object.defineProperty(this, 'buffer', {value: new ArrayBuffer(byteLength)});
            Object.defineProperty(this, 'byteLength', {value: byteLength});
            Object.defineProperty(this, 'byteOffset', {value: 0});
            Object.defineProperty(this, 'length', {value: typedArray.length});
  
            for (var i = 0; i < this.length; i += 1)
              this._setter(i, typedArray._getter(i));
  
          }).apply(this, arguments);
        }
  
        // %TypedArray% ( array )
        if (arguments.length >= 1 &&
            Type(arguments[0]) === 'object' &&
            !(arguments[0] instanceof $TypedArray$) &&
            !(arguments[0] instanceof ArrayBuffer || Class(arguments[0]) === 'ArrayBuffer')) {
          return (function(array) {
  
            var byteLength = array.length * this.BYTES_PER_ELEMENT;
            Object.defineProperty(this, 'buffer', {value: new ArrayBuffer(byteLength)});
            Object.defineProperty(this, 'byteLength', {value: byteLength});
            Object.defineProperty(this, 'byteOffset', {value: 0});
            Object.defineProperty(this, 'length', {value: array.length});
  
            for (var i = 0; i < this.length; i += 1) {
              var s = array[i];
              this._setter(i, Number(s));
            }
          }).apply(this, arguments);
        }
  
        // %TypedArray% ( buffer, byteOffset=0, length=undefined )
        if (arguments.length >= 1 &&
            Type(arguments[0]) === 'object' &&
            (arguments[0] instanceof ArrayBuffer || Class(arguments[0]) === 'ArrayBuffer')) {
          return (function(buffer, byteOffset, length) {
  
            byteOffset = ToUint32(byteOffset);
            if (byteOffset > buffer.byteLength)
              throw RangeError('byteOffset out of range');
  
            // The given byteOffset must be a multiple of the element
            // size of the specific type, otherwise an exception is raised.
            if (byteOffset % this.BYTES_PER_ELEMENT)
              throw RangeError('buffer length minus the byteOffset is not a multiple of the element size.');
  
            if (length === undefined) {
              var byteLength = buffer.byteLength - byteOffset;
              if (byteLength % this.BYTES_PER_ELEMENT)
                throw RangeError('length of buffer minus byteOffset not a multiple of the element size');
              length = byteLength / this.BYTES_PER_ELEMENT;
  
            } else {
              length = ToUint32(length);
              byteLength = length * this.BYTES_PER_ELEMENT;
            }
  
            if ((byteOffset + byteLength) > buffer.byteLength)
              throw RangeError('byteOffset and length reference an area beyond the end of the buffer');
  
            Object.defineProperty(this, 'buffer', {value: buffer});
            Object.defineProperty(this, 'byteLength', {value: byteLength});
            Object.defineProperty(this, 'byteOffset', {value: byteOffset});
            Object.defineProperty(this, 'length', {value: length});
  
          }).apply(this, arguments);
        }
  
        // %TypedArray% ( all other argument combinations )
        throw TypeError();
      }
  
      // Properties of the %TypedArray Instrinsic Object
  
      // %TypedArray%.from ( source , mapfn=undefined, thisArg=undefined )
      Object.defineProperty($TypedArray$, 'from', {value: function(iterable) {
        return new this(iterable);
      }});
  
      // %TypedArray%.of ( ...items )
      Object.defineProperty($TypedArray$, 'of', {value: function(/*...items*/) {
        return new this(arguments);
      }});
  
      // %TypedArray%.prototype
      var $TypedArrayPrototype$ = {};
      $TypedArray$.prototype = $TypedArrayPrototype$;
  
      // WebIDL: getter type (unsigned long index);
      Object.defineProperty($TypedArray$.prototype, '_getter', {value: function(index) {
        if (arguments.length < 1) throw SyntaxError('Not enough arguments');
  
        index = ToUint32(index);
        if (index >= this.length)
          return undefined;
  
        var bytes = [], i, o;
        for (i = 0, o = this.byteOffset + index * this.BYTES_PER_ELEMENT;
             i < this.BYTES_PER_ELEMENT;
             i += 1, o += 1) {
          bytes.push(this.buffer._bytes[o]);
        }
        return this._unpack(bytes);
      }});
  
      // NONSTANDARD: convenience alias for getter: type get(unsigned long index);
      Object.defineProperty($TypedArray$.prototype, 'get', {value: $TypedArray$.prototype._getter});
  
      // WebIDL: setter void (unsigned long index, type value);
      Object.defineProperty($TypedArray$.prototype, '_setter', {value: function(index, value) {
        if (arguments.length < 2) throw SyntaxError('Not enough arguments');
  
        index = ToUint32(index);
        if (index >= this.length)
          return;
  
        var bytes = this._pack(value), i, o;
        for (i = 0, o = this.byteOffset + index * this.BYTES_PER_ELEMENT;
             i < this.BYTES_PER_ELEMENT;
             i += 1, o += 1) {
          this.buffer._bytes[o] = bytes[i];
        }
      }});
  
      // get %TypedArray%.prototype.buffer
      // get %TypedArray%.prototype.byteLength
      // get %TypedArray%.prototype.byteOffset
      // -- applied directly to the object in the constructor
  
      // %TypedArray%.prototype.constructor
      Object.defineProperty($TypedArray$.prototype, 'constructor', {value: $TypedArray$});
  
      // %TypedArray%.prototype.copyWithin (target, start, end = this.length )
      Object.defineProperty($TypedArray$.prototype, 'copyWithin', {value: function(target, start) {
        var end = arguments[2];
  
        var o = ToObject(this);
        var lenVal = o.length;
        var len = ToUint32(lenVal);
        len = max(len, 0);
        var relativeTarget = ToInt32(target);
        var to;
        if (relativeTarget < 0)
          to = max(len + relativeTarget, 0);
        else
          to = min(relativeTarget, len);
        var relativeStart = ToInt32(start);
        var from;
        if (relativeStart < 0)
          from = max(len + relativeStart, 0);
        else
          from = min(relativeStart, len);
        var relativeEnd;
        if (end === undefined)
          relativeEnd = len;
        else
          relativeEnd = ToInt32(end);
        var final;
        if (relativeEnd < 0)
          final = max(len + relativeEnd, 0);
        else
          final = min(relativeEnd, len);
        var count = min(final - from, len - to);
        var direction;
        if (from < to && to < from + count) {
          direction = -1;
          from = from + count - 1;
          to = to + count - 1;
        } else {
          direction = 1;
        }
        while (count > 0) {
          o._setter(to, o._getter(from));
          from = from + direction;
          to = to + direction;
          count = count - 1;
        }
        return o;
      }});
  
      // %TypedArray%.prototype.entries ( )
      // -- defined in es6.js to shim browsers w/ native TypedArrays
  
      // %TypedArray%.prototype.every ( callbackfn, thisArg = undefined )
      Object.defineProperty($TypedArray$.prototype, 'every', {value: function(callbackfn) {
        if (this === undefined || this === null) throw TypeError();
        var t = Object(this);
        var len = ToUint32(t.length);
        if (!IsCallable(callbackfn)) throw TypeError();
        var thisArg = arguments[1];
        for (var i = 0; i < len; i++) {
          if (!callbackfn.call(thisArg, t._getter(i), i, t))
            return false;
        }
        return true;
      }});
  
      // %TypedArray%.prototype.fill (value, start = 0, end = this.length )
      Object.defineProperty($TypedArray$.prototype, 'fill', {value: function(value) {
        var start = arguments[1],
            end = arguments[2];
  
        var o = ToObject(this);
        var lenVal = o.length;
        var len = ToUint32(lenVal);
        len = max(len, 0);
        var relativeStart = ToInt32(start);
        var k;
        if (relativeStart < 0)
          k = max((len + relativeStart), 0);
        else
          k = min(relativeStart, len);
        var relativeEnd;
        if (end === undefined)
          relativeEnd = len;
        else
          relativeEnd = ToInt32(end);
        var final;
        if (relativeEnd < 0)
          final = max((len + relativeEnd), 0);
        else
          final = min(relativeEnd, len);
        while (k < final) {
          o._setter(k, value);
          k += 1;
        }
        return o;
      }});
  
      // %TypedArray%.prototype.filter ( callbackfn, thisArg = undefined )
      Object.defineProperty($TypedArray$.prototype, 'filter', {value: function(callbackfn) {
        if (this === undefined || this === null) throw TypeError();
        var t = Object(this);
        var len = ToUint32(t.length);
        if (!IsCallable(callbackfn)) throw TypeError();
        var res = [];
        var thisp = arguments[1];
        for (var i = 0; i < len; i++) {
          var val = t._getter(i); // in case fun mutates this
          if (callbackfn.call(thisp, val, i, t))
            res.push(val);
        }
        return new this.constructor(res);
      }});
  
      // %TypedArray%.prototype.find (predicate, thisArg = undefined)
      Object.defineProperty($TypedArray$.prototype, 'find', {value: function(predicate) {
        var o = ToObject(this);
        var lenValue = o.length;
        var len = ToUint32(lenValue);
        if (!IsCallable(predicate)) throw TypeError();
        var t = arguments.length > 1 ? arguments[1] : undefined;
        var k = 0;
        while (k < len) {
          var kValue = o._getter(k);
          var testResult = predicate.call(t, kValue, k, o);
          if (Boolean(testResult))
            return kValue;
          ++k;
        }
        return undefined;
      }});
  
      // %TypedArray%.prototype.findIndex ( predicate, thisArg = undefined )
      Object.defineProperty($TypedArray$.prototype, 'findIndex', {value: function(predicate) {
        var o = ToObject(this);
        var lenValue = o.length;
        var len = ToUint32(lenValue);
        if (!IsCallable(predicate)) throw TypeError();
        var t = arguments.length > 1 ? arguments[1] : undefined;
        var k = 0;
        while (k < len) {
          var kValue = o._getter(k);
          var testResult = predicate.call(t, kValue, k, o);
          if (Boolean(testResult))
            return k;
          ++k;
        }
        return -1;
      }});
  
      // %TypedArray%.prototype.forEach ( callbackfn, thisArg = undefined )
      Object.defineProperty($TypedArray$.prototype, 'forEach', {value: function(callbackfn) {
        if (this === undefined || this === null) throw TypeError();
        var t = Object(this);
        var len = ToUint32(t.length);
        if (!IsCallable(callbackfn)) throw TypeError();
        var thisp = arguments[1];
        for (var i = 0; i < len; i++)
          callbackfn.call(thisp, t._getter(i), i, t);
      }});
  
      // %TypedArray%.prototype.indexOf (searchElement, fromIndex = 0 )
      Object.defineProperty($TypedArray$.prototype, 'indexOf', {value: function(searchElement) {
        if (this === undefined || this === null) throw TypeError();
        var t = Object(this);
        var len = ToUint32(t.length);
        if (len === 0) return -1;
        var n = 0;
        if (arguments.length > 0) {
          n = Number(arguments[1]);
          if (n !== n) {
            n = 0;
          } else if (n !== 0 && n !== (1 / 0) && n !== -(1 / 0)) {
            n = (n > 0 || -1) * floor(abs(n));
          }
        }
        if (n >= len) return -1;
        var k = n >= 0 ? n : max(len - abs(n), 0);
        for (; k < len; k++) {
          if (t._getter(k) === searchElement) {
            return k;
          }
        }
        return -1;
      }});
  
      // %TypedArray%.prototype.join ( separator )
      Object.defineProperty($TypedArray$.prototype, 'join', {value: function(separator) {
        if (this === undefined || this === null) throw TypeError();
        var t = Object(this);
        var len = ToUint32(t.length);
        var tmp = Array(len);
        for (var i = 0; i < len; ++i)
          tmp[i] = t._getter(i);
        return tmp.join(separator === undefined ? ',' : separator); // Hack for IE7
      }});
  
      // %TypedArray%.prototype.keys ( )
      // -- defined in es6.js to shim browsers w/ native TypedArrays
  
      // %TypedArray%.prototype.lastIndexOf ( searchElement, fromIndex = this.length-1 )
      Object.defineProperty($TypedArray$.prototype, 'lastIndexOf', {value: function(searchElement) {
        if (this === undefined || this === null) throw TypeError();
        var t = Object(this);
        var len = ToUint32(t.length);
        if (len === 0) return -1;
        var n = len;
        if (arguments.length > 1) {
          n = Number(arguments[1]);
          if (n !== n) {
            n = 0;
          } else if (n !== 0 && n !== (1 / 0) && n !== -(1 / 0)) {
            n = (n > 0 || -1) * floor(abs(n));
          }
        }
        var k = n >= 0 ? min(n, len - 1) : len - abs(n);
        for (; k >= 0; k--) {
          if (t._getter(k) === searchElement)
            return k;
        }
        return -1;
      }});
  
      // get %TypedArray%.prototype.length
      // -- applied directly to the object in the constructor
  
      // %TypedArray%.prototype.map ( callbackfn, thisArg = undefined )
      Object.defineProperty($TypedArray$.prototype, 'map', {value: function(callbackfn) {
        if (this === undefined || this === null) throw TypeError();
        var t = Object(this);
        var len = ToUint32(t.length);
        if (!IsCallable(callbackfn)) throw TypeError();
        var res = []; res.length = len;
        var thisp = arguments[1];
        for (var i = 0; i < len; i++)
          res[i] = callbackfn.call(thisp, t._getter(i), i, t);
        return new this.constructor(res);
      }});
  
      // %TypedArray%.prototype.reduce ( callbackfn [, initialValue] )
      Object.defineProperty($TypedArray$.prototype, 'reduce', {value: function(callbackfn) {
        if (this === undefined || this === null) throw TypeError();
        var t = Object(this);
        var len = ToUint32(t.length);
        if (!IsCallable(callbackfn)) throw TypeError();
        // no value to return if no initial value and an empty array
        if (len === 0 && arguments.length === 1) throw TypeError();
        var k = 0;
        var accumulator;
        if (arguments.length >= 2) {
          accumulator = arguments[1];
        } else {
          accumulator = t._getter(k++);
        }
        while (k < len) {
          accumulator = callbackfn.call(undefined, accumulator, t._getter(k), k, t);
          k++;
        }
        return accumulator;
      }});
  
      // %TypedArray%.prototype.reduceRight ( callbackfn [, initialValue] )
      Object.defineProperty($TypedArray$.prototype, 'reduceRight', {value: function(callbackfn) {
        if (this === undefined || this === null) throw TypeError();
        var t = Object(this);
        var len = ToUint32(t.length);
        if (!IsCallable(callbackfn)) throw TypeError();
        // no value to return if no initial value, empty array
        if (len === 0 && arguments.length === 1) throw TypeError();
        var k = len - 1;
        var accumulator;
        if (arguments.length >= 2) {
          accumulator = arguments[1];
        } else {
          accumulator = t._getter(k--);
        }
        while (k >= 0) {
          accumulator = callbackfn.call(undefined, accumulator, t._getter(k), k, t);
          k--;
        }
        return accumulator;
      }});
  
      // %TypedArray%.prototype.reverse ( )
      Object.defineProperty($TypedArray$.prototype, 'reverse', {value: function() {
        if (this === undefined || this === null) throw TypeError();
        var t = Object(this);
        var len = ToUint32(t.length);
        var half = floor(len / 2);
        for (var i = 0, j = len - 1; i < half; ++i, --j) {
          var tmp = t._getter(i);
          t._setter(i, t._getter(j));
          t._setter(j, tmp);
        }
        return t;
      }});
  
      // %TypedArray%.prototype.set(array, offset = 0 )
      // %TypedArray%.prototype.set(typedArray, offset = 0 )
      // WebIDL: void set(TypedArray array, optional unsigned long offset);
      // WebIDL: void set(sequence<type> array, optional unsigned long offset);
      Object.defineProperty($TypedArray$.prototype, 'set', {value: function(index, value) {
        if (arguments.length < 1) throw SyntaxError('Not enough arguments');
        var array, sequence, offset, len,
            i, s, d,
            byteOffset, byteLength, tmp;
  
        if (typeof arguments[0] === 'object' && arguments[0].constructor === this.constructor) {
          // void set(TypedArray array, optional unsigned long offset);
          array = arguments[0];
          offset = ToUint32(arguments[1]);
  
          if (offset + array.length > this.length) {
            throw RangeError('Offset plus length of array is out of range');
          }
  
          byteOffset = this.byteOffset + offset * this.BYTES_PER_ELEMENT;
          byteLength = array.length * this.BYTES_PER_ELEMENT;
  
          if (array.buffer === this.buffer) {
            tmp = [];
            for (i = 0, s = array.byteOffset; i < byteLength; i += 1, s += 1) {
              tmp[i] = array.buffer._bytes[s];
            }
            for (i = 0, d = byteOffset; i < byteLength; i += 1, d += 1) {
              this.buffer._bytes[d] = tmp[i];
            }
          } else {
            for (i = 0, s = array.byteOffset, d = byteOffset;
                 i < byteLength; i += 1, s += 1, d += 1) {
              this.buffer._bytes[d] = array.buffer._bytes[s];
            }
          }
        } else if (typeof arguments[0] === 'object' && typeof arguments[0].length !== 'undefined') {
          // void set(sequence<type> array, optional unsigned long offset);
          sequence = arguments[0];
          len = ToUint32(sequence.length);
          offset = ToUint32(arguments[1]);
  
          if (offset + len > this.length) {
            throw RangeError('Offset plus length of array is out of range');
          }
  
          for (i = 0; i < len; i += 1) {
            s = sequence[i];
            this._setter(offset + i, Number(s));
          }
        } else {
          throw TypeError('Unexpected argument type(s)');
        }
      }});
  
      // %TypedArray%.prototype.slice ( start, end )
      Object.defineProperty($TypedArray$.prototype, 'slice', {value: function(start, end) {
        var o = ToObject(this);
        var lenVal = o.length;
        var len = ToUint32(lenVal);
        var relativeStart = ToInt32(start);
        var k = (relativeStart < 0) ? max(len + relativeStart, 0) : min(relativeStart, len);
        var relativeEnd = (end === undefined) ? len : ToInt32(end);
        var final = (relativeEnd < 0) ? max(len + relativeEnd, 0) : min(relativeEnd, len);
        var count = final - k;
        var c = o.constructor;
        var a = new c(count);
        var n = 0;
        while (k < final) {
          var kValue = o._getter(k);
          a._setter(n, kValue);
          ++k;
          ++n;
        }
        return a;
      }});
  
      // %TypedArray%.prototype.some ( callbackfn, thisArg = undefined )
      Object.defineProperty($TypedArray$.prototype, 'some', {value: function(callbackfn) {
        if (this === undefined || this === null) throw TypeError();
        var t = Object(this);
        var len = ToUint32(t.length);
        if (!IsCallable(callbackfn)) throw TypeError();
        var thisp = arguments[1];
        for (var i = 0; i < len; i++) {
          if (callbackfn.call(thisp, t._getter(i), i, t)) {
            return true;
          }
        }
        return false;
      }});
  
      // %TypedArray%.prototype.sort ( comparefn )
      Object.defineProperty($TypedArray$.prototype, 'sort', {value: function(comparefn) {
        if (this === undefined || this === null) throw TypeError();
        var t = Object(this);
        var len = ToUint32(t.length);
        var tmp = Array(len);
        for (var i = 0; i < len; ++i)
          tmp[i] = t._getter(i);
        function sortCompare(x, y) {
          if (x !== x && y !== y) return +0;
          if (x !== x) return 1;
          if (y !== y) return -1;
          if (comparefn !== undefined) {
            return comparefn(x, y);
          }
          if (x < y) return -1;
          if (x > y) return 1;
          return +0;
        }
        tmp.sort(sortCompare);
        for (i = 0; i < len; ++i)
          t._setter(i, tmp[i]);
        return t;
      }});
  
      // %TypedArray%.prototype.subarray(begin = 0, end = this.length )
      // WebIDL: TypedArray subarray(long begin, optional long end);
      Object.defineProperty($TypedArray$.prototype, 'subarray', {value: function(start, end) {
        function clamp(v, min, max) { return v < min ? min : v > max ? max : v; }
  
        start = ToInt32(start);
        end = ToInt32(end);
  
        if (arguments.length < 1) { start = 0; }
        if (arguments.length < 2) { end = this.length; }
  
        if (start < 0) { start = this.length + start; }
        if (end < 0) { end = this.length + end; }
  
        start = clamp(start, 0, this.length);
        end = clamp(end, 0, this.length);
  
        var len = end - start;
        if (len < 0) {
          len = 0;
        }
  
        return new this.constructor(
          this.buffer, this.byteOffset + start * this.BYTES_PER_ELEMENT, len);
      }});
  
      // %TypedArray%.prototype.toLocaleString ( )
      // %TypedArray%.prototype.toString ( )
      // %TypedArray%.prototype.values ( )
      // %TypedArray%.prototype [ @@iterator ] ( )
      // get %TypedArray%.prototype [ @@toStringTag ]
      // -- defined in es6.js to shim browsers w/ native TypedArrays
  
      function makeTypedArray(elementSize, pack, unpack) {
        // Each TypedArray type requires a distinct constructor instance with
        // identical logic, which this produces.
        var TypedArray = function() {
          Object.defineProperty(this, 'constructor', {value: TypedArray});
          $TypedArray$.apply(this, arguments);
          makeArrayAccessors(this);
        };
        if ('__proto__' in TypedArray) {
          TypedArray.__proto__ = $TypedArray$;
        } else {
          TypedArray.from = $TypedArray$.from;
          TypedArray.of = $TypedArray$.of;
        }
  
        TypedArray.BYTES_PER_ELEMENT = elementSize;
  
        var TypedArrayPrototype = function() {};
        TypedArrayPrototype.prototype = $TypedArrayPrototype$;
  
        TypedArray.prototype = new TypedArrayPrototype();
  
        Object.defineProperty(TypedArray.prototype, 'BYTES_PER_ELEMENT', {value: elementSize});
        Object.defineProperty(TypedArray.prototype, '_pack', {value: pack});
        Object.defineProperty(TypedArray.prototype, '_unpack', {value: unpack});
  
        return TypedArray;
      }
  
      var Int8Array = makeTypedArray(1, packI8, unpackI8);
      var Uint8Array = makeTypedArray(1, packU8, unpackU8);
      var Uint8ClampedArray = makeTypedArray(1, packU8Clamped, unpackU8);
      var Int16Array = makeTypedArray(2, packI16, unpackI16);
      var Uint16Array = makeTypedArray(2, packU16, unpackU16);
      var Int32Array = makeTypedArray(4, packI32, unpackI32);
      var Uint32Array = makeTypedArray(4, packU32, unpackU32);
      var Float32Array = makeTypedArray(4, packF32, unpackF32);
      var Float64Array = makeTypedArray(8, packF64, unpackF64);
  
      global.Int8Array = global.Int8Array || Int8Array;
      global.Uint8Array = global.Uint8Array || Uint8Array;
      global.Uint8ClampedArray = global.Uint8ClampedArray || Uint8ClampedArray;
      global.Int16Array = global.Int16Array || Int16Array;
      global.Uint16Array = global.Uint16Array || Uint16Array;
      global.Int32Array = global.Int32Array || Int32Array;
      global.Uint32Array = global.Uint32Array || Uint32Array;
      global.Float32Array = global.Float32Array || Float32Array;
      global.Float64Array = global.Float64Array || Float64Array;
    }());
  
    //
    // 6 The DataView View Type
    //
  
    (function() {
      function r(array, index) {
        return IsCallable(array.get) ? array.get(index) : array[index];
      }
  
      var IS_BIG_ENDIAN = (function() {
        var u16array = new Uint16Array([0x1234]),
            u8array = new Uint8Array(u16array.buffer);
        return r(u8array, 0) === 0x12;
      }());
  
      // DataView(buffer, byteOffset=0, byteLength=undefined)
      // WebIDL: Constructor(ArrayBuffer buffer,
      //                     optional unsigned long byteOffset,
      //                     optional unsigned long byteLength)
      function DataView(buffer, byteOffset, byteLength) {
        if (!(buffer instanceof ArrayBuffer || Class(buffer) === 'ArrayBuffer')) throw TypeError();
  
        byteOffset = ToUint32(byteOffset);
        if (byteOffset > buffer.byteLength)
          throw RangeError('byteOffset out of range');
  
        if (byteLength === undefined)
          byteLength = buffer.byteLength - byteOffset;
        else
          byteLength = ToUint32(byteLength);
  
        if ((byteOffset + byteLength) > buffer.byteLength)
          throw RangeError('byteOffset and length reference an area beyond the end of the buffer');
  
        Object.defineProperty(this, 'buffer', {value: buffer});
        Object.defineProperty(this, 'byteLength', {value: byteLength});
        Object.defineProperty(this, 'byteOffset', {value: byteOffset});
      };
  
      // get DataView.prototype.buffer
      // get DataView.prototype.byteLength
      // get DataView.prototype.byteOffset
      // -- applied directly to instances by the constructor
  
      function makeGetter(arrayType) {
        return function GetViewValue(byteOffset, littleEndian) {
          byteOffset = ToUint32(byteOffset);
  
          if (byteOffset + arrayType.BYTES_PER_ELEMENT > this.byteLength)
            throw RangeError('Array index out of range');
  
          byteOffset += this.byteOffset;
  
          var uint8Array = new Uint8Array(this.buffer, byteOffset, arrayType.BYTES_PER_ELEMENT),
              bytes = [];
          for (var i = 0; i < arrayType.BYTES_PER_ELEMENT; i += 1)
            bytes.push(r(uint8Array, i));
  
          if (Boolean(littleEndian) === Boolean(IS_BIG_ENDIAN))
            bytes.reverse();
  
          return r(new arrayType(new Uint8Array(bytes).buffer), 0);
        };
      }
  
      Object.defineProperty(DataView.prototype, 'getUint8', {value: makeGetter(Uint8Array)});
      Object.defineProperty(DataView.prototype, 'getInt8', {value: makeGetter(Int8Array)});
      Object.defineProperty(DataView.prototype, 'getUint16', {value: makeGetter(Uint16Array)});
      Object.defineProperty(DataView.prototype, 'getInt16', {value: makeGetter(Int16Array)});
      Object.defineProperty(DataView.prototype, 'getUint32', {value: makeGetter(Uint32Array)});
      Object.defineProperty(DataView.prototype, 'getInt32', {value: makeGetter(Int32Array)});
      Object.defineProperty(DataView.prototype, 'getFloat32', {value: makeGetter(Float32Array)});
      Object.defineProperty(DataView.prototype, 'getFloat64', {value: makeGetter(Float64Array)});
  
      function makeSetter(arrayType) {
        return function SetViewValue(byteOffset, value, littleEndian) {
          byteOffset = ToUint32(byteOffset);
          if (byteOffset + arrayType.BYTES_PER_ELEMENT > this.byteLength)
            throw RangeError('Array index out of range');
  
          // Get bytes
          var typeArray = new arrayType([value]),
              byteArray = new Uint8Array(typeArray.buffer),
              bytes = [], i, byteView;
  
          for (i = 0; i < arrayType.BYTES_PER_ELEMENT; i += 1)
            bytes.push(r(byteArray, i));
  
          // Flip if necessary
          if (Boolean(littleEndian) === Boolean(IS_BIG_ENDIAN))
            bytes.reverse();
  
          // Write them
          byteView = new Uint8Array(this.buffer, byteOffset, arrayType.BYTES_PER_ELEMENT);
          byteView.set(bytes);
        };
      }
  
      Object.defineProperty(DataView.prototype, 'setUint8', {value: makeSetter(Uint8Array)});
      Object.defineProperty(DataView.prototype, 'setInt8', {value: makeSetter(Int8Array)});
      Object.defineProperty(DataView.prototype, 'setUint16', {value: makeSetter(Uint16Array)});
      Object.defineProperty(DataView.prototype, 'setInt16', {value: makeSetter(Int16Array)});
      Object.defineProperty(DataView.prototype, 'setUint32', {value: makeSetter(Uint32Array)});
      Object.defineProperty(DataView.prototype, 'setInt32', {value: makeSetter(Int32Array)});
      Object.defineProperty(DataView.prototype, 'setFloat32', {value: makeSetter(Float32Array)});
      Object.defineProperty(DataView.prototype, 'setFloat64', {value: makeSetter(Float64Array)});
  
      global.DataView = global.DataView || DataView;
  
    }());
  
  }(self));
  /* Blob.js
 * A Blob implementation.
 * 2018-01-12
 *
 * By Eli Grey, http://eligrey.com
 * By Devin Samarin, https://github.com/dsamarin
 * License: MIT
 *   See https://github.com/eligrey/Blob.js/blob/master/LICENSE.md
 */

/*global self, unescape */
/*jslint bitwise: true, regexp: true, confusion: true, es5: true, vars: true, white: true,
  plusplus: true */

/*! @source http://purl.eligrey.com/github/Blob.js/blob/master/Blob.js */

(function (view) {
	"use strict";

	view.URL = view.URL || view.webkitURL;

	if (view.Blob && view.URL) {
		try {
			new Blob;
			return;
		} catch (e) {}
	}

	// Internally we use a BlobBuilder implementation to base Blob off of
	// in order to support older browsers that only have BlobBuilder
	var BlobBuilder = view.BlobBuilder || view.WebKitBlobBuilder || view.MozBlobBuilder || (function(view) {
		var
			  get_class = function(object) {
				return Object.prototype.toString.call(object).match(/^\[object\s(.*)\]$/)[1];
			}
			, FakeBlobBuilder = function BlobBuilder() {
				this.data = [];
			}
			, FakeBlob = function Blob(data, type, encoding) {
				this.data = data;
				this.size = data.length;
				this.type = type;
				this.encoding = encoding;
			}
			, FBB_proto = FakeBlobBuilder.prototype
			, FB_proto = FakeBlob.prototype
			, FileReaderSync = view.FileReaderSync
			, FileException = function(type) {
				this.code = this[this.name = type];
			}
			, file_ex_codes = (
				  "NOT_FOUND_ERR SECURITY_ERR ABORT_ERR NOT_READABLE_ERR ENCODING_ERR "
				+ "NO_MODIFICATION_ALLOWED_ERR INVALID_STATE_ERR SYNTAX_ERR"
			).split(" ")
			, file_ex_code = file_ex_codes.length
			, real_URL = view.URL || view.webkitURL || view
			, real_create_object_URL = real_URL.createObjectURL
			, real_revoke_object_URL = real_URL.revokeObjectURL
			, URL = real_URL
			, btoa = view.btoa
			, atob = view.atob

			, ArrayBuffer = view.ArrayBuffer
			, Uint8Array = view.Uint8Array

			, origin = /^[\w-]+:\/*\[?[\w\.:-]+\]?(?::[0-9]+)?/
		;
		FakeBlob.fake = FB_proto.fake = true;
		while (file_ex_code--) {
			FileException.prototype[file_ex_codes[file_ex_code]] = file_ex_code + 1;
		}
		// Polyfill URL
		if (!real_URL.createObjectURL) {
			URL = view.URL = function(uri) {
				var
					  uri_info = document.createElementNS("http://www.w3.org/1999/xhtml", "a")
					, uri_origin
				;
				uri_info.href = uri;
				if (!("origin" in uri_info)) {
					if (uri_info.protocol.toLowerCase() === "data:") {
						uri_info.origin = null;
					} else {
						uri_origin = uri.match(origin);
						uri_info.origin = uri_origin && uri_origin[1];
					}
				}
				return uri_info;
			};
		}
		URL.createObjectURL = function(blob) {
			var
				  type = blob.type
				, data_URI_header
			;
			if (type === null) {
				type = "application/octet-stream";
			}
			if (blob instanceof FakeBlob) {
				data_URI_header = "data:" + type;
				if (blob.encoding === "base64") {
					return data_URI_header + ";base64," + blob.data;
				} else if (blob.encoding === "URI") {
					return data_URI_header + "," + decodeURIComponent(blob.data);
				} if (btoa) {
					return data_URI_header + ";base64," + btoa(blob.data);
				} else {
					return data_URI_header + "," + encodeURIComponent(blob.data);
				}
			} else if (real_create_object_URL) {
				return real_create_object_URL.call(real_URL, blob);
			}
		};
		URL.revokeObjectURL = function(object_URL) {
			if (object_URL.substring(0, 5) !== "data:" && real_revoke_object_URL) {
				real_revoke_object_URL.call(real_URL, object_URL);
			}
		};
		FBB_proto.append = function(data/*, endings*/) {
			var bb = this.data;
			// decode data to a binary string
			if (Uint8Array && (data instanceof ArrayBuffer || data instanceof Uint8Array)) {
				var
					  str = ""
					, buf = new Uint8Array(data)
					, i = 0
					, buf_len = buf.length
				;
				for (; i < buf_len; i++) {
					str += String.fromCharCode(buf[i]);
				}
				bb.push(str);
			} else if (get_class(data) === "Blob" || get_class(data) === "File") {
				if (FileReaderSync) {
					var fr = new FileReaderSync;
					bb.push(fr.readAsBinaryString(data));
				} else {
					// async FileReader won't work as BlobBuilder is sync
					throw new FileException("NOT_READABLE_ERR");
				}
			} else if (data instanceof FakeBlob) {
				if (data.encoding === "base64" && atob) {
					bb.push(atob(data.data));
				} else if (data.encoding === "URI") {
					bb.push(decodeURIComponent(data.data));
				} else if (data.encoding === "raw") {
					bb.push(data.data);
				}
			} else {
				if (typeof data !== "string") {
					data += ""; // convert unsupported types to strings
				}
				// decode UTF-16 to binary string
				bb.push(unescape(encodeURIComponent(data)));
			}
		};
		FBB_proto.getBlob = function(type) {
			if (!arguments.length) {
				type = null;
			}
			return new FakeBlob(this.data.join(""), type, "raw");
		};
		FBB_proto.toString = function() {
			return "[object BlobBuilder]";
		};
		FB_proto.slice = function(start, end, type) {
			var args = arguments.length;
			if (args < 3) {
				type = null;
			}
			return new FakeBlob(
				  this.data.slice(start, args > 1 ? end : this.data.length)
				, type
				, this.encoding
			);
		};
		FB_proto.toString = function() {
			return "[object Blob]";
		};
		FB_proto.close = function() {
			this.size = 0;
			delete this.data;
		};
		return FakeBlobBuilder;
	}(view));

	view.Blob = function(blobParts, options) {
		var type = options ? (options.type || "") : "";
		var builder = new BlobBuilder();
		if (blobParts) {
			for (var i = 0, len = blobParts.length; i < len; i++) {
				if (Uint8Array && blobParts[i] instanceof Uint8Array) {
					builder.append(blobParts[i].buffer);
				}
				else {
					builder.append(blobParts[i]);
				}
			}
		}
		var blob = builder.getBlob(type);
		if (!blob.slice && blob.webkitSlice) {
			blob.slice = blob.webkitSlice;
		}
		return blob;
	};

	var getPrototypeOf = Object.getPrototypeOf || function(object) {
		return object.__proto__;
	};
	view.Blob.prototype = getPrototypeOf(new view.Blob());
}(
	   typeof self !== "undefined" && self
	|| typeof window !== "undefined" && window
	|| this
));

/**
 * ## jexjs javascript library <br />
 *
 * @class jexjs
 */
var jexjs = {
    version : "0.1.90",
    name : 'jexjs'
};

// 전역 객체로 선언
window.jexjs = jexjs;
window.jj = window.jexjs;

/**
 * 전역 설정을 저장하기 위한 변수
 *
 * @property jexjs.global
 * @type {Object}
 */
jexjs.global = {};

/**
 * 플러그인 설정을 저장하기 위한 변수
 * @property jexjs.global.plugins
 * @type {Object}
 */
jexjs.global.plugins = {};

 /************************************************************************************
 * String 객체를 확장한다.
 * @class String
 ************************************************************************************/
/**
 * Usage : "".startsWith("st") <br />
 * 문자열이 "st"로 시작할 경우 true, 그렇지 않을 경우 false를 리턴한다.
 *
 * @method startsWith
 * @param {String} str
 * @return {Boolean} {str}로 시작할 경우 true, 그렇지 않을 경우 false
 */
if (typeof String.prototype.startsWith !== 'function') {
    String.prototype.startsWith = function(str) {
        return new RegExp("^" + str).test(this);
    };
}

/**
 * Usage : "".endsWith("st") <br />
 * 문자열이 "st"로 끝나는 경우 경우 true, 그렇지 않을 경우 false를 리턴한다.
 *
 * @method endsWith
 * @param {String} str
 * @return {Boolean} {str}로 끝나는 경우 true, 그렇지 않을 경우 false
 */
if (typeof String.prototype.endsWith !== 'function') {
    String.prototype.endsWith = function(str) {
        return new RegExp(str + "$").test(this);
    };
}

jexjs.isString = function( stringData ) {
    if ( "string" == typeof stringData ) {
        return true;
    }
    return false;
};

/**
 * @method trim
 * @param {String} data 좌우 공백을 제거하기 위한 문자열
 * @return {String}
 */
jexjs.trim = function(data) {
    if (data && typeof data.trim === 'function') {
        return data.trim();
    }

    return data;
};

/************************************************************************************
 * Date 객체를 확장한다.
 * @class Date
 ************************************************************************************/

/**
 * 날짜 및 시간을 특정 형태로 변환해준다. <br />
 * <table>
 *     <tr><td colspan="3" style="text-align:center;">ex) 2009년 7월 4일 15시 3분 55초</td></tr>
 *     <tr style="text-align:center;">
 *         <td>패턴</td>
 *         <td>설명</td>
 *         <td>결과</td>
 *     </tr>
 *     <tr><td>YYYY(yyyy)</td><td>년</td><td>2009</td></tr>
 *     <tr><td>YY(yy)</td><td>년</td><td>09</td></tr>
 *     <tr><td>Y(y)</td><td>년</td><td>9</td></tr>
 *     <tr><td>MM</td><td>월</td><td>07</td></tr>
 *     <tr><td>M</td><td>월</td><td>7</td></tr>
 *     <tr><td>dd</td><td>일</td><td>04</td></tr>
 *     <tr><td>d</td><td>일</td><td>4</td></tr>
 *     <tr><td>HH</td><td>시간 (00~23)</td><td>08</td></tr>
 *     <tr><td>H</td><td>시간 (0~23)</td><td>8</td></tr>
 *     <tr><td>hh</td><td>시간 (00 01 02 ... 11, 12 01 02 ... 11)</td><td>15</td></tr>
 *     <tr><td>h</td><td>시간 (0 1 2 ... 11, 12 1 2 ... 11)</td><td>3</td></tr>
 *     <tr><td>mm</td><td>분</td><td>03</td></tr>
 *     <tr><td>m</td><td>분</td><td>3</td></tr>
 *     <tr><td>ss</td><td>초</td><td>55</td></tr>
 *     <tr><td>s</td><td>초</td><td>55</td></tr>
 *     <tr><td>A</td><td>AM; PM</td><td>PM</td></tr>
 *     <tr><td>a</td><td>am; pm</td><td>pm</td></tr>
 *     <tr><td>AA(aa)</td><td>오전; 오후</td><td>오후</td></tr>
 * </table>
 *
 * @method format
 * @param {String} pattern
 * @returns {String}
 * @example
 *      var date = new Date(2014, 9-1, 5, 14, 2, 44);
 *      date.format("yyyy-MM-dd hh:mm:ss"); // --> 2014-09-05 02:02:44
 *      date.format("yyyy년"); // --> 2014년
 *      date.format("dd/MM/yy"); // --> 05/09/14
 *      date.format("aa h시"); // --> 오후 2시
 */
Date.prototype.format = function(pattern) {
    if (typeof pattern !== 'string') {        return pattern;     }

    var year = null,
        month = null,
        day = null,
        hour = null,
        minute = null,
        second = null,
        am_pm = null
        ;

    // year
    if (/yyyy/.test(pattern) || /YYYY/.test(pattern)) {
        year = this.getFullYear();

        pattern = pattern.replace(/yyyy/g, year);
        pattern = pattern.replace(/YYYY/g, year);
    }

    // year
    if (/yy/.test(pattern) || /YY/.test(pattern)) {
        year = (this.getFullYear() + "").substring(2);

        pattern = pattern.replace(/yy/g, year);
        pattern = pattern.replace(/YY/g, year);
    }

    // year
    if (/y/.test(pattern) || /Y/.test(pattern)) {
        year = parseInt((this.getFullYear() + "").substring(2), 10);
        pattern = pattern.replace(/y/g, year);
        pattern = pattern.replace(/Y/g, year);
    }

    // month
    if (/MM/.test(pattern)) {
        month = this.getMonth() + 1;

        if (month < 10) {
            month = "0" + month;
        }

        pattern = pattern.replace(/MM/g, month);
    }

    // month
    if (/M/.test(pattern)) {
        month = this.getMonth() + 1;
        pattern = pattern.replace(/M/g, month);
    }

    // day
    if (/dd/.test(pattern)) {
        day = this.getDate();

        if (day < 10) {
            day = "0" + day;
        }

        pattern = pattern.replace(/dd/g, day);
    }

    // day
    if (/d/.test(pattern)) {
        day = this.getDate();
        pattern = pattern.replace(/d/g, day);
    }

    // hour : 0 ~ 23
    if (/HH/.test(pattern)) {
        hour = this.getHours();

        if (hour < 10) {
            hour = "0" + hour;
        }

        pattern = pattern.replace(/HH/g, hour);
    }

    // hour : 0 ~ 23
    if (/H/.test(pattern)) {
        hour = this.getHours();
        pattern = pattern.replace(/H/g, hour);
    }

    // hour (am)00 01 02 ... 11, (pm)12 01 02 03 ... 11
    if (/hh/.test(pattern)) {
        hour = this.getHours();
        if (hour > 12) {
            hour = hour - 12;
        }

        if (hour < 10) {
            hour = "0" + hour;
        }

        pattern = pattern.replace(/hh/g, hour);
    }

    // hour (am)0 1 2 ... 11, (pm)12 1 2 3 ... 11
    if (/h/.test(pattern)) {
        hour = this.getHours();
        if (hour > 12) {
            hour = hour - 12;
        }
        pattern = pattern.replace(/h/g, hour);
    }

    // minute
    if (/mm/.test(pattern)) {
        minute = this.getMinutes();
        if (minute < 10) {
            minute = "0" + minute;
        }

        pattern = pattern.replace(/mm/g, minute);
    }

    // minute
    if (/m/.test(pattern)) {
        minute = this.getMinutes();
        pattern = pattern.replace(/m/g, minute);
    }

    // second
    if (/ss/.test(pattern)) {
        second = this.getSeconds();
        if (second < 10) {
            second = "0" + second;
        }

        pattern = pattern.replace(/ss/g, second);
    }

    if (/s/.test(pattern)) {
        second = this.getSeconds();
        pattern = pattern.replace(/s/g, second);
    }

    // 오전, 오후
    if (/aa/.test(pattern) || /AA/.test(pattern)) {
        am_pm = (this.getHours() < 12)? "오전": "오후";
        pattern = pattern.replace(/aa/g, am_pm);
        pattern = pattern.replace(/AA/g, am_pm);
    }

    // am, pm
    if (/A/.test(pattern)) {
        am_pm = (this.getHours() < 12)? "AM": "PM";
        pattern = pattern.replace(/A/g, am_pm);
    }

    // am, pm
    if (/a/.test(pattern)) {
        am_pm = (this.getHours() < 12)? "am": "pm";
        pattern = pattern.replace(/a/g, am_pm);
    }


    return pattern;
};

/**
 *
 * @method format
 * @param {String} pattern
 * @param {Date} date 없을 경우 현재 시간을 기준으로 생성
 * @returns {String}
 * @static
 * @example
 *      var now = Date.format("yyyyMMdd"); // --> 20140925
 *      var now = Date.format("yyyyMMdd", new Date(2014, 9, 25)); // --> 20140925
 */
Date.format = function(pattern, date) {
    if (date instanceof Date) {
        return date.format(pattern);
    } else {
        return new Date().format(pattern);
    }
};

var JexDateUtil = {
	DAYS_OF_MONTH : [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
};

/**
 * 해당월의 시작요일을 반환한다.
 * 0 : 일요일 ~ 6 : 토요일
 * @param year
 * @param month
 * @return day
 */
JexDateUtil.getFirstDayOfMonth = function (year, month) {
	return new Date(year, month-1,1).getDay();
};

/**
 * 해당월의 마지막 일을 반환한다.
 * 
 * @param year
 * @param month
 * @return last day ex) 28,29,30,31
 * 
 */
JexDateUtil.getLastDayOfMonth = function (year, month) {
	var day = null;
	if ( 2 === month && ( 0 === year%4 && (0 !== year%100 || 0 === year%400) ) ) {
		return 29;
	} else {
		return JexDateUtil.DAYS_OF_MONTH(month-1);
	}
};
 
/************************************************************************************
 * Array 관련 함수
 ************************************************************************************/
if (typeof Array.prototype.jexPushByIndex !== 'function') {
    Array.prototype.jexPushByIndex = function( _data, _idx ) {
        var idx = _idx | this.length;
        
        if( undefined === _idx || null === _idx ){
            this.push( _data );
        }else{
            if ( _idx > this.length ){
                this.push( _data );
            }else{
                this.splice( _idx, 0, _data);
            }
        }
        return this.length;
    };
}

/**
 * 해당 객체가 Array 타입인지에 대한 검사를 수행한다.
 *
 * @method isArray
 * @param {Object} obj Array 타입의 객체인지 확인하고 싶은 객체
 * @return {Boolean}
 */
jexjs.isArray = function(obj) {
    if (typeof Array.isArray === 'function') {
        return Array.isArray(obj);
    }

    if (this.type(obj) === 'Array') {
        return true;
    }

    return false;
};

/**
 * Array 루프를 돌려준다. callback 함수 내에서 this로 value scope를 넘겨준다.
 *
 * @method forEach
 * @param {Array} arr 반복문을 돌릴 배열
 * @param {Function } fn 사용자 정의 함수
 * <br />
 *
 * <h4>callback 파라미터</h4>
 * <table>
 *     <tr>
 *         <td>index</td><td>Number</td><td>배열 인덱스</td>
 *     </tr>
 *     <tr>
 *         <td>value</td><td>{ Object }</td><td>배열 값</td>
 *     </tr>
 * </table>
 *
 * @example
 *      jexjs.forEach( [ 1, 2, 3 ], function( index, value ) { ... } );
 */
jexjs.forEach = function ( arr, fn ) {
    if ( jexjs.isArray(arr) ) {
        for (var i = 0; i < arr.length; i++) {
            var value = arr[i];

            var result = fn.apply(value, [i, value]);

            if (typeof result === 'boolean' && !result) {
                break;
            }
        }
    } else {
        jexjs.warn('jexjs.forEach : Array 타입만 사용할 수 있습니다. arr : ' + typeof arr);
    }
};

/**
 * 해당 객체가 Array 타입인지에 대한 검사를 수행한다.
 *
 * @method isArray
 * @param {Object} obj Array 타입의 객체인지 확인하고 싶은 객체
 * @return {Boolean}
 */
jexjs.isArray = function(obj) {
    if (typeof Array.isArray === 'function') {
        return Array.isArray(obj);
    }

    if (this.type(obj) === 'Array') {
        return true;
    }

    return false;
};

/************************************************************************************
 * JexUtil
 ************************************************************************************/
jexjs._isProjectScope = function(){
    if ( window.jexFrame ) {
        return false;
    }
    return true;
};

jexjs._isJQueryObject = function( jqueryObj ) {
    return jqueryObj instanceof jQuery;
};

/** 
 * Dom Element를 반환합니다.
 * String, HTMLElement 객체를 모두 HTML Element로 변환해줍니다.
 */
jexjs._getHtmlElement = function( unknownElement, scope ) {
    if( jexjs.isNull(scope) ) {
        scope = window;
    }
    if ( jexjs.isString( unknownElement ) ) {
        return scope.document.getElementById( unknownElement );
    } else {
        return unknownElement;
    }
};

/**
 * @param elem elementId or element 객체
 * @return elementId;
 */
jexjs._getElementId = function( elem ) {
    if( jexjs.isHtmlElement( elem ) ){
        return elem.getAttribute("id");
    } else {
        return elem;
    }
};

/* jexjs 하위 함수 호출 */
jexjs._callAllIframeFunction = function( fnName ){
    if ( jexjs.hasIframe() ) {
        var maxFrameLength = window.frames.length;
        var frm = null;
        for(var i=0; i < maxFrameLength; i++ ) {
            frm = window.frames[i];
            if( frm.jexjs && frm.jexjs._isProjectScope() ) {
                jexjs.debug("    jexjs : "+ fnName +" childFrmae["+i+"] call" );
                frm.jexjs[fnName].apply(null, Array.prototype.slice.call(arguments, 1) );
            }
        }
    }
};

jexjs.isHtmlElement = function( element ) {
    //ie8 이상인경우
    if ( "undefined" !== typeof HTMLElement) {    
        return element instanceof HTMLElement;
    } else if ( element.nodeType && element.nodeType === 1) {
        return true;
    } else {
        return false;
    }
};

jexjs.isCanvasElement = function ( canvasElem ) {
    return canvasElem instanceof HTMLCanvasElement;
};

jexjs.hasIframe = function(){
    if ( 0 < window.frames.length ) {
        return true;
    }
    return false;
};

jexjs.isFunction = function( func ){
    if ( "function" == typeof func ){
        return true;
    }
    return false;
};

/**
 * target 객체를 확장한다.
 *
 * 
 * @method extend
 * @param {Object} target 확장하고자 하는 object
 * @param {Object} obj {key:value, key:value, ...}
 * @returns {Object}
 * @example
 *      var my_target = {};
 *      jexjs.extend(my_target, {'id': 'jexjs', 'name': 'jexscript'});
 */

/**
 * target 객체를 확장한다. <br />
 * 기본적으로 확장하고자 하는 모든 값을 target에 설정한다. (deep = true) <br />
 * target에 존재하는 키 값에 대해서만 확장을 하려면 (deep = false)로 설정한다. <br />
 *
 * @method extend
 * @param {Object} target 확장하고자 하는 object
 * @param {String} key
 * @param {Object} value 2번째 파라미터가 object라면 {Boolean} _deep default : true
 * @param {Boolean} _deep default : true
 * @returns {Object}
 * @example
 *      var my_target = {};
 *      jexjs.extend(my_target, 'id', 'jexjs');
 */
jexjs.extend = function(target, key, value, _deep) {
    if ( jexjs.isNull(target) ) {      target = {};   }
    if ( jexjs.isNull(key) )    {      return target;  }

    var deep = true;

    if ( typeof key === 'object' ) {
        if ( typeof value === 'boolean' && value === false ) {
            deep = false;
        }

        for ( var k in key ) {
            jexjs._extendFromKeyValue(target, k, key[k], deep);
        }
    } else if ( typeof key === 'string' ) {
        if ( typeof _deep === 'boolean' && _deep === false ) {
            deep = false;
        }

        jexjs._extendFromKeyValue(target, key, value, deep);
    }

    return target;
};

jexjs._extendFromKeyValue = function(target, key, value, deep) {
    if ( typeof target[key] == 'undefined' && !deep ) {
        return target;
    }

    if ( jexjs.isArray(value) ) {
        target[key] = jexjs.cloneArray(value);
    } else if ( "function" == typeof value ) {
        target[key] = value;
    } else if ( jexjs.isHtmlElement( value ) ) {
        target[key] = value;
    } 
    else if ( typeof value === 'object' && null !== value ) {
        if ( typeof target[key] !== 'object' ) {
            target[key] = {};
        }

        for (var j in value ) {
            jexjs.extend(target[key], j, value[j], deep);
        }
    } else {
        target[key] = value;
    }

    return target;
};

/**
 * data를 복사한 객체를 리턴한다.
 *
 * @method clone
 * @param {Object} data
 * @returns {Object}
 * @example
 *      var clonedData = jexjs.clone(originalData);
 */
jexjs.clone = function( data ) {
    if (jexjs.isArray(data)) {
        return jexjs.cloneArray(data);
    } else {
        var cloned = {};
        jexjs.extend(cloned, data);

        return cloned;
    }
};

/**
 * Array를 복제한다. 내부에 object를 데이터로 갖고 있을 경우, object copy도 수행한다.
 * @param {Array} arr
 * @returns {Array}
 * @example
 *      var clonedArr = jexjs.cloneArray(['1', '2', { id: 'hi' }]);
 */
jexjs.cloneArray = function( arr ) {
    if ( !jexjs.isArray(arr) ) {
        return arr;
    }

    var clonedArr = arr.slice(0);

    jexjs.forEach(clonedArr, function(i, v) {
        if ( jexjs.isArray(v) ) {
            clonedArr[i] = jexjs.cloneArray(v);
        } else if ( typeof v === 'object' ) {
            clonedArr[i] = jexjs.clone(v);
        }
    });
    return clonedArr;
};

/**
 * @method parseJSON
 * @param {String} data JSON 형태를 갖춘 문자열 데이터
 * @return {Object}
 */
jexjs.parseJSON = function( data ) {
    if (typeof data === 'string') {
        return JSON.parse( data );
    }

    return data;
};

/**
 * 해당 문자열이 json 형태인지 확인
 *
 * @method isJSONExp
 * @param {String} data json 형태임을 확인하고 싶은 문자열
 * @return {Boolean}
 */
jexjs.isJSONExp = function(data) {
    if (typeof data !== 'string') {
        return false;
    }
    return /(^{[^}]+})|^\[[^\]]+\](\})$/.test(data);
};

jexjs._hasJSONField = function ( data, field ) {
    if ( typeof data[ field ] === "undefined") {
        return false;
    }
    return true;
};

/**
 * JSON 객체에 해당 필드가 존재하는지 여부를 check 합니다.
 * 
 * @method hasJSONField
 * @param {JSON} data
 * @param {String} or {Array} field
 * @return {Boolean}
 */
jexjs.hasJSONField = function( data, field ) {
    if ( typeof field  === "string") {
        return jexjs._hasJSONField( data, field );
    } else if ( jexjs.isArray( field ) ) {
        var hasField = false, f;
        for( var i =0; i < field.length; i++) {
            f = field[i];
            if ( !jexjs._hasJSONField( data, f) ) {
                return false;
            }
        }
        return true;
    }
};


/**
 * @method isNull
 * @param {data} Object null 여부를 확인하고 싶은 객체
 * @return {Boolean}
 */
jexjs.isNull = function(data) {
    if (data === null || data === undefined) {
        return true;
    }

    return false;
};


/**
 * @method empty
 * @param {data} 값이 비어있는지 여부를 확인하고 싶은 객체
 * @return {Boolean}
 */
jexjs.empty = function(data) {

    if ( data === null || data === undefined ) {
        return true;
    } else if ( typeof data === 'string' && jexjs.trim(data) === '' ) {
        return true;
    } else if ( jexjs.isArray(data) && typeof data[0] === 'undefined' ) {
        return true;
    } else if ( typeof data === 'object') {
        var count = 0;

        for ( var i in data ) {
            count++;
        }

        if ( count === 0 ) {
            return true;
        }
    }

    return false;
};

/**
 * 
 * @method null2Void
 * @param {data} 문자열 data
 * @return {String} 값이 null인 경우에는 ""를 반환하며, 그렇지 않은 경우에는 입력받은 값 그대로 반환한다.
 */
jexjs.null2Void = function(data){
	return jexjs.isNull(data)? "" : data;
};

/**
 * @method type
 * @param {obj} Object 타입을 알고 싶은 객체
 * @return {String} javascript 식별 가능한 형태의 객체 문자열을 리턴한다. <br />
 * 					[ Undefined Null Array RegExp String Number Boolean Function Object Date Error ]
 */
jexjs.type = function(obj) {
    return Object.prototype.toString.call(obj).match(/^\[object\s(.*)\]$/)[1];
};

/**
 * parameter string을 만들어준다.
 * @param {JSONObject} params 
 * @example jexjs.param({{
            "key1":"val1",
            "key2":"val2",
            "key3":"val3"
        }}) => "key1=val1&key2=val2&key3=value3"
 */
jexjs.param = function(params) {
    var paramString = "";
    var cnt = 0, value = null;
    for (var key in params ) {
        if ( cnt !== 0 ) {
            paramString = paramString.concat("&");
        }
        value = (jexjs.empty(params[key])? "" : params[key]);
        paramString = paramString.concat( key );
        paramString = paramString.concat("=");
        paramString = paramString.concat( encodeURIComponent( value ));
        cnt++;
    }
    return paramString;
};

/************************************************************************************
 * Jex Cookie
 ************************************************************************************/
jexjs.cookie = {};

jexjs.cookie.option = {
		expires : 365*10,
    	path	 : "/",
    	prefix  : ''
};

jexjs.cookieSetup = function( settings ) {
	jexjs.extend(jexjs.cookie.option, settings );
};
/**
 * cookie 정보를 저장한다.
 * @method set
  * @param {String} cookieName
  * @param {String} cookieValue
  * @param {JSONObject} option
  * @example jexjs.cookie.set("USER_ID", "testid", { expires : 5 , path : "/" });
 */
jexjs.cookie.set = function( cookieName, cookieValue, option ) {
	var name = jexjs.cookie.option.prefix + cookieName;
	var d = new Date();
	if(3 == arguments.length && typeof option === "object"){
		jexjs.extend(jexjs.cookie.option, option);
	}
	d.setDate( d.getDate() + jexjs.cookie.option.expires );
	document.cookie = name + "=" + encodeURIComponent(cookieValue) + "; path="+jexjs.cookie.option.path+"; expires=" + d.toGMTString() + ";";
};

 /**
 * cookie 정보를 불러온다.
 * @method get
 * @param {String} cookieName
 * @returns {String} cookieValue
 * @example cookie.get("USER_ID");
 */
jexjs.cookie.get = function( cookieName ) {
	var name = jexjs.cookie.option.prefix + cookieName + "=";
	var ca = document.cookie.split(';');
	for(var i=0; i<ca.length; i++) {
	    var c = ca[i];
	    while (c.charAt(0)==' ') c = c.substring(1);
	    if (c.indexOf(name) != -1) return decodeURIComponent(c.substring(name.length, c.length));
	}
	return "";
};

/**
* cookie 값을 삭제합니다.
* @param {Object} cookieName
*/
jexjs.cookie.remove = function(cookieName) {
	var name = jexjs.cookie.option.prefix + cookieName;
	jexjs.cookie.set( name, "" , { expires : -1 } );
};

 /************************************************************************************
 * Jex Storage
 ************************************************************************************/
if ( typeof Storage == "undefined" ){
    jexjs.error("storage 가 지원되지 않는 browser 입니다.");
} else{
 jexjs.sessionStorage = {};
 jexjs.localStorage = {};
  /**
  * sessionStroage에 저장합니다.
  */
 jexjs.sessionStorage.set = function( key, value ) {
     var input = value;
     
     if ( !jexjs.isNull( input )) {
         if ( "string" != typeof input && jexjs.isJSONExp( JSON.stringify( input ) ) ) { //JSON
             input = JSON.stringify( input );
         } else if( jexjs.isArray(input) ){  //Array
             input = JSON.stringify( input );
         } 
         input = encodeURIComponent( input );
     }
     sessionStorage.setItem( key, input );
 };
 /**
  * sessionStroage 값을 가져옵니다.
  */
 jexjs.sessionStorage.get = function( key ) {
     var result = sessionStorage.getItem(key);
     if ( !jexjs.isNull(result) ) {
         result = decodeURIComponent( result );
         
         if ( jexjs.isJSONExp( result ) ) {
             return jexjs.parseJSON ( result );
         }else {
             try {
                 var tmpResult = jexjs.parseJSON ( result );
                 if ( jexjs.isArray(tmpResult) ){
                     return tmpResult;
                 }
             }catch(e){
             }
         }
     }
     return result;
 };
/**
 * sessionStorage 값을 삭제합니다.
 */
 jexjs.sessionStorage.remove =  function( key ) {
     sessionStorage.removeItem( key );
 };

  /**
  * localStorage 저장합니다.
  */
 jexjs.localStorage.set = function( key, value ) {
     var input = value;
     if ( !jexjs.isNull( input )) {
         if ( "string" != typeof value && jexjs.isJSONExp( JSON.stringify( input ) ) ) { //JSON
             input = JSON.stringify( input );
         } else if( jexjs.isArray(input) ){  //Array
             input = JSON.stringify( input );
         } 
         input = encodeURIComponent( input );
     }
     localStorage.setItem( key, input );
 };
 /**
  * localStorage 값을 가져옵니다.
  */
 jexjs.localStorage.get = function( key ) {
     var result = localStorage.getItem(key);
     if ( !jexjs.isNull(result) ) {
         result = decodeURIComponent( result );
         if ( jexjs.isJSONExp( result ) ) {
             return jexjs.parseJSON ( result);
         }else {
             try {
                 var tmpResult = jexjs.parseJSON ( result );
                 if ( jexjs.isArray(tmpResult) ){
                     return tmpResult;
                 }
             }catch(e){
                 
             }
         }
     }
     return result;
 };
/**
 * localStorage 값을 삭제합니다.
 */
 jexjs.localStorage.remove =  function( key ) {
     localStorage.removeItem( key );
 };
}

/************************************************************************************
 * Jex File Util
 ************************************************************************************/
/**
 * dataUrl -> Blob로 변경
 */
jexjs.dataURLtoBlob = function ( dataURL ) {
    
    var byteString = atob(dataURL.split(',')[1]);

    var mimeString = dataURL.split(',')[0].split(':')[1].split(';')[0];

    var ab = new ArrayBuffer(byteString.length);
    var ia = new Uint8Array(ab);
    for ( var i = 0; i < byteString.length; i++) {
        ia[i] = byteString.charCodeAt(i);
    }

    return new Blob( [ia], { type: mimeString });
};

jexjs.isBlob = function( blobData ) {
    return window.Blob && "[object Blob]" === Object.prototype.toString.call(maybeBlob);
};

jexjs.isFile = function( fileData ) {
    return window.File && "[object File]" === Object.prototype.toString.call(maybeFile);
};

jexjs.isFileList = function( fileList ) {
    return window.File && "[object FileList]" === Object.prototype.toString.call(maybeFile);
};

/************************************************************************************
 * Jex Event Util
 ************************************************************************************/
jexjs.event = {
    //Event 추가
    attach : function( element , type, myHandler ) {
        if ( element.addEventListener ) {                // For IE8 이하버전 이외의 모든 브라우져
			element.addEventListener( type, myHandler, false );
		} else if ( element.attachEvent ) {              // For IE 8 and earlier versions
			element.attachEvent("on" + type , myHandler );
		} else {
			element["on"+type] = myHandler;
		}
    },
    //Event 삭제
    detach : function( element, type, myHandler ) {
        if ( element.removeEventListener ) {                  // For IE8 이하버전 이외의 모든 브라우져
            element.removeEventListener(type, myHandler, false);
        } else if ( element.detachEvent ) {                     // For IE 8 and earlier versions
            element.detachEvent("on"+type, myHandler);
        } else {
        	element["on"+type] = null;
         }
    },
    preventDefault : function(e){
        if (e.preventDefault) {
            e.preventDefault();
        } else {
            e.returnValue = false;
        }
    },
    stopPropagation : function(e){
        if ( e.stopPropagation ) {
            e.stopPropagation();
        } else {
            e.cancelBubble = true;
        }
    },
    getEvent : function( event ){
    	return event ? event : window.event;
    },
    getTarget : function( event ){
    	return event.target || event.srcElement;
    },
    getRelatedTarget : function ( event ) {
    	if ( event.relatedTarget ) {
    		return event.relatedTarget;
    	} else if ( event.toElement ) {
    		return event.toElement;
    	} else if( event.fromElement ) {
    		return event.fromElement;
    	} else {
    		return null;
    	}
    },
    getButton : function( event ) {
    	if ( document.implementation.hasFeature("MouseEvents","2.0") ) {
    		return event.button;
    	} else {
    		switch( event.button ) {
    		case 0:
    		case 1:
    		case 3:
    		case 5:
    		case 7:
    			return 0;
    		case 2:
    		case 6:
    			return 2;
    		case 4:
    			return 1;
    		}
    	}
    } 
};

/************************************************************************************
 * Jex Event Util
 ************************************************************************************/
jexjs.cssUtil = {
    getComputedStyle: function( elem, prop ) {
        if (window.getComputedStyle && window.getComputedStyle(elem, null)) {
            return window.getComputedStyle(elem, null).getPropertyValue(prop);
        } else {
            return elem.style[prop];
        }
    }
};
/**
 * logger 정보를 저장하기 위한 변수
 * @property jexjs.global.logger.level
 * @type {String}
 * @default "off"
 * off, error, warn, info, debug
 * off : 출력안함
 * error : javascript exception 발생시킴
 * debug : 
 */
jexjs.global.logger = {
    _ENUM_LEVEL : ['OFF','ERROR','WARN','INFO','DEBUG'],
    level:1
};

/**
 * debug 모드로 작동할 지에 대한 설정 <br />
 * url?jex_debug=true 로 debug 모드를 작동시킬 수 있다.
 *
 * @property jexjs.global.debug
 * @type {boolean}
 * @default false
 */
jexjs.global.debug = false;

/**
 * @method error
 * @param {String} msg 메시지
 * @return {Error} 에러를 발생한다.
 */
jexjs.error = function(msg) {
    jexjs.logger.error(msg);
};

/**
 * @method warn
 * @param {String} msg 메시지
 */
jexjs.warn = function(message) {
    jexjs.logger.warn(message);
};

/**
 * @method info
 * @param {String} msg 메시지
 */
jexjs.info = function(message) {
    jexjs.logger.info(message);
};

/**
 * @method debug
 * @param {String} msg 메시지
 */
jexjs.debug = function(message) {
    jexjs.logger.debug(message);
};


/**
 * URL query string의 내용을 caching해 놓기위한 객체
 * @readOnly
 */
jexjs.global._url_parameter = {};

/**
 * parameter는 onload 시 URL의 query string을 기본으로 파라미터를 설정한다.
 * 등록된 parameter가 있을 경우 key 값에 해당하는 데이터를 리턴한다.
 *
 * @method getParameter
 * @param {String} key
 * @return {String}
 */
jexjs.getParameter = function(key) {
    return jexjs.global._url_parameter[key];
};

/**
 * parameter는 onload 시 URL의 query string을 기본으로 파라미터를 설정한다.
 * 등록된 parameter object를 리턴한다.
 *
 * @method getParameterMap
 * @return {Object}
 */
jexjs.getParameterMap = function() {
    return jexjs.global._url_parameter;
};

// parsing URL query string
// URL에 존재하는 파라미터 값을 설정한다.
(function() {
    var queryString = window.location ? window.location.search : "";

    if (queryString.indexOf("?") > -1) {
        var startIndex = queryString.indexOf("?") + 1,
            endIndex = queryString.indexOf("#")
            ;

        queryString = (endIndex > -1) ?
            queryString.substring(startIndex, endIndex) :
            queryString.substring(startIndex);

        var queryArray = queryString.split("&");
        for (var i = 0; i < queryArray.length; i++) {
            var keyValue = queryArray[i].split("="),
                key = keyValue[0],
                value;

            if (keyValue.length === 1) {
                value = "";
            } else {
                value = keyValue[1];
            }

            jexjs.global._url_parameter[key] = decodeURIComponent(value);
        }
    }
})();

/**
 * 로그레벨을 설정합니다. 
 * @param enumLevel 'OFF','ERROR','WARN','INFO','DEBUG'
 */
jexjs.setLogLevel = function( enumLevel ){
    var globalLogger = jexjs.global.logger;
    enumLevel = enumLevel.toUpperCase();
    var level = globalLogger._ENUM_LEVEL.indexOf( enumLevel );
    if ( -1 < level ) {
        globalLogger.level = level;
    }
};

/**
 * 현재의 로그레벨을 반환합니다.
 */
jexjs.getLogLevel = function(){
    var globalLogger = jexjs.global.logger;
    return globalLogger._ENUM_LEVEL[ globalLogger.level ];
};

//사용하지 말것!! 호환성위해 남겨둠
// set debug = true if parameter 'jex_debug' exists 
(function() {
    var debug = jexjs.getParameter("jex_debug");
    if ("boolean" == typeof debug ) {
        if(debug) {
            jexjs.global.logger.level = 4;
        }
    }
})();

// set debug logLevel
(function() {
    var level = jexjs.getParameter("jex_logger_level");
    if ( "string" == typeof level ) {
        jexjs.setLogLevel(level);
    }
})();


/**
 * 사용하지 말것!!!! 호환성유지를 위해 남겨둔다. 
 * debug 사용여부를 설정한다.
 * @method setDebug
 * @param {Boolean} true or false
 * @example
 *      jexjs.setDebug(true);
 */
jexjs.setDebug = function( isDebug ) {
    var globalLogger = jexjs.global.logger;
    if ( isDebug ){
        globalLogger.level = 4;
    } else {
        globalLogger.level = 1;
    }
};
/**
 * 사용하지 말것!!!! 호환성유지를 위해 남겨둔다. 
 */
jexjs.isDebug = function() {
    var globalLogger = jexjs.global.logger;
    
    if ( 4 == globalLogger.level ) {
        return true;
    } else {
        return false;
    }    
};

/**
 * 사용하지 말것!!!! 호환성유지를 위해 남겨둔다. 
 */
jexjs.log = function(message) {
    jexjs.logger.debug(message);
};
/**
 * 사용자에게 알림창을 띄운다.
 *
 * @method alert
 * @param {String} message 옵션. 안내 메시지
 * @example
 *      jexjs.alert("잘못된 정보입니다.");
 */
jexjs.alert = function(message) {
    alert(message);
};

/**
 * 사용자로부터 Ok, Cancel 중 하나를 입력받을 수 있는 창을 띄운다.
 *
 * @method confirm
 * @param {String} message 옵션. 안내 메시지
 * @returns {Boolean}
 * @example
 *      var doSave = jexjs.confirm("저장하시겠습니까?");
 */
jexjs.confirm = function(message) {
    return confirm(message);
};

/**
 * 사용자로부터 값을 입력받을 수 있는 창을 띄운다.
 *
 * @method prompt
 * @param {String} message 안내 메시지.
 * @param {String} text 옵션. 기본 입력 값을 설정할 수 있다.
 * @returns {String}
 * @example
 *      var userInput = jexjs.prompt("아이디를 입력해주세요.", "hello@gmail.com");
 */
jexjs.prompt = function(message, text) {
    return prompt(message, text);
};

jexjs.getCode = function(group, key) {
    return jexjs.plugin('code_manager').getCode(group, key);
};

jexjs.getSimpleCode = function(group, key) {
    return jexjs.plugin('code_manager').getSimpleCode(group, key);
};

/**
 * {{#crossLink "jexjs.plugins/require:method"}}{{/crossLink}} 함수를 이용하여 플러그인을 생성한다. <br />
 *
 * @example
 *      var myPlugin = jexjs.plugin('myPlugin', 'param1', 'param2', ...);
 *
 *
 * @method plugin
 * @param {String} key 등록된 plugin key
 * @returns {Object}
 *
 */
jexjs.plugin = function(key) {
    return jexjs.plugins.require.apply(this, arguments);
};

/**
 * jexjs가 선언되어있는 최상위 window를 (parent, opener) 가져옵니다.
 * @method getRoot
 * @returns {window} 최상위 window
 * @example
 *      var root_jexjs = jexjs.getRoot();
 */
jexjs.getRoot = function(p,b){
	
	if(jexjs.isNull(p)) {
		p = (jexjs.isNull(opener))? parent:opener;
		if(jexjs.isNull(p)) {
		    p = window;
		}
		b = window;
	}
	try {
	    if(!p.jexjs) return b;
    } catch ( e ) {
        return b;
    }

	if( p === b ) return b;
	else return jexjs.getRoot(p.parent,p);
};

/**
 * @method getOpener
 * @returns {window}
 * @example
 *      jexjs.getOpener();
 */
jexjs.getOpener = function(){
	return ( jexjs.isNull(opener) ) ? parent : opener;
};

/**
 * jexjs가 선언되어있는 최상위 parent window를 가져옵니다.
 * @method getRootParent
 * @returns {window} 최상위 parent window
 * @example jexjs.getRootParent();
 */
jexjs.getRootParent = function(p,b){
	
	if(jexjs.isNull(p) && jexjs.isNull(b)) {
		p = parent;
		b = window;
		if(jexjs.isNull(p)) {
			p = window;
		}
	}
	try {
	    if(!p.jexjs) return b;
    } catch ( e ) {
        return b;
    }

	if( p === b ) return b;
	else return jexjs.getRootParent(p.parent,p);
};

/**
 * 브라우져 정보와 버전을 확인하기 위해 사용
 */
jexjs.global._navigator = window.navigator;

jexjs.getBrowser = function( customUserAgent ){
	
	if ( !customUserAgent ) customUserAgent = jexjs.global._navigator.userAgent.toLowerCase();
	else customUserAgent = customUserAgent.toLowerCase();
    var version = "";
    var chooseBrowser = null;
    var browser = {
            'msie': false,
            'chrome': false,
            'firefox': false,
            'safari': false,
            'opera' : false,
            'version':''
    };
    
    var matchs = customUserAgent.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))[\/]?\s*([\d.]+)/i) || [];
	
    //해당 브라우져만 true 설정
	for(var b in browser){
		if ( b === matchs[1] ) {
			browser[b] = true;
			chooseBrowser = b;
		}
	}
	
	//MSIE값보다 trident 버전이 더 높은경우 trident값을 따름.
	if( /msie/i.test( matchs[1]) ){
		//IE - 'MSIE' 형식이 아닌경우
		var trident =  /\btrident(?=\/)[\/]?\s*([\d.]+)/g.exec(customUserAgent) || [];
		if ( chooseBrowser )	browser[ chooseBrowser ] = false;
		browser.msie = true;
		browser.version = ( parseFloat(matchs[2]) < ( parseFloat(trident[1]) + 4 ) ? parseFloat(trident[1]) + 4 : matchs[2] );
		return browser;
	}
	//IE - 'MSIE' 형식이 아닌경우
	else if(/trident/i.test(matchs[1]) ){
		var rv =  /\brv[ :]+([\d.]+)/g.exec(customUserAgent) || [];
		if ( chooseBrowser )	browser[ chooseBrowser ] = false;
		browser.msie = true;
		browser.version = rv[1] || '';
		return browser;
	}//opera user agent에 firefox가 포함된 경우
	else if( matchs[1] === 'firefox' ){
		version = customUserAgent.match(/\bopera[\/ ]?([\d.]+)/);
        
        if( null !== version ) {
        	if ( chooseBrowser )	browser[ chooseBrowser ] = false;
        	browser.opera = true;
        	browser.version = version[1];
        	return browser;
         }
	}
	
	browser.version = ( matchs[2] ? matchs[2] : navigator.appVersion );
	if((version = customUserAgent.match(/version\/([\d.]+)/i))!== null) {
		browser.version = version[1];
	}
	
    return browser;
};

//보안문제로 https 인경우만 가능
jexjs.getGeolocation = function( callback ) {
    if ( "geolocation" in jexjs.global._navigator) {
        var geolocation = jexjs.global._navigator.geolocation;
        geolocation.getCurrentPosition( function( position ){
            var geo = {
                    'latitude' : position.coords.latitude,
                    'longitude' : position.coords.longitude  
            };
            callback.call( undefined, geo);
        });
         
    } else {
         callback.call(undefined, {} );
    }
};

jexjs._isJexMobile = function() {
    return false;
};

/**
 * TODO TEMP
 * jQquery의 기능을 임시로 사용하기 위해 만듦.
 * 추후에 구현예정 
 */
jexjs.$ = jQuery;


/**
 * logger <br />
 * jexjs.isDebug() === true 일 때에만 로그를 출력한다.
 *
 *
 * TODO
 * 현재 isDebug 에 대한 체크로만 로깅을 진행하는데
 *  # hash 값을 통해서 console, html logger를 변경하거나 하는 등의 내용에 대해서
 *  좀 더 고민해봐야한다.
 *
 *
 * @class jexjs.logger
 */

(function() {

    if (typeof console === 'undefined' || !console) {    console = {};    }
    if (typeof console.log === 'undefined') {
        console.log = function(message) {};
    }
    // level : off, error, warn, info, debug
    
    var ConsoleLogger = function(){
        
        var globalLogger = jexjs.global.logger;
        
        function _getLevelNumber(){
            return globalLogger.level;
        }
        
        function _print( message ){
            if ( jexjs._isJexMobile() ){
                if ( jexjs.isEmulator() ){
                    console.log(message);
                }
            } else {
                console.log(message);
            }
        }
        
        return {
            error: function(message) {
                if ( 0 < _getLevelNumber() ){
                    throw new Error(message);
                }
            },
            warn : function(message) {
                if ( 1 < _getLevelNumber() ) {
                    _print(message);
                }
            },
            info : function(message) {
                if ( 2 < _getLevelNumber() ) {
                    _print(message);
                }
            },
            debug: function(message) {
                if ( 3 < _getLevelNumber() ) {
                    _print(message);
                }
            }
        };
    };
    
    var HtmlLogger = function() {

        /**
         * div #jexjs-logger
         *      div .jexjs-logger-badge
         *      div .jexjs-logger-console
         *          ul
         *              li .jexjs-logger-console-line
         */
        var id = "jexjs-logger",
            classBadge = "jexjs-logger-badge",
            classConsole = "jexjs-logger-console",
            classConsoleLine = "jexjs-logger-console-line",

            classDisplayNone = "jexjs-hide" // core css display:none
        ;
        var globalLogger = jexjs.global.logger;

        var $logger = jexjs.$("#" + id);
        if ($logger.length === 0) {
            var html = '<div id="' + id + '">' +
                '<div class="' + classBadge + '"></div>' +
                '<div class="' + classConsole + ' ' + classDisplayNone + '">' +
                    '<ul></ul>' +
                '</div>' +
            '</div>'
            ;

            $logger = jexjs.$(html).appendTo("body");
        }

        var $console = $logger.find('.' + classConsole),
            $ul = $console.find("ul");

        $logger.find('.' + classBadge).on('click', function() {
            if ($console.css('display') === "none") {
                $console.removeClass('jexjs-hide');
            } else {
                $console.addClass('jexjs-hide');
            }
        });

        function _getLevelNumber(){
            return globalLogger.level;
        }
        
        function appendLine(message) {
            message = 'jexjs : ' + message;
            jexjs.$('<li class="' + classConsoleLine + '">' + message + '</li>').appendTo($ul);
        }

        return {
            error: function(message) {
                if ( 0 < _getLevelNumber() ){
                    throw new Error(message);
                }
            },
            warn : function(message) {
                if ( 1 < _getLevelNumber() ) {
                    appendLine(message);
                }
            },
            info : function(message) {
                if ( 2 < _getLevelNumber() ) {
                    appendLine(message);
                }
            },
            debug: function(message) {
                if ( 3 < _getLevelNumber() ) {
                    appendLine(message);
                }
            }
        };
    };

    if (jexjs.getParameter("jex_logger") !== "html") {
        jexjs.logger = new ConsoleLogger();
    } else {
        jexjs.logger = new HtmlLogger();
    }
})();

jexjs.debug("[init] loading jexjs modules");


/**
 * event <br />
 *
 * jexjs에서 실제로 event가 발생하지 않도록, 
 * @class Loader
 */
(function() {
    
    var Loader = function(){
        
        var _beforeOnload = [],
            _afterOnload = [],
            _beforeReload = [],
            _afterReload = [];
        
        var _pageLoader = [];
        
        function _reload (){

            var i,max;
            
            for (i=0, max = _beforeReload.length; i < max; i++) {
                _beforeReload[i]();
            }
            
            for(i=0; i < _pageLoader.length; i++){
                if ( "function" == typeof _pageLoader[i].reload ){
                    _pageLoader[i].reload();
                }
            }
            
            for(i=0, max = _afterReload.length; i < max; i++ ){
                _afterReload[i]();
            }
        }
        
        return {
            pushInstance : function( pageLoader ){
                _pageLoader.push( pageLoader );
            },
            getInstance : function(){
                return _pageLoader;
            },
            reload : function(){
                _reload();
            },
            addBeforeOnload : function( _fn, _index ){
                var idx = _index | _beforeOnload.length;
                if ("function" == typeof _fn ) {
                   _beforeOnload.jexPushByIndex( _fn, _index );
                }else{
                    jexjs.error("jexjs loader : addBeforeOnload [error] : function만 event에 추가할 수 있습니다.");
                }
            },
            getBeforeOnload : function(){
                return _beforeOnload;
            },
            addAfterOnload : function( _fn, _index ){
                var idx = _index | _afterOnload.length;
                if ("function" == typeof _fn ) {
                   _afterOnload.jexPushByIndex( _fn, _index );
                }else{
                    jexjs.error("jexjs loader : addAfterOnload [error] : function만 event에 추가할 수 있습니다.");
                }
            },
            getAfterOnload : function(){
                return _afterOnload;
            },
            addBeforeReload : function(_fn, _index) {
                var idx = _index | _beforeReload.length;
                if ("function" == typeof _fn) {
                    _beforeReload.jexPushByIndex(_fn, _index);
                } else {
                    jexjs.error("jexjs loader : addBeforeReload [error] : function만 event에 추가할 수 있습니다.");
                }
            },
            getBeforeReload : function() {
                return _beforeReload;
            },
            addAfterReload : function(_fn, _index) {
                var idx = _index | _afterReload.length;
                if ("function" == typeof _fn) {
                    _afterReload.jexPushByIndex(_fn, _index);
                } else {
                    jexjs.error("jexjs loader : addAfterReload [error] : function만 event에 추가할 수 있습니다.");
                }
            },
            getAfterReload : function() {
                return _afterReload;
            }
        };
    };
    jexjs.loader = new Loader();
})();
/**
 * 플러그인 등록 및 생성을 도와준다.
 *
 * @class jexjs.plugins
 * @static
 */
jexjs.plugins = {
    _plugins : {},

    /**
     * 플러그인 등록을 위한 함수 <br />
     * Class 에는 function() { } 원형을 추가해야 하며, init 함수를 반드시 포함해야한다. <br />
     * init 함수는 n개의 파라미터를 받도록 정의할 수 있고, jexjs.plugins.require('key', 'param1', 'param2', ...) 처럼 <br />
     * 2번째 이후의 모든 파라미터를 init 함수로 넘겨준다. <br />
     *  function init(param1, param2, ...) {   ... } <br />
     *
     *
     * @example
     *      객체를 리턴함으로써 특정 메소드만 public 메소드로써 생성하는 방법
     *      jexjs.plugins.define('test_plugin', function() {
     *          return {
     *              init: function(my_param, param2) {
     *                  ...
     *              }
     *          };
     *      });
     *
     * @example
     *      function() { }을 생성한 후 prototype을 통해 함수를 정의하고 등록하는 방법
     *      var myPlugin = function() { };
     *      myPlugin.prototype.init = function() { ... };
     *
     *      jexjs.plugins.define('test_plugin', myPlugin);
     *
     * @example
     *      의존성 플러그인을 함께 선언하는 방법
     *      jexjs.plugins.define('test_plugin', [ 'dep', 'mod', 'reg' ], function(dep, mode, reg) {
     *          ...
     *      });
     *
     *
     * @method define
     * @param {String} key
     * @param {Array: key} _dependencies 옵션값. 의존 플러그인이 있을 경우에 사용 할 수 있다.
     * @param {Class} _Class
     */
    define : function(key, _dependencies, _Class, isStatic){
        var dependencies, Class;
        var global = jexjs.global.plugins[key]   = {};

        if (jexjs.isArray(_dependencies)) {
            dependencies = _dependencies;
            Class = _Class;
            global.isStatic = !!isStatic;
        } else {
            Class = _dependencies;
            global.isStatic = _Class;
        }

        global.dependencies = jexjs.clone(dependencies) || [];
        jexjs.plugins._plugins[key] = Class;
        jexjs.debug("  [plugin] define '" + key + "'");
    },

    /**
     * 등록된 플러그인을 생성해준다. <br />
     * {{#crossLink " jexjs/plugin:method"}}{{/crossLink}} 함수를 이용하여 생성할 수도 있다. <br />
     *
     * @example
     *      var pluginObject = jexjs.plugins.require('test_plugin', 'param1', 'param2');
     *      pluginObject.myMethod();
     *
     *
     * @method require
     * @param {String} key
     * @returns {Object} plugin object
     */
    require : function(key) {
        var args = Array.prototype.slice.call(arguments, 1);

        var Plugin = jexjs.plugins._plugins[key];

        if (jexjs.isNull(Plugin)) {
            jexjs.error("jexjs.plugins." + key + " is not defined.");
        }

        var global = jexjs.global.plugins[key];

        if (global.isStatic && global.instance) {
            return global.instance;
        }

        var dependencies = global.dependencies,
            dependencyPlugins = [];

        for (var i = 0; i < dependencies.length; i++) {
            var dependency = jexjs.plugins.require(dependencies[i]);
            dependencyPlugins.push(dependency);
        }

        //var plugin = new Plugin();
        var plugin = Object.create(Plugin.prototype);
        var publicScope = Plugin.apply(plugin, dependencyPlugins);

        if (typeof publicScope.init === 'function') {
            //publicScope.init.apply( this , args);
            publicScope.init.apply( publicScope , args);
        }

        if (global.isStatic) {
            global.instance = publicScope;
        }

        return publicScope;
    }
};




/* ==================================================================================
 * ajax 통신을 수행한다.
 *
 * - dependency
 *      jQuery.ajax
 *
 * 기존 버전 호환을 위해서 .createAjaxUtil(url) 함수를 유지한다.
 * 
 * ajax -> success -> filter -> filter의 true, false 에 따라 업무 success, error 함수 호출
 *      -> error -> ajax 호출시 error 함수 구현되어있지 않으면, 공통 error Function, 있으면 업무 error 함수 호출
 * 
 * ================================================================================== */
jexjs.plugins.define('ajax', function() {
    var
        // ajax 통신 시 전달할 파라미터를 저장한다.
        _parameter = {},
        // 사용자 정의 callback
        _callback = {
            success: null,
            error: null
        },

        _global     = jexjs.global.plugins.ajax,

        url         = "",
        context_path = _global.contextPath || "",
        url_prefix  = _global.prefix || "",
        url_suffix  = _global.suffix || ".jct",
        filters     = _global.filters || [],
        filter      = true,
        beforeExecutes = _global.beforeExecutes || [];
    
        if( _global.callback ) jexjs.extend( _callback , _global.callback );
    
    var indicator = _global.indicator || jexjs.plugin('indicator', { modal: true });

    var option = {
            userData : false
    };
    
    // ajax 통신에 필요한 설정 기본값
    var settings = {
        type: "POST",
        url: "",
        data: {},
        cache: false,
        headers: {
            "cache-control": "no-cache",
            "pragma": "no-cache"
        },
        commonData: {}  //모든 ajax 호출시 사용되는 공통 data. 
    };

    jexjs.extend(settings, _global.settings);
    
    var jexExecutor = {
        execute: function(settings, _parameter, option ) {
            if ( option.userData ){
                for(var key in _parameter){
                    settings.data[key] = _parameter[key];
                }
            }else {
                jexjs.debug('  jexjs.plugin.ajax : _parameter ' + JSON.stringify(_parameter));
                settings.data = {
                    "_JSON_": encodeURIComponent(JSON.stringify(_parameter))
                };
            }
            
            if ( settings.delay && typeof settings.delay == "number"){
                var delay = settings.delay;
                delete settings.delay;
                setTimeout(function(){
                    jQuery.ajax(settings);
                },delay);
            } else {
                jQuery.ajax(settings);
            } 
        }
    };
    
    var _jexExecutor = _global.executor || jexExecutor;
    
    if ( 0 < beforeExecutes.length ){
        _jexExecutor.beforeExecutes = beforeExecutes;
    }
    
    function _execute() {
        
        _beforeExecute();
        
        //전처리 함수 실행
        var pSettings = jexjs.clone( settings );
        
        if ( _jexExecutor.beforeExecutes && 0 < _jexExecutor.beforeExecutes.length ) {
            for(var i=0; i < _jexExecutor.beforeExecutes.length; i++) {
                pSettings = _jexExecutor.beforeExecutes[i](pSettings);
            }
        }
        jexjs.extend( settings, pSettings );

        var param = {};
        //전처리함수(beforeExecute)에서 설정한 공통 data가 있는 경우
        if ( !jexjs.empty(settings.commonData) ) {
            jexjs.extend( param, settings.commonData );
            delete settings.commonData; //ajax 호출시 사용하지 않으므로 삭제
        }

        jexjs.extend( param, _parameter );

        _jexExecutor.execute(settings, param, option );
    }

    function _getUrl ( context_path , url_prefix,  url, url_suffix){
        
        var fullUrl = context_path + url_prefix;
        
        if ( -1 == url.indexOf(".jct") ){
            fullUrl += url + url_suffix;
        } else {
            fullUrl += url;
        }
        fullUrl = fullUrl.replace( /\/\//g, "/");
        return fullUrl;
    }
    
    function _beforeExecute() {
        settings.success    = _jQueryAjaxSuccess;
        settings.error      = _jQueryAjaxError;
        settings.url        = _getUrl( context_path , url_prefix , url , url_suffix );

        _showIndicator();
    }

    function _jQueryAjaxSuccess(data,textStatus, jqXHR) {
        var result = data;
        if (typeof result === 'string' && jexjs.isJSONExp(result)) {
            result = jexjs.parseJSON(result);
        }

        //jqXHR.getAllResponseHeaders();  jqXHR.getResponseHeader("date")

        jexjs.debug('    jexjs.plugin.ajax : ' + settings.url + ' 호출 성공');

        if ( _checkFilter(result,jqXHR) ) {
            if (typeof _callback.success === "function") {
                _callback.success(result,jqXHR);
            }
        } else {
            _jQueryAjaxError(result,jqXHR);
        }

        _complete();
    }

    function _checkFilter(result) {
        if (!filter) {
            return true;
        }

        var filterResult = true;
        for (var i = 0, length = filters.length; i < length; i++) {
            jexjs.debug('    jexjs.plugin.ajax : ' + ( i + 1) + ' filter start');
            var doNext = filters[i](result);

            if (typeof doNext === 'boolean' && !doNext) {
                filterResult = false;
                jexjs.debug('    jexjs.plugin.ajax : ' + ( i + 1) + ' filter failed');
                jexjs.debug(result);
                break;
            }

            if (i === length -1) {
                jexjs.debug('    jexjs.plugin.ajax : all filter passed.');
            }
        }

        return filterResult;
    }

    function _jQueryAjaxError(data,jqXHR) {
        jexjs.debug('  jexjs.plugin.ajax [error] : 호출 실패! ' + settings.url);
        jexjs.debug('  jexjs.plugin.ajax [error] : [' + data.status+'] ' + data.statusText);
        if (typeof _callback.error === "function") {
            _callback.error(data,jqXHR);
        }
        _complete();
    }

    function _complete() {
        _hideIndicator();
    }

    function _setIndicator( _indicator ) {
        if (typeof _indicator === 'object') {
            if ( typeof _indicator.show === 'function' && typeof _indicator.hide === 'function' ) {
                indicator = _indicator;
            }
        } else if ( typeof _indicator === 'boolean' &&  _indicator === false ){
          indicator = _indicator;  
        }
    }

    function _showIndicator() {
        if (indicator) {
            indicator.show();
        }
    }

    function _hideIndicator() {
        if (indicator) {
            indicator.hide();
        }
    }

    return {
        init: function(_url, _indicator) {
            url = _url;

            _setIndicator( _indicator );
        },

        setIndicator: function( _indicator ) {
            _setIndicator( _indicator );
        },
        
        getIndicator : function(){
            return indicator;
        },

        /**
         * 파라미터를 설정하는 함수 <br />
         * {key} 값에 {value} 값을 설정한다.
         *
         * @method set
         * @param {String} key
         * @param {Object} value
         */

        /**
         * 파라미터를 설정하는 함수 <br />
         * {key} 값에 {value} 값을 설정한다.
         *
         * @method set
         * @param {Object} obj {key: value, key: value, ...}
         */
        set: function(key, value) {
            jexjs.extend(_parameter, key, value);
        },

        /**
         * 파라미터에 저장된 값을 얻어온다.
         *
         * @method get
         * @param {key} String
         * @return {Object} key 값에 저장된 데이터
         */
        get: function(key) {
            return _parameter[key];
        },

        /**
         * 현재 ajax 플러그인에 설정된 설정 값을 꺼낸다. <br />
         * prefix, suffix 는 내부적으로 url_prefix, url_suffix를 리턴한다.
         *
         * @method setting
         * @param {String} key 가져오고자 하는 설정값의 key
         * @returns {Object}
         * @example
         *      var checkUrl = jexAjax.setting('url');
         *      var checkSuffix = jexAjax.setting('suffix');
         */

        /**
         * ajax 통신을 위한 설정 값을 지정한다. <br />
         * prefix, suffix 는 내부적으로 url_prefix, url_suffix 로 지정하고 제거한 후에 <br />
         * 나머지 설정 값은 ajax 통신을 위해 사용한다.
         *
         * @method setting
         * @param {String} key
         * @param {Object} value
         * @example
         *      jexAjax.setting('url', 'new_url');
         */

        /**
         * ajax 통신을 위한 설정 값을 지정한다. <br />
         * prefix, suffix 는 내부적으로 url_prefix, url_suffix 로 지정하고 제거한 후에 <br />
         * 나머지 설정 값은 ajax 통신을 위해 사용한다.
         *
         * @method setting
         * @param {Object} obj {key: value, key: value, ...}
         * @example
         *      jexAjax.setting({
         *          'prefix': '/plugin',
         *          'suffix': '.jct',
         *          'url': 'new_url',
         *          'async': false
         *      });
         */
        setting: function(key, value) {
            if (arguments.length === 1 && typeof key === 'string') {
                if (key === 'contextPath') {
                     return context_path;
                } else if (key === 'prefix') {
                    return url_prefix;
                } else if (key === 'suffix') {
                    return url_suffix;
                } else if (key === 'url') {
                    return url;
                } else if (key === 'filter') {
                    return filter;
                } else if (key == 'userData'){
                    return option.userData;
                } else {
                    return settings[key];
                }
            }

            if (typeof key === 'object') {
                for (var k in key) {
                    this._setting(k, key[k]);
                }
            } else if (typeof key === 'string') {
                this._setting(key, value);
            }
        },
        _setting: function(key, value) {
             if (key === 'contextPath') {
                 context_path = value;
            } else if (key === 'url') {
                url = value;
            } else if (key === 'prefix') {
                url_prefix = value;
            } else if (key === 'suffix') {
                url_suffix = value;
            } else if ( key === 'userData') {
                option.userData = value;
            } else if (key === 'filter') {
                if (typeof value === 'boolean') {
                    filter = value;
                }
            } else {
                jexjs.extend(settings, key, value);
            }
        },

        /**
         * 사용자 callback을 지정한다.
         *
         * @method callback
         * @param {String} key 'success' | 'error'
         * @param {Function} fn 사용자 callback
         *
         * @example
         *      function your_success(data) { }
         *      function your_error(data) { }
         *
         *      jexAjax.callback('success', your_success);
         *      jexAjax.callback('error', your_error);
         */

        /**
         * 사용자 callback을 지정한다.
         *
         * @method callback
         * @param {Object} obj {key: Fn, key: Fn, ... }
         *
         * @example
         *      function your_success(data) { }
         *      function your_error(data) { }
         *
         *      jexAjax.callback({
         *          'success': your_success,
         *          'error': your_error
         *      });
         */
        callback: function(key, value) {
            jexjs.extend(_callback, key, value);
        },

        /**
         * executor를 설정한다. <br />
         * default : jQuery.ajax를 사용하는 executor <br /><br />
         *
         * execute 함수를 반드시 구현해야 하며, settings, parameter 를 변수로 받을 수 있다. <br />
         * execute 함수는 처리 후 반드시 settings.success, settings.error 함수를 호출해줌으로 써 <br />
         * callback 처리를 해주어야 한다.
         *
         * @method executor
         * @param {Object} executor
         * @example
         *      jexAjax.executor({
         *          execute: function(settings, parameter) {
         *              if (success) {
         *                  settings.success({});
         *              } else {
         *                  settings.error({});
         *              }
         *          }
         *      });
         */
        executor: function(executor) {
            if (typeof executor.execute === 'function') {
                _jexExecutor = executor;
            } else {
                jexjs.error("jexjs.plugin.ajax.executor must implements execute function");
            }
        },

        /**
         * ajax 통신을 수행한다.
         * @method execute
         * @param {Function} callback
         * @example
         *      jexAjax.execute();
         *      jexAjax.execute(function(data) {
         *          // success!!!!!
         *      });
         *
         *      jexAjax.execute({
         *          success: function(data) {
         *              // success
         *          },
         *          error: function(data) {
         *              // error
         *          }
         *      });
         *
         */
        execute: function(callback) {
            if (typeof callback === 'function') {
                this.callback('success', callback);
            } else if (typeof callback === 'object') {
                if (typeof callback.success === 'function') {
                    this.callback('success', callback.success);
                }
                if (typeof callback.error === 'function') {
                    this.callback('error', callback.error);
                }
            }

            _execute();
        }
    };
});

/**
 * ajax Error 인지 아닌지를 판단합니다.
 * ERROR값이 true 인경우
 * @parameter dat ajax action호출 후 반한된 데이터값
 * @example {"COMMON_HEAD":{"ERROR":true,"MESSAGE":"","CODE":""}}
 */
jexjs.isJexError = function( dat ){
    if ( !jexjs.isNull( dat ) && !jexjs.isNull(dat.COMMON_HEAD) ) {
        if ( !jexjs.isNull(dat.COMMON_HEAD.ERROR) && dat.COMMON_HEAD.ERROR ){
            return true;
        }
    }
    return false;
};

/**
 * ajax Error 인경우 ErrorCode를 반환해줍니다.
 * @parameter dat ajax action호출 후 반한된 데이터값
 * @example {"COMMON_HEAD":{"ERROR":true,"c":"","CODE":""}}
 */
jexjs.getJexErrorCode = function( dat ) {
    if ( !jexjs.isNull( dat ) && !jexjs.isNull(dat.COMMON_HEAD) ) {
        return dat.COMMON_HEAD.CODE;
    }
    return null;
};

/**
 * ajax Error 인경우 ErrorMessage 값을 반환해줍니다.
 * @parameter dat ajax action호출 후 반한된 데이터값
 * @example {"COMMON_HEAD":{"ERROR":true,"MESSAGE":"","CODE":""}}
 */
jexjs.getJexErrorMessage = function( dat ){
    if ( !jexjs.isNull( dat ) && !jexjs.isNull(dat.COMMON_HEAD) ) {
        return dat.COMMON_HEAD.MESSAGE;
    }
    return null;
};

/**
 * 기존 jex2.0 호환위해 사용. jexMobile에서 사용.
 * @param {String} url
 * @returns { jexjs.plugin.ajax }
 */
jexjs.createAjaxUtil = function (url) {
    return jexjs.plugin('ajax', url);
};

/**
 * 공통 ajax값을 setting 합니다. 기존에 이미 설정되어있는 경우 값을 덮어 씌움.
 * @param {Object} settings 공통 ajax 설정 값
 */
jexjs.ajaxSetup = function(settings) {
    if (jexjs.isNull(settings)) {
        return;
    }

    var globalAjax = jexjs.global.plugins.ajax;

    //indicator
    if (typeof settings.indicator === 'object') {
        if ( typeof settings.indicator.show === 'function' && typeof settings.indicator.hide === 'function' ) {
            globalAjax.indicator = settings.indicator;
            delete settings.indicator;
        }
    } else if ( typeof settings.indicator === 'boolean' &&  settings.indicator === false ){
        globalAjax.indicator = settings.indicator;  
        delete settings.indicator;
    }
    
    //settings
    if (typeof settings.prefix === 'string') {
        globalAjax.prefix = settings.prefix;
        delete settings.prefix;
    }
    if (typeof settings.suffix === 'string') {
        globalAjax.suffix = settings.suffix;
        delete settings.suffix;
    }
    if (typeof settings.contextPath === 'string') {
        globalAjax.contextPath = settings.contextPath;
        delete settings.contextPath;
    }
    
    globalAjax.settings = settings;
};

/**
 * 공통 ajax 값을 확장합니다.
 * @param {Object} settings 공통 ajax 설정 값
 */
jexjs.ajaxSetupExtend = function (settings) {
    if (jexjs.isNull(settings)) {
        return;
    }

    var globalAjax = jexjs.global.plugins.ajax;

    //indicator
    if (typeof settings.indicator === 'object') {
        if ( typeof settings.indicator.show === 'function' && typeof settings.indicator.hide === 'function' ) {
            globalAjax.indicator = settings.indicator;
            delete settings.indicator;
        }
    } else if ( typeof settings.indicator === 'boolean' &&  settings.indicator === false ){
        globalAjax.indicator = settings.indicator;  
        delete settings.indicator;
    }
    
    //settings
    if (typeof settings.prefix === 'string') {
        globalAjax.prefix = settings.prefix;
        delete settings.prefix;
    }
    if (typeof settings.suffix === 'string') {
        globalAjax.suffix = settings.suffix;
        delete settings.suffix;
    }
    if (typeof settings.contextPath === 'string') {
        globalAjax.contextPath = settings.contextPath;
        delete settings.contextPath;
    }
    
    jexjs.extend(globalAjax.settings, settings);
};

/**
 * ajaxError : 공통 error 함수를 정의합니다. ajax 호출이 실패하였을 경우 수행됩니다.
 */
jexjs.ajaxError = function( errFn ){
    var globalAjax = jexjs.global.plugins.ajax;
    
    if (!globalAjax.callback) {
        globalAjax.callback = [];
    }

    if (typeof errFn !== 'function') {
        return;
    }
    
    globalAjax.callback.error =  errFn;
};

/**
 * ajaxFilter : ajax호출이 성공적으로 끝난 후에 등록된 필터들을 순서대로 실행한다. <br>
 *      filter는 false를 리턴할 경우에만 종료를 하고 <br>
 *      그 외의 경우 모든 filter를 호출한 후 callback (success) 함수를 실행한다. <br>
 *      false를 리턴할 경우, 공통 에러 처리 혹은 callback (error) 함수를 실행한다. <br>
 *
 * @method addAjaxFilter
 * @param {Function} filter
 * @param {Number} index 필터 추가 위치
 * @example
 *      jexjs.addAjaxFilter(function(data) {
 *          // data는 ajax 호출 후 성공적으로 내려온 값이다.
 *          return false; // 필터를 종료하고 error 처리 실행
 *      });
 */
jexjs.ajaxFilter = function(filter, _index) {
    var globalAjax = jexjs.global.plugins.ajax;

    if (!globalAjax.filters) {
        globalAjax.filters = [];
    }

    if (typeof filter !== 'function') {
        return;
    }

    var index = (typeof _index === 'number') ? _index : globalAjax.filters.length;

    if ( index >= globalAjax.filters.length ) {
        globalAjax.filters.push(filter);
    } else {
        if (index === 0) {
            var result = [];
            result.push(filter);
            globalAjax.filters = result.concat(globalAjax.filters);
        } else {
            var pre = globalAjax.filters.splice(0, index);
            pre.push( filter );

            globalAjax.filters = pre.concat(globalAjax.filters);
        }
    }
};

/**
 * @deprecated
 * @param {Function} filter
 */
jexjs.addAjaxFilter = function(filter) {
    jexjs.debug('    jexjs.addAjaxFilter is deprecated. change method name to `jexjs.ajaxFilter`');
    jexjs.ajaxFilter(filter);
};

/**
 * ajax execute함수를 쏘기전에 호출해주는 전처리 실행함수
 * @param {function} beforeExecute
 */
jexjs.addAjaxBeforeExecute = function( beforeExecute ){
    
    if ( typeof beforeExecute != 'function'){
        return;
    }
    
    var globalAjax = jexjs.global.plugins.ajax;
    if ( !globalAjax.beforeExecutes ){
        globalAjax.beforeExecutes = [];
    }
    
    globalAjax.beforeExecutes.push( beforeExecute );
};

/**
 * global Executor 구현
 */
jexjs.setAjaxExecutor = function ( executor ) {
    var globalAjax = jexjs.global.plugins.ajax;
    if( "function" == typeof executor.execute ) {
        globalAjax.executor = executor;
    }else  {
        jexjs.error("jexjs.plugin.ajax.executor must implements execute function");
    }
};

/* ==================================================================================
 * code manager은 jex framework와 통신하여 code 에 해당하는 값을 얻어 온다. <br />
 *
 * var jexCodeManager = jexjs.plugin("code_manager"); <br />
 *
 * @class jexjs.plugins.code_manager
 * ================================================================================== */
jexjs.plugins.define('code_manager', function() {
    // init static data on global
    if (!jexjs.global.plugins.code_manager.cachedCode) {
        jexjs.global.plugins.code_manager.cachedCode = {};
    }

    if (!jexjs.global.plugins.code_manager.cachedCodeList) {
        jexjs.global.plugins.code_manager.cachedCodeList = {};
    }

    if (!jexjs.global.plugins.code_manager.cachedSimpleCode) {
        jexjs.global.plugins.code_manager.cachedSimpleCode = {};
    }
    
    if (!jexjs.global.plugins.code_manager.settings) {
        jexjs.global.plugins.code_manager.settings = {};
    }
    
    /*
     DV_CD 는 _code.jct 를 호출할 때 어떤 형태의 데이터를 리턴받을지에 대한 코드 값이다.
     jexstudio > 코드 관리에서 등록된 코드 목록을 호출할 때 사용한다.

     1 : "코드 값"           - GROUP, KEY 값과 함께 넘길 경우, { RESULT: "String" } 형태로 데이터를 받는다.
     2 : [ 키, 코드 배열 ]    - GROUP 값과 넘길 경우, { RESULT: [{KEY: "", CODE: ""}, ... ] } 형태로 데이터를 받는다.
     3 : "심플코드 값"        - GROUP, KEY 값과 함께 넘길 경우, { RESULT: "String" } 형태로 데이터를 받는다.
     4 : [ 키, 심플코드 배열 ] - GROUP 값과 넘길 경우, { RESULT: [{KEY: "", CODE: ""}, ... ] } 형태로 데이터를 받는다.
     */
    var DV_CD = {
        "CODE_FROM__GROUP_KEY": 1,
        "CODE_FROM__GROUP": 3,

        "SIMPLE_CODE_FROM__GROUP_KEY": 2,
        "SIMPLE_CODE_FROM__GROUP": 4
    };

    var defaultOrderOption = {
        baseField   : 'KEY', // KEY, CODE, USR
        order       : 'ASC' //  ASC, DESC
    };

    var lastOrder = {
        baseField   : defaultOrderOption.baseField,
        order       : defaultOrderOption.order
    };

    var globalSettings = jexjs.global.plugins.code_manager.settings;
    var cache = (jexjs.isNull( globalSettings.cache )? false : globalSettings.cache);
    
    var cachedCode = jexjs.global.plugins.code_manager.cachedCode;
    var cachedCodeList = jexjs.global.plugins.code_manager.cachedCodeList;
    var cachedSimpleCode = jexjs.global.plugins.code_manager.cachedSimpleCode;

    var code_url = '_code';

    var contextPath = globalSettings.contextPath || "",
    	 urlPrefix = globalSettings.prefix || "",
        urlSuffix = globalSettings.suffix || ".jct";

    /* jexjs.ajax 플러그인의 Executor를 교체할 수 있다. */
    var ajaxDummyExecutor;

    function getCode(cacheData, group, key, dv_cd, orderOpts) {
        var orderBase   = orderOpts.ORDER_BASE || defaultOrderOption.baseField,
            order       = orderOpts.ORDER      || defaultOrderOption.order;

        if (lastOrder.baseField !== orderBase || lastOrder.order !== order) {
            cacheData[group] = undefined;
            lastOrder.baseField     = orderBase;
            lastOrder.order         = order;
        }

        if ( cache ){
            if (key) {
                if (typeof cacheData[group] === 'object' &&
                    typeof cacheData[group][key] !== 'undefined') {
    
                        return cacheData[group][key];
                }
            } else {
                if (typeof cacheData[group] === 'object') {
                    return jexjs.clone(cacheData[group]);
                }
            }
        }

        var jexAjax = jexjs.createAjaxUtil(code_url);
        jexAjax.set('DV_CD', dv_cd);
        jexAjax.set('GROUP', group);
        jexAjax.set('ORDER_BASE', orderBase);
        jexAjax.set('ORDER', order);
        if (key) {
            jexAjax.set('KEY', key);
        }
        
        if (contextPath) {
            jexAjax.setting('contextPath', contextPath);
        }

        if (urlPrefix) {
            jexAjax.setting('prefix', urlPrefix);
        }

        if (urlSuffix) {
            jexAjax.setting('suffix', urlSuffix);
        }

        jexAjax.setting('async', false);

        if (ajaxDummyExecutor) {
            jexAjax.executor( { execute: ajaxDummyExecutor } );
        }

        jexAjax.execute(function(data) {
            if (data.RESULT) {
                var target = { };
                target[group] = { };

                var hasData = false;

                if ( jexjs.isArray(data.RESULT) ) {
                    delete cacheData[group];
                    jexjs.forEach(data.RESULT, function(index, value) {
                        hasData = true;
                        var each = value;
                        target[group][each.KEY] = each.CODE;
                    });
                } else if ( typeof data.RESULT === 'string' && key ) {
                    hasData = true;
                    target[group][key] = data.RESULT;
                }

                if (hasData) {
                    jexjs.extend( cacheData, target );
                }
            }
        });

        if (key) {
            if (typeof cacheData[group] === 'object' &&
                typeof cacheData[group][key] !== 'undefined') {

                return cacheData[group][key];
            }
        } else {
            if (typeof cacheData[group] === 'object') {
                return jexjs.clone(cacheData[group]);
            }
        }

        return null;
    }


    function getCodeList(cacheDataList, group, orderOpts) {
        var orderBase   = orderOpts.ORDER_BASE || defaultOrderOption.baseField,
            order       = orderOpts.ORDER      || defaultOrderOption.order;

        if (lastOrder.baseField !== orderBase || lastOrder.order !== order) {
            cacheDataList[group] = undefined;
            lastOrder.baseField     = orderBase;
            lastOrder.order         = order;
        }

        if ( cache ){
            if (typeof cacheDataList[group] === 'object') {
                return jexjs.clone(cacheDataList[group]);
            }
        }

        var jexAjax = jexjs.createAjaxUtil(code_url);
        jexAjax.set('DV_CD', DV_CD.CODE_FROM__GROUP);
        jexAjax.set('GROUP', group);
        jexAjax.set('ORDER_BASE', orderBase);
        jexAjax.set('ORDER', order);
        if (contextPath) {
            jexAjax.setting('contextPath', contextPath);
        }
        if (urlPrefix) {
            jexAjax.setting('prefix', urlPrefix);
        }
        if (urlSuffix) {
            jexAjax.setting('suffix', urlSuffix);
        }
        jexAjax.setting('async', false);

        if (ajaxDummyExecutor) {
            jexAjax.executor( { execute: ajaxDummyExecutor } );
        }

        jexAjax.execute(function(data) {
            if (data.RESULT) {
                if ( jexjs.isArray(data.RESULT) ) {
                    delete cacheDataList[group];
                    cacheDataList[group] = data.RESULT;

                }
            }
        });

        if (typeof cacheDataList[group] === 'object') {
            return jexjs.clone(cacheDataList[group]);
        }

        return null;
    }

    function getUrl() {
        var result = code_url;

        if (urlPrefix) {
            result = urlPrefix + result;
        }

        if (urlSuffix) {
            result = result + urlSuffix;
        }
        
        if (contextPath) {
            result = contextPath + result;
        }

        return result;
    }
    
    return {
        init: function( orderOpt ) {
            if ( orderOpt ) {
                defaultOrderOption.baseField    = orderOpt.ORDER_BASE || 'KEY';
                defaultOrderOption.order        = orderOpt.ORDER || 'ASC';
                lastOrder.baseField = defaultOrderOption.baseField;
                lastOrder.order = defaultOrderOption.order;
                if ( orderOpt.cache ){
                    cache = orderOpt.cache;
                } 
            }
        },

        /**
         * @method getCode
         * @param {String} group    그룹 코드 값. 필수
         * @param {String} _key      키 코드 값. 선택
         * @returns { Object || String }
         */
        getCode: function(group, _key, _orderOpts) {
            var url = getUrl();

            var key = null,
                orderOpts = { };
            if (typeof _key === 'string') {
                key = _key;
                orderOpts = _orderOpts || {};
            } else if (typeof _key === 'object') {
                orderOpts = _key;
            }

            if (!cachedCode[url]) {
                cachedCode[url] = { };
            }

            var cacheData = cachedCode[url];

            var dv_cd = DV_CD.CODE_FROM__GROUP;
            if (cacheData[group] && key) {
                dv_cd = DV_CD.CODE_FROM__GROUP_KEY;
            }
            return getCode(cacheData, group, key, dv_cd, orderOpts);
        },
        /**
         * group에 대한 코드 목록을 list 형태로 반환합니다.
         * @method getCodeList
         * @param {String} group
         * @param {Object} orderOpts
         */
        getCodeList : function(group, orderOpts) {
            var url = getUrl();

            orderOpts = orderOpts || {};

            if (!cachedCodeList[url]) {
                cachedCodeList[url] = {};
            }

            var cacheDataList = cachedCodeList[url];

            return getCodeList(cacheDataList, group, orderOpts);

        },
        /**
         * @method getSimpleCode
         * @param {String} group    그룹 코드 값. 필수
         * @param {String} _key      키 코드 값. 선택
         * @returns { Object || String }
         */
        getSimpleCode: function(group, _key, _orderOpts) {
            var url = getUrl();

            if (!cachedSimpleCode[url]) {
                cachedSimpleCode[url] = { };
            }

            var key = null,
                orderOpts = {};
            if (typeof _key === 'string') {
                key = _key;
                orderOpts = _orderOpts || {};
            } else if (typeof _key === 'object') {
                orderOpts = _key;
            }

            var cacheData = cachedSimpleCode[url];

            var dv_cd = DV_CD.SIMPLE_CODE_FROM__GROUP;
            if (cacheData[group] && _key) {
                dv_cd = DV_CD.SIMPLE_CODE_FROM__GROUP_KEY;
            }

            return getCode(cacheData, group, _key, dv_cd, orderOpts);
        },

        /**
         * 호출 URL을 변경할 때 사용한다. 기본 url : _code
         * @method url
         * @param _url
         */
        url: function(_url) {
            code_url = _url;
        },
        
        contextPath: function(_contextPath) {
        	contextPath = _contextPath;
        },

        urlPrefix: function(_urlPrefix) {
            urlPrefix = _urlPrefix;
        },

        urlSuffix: function(_urlSuffix) {
            urlSuffix = _urlSuffix;
        },

        dummy: function( executor ) {
            if (typeof executor === 'function') {
                ajaxDummyExecutor = executor;
            }
        },
        removeCache : function(){
            var url = getUrl();
            if (cachedCode[url]) {
                delete cachedCode[url];
            }
            if (cachedSimpleCode[url]) {
                delete cachedSimpleCode[url];
            }
        },
        isCache : function(){
            return cache;
        }
    };
});

/**
 * @param settings { JSONObject }
 * cache : true or false 
 */
jexjs.codeManagerSetup = function( settings ){
    if (jexjs.isNull(settings)) {
        return;
    }
    var codeManagerGrobal = jexjs.global.plugins.code_manager;
    codeManagerGrobal.settings = settings;
};
/**
 * dom 플러그인을 생성한다. <br />
 *
 * var jexDom = jexjs.plugin("dom"); <br />
 *
 * @class jexjs.plugins.dom
 */

jexjs.plugins.define('dom', function() {

	var _OPT = {
		'TYPE' : {
			'JSON' : 'Json',
			'ARRAY' : 'Array'
		}
	};
	    
	var  _opt = {
            TYPE : _OPT.TYPE.JSON  // Json or Array
	};

    function _init ( opt ) {
        jexjs.extend( _opt, opt );
    }
    
	function get(domId, findName) {
		var $scope = jexjs.$("#" + domId);
		if ($scope.length === 0) {
			return;
		}

		if (!findName) {
			return;
		}

		var $find = $scope.find('[name="' + findName + '"]');
		if ($find.length === 0) {
			return;
		}

		var tagName = $find[0].tagName.toLowerCase(), result;

		if ("input" === tagName) {
			var type = $find.attr("type").toLowerCase();

			if ("checkbox" === type) {
				result = [];

				$scope.find('[name="' + findName + '"]:checked').each(function() {
				    
				    if ( _opt.TYPE == _OPT.TYPE.JSON ) {
				        result.push({'value':jexjs.$(this).val()});
				    } else {
				        result.push(jexjs.$(this).val());
				    }
				});

				return result;
			} else if ("radio" === type) {
				return jexjs.null2Void($scope.find('[name="' + findName + '"]:checked').val());
			}

			return $find.val();
		} else if ("select" === tagName) {
			return jexjs.null2Void($find.val());
		} else if ("textarea" === tagName) {
			return $find.val();
		} else {
			return $find.html();
		}
	}

	function getAll(domId) {
		var result = {};

		jexjs.$("#" + domId).find("[name]").each(function() {
			var key = jexjs.$(this).attr("name");

			if (!key) {
				return true;
			}

			if (typeof result[key] === "undefined") {
				result[key] = jexjs.null2Void(get(domId, key));
			}
		});

		return result;
	}

	function set(domId, findName, value) {
		var $scope = jexjs.$("#" + domId);
		if ($scope.length === 0) {
			return;
		}

		if (!findName) {
			return;
		}

		var $find = $scope.find('[name="' + findName + '"]');
		if ($find.length === 0) {
			return;
		}

		var tagName = $find[0].tagName.toLowerCase();

		if ("input" === tagName) {
			var type = $find.attr("type");
			if ("checkbox" === type) {
			    
				if (typeof value === "string") {
					if ("" === value.trim()) {
						$find.each(function() {
							jexjs.$(this)[0].checked = false;
						});
					} else {
						var checkbox = $scope.find('[name="' + findName + '"][value="' + value + '"]')[0];
						if (checkbox) {
							checkbox.checked = true;
						}
					}
				} else if (jexjs.isArray(value)) {
					for (var i = 0; i < value.length; i++) {
						if( value[i].value && "string" === typeof value[i].value ) {
							set(domId, findName, value[i].value);
						}else{
							set(domId, findName, value[i]);
						}
					}
				}
			} else if ("radio" === type) {
				if ("" === value.trim()) {
					$find.each(function() {
						jexjs.$(this)[0].checked = false;
					});
				} else {
					var radio = $scope.find('[name="' + findName + '"][value="' + value + '"]')[0];
					if (radio) {
						radio.checked = true;
					}
				}
			} else {
				$find.val(value);
			}
		} else if ("select" === tagName) {
	        $find.val(value);
		} else if ("textarea" === tagName) {
			$find.val(value);
		} else {
			$find.html( value );
		}
	}

	function setAll(domId, params) {
		for ( var i in params) {
			set(domId, i, params[i]);
		}
	}

	function clear(domId, findName) {
       var $scope = jexjs.$("#" + domId);
        if ($scope.length === 0) {
            return;
        }

        if (!findName) {
            return;
        }

        var $find = $scope.find('[name="' + findName + '"]');
        if ($find.length === 0) {
            return;
        }

        var tagName = $find[0].tagName.toLowerCase();
        if ( "select" === tagName ) {   	//clear 할때, selectbox는 첫 value로 selected 설정
            if ( 0 < $find.children("option").length ){
                set( domId, findName, $find.children("option").eq(0).val() );
                return;
            }
        } else if ( "input" === tagName) {   //clear 할때, radio는 첫 value로 checked 설정
			 var type = $find.attr("type");
			 if( "radio" === type ) {
					if ( 0 < $find.length ){
						set( domId, findName, $find.eq(0).val() );
						return;
					}
			 }
				
        }
        set(domId, findName, "");
	}

	function clearAll(domId) {
		jexjs.$("#" + domId).find("[name]").each(function() {
			clear(domId, jexjs.$(this).attr("name"));
		});
	}
	
	return {
		init : function( opt ) {
		    _init( opt );
		},
		/**
		 * {domId} 하위 태그들 중 name={findName} 인 태그의 값을 리턴한다. <br />
		 * [type=checkbox] 인 경우 Array 형태로 리턴한다.
		 *
		 * @method get
		 * @param {String} domId
		 * @param {String} findName
		 * @returns {String | Array}
		 * @example
		 *      jexjs.plugin("dom").get("my_form", "loginId");     // jex@jexframe.com
		 *      jexjs.plugin("dom").get("more_info", "hobby");     // [ "book", "computer" ]
		 */
		get : function(domId, findName) {
			return get(domId, findName);
		},

		/**
		 * {domId} 하위 태그들 중 name={findName} 인 태그의 값을 설정한다.
		 *
		 * @method set
		 * @param {String} domId
		 * @param {String} findName
		 * @param {String | Array} value [type=checkbox]의 경우 Array 형태의 파라미터도 가능하다.
		 * @example
		 *      jexjs.plugin("dom").set("my_form", "loginId", "jex@jexframe.com");
		 *      jexjs.plugin("dom").set("more_info", "hobby", [ "book", "computer" ]);
		 */
		set : function(domId, findName, value) {
			set(domId, findName, value);
		},

		/**
		 * {domId}의 하위 태그들 중 name 태그를 갖는 태그의 value를 리턴한다. <br />
		 * @method getAll
		 * @param {String} domId
		 * @returns {Object}
		 * @example
		 *      var getAll = jexjs.plugin("dom").getAll("my_form");
		 *      getAll.loginId  // jex@jexframe.com
		 */
		getAll : function(domId) {
			return getAll(domId);
		},

		/**
		 * {domId}의 하위 태그들 중 [name=params의 키] 를 만족하는 태그들의 값을 설정한다.
		 * @method setAll
		 * @param {String} domId
		 * @param {Object} params
		 */
		setAll : function(domId, params) {
			setAll(domId, params);
		},

		/**
		 * {domId}의 하위 태그 중 [name={findName}]을 만족하는 태그의 value를 초기화한다. <br />
		 *   - [type=checkbox, radio] = checked: false <br />
		 *   - [all] = value: ""
		 *
		 * @method clear
		 * @param {String} domId
		 * @param {String} findName
		 */
		clear : function(domId, findName) {
			clear(domId, findName);
		},

		/**
		 * {domId}의 하위 태그 중 [name] 속성을 갖는 모든 태그의 값을 clear 시킨다. <br />
		 * @method clearAll
		 * @param {String} domId
		 */
		clearAll : function(domId) {
			clearAll(domId);
		}
	};
});


jexjs.dom = jexjs.plugin("dom", {
    'TYPE' : "Array"
});
/**
 * 삭제예정. 쓰지 마세요!! 
 * 일단 이미 사용한 경우를 위해 남겨두자!!!
 */

 if ("undefined" == typeof FormData) {
    jexjs.debug('FormData 객체가 존재하지 않는 브라우져에서는 "file_upload" plugin 사용이 불가능합니다.');
 } else {
    jexjs.plugins.define('file_upload', function() {

        var _global = jexjs.global.plugins.file_upload;
        var _checkType = null;  //file type과 data타입은 함께 사용할 수 없으므로 valid check 
        var _parameter = {}; // file외의 일반 text data
        var formData = new FormData();  //실제 ajax 호출시 사용되는 data
        var form_file_upload_id = "jex_file_upload_form";
        var random = new Date().getTime(),
            template_form = '<form method="post" enctype="multipart/form-data" style="position:absolute; top: -1000px; left: -1000px;"></form>',
            template_iframe = '<iframe style="display:none;"></iframe>',
            template_file = '<input type="file" />',
            template_submit = '<input type="submit" value="upload" />';

        var contextPath = _global.contextPath || "",
            prefix = _global.prefix || "",
            suffix = _global.suffix || ".jct",
            url,
            $form,
            $targetFrame,
            files = [];
        var success;
        
        var options = {
                type : "file",     // file : 일반 input type, data : 파일선택화면을 띄우지 않고 data로 입력받은경우.
                multiple : false,  // input type="file" 에서 다건선택가능
                reset:true         // input type="file" 선택시 새로 file 선택하지 않고 추가된파일 계속 가지고있을건지 여부
        };
        
        var events = {
                
        };
        
        if ( _global.options ){
            jexjs.extend( options, _global.options );
        }
        
        function init( _url , option ) {
            
            settings( option );
            
            initDom();

            url = _url;

            $form.attr({
                'action': getUrl( _url ),
                'target': $targetFrame.attr('name')
            });
        }
        
        function settings ( key, value ){
            if ( typeof key === 'object' ){
                for( var k in key){
                    _settings( k, key[k]);
                }
            }else if ( typeof key === 'string'){
                _settings( key, value );
            }
        }
        
        function _settings ( key, value ){
            if ( 'contextPath' === key ){
                contextPath = value;
            }else if ( 'prefix' === key ){
                prefix = value;
            }else if ( 'suffix' === key ){
                suffix = value;
            }
            options[ key ] = value;
        }
        
        function getUrl( _url ){
            var fullUrl = "";
            
            if ( !jexjs.empty( contextPath )){
                fullUrl += contextPath + "/" ;
            }
            if ( !jexjs.empty( prefix )){
                fullUrl += prefix + "/" ;
            }
            
            //id에 .jct 확장자 넘어온경우
            if ( -1 != fullUrl.indexOf(".jct") && ".jct" == suffix) {
                fullUrl +=  _url;
            } else {
                fullUrl +=  _url + suffix;
            }
            
            return fullUrl;
        }

        function initDom() {
            var random = new Date().getTime();
            $form = jexjs.$('#' + form_file_upload_id + "_" + random);
            if ($form.length === 0) {
                $form = jexjs.$(template_form);
                $form.appendTo("body");
            }

            if ($form.find('input[type=submit]').length === 0) {
                $form.append(jexjs.$(template_submit));
            }

            $form.off('submit').on('submit', function(event) {
                var $inputFile = $(jexjs.$(this).find("input[type=file]")[0]);

                if ( "file" == options.type ) {
                    //파일 다건 선택
                    if ( options.multiple ){
                        var _files = files;
                        for( var i = 0; i < _files.length; i++ ){
                            formData.append( $inputFile.attr('name'), _files[i] );
                        }
                    }//파일 단건 선택
                    else{
                        formData.append( $inputFile.attr('name'), $inputFile[0].files[0] );
                    }
                }
                
                //file 객체외의 데이터가 있는 경우 추가
                if ( _parameter ) {
                    for( var key in _parameter ) {
                        if ( "object" == typeof _parameter[key] ) {
                            formData.append(key, JSON.stringify( _parameter[key] ));
                        } else {
                            formData.append(key, _parameter[key] );
                        }
                    }
                }
                
                jQuery.ajax({
                    url: getUrl(url),
                    type: 'POST',
                    data: formData,
                    async: false,
                    cache: false,
                    processData: false,
                    contentType: false,
                    success: function(data, textStatus, jqXHR) {
                        if (typeof success === 'function') {
                            success(data);
                        }
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        jexjs.warn("file_upload plugin:: error :: "+textStatus);
                    }
                });

                return false;
            });

            $targetFrame = jexjs.$(template_iframe);
            $targetFrame.attr('name', 'jex_fileupload_frame');
            $targetFrame.appendTo("body");
        }
        
        function add(name, _callback) {
            
            var $input_file = $form.find('input[name=' + name + ']')[0];
            
            if (typeof $input_file !== 'undefined') {
                $input_file.remove();
            }
                
            $input_file = jexjs.$(template_file)
                .attr({
                    'id': name,
                    'name': name
                });

            if ( options.multiple ){
                $input_file.prop("multiple",true);
            }
            
            $form.append($input_file);
            
            $input_file.on('change', function( e ) {
                var targetFiles = e.target.files || e.dataTransfer.files;
                if ( !jexjs.empty(targetFiles)){
                    for(var k=0; k < targetFiles.length; k++){
                        jexjs.debug("    jexjs.plugin.file_upload : e.files["+k+"]::"+ targetFiles[k].name);
                    }
                }
                
                if ( options.reset ){
                    files = targetFiles;
                }else {
                    for(var i=0; i < targetFiles.length; i++){
                        var isDuplicate = false;
                        for(var j=0; j < files.length; j++){
                            if ( files[j].name == targetFiles[i].name){
                                jexjs.debug("    jexjs.plugin.file_upload : overwrite file::"+ targetFiles[i].name);
                                files[j] = targetFiles[i];
                                isDuplicate = true;
                            }
                        }
                        if ( !isDuplicate ){
                            jexjs.debug("    jexjs.plugin.file_upload : add file::"+ targetFiles[i].name);
                            files.push(targetFiles[i]);
                        }
                    }
                }
                
                if (typeof _callback === "function") {
                    _callback( $input_file[0], jexjs.clone(files) );
                }
            });

            $input_file.click();
        }
        
        function addFormData( name, value ){
            formData.append( name, value );
        }
        
        function _removeFile( orgFileName ) {
            var file, newFiles = [];
            var isRemove = false;
            for ( var i = 0; i < files.length; i++ ){
                file = files[i];
                if ( orgFileName != file.name ){
                    newFiles.push(file);
                }else{
                    isRemove = true;
                }
            }
            files = newFiles;
            if ( isRemove ){
                jexjs.debug("    jexjs.plugin.file_upload : remove file::"+ orgFileName);
                return 1;
            }
            return 0;
        }
        
        function removeFileList(name, orgFileName, _callback ){
            var $input_file = $form.find('input[name=' + name + ']')[0];
            var removeCount = 0;
            if ( "string" == typeof orgFileName ) {
                removeCount =  _removeFile(orgFileName);
            }else if ( jexjs.isArray(orgFileName) ) {
                for(var i=0; i < orgFileName.length; i++){
                    removeCount += _removeFile( orgFileName[i] );
                }
            }
            _callback( $input_file[0], jexjs.clone(files), removeCount );
        }
        
        function upload(_callback) {
            success = _callback;

            $form.find('input[type=submit]').click();
        }

        function setUrl(_url) {
            url = _url;
            $form.attr('action', getUrl(_url) );
        }

        return {
            init: function(_url , option) {
                init(_url, option);
            },
            //일반데이터 추가
            setData : function( key , value ){
                jexjs.extend(_parameter, key, value);
            },
            //파일추가
            add: function(name, fileData ) {
                var type = "file";
                if ( "function" != typeof fileData ) {
                    type = "data";
                    options.type = type;
                }
                
                if ( null === _checkType ) {
                    _checkType = type;
                } else {
                    if ( _checkType != type ) {
                        jexjs.error("    jexjs.plugin.file_upload:: file Type과 data Type을 함께 사용할 수 없습니다. ");
                    }
                }
                
                if ( "function" == typeof fileData ) {  //File 선택하여 추가
                    add(name, fileData);
                } else {    //File Data 추가
                    addFormData(name, fileData);
                }
            },
            //파일삭제
            remove : function( name, fileNameList , callback) {
                removeFileList( name, fileNameList , callback);
            },
            //파일업로드
            upload: function(_callback) {
                upload(_callback);
            },
            url: function(_url) {
                setUrl(_url);
            }
        };
    });
 }
/* ========================================================================
 * jexjs.plugins.form
 * 생성시 기준 element 이하에서 'keydown : enter' 이벤트가 발생할 경우
 * 지정된 element의 지정된 event를 실행시킨다.
 * ======================================================================== */

// auto binding
$(function() {
    $(document.body ).find('[jex-form]').each(function() {
        var $scope = $( this );
        var $target = $scope.find('[jex-submit]');
        var event = $target.attr('jex-submit');

        function isExceptElement( e ) {
            var targetNode = e.target;
            var tagName = targetNode.tagName.toLowerCase() ;
            
            if ( "textarea" == tagName ) {
                return true;
            } else if ( "input" == tagName )  {
                var type = targetNode.getAttribute("type").toLowerCase();
                if ( "submit" == type ) {
                    return true;
                }
            } else if( "button" == tagName ) {
                return true;
            }
            
            return false;
        }
        
        $scope.on('keydown', function(e) {
            var keyCode = e.which || e.keyCode;
            if (keyCode === 13) {
                if ( !isExceptElement( e ) ) {
                    jexjs.debug('    jexjs.plugins.form : jex-submit event 실행');
                    if ($target) {
                        $target.trigger(event);
                        return false;
                    }
                }
            }
        });
    });
});

jexjs.plugins.define('form', function() {
    var $scope,
        $target,
        event;

    var attr = {
        form: 'jex-form',
        submit: 'jex-submit'
    };

    function get$(element) {
        if (typeof element === 'string') {
            if (!element.startsWith('#')) {
                element = '#' + element;
            }

            return jexjs.$( element );
        } else if (element && element instanceof jQuery) {
            return element;
        } else if (element && element instanceof HTMLElement) {
            return jexjs.$( element );
        }
    }

    function isExceptElement( e ) {
        var targetNode = e.target;
        var tagName = targetNode.tagName.toLowerCase() ;
        
        if ( "textarea" == tagName ) {
            return true;
        } else if ( "input" == tagName )  {
            var type = targetNode.getAttribute("type").toLowerCase();
            if ( "button" == type ) {
                return true;
            }
        } else if( "button" == tagName ) {
            return true;
        }
        
        return false;
    }
    
    function listen() {
        $scope.on('keydown', function(e) {
            var keyCode = e.which || e.keyCode;

            if (keyCode === 13) {
                if ( !isExceptElement( e ) ) {
                    jexjs.debug('    jexjs.plugins.form : jex-submit event 실행');
                    if ($target) {
                        $target.trigger(event);
                        return false;
                    }
                }
            }
        });
    }

    return {
        init: function(element) {
            $scope = get$(element);

            if (!$scope) {
                jexjs.error('form 플러그인은 `elementId | HTMLElement | jQueryElement` 중 하나를 파라미터로 입력해야 합니다.');
            }

            if ($scope.attr( attr.form )) {
                var $submitElement = $scope.find('[' + attr.submit + ']');
                var _event = $submitElement.attr( attr.submit );

                listen();

                $target = $submitElement;
                event = _event;
            }
        },
        setSubmit: function(_element, _event) {
            var _$target = get$(_element);

            if (!_$target) {
                jexjs.error('jexjs.plugins.form : setSubmit시 대상이 될 수 있는 `elementId | HTMLElement | jQueryElement`중 하나를 파라미터로 입력해야 합니다.');
            }

            if (typeof _event !== 'string') {
                jexjs.error('jexjs.plugins.form : setSubmit시 이벤트명은 문자열로 입력해야 합니다.');
            }

            $target = _$target;
            event = _event;

            listen();
        }
    };
});


/* ==================================================================================
 * indicator 플러그인은 사용자에게 '현재 ~ 작업을 진행 중' 임을 나타낼 때 사용한다.
 * 이를 나타내기 위해서 기본적으로 메인 화면을 덮는 `배경` 위에 진행 중을 표시하는 `이미지`로 구성해서 사용한다.
 * #jexjs-indicator-wrap
 *   .jexjs-indicator
 *      .jexjs-indicator-bg
 *          .jexjs-indicator-img
 *
 * indicator 는 document.body 마다 하나씩만 존재할 수 있다. 즉, 최초 생성 후에는 제거하지 않는다.
 *
 * var jexIndicator = jexjs.plugin('indicator');
 * ================================================================================== */

jexjs.plugins.define('indicator', [ 'template' ], function($template) {

    var id = {
        'wrap' : 'jexjs-indicator-wrap'
    };
    
    var name = {
        'theme': {
            'def'   : 'jexjs-indicator-theme-default',
            'modal'     : 'jexjs-indicator-theme-modal',
            'user'  :   'jexjs-indicator-theme-user'
        }
    };

    var cssClass = {    //기본 디자인
        wrapper : '',
        bg: 'jexjs-indicator',
        imgBg: 'jexjs-indicator-bg',
        img: 'jexjs-indicator-img',
        modal: 'modal',
        active : 'active'
    };
    
    var targetCssClass = {  //target을 입력받아 특정 영역에 indicator를 사용할때의 기본 디자인
        bg: 'jexjs-indicator-target',
        imgBg: 'jexjs-indicator-bg-target'
    };

    var template = {
        wrapper: '<div id="#{ id }" class="#{ classWrapper }"></div>',
        indicator: '<div name="#{ themeName }" class="#{ classBg }"><div class="#{ classImgBg }"><span class="#{ classImg }"></span></div></div>'
    };

    var options = {
        scopeWindow: null,
        modal: false,
        user : false,
        target : null   //기본적으로는 indicator wrap 이 body에 추가되지만, target이 있는 경우는 target에 indicator가 추가.
                        //위치의 기준이 되는 태그이기때문에, target은 "position:relative"로 설정하여야 한다. 그리고 width, hegith.
    };
    
    var fn = {
        show : function( $indicator ){
            $indicator.addClass( cssClass.active );
        },
        hide : function( $indicator){
            $indicator.removeClass( cssClass.active );
        }
    };

    var $indicator;

    function init() {
        var scope = options.scopeWindow || jexjs.getRootParent() || window;
        var wrapper = null;

        // target이 없는 경우.
        if ( jexjs.isNull(options.target) ) {
            wrapper = scope.document.getElementById(id.wrap);
            
            //wrapper가 append 되어있지 않으면, 생성.
            if (jexjs.isNull(wrapper)) {
                jexjs.debug('    jexjs.plugin.indicator: init indicator-wrapper');

                var wrapperTemplate = $template.render(template.wrapper, { 
                    id: id.wrap,
                    classWrapper : cssClass.wrapper
                }),
                    $wrapper = jexjs.$(wrapperTemplate);
                jexjs.$(scope.document.body).append($wrapper);
                
                wrapper = $wrapper[0];
            }
        }// target id가 있는 경우.
        else {
            wrapper = jexjs._getHtmlElement( options.target, scope );
            cssClass = jexjs.extend( cssClass, targetCssClass );
        }

        var themeName = name.theme.def;
        if ( options.user ){
            themeName = name.theme.user;
        }else if (options.modal) {
            themeName = name.theme.modal;
        }

        var $tmpIndicator = jexjs.$(wrapper).find('[ name="'+ themeName +'"]');
        if ($tmpIndicator.length > 0) {
            $indicator = $tmpIndicator;
        } else {
            
            var html = $template.render(template.indicator, {
                themeName: themeName,
                classBg: cssClass.bg,
                classImgBg: cssClass.imgBg,
                classImg: cssClass.img
            });

            $indicator = jexjs.$( html );

            if (options.modal) {
                $indicator.addClass( cssClass.modal );
            }
            jexjs.$(wrapper).append($indicator);
        }
    }
    function show() {
        fn.show( $indicator );
    }

    function hide() {
        fn.hide( $indicator );
    }

    return {
        init: function(_opts) {
            if (_opts) {
                
                if (typeof _opts.css === 'object') {
                    options.user = true;    //사용자 정의 class
                    cssClass = jexjs.extend( cssClass, _opts.css );
                    delete _opts.css;
                }
                
                if ( _opts.fn ){
                    if (typeof _opts.fn.show === 'function') {
                        fn.show = _opts.fn.show;
                    }
                    if (typeof _opts.fn.hide === 'function') {
                        fn.hide = _opts.fn.hide;
                    }
                    delete _opts.fn;
                }
                
                if (typeof _opts.scopeWindow === 'object') {
                    options.scopeWindow = _opts.scopeWindow;
                    delete _opts.scopeWindow;
                }
                
                options = jexjs.extend( options, _opts );
                
                if ( _opts.target ) {
                    id.wrap = id.wrap + "_" + jexjs._getElementId(_opts.target);
                }
            }
            init();
        },
        show: function() {
            show();
        },
        hide: function() {
            hide();
        }
    };
});
/* ========================================================================
 * jexjs.plugins.input
 * 사용자의 키보드 입력에 대한 제어를 담당하는 플러그인
 * ======================================================================== */

jexjs.plugins.define('input', function() {
    var rules = jexjs.global.plugins.input.rules || {};

    var inputAttr = 'jex-input';

    function listen( $scope ) {
        if ( jexjs.empty($scope.attr(inputAttr)) ) {
            $scope.find('[' + inputAttr + ']').each(function() {
                listen( jexjs.$(this) );
            });
        } else {
            var checkList = ($scope.attr( inputAttr ) || '').split(';');
            jexjs.forEach(checkList, function(index, value) {
                var each = jexjs.trim(value);

                if (jexjs.empty(each)) {
                    return true;
                }

                var fn = rules[ each ];

                if (!fn) {
                    jexjs.error(' [ input ] 등록되지 않은 rule 입니다. ' + each);
                }

                fn( $scope );
            });
        }
    }

    return {
        addRule: function( name, fn ) {
            rules[name] = fn;
        },
        listen: function( $scope ) {
            listen( $scope );
        },
        rules: rules
    };
}, true);


/* ==================================================================================
 * ml 플러그인은 페이지에서 다국어를 사용하는 경우 필요한 플러그인이다.
 *
 * jexjs.plugin('ml');
 * ================================================================================== */

jexjs.plugins.define('ml', [ 'indicator', 'ajax','template', 'queue', 'code_manager' ], function( $indicator, $ajax, $template, $queue, $codeManager ) {
    
    var _globalMl =  jexjs.global.plugins.ml,
    _viewId = (function(){
                var viewId = null;
                var pathName = window.location.pathname || window.location.href;
                var matchList = pathName.match(/(\w)+.act/g);
                if ( matchList && matchList.length == 1 ){
                    viewId = matchList[0].replace(".act","");
                    return viewId;
                }else {
                    jexjs.debug("    jexjs.plugin.ml : view Id 추출 실패!! "+ pathName);
                }
            })();
    
    var _CONST = {
            TRANSLATE_MODE_Y : true,    //dom 번역을 한다.
            TRANSLATE_MODE_N : false    //dom 번역없이 param 값에 대한 변경만
    };
    
    var _settings = {
            isUseHeader : true,
            isUseBody : true,
            contextPath : null,
            prefix : null,
            url : "jexMLang",
            suffix : "",
            codeManager : $codeManager,
            isTranslateLocal : false,    //페이지 최초 road시 loca언어인경우에는 번역할필요가 없으나 HTML parameter를 사용하면 필요하여 추가 ( isTranslateServer : false 일때 )
            isTranslateServer : false    //페이지 최초 road시 번역된 Html 이 내려오는경우 true, 번역되지 않은 data가 내려오는 경우 false
    };
    
    var _FUNC = {
            'beforeInit' : function( info ){
            },
            'afterInit' : function( info ){
            },
            'beforeChange' : function( info ){
                info.indicator.show();
            },
            'afterChange' : function( info ){
                info.indicator.hide();
            },
            //{ 'VIEW_ID':viewId, 'ML_ID': mlKey, 'ML_TP':_ML_TP.HTML }
            'isInsertMlKey' : function(){
                return true;
            },
            //{ 'VIEW_ID':viewId, 'ML_ID': mlKey, 'ML_TP':_ML_TP.HTML }
            'setInsertViewId' : function(){
                return _viewId;
            }
    };
    var _ML_ATTR = "data-jex-ml" ,
        _ML_ATTR_VIEW_ID = "data-jex-view",
        _ML_ATTR_NOMAL_VIEW_ID = "data-jex-nomal-view", //사용하지 말기. jex-view와 동일한처리
        _ML_ATTR_OPT_DYNAMIC = "data-jex-ml-opt-dynamic",
        _ML_ATTR_PARAM = "data-jex-param",
        _ML_ATTR_META_VIEW_ID = "data-jex-ml-id",   //서버번역일때, script에서 다국어 data를 가져오는 view id를 알려주기위해 함께 내려줌.
        _ML_TP = {
            HTML : "V",
            JS   : "J"
        },
        _ML_ACTION = {
            LOAD: 'LOAD',       //해당 언어에 대한 다국어 데이터를 반환하며, 쿠키에 언어코드는 set 하지 않는다.
            SET : 'SET',        //해당 언어에 대한 다국어 데이터를 반환하며, 쿠키에 언어코드도 set
            INSERT : 'INSERT'   //page에 대한 다국어 key insert
        },
        _ML_ATTR_CODE_GROUP = "data-jex-code-group",
        _ML_ATTR_CODE_KEY = "data-jex-code-key",
        _ML_ATTR_CODE_TEPLATE = "data-jex-code-tpl",
        _IS_ML_DEBUG = false,
        _IS_LOADED = false,  //local단어일때는 ajax호출하지 않음. false인경우는 한번도 다국어정보를 read 하지 않은 상태
        _CACHED_ML_DATA = {},
        _LOCAL_JS_ML_DATA = {},
        _LOAD_VIEW_LIST = [];
    
    //local 다국어 정보를 서버에서 주는 경우는 이미 local 다국어 정보를 가지고 있음.
    var _LOCAL_HTML_ML_DATA = null;
    try{
        _LOCAL_HTML_ML_DATA  = htmlOriginalValues;
        jexjs.debug("    jexjs.plugin.ml : Local Data from Server : "+ JSON.stringify(_LOCAL_HTML_ML_DATA));
    }catch (e){
        _LOCAL_HTML_ML_DATA = {};
    }
        
    $indicator = jexjs.plugin("indicator",{ modal : true});
    
    if ( _globalMl.settings ){
        jexjs.extend( _settings, _globalMl.settings);
    }
    
    if ( _globalMl.event ){
        jexjs.extend( _FUNC, _globalMl.func );
    }
    
    function setLocalLang( localLang ){
        jexjs.cookie.set("JEX_LOCAL_LANG", localLang);
    }
    
    function setLang ( lang ){
        jexjs.cookie.set("JEX_LANG", lang);
    }
    
    /**
     * 초기화
     */
    function _init( settings ){

        _setSettings( settings );
        
        //meta 태그에 view id가 있는경우
        var headNodes = document.head || document.getElementsByTagName("head")[0]; // ie8 document.head 없음.
        var metaNode = headNodes.querySelector("meta["+_ML_ATTR_META_VIEW_ID+"]");
        if ( null !== metaNode ) {
            _viewId = metaNode.getAttribute( _ML_ATTR_META_VIEW_ID );
            jexjs.debug("    jexjs.plugin.ml : init : meta tag view id load ::"+ _viewId);
        }
        
        try {
            jexjs.debug("    jexjs.plugin.ml : init : isUseHeader :" + _settings.isUseHeader);
            jexjs.debug("    jexjs.plugin.ml : init : isUseBody :" + _settings.isUseBody);
            jexjs.debug("    jexjs.plugin.ml : init : contextPath :" + _settings.contextPath);
            jexjs.debug("    jexjs.plugin.ml : init : prefix :" + _settings.prefix);
            jexjs.debug("    jexjs.plugin.ml : init : url :" + _settings.url);
            jexjs.debug("    jexjs.plugin.ml : init : suffix :" + _settings.suffix);
            jexjs.debug("    jexjs.plugin.ml : init : isTranslateLocal :" + _settings.isTranslateLocal);
            jexjs.debug("    jexjs.plugin.ml : init : isTranslateServer :" + _settings.isTranslateServer);
        } catch(e) {
            
        }
        //  Dom Element에서 local 단어 추출하여 저장
        //  - 서버에서 번역을 해주지 않는 경우.
        //  - 서버에서 번역을 해주는 모드인데, local 언어인경우는 local 단어 추출
        if ( !_settings.isTranslateServer || ( _settings.isTranslateServer && jexjs.getLang() == jexjs.getLocalLang()) ){
            //local 단어 load
            _saveLocalMl();
        }
        //local단어가 아닌경우만 해당 언어의 다국어정보 load
        if ( jexjs.getLang() != jexjs.getLocalLang() ) {
            _loadViewData();
        }
        //TODO 초기설정과 chagne를 분리하게되면 _initChange를 public 함수로 변경하면됨.
        //현재 언어로 번역
        _initChange();
    }
    
    function _initChange() {
        
        if ( "function" == typeof _FUNC.beforeInit){
            _FUNC.beforeInit.call(undefined,  {
                'LANG' : jexjs.getLang(),
                'indicator' : $indicator
            });
        }
        
        function _afterInitFn() {
            if ( "function" == typeof _FUNC.afterInit ) {
                _FUNC.afterInit.call(undefined , {
                        'LANG' : jexjs.getLang(),
                        'indicator' : $indicator
                });
            }
        }
       
        // 서버에서 번역을 해주는 경우, param 만 값 치환
        if ( _settings.isTranslateServer ){
            _changeDom( _CONST.TRANSLATE_MODE_N, jexjs.getLang(), _afterInitFn );
        }
        // 서버에서 번역을 해주지 않는 경우
        else {
            if ( !jexjs.empty(_CACHED_ML_DATA) ){   //local언어가 아닌경우 해당언어로 dom 변경
                _changeDom( _CONST.TRANSLATE_MODE_Y, jexjs.getLang(), _afterInitFn );
            }else{  // local 단어 인경우
                //html에 parameter 를 사용하는 경우는 local단어인경우도 변환작업 필요.
                if( _settings.isTranslateLocal ){
                    _changeDom( _CONST.TRANSLATE_MODE_N, jexjs.getLang(), _afterInitFn );
                }else{
                    _afterInitFn();
                }
            }
        }
    }
    
    //settings
    function _setSettings( settings ){
        var lang = jexjs.getLang();
        var localLang = jexjs.getLocalLang();
        
        // local단어와 기본언어 단어가 쿠키에없거나 parameter에 없으면, 기본값은 KO;
        if ( jexjs.empty(lang)){
            if( settings && settings.LANG ){
                setLang( settings.LANG);
            }else{
                setLang("KO");
            }
        }
        if ( jexjs.empty(localLang) ){
            if( settings && settings.LOCAL_LANG ){
                setLocalLang( settings.LOCAL_LANG);
            }else{
                setLocalLang("KO");
            }
        }
        
        if ( settings ){
            if ( settings.jexFunction ){
                var jexFunction = settings.jexFunction;
                for(var fnNm in jexFunction){
                    if ( "function" == typeof jexFunction[fnNm]){
                        _FUNC[fnNm] = jexFunction[fnNm];
                    }
                }
                delete settings.jexFunction;
            }else if (settings.LANG){
                delete settings.LANG;
            }else if (settings.LOCAL_LANG){
                delete settings.LOCAL_LANG;
            }
        }
        
        jexjs.extend( _settings, settings );
    }
    
    //Dom Element의 text 정보를 저장
    function _saveLocalMl(){
        
        if ( _settings.isUseHeader ){
            try{
                var headNodes = document.head || document.getElementsByTagName("head")[0]; // ie8 document.head 없음.
                var localHeadNodes = headNodes.cloneNode(true);
                _readRocalMl( localHeadNodes.childNodes );
            }catch(e){
                jexjs.debug("    jexjs.plugin.ml : _saveLocalMl read head error");
            }
        }
        
        if ( _settings.isUseBody ){
            var bodyNodes = document.body,
            localBodyNodes = bodyNodes.cloneNode(true);
            _readRocalMl( localBodyNodes.childNodes );
        }
    }
    
    //local 단어정보를 메모리에 저장
    function _readRocalMl( nodes ){
        var node = null,
        mlAttrNm = null,
        mlAttrValue = null,
        subAttr = null,
        mlValue = null;
        for(var i=0, len = nodes.length; i < len; i++){
            node = nodes[i];
            if ( 1 == node.nodeType ){  //element 인경우만 처리
                if ( node.hasChildNodes() ){
                    _readRocalMl( node.childNodes );
                }
                for(var j=0, atts = node.attributes, attsLen = atts.length; j < attsLen; j++){
                    mlAttrNm = atts[j].name;
                    mlAttrValue = atts[j].value;

                    if( "" === mlAttrValue.trim() ){    //다국어 key 가 공백이면 무시
                        continue;
                    }
                    
                    if ( mlAttrNm == _ML_ATTR ) {   //다국어 key
                        mlValue = node.innerHTML;
                        if ( jexjs.getLocalLang() == jexjs.getLang() ){    //local언어인경우 local단어 없으면, ajax 호출
                            if ( "" === mlValue.trim() ){
                                var word = getHtmlMlData( null, mlAttrValue, jexjs.getLang() );
                                if (jexjs.empty(word)){
                                    jexjs.debug("    jexjs.plugin.ml : _readRocalMl : "+ mlAttrValue +" 다국어 key의 local단어가 없습니다. 성능개선을 위해 local단어를 추가해주세요.");
                                    _loadViewData();
                                }
                            }
                        }
                        _LOCAL_HTML_ML_DATA[ mlAttrValue ] = node.innerHTML;
                    } else if( _ML_ATTR_OPT_DYNAMIC != mlAttrNm && mlAttrNm.startsWith( _ML_ATTR ) ) {   //attribute 다국어 key
                        subAttr = mlAttrNm.substr(_ML_ATTR.length + 1);
                        _LOCAL_HTML_ML_DATA[ mlAttrValue ] = node.getAttribute(subAttr);
                    }
                }
            }
        }
    }
    
    // domId 나 html contents를 parameter로 받아 다국어 번역된 contents를 return 해 줍니다.
    // display 언어가 local단어와 동일하면 번역하지 않습니다.
    function _translateHtml( p_contents, option ){
        var contents;
        var newContents;
        var async = option.async;
        
        //sync 인경우만 clone 하여 사용
        if ( !async ) {
            if ( jexjs.isNull( p_contents.childNodes ) ){
                newContents = jexjs.$(p_contents).clone(true);
            }else{
                newContents = jexjs.$(p_contents).clone(true)[0];
            }
        }else{
            newContents = p_contents;
        }
        
        if ( jexjs.isNull( newContents.childNodes ) ){
            _readRocalMl( newContents );
            //local언어가 아닌경우
            if ( jexjs.getLocalLang() != jexjs.getLang() ){
                _changeDomNodes( _CONST.TRANSLATE_MODE_Y, newContents , jexjs.getLang() );
            }//local언어인경우
            else{
                if ( _settings.isTranslateLocal ){
                    _changeDomNodes( _CONST.TRANSLATE_MODE_Y, newContents , jexjs.getLang() );
                }
            }
        }else{
            _readRocalMl( newContents.childNodes );
            //local언어가 아닌경우
            if ( jexjs.getLocalLang() != jexjs.getLang() ){
                _changeDomNodes( _CONST.TRANSLATE_MODE_Y, newContents.childNodes , jexjs.getLang() );
            }//local언어인경
            else{
                if ( _settings.isTranslateLocal ){
                    _changeDomNodes( _CONST.TRANSLATE_MODE_Y, newContents.childNodes , jexjs.getLang() );
                }
            }
        }
        return newContents;
    }
    
    //언어변경 이벤트 발생시
    function _change( lang, opt ){

        var param = {
                'LANG' :lang,
                'indicator' : $indicator
        };
        
        if ( "function" == typeof _FUNC.beforeChange ){
            _FUNC.beforeChange.call(undefined, param);
        }
        
        function fn(){
            var localLang = jexjs.getLocalLang();
            
            if ( localLang != lang && jexjs.empty( _CACHED_ML_DATA[ lang ] ) ){
                _loadViewData( lang );
                if ( 0 < _LOAD_VIEW_LIST.length){
                    for(var i=0 ; i < _LOAD_VIEW_LIST.length; i++){ // 다른 load view가 load 된적이 있는 경우는 언어변경시에도 함께 load
                        _addLoadView(_LOAD_VIEW_LIST[i]);
                    }
                }
            }else{
                setLang( lang );    //이미 load된 언어인경우 언어정보만 쿠키에 저장
            }
            _changeDom( _CONST.TRANSLATE_MODE_Y, lang, function(){
                jexjs.loader.reload();
                if ( "function" == typeof _FUNC.afterChange ){
                    _FUNC.afterChange.call(undefined , param);
                }
            });
        }
        
        if ( opt && opt.delay ){
            setTimeout( fn , opt.delay );
        }else{
            fn();
        }
    }
    
    //언어코드에 대한 정보로 Dom 변경
    function _changeDom( isTranslate, lang, callback ){
          if ( _settings.isUseHeader ){
              var headNodes = document.head || document.getElementsByTagName("head")[0]; // ie8 document.heade 없음.
              _changeDomNodes( isTranslate, headNodes.childNodes , lang );
          }
        
          if ( _settings.isUseBody ){
              var bodyNodes = document.body;
              _changeDomNodes( isTranslate, bodyNodes.childNodes, lang );
          }
              
          if ( "function" == typeof callback ){
              callback();
          }
//        var headNodes, newHeadNodes, bodyNodes, newBodyNodes;
//        
//        //ie8 인경우 
//        jexjs.debug("jexjs.plugin.ml [ getHtmlMlData ] : isMsie=" +jexjs.getBrowser().msie+" , version="+ jexjs.getBrowser().version );
//        if ( jexjs.getBrowser().msie && "8.0" == jexjs.getBrowser().version ){
//            if ( _settings.isUseHeader ){
//                headNodes = document.head || document.getElementsByTagName("head")[0]; // ie8 document.heade 없음.
//                _changeDomNodes( headNodes.childNodes , lang );
//            }
//            if ( _settings.isUseBody ){
//                bodyNodes = document.body;
//                _changeDomNodes( bodyNodes.childNodes, lang );
//            }
//        }
//        //ie8 외의 경우
//        else {
//            if ( _settings.isUseHeader ){
//                headNodes = document.head || document.getElementsByTagName("head")[0]; // ie8 document.heade 없음.
//                newHeadNodes = jexjs.$("head").clone(true)[0];
//                _changeDomNodes( newHeadNodes.childNodes , lang );
//            }
//            if ( _settings.isUseBody ){
//                bodyNodes = document.body;
//                newBodyNodes = jexjs.$("body").clone(true)[0];
//                _changeDomNodes( newBodyNodes.childNodes, lang );
//            }
//            if ( _settings.isUseHeader ){
//                headNodes.parentNode.replaceChild(newHeadNodes, headNodes);
//            }
//            if ( _settings.isUseBody ){
//                bodyNodes.parentNode.replaceChild(newBodyNodes, bodyNodes);
//            }
//        }
    }
    
    function _changeDomNodes( isTranslate, newNodes, lang , parentCodeGroup){

        var node = null,
        attrNm = null,
        attrValue = null,
        subAttr = null,
        insertViewId = null,
        isDynamic = null,
        codeManager = _settings.codeManager,
        codeTemplate = null,
        codeGroup = parentCodeGroup,
        mlWord = null,
        params = {};
        
        for(var i=0, len = newNodes.length; i < len; i++){
            node = newNodes[i];
            if ( 1 == node.nodeType ){  //element 인경우만 처리
                
                //view Id
                if ( node.hasAttribute( _ML_ATTR_VIEW_ID )){
                    insertViewId = node.getAttribute( _ML_ATTR_VIEW_ID );
                } else if ( node.hasAttribute( _ML_ATTR_NOMAL_VIEW_ID )){   //사용하지 말것. view id와 동일한처리
                    insertViewId = node.getAttribute( _ML_ATTR_NOMAL_VIEW_ID );
                }else{
                    insertViewId = null;
                }
                
                if ( isTranslate ) {    // 번역이 필요한 경우만 필요
                    //codeGroup 있는 경우
                    if ( node.hasAttribute( _ML_ATTR_CODE_GROUP ) ){
                        codeGroup = codeManager.getCode(node.getAttribute( _ML_ATTR_CODE_GROUP ));
                    }
                    
                    //code template 확인
                    if ( node.hasAttribute( _ML_ATTR_CODE_TEPLATE )){
                        codeTemplate = node.getAttribute( _ML_ATTR_CODE_TEPLATE );
                    }
                }
                //auto insert 여부 확인
                if ( node.hasAttribute( _ML_ATTR_OPT_DYNAMIC )){
                    isDynamic = ( "true" == node.getAttribute( _ML_ATTR_OPT_DYNAMIC ) ? true : false );
                }
                
                for(var j=0, atts = node.attributes, attsLen = atts.length; j < attsLen; j++){
                    attrNm = atts[j].name;
                    attrValue = atts[j].value;
                    
                    if ( "" === attrValue.trim() ) continue;    //다국어 key에 대한 값이 없는 경우 무시
                    
                    if ( attrNm == _ML_ATTR ) { //다국어 key
                        if ( node.hasAttribute( _ML_ATTR_PARAM ) ){
                            params = node.getAttribute( _ML_ATTR_PARAM );
                            if ( jexjs.isJSONExp( params ) ){
                                params = JSON.parse( params );
                            }else{
                                params = {};
                            }
                        }
                        mlWord = getHtmlMlData( insertViewId, attrValue , lang, isDynamic, params );
                        
                        if ( isTranslate || ( !isTranslate && !jexjs.empty(params) ) ) {    // 번역을 하지 않아도 되는 경우는 param이 있는 경우만 다시 변경
                            node.innerHTML = mlWord;
                        }
                    }
                    else if( _ML_ATTR_OPT_DYNAMIC != attrNm && attrNm.startsWith( _ML_ATTR ) ) { //attribute 다국어 key
                        subAttr = attrNm.substr( _ML_ATTR.length + 1);
                        if ( node.hasAttribute( _ML_ATTR_PARAM +"-" + subAttr ) ){
                            params = node.getAttribute( _ML_ATTR_PARAM +"-" + subAttr );
                            if ( jexjs.isJSONExp( params ) ){
                                params = JSON.parse( params );
                            }else{
                                params = {};
                            }
                        }
                        
                        mlWord = getHtmlMlData( insertViewId, attrValue , lang, isDynamic, params );
                        
                        if ( isTranslate || ( !isTranslate && !jexjs.empty(params) ) ) {    // 번역을 하지 않아도 되는 경우는 param이 있는 경우만 다시 변경
                            node.setAttribute(subAttr, mlWord);
                        }
                    }else if ( isTranslate && attrNm == _ML_ATTR_CODE_KEY ){  // code key
                        if ( codeGroup ){
                            if ( codeTemplate ){
                                var codeData = { 
                                     'KEY' : attrValue,
                                    'CODE': codeGroup[attrValue]
                                };
                                setNodeData( node, $template.render(codeTemplate, codeData ));
                            }else{
                                setNodeData( node, codeGroup[attrValue]);
                            }
                        }
                    }
                }
                
                if ( node.hasChildNodes() ){
                    _changeDomNodes( isTranslate, node.childNodes, lang, codeGroup );
                }
            }
        }
    }
    
    //
    function getNodeData ( node ){
        if( "input" == node.tagName.toLowerCase() && "text" == node.getAttribute("type")){
            return node.value;
        }else{
            return node.innerHTML;
        }
    }
    
    //코드인경우 사용
    function setNodeData ( node, value ){
        if( "input" == node.tagName.toLowerCase() && "text" == node.getAttribute("type")){
            node.value = value;
        }else{
            node.innerHTML = value;
        }
    }
    
    /**
     * html local key 를 가져옵니다.
     */
    function _getHtmlLocalData( key ){
        return _LOCAL_HTML_ML_DATA[ key ];
    }
    
    /**
     * HTML 캐시된 단어를 가져옵니다.
     * LANG 단어 > 사전의 LOCAL_LANG의 단어
     */
    function _getHtmlCachedData( key, lang ){
        var mlData = _CACHED_ML_DATA[lang];
        var htmlData = {};
        
        if ( mlData &&  mlData[_ML_TP.HTML] ) {
            htmlData = mlData[_ML_TP.HTML];
            if (htmlData[key]) {
                return htmlData[key];
            }
        }
        return null;
    }
    
    /**
     * javascript local단어를 저장합니다.
     */
    function _setJsLocalData( key, localWrd ){
        _LOCAL_JS_ML_DATA[ key ] = localWrd;
        jexjs.debug("    jexjs.plugin.ml : setJsLocalData :" + JSON.stringify(_LOCAL_JS_ML_DATA));
    }
    
    /**
     * javascript local단어를 가져옵니다.
     */
    function _getJsLocalData( key ){
        return _LOCAL_JS_ML_DATA[ key ];
    }
        
    /**
     * javascript cacheed된 data를 가져옵니다.
     * LANG 단어 > 사전의 LOCAL_LANG의 단어
     */
    function _getJsCachedData( key, lang){
        var mlData = _CACHED_ML_DATA[lang];
        var jsData = {};
        if ( mlData && mlData[_ML_TP.JS] ) {
            jsData = mlData[_ML_TP.JS];
            if (jsData[key]) {
                return jsData[key];
            }
        }
        return null;
    }
    
    /**
     * key에 대한 HTML data 반환
     * local언어인경우 local 사용
     * 그외의 언어인경우
     * HTML LANG 사전단어 > HTML LOCAL 단어 > HTML LOCAL_LANG에 대한 사전단어 > JS LANG 사전단어 > JS LOCAL 단어 > JS LOCAL_LANG에 대한 사전단어
     */
    function getHtmlMlData ( insertViewId, mlKey, lang, isDynamic, params ) {
        
        var localLang = jexjs.getLocalLang();
        insertViewId = insertViewId || _FUNC.setInsertViewId.call(undefined, { 'ML_ID': mlKey, 'ML_TP':_ML_TP.HTML }) || _viewId; 
        var localWrd = _getHtmlLocalData( mlKey );
        var word = null;
        var mlDataOfLang = _CACHED_ML_DATA[ lang ];
        
        if ( jexjs.isNull( mlDataOfLang ) && localLang != lang ) {
            jexjs.debug("    jexjs.plugin.ml : getHtmlMlData :" + lang +" 언어가 load 되어있지 않습니다.");
        }
        
        word  = _getHtmlCachedData( mlKey, lang ) || _getHtmlCachedData( mlKey, localLang ) || _getJsCachedData( mlKey, lang ) || _getJsCachedData( mlKey, localLang ) ;
        
        //다국어 정보를 load 했지만, 다국어 ID가 없는 경우 id insert.
        //일단 dynamic attribute 있는 경우에는 insert 안함.
        if ( _IS_LOADED && jexjs.isNull( word ) ){
            var isInsertMlKey = ( !jexjs.isNull(isDynamic)? !isDynamic : _FUNC.isInsertMlKey.call(undefined, { 'VIEW_ID':insertViewId, 'ML_ID': mlKey, 'ML_TP':_ML_TP.HTML } ));
            if ( isInsertMlKey ){
                _insertMlKey( insertViewId, _ML_TP.HTML, mlKey, localWrd, lang, isDynamic );
            }else{
                jexjs.debug("    jexjs.plugin.ml : getHtmlMlData : viewId=" +insertViewId+" ,mlkey="+ mlKey+" , localwrd="+localWrd+" 를 db에 insert 요청안함");
            }
        }
        
        // local 언어인경우 HTML에 등록된 단어 사용, 없는 경우 사전의 local단어 , js local data
        if( lang == localLang ){
             word = _getHtmlLocalData( mlKey ) || _getHtmlCachedData( mlKey, localLang ) || _getJsLocalData( mlKey ) || _getJsCachedData( mlKey, localLang );
        }
        // local 언어가 아닌경우, 해당언어에 등록된 단어 반환. but, 없는경우 local언어 단어 사용.
        else {
            word  = _getHtmlCachedData( mlKey, lang ) || _getJsCachedData( mlKey, lang );
            if ( jexjs.isNull(word) ){
                word =  _getHtmlLocalData( mlKey ) ||  _getHtmlCachedData( mlKey, localLang ) || _getJsLocalData( mlKey ) ||  _getJsCachedData( mlKey, localLang );
            }
        }
        
        //단어에 parameter가 있는 경우 render
        
        if ( !jexjs.empty(params) ){
            word = _getRenderHtml( word, params );
        }
        
        return word;
    }
    
    /**
     * html에서는 #{ ID } 표현이 불가능하기때문에, #[ ID ] 사용
     */
    function _getRenderHtml( template , param){
        var startVar = '#[',
            endVar = ']',
            changeStartVar = '#{',
            changeEndVar = '}',
            i_start,
            i_end,
            result = '',
            cursor=0;
        
        while (( i_start = template.indexOf(startVar, cursor)) != -1) {
            
            i_end = template.indexOf(endVar, i_start);
            if (i_end === -1) {
                jexjs.error("  template] render error : can not found ']' ");
            }
            result += template.substring(cursor, i_start);
            result = result.concat( changeStartVar );
            result += template.substring(i_start + startVar.length, i_end + endVar.length - 1);
            result = result.concat( changeEndVar );
            cursor = i_end + 1;
        }
        
        result += template.substring(cursor);
        return getRender( result , param );
    }
    /**
     * key에 대한 JS data 반환
     * 해당언어에 다국어 id가 없는 경우 debug 모드인경우 다국어 id insert 하고 다국어정보 다시 불러옴.
     * 우선순위 : local 언어인경우 - parameter로 입력받은 local단어 -> 사전의 local 언어의 단어
     * 우선순위 : local 언어아닌경우 - 현재 언어의 단어 -> parameter로 입력받은 local단어 > 사전의 local 언어의 단어
     */
    function getJsMlData ( mlKey, _localWrd, _param, _option ){
        
        var localWrd = null, param = null, option = null;
        
        if ("string" == typeof _localWrd ){
            localWrd = _localWrd;
            
            param = _param;
            option = _option;
            _setJsLocalData( mlKey, localWrd );
        }else{
            param = _localWrd;
            option = _param;
        }
        
        if( jexjs.isNull(option)){
            option = {};
        }
        
        var lang = option.LANG || jexjs.getLang();
        var localLang = jexjs.getLocalLang();
        var word = null;
        var mlDataOfLang = _CACHED_ML_DATA[ lang ];
        var insertViewId = null;
        
        if ( jexjs.isNull( mlDataOfLang ) && localLang != lang ){
            jexjs.debug("    jexjs.plugin.ml : getJsMlData :" + lang +" 언어가 load 되어있지 않습니다.");
        }
        
        word  = _getJsCachedData( mlKey, lang ) || _getJsCachedData( mlKey, localLang );
        
        //다국어 정보를 load 했지만, 다국어 ID가 없는 경우 id insert
        if ( _IS_LOADED && jexjs.isNull( word ) ){
            insertViewId = option.VIEW_ID || option.NOMAL_VIEW_ID || _FUNC.setInsertViewId.call(undefined, { 'ML_ID': mlKey, 'ML_TP':_ML_TP.JS }) || _viewId; 
            if ( _FUNC.isInsertMlKey.call(undefined, { 'VIEW_ID':insertViewId, 'ML_ID': mlKey, 'ML_TP':_ML_TP.JS } ) ){
                _insertMlKey( insertViewId, _ML_TP.JS, mlKey, localWrd, lang );
            }else{
                jexjs.debug("    jexjs.plugin.ml : getJsMlData : " + insertViewId + " | " + mlKey +" 를 db에 insert 요청안함");
            }
        }
        
        // local언어인경우
        if ( lang == localLang ){
            word = _getJsLocalData( mlKey );
        }// local 언어가 아닌경우
        else{
            word  = _getJsCachedData( mlKey , lang ) || _getJsLocalData( mlKey ) || _getJsCachedData( mlKey , localLang );
        }
        
        return word ? getRender( word , param ): null;
   }
    
    /**
     * lang이 없는 경우는 localLang 데이터 반환, 있는 경우는 해당언어 데이터 반환, "ALL"인경우 전체 데이터 반환
     * @param lang 언어코드
     */
    function _loadViewData( _lang, p_action ){
        
        var lang = _lang || jexjs.getLang();
        
        //언어코드 없는 경우는 local 언어에 대한 다국어정보를 반환
        var action = p_action || _ML_ACTION.SET;
        var jaxAjax = jexjs.createAjaxUtil( _settings.url );
        jaxAjax.set("ACTION", action );
        jaxAjax.set("VIEW_ID", _viewId);
        if ( !jexjs.empty(lang) ){
            jaxAjax.set("LANG", lang);  //ALL로 보내면 전체 언어 가져옮.
        }
        if ( !jexjs.isNull( _settings.prefix ) ){
            jaxAjax.setting('prefix', _settings.prefix  );
        }
        if ( !jexjs.isNull( _settings.suffix ) ){
            jaxAjax.setting('suffix', _settings.suffix  );
        }
        if ( !jexjs.isNull( _settings.contextPath ) ){
            jaxAjax.setting('contextPath', _settings.contextPath  );
        }
        jaxAjax.setting('async', false );
        jaxAjax.setIndicator(false);
        jaxAjax.execute(function(data) {
            jexjs.debug("    jexjs.plugin.ml : _loadViewData:" + _viewId + " 다국어 정보 "+ lang +" 요청!!");
            jexjs.debug("    jexjs.plugin.ml : data:" + JSON.stringify(data));
            
            _IS_LOADED = true; 
            if ( data.ML_DATA ) {
                if ( data.ML_DATA[ data.LANG ] ){
                    _setCacheData( data.ML_DATA[ data.LANG ] , data.LANG );
                }
                if ( jexjs.getLocalLang() != data.LANG &&  data.ML_DATA[ jexjs.getLocalLang() ] ){
                    _setCacheData( data.ML_DATA[ jexjs.getLocalLang() ] , jexjs.getLocalLang() );
                }
            }
            
            if ( action == _ML_ACTION.SET){
                if ( data.LANG ) setLang( data.LANG );
            }
            
            if( data.debug ){
                _IS_ML_DEBUG = data.debug;
            }else{
                _IS_ML_DEBUG = false;
            }
        });
    }
    
    //현재 viewid 페이지 외에 view를 load 합니다.
    function _addLoadView( viewId ){
        _addLoadViewList( viewId ); //추가적으로 load된 view가 있는경우,
        var lang = jexjs.getLang();
        var jaxAjax = jexjs.createAjaxUtil( _settings.url );
        jaxAjax.set("ACTION", _ML_ACTION.LOAD );
        jaxAjax.set("VIEW_ID", viewId);
        jaxAjax.set("LANG", lang);  //ALL로 보내면 전체 언어 가져옮.
        if ( !jexjs.isNull( _settings.prefix ) ){
            jaxAjax.setting('prefix', _settings.prefix  );
        }
        if ( !jexjs.isNull( _settings.suffix ) ){
            jaxAjax.setting('suffix', _settings.suffix  );
        }
        if ( !jexjs.isNull( _settings.contextPath ) ){
            jaxAjax.setting('contextPath', _settings.contextPath  );
        }
        jaxAjax.setting('async', false );
        jaxAjax.setIndicator(false);
        jaxAjax.execute(function(data) {
            jexjs.debug("    jexjs.plugin.ml : _addViewLoad:" + viewId + " 다국어 정보 "+ lang +"추가 요청!!");
            jexjs.debug("    jexjs.plugin.ml : add data:" + JSON.stringify(data));
            if ( data.ML_DATA ) {
                if ( data.ML_DATA[ data.LANG ] ){
                    _setCacheData( data.ML_DATA[ data.LANG ] , data.LANG );
                }
                if ( jexjs.getLocalLang() != data.LANG &&  data.ML_DATA[ jexjs.getLocalLang() ] ){
                    _setCacheData( data.ML_DATA[ jexjs.getLocalLang() ] , jexjs.getLocalLang() );
                }
            }
        });
    }
    
    //load한 다국어 정보를 cache 합니다.
    function _setCacheData( data , lang ){
        
        if ( !_CACHED_ML_DATA[lang] ){
            _CACHED_ML_DATA[lang] = jexjs.clone( data );
        } else{
            jexjs.extend( _CACHED_ML_DATA[lang], data );
        }
        
        // View or JS가 하나도 없는 경우 빈 object 생성.
        if( jexjs.isNull( _CACHED_ML_DATA[lang][_ML_TP.HTML] ) ){
            _CACHED_ML_DATA[lang][_ML_TP.HTML] = {};
        }
        if( jexjs.isNull( _CACHED_ML_DATA[lang][_ML_TP.JS] ) ){
            _CACHED_ML_DATA[lang][_ML_TP.JS] = {};
        }
    }
    
    /**
     * 다국어 debug 모드인경우, view Load 할때 or js key 호출시 등록되지 않은 다국어 key 인경우 DB에 자동으로 insert 한다.
     */
   function _insertMlKey ( insertViewId, mlTp, mlKey, localWrd, lang, isDynamic ){
       jexjs.debug("    jexjs.plugin.ml : _insertMlKey : debug=" + _IS_ML_DEBUG );
       
       if ( _IS_ML_DEBUG && !jexjs.empty(mlKey)){
           jexjs.debug("    jexjs.plugin.ml : _insertMlKey : insertViewId="+insertViewId+", mltp="+mlTp+", mlKey=" + mlKey +" ,localWrd="+ localWrd +" 를 db에 insert 요청");
           var jaxAjax = jexjs.createAjaxUtil( _settings.url );
           jaxAjax.set("ACTION", _ML_ACTION.INSERT );
           jaxAjax.set("ML_TP", mlTp );
           jaxAjax.set("VIEW_ID", insertViewId);
           jaxAjax.set("ML_ID", mlKey );
           if( !jexjs.isNull( localWrd ) ){
               jaxAjax.set("LOCAL_WRD", localWrd );
           }
           jaxAjax.set("CHG_YN", 'Y' );
           jaxAjax.set("USR_REG_YN", 'Y' );
           if ( !jexjs.isNull( _settings.prefix ) ){
               jaxAjax.setting('prefix', _settings.prefix  );
           }
           if ( !jexjs.isNull( _settings.suffix ) ){
               jaxAjax.setting('suffix', _settings.suffix  );
           }
           if ( !jexjs.isNull(_settings.contextPath) ){
               jaxAjax.setting('contextPath', _settings.contextPath  );
           }
           jaxAjax.setIndicator(false);
           jaxAjax.execute(function(data) {
               jexjs.debug("    jexjs.plugin.ml : _insertMlKey : insertViewId="+insertViewId+", mltp="+mlTp+", mlKey=" + mlKey +" ,localWrd="+ localWrd +" 를 db에 insert");
               _loadViewData( lang, _ML_ACTION.LOAD );
           });
       }
   }
   
   function getRender( template , params ){
       if ( params && "object" == typeof params ){
           return $template.render( template , params );
       }else{
           return template;
       }
   }
   
   /**
    * LOAD 된 VIEW LIST 목록에 view id를 추가합니다.
    */
   function _addLoadViewList( viewId ){
       var isAlreadyIncludeView = false; 
       if ( 0 === _LOAD_VIEW_LIST.length ){
           _LOAD_VIEW_LIST.push(viewId);
       }else{
           for(var i=0; i < _LOAD_VIEW_LIST.length; i++){
               if ( viewId == _LOAD_VIEW_LIST[i] ){
                   isAlreadyIncludeView = true;
                   break;
               }
           }
           if( !isAlreadyIncludeView ){
               _LOAD_VIEW_LIST.push(viewId);
           }
       }
   }
    
    //TODO
    function _getJsText( mlKey, lang ){
        var originalText = getJsMlData( mlKey, param, lang );
        return _toJsText( originalText );
    }

    //TODO
    function _getHtmlText( mlKey, lang ){
        var originalText = getHtmlMlData( mlKey, lang);
        return _toHtmlText( originalText );
    }
    
    //TODO
    function _toHtmlText ( text ){
        var htmlText = "";
        //TODO 공백 -> &nbsp;
        //TODO \n -> <br> (html) , <br /> (xhtml)
        return text;
    }
    
    //TODO
    function _toJsText( text ){
        var jsText = "";
        //TODO &nbsp; -> 공백 
        //TODO <br> (html) , <br /> (xhtml) -> \n
        return text;
    }
    
    return {
        /**
         * 객체 생성시 처리할 로직
         */
        init: function( settings ) {
            _init( settings );
        },
        getViewId : function(){
            return _viewId;
        },
        /**
         * 함수를 추가합니다. 
         * setViewId , beforeChange, afterChange, change function
         */
        addFunction : function(fnNm , fn ){
            if ( "function" == typeof fn ){
                _FUNC[fnNm] = fn ;
            }
        },
        /**
         * 언어코드에 다국어정보를 가져온뒤 Dom Element 변경
         * @param lang 언어코드
         */
        change : function( lang, opt ){
            _change(lang, opt);
        },
        /**
         * 입력한 그대로의 값을 반환
         * @param {string} mlKey 다국어 key
         * @param {string} localWrd local단어
         * @param {JSONObject} param
         * @param {JSONObject} option { "VIEW_ID" : "COM_ID" };
         * @example jexjs.plugin("ml").get("key1","{USR_NM} 님 안녕하세요.",{"USR_NM":"이름"}, { "VIEW_ID" : "login_0001_01" });
         *  jexjs.plugin("ml").get("key1", {"USR_NM":"이름"}, { "VIEW_ID" : "login_0001_01" });
         */
        get : function ( mlKey, localWrd, param, option ){
            return getJsMlData.apply(this, arguments );
        },
        /**
         * 해당언어로 번역한 html을 반환합니다.
         */
        translateHtml : function( contents , opt ){
            if ( !opt ){ opt = {};}
            opt.async  = false;
            return _translateHtml( contents, opt );
        },
        asyncTranslateHtml : function( contents , opt ){
            if ( !opt ){ opt = {};}
            opt.async  = true;
            _translateHtml( contents, opt );
        },
        /**
         * viewId를 load 합니다.
         */
        addLoadView: function( viewId ){
            _addLoadView( viewId );
        }
        //,
        /**
         * js용 다국어 정보 반환
         */
//        getJsText : function( mlKey, param, lang ){
//            return _getJsText( mlKey, param, lang );
//        },
        /**
         * html용 다국어 정보 반환
         */
//        getHtmlText : function( mlKey, lang ){
//            return _getHtmlText( mlKey, lang );
//        }
    };
},true );

/**
 * 현재 display되고 있는 언어가 무엇인지 상관없이 프로젝트의 local언어가 무엇인지 반환한다. 
 */
jexjs.getLocalLang = function() {
    return jexjs.cookie.get("JEX_LOCAL_LANG");
};

/**
 * 현재 display되고 있는 언어가 무엇인지, 언어코드를 반환한다.
 * 언어코드는 ISO 639-1 2bytes 언어코드를 따른다.
 */
jexjs.getLang = function() {
    return jexjs.cookie.get("JEX_LANG");
};

/**
 * 되도록 사용하지 말것!!
 * 씨티에서만 사용.
 * - 언어버튼 눌렀을때 location 후 해당 언어로 표시해주기 위해 사용.
 * - 쿠키만 변경하고 location  되지 않으면, display 된 값과 쿠키값이 다른경우가 발생하여 새로고침시 언어 변경될수있음
 */
jexjs.setLang = function( lang ) {
    jexjs.cookie.set("JEX_LANG", lang);
};

/**
 * Mobile인 경우 App에서 언어가 변경된 경우 Web으로 언어변경을 알린다.
 * 
 */
jexjs.setChangeLangListener = function( fn ) {
    if ( "function" == typeof fn ) {
        if ( jexjs._isJexMobile() ) {
            jexMobile._addCallFunctionFromNative( 'appcall_changeLang', fn);
        } else {
            jex.warn("jex.mobile.js 에서만 사용가능한 함수입니다.");
        }
    }
};

/**
 * Mobile인 경우 Web에서 언어변경시 App으로 언어변경을 알린다.
 */
jexjs.noticeChangeLang = function ( lang ) {
    if ( jexjs._isJexMobile() ) {
        jexMobile.callNative('changeLang', {'JEX_LANG':lang });
    } else {
        jex.warn("jex.mobile.js 에서만 사용가능한 함수입니다.");
    }
};
/* ==================================================================================
 * pageloader
 *
 * jexjs.plugin('pageloader');
 * ================================================================================== */

jexjs.plugins.define('pageloader', function( ) {
    
    var _pageInfo = {
        'onload': null,     //실제 onload 된경우 발생하는 이벤트
        'reload' : null,    //실제로는 onload 되지않았지만, load 해야하는 경우 사용되는 event
        'event' : null      //event
    };
    
    function _onload(){
        
        var i, max;
        var beforeOnload = jexjs.loader.getBeforeOnload();
        var afterOnload = jexjs.loader.getAfterOnload();
        var beforeReload = jexjs.loader.getBeforeReload();
        var afterReload = jexjs.loader.getAfterReload();
        
        var fn = null;
        for( i=0, max = beforeOnload.length; i < max; i++ ){
            fn = beforeOnload.pop();
            fn();
        }
        
        for( i=0, max = beforeReload.length; i < max; i++ ){
            beforeReload[i]();
        }

        // TODO queue 사용하도록 변경
        if ( "function" == typeof _pageInfo.onload ){
            _pageInfo.onload();
        }
        
        if ( "function" == typeof _pageInfo.reload ){
            _pageInfo.reload();
        }
        
        for( i=0, max = afterReload.length; i < max; i++ ){
            afterReload[i]();
        }
        
        for( i=0, max = afterOnload.length; i < max; i++ ){
            fn = afterOnload.pop();
            fn();
        }
    }
    
    function _reload(){
        if ( "function" == typeof _pageInfo.reload ){
            _pageInfo.reload();
        }
    }
    
    return {
        /**
         * 객체 생성시 처리할 로직
         */
        init: function( pageInfo ) {
            
            var self = this;
            jexjs.loader.pushInstance( this );
            
            for( var prop in pageInfo){
                if ( undefined !== _pageInfo[prop] && "function" == typeof pageInfo[prop]){
                    _pageInfo[prop] = pageInfo[prop];
                }
            }
            
            $(document).ready(function() {
                self.onload();
            });
            
            if ( "function" == typeof _pageInfo.event ){
                _pageInfo.event.apply(this, arguments);
            }
        },
        onload : function(){
            _onload();
        },
        reload : function(){
            _reload();
        },
        bindAllEvent : function(){
            if ( "function" == typeof _pageInfo.event ){
                _pageInfo.event.apply(this, arguments);
            }
        },
        addEvent : function( selector, eventId, fn ){
            jexjs.debug("    jexjs.plugin.pageloader : addEvent: "+selector+","+eventId);
            
            if( "function" == typeof fn){
                //TODO 추후에 이벤트 jquery 대신에 script로 변경
                jexjs.$( selector ).bind( eventId, function(){
                   fn.apply(this, arguments); 
                });
                
            }else{
                jexjs.error("    jexjs.plugin.pageloader : addEvent : function만 event에 추가할 수 있습니다.");
            }
        }
    };
});

jexjs.createPageloader = function( pageInfo ){
    return jexjs.plugin("pageloader", pageInfo );
};
/* ==================================================================================
 * queue 플러그인은 비동기로 실행되는 함수들을 순차적으로 호출하기 위한 용도로 사용된다.
 *
 * jexjs.plugin('queue');
 * ================================================================================== */
jexjs.plugins.define('queue', function() {

    var jobList = [];
    var isRun = false;

    var _next = function( addedJob ) {
        if (typeof addedJob === 'function') {
            jobList.push( addedJob );
        }

        if ( !isRun ) {
            if (jobList.length > 0) {
                isRun = true;

                var job = jobList.shift();
                
                job(function() {
                    isRun = false;
                    _next();
                });
            }
        }
    };

    return {
        next: function( job ) {
            _next( job );
            return this;
        }
    };
});


/* ==================================================================================
 * screenshot 플러그인은 화면에 출력된 html document를 이미지파일로 렌더링해주는 플러그인이다.
 *  - Dependency : html2canvas ( http://html2canvas.hertzen.com/ )
 *
 * jexjs.plugin('screenshot');
 * ================================================================================== */
jexjs.plugins.define('screenshot', [], function ( ) {

    var _IFRAME_ATTR = "jex_screenshot_iframe",
    _IFRAME_IMG_ATTR = "jex_screenshot_iframe_img",
    iframeMap = {};

    function log(msg) {
        return 'jexjs.plugins.screenshot : ' + msg;
    }

    function randomIframeKey() {
        return Math.ceil(Date.now() + Math.random() * 10000000).toString();
    }

    if (!window.html2canvas) {
    	if( jexjs.getBrowser().msie && 9 > parserFloat(jexjs.getBrowser().version) ){
    		jexjs.error( log('screenshot 플러그인은 IE9+ 부터 지원합니다.') );
    	}else{
    		jexjs.error( log('html2canvas가 정의되지 않았습니다.') );
    	}
    }

    //임시로 생성했던 iframe img 태그 삭제
    function clearIframeImage( iframeElement, jexQueue ) {
        console.log("## clear iframe src::"+ iframeElement.src);
        var documentElement = iframeElement.contentWindow.document.documentElement;
        var iframeList = documentElement.querySelectorAll("iframe");
        
        if( iframeList.length > 0 ) {
            for( var i=0, len = iframeList.length; i < len; i++ ) {
                clearIframeImage( iframeList[i] , jexQueue );
            }

        }       
        
        if ( jexjs.empty( iframeElement.getAttribute(_IFRAME_ATTR ) )){
            return false;
        }

        jexQueue.next(function( next ){
            var iframeKey = iframeElement.getAttribute( _IFRAME_ATTR );
            var imgList = iframeElement.parentElement.getElementsByTagName("img");
            var key = null;
            for(var i=0; i < imgList.length; i++){
                key = imgList[i].getAttribute( _IFRAME_IMG_ATTR );
                if ( !jexjs.empty(key) && iframeKey == key ) {
                    imgList[i].remove();
                    break;
                }
            }
            iframeElement.removeAttribute( _IFRAME_ATTR );
            console.log("## clear iframe src::"+ iframeElement.src + "iframeMap["+ iframeKey +"] " +iframeMap[iframeKey]  );
            iframeElement.style.display =  iframeMap[iframeKey];
            delete iframeMap[iframeKey];
            next();
        });
    }

    //screenshot을 찍기위해 iframe을 img로 변경
    function iframeToTempImage( iframeElement, jexQueue ){
        jexjs.debug("    jexjs.plugin.screenshot : iframeToTempImage : cur iframe name="+ iframeElement.getAttribute("name"));
        var documentElement = iframeElement.contentWindow.document.documentElement;
        var iframeBody = iframeElement.contentWindow.document.body;
        var iframeList = documentElement.querySelectorAll("iframe");
        
        //빈 iframe 이거나 화면에 보이지 않는 경우는 image randering 안함
        if ( 0 === iframeBody.childNodes.length || 
            "none" == jexjs.cssUtil.getComputedStyle(iframeElement, "display") || 
            ( !jexjs.empty(iframeElement.getAttribute("name")) && -1 !== iframeElement.getAttribute("name").indexOf("jexQms") )
        ) {
            jexjs.debug("    jexjs.plugin.screenshot : iframeToTempImage : "+iframeElement.getAttribute("name")+" image randering 안함");
            return false;
        }
        
        //하위 iframe 먼저 처리
        if( iframeList.length > 0 ) {
            for( var i=0,len=iframeList.length; i < len; i++ ) {
                jexjs.debug("    jexjs.plugin.screenshot : iframeToTempImage : child iframe name="+ iframeList[i].getAttribute("name"));
                iframeToTempImage( iframeList[i] , jexQueue );
            }
        }
        jexjs.debug("    jexjs.plugin.screenshot : iframeToTempImage :"+iframeElement.getAttribute("name")+" image randering 시작");

        jexQueue.next(function( next ){
          var height = Math.max(Math.max(iframeBody.scrollHeight, documentElement.scrollHeight), Math.max(iframeBody.offsetHeight, documentElement.offsetHeight), Math.max(iframeBody.clientHeight, documentElement.clientHeight));
          html2canvas( iframeBody , {
            //foreignObjectRendering : true,
            height : height,
            logging: false
          }).then(function(canvas) {

            var iframeRandomKey = randomIframeKey();
            var img = document.createElement('img');
            img.setAttribute( _IFRAME_IMG_ATTR , iframeRandomKey );
            img.src = canvas.toDataURL();
            iframeElement.setAttribute( _IFRAME_ATTR, iframeRandomKey );
            //iframeElement.before( img );
            iframeElement.parentElement.insertBefore(img, iframeElement)
            console.log("## capture iframe name::"+ iframeElement.getAttribute("name")+", src::"+ iframeElement.src +", iframeRandomKey::" + iframeRandomKey + ", display:"+ iframeElement.style.display);
            iframeMap[iframeRandomKey]=  iframeElement.style.display;
            iframeElement.style.display =  "none";
            next();
          });
      });
    }

    function toCanvas( _callback, _elem ) {
        var jexQueue = jexjs.plugin("queue");
        var elem = _elem || document.body;
        var iframeList = elem.querySelectorAll("iframe");
        var doc = document.documentElement;
        var left = (window.pageXOffset || doc.scrollLeft) - (doc.clientLeft || 0);
        var top = (window.pageYOffset || doc.scrollTop)  - (doc.clientTop || 0);

        window.scrollTo(0, 0);
        if ( iframeList.length > 0 ) {
            for( var i=0, len = iframeList.length; i < len; i++ ) {
                jexjs.debug("    jexjs.plugin.screenshot : toCanvas : child iframe name="+ iframeList[i].getAttribute("name"));
                iframeToTempImage( iframeList[i] , jexQueue );
            }
        }

        jexQueue.next(function( next ){
            html2canvas( elem, {
                //foreignObjectRendering: true,
                logging: false
            }).then(function(canvas) {

                var jexSubQueue = jexjs.plugin("queue");
                jexSubQueue.next(function( subNext ){
                    if ( iframeList.length > 0 ) {
                        for( var i=0, len = iframeList.length; i < len; i++ ) {
                            clearIframeImage( iframeList[i] , jexSubQueue );
                        }
                    }
                    subNext();
                }).next(function( subNext ){
                    canvas.removeAttribute("style");    //canvas size를 지정해버려서 제거.
                    window.scrollTo(left, top);
                    if (typeof _callback === 'function') {
                        _callback( canvas );
                    }
                    subNext();
                });
            });
        });
   }

    function toImage( _callback, _elem ) {
        toCanvas(function(canvas) {
            var img = document.createElement('img');
            var dataUrl = canvas.toDataURL();
            img.src = dataUrl;
            if (typeof _callback === 'function') {
                _callback( img );
            }
        }, _elem);
    }

    function toBlob( _callback, _elem ) {
        toCanvas(function(canvas) {
            var dataUrl = canvas.toDataURL();
            var blob = jexjs.dataURLtoBlob(dataUrl);
            if (typeof _callback === 'function') {
                _callback( blob );
            }
        }, _elem);
    }
    
    function toDataURL( _callback, _elem ) {
        toCanvas(function(canvas) {
            var dataUrl = canvas.toDataURL();
            if (typeof _callback === 'function') {
                _callback( dataUrl );
            }
        }, _elem);
    }

    return {
        toCanvas: function( callback, elem ) {
            toCanvas(callback, elem);
        },
        toImage: function( callback, elem ) {
            toImage(callback, elem);
        },
        toBlob: function( callback, elem ) {
            toBlob(callback, elem);
        },
        toDataURL: function( callback, elem ) {
            toDataURL(callback, elem);
        }
    };
});
/* ==================================================================================
 * template 플러그인은 '문자열 템플릿'과 '변수 맵'을 통해서 하나의 완성된 '문자열'을 만들어주는 플러그인이다.
 *
 * var BANNER_TEMPLATE = 'Welcome to #{ title }. #{ loginUser.loginId }님이 로그인 하였습니다.';
 * var params = {
 *   'title': 'jexjs',
 *   loginUser: {
 *      'loginId': 'helloworld'
 *   }
 * }
 *
 * 일 때, 위 두 재료를 합하여
 *
 *      'Welcome to jexjs. helloworld님이 로그인하였습니다.
 *
 * 를 완성해준다.
 *
 *
 * jexjs.plugin('template');
 * ================================================================================== */
jexjs.plugins.define('template', function() {

    var NOT_FOUND_PARAM = 'undefined';

    function render(_template, params) {
        var
            result = '',
            cursor = 0, // work pointer
            startVar = '#{',
            endVar = '}'
        ;

        (function() {
            var i_start,
                i_end;

            while (( i_start = _template.indexOf(startVar, cursor)) != -1) {
                i_end = _template.indexOf(endVar, i_start);

                if (i_end === -1) {
                    jexjs.error("  template] render error : can not found '}' ");
                }

                result = result + _template.substring(cursor, i_start);

                var this_var = _template.substring(i_start + startVar.length, i_end + endVar.length - 1);

                /*jshint evil: true*/
                var fn = new Function('localScope', 'return localScope.' + this_var);

                var fnResult = NOT_FOUND_PARAM;
                try {
                    fnResult = fn(params);

                    if ( 'undefined' == typeof fnResult) {
                        fnResult = NOT_FOUND_PARAM;
                    }
                } catch(e) { }

                result = result + fnResult;
                cursor = i_end + 1;
            }

            result = result + _template.substring(cursor);
        })();

        return result;
    }


    return {
        init: function( ) {

        },

        /**
         * String 템플릿과 parameter를 합쳐서 완성된 String을 만든다.
         *
         * @method render
         * @param {String} key || template
         * @param {Object} params
         * @returns {String}
         */
        render: function(_keyOrTemplate, params, option) {
            if ( option ) {
                if ( "string" == typeof option.NOT_FOUND_PARAM) {
                    NOT_FOUND_PARAM = option.NOT_FOUND_PARAM;
                }
            }
            var self = this,
                template = self.get(_keyOrTemplate) || _keyOrTemplate;

            return render(template, params);
        },
        renderSpace : function( _keyOrTemplate, params ) {
            return this.render( _keyOrTemplate, params, {
                'NOT_FOUND_PARAM' : ''
            });
        },
        add: function(_id, _template) {
            jexjs.global.plugins.template._list[_id] = _template;
        },
        get: function(_id) {
            return jexjs.global.plugins.template._list[_id];
        },
        _registerFromDom: function() {
            var self = this,
                domTemplateList = document.getElementsByTagName("jex-template"),
                scriptTemplateList = document.getElementsByTagName("script"),
                i, length = domTemplateList.length
                ;

            for (i = 0; i < length; i++) {
                var domTemplate = domTemplateList[i],
                    domId = domTemplate.getAttribute('id'),
                    domText = domTemplate.innerHTML.trim()
                ;

                self.add(domId, domText);
            }

            length = scriptTemplateList.length;
            for( i = 0; i < length; i++) {
                var scriptTemplate = scriptTemplateList[i],
                    scriptId = scriptTemplate.getAttribute('id'),
                    scriptType = scriptTemplate.getAttribute('type'),
                    scriptText = scriptTemplate.innerHTML.trim()
                ;

                if (scriptId && scriptType === "text/jex-template") {
                    self.add(scriptId, scriptText);
                }
            }
        }
    };
}, true);

//jexjs.global.plugins.template.tag = "jex-template"; 옵션
jexjs.global.plugins.template._list = {};

/**
 * 기본 template 정의
 * */
jexjs.template = (function( ){
    return jexjs.plugin("template");
}());

$(document).ready(function() {
    jexjs.plugin("template")._registerFromDom();
});

/**
 * file upload 플러그인 <br />
 *
 * iframe 을 이용하여 form 전송을 통하여 file을 업로드 한다.
 *
 * var file_uploader = jexjs.plugin("upload"); <br />
 *
 * @class jexjs.plugins.upload
 */

jexjs.plugins.define('upload', function() {

    var _global = jexjs.global.plugins.upload || jexjs.global.plugins.file_upload; //기존 upload와 호환성유지
    var _checkType = null;  //file type과 data타입은 함께 사용할 수 없으므로 valid check 
    var _parameter = {};    // file외의 일반 text data
    var formData = null;
    try {
        formData = new FormData();  //실제 ajax 호출시 사용되는 data
    } catch( e ){
        jexjs.debug("    jexjs.plugin.upload : "+ e);
        jexjs.debug("    jexjs.plugin.upload : IE10 이상만 지원합니다.");
    }
    var form_file_upload_id = "jex_file_upload_form";
    var random = new Date().getTime(),
        template_form = '<form method="post" enctype="multipart/form-data" style="position:absolute; top: -1000px; left: -1000px;"></form>',
        template_iframe = '<iframe style="display:none;"></iframe>',
        template_file = '<input type="file" />',
        template_submit = '<input type="submit" value="upload" />';

    var contextPath = _global.contextPath || "",
        prefix = _global.prefix || "",
        suffix = _global.suffix || ".jct",
        url,
        $form,
        $targetFrame,
        files = [];
    

    var _AjaxUploadSuccess = function( data ){
        
    };
    
    var _AjaxUploadError = function( data ) {
        var code = jexjs.null2Void(jexjs.getJexErrorCode( data ));
        var msg = jexjs.null2Void(jexjs.getJexErrorMessage( data ));
        alert("[ "+ code +" ]" + msg );
    };
    
    //TODO 파일들 각각 업로드 되도록 기능구현하자.
    //TODO progressbar
    //TODO totalSize 계산
    var options = {
            type : "file",      // file : 일반 input type, data : 파일선택화면을 띄우지 않고 data로 입력받은경우.
            async : true,       // aysnc 여부
            multiple : false,   // input type="file" 에서 다건파일 선택가능여부
            reset: true,        // input type="file" 선택시 새로 file 선택하지 않고 추가된파일 계속 가지고있을건지 여부
            name : "FILE_NM",   // 파일 전송시 사용할 기본 input domain 필드명
            dragrable : false,  // drag 설정여부
            isIndicator : false,  // indicator 사용여부
            indicator : null    // indicator 객체
            //TODO allowedExtensions : []  //파일확장자
            //TODO allowedMaxCount : 10,
            //TODO allowedMaxSize : 
            //TODO autoUpload : false
    };
    
    var element = {
            'drop' : null   //drop 되면 파일추가될 영역
    };
    
    var events = {
            onDrop : null,
            onDragover : null,
            onDragleave : null
//            ,
//            onProgress : function( e ){
//                if (e.lengthComputable) {
//                    var percentComplete = e.loaded / e.total;
//                    percentComplete = parseInt(percentComplete * 100);
//                    console.log(percentComplete);
//                    if (percentComplete === 100) {
//
//                    }
//                }
//            }
    };
    
    if ( _global.options ){
        jexjs.extend( options, _global.options );
    }
    
    function _callUserEvent( eventName, e){
        if ( jexjs.isFunction( events[eventName] ) ) {
            events[eventName].call(null, e);
        }
    }
    
    function onDragoverHandler( e ) {
        jexjs.event.preventDefault(e);
        _callUserEvent('onDragover', e);
    }
    
    function onDragleaveHandler( e ) {
        jexjs.event.preventDefault(e);
        _callUserEvent('onDragleave', e);
    }
    
    function onDropHandler( e ) {
        jexjs.event.preventDefault(e);
        
        //drop 할때, 단건인경우는 파일추가되지 않도록 구현.  
        var addFiles = e.target.files || e.dataTransfer.files;
        if( !options.multiple && 1 < addFiles.length ) {
            return false;
        }
        _addFile( e, events.onDrop );
    }
    
    function onChangeHandler( e , _callback ) {
        _addFile( e, _callback );
    }
    
    function _resetFile(){
        files = [];
        formData = new FormData();
    }
    
    function _addFile( e , callback ) {
        var addFiles = e.target.files || e.dataTransfer.files;
        
        //로그출력 추가된 파일
        if ( !jexjs.empty(addFiles)){
            for(var k=0; k < addFiles.length; k++){
                jexjs.debug("    jexjs.plugin.upload : addFiles["+k+"]::"+ addFiles[k].name);
            }
        }
        
        if ( options.reset ){
            _resetFile();
            files = addFiles;
        }else {
            for(var i=0; i < addFiles.length; i++){
                var isDuplicate = false;
                for(var j=0; j < files.length; j++){
                    if ( files[j].name == addFiles[i].name){
                        jexjs.debug("    jexjs.plugin.upload : overwrite file::"+ addFiles[i].name);
                        files[j] = addFiles[i];
                        isDuplicate = true;
                    }
                }
                if ( !isDuplicate ){
                    files.push(addFiles[i]);
                }
            }
        }
        
        //로그출력 전체파일
        if ( !jexjs.empty(files)){
            for(var l=0; l < files.length; l++){
                jexjs.debug("    jexjs.plugin.upload : files["+l+"]::"+ files[l].name);
            }
        }
        
        if (typeof callback === "function") {
            if ( options.multiple ){
                callback( jexjs.clone(files), addFiles, {'event': e } );
            } else {
                callback( jexjs.clone(files)[0], addFiles, {'event': e } );
            }
        }
    }
    
    function initDragAndDrop ( option ) {
        if( option.dragrable ) {
            jexjs.event.attach( element.drop, 'drop', onDropHandler );
            jexjs.event.attach( element.drop, 'dragover', onDragoverHandler );
            jexjs.event.attach( element.drop, 'dragleave', onDragleaveHandler );
        }
    }
    
    function isAllowedExtension ( fileName ) {
        var isValid = false;
        
        if( 0 === options.allowedExtensions.length ) {
            return true;
        }
        
        jexjs.each( options.allowedExtensions , function(idx, ext) {
            if (jexjs.isString(ext)) {
                var extRegex = new RegExp("\\." + ext + "$", "i");
                if (fileName.match(extRegex) !== null) {
                    valid = true;
                    return false;
                }
            }
        });

        return isValid;
    }
    
    function init( _url , option ) {
        
        if ( option ) {
            
            if ( option.event ) {
                jexjs.extend( events, option.event, false );
                delete option.event;
            }
            
            if ( option.element ) {
                for( var key in option.element ) {
                    var elem = option.element[key];
                    element[key] = jexjs._getHtmlElement( option.element[key] );
                }
                delete option.element;
            }
            
            if ( option.indicator ) {
                options.isIndicator = true;
            }
            settings( option );
            
            initDragAndDrop( option );
        }
        
        initDom();

        url = _url;

        $form.attr({
            'action': getUrl( _url ),
            'target': $targetFrame.attr('name')
        });
        
    }
    
    function settings ( key, value ){
        if ( typeof key === 'object' ){
            for( var k in key){
                _settings( k, key[k]);
            }
        }else if ( typeof key === 'string'){
            _settings( key, value );
        }
    }
    
    function _settings ( key, value ){
        if ( 'contextPath' === key ){
            contextPath = value;
        }else if ( 'prefix' === key ){
            prefix = value;
        }else if ( 'suffix' === key ){
            suffix = value;
        }
        options[ key ] = value;
    }
    
    function getUrl( _url ){
        var fullUrl = "";
        
        if ( !jexjs.empty( contextPath )){
            fullUrl += contextPath + "/" ;
        }
        if ( !jexjs.empty( prefix )){
            fullUrl += prefix + "/" ;
        }
        
        //id에 .jct 확장자 넘어온경우
        if ( -1 != fullUrl.indexOf(".jct") && ".jct" == suffix) {
            fullUrl +=  _url;
        } else {
            fullUrl +=  _url + suffix;
        }
        
        return fullUrl;
    }

    function initDom() {
        var random = new Date().getTime();
        $form = jexjs.$('#' + form_file_upload_id + "_" + random);
        if ($form.length === 0) {
            $form = jexjs.$(template_form);
            $form.appendTo("body");
        }

        if ($form.find('input[type=submit]').length === 0) {
            $form.append(jexjs.$(template_submit));
        }

        $form.off('submit').on('submit', function(event) {
            
            var $inputFile = $(jexjs.$(this).find("input[type=file]")[0]);

            if ( "file" == options.type ) {
                //파일 다건 선택
                if ( options.multiple ){
                    var _files = files;
                    for( var i = 0; i < _files.length; i++ ){
                        formData.append( options.name , _files[i] );
                    }
                }//파일 단건 선택
                else{
                    formData.append( options.name , $inputFile[0].files[0] );
                }
            }
            
            //file 객체외의 데이터가 있는 경우 추가
            if ( _parameter ) {
                for( var key in _parameter ) {
                    if ( "object" == typeof _parameter[key] ) {
                        formData.append(key, JSON.stringify( _parameter[key] ));
                    } else {
                        formData.append(key, _parameter[key] );
                    }
                }
            }
            
            if( options.dragrable && !options.isIndicator ) {
                options.indicator = jexjs.plugin("indicator", {
                    target : element.drop
                });
            }
            
            if ( options.indicator ) {
                options.indicator.show();
            }
            
            jQuery.ajax({
                xhr: function(){
                    var xhr = new window.XMLHttpRequest();
//                    xhr.upload.addEventListener("progress", function(e) {
//                        events.onProgress.call(null, e );
//                    }, false);
                    return xhr;
                },
                url: getUrl(url),
                type: 'POST',
                data: formData,
                async: options.async,
                cache: false,
                processData: false,
                contentType: false,
                success: function(data, textStatus, jqXHR) {
                    if ( options.indicator ) {
                        options.indicator.hide();
                    }
                    if ( jexjs.isJexError( data )){
                        _AjaxUploadError( data );
                    } else {
                        _AjaxUploadSuccess( data );
                    }
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    if ( options.indicator ) {
                        options.indicator.hide();
                    }
                    jexjs.warn("    jexjs.plugin.upload:: error :: "+textStatus);
                }
            });

            return false;
        });

        $targetFrame = jexjs.$(template_iframe);
        $targetFrame.attr('name', 'jex_fileupload_frame');
        $targetFrame.appendTo("body");
    }
    
    function add(_callback) {
        
        var $input_file = $($form.find('input[name=' + options.name + ']')[0]);
        
        if (typeof $input_file !== 'undefined') {
            $input_file.remove();
        }
            
        $input_file = jexjs.$(template_file)
            .attr({
                'id': options.name,
                'name': options.name
            });

        if ( options.multiple ){
            $input_file.prop("multiple",true);
        }
        
        $form.append($input_file);
        
        $input_file.on('change', function( e ) {
            onChangeHandler( e, _callback );
        });

        $input_file.click();
    }
    
    function addFormData( value ){
        formData.append( options.name, value );
    }
    
    function _removeFile( orgFileName ) {
        var file, newFiles = [];
        var isRemove = false;
        for ( var i = 0; i < files.length; i++ ){
            file = files[i];
            if ( orgFileName != file.name ){
                newFiles.push(file);
            }else{
                isRemove = true;
            }
        }
        files = newFiles;
        if ( isRemove ){
            jexjs.debug("    jexjs.plugin.upload : remove file::"+ orgFileName);
            return 1;
        }
        return 0;
    }
    
    function removeFileList(orgFileName, _callback ){
        var removeCount = 0;
        var count = 0;
        var removedFiles = [];
        if (  jexjs.isString( orgFileName ) ) {
            removeCount =  _removeFile(orgFileName);
        }else if ( jexjs.isArray(orgFileName) ) {
            for(var i=0; i < orgFileName.length; i++){
                count = _removeFile( orgFileName[i] );
                if ( count == 1 ) {
                    removedFiles = orgFileName[i];
                }
                removeCount+=count;
            }
        }
        
        _callback( jexjs.clone(files), removedFiles, {'removedCount': removeCount});
    }
    
    function upload(_callback) {
        
        if ( "function" == typeof _callback ){
            _AjaxUploadSuccess = _callback;
        }else {
            if( "function" == typeof _callback.success ){
                _AjaxUploadSuccess = _callback.success;
            }
            if( "function" == typeof _callback.error ){
                _AjaxUploadError = _callback.error;
            }
        }
        $form.find('input[type=submit]').click();
        _resetFile();
    }

    function setUrl(_url) {
        url = _url;
        $form.attr('action', getUrl(_url) );
    }

    return {
        init: function(_url , option) {
            init(_url, option);
        },
        /**
         * 일반데이터 추가
         * 
         */
        setData : function( key , value ){
            jexjs.extend(_parameter, key, value);
        },
        /**
         * 파일추가
         * @param name input type=file 인 필드의 name
         * @param fileData input type=file element를 사용하여 파일 추가하는 경우는 callback 함수. 아닌경우는 blob data
         */
        add: function( fileData ) {
            
            var type = "file";
            if ( "function" != typeof fileData ) {
                type = "data";
                options.type = type;
            }
            
            if ( null === _checkType ) {
                _checkType = type;
            } else {
                if ( _checkType != type ) {
                    jexjs.error("    jexjs.plugin.upload:: file Type과 data Type을 함께 사용할 수 없습니다. ");
                }
            }
            
            if ( "function" == typeof fileData ) {  //File 선택하여 추가
                add(fileData);
            } else {    //File Data 추가
                addFormData(fileData);
            }
        },
        /**
         * 파일삭제
         * @param name input type=file 인 필드의 name
         * @param fileNameList
         * @param callback
         */
        remove : function( fileNameList , callback) {
            removeFileList( fileNameList , callback);
        },
        /**
         * 파일업로드
         */
        upload: function(_callback) {
            upload(_callback);
        },
        url: function(_url) {
            setUrl(_url);
        }
    };
});

/**
 * 파일업로드 공통 설정
 */
jexjs.fileUploadSetup = function( settings ){

    if (jexjs.isNull( settings )) {
        return;
    }

    var globalFileUpload = jexjs.global.plugins.upload || jexjs.global.plugins.file_upload; //기존 upload와 호환성유지
    
    //settings
    if (typeof settings.prefix === 'string') {
        globalFileUpload.prefix = settings.prefix;
        delete settings.prefix;
    }
    if (typeof settings.suffix === 'string') {
        globalFileUpload.suffix = settings.suffix;
        delete settings.suffix;
    }
    if (typeof settings.contextPath === 'string') {
        globalFileUpload.contextPath = settings.contextPath;
        delete settings.contextPath;
    }
    
    globalFileUpload.options = settings;
    
};
})();