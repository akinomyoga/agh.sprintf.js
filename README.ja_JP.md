# agh.sprintf.js

C, POSIX compatible sprintf written in JavaScript.

sprintf の真面目な JavaScript 実装。

License: MIT License にします

**HTML**

```html
<script type="text/javascript" charset="utf-8" src="agh.sprintf.js"></script>
<script type="text/javascript">
var result1 = sprintf("pi = %-*.*g /* this is an example */", 30, 20, Math.PI);
var result2 = vsprintf("pi = %-*.*g /* this is an example */", [30, 20, Math.PI]);
</script>
```

**Node**

```sh
$ npm install agh.sprintf
```

```javascript
var agh = require('agh.sprintf');
console.log(agh.sprintf("pi = %-*.*g /* this is an example */", 30, 20, Math.PI));
console.log(agh.vsprintf("pi = %-*.*g /* this is an example */", [30, 20, Math.PI]));
```

**Node (without npm)**

```sh
$ git clone https://github.com/akinomyoga/agh.sprintf.js
$ cd agh.sprintf.js
```

```javascript
var agh = require('./agh.sprintf.js');
console.log(agh.sprintf("pi = %-*.*g /* this is an example */", 30, 20, Math.PI));
console.log(agh.vsprintf("pi = %-*.*g /* this is an example */", [30, 20, Math.PI]));
```

## 1 書式指定

書式は以下の形式で指定する。

`'%'` *\<pos>***?** *\<flags>***?** *\<width>***?** *\<precision>***?** *\<type>***?** *\<conv>*

 - 変換指定子   *\<conv>*      は出力する形式を指定する。
 - 幅           *\<width>*     は出力時の最小文字数を指定する。
 - 精度         *\<precision>* は内容をどれだけ詳しく出力するかを指定する。
 - フラグ       *\<flags>*     は出力の見た目を細かく指定する。
 - 位置指定子   *\<pos>*       は引数の番号を指定する。
 - サイズ指定子 *\<type>*      は引数のサイズ・型を指定する。

### 1.1 変換指定子 *\<conv>*

引数の型及び出力の形式を指定する。以下の何れかの値を取る。

|指定|準拠|説明|
|:--|:--|:--|
|`'d', 'i'`|標準|10進符号付き整数
|`'o'`     |標準| 8進符号無し整数
|`'u'`     |標準|10進符号無し整数
|`'x', 'X'`|標準|16進符号無し整数     (lower/upper case は 0xa/0XA などの違い)
|`'f', 'F'`|標準|浮動小数点数         (lower/upper case は inf/INF などの違い)
|`'e', 'E'`|標準|浮動小数点数指数表記 (lower/upper case は 1e+5/1E+5 などの違い)
|`'g', 'G'`|標準|浮動小数点数短い表記 (lower/upper case は 1e+5/1E+5 などの違い)
|`'a', 'A'`|C99 |浮動小数点数16進表現 (lower/upper case は 1p+5/1P+5 などの違い)
|`'c'`     |標準|文字
|`'C'`     |XSI |文字   (本来 wchar_t 用だがこの実装では c と区別しない)
|`'s'`     |標準|文字列
|`'S'`     |XSI |文字列 (本来 wchar_t 用だがこの実装では s と区別しない)
|`'p'`     |標準|ポインタ値。この実装では upper hexadecimal number で出力。
|`'n'`     |標準|今迄の出力文字数を value[0] に格納
|`'%'`     |標準|"%" を出力

```javascript
// 例
sprintf("%d", 12345); // "12345"
sprintf("%o", 12345); // "30071"
sprintf("%u", -12345); // "4294954951"
sprintf("%x", 54321); // "d431"
sprintf("%X", 54321); // "D431"
sprintf("%f", Math.PI); // "3.141593"
sprintf("%e", Math.PI); // "3.141593e+000"
sprintf("%g", Math.PI); // "3.14159"
sprintf("%a", Math.PI); // "0x1.921fb54442d18p+001"
sprintf("%f, %F", Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY); // "inf, INF"
sprintf("%c, %C", 12354, 12354); // "あ, あ"
sprintf("%s, %S", 12354, 12354); // "12354, 12354"
sprintf("%d", 12345); // "12345"
sprintf("%p", 12345); // "3039"
sprintf("%d%n", 12345, a = []); // "12345", a == [5]
sprintf("%%"); // "%"
```

