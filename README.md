# rbps と rgps

## rbps

### 概要
FreeBSDでport(s)を検索するソフトウェアにpsearchというのがありますが、それをrubyで書いたものです。
はい、車輪の再発明です。それも劣化版の。
名前は**R**u**B**y **P**ort(s) **S**earchのつもり。

### 使い方

~~~
ruby rbps.rb [option] PATTERN
~~~

#### オプション

##### l
詳細な説明も表示します。

え、psearchと比べるとオプションが少ないって？だから劣化版です。
あとバージョンとヘルプにも対応しているかと思いますが、rubyのライブラリの機能ですね。

## rgps

### 概要
rbpsのGUI版です。以上。まあ、見れば分かるでしょう。
名前は**R**uby **G**TK **P**ort(s) **S**earchのつもり。

### 使い方

~~~
ruby rgps.rb
~~~

## 注意
FreeBSDでport入れていて、さらにrubyとGTKが入ってないと動きません、きっと。
どちらも文字列を入力してportを検索し、その概要が見られるソフトウェアですが、私が文字列と認めないものではまともに動作しない可能性があります。

/usr/portsにINDEX-[major version number]というファイルがないと動作しません。INDEX-云々ファイルは/usr/portsにcdしてmake index（sudoも必要でしょう）すれば、作成されます。

## おまけ
FreeBSDでportを詳細な説明も含めてぼーっと眺めたいと思って作ったソフトウェアです。そういう要望をお持ちの方には役立つかと。（そういう要望をお持ちの方にしか役立ちません。）
