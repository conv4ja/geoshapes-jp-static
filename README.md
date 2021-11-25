# ABOUT

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="クリエイティブ・コモンズ・ライセンス" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/80x15.png" /></a><br />

このコンテンツは <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">クリエイティブ・コモンズ 表示 - 継承 4.0 国際 ライセンス</a>の下に提供されています。

本リポジトリは、国立情報学研究所 [Geoshapeリポジトリ](https://geoshape.ex.nii.ac.jp/city/)の提供する市町村境界データのコンテンツをより便利に利用するためのクローンリポジトリです。
[Geoshapeプロジェクト](https://geoshape.ex.nii.ac.jp/city/) で提供される平成27年時点での市町村境界データ(GeoJSONないしはTopoJSON形式)のミラーコンテンツを、現在の市町村境界の標準地域コードに対応するファイル名を付した上で `src/geojson` および `src/topojson` 配下に格納しています。

[ファイル配信サイト](#Distribution)では、各境界データを静的コンテンツとしてホストします。
ファイル単位での取得をご希望の場合はこちらもご利用ください。

なお、本リポジトリ `/src` 配下のgeojsonおよびtopojsonコンテンツは NII/CODH によりCC BY-SA 4.0 にて利用許諾されており、再利用の際は次のクレジット表記が必要となります。

`『歴史的行政区域データセットβ版』（CODH作成）, CC BY-SA 4.0`

もしくは

` Asanobu KITAMOTO, ROIS-DS Center for Open Data in the Humanities, CC BY-SA 4.0 `

なお、各コンテンツについては国土交通省の「[国土数値情報](http://nlftp.mlit.go.jp/ksj/)」をもとに作成されています。
原データの利用規約については[こちら](http://nlftp.mlit.go.jp/ksj/gml/datalist/KsjTmplt-N03.html)をご確認ください。

各種シンボリックリンク構成および `/src` 以外の各種コンテンツは [Conv4Japan](https://github.com/conv4ja)有志の手によるものです。
本リポジトリを再利用する場合には、CC BY-SA 4.0 クレジット表記に `Conv4Japan Contributors` を追記してください。

# Distribution

各シェープファイルを静的コンテンツとして配信するサービスを試験提供します。
いずれもGETリクエストのみ受け入れる擬似的なRESTエンドポイントとして振る舞います。

実験的サービスにつき、ベストエフォートかつ運営都合でのサービス停止などがある可能性にご留意ください。

* [Tanban GeoShapes API](https://geoshapes.tanban.org/api/jp/)

#### [Claims for users from countries which have GDPR or its compatible data protection law series]

THIS IS A EXPERIMENTAL SERVICE ENDPOINT FOR COMMUNITIES OF PEOPLE IN JAPAN.
DO NOT ACCESS THIS ENDPOINT FROM OUTSIDE JAPAN. (sorry, that's limited at now)

YOU MUST DISCLAIM US (Conv4Japan Contributors) FROM ANY TYPE OF RISK, COST, DAMAGE, DUTY OR CHARGE WHICH IS PROBABLY ACCLAIMED BY YOU OR YOUR ORGANIZATION.


## APIリソースについて

* すべてのリソースについて、GETリクエストのみ受け付けます。
* github.ioではMIMEヘッダはサポートしません。リソースのMIMEタイプが正常に解釈されない場合があります。

| リソース | 説明 | レスポンスの例 | 
| --- | --- | --- |
| /health | API稼働状況を取得します | status only |
| /version | APIバージョンを取得します | {"version": "0.1.1", "language":"ja"} |
| /prefecture/list/name | 都道府県一覧を取得します | { "北海道": "01", ... } |
| /prefecture/list/code | 都道府県一覧を取得します | { "01": "北海道", ... } |
| /city/list/name/all | 市町村一覧を取得します | { "小樽市":"01101", ..., "八重山町":"47483" } |
| /city/list/name/:pid | 都道府県内の市町村一覧を取得します | { "小樽市":"01101", ... } |
| /city/list/code/all | 市町村一覧を取得します | { "01101":"小樽市", ..., "47483":"八重山町" } |
| /city/list/code/:pid | 都道府県内の市町村一覧を取得します | { "01101":"小樽市", ... } |
| /city/info/:cid | 標準地域コードから市町村メタデータを取得します | {"prefName":"埼玉県","cityName":"川越市","cityCode":"11201","id":"gci:11201A1968"} |
| /city/info/:p/:c | 市町村名から市町村メタデータを取得します | {"prefName":"青森県","cityName":"弘前市","cityCode":"02202","id":"gci:02202A1968"} |
| /city/info/:pid/:c | 市町村名から市町村メタデータを取得します | {"prefName":"青森県","cityName":"弘前市","cityCode":"02202","id":"gci:02202A1968"} |
| /city/info/:pid/:cid | 市町村コードから市町村メタデータを取得します | {"prefName":"青森県","cityName":"弘前市","cityCode":"02202","id":"gci:02202A1968"} |
| /:fmt/:cid | 市町村コードで境界データを取得します | (data body) |

[凡例]

| 名称 | 説明 | 値の例 |
| --- | --- | --- |
| :fmt | 境界データフォーマット | topojson |
| :pid | 都道府県コード | 3, 08, 31 |
| :p | 都道府県名 | "宮崎県" |
| :cid | 5桁表記の標準地域コード | 01105, 12204 |
| :c | 市町村名 | "海老原市" |


# 謝辞

行政区域データ・セットを提供いただきましたNII北本研究室に、感謝いたします。


# 作業者一覧

Nomura Suzume <suzume315[at]g00.g1e.org>