### 1.2 幅指定子 *\<width>*

幅指定子は以下の形式を持つ。

*\<width>* **:=** `/\d+/` **|** `'*'` **|** `'*'` `/\d+/` `'$'`

| 指定 | 準拠 | 説明 |
|:--|:--|:--|
|`/\d+/`        |標準 |最小幅を整数で指定する。        |
|`'*'`          |標準 |次の引数を読み取って最小幅とする|
|`'*'` `/\d+/` `'$'`|POSIX|指定した番号の引数を最小幅とする|

```javascript
// 例
sprintf("[%1d]", 12345); // "[12345]"
sprintf("[%8d]", 12345); // "[   12345]" 
sprintf("[%*d]", 6, 12345); // "[ 12345]"
sprintf("[%*2$d]", 12345, 7); // "[  12345]"
```

### 1.3 精度指定子 *\<precision>*

精度指定子は以下の形式を持つ。

*\<precision>* **:=** `'.'` `/\d+/` **|** `'.*'` **|** `'.*'` `/\d+/` `'$'`

|指定|準拠|説明|
|:--|:--|:--|
|`'.'` `/\d+/`       |標準 |精度を整数で指定する。
|`'.*'`              |標準 |次の引数を読み取って精度とする。
|`'.*'` `/\d+/` `'$'`|POSIX|指定した番号の引数を精度とする。

整数の場合は精度で指定した桁だけ必ず整数を出力する。例えば、精度 4 の場合は "0001" など。
精度を指定した時はフラグで指定した '0' は無視される。

浮動小数点数 *\<conv>* = f, F, e, E, a, A の場合は小数点以下の桁数を指定する。
浮動小数点数 *\<conv>* = g, G の場合は有効桁数を指定する。
*\<conv>* = f, F, e, E, g, G に対しては既定値は 6 である。
*\<conv>* = a, A については倍精度浮動小数点数の16進桁数である 13 が既定値である。

文字列の場合は最大出力文字数を指定する。この文字数に収まらない部分は出力されずに無視される。

```javascript
// 例
sprintf("%.1d", 12345); // "12345"
sprintf("%.8d", 12345); // "00012345" 
sprintf("%.*d", 6, 12345); // "012345"
sprintf("%.*2$d", 12345, 7); // "0012345"
sprintf("%.1f", Math.PI); // "3.1"
sprintf("%.10f", Math.PI); // "3.1415926536"
sprintf("%.50f", Math.PI); // "3.14159265358979311599796346854418516159057617187500"
sprintf("%.1g", Math.PI); // "3"
sprintf("%.10g", Math.PI); // "3.141592654"
sprintf("%.1s", "12345"); // "1"
sprintf("%.10s", "12345"); // "12345"
```

### 1.4 フラグ *\<flags>*

フラグは以下の形式を持つ。

*\<flags>* **:= (** `/[-+ 0#']/` **|** `/\=./` **) +**

| 指定 | 準拠 | 説明 |
|:--|:--|:--|
|`'-'`|標準|左寄せを意味する。既定では右寄せである。|
|`'+'`|標準|非負の数値に正号を付ける事を意味する。|
|`'#'`|標準|整数の場合、リテラルの基数を示す接頭辞を付ける。但し、値が 0 の時は接頭辞を付けない。*\<conv>* = o, x, X のそれぞれに対して "0", "0x", "0X" が接頭辞となる。<br>浮動小数点数 *\<conv>* = f, F, e, E, g, G, a, A の場合は、整数 (precision = 0) に対しても小数点を付ける (例 "123.") 事を意味する。*\<conv>* = g, G については小数末尾の 0 の連続を省略せずに全て出力する。|
|`' '`|標準 |非負の数値の前に空白を付ける事を意味する。これは出力幅が width で指定した幅を超えても必ず出力される空白である。|
|`'0'`|標準 |左側の余白を埋めるのに 0 を用いる。但し、空白と異なり 0 は符号や基数接頭辞の右側に追加される。|
|`"'"`|SUSv2|*\<conv>* = d, i, f, F, g, G の整数部で桁区切 (3桁毎の ",") を出力する事を意味する。但し、flag 0 で指定される zero padding の部分には区切は入れない。|

```javascript
// 例
sprintf("[%3d][%-3d]", 1, 1); // "[  1][1  ]"
sprintf("%d, %+d", 1, 1); // "1, +1"
sprintf("%o, %#o, %#o", 1, 1, 0); // "1, 01, 0"
sprintf("%x, %#x, %#x", 1, 1, 0); // "1, 0x1, 0"
sprintf("[%d][% d]", 1, 1); // "[1][ 1]"
sprintf("[%4d][%04d]", 1, 1); // "[   1][0001]"
sprintf("%d, %'d", 1234567, 1234567); // "1234567, 1,234,567"
```

### 1.5 位置指定子 *\<pos>*

位置指定子は以下の形式を持つ。

*\<pos>* **:=** `/\d+\$/`

整数で引数の番号を指定する。書式指定文字列の次に指定した引数の番号が 1 に対応する。

```javascript
// 例
sprintf("%3$d %2$d %1$d %2$d %3$d", 111, 222, 333); // "333 222 111 222 333"
```

### 1.6 サイズ指定子 *\<type>*

サイズ指定子で引数を解釈する時の精度を指定する。
サイズ指定子は以下の何れかである。

整数 (*\<conv>* = d, i, o, u, x, X) の時

|指定   |準拠                    |説明  |
|:------|:-----------------------|:-----|
|(既定) |標準 (int)              |double|
|`'hh'` |C99  (char)             |  8bit|
|`'h'`  |標準 (short)            | 16bit|
|`'l'`  |標準 (long)             | 32bit|
|`'ll'` |C99  (long long)        | 32bit|
|`'t'`  |C99  (ptrdiff_t)        | 32bit|
|`'z'`  |C99  (size_t)           | 32bit|
|`'I'`  |MSVC (ptrdiff_t, size_t)| 32bit|
|`'I32'`|MSVC (32bit)            | 32bit|
|`'q'`  |BSD  (64bit)            | 64bit|
|`'I64'`|MSVC (64bit)            | 64bit|
|`'j'`  |C99  (intmax_t)         |double|

 - JavaScript の整数は内部的には double の様なので指定がなければそのままである。
 - JavaScript では 64bit は正確に扱えないので 32bit を native int (ptrdiff_t, size_t, long, long long, etc.) とする。
 - JavaScript では 64bit は正確に扱えないので、明示的な 64bit 指定 (`q` `I64`) については正確な出力にならないかもしれない。

```javascript
// 例
sprintf("%x", 123456789); // "75bcd15"
sprintf("%hx", 123456789); // "cd15"
sprintf("%hhx", 123456789); // "15"
```

浮動小数点 (*\<conv>* = f, F, e, E, g, G, a, A) の時

|指定   |準拠                    |説明  |
|:------|:-----------------------|:-----|
|(既定) |標準 (double)           |double|
|`'hh'` |独自                    | float|
|`'h'`  |独自                    | float|
|`'l'`  |C99  (double)           |double|
|`'ll'` |独自                    |double|
|`'L'`  |標準 (long double)      |double|
|`'w'`  |独自                    |double|

 - JavaScript に long double はないので double で代用する。
 - hh, h, l, ll, w は本来、他の *\<conv>* で使われるサイズ指定だが、独自拡張で意味を与えている。

```javascript
// 例
sprintf("%.15g", Math.PI);  // "3.14159265358979"
sprintf("%.15hg", Math.PI); // "3.14159250259399"
```

文字・文字列 (*\<conv>* = c, C, s, S) の時

|指定  |準拠           |説明   |
|:-----|:--------------|:------|
|(既定)|標準 (既定)    |unicode|
|`'hh'`|独自           |  ascii|
|`'h'` |MSVC (char)    |  ascii|
|`'l'` |C99  (wint_t)  |unicode|
|`'w'` |MSVC (wchar_t) |unicode|

```javascript
// 例
sprintf("%c", 12354); // "あ"
sprintf("%hc", 12354); // "B"
```

## 2 (ToDo)

README: 使用例を追加する。他の実装との比較を追加する。

sprintf.js: =?, (), filters
